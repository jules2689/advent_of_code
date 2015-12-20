require 'pry'

module Advent
  class Day18 < Base
    def initialize
      @times = 100
    end

    def input
      File.readlines(File.dirname(__FILE__) + "/data/day18.txt").map(&:chomp)   
    end

    def challenge_1(challenge_input=input)
      game_of_lights(challenge_input, 1)
    end

    def challenge_2(challenge_input=input)
      game_of_lights(challenge_input, 2)
    end

    def game_of_lights(challenge_input, challenge)
      challenge_input = challenge_input.map { |i| i.split("") }

      @times.times do
        new_input = []
        
        challenge_input.each_with_index do |line, row|
          new_input << []
          line.each_with_index do |light, column|
            if always_on?(row, column, challenge, challenge_input)
              new_input[row][column] = "#"
            else
              neighbours_on = check_neighbours(challenge_input, row, column)
              new_light = new_light(light, neighbours_on)
              new_input[row][column] = new_light
            end
          end
        end

        challenge_input = new_input
      end

      challenge_input = challenge_input.map(&:join)
      challenge_input.join.count("#")
    end

    def always_on?(row, column, challenge, challenge_input)
      return false if challenge != 2

      (row == 0 && column == 0) || 
      (row == 0 && column == challenge_input.size - 1) ||
      (row == challenge_input[0].size - 1 && column == 0) || 
      (row == challenge_input[0].size - 1 && column == challenge_input.size - 1)
    end

    def new_light(light, neighbours_on)
      if light == "#"
        neighbours_on == 2 || neighbours_on == 3 ? "#" : "."
      else
        neighbours_on == 3 ? "#" : "."
      end
    end

    ## TO DO SIMPLIFY
    def check_neighbours(challenge_input, row, column)
      neighbours_on = 0

      # left of the light
      if row > 0
        neighbours_on += 1 if challenge_input[row-1][column] == "#"
      end

      if row > 0 && column > 0
        neighbours_on += 1 if challenge_input[row-1][column-1] == "#"
      end

      if row > 0 && column < challenge_input[row].size - 1
        neighbours_on += 1 if challenge_input[row-1][column+1] == "#"
      end

      # right of the light
      if row < challenge_input.size - 1
        neighbours_on += 1 if challenge_input[row+1][column] == "#"
      end

      if row < challenge_input.size - 1 && column > 0
        neighbours_on += 1 if challenge_input[row+1][column-1] == "#"
      end

      if row < challenge_input.size - 1 && column < challenge_input[row].size - 1
        neighbours_on += 1 if challenge_input[row+1][column+1] == "#"
      end

      # Above and Below
      if column > 0
        neighbours_on += 1 if challenge_input[row][column-1] == "#"
      end

      if column < challenge_input[row].size - 1
        neighbours_on += 1 if challenge_input[row][column+1] == "#"
      end

      neighbours_on
    end

    # Testing

    def test
      input = %w(
        .#.#.#
        ...##.
        #....#
        ..#...
        #.#..#
        ####..
      )

      @times = 1
      test_1 = perform_test(1, input, 11)

      @times = 4
      test_2 = perform_test(1, input, 4)

      input = %w(
        ##.#.#
        ...##.
        #....#
        ..#...
        #.#..#
        ####.#
      )

      @times = 1
      test_3 = perform_test(2, input, 18)

      test_1 && test_2 && test_3
    end 
  end
end
