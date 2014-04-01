module DutchUncle

  class MonitorResult
    ATTRIBUTES = [:passed, :name, :query, :failed_points, :run_at]
    attr_accessor *ATTRIBUTES
    
    def initialize(result_attributes)
      ATTRIBUTES.each do |attr|
        self.send(:"#{attr}=", result_attributes[attr])
      end
    end

  end
end

