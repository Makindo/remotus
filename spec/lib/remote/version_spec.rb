require "spec_helper"

describe Remote::VERSION do
  it "should be a string" do
    expect(Remote::VERSION).to be_kind_of(String)
  end
end
