class Name < ActiveRecord::Base
  include Remote::Data
  include Remote::Provider

  validates_with NameValidator
end
