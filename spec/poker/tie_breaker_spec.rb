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

  it "determines the better of two hands with four of a kind" do
    # four fives
    hand1 = Poker::Hand.new %w[5H 5D 5H 5S TH]

    # three kings
    hand2 = Poker::Hand.new %w[KH KD KC KH AH]

    expect(subject.new(hand1, hand2).winner).to eq hand2
  end
end
