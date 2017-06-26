require "spec_helper"
require_relative "../../lib/poker/errors"

describe Poker::Hand do
  subject { described_class }
  let(:cards_error) { Poker::Errors::NumberOfCardsError }

  it "passes with exactly five cards" do
    hand1 = %w[8S 8D 9S 9D TH]
    expect { described_class.new(hand1) }.not_to raise_error
  end

  it "fails with fewer than five cards" do
    hand2 = %w[8S 8D 9S 9D]
    expect { described_class.new(hand2) }.to raise_error(cards_error)
  end

  it "fails with more than five cards" do
    hand3 = %w[8S 8D 9S 9D TH AC]
    expect { described_class.new(hand3) }.to raise_error(cards_error)
  end
end
