require "spec_helper"

describe Status do
  before do
    @status1 = TwitterStatus.new(external_id: "asdf", text: "a test status for some stuff", data: "some data for testing")
    @status1.rate(3)
    @status1.save
    
    @status2 = TwitterStatus.create(external_id: "bfgiou", text: "a second test status", data: "some more data")
  end

  it "should be valid" do
    expect(@status1).to be_valid
  end

  it "should be able to return statuses with votes" do
    expect(Status.with_votes.count).to eql(1)
  end
end
