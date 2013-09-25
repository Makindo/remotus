class Gender < ActiveRecord::Base
  include Remote::Data
  include Remote::Provider

  validates_with GenderValidator
end
