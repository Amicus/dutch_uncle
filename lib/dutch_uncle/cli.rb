require 'yaml'
require 'pry'

module DutchUncle
  class Cli
    attr_reader :influxdb, :notifier, :server
    attr_accessor :config, :monitors

#have it default to using a config in a directory and also take command line args
#expand config file to have everything necessary
#need to figure that out path
    
    def initialize(config_path)
      self.config = YAML.load_file(File.expand_path(config_path))
      setup_configs
      @server = Server.new(influxdb, monitors: monitors)
    end

    def start
      puts 'calling start'
      server.start
    end

    def stop
      server.stop
    end

    private
    
    def setup_configs
      configure_influxdb
      configure_notifier
      setup_monitors
    end

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

    def setup_monitors
      self.monitors = config["monitors"]
    end

  end

end

