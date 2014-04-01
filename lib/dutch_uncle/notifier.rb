module DutchUncle
  class Notifier

    def notify!(monitor_result)
      message = monitor_result.message
      Honeybadger.notify(monitor_result.name, message, monitor_result.failed_points.first || {})
    end

  end
end