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
      # if defined?(JRUBY_VERSION)
      #   ::DB = Sequel.connect('jdbc:sqlite:development.db') unless defined?(DB)
      # else
      #   ::DB = Sequel.connect('sqlite://development.db') unless defined?(DB)
      # end

      # MySQL
      ::DB = Sequel.connect("mysql://root@localhost/lirc") unless defined?(DB)
    end
    
    routes do
    end
    
    middleware do
    end
  end
end
