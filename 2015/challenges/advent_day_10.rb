# --- Day 10: Elves Look, Elves Say ---
# Today, the Elves are playing a game called look-and-say. They take turns making sequences by reading aloud the previous sequence and using that reading as the next sequence. For example, 211 is read as "one two, two ones", which becomes 1221 (1 2, 2 1s).
# Look-and-say sequences are generated iteratively, using the previous value as input for the next step. For each step, take the previous value, and replace each run of digits (like 111) with the number of digits (3) followed by the digit itself (1).

# For example:

# 1 becomes 11 (1 copy of digit 1).
# 11 becomes 21 (2 copies of digit 1).
# 21 becomes 1211 (one 2 followed by one 1).
# 1211 becomes 111221 (one 1, one 2, and two 1s).
# 111221 becomes 312211 (three 1s, two 2s, and one 1).
# Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?

# --- Part Two ---
# Neat, right? You might also enjoy hearing John Conway talking about this sequence (that's Conway of Conway's Game of Life fame).
# Now, starting again with the digits in your puzzle input, apply this process 50 times. What is the length of the new result?

module Advent
  class Day10 < Base
    attr_accessor :cached_result, :times

    def initialize
      self.times = 40
    end

    def input
      1113122113
    end

    def challenge_1(challenge_input=input)
      original_input = challenge_input
      challenge_input = fetch_cache(challenge_input)

      self.times.times do |i|
        split_chunks = challenge_input.to_s.split("").map(&:to_i).slice_when{ |i, j| i != j }.to_a
        challenge_input = split_chunks.collect{ |a| "#{a.length}#{a.first}" }.join
      end

      self.cached_result = { "original" => original_input, "times" => self.times, "input" => challenge_input }
      challenge_input.size
    end

    def fetch_cache(challenge_input)
      unless self.cached_result.nil?
        if self.cached_result["original"] == challenge_input && self.cached_result["times"] < self.times
          self.times = self.times - self.cached_result["times"]
          challenge_input = self.cached_result["input"]
        end
      end
      challenge_input
    end

    def challenge_2(challenge_input=input)
      self.times = 50
      challenge_1(challenge_input)
    end

    # Testing

    def test
      self.times = 1
      perform_test(1, 1, 2) && perform_test(1, 11, 2) && 
      perform_test(1, 21, 4) && perform_test(1, 1211, 6) && 
      perform_test(1, 111221, 6)
    end
  end
end
