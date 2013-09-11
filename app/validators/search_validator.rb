class SearchValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:query] << "isn't present" if @record.query.empty?
  end
end
