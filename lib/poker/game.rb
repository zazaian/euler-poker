module Poker
  class Game
    attr_reader :sanitized_hands, :player1_wins, :player2_wins

    def initialize(hands_file)
      # read the hands and truncate the newline chars
      @sanitized_hands = File.readlines(hands_file).collect {|h| h[0..-2] }

      @player1_wins = 0
      @player2_wins = 0
    end

    def play
      sanitized_hands.each do |hand|
        all_cards = hand.split

        player1_cards = all_cards[0..4]
        player2_cards = all_cards[5..9]

        hand1 = Hand.new(player1_cards)
        hand2 = Hand.new(player2_cards)

        if hand1.better_than?(hand2)
          puts "Player 1 wins!!"
          @player1_wins += 1
        else
          puts "Player 2 wins!!"
          @player2_wins += 1
        end

        puts "Totals - Player 1: #{player1_wins}, Player 2: #{player2_wins}"
      end
    end
  end
end
