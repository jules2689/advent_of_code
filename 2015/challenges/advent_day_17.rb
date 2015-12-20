# --- Day 17: No Such Thing as Too Much ---
# The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to move it into smaller containers. You take an inventory of the capacities of the available containers.
# For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there are four ways to do it:

# 15 and 10
# 20 and 5 (the first 5)
# 20 and 5 (the second 5)
# 15, 5, and 5
# Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of eggnog?

# --- Part Two ---
# While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving department is requesting as many containers as you can spare.
# Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can you fill that number of containers and still hold exactly 150 litres?
# In the example above, the minimum number of containers was two. There were three ways to use that many containers, and so the answer there would be 3.

module Advent
  class Day17 < Base
    def initialize
      @size = 150
    end

    def input
      [ 11, 30, 47, 31, 32, 36, 3, 1, 5, 3, 32, 36, 15, 11, 46, 26, 28, 1, 19, 3 ]
    end

    def challenge_1(challenge_input=input)
       combinations = (0..challenge_input.size).flat_map{|size| challenge_input.combination(size).to_a }
       combinations.map { |y| y.inject(&:+) }.reject { |n| n != @size }.size
    end

    def challenge_2(challenge_input=input)
      combinations = (0..challenge_input.size).flat_map{|size| challenge_input.combination(size).to_a }
      combinations = combinations.reject { |n| n.inject(&:+) != @size }
      min = combinations.min { |n| n.size }.size
      combinations.reject { |n| n.size != min }.size
    end

    # Testing

    def test
      @size = 25
      perform_test(1, [20, 15, 10, 5, 5], 4) &&
      perform_test(2, [20, 15, 10, 5, 5], 3)
    end 
  end
end
