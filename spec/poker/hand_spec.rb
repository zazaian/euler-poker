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

  it "can identify two of a kind" do
    # two eights
    hand = described_class.new %w[8S 8D 7S 9D TH]
    expect(hand.two_of_a_kind).to eq true
  end

  it "can identify two pair" do
    # two eights, two sevens
    hand = described_class.new %w[8S 8D 7S 7D TH]
    expect(hand.two_pair).to eq true
  end

  it "can identify three of a kind" do
    # three eights
    hand = described_class.new %w[8S 8D 8C 7D TH]
    expect(hand.three_of_a_kind).to eq true
  end

  it "can identify four of a kind" do
    # four eights
    hand = described_class.new %w[8S 8D 8C 8H TH]
    expect(hand.four_of_a_kind).to eq true
  end
end
