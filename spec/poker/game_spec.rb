require "spec_helper"

describe Poker::Game do
  subject { described_class }

  it "plays the game" do
    subject.new("p054_poker.txt").play
  end
end
