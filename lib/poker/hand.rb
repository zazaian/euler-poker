module Poker
  class Hand
    attr_reader :cards

    def initialize(cards)
      raise cards_error(cards) if cards.size != 5

      @cards = cards.collect do |card_sym|
        Card.new(card_sym)
      end
    end

    def best_hand_methods
      [:royal_flush,
       :straight_flush,
       :four_of_a_kind,
       :full_house,
       :flush,
       :straight,
       :three_of_a_kind,
       :two_pair,
       :two_of_a_kind,
       :high_card]
    end

    def best_hand
      @best_hand ||= best_hand_methods.find(&self.method(:send))
    end

    def best_hand_index
      best_hand_methods.index(best_hand)
    end

    def royal_flush
      # Five cards in a sequence, all of the same suit, that includes a high ace.
      straight_flush && ace_high
    end

    def straight_flush
      # Five cards in a sequence, all of the same suit.
      straight && flush
    end

    def four_of_a_kind
      # All four cards of one rank, and any other unmatched card.
      n_of_a_kind?(4, size: 1)
    end

    def full_house
      # Three matchi@ng cards of one rank and two matching cards of another rank.
      two_of_a_kind && three_of_a_kind
    end

    def flush
      # All five cards of the same suit, but not in a sequence.
      flush_suit = cards.first.suit
      cards.all? {|card| card.suit == flush_suit }
    end

    def straight
      # Five cards of sequential rank in at least two different suits.
      consecutive?
    end

    def three_of_a_kind
      # Three cards of the same rank, with two cards not of this rank nor the same as each other.
      # Two cards of one rank, plus three cards which are not this rank nor the same.
      n_of_a_kind?(3, size: 1)
    end

    def two_pair
      # Two cards of the same rank, plus two cards of another rank.
      n_of_a_kind?(2, size: 2)
    end

    def two_of_a_kind
      # Two cards of one rank, plus three cards which are not this rank nor the same.
      n_of_a_kind?(2, size: 1)
    end

    def high_card
      # Any hand not meeting the above requirements.
      true
    end

    def n_of_a_kind?(n, size: 1)
      all_pairs[n] && all_pairs[n].size == size
    end

    def all_pairs
      @all_pairs ||= cards.group_by(&:rank).values.group_by(&:size)
    end

    def consecutive?
      Card::RANKS.join.include?(sorted_ranks.join)
    end

    def sorted_ranks
      @sorted_ranks ||= cards.collect {|c| c.rank }.sort do |x, y|
        Card::RANKS.index(x) <=> Card::RANKS.index(y)
      end
    end

    def ace_high
      sorted_ranks.last == "A"
    end

    def highest_card_index
      Card::RANKS.index(sorted_ranks.last)
    end

    def self.card_index(rank)
      Card::RANKS.index(rank)
    end

    def better_than?(other_hand)
      # check if this hand is better than the other hand
      return true if best_hand_index < other_hand.best_hand_index

      # if not, break the tie
      TieBreaker.new(self, other_hand).winner == self
    end

    private

    def cards_error(cards_num)
      Poker::Errors::NumberOfCardsError.new(cards: cards)
    end
  end
end
