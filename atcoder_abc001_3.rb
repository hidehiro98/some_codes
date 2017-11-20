deg, dis = gets.chomp.split(" ").map(&:to_f)

deg /= 10
dis = (dis / 60).round(1)

if 11.25 <= deg && deg < 33.75
  deg_result = "NNE"
elsif 33.75 <= deg && deg < 56.25
  deg_result = "NE"
elsif 56.25 <= deg && deg < 78.75
  deg_result = "ENE"
elsif 78.75 <= deg && deg < 101.25
  deg_result = "E"
elsif 101.25 <= deg && deg < 123.75
  deg_result = "ESE"
elsif 123.75 <= deg && deg < 146.25
  deg_result = "SE"
elsif 146.25 <= deg && deg < 168.75
  deg_result = "SSE"
elsif 168.75 <= deg && deg < 191.25
  deg_result = "S"
elsif 191.25 <= deg && deg < 213.75
  deg_result = "SSW"
elsif 213.75 <= deg && deg < 236.25
  deg_result = "SW"
elsif 236.25 <= deg && deg < 258.75
  deg_result = "WSW"
elsif 258.75 <= deg && deg < 281.25
  deg_result = "W"
elsif 281.25 <= deg && deg < 303.75
  deg_result = "WNW"
elsif 303.75 <= deg && deg < 326.25
  deg_result = "NW"
elsif 326.15 <= deg && deg < 348.75
  deg_result = "NNW"
else
  deg_result = "N"
end

if 0.0 <= dis && dis <= 0.2
  dis_result = 0
elsif 0.3 <= dis && dis <= 1.5
  dis_result = 1
elsif 1.6 <= dis && dis <= 3.3
  dis_result = 2
elsif 3.4 <= dis && dis <= 5.4
  dis_result = 3
elsif 5.5 <= dis && dis <= 7.9
  dis_result = 4
elsif 8.0 <= dis && dis <= 10.7
  dis_result = 5
elsif 10.8 <= dis && dis <= 13.8
  dis_result = 6
elsif 13.9 <= dis && dis <= 17.1
  dis_result = 7
elsif 17.2 <= dis && dis <= 20.7
  dis_result = 8
elsif 20.8 <= dis && dis <= 24.4
  dis_result = 9
elsif 24.5 <= dis && dis <= 28.4
  dis_result = 10
elsif 28.5 <= dis && dis <= 32.6
  dis_result = 11
elsif 32.7 <= dis
  dis_result = 12
end

if dis_result == 0
  puts "C 0"
else
  puts "#{deg_result} #{dis_result}"
end
