$n, k = gets.chomp.split.map(&:to_i)

$array = []

$n.times do
  $array << gets.chomp.split.map(&:to_i)
end

$done = Array.new($n + 1, [])
$memo = Array.new($n + 1, [])


def search(i, limit_price)
  return $memo[i][limit_price] if $done[i][limit_price]

  if i == $n
    result = 0
  elsif limit_price < $array[i][0]
    result = search(i + 1, limit_price)
  else
    result1 = search(i + 1, limit_price)
    result2 = search(i + 1, limit_price - $array[i][0]) + $array[i][1]
    result = [result1, result2].max
  end

  $done[i][limit_price] = true
  $memo[i][limit_price] = result
  result
end

puts search(0, k)
p $done
p $memo
