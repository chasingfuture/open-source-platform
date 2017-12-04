# Contain project related information
class Project

  # MongoID configuration
  include Mongoid::Document

  # Document fields
  #
  # slug            used to beautify URLs as a replacement of _id
  # repository_url  github page
  # git_url         .git
  # homepage_url    custom website
  field :slug,            type: String
  field :name,            type: String
  field :description,     type: String
  field :repository_url,  type: String
  field :git_url,         type: String
  field :homepage_url,    type: String

  # Indexes
  index({ slug: 1 }, { unique: true })

  # Validations
  validates_presence_of :name
  validates_presence_of :repository_url
  validates_presence_of :git_url
  validates_presence_of :slug
  validates_uniqueness_of :slug

end
