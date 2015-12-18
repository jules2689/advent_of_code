require 'pry'
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
