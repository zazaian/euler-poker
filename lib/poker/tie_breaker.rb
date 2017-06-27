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
      n_of_a_kind(4) || best_unpaired_cards
    end

    def full_house
      n_of_a_kind(3) || n_of_a_kind(2)
    end

    def flush
      best_unpaired_cards
    end

    def straight
      highest_card_wins
    end

    def three_of_a_kind
      n_of_a_kind(3) || best_unpaired_cards
    end

    def two_pair
      # hand1 sets
      set1 = hand1.all_sets[2].first
      set2 = hand1.all_sets[2].last
      index1 = Hand.card_index(set1.first.rank)
      index2 = Hand.card_index(set2.first.rank)
      hand1_high = [index1, index2].max
      hand1_low = [index1, index2].min

      # hand2 sets
      set3 = hand2.all_sets[2].first
      set4 = hand2.all_sets[2].last
      index3 = Hand.card_index(set3.first.rank)
      index4 = Hand.card_index(set4.first.rank)
      hand2_high = [index3, index4].max
      hand2_low = [index3, index4].min

      if hand1_high > hand2_high
        hand1
      elsif hand2_high > hand1_high
        hand2
      else
        hand1_low > hand2_low ? hand1 : hand2
      end
    end

    def two_of_a_kind
      n_of_a_kind(2) || best_unpaired_cards
    end

    def n_of_a_kind(set_size)
      set1 = hand1.all_sets[set_size].first
      set2 = hand2.all_sets[set_size].first

      index1 = Hand.card_index(set1.first.rank)
      index2 = Hand.card_index(set2.first.rank)

      if index1 > index2
        hand1
      elsif index2 > index1
        hand2
      end

      # if the sets match, return nil
    end

    def high_card
      highest_card_wins
    end

    def best_unpaired_cards
      hand1.unpaired_card_indexes.each_with_index do |card_num1, index|
        card_num2 = hand2.unpaired_card_indexes[index]
        return hand1 if card_num1 > card_num2
        return hand2 if card_num2 > card_num1
      end
    end

    def total_unpaired_cards
      hand1.total_unpaired_cards
    end

    private

    def highest_card_wins
      hand1.highest_card_index > hand2.highest_card_index ? hand1 : hand2
    end
  end
end
