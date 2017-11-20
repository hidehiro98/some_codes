r = gets.chomp.to_i

array = []

r.times do
  array << gets.chop.to_i
end

minv = array[0]
maxv = array[1] - array[0]

array.each_with_index do |num, i|
  next if i.zero?
  maxv = [maxv, array[i] - minv].max
  minv = [minv, array[i]].min
end

puts maxv
