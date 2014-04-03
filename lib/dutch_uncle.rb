require "dutch_uncle/version"
require 'logger'

module DutchUncle
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end
end

require 'influxdb'
require 'honeybadger'

require 'dutch_uncle/server'
require 'dutch_uncle/notifier'
require 'dutch_uncle/checker'
require 'dutch_uncle/monitor_result'
require 'dutch_uncle/runner'
