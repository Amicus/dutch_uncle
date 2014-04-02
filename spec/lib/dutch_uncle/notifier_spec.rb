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
          expect(Honeybadger).to receive(:notify).with({
            error_class: monitor_result.name,
            error_message: an_instance_of(String),
            parameters: {}
          })
          subject
        end
      end
    end
  end
end