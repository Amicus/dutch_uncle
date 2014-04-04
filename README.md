# DutchUncle

DutchUncle is a monitoring and notification system for InfluxDB and Honeybadger. It runs checks against data in InfluxDB and notifies Honeybadger if any of these checks fail.

DutchUncle is watching.

## Installation

Add this line to your application's Gemfile:

    gem 'dutch_uncle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dutch_uncle

##Usage

To run locally, start an instance of influxdb, add a config file (see /spec/support/config.yaml for an example), and run bundle exec dutch\_uncle run . DutchUncle looks for a config file in the application's root directory by default, but a different directory can be specified with the --config option.

##How it works

The Server will check influxdb at the interval defined in SERVER::LOOP\_INTERVAL for every monitor specified in the configuration file. If any of these checks fail, a notification with information about the failure is sent to Honeybadger, which will then send out alerts if configured to do so. All checks and failures are also written to influx with the series names dutch_uncle.checks and dutch_uncle.failures. 

There are currently two types of monitors: heartbeat and non-heartbeat. Heartbeat monitors will fail the check if their query does not return a point, non-heartbeat monitors fail the check if their query returns a point. 

An example monitor:
  ---
    messages_processing:  #the name of the monitor
      query: 'select * from donaghy.pingWorker'  #the query sent to influxdb
      heartbeat: true   #if true, the check fails if the query doesn't return data. if false or not present, the check fails if data is returned
  ---

##If something blows up
Check the logs. DutchUncle writes to STDOUT with information about what it's doing.
Check influxdb. You can query for the dutch_uncle.checks and dutch_uncle.failures time series to get information.

