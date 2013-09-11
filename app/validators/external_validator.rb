class ExternalValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    @record.errors[:external_id] << "not present" if @record.external_id.nil?
    @record.errors[:external_id] << "is junk" if junk?
  end

  private

  def junk?
    REDIS.sismember(@record.class, @record.external_id)
  end
end
