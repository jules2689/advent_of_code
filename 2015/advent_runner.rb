class AdventRunner

  def self.run_all_classes
    classes_to_run = Advent.constants.select {|c| Advent.const_get(c).is_a? Class}
    restriction = ARGV[0]
    
    classes_to_run.reject! { |a| !should_run_class?(restriction, a) }
    classes_to_run = classes_to_run.sort { |x, y| y.to_s.gsub('Day','').to_i <=> x.to_s.gsub('Day','').to_i }
    classes_to_run.reverse!
    all_passed = true

    classes_to_run.each do |advent_class|
      challenge = Advent::const_get(advent_class).new
      
      start_time = Time.now
      output = is_testing ? run_tests(challenge) : run_challenge(challenge)
      all_passed = all_passed && output.include?("Test Passed: true")
      end_time = Time.now
      output_results(challenge, output, start_time, end_time)
    end

    puts format_test_string("=================\nAll Passed: #{all_passed}", all_passed) if is_testing
  end

private

  def self.should_run_class?(restriction, advent_class)
    is_restricted = !(restriction.nil? || restriction == "test" || advent_class.to_s == restriction) 
    is_base_class = advent_class.to_s == "Base"
    !is_restricted && !is_base_class
  end

  def self.is_testing
    (!ARGV[1].nil? && ARGV[1].downcase == "test") || (!ARGV[0].nil? && ARGV[0].downcase == "test")
  end

  STOP_OUTPUT = true
  def self.run_tests(challenge)
    if STOP_OUTPUT
      $stdout = StringIO.new # override stdout for the tests to defer printing results
      tests = challenge.test
      test_passed_line = format_test_string("Test Passed: #{tests}", tests)
      output = "#{$stdout.string}\n#{test_passed_line}"
      $stdout = STDOUT # Put back origin STDOUT
      output
    else
      tests = challenge.test
    end
  end

  def self.run_challenge(challenge)
    challenge_1 = challenge.challenge_1
    challenge_2 = challenge.challenge_2
    "Challenge 1: #{challenge_1}\nChallenge 2: #{challenge_2}"
  end

  def self.output_results(challenge, output, start_time, end_time)
    # Determine what needs to be output
    separator = "=" * 60
    class_name = challenge.class.name.to_s
    run_time = "#{(end_time - start_time).to_f}s"
    class_time_separator = " " * (separator.size - class_name.size - run_time.size)

    # Output the results
    puts "\n" + separator
    puts class_name + class_time_separator + run_time
    puts separator
    puts output
    puts 
  end

end
