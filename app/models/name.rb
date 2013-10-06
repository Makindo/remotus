class Name < ActiveRecord::Base
  include Remotus::Data
  include Remotus::Provider

  validates_with NameValidator
end
