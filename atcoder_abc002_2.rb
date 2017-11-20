array = gets.chomp.split(//)

a = array.map do |c|
  c unless ["a", "i", "u", "e", "o"].include?(c)
end.join

puts a
