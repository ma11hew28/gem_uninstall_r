#!/usr/bin/env ruby

require './gem_class'

if ARGV.length < 1 then puts "usage: #{__FILE__} GEMNAME"; exit 1 end

gemr = GemClass.new(ARGV.first)

# p gemr.dependencies_r

gemr.uninstall_r
