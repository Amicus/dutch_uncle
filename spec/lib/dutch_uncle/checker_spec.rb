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

    describe "#initialize" do
      subject { checker }
      let(:config) { {'query' => 'query', 'heartbeat' => true} }

      it "accepts a string for query and heartbeat" do
        expect(subject.query).to eq('query')
        expect(subject.heartbeat).to be_true
      end
    end

    describe "#check" do
      subject { checker.check }

      its(:name) { should eq('test-checker') }
      its(:query) { should match /#{Regexp.escape(query)} AND time > \d+/}
      its(:run_at) { should be_a(Time) }

      it "uses the last_run in the query for the next check" do
        run_at = subject.run_at
        expect(checker.check.query).to match(/time > #{run_at.to_i}/)
      end

      it "writes to influx when making a check" do
        expect(influxdb.query("select * from #{subject.name}")).not_to be_empty
      end

      shared_examples "non-heartbeat" do
        context "when a point exists" do
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

      context "with a query with a WHERE clause" do
        it_behaves_like "non-heartbeat"
      end

      context "without a where clause in the query" do
        let(:query) { "select * from #{series_name}" }
        it_behaves_like "non-heartbeat"
      end

      context "with a heartbeat config" do
        let(:config) do
           {
            query: query,
            critical: false,
            heartbeat: true,
          }
        end

        it "passes when there is a point" do
          influxdb.write_point(series_name, value: 5001, controller: 'fake_controller', server: 'fake_server')
          expect(subject.passed).to be_true
        end

        it "fails when there is not a point" do
          expect(subject.passed).to be_false
        end
      end

    end
  end
end