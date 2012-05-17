require 'rubygems'
require 'bundler/setup'

require 'pakyow'
require 'sequel'

module PakyowApplication
  class Application < Pakyow::Application
    config.app.default_environment = :development
  
    configure(:development) do
      # establish the database connection

      # SQLite (haversine query doesn't work)
      # ::DB = Sequel.connect('sqlite://development.db') unless defined?(DB)

      # MySQL
      ::DB = Sequel.connect("mysql://root@localhost/lirc") unless defined?(DB)
    end
    
    routes do
    end
    
    middleware do
    end
  end
end
