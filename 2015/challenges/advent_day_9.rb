# --- Day 9: All in a Single Night ---
# Every year, Santa manages to deliver all of his presents in a single night.
# This year, however, he has some new locations to visit; his elves have provided him the distances between every pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location exactly once. What is the shortest distance he can travel to achieve this?
# For example, given the following distances:

# London to Dublin = 464
# London to Belfast = 518
# Dublin to Belfast = 141
# The possible routes are therefore:

# Dublin -> London -> Belfast = 982
# London -> Dublin -> Belfast = 605
# London -> Belfast -> Dublin = 659
# Dublin -> Belfast -> London = 659
# Belfast -> Dublin -> London = 605
# Belfast -> London -> Dublin = 982
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

# What is the distance of the shortest route?

# --- Part Two ---
# The next year, just to show off, Santa decides to take the route with the longest distance instead.
# He can still start and end at any two (different) locations he wants, and he still must visit each location exactly once.
# For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.

# What is the distance of the longest route?

module Advent
  class Day9 < Base

    def input
      [ 'Faerun to Norrath = 129', 'Faerun to Tristram = 58', 'Faerun to AlphaCentauri = 13', 'Faerun to Arbre = 24', 'Faerun to Snowdin = 60', 'Faerun to Tambi = 71', 'Faerun to Straylight = 67', 'Norrath to Tristram = 142', 'Norrath to AlphaCentauri = 15', 'Norrath to Arbre = 135', 'Norrath to Snowdin = 75', 'Norrath to Tambi = 82', 'Norrath to Straylight = 54', 'Tristram to AlphaCentauri = 118', 'Tristram to Arbre = 122', 'Tristram to Snowdin = 103', 'Tristram to Tambi = 49', 'Tristram to Straylight = 97', 'AlphaCentauri to Arbre = 116', 'AlphaCentauri to Snowdin = 12', 'AlphaCentauri to Tambi = 18', 'AlphaCentauri to Straylight = 91', 'Arbre to Snowdin = 129', 'Arbre to Tambi = 53', 'Arbre to Straylight = 40', 'Snowdin to Tambi = 15', 'Snowdin to Straylight = 99', 'Tambi to Straylight = 70' ]
    end

    def challenge_1(challenge_input=input)
      find_route(challenge_input).first # min
    end

    def challenge_2(challenge_input=input)
      find_route(challenge_input).last # max
    end

    def find_route(challenge_input)
      if @distances.nil?
        city_distances ||= {}

        # Convert into hash of hashes
        if city_distances.empty?
          challenge_input.map(&:split).each do |x, to, y, equals, d|
            city_distances[x] ||= {}
            city_distances[y] ||= {}
            city_distances[x][y] = city_distances[y][x] = d.to_i
          end
        end

        # For every permutation of the cities array, find the distance between consecutive nodes
        # Since we now have an array of city_distances for all possible combinations of cities, get the min
        cities = city_distances.keys.flatten.uniq
        @distances ||= cities.permutation.map do |path|
          # For every 2 consecutive cities in the path, reduce and add the distance
          path.each_cons(2).reduce(0) do |distance, (current_town, next_town)|
            distance + city_distances[current_town][next_town]
          end
        end
      end
      @distances.minmax
    end

    # Testing

    def test
      input = ["London to Dublin = 464","London to Belfast = 518","Dublin to Belfast = 141"]
      perform_test(1, input, 605) && perform_test(2, input, 982)
    end
  end
end
