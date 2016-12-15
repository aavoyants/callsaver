require 'sinatra'
require 'pg'
require 'yaml'

env = ENV['RACK_ENV'] || 'development'

db_config = YAML.load_file('config/database.yml')[env]
CONNECTION = PG.connect(dbname: db_config['database'], user: db_config['user'])

CONNECTION.exec('CREATE EXTENSION if not exists "uuid-ossp";')
CONNECTION.exec('CREATE TABLE IF NOT exists requests(id uuid DEFAULT uuid_generate_v1(), json json);')

post '/filer' do
  content_type 'application/json'

  begin
    CONNECTION.exec("insert into requests (id, json) VALUES (DEFAULT, '#{params.to_json}' );")
    results = CONNECTION.exec("SELECT id FROM requests LIMIT 1 OFFSET (SELECT COUNT(*) FROM requests) - 1;")
    { uuid: results.first['id'] }.to_json
  rescue => e
    halt 500
  end
end
