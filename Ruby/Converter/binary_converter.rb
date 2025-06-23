#!/usr/bin/env ruby

def binary_to_decimal(bin)
  bin.to_i(2)
end

def decimal_to_binary(dec)
  dec.to_i.to_s(2)
end

def decimal_to_hex(dec)
  dec.to_i.to_s(16).upcase
end

def hex_to_decimal(hex)
  hex.to_i(16)
end

def binary_to_hex(bin)
  decimal_to_hex(binary_to_decimal(bin))
end

def hex_to_binary(hex)
  decimal_to_binary(hex_to_decimal(hex))
end

def menu
  puts "\n--- Binary Converter ---"
  puts "1. Binary to Decimal"
  puts "2. Binary to Hexadecimal"
  puts "3. Decimal to Binary"
  puts "4. Decimal to Hexadecimal"
  puts "5. Hexadecimal to Decimal"
  puts "6. Hexadecimal to Binary"
  puts "7. Exit"
  print "Choose an option (1-7): "
  gets.strip.to_i
end

loop do
  choice = menu

  case choice
  when 1
    print "Enter binary number: "
    bin = gets.strip
    puts "Decimal: #{binary_to_decimal(bin)}"
  when 2
    print "Enter binary number: "
    bin = gets.strip
    puts "Hexadecimal: #{binary_to_hex(bin)}"
  when 3
    print "Enter decimal number: "
    dec = gets.strip
    puts "Binary: #{decimal_to_binary(dec)}"
  when 4
    print "Enter decimal number: "
    dec = gets.strip
    puts "Hexadecimal: #{decimal_to_hex(dec)}"
  when 5
    print "Enter hexadecimal number: "
    hex = gets.strip
    puts "Decimal: #{hex_to_decimal(hex)}"
  when 6
    print "Enter hexadecimal number: "
    hex = gets.strip
    puts "Binary: #{hex_to_binary(hex)}"
  when 7
    puts "Goodbye!"
    break
  else
    puts "Invalid option. Please try again."
  end
end
