#!/usr/bin/env ruby

require 'securerandom'

def generate_password(length: 12, uppercase: true, lowercase: true, numbers: true, symbols: true)
  character_sets = []
  character_sets << ('A'..'Z').to_a if uppercase
  character_sets << ('a'..'z').to_a if lowercase
  character_sets << ('0'..'9').to_a if numbers
  character_sets << ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '='] if symbols

  if character_sets.empty?
    puts "Error: You must select at least one character set!"
    exit
  end

  all_characters = character_sets.flatten

  password = ""
  length.times do
    password << all_characters.sample(random: SecureRandom)
  end

  password
end

# === Interactive part ===
puts "Welcome to the Ruby Password Generator!"
print "Desired password length (default 12): "
length = gets.strip.to_i
length = 12 if length <= 0

print "Include uppercase letters? (Y/n): "
uppercase = gets.strip.downcase != 'n'

print "Include lowercase letters? (Y/n): "
lowercase = gets.strip.downcase != 'n'

print "Include numbers? (Y/n): "
numbers = gets.strip.downcase != 'n'

print "Include symbols? (Y/n): "
symbols = gets.strip.downcase != 'n'

password = generate_password(
  length: length,
  uppercase: uppercase,
  lowercase: lowercase,
  numbers: numbers,
  symbols: symbols
)

puts "\nGenerated Password:\n#{password}"
