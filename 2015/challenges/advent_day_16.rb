# --- Day 16: Aunt Sue ---
# Your Aunt Sue has given you a wonderful gift, and you'd like to send her a thank you card. However, there's a small problem: she signed it "From, Aunt Sue".
# You have 500 Aunts named "Sue".
# So, to avoid sending the card to the wrong person, you need to figure out which Aunt Sue (which you conveniently number 1 to 500, for sanity) gave you the gift. You open the present and, as luck would have it, good ol' Aunt Sue got you a My First Crime Scene Analysis Machine! Just what you wanted. Or needed, as the case may be.
# The My First Crime Scene Analysis Machine (MFCSAM for short) can detect a few specific compounds in a given sample, as well as how many distinct kinds of those compounds there are. According to the instructions, these are what the MFCSAM can detect:

# children, by human DNA age analysis.
# cats. It doesn't differentiate individual breeds.
# Several seemingly random breeds of dog: samoyeds, pomeranians, akitas, and vizslas.
# goldfish. No other kinds of fish.
# trees, all in one group.
# cars, presumably by exhaust or gasoline or something.
# perfumes, which is handy, since many of your Aunts Sue wear a few kinds.
# In fact, many of your Aunts Sue have many of these. You put the wrapping from the gift into the MFCSAM. It beeps inquisitively at you a few times and then prints out a message on ticker tape:

# children: 3
# cats: 7
# samoyeds: 2
# pomeranians: 3
# akitas: 0
# vizslas: 0
# goldfish: 5
# trees: 3
# cars: 2
# perfumes: 1
# You make a list of the things you can remember about each Aunt Sue. Things missing from your list aren't zero - you simply don't remember the value.

# What is the number of the Sue that got you the gift?

# --- Part Two ---
# As you're about to send the thank you note, something in the MFCSAM's instructions catches your eye. Apparently, it has an outdated retroencabulator, and so the output from the machine isn't exact values - some of them indicate ranges.
# In particular, the cats and trees readings indicates that there are greater than that many (due to the unpredictable nuclear decay of cat dander and tree pollen), while the pomeranians and goldfish readings indicate that there are fewer than that many (due to the modial interaction of magnetoreluctance).

# What is the number of the real Aunt Sue?

module Advent
  class Day16 < Base

    def input
      File.readlines(File.dirname(__FILE__) + "/data/day16.txt").map(&:chomp)    
    end

    def challenge_1(challenge_input=input)
      sues = map_sues_from_input(challenge_input)
      remove_not_matching(sues, 1).keys.first
    end

    def challenge_2(challenge_input=input)
      sues = map_sues_from_input(challenge_input)
      remove_not_matching(sues, 2).keys.first
    end

    def map_sues_from_input(input)
      sues = {}
      input.each do |sue|
        sue_num = sue.match(/Sue (\d+)\:/)[1]
        attrs = sue.scan(/(\w+)\: (\d+),?/).to_h
        sues[sue_num] = attrs
      end
      sues
    end

    def remove_not_matching(sues, challenge)
      sues.delete_if do |s, attrs|
        matching_sue.collect do |k, v|
          attrs.has_key?(k.to_s) && check_if_matching_value(challenge, k.to_s, attrs[k.to_s].to_i, v.to_i)
        end.any?
      end
    end

    def check_if_matching_value(challenge, key, attr_val, matching_val)
      if challenge == 1
        attr_val != matching_val
      else
        if key == "cats" || key == "trees"
          attr_val <= matching_val
        elsif key == "pomeranians" || key == "goldfish"
          attr_val >= matching_val
        else
          attr_val != matching_val
        end 
      end
    end

    def matching_sue
      { children: 3,
        cats: 7,
        samoyeds: 2,
        pomeranians: 3,
        akitas: 0,
        vizslas: 0,
        goldfish: 5,
        trees: 3,
        cars: 2,
        perfumes: 1 }
    end

    # Testing

    def test
      input = ["Sue 1: cars: 9, akitas: 3, goldfish: 0", "Sue 2: children: 3, akitas: 0, goldfish: 5"]
      perform_test(1, input, 2)
    end 
  end
end
