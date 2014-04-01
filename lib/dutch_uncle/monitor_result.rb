module DutchUncle

  class MonitorResult
    ATTRIBUTES = [:passed, :name, :query, :failed_points, :run_at, :message]
    attr_accessor *ATTRIBUTES
    
    def initialize(result_attributes)
      ATTRIBUTES.each do |attr|
        self.send(:"#{attr}=", result_attributes[attr])
      end
    end

    def passed?
      self.passed
    end

    def message
      @message || "#{name} failed at #{run_at}"
    end

  end
end

