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
      n_of_a_kind(4)
    end

    def full_house
    end

    def flush
    end

    def straight
      highest_card_wins
    end

    def three_of_a_kind
      n_of_a_kind(3)
    end

    def two_pair
    end

    def two_of_a_kind
      n_of_a_kind(2)
    end

    def n_of_a_kind(set_size)
      pair1 = hand1.all_sets[set_size].first
      pair2 = hand2.all_sets[set_size].first

      index1 = Hand.card_index(pair1.first.rank)
      index2 = Hand.card_index(pair2.first.rank)

      index1 > index2 ? hand1 : hand2
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
