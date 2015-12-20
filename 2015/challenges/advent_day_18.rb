# --- Day 18: Like a GIF For Your Yard ---
# After the million lights incident, the fire code has gotten stricter: now, at most ten thousand lights are allowed. You arrange them in a 100x100 grid.
# Never one to let you down, Santa again mails you instructions on the ideal lighting configuration. With so few lights, he says, you'll have to resort to animation.
# Start by setting your lights to the included initial configuration (your puzzle input). A # means "on", and a . means "off".
# Then, animate your grid in steps, where each step decides the next configuration based on the current one. Each light's next state (either on or off) depends on its current state and the current states of the eight lights adjacent to it (including diagonals). Lights on the edge of the grid might have fewer than eight neighbors; the missing ones always count as "off".

# For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through 8, and the light marked B, which is on an edge, only has the neighbors marked 1 through 5:

# 1B5...
# 234...
# ......
# ..123.
# ..8A4.
# ..765.
# The state a light should have next is based on its current state (on or off) plus the number of neighbors that are on:

# A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
# A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
# All of the lights update simultaneously; they all consider the same current state before moving to the next.

# Here's a few steps from an example configuration of another 6x6 grid:

# Initial state:
# .#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####..

# After 1 step:
# ..##..
# ..##.#
# ...##.
# ......
# #.....
# #.##..

# After 2 steps:
# ..###.
# ......
# ..###.
# ......
# .#....
# .#....

# After 3 steps:
# ...#..
# ......
# ...#..
# ..##..
# ......
# ......

# After 4 steps:
# ......
# ......
# ..##..
# ..##..
# ......
# ......
# After 4 steps, this example has four lights on.

# In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?

# --- Part Two ---

# You flip the instructions over; Santa goes on to point out that this is all just an implementation of Conway's Game of Life. At least, it was, until you notice that something's wrong with the grid of lights you bought: four lights, one in each corner, are stuck on and can't be turned off. The example above will actually run like this:

# Initial state:
# ##.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####.#

# After 1 step:
# #.##.#
# ####.#
# ...##.
# ......
# #...#.
# #.####

# After 2 steps:
# #..#.#
# #....#
# .#.##.
# ...##.
# .#..##
# ##.###

# After 3 steps:
# #...##
# ####.#
# ..##.#
# ......
# ##....
# ####.#

# After 4 steps:
# #.####
# #....#
# ...#..
# .##...
# #.....
# #.#..#

# After 5 steps:
# ##.###
# .##..#
# .##...
# .##...
# #.#...
# ##...#
# After 5 steps, this example now has 17 lights on.

# In your grid of 100x100 lights, given your initial configuration, but with the four corners always in the on state, how many lights are on after 100 steps?


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
