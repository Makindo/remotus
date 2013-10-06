class Gender < ActiveRecord::Base
  include Remotus::Data
  include Remotus::Provider

  validates_with GenderValidator
end
