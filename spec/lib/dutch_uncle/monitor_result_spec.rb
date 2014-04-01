require 'spec_helper'


module DutchUncle
  describe MonitorResult do
    let(:monitor_result) do
       MonitorResult.new({
          passed: true,
          name: 'name',
          query: 'query',
          failed_points: nil,
          message: 'a custom message',
          run_at: Time.now,
        })
    end

    describe "#passed?" do
      subject { monitor_result.passed? }

      it "equals passed" do
        expect(subject).to eq(monitor_result.passed)
      end
    end

    describe "#initialize" do
      subject { monitor_result }

      its(:passed) { should be_true }
    end    

    describe "#message" do
      subject { monitor_result.message }
      it "is custom message when passed in" do
        expect(subject).to eq(monitor_result.message)
      end

      it "is default message when message not assigned" do
        monitor_result.message = nil
        expect(subject).to match(/#{Regexp.escape(monitor_result.name)} failed at \d/)
      end

    end

  end
end