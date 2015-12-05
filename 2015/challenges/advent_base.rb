module Advent
  class Base

    def input
    end

    def challenge_1(challenge_input=input)
    end

    def challenge_2(challenge_input=input)
    end

    # Testing

    def test
    end

    def perform_test(test, test_input, answer)
      result = test == 1 ? challenge_1(test_input) : challenge_2(test_input)
      passed = result.to_i == answer
      puts format_test_string("Expecting #{answer} for input #{test_input}. Got #{result}.", passed)
      passed
    end
  end
end
