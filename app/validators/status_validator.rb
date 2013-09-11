class StatusValidator < ActiveModel::Validator
  BAD_HASHTAGS = ["#newcarincentives", "#followme", "#choosenissan1000"]

  def validate(record)
    @record = record
    @record.errors[:external_id] << "isn't present" if nonexternal?
    @record.errors[:text] << "contains a spam hashtag" if badtagged?
    @record.errors[:text] << "contains a retweet" if retweet?
  end

  private

  def badtagged?
    @record.text =~ /#{BAD_HASHTAGS.join("|")}/
  end

  def retweet?
    @record.text =~ /^rt/
  end

  def nonexternal?
    @record.external_id.empty?
  end
end
