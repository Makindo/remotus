require "spec_helper"

describe TwitterStatusRemote do
  describe "#record", vcr: { cassette_name: "twitter_status" } do
    it "returns a hash with the data of the status" do
      expect(described_class.new(1).record[:data]).to be_present
    end

    it "contains the type of status" do
      expect(described_class.new(1).record[:type]).to eq("TwitterStatus")
    end
  end

  describe "errors" do
    it "adds the id to the forbidden list if no longer exists"
    it "adds the id to the forbidden list if no longer accessible"
    it "warns if no longer exists"
    it "warns if no longer accessible"
    it "waits if the rate limit is up"
  end
end
