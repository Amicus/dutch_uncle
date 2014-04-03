require 'spec_helper'

module DutchUncle
  describe Cli do
    let(:config_path) { 'spec/support/config.yaml' }
    let(:config) { YAML.load_file(config_path) }
    subject { Cli.new(config_path) }
    
    describe "#initialize" do

      it "configures influxdb correctly" do
        expect { subject.influxdb.write_point('test_point', value: 1) }.to_not raise_error
      end

      it "sets up monitors" do
        expect(subject.server.monitors).to eq(config["monitors"])
      end

      it "configures a notifier" do
        Notifier.should_receive(:configure).with(config["notifier"])
        subject
      end

    end

    describe "#start" do

      it "starts the server" do
        expect(subject.server).to receive(:start)
        subject.start
      end
    end

    describe "#stop" do 

      it "stops the server" do
        expect(subject.server).to receive(:stop)
        subject.stop
      end
    end

  end
end