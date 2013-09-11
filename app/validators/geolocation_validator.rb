classGeolocationValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:address] << "is completely empty" if incomplete?
  end

  private

  def incomplete?
    @record.city.empty? && @record.state.empty? && @record.country.empty?
  end
end

