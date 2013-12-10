require "spec_helper"

describe TwitterProfileDenormalizer do
  before do
    @profile = Twitter::User.new(id: 1, id_str: "1", name: "Test User", screen_name: "tester")
    @denorm_profile = described_class.new(@profile)
  end

  it "should be convertable to a hash" do
    expect(@denorm_profile.to_hash[:name]).to be_eql("Test User")
  end
end
    
