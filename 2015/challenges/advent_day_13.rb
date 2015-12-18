# --- Day 13: Knights of the Dinner Table ---
# In years past, the holiday feast with your family hasn't gone so well. Not everyone gets along! This year, you resolve, will be different. You're going to find the optimal seating arrangement and avoid all those awkward conversations.
# You start by writing up a list of everyone invited and the amount their happiness would increase or decrease if they were to find themselves sitting next to each other person. You have a circular table that will be just big enough to fit everyone comfortably, and so each person will have exactly two neighbors.

# For example, suppose you have only four attendees planned, and you calculate their potential happiness as follows:

# Alice would gain 54 happiness units by sitting next to Bob.
# Alice would lose 79 happiness units by sitting next to Carol.
# Alice would lose 2 happiness units by sitting next to David.
# Bob would gain 83 happiness units by sitting next to Alice.
# Bob would lose 7 happiness units by sitting next to Carol.
# Bob would lose 63 happiness units by sitting next to David.
# Carol would lose 62 happiness units by sitting next to Alice.
# Carol would gain 60 happiness units by sitting next to Bob.
# Carol would gain 55 happiness units by sitting next to David.
# David would gain 46 happiness units by sitting next to Alice.
# David would lose 7 happiness units by sitting next to Bob.
# David would gain 41 happiness units by sitting next to Carol.
# Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David talks so much), but David would gain 46 happiness units (because Alice is such a good listener), for a total change of 44.

# If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice gains 54). Finally, seat Carol, who sits next to Bob (Carol gains 60, Bob loses 7) and David (Carol gains 55, David gains 41). The arrangement looks like this:

#      +41 +46
# +55   David    -2
# Carol       Alice
# +60    Bob    +54
#      -7  +83
# After trying every other seating arrangement in this hypothetical scenario, you find that this one is the most optimal, with a total change in happiness of 330.
# What is the total change in happiness for the optimal seating arrangement of the actual guest list?

# --- Part Two ---
# In all the commotion, you realize that you forgot to seat yourself. At this point, you're pretty apathetic toward the whole thing, and your happiness wouldn't really go up or down regardless of who you sit next to. You assume everyone else would be just as ambivalent about sitting next to you, too.
# So, add yourself to the list, and give all happiness relationships that involve you a score of 0.
# What is the total change in happiness for the optimal seating arrangement that actually includes yourself?

module Advent
  class Day13 < Base

    def initialize
      @distances = {}
    end

    def input
      File.readlines(File.dirname(__FILE__) + "/data/day13.txt").map(&:chomp)  
    end

    def challenge_1(challenge_input=input)
      find_optimal_happiness(challenge_input)
    end

    def challenge_2(challenge_input=input)
      find_optimal_happiness(challenge_input, 2)
    end

    def find_optimal_happiness(challenge_input, challenge=1)
      happiness_ratings ||= {}

      # Convert into hash of hashes
      if happiness_ratings.empty?
        challenge_input.map { |i| i.gsub(/happiness units by sitting next to|\./,'') }.map(&:split).each do |x, would, gain, y, z|
          happiness_ratings[x] ||= {}
          modifier = gain == "gain" ? 1 : -1
          happiness_ratings[x][z] = y.to_i * modifier
        end
      end

      # For every permutation of the happiness_ratings array, find the happiness between consecutive seatings
      # Since we now have an array of happiness for all possible combinations of seatings, get the minmax
      arrangement = happiness_ratings.keys.flatten.uniq

      # For Challenge 2, add me in
      if challenge == 2
        happiness_ratings["Julian"] = {}
        arrangement.each { |person| happiness_ratings[person]["Julian"] = happiness_ratings["Julian"][person] = 0 }
        arrangement << "Julian"
      end

      distances ||= arrangement.permutation.map do |path|
        # For every 2 consecutive arrangement in the path, reduce and add the distance. Also do this for first/last
        happiness_arrangement = path.each_cons(2).reduce(0) do |happiness, (current_seat, next_seat)|
          happiness + happiness_ratings[current_seat][next_seat] + happiness_ratings[next_seat][current_seat]
        end
        happiness_arrangement + happiness_ratings[path.first][path.last] + happiness_ratings[path.last][path.first]
      end
      distances.max
    end

    # Testing

    def test
      input = ["Alice would gain 54 happiness units by sitting next to Bob.", "Alice would lose 79 happiness units by sitting next to Carol.", "Alice would lose 2 happiness units by sitting next to David.", "Bob would gain 83 happiness units by sitting next to Alice.", "Bob would lose 7 happiness units by sitting next to Carol.", "Bob would lose 63 happiness units by sitting next to David.", "Carol would lose 62 happiness units by sitting next to Alice.", "Carol would gain 60 happiness units by sitting next to Bob.", "Carol would gain 55 happiness units by sitting next to David.", "David would gain 46 happiness units by sitting next to Alice.", "David would lose 7 happiness units by sitting next to Bob.", "David would gain 41 happiness units by sitting next to Carol."]
      perform_test(1, input, 330)
    end
  end
end
