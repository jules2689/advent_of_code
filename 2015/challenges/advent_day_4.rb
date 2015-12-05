# --- Day 4: The Ideal Stocking Stuffer ---
# Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.
# To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

# For example:
# If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
# If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....

# --- Part Two ---
# Now find one that starts with six zeroes.

require 'digest/md5'

module Advent
  class Day4 < Base
    def input
      "bgvyzdsv"
    end

    def challenge_1(challenge_input=input)
      search_for_start_token("00000", challenge_input)
    end

    def challenge_2(challenge_input=input)
      search_for_start_token("000000", challenge_input)
    end

    def search_for_start_token(search_key, key)
      answer = -1
      result = ""

      while !result.start_with?(search_key)
        answer = answer + 1
        result = Digest::MD5.hexdigest("#{key}#{answer}")
      end

      answer
    end

    # Testing

    def test
      perform_test(1, "abcdef", 609043) && perform_test(1, "pqrstuv", 1048970)
    end
  end
end
