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
        points = influxdb.query monitor_config['query'] + "AND time > now() - 10m"

        if points.values.detect(&:present?)
          alerter.notify!("#{monitor_name} failed")
        end
      end

    end



  end
end