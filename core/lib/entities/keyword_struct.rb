# Allows for using keyword arguments with Struct instead of order dependent args
#
# Usage:
#
# SomeStruct = KeywordStruct.new(:attribute_one, :attribute_two)
# struct_instance = SomeStruct.new(attribute_one: 'hello', attribute_two: 'world')

class KeywordStruct < Struct
  def initialize(**kwargs)
    super(*members.map{|k| kwargs[k] })
  end
end