# Contain user information.
# Those are real app users for which profiles are created after registration.
class User

  # MongoID configuration
  include Mongoid::Document

  # Document fields
  #
  # github_ext_id   profile id on github, mainly used for authentication purpose
  field :name,            type: String
  field :email,           type: String
  field :avatar_url,      type: String
  field :github_ext_id,   type: Integer

  # Indexes
  index({ github_ext_id: 1 }, { unique: true })

  # Validations
  #
  # Note that github_ext_id is required.
  # This is because Github auth is mandatory.
  # This can be changed later on if the auth schema evolves.
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :github_ext_id
  validates_uniqueness_of :github_ext_id

end
