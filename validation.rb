module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    extend Acсessors
    attr_accessor_with_history :validations
    def validate(*validation_args)
      self.validations = { name: validation_args[0], type: validation_args[1], options: validation_args[2] }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    def validate!
      validate_parametrs = self.class.validations_history
      validate_parametrs.each do |value|
        if respond_to?("validate_#{value[:type]}!".to_sym) && !instance_variable_get("@#{value[:name]}".to_sym).nil?
          send("validate_#{value[:type]}!".to_sym, instance_variable_get("@#{value[:name]}".to_sym), value[:options])
        else
          next
        end
      end
      true
    end

    def validate_presence!(name, _options)
      raise 'Не может быть nil или пустая строка' if name == '' || name.nil?
    end

    def validate_format!(name, options)
      regular_exp = options
      raise 'Ошибка формата' if name !~ regular_exp
    end

    def validate_type!(name, options)
      raise 'Ошибка класса' if name.class != options
    end
  end
end
