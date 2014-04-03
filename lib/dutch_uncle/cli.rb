require 'yaml'

module DutchUncle
  class Cli
    attr_reader :influxdb, :server
    attr_accessor :config, :monitors
    
    def initialize(config_path)
      self.config = YAML.load_file(File.expand_path(config_path))
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
      host      = influxdb_config['hosts'] || influxdb_config['host'] || influxdb_config[:host] || influxdb_config[:hosts]
      @influxdb = InfluxDB::Client.new(host, port, username, password, database)
    end

    def configure_notifier
      notifier_config = config["notifier"] || config[:notifier]
      Notifier.configure(notifier_config)
    end

  end

end
