require 'pry-byebug'
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
