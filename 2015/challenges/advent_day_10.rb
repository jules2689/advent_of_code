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
