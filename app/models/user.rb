# Contain user information.
# Those are real app users for which profiles are created after registration.
class User

  # MongoID configuration
  include Mongoid::Document

  # Document fields
  #
  # login           imported login name from github, used as slug
  # github_ext_id   profile id on github, mainly used for authentication purpose
  field :login,           type: String
  field :name,            type: String
  field :email,           type: String
  field :avatar_url,      type: String
  field :github_ext_id,   type: Integer

  # Relations
  has_many :projects, foreign_key: 'owner_id'

  # Indexes
  index({ github_ext_id: 1 }, { unique: true })
  index({ login: 1 }, { unique: true })

  # Validations
  #
  # Note that github_ext_id is required.
  # This is because Github auth is mandatory.
  # This can be changed later on if the auth schema evolves.
  validates_presence_of   :login
  validates_uniqueness_of :login
  validates_presence_of   :name
  validates_presence_of   :email
  validates_presence_of   :github_ext_id
  validates_uniqueness_of :github_ext_id

end
