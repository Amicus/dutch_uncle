module DutchUncle
  class Checker

    attr_reader :name, :query, :influxdb, :heartbeat
    attr_accessor :last_run

    def initialize(influxdb, name, config)
      @influxdb = influxdb
      @name = name
      @query = config[:query] || config['query']
      @heartbeat = config[:heartbeat] || config['heartbeat']
      @last_run = Time.now - 5*60 #should be Time.now - 5.minutes - no rails here
    end

    def check
      query = query_with_time
      debug("checking: #{query}")
      write_check_to_influx(query)
      points = influxdb.query(query)
      passed = passed?(points)
      failed_points = flatten_points(points)
      self.last_run = Time.now
      write_failure_to_influx(query, failed_points) unless passed
      MonitorResult.new({
        passed: passed,
        name: name,
        query: query,
        failed_points: failed_points,
        run_at: Time.now,
      })
    end

    private

    def write_check_to_influx(query)
      debug("writing dutch_uncle.checks")
      data = {
        name: name,
        query: query
      }
      influxdb.write_point('dutch_uncle.checks', data)
    end

    def write_failure_to_influx(query, failed_points)
      debug("writing dutch_uncle.failures")
      data = {
        query: query,
        name: name,
        points: failed_points
      }
      influxdb.write_point('dutch_uncle.failures', data)
    end

    def passed?(points_hash)
      if !points_hash.detect {|series_name, points| !points.empty? } && !heartbeat
        true
      elsif points_hash.detect {|series_name, points| !points.empty? } && heartbeat
        true
      end
    end

    def flatten_points(points_hash)
      points_hash.map {|series_name,points| points.map {|point| point.merge('series_name' => series_name)} }.flatten
    end

    def query_with_time
      joiner = query.match(/where/i) ? 'AND' : 'WHERE'
      "#{query} #{joiner} time > #{last_run.to_i}s"
    end

    def debug(txt)
      DutchUncle.logger.debug("DutchUncle::Checker(#{name}) - #{txt}")
    end

  end

end

