# --- Day 15: Science for Hungry People ---
# Today, you set out on the task of perfecting your milk-dunking cookie recipe. All you have to do is find the right balance of ingredients.
# Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a list of the remaining ingredients you could use to finish the recipe (your puzzle input) and their properties per teaspoon:

# capacity (how well it helps the cookie absorb milk)
# durability (how well it keeps the cookie intact when full of milk)
# flavor (how tasty it makes the cookie)
# texture (how it improves the feel of the cookie)
# calories (how many calories it adds to the cookie)
# You can only measure ingredients in whole-teaspoon amounts accurately, and you have to be accurate so you can reproduce your results in the future. The total score of a cookie can be found by adding up each of the properties (negative totals become 0) and then multiplying together everything except calories.

# For instance, suppose you have these two ingredients:

# Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
# Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each ingredient must add up to 100) would result in a cookie with the following properties:

# A capacity of 44*-1 + 56*2 = 68
# A durability of 44*-2 + 56*3 = 80
# A flavor of 44*6 + 56*-2 = 152
# A texture of 44*3 + 56*-1 = 76
# Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of 62842880, which happens to be the best score possible given these ingredients. If any properties had produced a negative total, it would have instead become zero, causing the whole score to multiply to zero.

# Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie you can make?

# --- Part Two ---
# Your cookie recipe becomes wildly popular! Someone asks if you can make another recipe that has exactly 500 calories per cookie (so they can use it as a meal replacement). Keep the rest of your award-winning process the same (100 teaspoons, same ingredients, same scoring system).
# For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60 teaspoons of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500. The total score would go down, though: only 57600000, the best you can do in such trying circumstances.
# Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie you can make with a calorie total of 500?

module Advent
  class Day15 < Base

    def initialize
      @cache = {}
    end

    def input
      ['Sprinkles: capacity 5, durability -1, flavor 0, texture 0, calories 5', 'PeanutButter: capacity -1, durability 3, flavor 0, texture 0, calories 1','Frosting: capacity 0, durability -1, flavor 4, texture 0, calories 6', 'Sugar: capacity -1, durability 0, flavor 0, texture 2, calories 8']
    end

    def challenge_1(challenge_input=input)
      calculate_optimal_cookie(challenge_input)
    end

    def challenge_2(challenge_input=input)
      calculate_optimal_cookie(challenge_input, 500)
    end

    def calculate_optimal_cookie(challenge_input, req_calories=-1)
      ingredients = extract_ingredients(challenge_input)

      # Find Calories algorithm && Cookie algorithm
      calories = ingredients.collect { |k,v| v[:calories] }.map.with_index{ |x, i| form_eq(x, i) }
      algorithm = [:capacity, :durability, :flavor, :texture].collect do |cookie_attr|
        ingredients.collect { |k,v| v[cookie_attr] }.map.with_index{ |x, i| form_eq(x, i) }
      end.map { |a| "(#{a.reject(&:nil?).join(" + ")})" }

      # Letters for mapping && All combinations of letters
      letters = ("a".."z").to_a
      combinations = find_combinations(ingredients.size)
      
      # Find best cookie
      combinations.collect do |combo|
        unless skip_due_to_calories?(calories, combo, req_calories)
          if @cache["#{algorithm.inspect}_#{combo.inspect}"].nil?
            calculate(combo, algorithm, ingredients, letters)
          else
            @cache["#{algorithm.inspect}_#{combo.inspect}"]
          end
        end
      end.reject(&:nil?).max
    end

    # Find all possible combinations of "split_count" digits that add up to 100
    def find_combinations(num_digits)
      (0..100).flat_map do |x|
        (0..100-x).flat_map do |y|
          (0..100-x-y).map do |z|
            [x, y, z, 100-x-y-z]
          end
        end
      end
    end

    # Extract ingredient config from input
    def extract_ingredients(input)
      ingredients = {}
      input.map do |ingredient|
        matches = ingredient.match(/(.*): \w* (-?\d+), \w* (-?\d+), \w* (-?\d+), \w* (-?\d+), \w* (-?\d+)/)
        ingredients[matches[1]] = { capacity: matches[2].to_i, durability: matches[3].to_i, flavor: matches[4].to_i, texture: matches[5].to_i, calories: matches[6].to_i }
      end
      ingredients
    end

    # Transform number into a proper math eq'n component
    def form_eq(x, i)
      letters = ("a".."z").to_a

      if x == 0
        nil
      elsif x < 0
        "-" + (x * -1).to_s + "*" + letters[i]
      elsif x > 0
        x.to_s + "*" + letters[i]
      end
    end

    # Calculate score for cookie config
    def calculate(combo, algorithm, ingredients, letters)
      result = algorithm.collect do |part|
        dup_part = part.dup
        ingredients.size.times { |i| dup_part.gsub!(/#{letters[i]}/, combo[i].to_s) }
        result = eval(dup_part)
        result <= 0 ? 0 : result
      end.inject(&:*)
      @cache["#{algorithm.inspect}_#{combo.inspect}"] = result
      result
    end

    # Determine if the config needs to be skipped due to calorie constraint
    def skip_due_to_calories?(calories_components, combo, req_calories)
      return false if req_calories < 0

      letters = ("a".."z").to_a      
      result = calories_components.collect do |part|
        dup_part = part.dup
        calories_components.size.times { |i| dup_part.gsub!(/#{letters[i]}/, combo[i].to_s) }
        result = eval(dup_part)
        result <= 0 ? 0 : result
      end.inject(&:+)

      result != req_calories
    end

    # Testing

    def test
      input = [ "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8", "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3" ]
      perform_test(2, input, 57600000)
    end
  end
end
