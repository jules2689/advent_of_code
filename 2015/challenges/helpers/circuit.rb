class Circuit
  attr_accessor :variables, :instructions

  def initialize
    self.variables = []
    self.instructions = {}
  end

  def add_instruction(instruction)
    var = instruction.split(" -> ").last
    func = instruction.split(" -> ").first
    self.instructions[var] = func
  end

  def calculate
    self.instructions = self.instructions.sort.to_h

    self.instructions.each do |var, instruction|
      self.variables << var
      if is_var_assignment?(instruction)
        assign_var(instruction, var)
      else
        route_var_instruction(instruction, var)
      end
    end
  end

  def get_values
    hash = {}
    self.variables.uniq.sort.each do |var|
      hash[var] = get(var)
    end
    hash.sort.to_h
  end

  private

  ##########
  # HELPERS
  ##########

  def get(var)
    if is_integer?(var)
      value = var.to_i
    else
      # Check if we've cached the value, fetch if we haven't then cache
      unless value = instance_variable_get("@#{var}")
        value = self.send(var).to_i
        instance_variable_set("@#{var}", value)
      end
    end

    value += 0x1_0000 if value < 0 # force 16 bit signed
    value
  end

  def is_integer?(val)
    val.to_i.to_s == val
  end

  def is_var_assignment?(func)
    %w( AND OR LSHIFT RSHIFT NOT ).all? { |f| !func.include?(f) }
  end

  def define_method(name, &block)
    self.class.send(:define_method, name, &block)
  end

  def remove_method(name)
    self.class.send(:remove_method, name)
  end

  #####################################
  # VAR ASSIGNMENT AND DYNAMIC METHODS
  #####################################

  def assign_var(instruction, var)
    define_method var do
      if is_integer?(instruction)
        instruction
      else
        get(instruction)
      end
    end
  end

  def route_var_instruction(instruction, var)
    func = %w( AND OR LSHIFT RSHIFT NOT ).delete_if { |f| !instruction.include?(f) }
    self.send("add_#{func.first.downcase}_instruction", instruction, var)
  end

  # x AND y -> d
  def add_and_instruction(instruction, var)
    first_var = instruction.split(" AND ").first
    second_var = instruction.split(" AND ").last

    define_method var do
      get(first_var) & get(second_var)
    end
  end

  # x OR y -> e
  def add_or_instruction(instruction, var)
    first_var = instruction.split(" OR ").first
    second_var = instruction.split(" OR ").last
    
    define_method var do
      get(first_var) | get(second_var)
    end
  end
  
  # NOT y -> i
  def add_not_instruction(instruction, var)
    first_var = instruction.split("NOT ").last

    define_method var do
      ~get(first_var)
    end
  end

  # x LSHIFT 2 -> f
  def add_lshift_instruction(instruction, var)
    first_var = instruction.split(" LSHIFT ").first
    second_var = instruction.split(" LSHIFT ").last

    define_method var do
      get(first_var) << get(second_var)
    end
  end

  # y RSHIFT 2 -> g
  def add_rshift_instruction(instruction, var)
    first_var = instruction.split(" RSHIFT ").first
    second_var = instruction.split(" RSHIFT ").last
    
    define_method var do
      get(first_var) >> get(second_var)
    end
  end

end
