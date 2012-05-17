# The model for a User
#
# FIELDS
#   primary_key :id
#   
#   String :twitter_username
#   String :access_token
#   
#   DateTime :created_at
#   DateTime :updated_at

class User < Sequel::Model(:users)
  one_to_many :messages
end
