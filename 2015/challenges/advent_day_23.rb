require 'pry'

module Advent
  class Day23 < Base

    def initialize
    end

    def input
      File.readlines(File.dirname(__FILE__) + "/data/day23.txt").map(&:chomp)
    end

    def challenge_1(challenge_input=input)
      registers = { "a" => 0, "b" => 0 }
      run_program(challenge_input, registers)
    end

    def challenge_2(challenge_input=input)
      registers = { "a" => 1, "b" => 0 }
      run_program(challenge_input, registers)
    end

    def run_program(challenge_input, registers)
      idx = 0

      while idx < challenge_input.size
        instruction = challenge_input[idx]

        case instruction[0..2]
        when 'hlf'
          registers[instruction[4]] = (registers[instruction[4]] / 2).to_i
        when 'tpl'
          registers[instruction[4]] *= 3
        when 'inc'
          registers[instruction[4]] += 1
        when 'jmp'
          idx += instruction[4..-1].to_i
          next
        when 'jie'
          if registers[instruction[4]] % 2 == 0
            idx += instruction[7..-1].to_i
            next
          end
        when 'jio'
          if registers[instruction[4]] == 1
            idx += instruction[7..-1].to_i
            next
          end
        end

        idx += 1
      end

      registers["b"]
    end

    # Testing

    def test
      input = ["inc b", "jio b, +2", "tpl b", "inc b"]
      perform_test(1, input, 2)
    end
  end
end
