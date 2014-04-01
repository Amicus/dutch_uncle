require 'spec_helper'


module DutchUncle
  describe Server do

    describe "#initialzie" do
      let(:alerter) { Alerter.new }
      let(:influxdb) { InfluxDB::Client.new }

      subject { Server.new(influxdb, alerter) }

      its(:alerter) { should == alerter }
      its(:influxdb) { should == influxdb }

    end


  end
end