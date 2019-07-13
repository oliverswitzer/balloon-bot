#!/usr/bin/env ruby

$: << '.'
$: << '../lib'
$: << '../ext'

require 'oj'

f = File.open("foo.json", "w")
100_000.times do
 obj = { created_at: DateTime.new(2001,2,3,4,5,6) }
 Oj.to_stream(f, obj)
 f.puts
 f.flush
end
f.close

def run_test_thread
  threads = Array.new(3) do
    Thread.new do 
      counter = 0
      File.open("foo.json", "r") { |f| Oj.enum_for(:load, f).lazy.each { counter += 1 } }
      #File.open("odd_file.jsonl", "r") { |f| Oj.enum_for(:load, f).lazy.each { counter += 1 } }
      puts counter
    end
  end
  threads.each(&:join)
end

100.times do |i|
  puts i
  run_test_thread
end
