require 'yaml'
require 'erb'

module DutchUncle
  class Runner
    attr_reader :influxdb, :server
    attr_accessor :config, :monitors
    
    def initialize(config_path)
      self.config = YAML.load(ERB.new(File.read(File.expand_path(config_path))).result)
      configure_influxdb
      configure_notifier
      @server = Server.new(influxdb, monitors: config["monitors"])
    end

    def start
      server.start
    end

    def stop
      server.stop
    end

    private

    def configure_influxdb
      influxdb_config = self.config["influxdb"] || influxdb_config[:influxdb]
      username  = influxdb_config["username"] || influxdb_config[:username]
      password  = influxdb_config["password"] || influxdb_config[:password]
      database  = influxdb_config["database"] || influxdb_config[:database]
      port      = influxdb_config["port"]  || influxdb_config[:port]
      hosts     = influxdb_config['hosts'] || influxdb_config['host'] || influxdb_config[:host] || influxdb_config[:hosts]
      @influxdb = InfluxDB::Client.new(database, hosts: hosts, port: port, username: username, password: password)
    end

    def configure_notifier
      notifier_config = config["notifier"] || config[:notifier]
      Notifier.configure(notifier_config)
    end

  end

end

