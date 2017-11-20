class Fixnum
  def separate(int)
    result = []
    while int > 0
      if int == 1
        result << Array.new(self, 1)
      elsif int == self
        result << [int]
      elsif int < self
        [int].product((self - int).separate(int)).map(&:flatten).each { |arr| result << arr }
      end
      int -= 1
    end
    result
  end
end

# a = 4.separate(3)
# p a
# b = 10.separate(3)
# p b


def separate(sum, int)
  result = []
  while int > 0
    if int == 1
      result << Array.new(sum, 1)
    elsif int == sum
      result << [int]
    elsif int < sum
      [int].product(separate((sum - int), int)).map(&:flatten).each { |arr| result << arr }
    end
    int -= 1
  end
  result
end

c = separate(15, 6)
p c
# d = separate(40, 25)
# p d
# e = separate(20, 20)
# p e
