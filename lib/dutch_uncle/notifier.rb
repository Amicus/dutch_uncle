module DutchUncle
  class Notifier

    def notify!(monitor_result)
      Honeybadger.notify({
        error_class: monitor_result.name,
        error_message: monitor_result.message,
        parameters: monitor_result.failed_points.first || {}
      })
    end

  end
end