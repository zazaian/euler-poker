module Poker
  class TieBreaker
    attr_reader :hand1, :hand2, :best_hand

    def initialize(hand1, hand2)
      @hand1 = hand1
      @hand2 = hand2
      @best_hand = hand1.best_hand
    end

    def winner
      # return the winner based on the hand type
      @winner ||= send(best_hand)
    end

    def straight_flush
      highest_card_wins
    end

    def four_of_a_kind
    end

    def full_house
    end

    def flush
    end

    def straight
      highest_card_wins
    end

    def three_of_a_kind
    end

    def two_pair
    end

    def two_of_a_kind
    end

    def high_card
      highest_card_wins
    end

    private

    def highest_card_wins
      hand1.highest_card_index > hand2.highest_card_index ? hand1 : hand2
    end
  end
end
