require 'spec_helper'


module DutchUncle
  describe Alerter do

    let(:series_name) { 'brief-controller' }
    let(:params)      { Hash.new(controller: 'fake_controller', server: 'fake_server') }
    
    let(:alerter) { Alerter.new }

    describe "#notify!" do
      subject { alerter.notify!(series_name, 'message', params) }

      context "when we need to alert of something" do

        it "sends the message to honeybadger with info about the alert" do
          expect(Honeybadger).to receive(:notify).with(series_name, 'message', params)
          subject
        end
      end
    end
  end
end