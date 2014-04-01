
DATABASE = "dutch_uncle_test"
INFLUX_CLIENT = InfluxDB::Client.new(DATABASE)


RSpec.configure do |config|
  config.before do
    if INFLUX_CLIENT.get_database_list.map {|l| l['name'] }.include?(DATABASE)
      INFLUX_CLIENT.delete_database(DATABASE)
    end
    INFLUX_CLIENT.create_database(DATABASE)
  end
end