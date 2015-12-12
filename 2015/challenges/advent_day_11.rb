# Passwords must include one increasing straight of at least three letters, like abc, bcd, cde,
# and so on, up to xyz. They cannot skip letters; abd doesn't count.
# Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
# Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.

module Advent
  class Day11 < Base
    attr_accessor :input_cache

    def initialize
      @input_cache = {}
    end

    def input
      "vzbxkghb"
    end

    def challenge_1(challenge_input=input)
      original_input = challenge_input
      @input_cache[original_input] = find_next_password(challenge_input) unless @input_cache.has_key?(original_input)
      @input_cache[original_input]
    end

    def challenge_2(challenge_input=input)
      challenge_input = challenge_1(challenge_input)
      challenge_1(challenge_input)
    end

    # Validators

    def find_next_password(challenge_input)
      while !valid?(challenge_input)
        challenge_input = increment_by_one(challenge_input).map(&:chr).join("")
      end
      challenge_input
    end

    def valid?(input)
      has_triple_letters = triple_letter_check(input)
      no_banned_letters = input.match(/(i|o|l)/) == nil
      has_double_letter = input.scan(/(\w)\1/).size >= 2
      has_triple_letters && no_banned_letters && has_double_letter
    end

    def increment_by_one(input)
      ascii = input.split("").map(&:ord).reverse
      ascii.each_with_index do |c, index|
        ascii[index] = c + 1
        if c >= 122
          ascii[index] = 97
        else
          break
        end
      end
      ascii.reverse
    end

    def triple_letter_check(input)
      letter_permutations = [*('a'..'z')].each_cons(3).to_a.map(&:join)
      letter_permutations.any? { |l| input.include?(l) }
    end

    # Testing

    def test
      perform_test(1, "abcdefgh", "abcdffaa")
    end
  end
end
