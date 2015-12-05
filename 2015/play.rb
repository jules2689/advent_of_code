#!/usr/bin/env ruby

require 'date'
require 'stringio'
Dir[File.dirname(__FILE__) + '/challenges/*.rb'].each {|file| require file }

# Colorize helpers
def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m\e[37m"; end
def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def format_test_string(text, pass); pass ? green(text) : red(text); end

classes_to_run = Advent.constants.select {|c| Advent.const_get(c).is_a? Class}
restriction = ARGV[0]
is_testing = (!ARGV[1].nil? && ARGV[1].downcase == "test") || (!ARGV[0].nil? && ARGV[0].downcase == "test")

classes_to_run.each do |advent_class|
  if (restriction.nil? || restriction == "test" || advent_class.to_s == restriction) && advent_class.to_s != "Base"
    challenge = Advent::const_get(advent_class).new
    
    # Run the challenge (or tests)
    start_time = Time.now
    if is_testing
      $stdout = StringIO.new # override stdout for the tests to defer printing results
      tests = challenge.test
      test_pass_line = format_test_string("Test Passed: #{tests}", tests)
      output = "#{$stdout.string}\n#{test_pass_line}"
      $stdout = STDOUT
    else
      challenge_1 = challenge.challenge_1
      challenge_2 = challenge.challenge_2
      output = "Challenge 1: #{challenge_1}\nChallenge 2: #{challenge_2}"
    end
    end_time = Time.now

    # Determine what needs to be output
    separator = "============================================================="
    class_name = advent_class.to_s
    run_time = "#{(end_time - start_time).to_f}s"
    class_time_separator = " " * (separator.size - class_name.size - run_time.size)

    # Output the results
    puts "\n" + separator
    puts class_name + class_time_separator + run_time
    puts separator
    puts output
  end
end
