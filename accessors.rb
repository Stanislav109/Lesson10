module Acсessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      array = []
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        array << value
      end
      define_method("#{name}_history".to_sym) { array }
    end
  end

  def strong_attr_accessor(attr_name, class_name)
    var_name = "@#{attr_name}".to_sym
    define_method(attr_name) { instance_variable_get(var_name) }
    define_method("#{attr_name}=".to_sym) do |value|
      raise "Несовпадающий класс: #{class_name} " if self.class != class_name
      instance_variable_set(var_name, value)
    end
  end
end

