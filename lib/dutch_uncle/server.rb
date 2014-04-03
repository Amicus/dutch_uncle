module DutchUncle
  class Server

    LOOP_INTERVAL = 30 #seconds

    attr_accessor :influxdb, :notifier, :monitors, :loop_thread, :stopped, :checkers

    def initialize(influxdb, opts = {})
      @influxdb = influxdb
      @notifier = Notifier.new
      @monitors = opts[:monitors]
      @checkers = monitors.map {|monitor_name, monitor_config| Checker.new(influxdb, monitor_name, monitor_config) }
    end

    def start
      return loop_thread if loop_thread

      self.loop_thread = Thread.new do
        loop do
          break if stopped?
          check_monitors
          sleep(loop_interval)
        end
      end
    end

    def stop
      self.stopped = true
    end

    def stopped?
      self.stopped
    end

    def check_monitors
      checkers.each do |checker|
        break if stopped?
        begin
          monitor_result = checker.check
          notifier.notify!(monitor_result) unless monitor_result.passed?
        rescue StandardError => e
          message = "#{checker.name} FAILED TO PROCESS due to #{e.class}"
          monitor_result = MonitorResult.new(passed: false, message: message, failed_points: [e])
          notifier.notify!(monitor_result)
        end
      end
    end

  private
    def loop_interval
      LOOP_INTERVAL
    end

  end
end