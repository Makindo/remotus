class NameValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:full_Name] << "is completely empty" if incomplete?
  end

  private

  def incomplete?
    @record.personal.blank? && @record.middle.blank? && @record.family.blank?
  end
end

