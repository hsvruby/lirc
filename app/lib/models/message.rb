# The model for a Message
#
# FIELDS
#   primary_key :id
#   foreign_key :created_by,  :users
#   foreign_key :location_id, :locations
#   
#   Text :text
#   
#   DateTime :created_at
#   DateTime :updated_at

class Message < Sequel::Model(:messages)
  plugin :validation_helpers

  many_to_one :user, :key => :created_by
  many_to_one :location
end
