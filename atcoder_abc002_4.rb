n, m = gets.chomp.split.map(&:to_i)

return 1 if m.zero?

pairs = []

m.times do
  b = gets.chomp.split.map(&:to_i)
  pairs << b
end

groups = pairs.take(1)
pairs.delete_at(0)

pairs.each do |pair|
  flag2 = true
  groups.each do |group|
    if group.include?(pair[0]) && group.include?(pair[1])
    elsif group.include?(pair[0]) || group.include?(pair[1])
      if group.include?(pair[0])
        flag = true
        group.each do |element|
          flag = false unless pairs.include?([element, pair[1]].sort)
        end
        if flag
          group << pair[1]
        else
          groups << pair if flag2
          flag2 = false
        end
      else
        flag = true
        group.each do |element|
          flag = false unless pairs.include?([element, pair[0]].sort)
        end
        if flag
          group << pair[0]
        else
          groups << pair if flag2
          flag2 = false
        end
      end
    else
      groups << pair if flag2
      flag2 = false
    end
  end
end

# p pairs
# p groups

puts groups.map { |group| group.size }.max










# http://abc002.contest.atcoder.jp/submissions/1149665
# N, M = gets.split.map(&:to_i)
# R = M.times.each_with_object({}){|_, h| x, y = gets.split.map(&:to_i); h[[x, y].sort] = true}

# puts (2 .. N).select{|n| [*1 .. N].combination(n).any?{|c| c.combination(2).all?{|x, y| R[[x, y].sort]}}}.max || 1
