class App < Thor
  include Thor::Actions

  def self.source_root
    File.join(File.dirname(__FILE__), 'app')
  end

  desc 'setup', 'Setup development environment'
  method_option 'db-name', type: :string,  aliases: '-d', banner: 'Database name'
  method_option 'db-user', type: :string,  aliases: '-u', banner: 'Database username'
  method_option 'db-pass', type: :string,  aliases: '-p', banner: 'Database password'
  method_option 'skip-db', type: :boolean, aliases: '-D', banner: 'Skip database.yml'
  method_option 'force',   type: :boolean, aliases: '-F', banner: 'Overwrite files, if exist'
  def setup
    create_database_yml unless options['skip-db']
  end

private

  def create_database_yml
    say('Generating database.yml')

    @db_name = options['db-name'] || ask('* Database name:', :green, default: 'p1')
    @db_user = options['db-user'] || ask('* Database username:', :green, default: 'rails')
    @db_pass = options['db-pass'] || ask('* Database password:', :green, default: '')

    config = {}
    config = { force: true } if options['force']

    template('database.yml.erb', 'config/database.yml', config)
    puts
  end
end
