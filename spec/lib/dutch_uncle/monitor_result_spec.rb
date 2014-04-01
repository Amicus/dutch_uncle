require 'spec_helper'


module DutchUncle
  describe MonitorResult do

    describe "#initialize" do
      subject do 
        MonitorResult.new({
          passed: true,
          name: 'name',
          query: 'query',
          failed_points: nil,
          run_at: Time.now,
        })
      end

      its(:passed) { should be_true }
    end    
  end
end