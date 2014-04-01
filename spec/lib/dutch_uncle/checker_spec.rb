require 'spec_helper'


module DutchUncle
  describe Checker do

    let(:influxdb) { INFLUX_CLIENT }
    let(:series_name) { 'brief-controller' }
    let(:query) { "select * from #{series_name} where value > 5000" }

    let(:config) do
      {
        query: query,
        critical: false
      }
    end
    let(:checker) { Checker.new(influxdb, 'test-checker', config) }

    describe "#check" do
      subject { checker.check }

      its(:name) { should eq('test-checker') }
      its(:query) { should match /#{Regexp.escape(query)} AND time > \d+/}
      its(:run_at) { should be_a(Time) }

      context "when there is a point that fails" do
        before do
          influxdb.write_point(series_name, value: 5001, controller: 'fake_controller', server: 'fake_server')
        end

        its(:passed) { should be_false }

        it "assigns series name to failed_points" do
          expect(subject.failed_points.first['series_name']).to eq(series_name)
        end
      end

      context "when there is no point that should alert" do
        its(:passed) { should be_true }
        its(:failed_points) { should be_empty }
      end
    end
  end
end