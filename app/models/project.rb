# Contain project related information
class Project

  # MongoID configuration
  include Mongoid::Document

  # Document fields
  #
  # slug            used to beautify URLs as a replacement of _id
  # repository_url  github (or whatever hosting service) page
  # git_url         .git
  # homepage_url    custom website
  # ext_id          hosting service id refering to this project
  # ext_src         specify the source of the project (e.g: 'github')
  field :slug,            type: String
  field :name,            type: String
  field :description,     type: String
  field :repository_url,  type: String
  field :git_url,         type: String
  field :homepage_url,    type: String
  field :ext_id,          type: Integer
  field :ext_source,      type: String
  # newly added field
  field :star_count,      type: Integer
  

  # relations
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  # Indexes
  index({ slug: 1 }, { unique: true })
  index({ ext_id: 1 }, { unique: true })

  # Validations
  validates_presence_of   :name
  validates_presence_of   :repository_url
  validates_presence_of   :git_url
  validates_presence_of   :slug
  validates_uniqueness_of :slug, scope: :owner
  validates_presence_of   :owner
  validates_presence_of   :ext_id
  validates_uniqueness_of :ext_id
  validates_presence_of   :ext_source
  validates               :ext_source, inclusion: { in: Platform::EXT_PLATFORMS }

end
