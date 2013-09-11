class Gender < ActiveRecord::Base
  include Remote::Data
  validates_with GenderValidator
end
