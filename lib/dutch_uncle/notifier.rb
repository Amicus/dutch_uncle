module DutchUncle
  class Notifier

    def self.configure(notifier_config)
      Honeybadger.configure do |config|
        config.api_key = notifier_config['api_key']
        config.environment_name = notifier_config['environment']
      end
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