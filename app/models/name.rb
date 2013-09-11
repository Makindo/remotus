class Name < ActiveRecord::Base
  include Remote::Data
  validates_with NameValidator
end
