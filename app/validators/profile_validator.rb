class ProfileValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:external_id] << "isn't present" if nonexternal?
  end

  private

  def nonexternal?
    @record.external_id.empty?
  end
end
