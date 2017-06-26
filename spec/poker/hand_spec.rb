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

  it "can identify a high-card-only hand" do
    # high card only
    hand = described_class.new %w[3S 8D 7S 9D TH]
    expect(hand.rank).to eq :high_card
  end

  it "can identify two of a kind" do
    # two eights
    hand = described_class.new %w[8S 8D 7S 9D TH]
    expect(hand.two_of_a_kind).to eq true
    expect(hand.rank).to eq :two_of_a_kind
  end

  it "can identify two pair" do
    # two eights, two sevens
    hand = described_class.new %w[8S 8D 7S 7D TH]
    expect(hand.two_pair).to eq true
    expect(hand.rank).to eq :two_pair
  end

  it "can identify three of a kind" do
    # three eights
    hand = described_class.new %w[8S 8D 8C 7D TH]
    expect(hand.three_of_a_kind).to eq true
    expect(hand.rank).to eq :three_of_a_kind
  end

  it "can identify four of a kind" do
    # four eights
    hand = described_class.new %w[8S 8D 8C 8H TH]
    expect(hand.four_of_a_kind).to eq true
    expect(hand.rank).to eq :four_of_a_kind
  end

  it "can identify a consecutive set" do
    # 2-6 consecutive, based on Card::RANKS
    hand = described_class.new %w[2S 3D 4C 5H 6H]
    expect(hand.consecutive?).to eq true
  end

  it "can identify a non-consecutive set" do
    # random cards, not a straight
    hand = described_class.new %w[2S 9D TC AH 5H]
    expect(hand.consecutive?).to eq false
    expect(hand.rank).to eq :high_card
  end

  it "can identify a straight" do
    # 2-6 straight
    hand = described_class.new %w[2S 3D 4C 5H 6H]
    expect(hand.straight).to eq true
    expect(hand.rank).to eq :straight

    # ten-to-ace straight
    hand = described_class.new %w[TS JD KC QH AH]
    expect(hand.straight).to eq true
    expect(hand.rank).to eq :straight
  end

  it "can identify a flush" do
    # all spades
    hand = described_class.new %w[2S 9S TS AS 5S]
    expect(hand.flush).to eq true
    expect(hand.rank).to eq :flush
  end

  it "can identify a full house" do
    # three twos, two aces
    hand = described_class.new %w[2S 2D 2H AS AH]
    expect(hand.full_house).to eq true
    expect(hand.rank).to eq :full_house
  end

  it "can identify a straight flush" do
    # 2-6, all spades
    hand = described_class.new %w[2S 3S 4S 5S 6S]
    expect(hand.straight_flush).to eq true
    expect(hand.rank).to eq :straight_flush
  end

  it "can identify a royal flush" do
    # ten to ace, all spades
    hand = described_class.new %w[TS JS QS KS AS]
    expect(hand.royal_flush).to eq true
    expect(hand.rank).to eq :royal_flush
  end
end
