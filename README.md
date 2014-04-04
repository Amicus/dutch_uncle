# DutchUncle

DutchUncle runs checks against data in influxdb and tells honeybadger to send out an alert if one of these checks fails. This gem is currently being used in the dutch_uncle_sinatra application. We have two instances of the sinatra app: one for staging and one for prod. They are checking data from the amicus_staging and amicus_production databases in influx. 

DutchUncle is watching.

## Installation

Add this line to your application's Gemfile:

    gem 'dutch_uncle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dutch_uncle

##Usage

To run localy, start an instance of influxdb, add a config file (see /spec/support/config.yaml for an example), and run bundle exec dutch_uncle run . DutchUncle looks for a config file in the application's root directory by default, but a different directory can be specified with the --config option.

To update/build you need to add heroku remotes:
staging: git@heroku.com:dutch-uncle-sinatra-staging.git
production: git@heroku.com:dutch-uncle-sinatra.git

after adding the remote, 'run git push <remote name> master' to build


##How it works

The Server will check influxdb at the interval specified in SERVER::LOOP_INTERVAL for every monitor specified in the configuration file. If any of these checks fail, a notification with info about the failure is sent to Honeybadger, which will then send out alerts to the team. All checks and failures are also written to influx with the series names dutch_uncle.checks and dutch_uncle.failures. 

There are currently two types of monitors: heartbeat and non-heartbeat. Heartbeat monitors will fail the check if their query does not return a point, non-heartbeat monitors fail the check if their query returns a point. 

An example monitor:
'''
  messages_processing:  #the name of the monitor
    query: 'select * from donaghy.pingWorker'  #the query sent to influxdb
    heartbeat: true   #if true, the check fails if the query doesn't return data. if false or not present, the check fails if data is returned
'''

We are also monitoring DutchUncle's uptime by hitting /monitor/ping with Honeybadger.

##If something blows up
Check the heroku app logs by running 'heroku logs'. You may need to specify the app name with the --app option when running this command.
Check influxdb. You can query for the dutch_uncle.checks and dutch_uncle.failures time series and get info, at the very least about when things stopped working. 



