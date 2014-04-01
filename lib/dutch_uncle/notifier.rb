module DutchUncle
  class Notifier

    def notify!(monitor_result)
      message = "#{monitor_result.name} failed at #{monitor_result.run_at}"
      Honeybadger.notify(monitor_result.name, message, monitor_result.failed_points.first || {})
    end

  end
end