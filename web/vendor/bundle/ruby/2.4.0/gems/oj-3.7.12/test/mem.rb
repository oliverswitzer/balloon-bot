#!/usr/bin/env ruby

$: << '.'
$: << '../lib'
$: << '../ext'

require 'objspace'
require 'oj'
require 'json'
require 'get_process_mem'

def record_allocation
  GC.start
  GC.start

  mem = GetProcessMem.new
  puts "Before - Process Memory: #{mem.mb} mb"
  puts "Before - Objects count: #{ObjectSpace.each_object.count}"
  puts "Before - Symbols count: #{Symbol.all_symbols.size}"

  yield

  GC.start
  GC.start
  GC.start

  puts "After - Process Memory: #{mem.mb} mb"
  puts "After - Objects count: #{ObjectSpace.each_object.count}"
  puts "After - Symbols count: #{Symbol.all_symbols.size}"
end

record_allocation do
  data = 1_000_000.times.map { |i| "string_number_#{i}".to_sym } # array of symbols
  Oj.dump(data, mode: :rails)
end
