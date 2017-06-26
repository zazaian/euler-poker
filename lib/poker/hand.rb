module Poker
  class Hand
    attr_reader :cards

    def initialize(cards)
      raise cards_error(cards) if cards.size != 5

      @cards = cards.collect do |card_sym|
        Card.new(card_sym)
      end
    end

    def rank
      [:royal_flush,
       :straight_flush,
       :four_of_a_kind,
       :full_house,
       :flush,
       :straight,
       :three_of_a_kind,
       :two_pair,
       :two_of_a_kind,
       :high_card].find(&self.method(:send))
    end

    def royal_flush
      # Five cards in a sequence, all of the same suit, that includes a high ace.
    end

    def straight_flush
      # Five cards in a sequence, all of the same suit.
    end

    def four_of_a_kind
      # All four cards of one rank, and any other unmatched card.
      n_of_a_kind?(4, size: 1)
    end

    def full_house
      # Three matching cards of one rank and two matching cards of another rank.
    end

    def flush
      # All five cards of the same suit, but not in a sequence.
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
      kinds = cards.group_by(&:rank).values.group_by(&:size)
      kinds[n] && kinds[n].size == size
    end

    def consecutive?
      Card::RANKS.join.include?(sorted_hand_ranks.join)
    end

    def sorted_hand_ranks
      @sorted_hand_ranks ||= cards.collect {|c| c.rank }.sort do |x, y|
        Card::RANKS.index(x) <=> Card::RANKS.index(y)
      end
    end

    private

    def cards_error(cards_num)
      Poker::Errors::NumberOfCardsError.new(cards: cards)
    end
  end
end
