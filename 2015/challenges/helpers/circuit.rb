class Circuit
  attr_accessor :variables

  def initialize
    self.variables = []
  end

  def add_instruction(instruction)
    var = instruction.split(" -> ").last
    instruction = instruction.split(" -> ").first

    self.variables << var
    define_var_instruction(instruction, var)
  end

  def get_values
    hash = {}
    self.variables.uniq.sort.each do |var|
      hash[var] = get_value(var)
    end
    hash.sort.to_h
  end

  private

  def get_value(var)
    transform!(var)
    value = self.send(var)
    value += 0x1_0000 if value < 0 # force 16 bit signed
    value
  end

  TRANSFORMS = {
    "LSHIFT"         => "<<",
    "RSHIFT"         => ">>",
    "NOT"            => "~",
    "AND"            => "&",
    "OR"             => "|",
    /\b(if|do|in)\b/ => "\\1_circuit" # keywords
  }

  def define_var_instruction(instruction, var)
    transform!(instruction)
    transform!(var)

    method = "def #{var}; @#{var} ||= #{instruction}; end"
    instance_eval(method)
  end

  def transform!(val)
    TRANSFORMS.each do |from, to|
      val.gsub!(from, to)
    end
  end

end
