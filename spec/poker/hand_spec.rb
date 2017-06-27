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
    expect(hand.best_hand).to eq :high_card
  end

  it "can identify two of a kind" do
    # two eights
    hand = described_class.new %w[8S 8D 7S 9D TH]
    expect(hand.two_of_a_kind).to eq true
    expect(hand.best_hand).to eq :two_of_a_kind
  end

  it "can identify two pair" do
    # two eights, two sevens
    hand = described_class.new %w[8S 8D 7S 7D TH]
    expect(hand.two_pair).to eq true
    expect(hand.best_hand).to eq :two_pair
  end

  it "can identify three of a kind" do
    # three eights
    hand = described_class.new %w[8S 8D 8C 7D TH]
    expect(hand.three_of_a_kind).to eq true
    expect(hand.best_hand).to eq :three_of_a_kind
  end

  it "can identify four of a kind" do
    # four eights
    hand = described_class.new %w[8S 8D 8C 8H TH]
    expect(hand.four_of_a_kind).to eq true
    expect(hand.best_hand).to eq :four_of_a_kind
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
    expect(hand.best_hand).to eq :high_card
  end

  it "can identify a straight" do
    # 2-6 straight
    hand = described_class.new %w[2S 3D 4C 5H 6H]
    expect(hand.straight).to eq true
    expect(hand.best_hand).to eq :straight

    # ten-to-ace straight
    hand = described_class.new %w[TS JD KC QH AH]
    expect(hand.straight).to eq true
    expect(hand.best_hand).to eq :straight
  end

  it "can identify a flush" do
    # all spades
    hand = described_class.new %w[2S 9S TS AS 5S]
    expect(hand.flush).to eq true
    expect(hand.best_hand).to eq :flush
  end

  it "can identify a full house" do
    # three twos, two aces
    hand = described_class.new %w[2S 2D 2H AS AH]
    expect(hand.full_house).to eq true
    expect(hand.best_hand).to eq :full_house
  end

  it "can identify a straight flush" do
    # 2-6, all spades
    hand = described_class.new %w[2S 3S 4S 5S 6S]
    expect(hand.straight_flush).to eq true
    expect(hand.best_hand).to eq :straight_flush
  end

  it "can identify a royal flush" do
    # ten to ace, all spades
    hand = described_class.new %w[TS JS QS KS AS]
    expect(hand.royal_flush).to eq true
    expect(hand.best_hand).to eq :royal_flush
  end

  it "can identify the pairs in a hand" do
    # full house, a two-pair and a three-pair
    hand = described_class.new %w[4D 4H 4C 8C 8D]

    pair1 = hand.all_sets[2].first
    expect([
      pair1.first.rank,
      pair1.last.rank
    ]).to eq %w[8 8]

    pair2 = hand.all_sets[3].first
    expect([
      pair2.first.rank,
      pair2[1].rank,
      pair2.last.rank
    ]).to eq %w[4 4 4]
  end

  it "has a best hand index" do
    # royal flush
    hand = described_class.new %w[TS JS QS KS AS]
    expect(hand.best_hand_index).to eq 0

    # four of a kind
    hand = described_class.new %w[8S 8D 8C 8H TH]
    expect(hand.best_hand_index).to eq 2

    # two pair
    hand = described_class.new %w[8S 8D 7S 7D TH]
    expect(hand.best_hand_index).to eq 7
  end

  it "can ferret out sorted non-pairs" do
    hand = described_class.new %w[8S 8D 7S 4D TH]
    expect(hand.unpaired_card_indexes).to eq([8, 5, 2])
  end

  it "knows how many total unpaired cards it has" do
    hand = described_class.new %w[8S 8D 7S 4D TH]
    expect(hand.total_unpaired_cards).to eq(3)
  end

  it "knows a flush is better than two-pair" do
    # flush, spades
    hand1 = subject.new %w[4S 5S QS KS AS]
    # two pair, jacks and nines
    hand2 = subject.new %w[9S 9D JS JH KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows a straight is better than three of a kind" do
    # ace-high straight
    hand1 = subject.new %w[TD JH QD KS AS]
    # three nines
    hand2 = subject.new %w[9S 9D 9H QS KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows a royal flush is better than a straight flush" do
    # royal flush
    hand1 = subject.new %w[TS JS QS KS AS]
    # king-high straight flush
    hand2 = subject.new %w[9S TS JS QS KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows a full house is better than a straight" do
    # full house, tens over kings
    hand1 = subject.new %w[TS TD TH KS KD]
    # king-high straight
    hand2 = subject.new %w[9S TD JH QC KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows three of a kind is better than two pair" do
    # three tens
    hand1 = subject.new %w[TS TD TH AS KD]
    # two pair, jacks and nines
    hand2 = subject.new %w[9S 9D JH JC KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows two pair is better than a pair" do
    # two pair, tens and aces
    hand1 = subject.new %w[TS TD AH AS KD]
    # pair of nines
    hand2 = subject.new %w[9S 9D 4H JC KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end

  it "knows a pair is better than high card" do
    # pair of fives
    hand1 = subject.new %w[5S 5D 8H AS KD]
    # king high
    hand2 = subject.new %w[3S 9D 4H JC KS]

    expect(subject.best_hand(hand1, hand2)).to eq hand1
  end
end
