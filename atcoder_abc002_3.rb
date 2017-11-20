xa, ya, xb, yb, xc, yc = gets.chomp.split.map(&:to_f)

result = ((xb - xa) * (yc - ya) - (yb - ya) * (xc - xa)) / 2

puts result < 0 ? -result : result
