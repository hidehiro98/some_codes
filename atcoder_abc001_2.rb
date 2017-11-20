a = gets.chomp.to_f

b = a / 1000

if b < 0.1
  puts "00"
elsif 0.1 <= b && b <= 5
  puts sprintf("%02d", (b * 10).to_i)
elsif 6 <= b && b <= 30
  puts b.to_i + 50
elsif 35 <= b && b <= 70
  puts ((b - 30) / 5).to_i + 80
elsif b > 70
  puts 89
end
