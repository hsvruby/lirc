# The model for a Location
#
# FIELDS
#   primary_key :id
#   
#   Float :lat
#   Float :lng
#   
#   String :foursquare_venue_id
#   
#   DateTime :created_at
#   DateTime :updated_at

require 'app/lib/models/message'

class Location < Sequel::Model(:locations)
  plugin :validation_helpers

  one_to_many :messages, :class => Message
end
