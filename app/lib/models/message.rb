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

  def before_create
    self.created_at = DateTime.now
    super
  end

  def self.proximity(lat, lng, rad)
    q = "
      SELECT messages.id, ( 3959 * acos( cos( radians(#{lat}) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(#{lng}) ) + sin( radians(#{lat}) ) * sin( radians( lat ) ) ) ) AS distance 
      FROM messages 
      JOIN locations ON locations.id = location_id
      HAVING distance < #{rad} ORDER BY distance
    "

    DB[q]
  end

  def to_hash
    {
      id: self.id,
      text: self.text,
      created_at: self.created_at,
      updated_at: self.updated_at,

      location: {
        id: self.location.id,
        lat: self.location.lat,
        lng: self.location.lng
      }
    }
  end

  def validate
    super
    validates_presence [:text, :user, :location]
  end
end
