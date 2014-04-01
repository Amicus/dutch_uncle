require 'spec_helper'


module DutchUncle
  describe Notifier do
    let(:notifier) { Notifier.new }
    let(:monitor_result) do
      MonitorResult.new({
        name: 'storage_used',
        passed: false,
        failed_points: [],
      })
    end

    describe "#notify!" do
      subject { notifier.notify!(monitor_result) }

      context "when we need to notify about something" do

        it "sends the message to honeybadger with info about the alert" do
          expect(Honeybadger).to receive(:notify).with(monitor_result.name, an_instance_of(String), {})
          subject
        end
      end
    end
  end
end