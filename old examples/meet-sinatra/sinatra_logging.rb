require 'sinatra'
require 'sequel'
require 'logger'
class MyApp < Sinatra::Application
  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true

    Dir.mkdir('logs') unless File.exist?('logs')

    $logger = Logger.new('logs/common.log','weekly')
    $logger.level = Logger::WARN

    # Spit stdout and stderr to a file during production
    # in case something goes wrong
    $stdout.reopen("logs/output.log", "w")
    $stdout.sync = true
    $stderr.reopen($stdout)
  end

  configure :development do
    $logger = Logger.new(STDOUT)
  end
end

# Log all DB commands that take more than 0.2s
DB = Sequel.postgres 'mydb', user:'dbuser', password:'dbpass', host:'localhost'
DB << "SET CLIENT_ENCODING TO 'UTF8';"
DB.loggers << $logger if $logger
DB.log_warn_duration = 0.2
