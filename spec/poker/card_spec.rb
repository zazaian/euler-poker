require "spec_helper"

describe Poker::Card do
  subject { described_class }

  it "sets a rank and suit" do
    card = described_class.new("8D")
    expect(card.rank).to eq("8")
    expect(card.suit).to eq("D")
  end
end
