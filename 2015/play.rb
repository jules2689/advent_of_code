#!/usr/bin/env ruby

Dir[File.dirname(__FILE__) + '/2015/challenges/*.rb'].each {|file| require file }

classes = Advent.constants.select {|c| Advent.const_get(c).is_a? Class}
restriction = ARGV[0]

classes.each do |advent_class|
  if restriction.nil? || advent_class.to_s == restriction
    challenge = Advent::const_get(advent_class).new
    puts advent_class.to_s
    puts "Challenge 1: #{challenge.challenge_1}"
    puts "Challenge 2: #{challenge.challenge_2}"
    puts "====================\n"
  end
end
