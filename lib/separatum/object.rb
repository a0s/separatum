class Object
  def is_one_of_a?(*types)
    types.flatten.any? { |t| self.class.to_s == t.to_s }
  end
end
