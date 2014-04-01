require 'spec_helper'


module DutchUncle
  describe Server do

    let(:alerter) { Alerter.new }
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
    let(:server) { Server.new(influxdb, alerter: alerter, monitors: monitors) }

    describe "#initialzie" do
      subject { server }

      its(:alerter) { should == alerter }
      its(:influxdb) { should == influxdb }
    end

    describe "#check_monitors" do
      subject { server.check_monitors }

      context "when there is a point that should alert" do
        before do
          influxdb.write_point(series_name, value: 5001, controller: 'fake_controller', server: 'fake_server')
        end

        it "triggers notify on alerter" do
          expect(alerter).to receive(:notify!).once
          subject
        end


      end
    end


  end
end