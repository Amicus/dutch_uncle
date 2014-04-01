TEST_CLIENT = InfluxDB::Client.new

DATABASE = "dutch_uncle_test"

RSpec.configure do |config|
  config.before do
    if TEST_CLIENT.get_database_list.map {|l| l['name'] }.include?(DATABASE)
      TEST_CLIENT.delete_database(DATABASE)
    end
    TEST_CLIENT.create_database(DATABASE)
  end
end