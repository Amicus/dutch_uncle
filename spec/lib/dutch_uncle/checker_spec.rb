require 'spec_helper'


module DutchUncle
  describe Checker do

    let(:influxdb) { INFLUX_CLIENT }
    let(:series_name) { 'brief-controller' }

    let(:config) do
      {
        query: "select * from #{series_name} where value > 5000",
        critical: false
      }
    end
    let(:checker) { Checker.new(influxdb, 'test-checker', config) }

    describe "#check" do
      subject { checker.check }

      context "when there is a point that should alert" do
        before do
          influxdb.write_point(series_name, value: 5001, controller: 'fake_controller', server: 'fake_server')
        end

        it { should be_false }
      end

      context "when there is no point that should alert" do
        it { should be_true }
      end
    end


  end
end