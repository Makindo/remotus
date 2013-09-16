class GenderValidator < ActiveModel::Validator
  VALID_GENDERS = 0..2

  def validate(record)
    @record = record
    @record.errors[:provider] << "not present" if @record.provider.empty?
    @record.errors[:value] << "not a valid gender" if ungendered?
  end

  private

  def gendered?
    !VALID_GENDERS.cover?(@record.value)
  end
end
