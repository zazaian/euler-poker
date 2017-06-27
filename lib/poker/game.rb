module Poker
  class Game
    attr_reader :sanitized_hands, :player1_wins, :player2_wins, :total_hands

    def initialize(hands_file)
      # read the hands and truncate the newline chars
      @sanitized_hands = File.readlines(hands_file).collect {|h| h[0..-2] }

      @player1_wins = 0
      @player2_wins = 0
      @total_hands = 0
    end

    def play
      sanitized_hands.each do |hand|
        all_cards = hand.split

        player1_cards = all_cards[0..4]
        player2_cards = all_cards[5..9]

        hand1 = Hand.new(player1_cards)
        hand2 = Hand.new(player2_cards)

        best_hand = Hand.best_hand(hand1, hand2)

        if hand1 == best_hand
          @player1_wins += 1
        else
          @player2_wins += 1
        end
        @total_hands += 1
      end

      puts "Total hands: #{@total_hands}, Player 1: #{player1_wins}, Player 2: #{player2_wins}"
    end
  end
end
