# --- Day 14: Reindeer Olympics ---
# This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must rest occasionally to recover their energy. Santa would like to know which of his reindeer is fastest, and so he has them race.
# Reindeer can only either be flying (always at their top speed) or resting (not moving at all), and always spend whole seconds in either state.
# For example, suppose you have the following Reindeer:

# Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
# Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
# After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten seconds, Comet has gone 140 km, while Dancer has gone 160 km. On the eleventh second, Comet begins resting (staying at 140 km), and Dancer continues on for a total distance of 176 km. On the 12th second, both reindeer are resting. They continue to rest until the 138th second, when Comet flies for another ten seconds. On the 174th second, Dancer flies for another 11 seconds.

# In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km (poor Dancer has only gotten 1056 km by that point). So, in this situation, Comet would win (if the race ended at 1000 seconds).
# Given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, what distance has the winning reindeer traveled?

# --- Part Two ---
# Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.
# Instead, at the end of each second, he awards one point to the reindeer currently in the lead. (If there are multiple reindeer tied for the lead, they each get one point.) He keeps the traditional 2503 second time limit, of course, as doing otherwise would be entirely ridiculous.
# Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point. He stays in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into the lead and gets his first point. Of course, since Dancer had been in the lead for the 139 seconds before that, he has accumulated 139 points by the 140th second.
# After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312. So, with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

# Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, how many points does the winning reindeer have?

module Advent
  class Day14 < Base

    def initialize
      @times = 2503
    end

    def input
      [ "Rudolph can fly 22 km/s for 8 seconds, but then must rest for 165 seconds.", "Cupid can fly 8 km/s for 17 seconds, but then must rest for 114 seconds.", "Prancer can fly 18 km/s for 6 seconds, but then must rest for 103 seconds.", "Donner can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.", "Dasher can fly 11 km/s for 12 seconds, but then must rest for 125 seconds.", "Comet can fly 21 km/s for 6 seconds, but then must rest for 121 seconds.", "Blitzen can fly 18 km/s for 3 seconds, but then must rest for 50 seconds.", "Vixen can fly 20 km/s for 4 seconds, but then must rest for 75 seconds.", "Dancer can fly 7 km/s for 20 seconds, but then must rest for 119 seconds." ]
    end

    def challenge_1(challenge_input=input)
      reindeer_stats = race(challenge_input)  
      reindeer = reindeer_stats.max_by { |k, v| v[:distance] }
      reindeer.last[:distance]
    end

    def challenge_2(challenge_input=input)
      reindeer_stats = race(challenge_input)  
      reindeer = reindeer_stats.max_by { |k, v| v[:points] }
      reindeer.last[:points]
    end

    def race(challenge_input)
      reindeer_stats = {}
      challenge_input.map { |i| i.gsub(/can fly|km\/s for|seconds|, but then must rest for| \./, '') }.map(&:split).map do |reindeer, speed, move_time, rest|
        reindeer_stats[reindeer] = { speed: speed.to_i, can_move_for: move_time.to_i, rest_time: rest.to_i, moving_for: 0, resting_for: 0, distance: 0, points: 0 }
      end 

      @times.times do
        reindeer_stats.keys.each { |reindeer| process_reindeer_action(reindeer_stats, reindeer) }
        assign_points_to_leading_reindeer(reindeer_stats)
      end

      reindeer_stats
    end

    def process_reindeer_action(reindeer_stats, reindeer)
      # If the reindeer can still move, then move
      if reindeer_stats[reindeer][:moving_for] < reindeer_stats[reindeer][:can_move_for]
        reindeer_stats[reindeer][:moving_for] += 1
        reindeer_stats[reindeer][:distance] += reindeer_stats[reindeer][:speed]

      # If the reindeer can still rest, then rest
      elsif reindeer_stats[reindeer][:resting_for] < reindeer_stats[reindeer][:rest_time]
        reindeer_stats[reindeer][:resting_for] += 1

      # If the reindeer has finished moving and resting, then reset and move
      else
        reindeer_stats[reindeer][:moving_for] = 0
        reindeer_stats[reindeer][:resting_for] = 0
        process_reindeer_action(reindeer_stats, reindeer)
      end
    end

    def assign_points_to_leading_reindeer(reindeer_stats)
      max_distance = reindeer_stats.max_by { |k, v| v[:distance] }.last[:distance]
      reindeer_stats.select { |k,v| reindeer_stats[k][:distance] == max_distance }.keys.each do |reindeer|
        reindeer_stats[reindeer][:points] += 1
      end
    end

    # Testing

    def test
      input = [ "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.", "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds." ]
      @times = 1000
      perform_test(1, input, 1120) && perform_test(2, input, 689)
    end
  end
end
