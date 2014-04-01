require 'spec_helper'


module DutchUncle
  describe Server do

    describe "#initialzie" do
      let(:alerter) { Alerter.new }
      let(:influxdb) { InfluxDB::Client.new }
      let(:monitors) do
        {
          long_request: {
            query: 'select * from brief-controller where value > 5000',
            critical: false
          }
        }
      end

      subject { Server.new(influxdb, alerter: alerter, monitors: monitors) }

      its(:alerter) { should == alerter }
      its(:influxdb) { should == influxdb }

    end


  end
end