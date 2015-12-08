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
      result = result.to_i if result.respond_to?(:to_i)
      passed =  result == answer
      puts format_test_string("Test #{test} => Expecting #{answer} for input #{test_input}. Got #{result}.", passed)
      passed
    end
  end
end
