module DutchUncle
  class Server

    attr_accessor :influxdb, :alerter

    def initialize(influxdb, alerter)
      @influxdb = influxdb
      @alerter = alerter
    end

  end
end