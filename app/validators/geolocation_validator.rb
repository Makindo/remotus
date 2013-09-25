class GeolocationValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:address] << "is completely empty" if incomplete?
  end

  private

  def incomplete?
    @record.city.blank? && @record.state.blank? && @record.country.blank?
  end
end

