require 'ostruct'
require 'active_support/core_ext/string/inflections'

module Lol
  # DynamicModel extends OpenStruct adding the following features:
  # - nested generation ({a: {}}) results in DynamicModel(a: DynamicModel)
  # - parsing of date/time when property name ends with _at or _date and the value is a number
  class DynamicModel < OpenStruct
    attr_reader :raw

    def initialize(hash={})
      raise ArgumentError, 'An hash is required as parameter' unless hash.is_a? Hash
      @raw = hash
      @table = {}
      @hash_table = {}

      hash.each do |k,v|
        key = k.to_s.underscore
        set_property(key, v)
        define_dynamic_method(key)
      end
    end

    def to_h
      @hash_table
    end

    def as_json(opts={})
      @table.as_json
    end

    protected

    def class_for_property(property)
      self.class
    end

    private

    def define_dynamic_method(name)
      name = name.to_sym
      unless respond_to?(name)
        define_singleton_method(name) { @table[name] }
        define_singleton_method("#{name}=") { |val| @table[name] = val }
      end
    end

    def date_key?(key)
      key.match(/^(.+_)?(at|date)$/)
    end

    def set_property(key, v)
      if date_key?(key) && v.is_a?(Integer)
        @table[key.to_sym] = @hash_table[key.to_sym] = value_to_date(v)
      else
        @table[key.to_sym] = convert_object(v, property: key.to_sym)
        @hash_table[key.to_sym] = v
      end
    end

    def value_to_date(v)
      Time.at(v / 1000)
    end

    def convert_object(obj, property:)
      if obj.is_a? Hash
        class_for_property(property).new obj
      elsif obj.respond_to?(:map)
        obj.map { |o| convert_object o, property: property }
      else
        obj
      end
    end
  end
end
