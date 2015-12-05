#!/usr/bin/env ruby

require 'date'
require 'stringio'
Dir[File.dirname(__FILE__) + '/challenges/*.rb'].each {|file| require file }
require File.dirname(__FILE__) + '/advent_runner.rb'

# Colorize helpers
def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m\e[37m"; end
def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def format_test_string(text, pass); pass ? green(text) : red(text); end

AdventRunner.run_all_classes
