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
  plugin :validation_helpers

  one_to_many :messages

  def before_validation
    self.make_access_token unless self.access_token
    super
  end

  def before_create
    self.created_at = DateTime.now
    super
  end

  def to_hash
    self.values
  end

  def validate
    super
    validates_presence [:twitter_username, :access_token]
  end

  def make_access_token
    self.access_token = secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  private

  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end
