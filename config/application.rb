require 'rubygems'
require 'bundler/setup'

require 'pakyow'
require 'sequel'
require 'twitter'
require 'json'

module PakyowApplication
  class Application < Pakyow::Application
    config.app.default_environment = :development
  
    configure(:development) do
      require 'pp'
      
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
      handler :bad_request, 400 do
        response.body << {errors: @errors}.to_json
        app.halt!
      end

      handler :not_found, 404 do
      end

      handler :unauthorized, 401 do
      end

      handler :forbidden, 403 do
      end

      # Expects: twitter_username
      # Responds With: user
      post '/users' do
        u_data = {twitter_username: request.params[:twitter_username]}
        
        unless u = User.first(u_data)
          u = User.new(u_data)

          @errors = u.errors and app.invoke_handler! :bad_request unless u.valid?
          u.save
        end

        response.body << u.to_hash.to_json
        app.halt!
      end

      # Expects: twitter_username
      # Responds With: user
      post '/users/auth' do
        u = User.first(twitter_username: request.params[:twitter_username])
        app.invoke_handler! :unauthorized unless u

        response.body << u.to_hash.to_json
        app.halt!
      end

      # Expects: text, location(lat/lng), access_token
      # Responds With: message
      post '/messages' do
        token = request.params[:access_token]
        app.invoke_handler! :unauthorized unless u = User.first(access_token: token)

        lat = request.params[:lat]
        lng = request.params[:lng]

        l = Location.new(lat: lat, lng: lng)
        
        @errors = l.errors and app.invoke_handler! :bad_request unless l.valid?
        l.save

        text = request.params[:text]

        m = Message.new(text: text, user: u, location: l)

        @errors = m.errors and app.invoke_handler! :bad_request unless m.valid?
        m.save

        response.body << m.to_hash.to_json
        app.halt!
      end

      # Expects: location (lat/lng), radius (in miles)
      # Responds With: messages
      get '/messages' do
        lat = request.params[:lat]
        lng = request.params[:lng]
        rad = request.params[:rad]

        @errors = [] and app.invoke_handler! :bad_request unless lat && lng && rad

        ms = Message.proximity(lat, lng, rad)
        response.body << ms.map{|m| m.to_hash}.to_json
        app.halt!
      end
    end
    
    middleware do
    end
  end
end
