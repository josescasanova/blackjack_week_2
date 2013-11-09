require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize (s, v)
    @suit =  s
    @value = v
  end

  def show_hand
    "The #{value} of #{suit}"
  end

  def to_s
    show_hand
  end
end


class Deck
  attr_accessor :cards
  
  def initialize 
    @cards = []
    ["C", "S", "H", "D"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].each do |value|
      @cards << Card.new(suit, value)
      end
    end
    shuffle
  end

  def shuffle
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end

module Hand

  def add_card(new_card)
    cards << new_card
  end

  def show_hand
    cards.each do |card|
      puts "#{name}'s hand: #{card}"
    end
      puts "for a total of #{total}"
    
  end

  def total
    value = cards.map { |cards| cards.value }

  total = 0
  value.each do |val|
    if val == "A"
      total += 11
    elsif val.to_i == 0
      total += 10
    else
      total += val.to_i
    end
  end
  
  value.select { |val| val == "A"}.count.times do
    if total > 21
      total -= 10
    end
  end

  total
  end

  def busted
   total > 21
  end

end

class Player
  include Hand

  attr_accessor :cards, :name

  def initialize(n)
  @name = n
  @cards = []
  end
  
end

class Dealer
  include Hand

  attr_accessor :cards, :name

  def initialize
  @name = "Dealer"
  @cards = []
  end

  def show_flop
    puts "First card is hidden"
    puts"Second card is #{cards[1]}"
  end

end

class Game
  attr_accessor :player, :dealer, :stack, :name

  def initialize
    @stack = Deck.new
    @player = Player.new("Bob")
    @dealer = Dealer.new 
  end

  def set_player_name
    puts "Please enter the player's name:"
    @player.name = gets.chomp
  end

  def deal_cards
    player.add_card(stack.deal) # Took out .name method on player
    dealer.add_card(stack.deal)
    player.add_card(stack.deal) # Took out .name method on player
    dealer.add_card(stack.deal)
  end

  def show_flops
    player.show_hand # took out .hand method
    dealer.show_flop
  end

  def hit_blackjack_or_bust?(participant)
    if participant.total == 21
      if participant.is_a?(Dealer)
        puts "Dealer hit blackjack. #{player.name} loses."# Changed from player_name to player.name
      else
        puts "Congratulations! #{player.name} won!"# Changed from player_name to player.name
      end 
      exit
    elsif participant.busted
      if participant.is_a?(Dealer)
      puts "Congratulations, Dealer busted. #{player.name} wins!"# Changed from player_name to player.name
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."# Changed from player_name to player.name
      exit
      end
    end
  end

  def player_turn
    puts "#{player.name}'s turn." #took off _name

    hit_blackjack_or_bust?(player)

    while !player.busted
      puts "press, 1, to hit or, 2, to stay."
      hit_or_stay = gets.chomp
    
      if !['1', '2'].include?(hit_or_stay) 
        puts "Please press either 1 or 2"
        next
      end

      if hit_or_stay == '2'
        puts "#{player.name} has decided to stay."# Changed from player_name to player.name
        break
      end

      new_card = stack.deal
      puts "Dealing card to #{player.name}: #{new_card}"# Changed from player_name to player.name
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"# Changed from player_name to player.name
    end
    hit_blackjack_or_bust?(player)

  end

  def dealer_turn
    puts "Dealer's turn."
    dealer.show_hand

    hit_blackjack_or_bust?(dealer)
    while dealer.total < 17
      new_card = stack.deal
      puts "Dealing card to Dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer's total is now: #{dealer.total}"
    end
    hit_blackjack_or_bust?(dealer)
  end

  def who_wins?(player, dealer)

    if player.total > dealer.total
      puts "The player #{player.name}!" # Changed from player_name to player.name
    elsif
      player.total < dealer.total
      puts "The dealer wins. #{player.name} loses." # Changed from player_name to player.name
    else
      player.total == dealer.total
      puts "It's a tie" 
    end
  end

  def run
    set_player_name
    deal_cards
    show_flops
    player_turn
    dealer_turn
    who_wins?(player, dealer)
  end
end

puts "Welcome to Black Jack"

black_jack = Game.new
black_jack.run

#d1 = Deck.new

#binding.pry
=begin
player = Player.new("Bob")
player.add_card(d1.deal)
player.add_card(d1.deal)
player.add_card(d1.deal)
player.show_hand
=end
=begin
dealer = Dealer.new
dealer.add_card(d1.deal)
dealer.add_card(d1.deal)
dealer.add_card(d1.deal)
dealer.show_hand
=end


