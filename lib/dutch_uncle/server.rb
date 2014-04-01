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
        points = influxdb.query("#{monitor_config[:query]} AND time > now() - 10m")

        points.each_pair do |series_name, points|
          unless points.empty?
            alerter.notify!("#{monitor_name} failed on series #{series_name}")
          end
        end
      end

    end



  end
end