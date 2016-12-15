require 'pry'

class Db < Thor
  include Thor::Actions

  desc 'create', 'create DB'
  def create
    content = YAML.load_file('config/database.yml')[ENV['RACK_ENV']]

    user = content['user']
    dbname = content['database']

    run("createdb --user=#{user} #{dbname}")
  end
end
