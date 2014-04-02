module DutchUncle
  class Notifier

    def self.configure(config)
      Honeybadger.configure { |config| config.api_key = config['api_key'] }
    end

    def notify!(monitor_result)
      Honeybadger.notify({
        error_class: monitor_result.name,
        error_message: monitor_result.message,
        parameters: monitor_result.failed_points.first || {}
      })
    end

  end
end