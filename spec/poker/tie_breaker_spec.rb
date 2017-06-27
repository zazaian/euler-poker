require "spec_helper"

describe Poker::TieBreaker do
  subject { described_class }

  it "determines the better of two straights" do
    hand1 = Poker::Hand.new %w[2S 3D 4C 5H 6H]
    hand2 = Poker::Hand.new %w[6S 7D 8C 9H TH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two straight flushes" do
    hand1 = Poker::Hand.new %w[2H 3H 4H 5H 6H]
    hand2 = Poker::Hand.new %w[6H 7H 8H 9H TH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two high card hands" do
    hand1 = Poker::Hand.new %w[2H 4D 6H 8S TH]
    hand2 = Poker::Hand.new %w[6H 7D 8C JH AH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two hands with a single pair" do
    # two fives
    hand1 = Poker::Hand.new %w[5H 5D 6H 8S TH]

    # two kings
    hand2 = Poker::Hand.new %w[KH KD 8C JH AH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end


  it "determines the better of two hands with three of a kind" do
    # three fives
    hand1 = Poker::Hand.new %w[5H 5D 5H 8S TH]

    # three kings
    hand2 = Poker::Hand.new %w[KH KD KC JH AH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two hands with three of a kind, high card" do
    # three fives, eight high
    hand1 = Poker::Hand.new %w[5H 5D 5H 8S 4H]

    # three fives, ace high
    hand2 = Poker::Hand.new %w[5H 5D 5C AH 3H]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two hands with four of a kind" do
    # four fives
    hand1 = Poker::Hand.new %w[5H 5D 5H 5S TH]

    # three kings
    hand2 = Poker::Hand.new %w[KH KD KC KH AH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines which hands has better unpaired cards" do
    # A K 2
    hand1 = Poker::Hand.new %w[5H 5D AH KS 2H]
    # A K Q
    hand2 = Poker::Hand.new %w[5H 5D AC KH QH]

    expect(subject.new(hand1, hand2).winner).to eq hand2

    # K Q T 9 3
    hand1 = Poker::Hand.new %w[KH QD TH 9S 3H]
    # K J T 9 3
    hand2 = Poker::Hand.new %w[KH JD TH 9S 3H]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two flushes based on high card" do
    # King high flush
    hand1 = Poker::Hand.new %w[KH QH TH 8H 3H]

    # Ace high flush
    hand2 = Poker::Hand.new %w[AS QS TS 8S 3S]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two full houses" do
    # kings over tens
    hand1 = Poker::Hand.new %w[KH KD KC TS TH]

    # aces over tens
    hand2 = Poker::Hand.new %w[AH AD AC TS TH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end

  it "determines the better of two two-pair hands" do
    # tens over eights
    hand1 = Poker::Hand.new %w[TH TD 8C 8S 4H]

    # aces over eights
    hand2 = Poker::Hand.new %w[AH AD 8C 8S 3H]

    expect(subject.new(hand1, hand2).winner).to eq hand2


    # aces over fives
    hand1 = Poker::Hand.new %w[AH AD 5C 5S 4H]

    # aces over eights
    hand2 = Poker::Hand.new %w[AH AD 8C 8S 3H]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end
end
