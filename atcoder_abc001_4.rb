# this programme only pass the tests partial

a = []
result = []

n = gets.chomp.to_i

n.times do
  b = gets.chomp
  temp_array = []
  temp_array2 = []

  temp_array = b.split("-").map(&:to_i)

  temp_array.each_with_index do |num, index|
    if (num % 5).zero?
      temp_array2 << num
    else
      if index.zero?
        temp_array2 << (num / 5) * 5
      else
        if 55 < (num % 100) && (num % 100) < 60
          temp_array2 << (num / 100 + 1) * 100
        else
          temp_array2 << ((num + 4) / 5) * 5
        end
      end
    end
  end
  a << temp_array2
end

a.sort!

a.each_with_index do |arr, index|
  if index.zero?
    result << arr
  elsif result[-1][1] >= arr[0]
    result[-1][1] = arr[1] if result[-1][1] < arr[1]
  else
    result << arr
  end
end

result.each do |arr|
  arr2 = arr.map do |e|
    sprintf("%04d", e)
  end
  puts arr2.join("-")
  $stdout.flush
end
