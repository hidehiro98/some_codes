puts 'tyep n and q'

a = gets.chomp.split(' ')
n = a[0].to_i
q = a[1].to_i

array = [*('A'..'Z')].take(n)
i = 1

if n == 5
  a = []
  array.permutation(5) { |each_array| a << each_array }

  puts "? #{x} #{y}"
  $stdout.flush

  # b = gets.chomp
  # if b == '<'
  #   -1
  # elsif b == '>'
  #   1
  # end


else
  array_s = array.sort do |x, y|
    # break  if i > q
    i += 1

    puts "? #{x} #{y}"
    $stdout.flush

    b = gets.chomp
    if b == '<'
      -1
    elsif b == '>'
      1
    end
  end
  puts "! #{array_s.join}"
  $stdout.flush
end
