class Circuit

  attr_accessor :variables, :instructions, :leftovers

  def initialize
    self.variables = []
    self.instructions = {}
    self.leftovers = {}
  end

  def add_instruction(instruction)
    var = instruction.split(" -> ").last
    func = instruction.split(" -> ").first
    self.instructions["#{var}_#{func.downcase.gsub(/\s/,'_')}"] = func
  end

  def calculate
    self.instructions = self.instructions.sort.to_h

    self.instructions.each do |var, instruction|
      idx = var.index('_') - 1
      var = var[0..idx]

      if is_var_assignment?(instruction)
        self.variables << var unless self.variables.include?(var)
        if is_integer?(instruction)
          set(var, instruction)
        else
          self.leftovers[var] = instruction
        end
      end
    end

    self.instructions.each do |var, instruction|
      idx = var.index('_') - 1
      var = var[0..idx]

      if !is_var_assignment?(instruction)
        self.variables << var unless self.variables.include?(var)
        route_var_instruction(instruction, var)
      end
    end

    self.leftovers.each do |var, instruction|
      set(var, get(instruction))
    end

  end

  def get_values
    hash = {}
    self.variables.each do |var|
      hash[var] = get(var)
    end
    hash.sort.to_h
  end

  private

  def set(var, val)
    puts "Assigning #{val} to #{var}"
    instance_variable_set("@#{var}", val)
  end

  def get(var)
    if is_integer?(var)
      v = var.to_i
    else
      v = instance_variable_get("@#{var}").to_i
    end

    v += 0x1_0000 if v < 0
    v
  end

  def is_integer?(val)
    val.to_i.to_s == val
  end

  def is_var_assignment?(func)
    %w( AND OR LSHIFT RSHIFT NOT ).all? { |f| !func.include?(f) }
  end

  def route_var_instruction(instruction, var)
    func = %w( AND OR LSHIFT RSHIFT NOT ).delete_if { |f| !instruction.include?(f) }
    self.send("add_#{func.first.downcase}_instruction", instruction, var)
  end

  # x AND y -> d
  def add_and_instruction(instruction, var)
    first_var = instruction.split(" AND ").first
    second_var = instruction.split(" AND ").last
    puts "AND:: #{var} = #{first_var} and #{second_var}"
    instance_variable_set("@#{var}", get(first_var) & get(second_var))
  end

  # x OR y -> e
  def add_or_instruction(instruction, var)
    first_var = instruction.split(" OR ").first
    second_var = instruction.split(" OR ").last
    puts "OR:: #{var} = #{first_var} or #{second_var}"
    instance_variable_set("@#{var}", get(first_var) | get(second_var))
  end
  
  # NOT y -> i
  def add_not_instruction(instruction, var)
    first_var = instruction.split("NOT ").last
    puts "NOT:: #{var} = !#{first_var}"
    instance_variable_set("@#{var}", ~get(first_var))
  end

  # x LSHIFT 2 -> f
  def add_lshift_instruction(instruction, var)
    first_var = instruction.split(" LSHIFT ").first
    second_var = instruction.split(" LSHIFT ").last
    puts "LSHIFT:: #{var} = #{first_var} << #{second_var}"
    instance_variable_set("@#{var}", get(first_var) << get(second_var))
  end

  # y RSHIFT 2 -> g
  def add_rshift_instruction(instruction, var)
    first_var = instruction.split(" RSHIFT ").first
    second_var = instruction.split(" RSHIFT ").last
    puts "RSHIFT:: #{var} = #{first_var} >> #{second_var}"
    instance_variable_set("@#{var}", get(first_var) >> get(second_var))
  end
end
