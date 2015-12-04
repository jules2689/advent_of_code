#!/usr/bin/env ruby

Dir[File.dirname(__FILE__) + '/challenges/*.rb'].each {|file| require file }

classes = Advent.constants.select {|c| Advent.const_get(c).is_a? Class}
restriction = ARGV[0]
is_testing = (!ARGV[1].nil? && ARGV[1].downcase == "test") || (!ARGV[0].nil? && ARGV[0].downcase == "test")

classes.each do |advent_class|
  if restriction.nil? || restriction == "test" || advent_class.to_s == restriction
    challenge = Advent::const_get(advent_class).new
    puts advent_class.to_s
    if is_testing
      puts "Test Passed: #{challenge.test}"
    else
      puts "Challenge 1: #{challenge.challenge_1}"
      puts "Challenge 2: #{challenge.challenge_2}"
    end
    puts "====================\n"
  end
end
