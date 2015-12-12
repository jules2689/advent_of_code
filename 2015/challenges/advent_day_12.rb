# --- Day 12: JSAbacusFramework.io ---
# Santa's Accounting-Elves need help balancing the books after a recent order. Unfortunately, their accounting software uses a peculiar storage format. That's where you come in.
# They have a JSON document which contains a variety of things: arrays ([1,2,3]), objects ({"a":1, "b":2}), numbers, and strings. Your first job is to simply find all of the numbers throughout the document and add them together.

# For example:
# [1,2,3] and {"a":2,"b":4} both have a sum of 6.
# [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
# {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
# [] and {} both have a sum of 0.
# You will not encounter any strings containing numbers.

# What is the sum of all numbers in the document?

# --- Part Two ---
# Uh oh - the Accounting-Elves have realized that they double-counted everything red.
# Ignore any object (and all of its children) which has any property with the value "red". Do this only for objects ({...}), not arrays ([...]).

# [1,2,3] still has a sum of 6.
# [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
# {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
# [1,"red",5] has a sum of 6, because "red" in an array has no effect.

require 'json'

module Advent
  class Day12 < Base

    def input
      JSON.parse(File.readlines(File.dirname(__FILE__) + "/data/day12.json").map(&:chomp).join(""))
    end

    def challenge_1(challenge_input=input)
      hash_block = Proc.new { |input| input.empty? }
      parse_numbers(challenge_input, hash_block).inject(&:+)
    end

    def challenge_2(challenge_input=input)
      hash_block = Proc.new { |input| input.empty? || input.has_value?("red") }
      parse_numbers(challenge_input, hash_block).inject(&:+)
    end

    def parse_numbers(input, hash_block)
      output = [0]

      if input.is_a? Hash
        output = hash_block.call(input) ? [0] : parse_numbers(input.values, hash_block)
      elsif input.is_a? Array
        output = output + input.collect { |d| parse_numbers(d, hash_block) }
      elsif input.is_a? Integer
        output = [input]
      end

      output.flatten
    end

    # Testing

    def test
      test_1 = perform_test(1, [1,2,3], 6) && perform_test(1, {"a":2,"b":4}, 6) &&
               perform_test(1, [[[3]]], 3) && perform_test(1, {"a":{"b":4},"c":-1}, 3) &&
               perform_test(1, {"a":[-1,1]}, 0) && perform_test(1, [-1,{"a":1}], 0) &&
               perform_test(1, [], 0) && perform_test(1, {}, 0)

      test_2 = perform_test(2, [1, {"c":"red","b":2}, 3], 4) &&
               perform_test(2, {"d":"red","e":[1,2,3,4],"f":5}, 0) &&
               perform_test(2, [1,"red",5], 6)

      test_1 && test_2
    end
  end
end
