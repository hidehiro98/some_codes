n = gets.chomp.to_i
array = [0, 0]

n.times do
  tmp = gets.chomp.split.map(&:to_i)
  array = tmp if tmp[0] > array[0]
end

puts array[0] + array[1]
