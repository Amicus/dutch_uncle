module DutchUncle
  class Server

    attr_accessor :influxdb, :notifier, :monitors

    def initialize(influxdb, opts = {})
      @influxdb = influxdb
      @notifier = opts[:notifier]
      @monitors = opts[:monitors]
    end

    def check_monitors
      monitors.each_pair do |monitor_name, monitor_config|
        monitor_result = Checker.new(influxdb, monitor_name, monitor_config).check
        notifier.notify!(monitor_result)
      end
    end
  end
end