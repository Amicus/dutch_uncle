module DutchUncle
  class Server

    attr_accessor :influxdb, :alerter, :monitors

    def initialize(influxdb, opts = {})
      @influxdb = influxdb
      @alerter = opts[:alerter]
      @monitors = opts[:monitors]
    end

    def check_monitors
      monitors.each_pair do |monitor_name, monitor_config|
        unless Checker.new(influxdb, monitor_name, monitor_config).check
          alerter.notify!(monitor_name, "#{monitor_name} has failed")
        end
      end
    end
  end
end