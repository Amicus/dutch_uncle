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
      query = "#{config['query']} AND time > #{last_run.to_i}"
      points = influxdb.query(query)
      self.last_run = Time.now
      MonitorResult.new({
        passed: passed?(points),
        name: name,
        query: query,
        failed_points: flatten_points(points),
        run_at: Time.now,
      })
    end

    private

    def passed?(points_hash)
      if !points_hash.detect {|series_name, points| !points.empty? } && !config[:heartbeat]
        true
      elsif points_hash.detect {|series_name, points| !points.empty? } && config[:heartbeat]
        true
      end
    end

    def flatten_points(points_hash)
      points_hash.map {|series_name,points| points.map {|point| point.merge('series_name' => series_name)} }.flatten
    end

  end

end

