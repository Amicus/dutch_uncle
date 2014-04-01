module DutchUncle
  class Checker

    attr_reader :name, :config, :influxdb
    attr_accessor :last_run

    def initialize(influxdb, name, config)
      @influxdb = influxdb
      @name = name
      @config = config
      @last_run = Time.now - 5*60 #should be Time.now - 5.minutes - no rails here
    end

    def check
      points = influxdb.query("#{config[:query]} AND time > #{last_run.to_i}")
      self.last_run = Time.now

      points.each_pair do |series_name, points|
        return points.empty?
      end
    end
  end
end