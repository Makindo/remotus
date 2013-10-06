require "spec_helper"

describe Remotus::VERSION do
  it "should be a string" do
    expect(Remotus::VERSION).to be_kind_of(String)
  end
end
