require 'spec_helper'


module DutchUncle
  describe Server do

    let(:notifier) { server.notifier }
    let(:influxdb) { INFLUX_CLIENT }

    let(:series_name) { 'brief-controller' }

    let(:monitors) do
      {
          long_request: {
              query: "select * from #{series_name} where value > 5000",
              critical: false
          }
      }
    end
    let(:server) { Server.new(influxdb, monitors: monitors) }

    describe "#initialzie" do
      subject { server }

      its(:notifier) { should == notifier }
      its(:influxdb) { should == influxdb }
    end

    describe "#check_monitors" do
      subject { server.check_monitors }

      let(:monitor_result) do
        MonitorResult.new({
          passed: true
        })
      end

      context "when checker passes" do
        before do
          Checker.any_instance.stub(:check).and_return(monitor_result)
        end

        it "does not trigger notify on notifier" do
          expect(notifier).to_not receive(:notify!)
          subject
        end
      end

      context "when checker fails" do
        before do
          monitor_result.passed = false
          Checker.any_instance.stub(:check).and_return(monitor_result)
        end

        it "triggers notify on notifier" do
          expect(notifier).to receive(:notify!).once
          subject
        end
      end

      context "when checker raises" do
        before do
          Checker.any_instance.stub(:check).and_raise "Badness!"
        end
        #TODO: better tests of what is sent to notifier
        it "triggers notify on notifier" do
          expect(notifier).to receive(:notify!).once
          subject
        end
      end
    end
  end
end