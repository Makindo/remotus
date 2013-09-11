class GenderValidator < ActiveModel::Validator
  VALID_GENDERS = 0..2

  def validate(record)
    @record = record
    @record.errors[:provider] << "not present" if @record.provider.empty?
    @record.errors[:type] << "not a valid gender" if ungendered?
  end

  private

  def gendered?
    !VALID_GENDERS.cover?(@record.type)
  end
end
