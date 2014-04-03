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
    let(:short_loop_interval) { 0.001 }

    describe "#initialize" do
      subject { server }

      its(:notifier) { should == notifier }
      its(:influxdb) { should == influxdb }
    end

    describe "#start" do
      subject { server.start }

      before do
        server.stub(:loop_interval).and_return(short_loop_interval)
      end

      after do
        server.stop
      end

      it "checks the monitors" do
        expect(server).to receive(:check_monitors).at_least(2).times
        subject
        sleep(short_loop_interval*3)
      end

    end

    describe "#stop" do

      subject { server.stop }

      before do
        server.stub(:loop_interval).and_return(short_loop_interval)
        server.start
      end

      it "sets stopped to true" do
        subject
        expect(server.stopped).to be_true
      end

      it "stops the checking" do
        subject
        expect(server).to_not receive(:check_monitors)
        sleep(short_loop_interval)
      end

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