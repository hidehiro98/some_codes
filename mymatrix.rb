#!/usr/bin/ruby -s
# -*- Ruby -*-

# �֥ץ���ߥ󥰤Τ������������ץ���ץ륳����
# (ʿ���¹�, �ٸ�, �������, 2004. ISBN 4-274-06578-2)
# http://ssl.ohmsha.co.jp/cgi-bin/menu.cgi?ISBN=4-274-06578-2

# $Id: mymatrix.rb,v 1.13 2004/10/06 09:18:00 hira Exp $

# Copyright (c) 2004, HIRAOKA Kazuyuki <hira@ics.saitama-u.ac.jp>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice,this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of the HIRAOKA Kazuyuki nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#########################################################

# �ֲø��軻�פ��LU ʬ��ˤ��չ��󡦰켡�������פγؽ��ѥ����ɤǤ�.
# �����ޤǤ�, �׻����򼨤��Τ���Ū.
# ���Ѥˤ�, matrix.rb (ruby ��ɸ��ź��)�ʤɤ�Ȥ������ɤ��Ǥ��礦.

# Ruby �Ȥ��γ��ͤ�:
#
# �����ʤ���. Ruby �餷������������򤱤Ƥ��ޤ�.
# ��ɸ�ϡ֤Ǥ������¿���οͤ��ɤ�Ǥ狼��פʤΤ�.

# Ruby �Ȥ��Ǥʤ����ͤ�:
#
# ��ư�����������ɡפȤ����ɤ�Ǥ�������.
# �����᥸�㡼�ʸ����Ȥä��и��������, ��������Ǥ���Ȼפ��ޤ�
# (�ܵ��� Ruby ������ʤ������ʤ���Τ��ȸ�򤷤ʤ��褦�ˤ������ꤤ���ޤ�).
# ���ƤΤȤ���, ��#�פ�������ޤǤϥ����ȤǤ�.
#
# ���ϡ��ä˸����¸����ʬ��. ��Ȥϵ��ˤ��ʤ��ƹ����ޤ���.
# ���ʤ����, �Ȥ���������ǧ���Ƥ�������.

#########################################################
# ��Usage

def matrix_usage()
  name = File::basename $0
  print <<EOU
#{name}: ����׻��Υ���ץ륳����
(�Ƽ�ƥ���)
  #{name} -t=make   �� ����
  #{name} -t=print  �� ɽ��
  #{name} -t=arith  �� �¡�����ܡ���
  #{name} -t=op     �� + - *
  #{name} -t=lu    �� LU ʬ��
  #{name} -t=det    �� ����
  #{name} -t=sol    �� ϢΩ�켡������
  #{name} -t=inv    �� �չ���
  #{name} -t=plu    �� LU ʬ�� (pivoting �Ĥ�)
EOU
end

def matrix_test(section)
  standalone = (__FILE__ == $0)  # ľ�ܵ�ư��(¾���� load ���줿�ΤǤʤ�)
  matched = (section == $t)  # -t=���� �� section �����פ��뤫
  return (standalone and matched)
end

if (matrix_test(nil)) # ľ�ܵ�ư���� -t �ʤ��ξ��ϡ�
  matrix_usage()
end

#########################################################
# ���٥��ȥ롦����������ȥ�������

# �������ϰϥ����å��ϥ��ܥ�

### �٥��ȥ�

class MyVector
  def initialize(n)
    @a = Array::new(n)
    for i in 0...n
      @a[i] = nil
    end
  end
  def [](i)
    return @a[i-1]
  end
  def []=(i, x)
    @a[i-1] = x
  end
  def dim
    return @a.length
  end
end

def make_vector(dim)
  return MyVector::new(dim)
end
def vector(elements)
  dim = elements.length
  vec = make_vector(dim)
  for i in 1..dim
    vec[i] = elements[i-1]
  end
  return vec
end
def vector_size(vec)
  return vec.dim
end
def vector_copy(vec)
  dim = vector_size(vec)
  new_vec = make_vector(dim)
  for i in 1..dim
    new_vec[i] = vec[i]
  end
  return new_vec
end

### ����

class MyMatrix
  def initialize(m, n)
    @a = Array::new(m)
    for i in 0...m
      @a[i] = Array::new(n)
      for j in 0...n
        @a[i][j] = nil
      end
    end
  end
  def [](i, j)
    return @a[i-1][j-1]
  end
  def []=(i, j, x)
    @a[i-1][j-1] = x
  end
  def dim
    return @a.length, @a[0].length
  end
end

def make_matrix(rows, cols)
  return MyMatrix::new(rows, cols)
end
def matrix(elements)
  rows = elements.length
  cols = elements[0].length
  mat = make_matrix(rows, cols)
  for i in 1..rows
    for j in 1..cols
      mat[i,j] = elements[i-1][j-1]
    end
  end
  return mat
end
def matrix_size(mat)
  return mat.dim
end
def matrix_copy(mat)
  rows, cols = matrix_size(mat)
  new_mat = make_matrix(rows, cols)
  for i in 1..rows
    for j in 1..cols
      new_mat[i,j] = mat[i,j]
    end
  end
  return new_mat
end

### ��

if (matrix_test('make'))
  puts('- vector -')  # �� ��- vector -�פ�ɽ�����Ʋ���

  puts('Make vector v = [2,9,4]^T, show v[2] and size of v.')
  v = make_vector(3)  # 3 �����ĥ٥��ȥ������
  v[1] = 2
  v[2] = 9
  v[3] = 4
  puts(v[2])  # �� 9 ��ɽ�����Ʋ���
  puts(vector_size(v))  # �� 3 (����)

  puts('Make vector w = [2,9,4]^T and show w[2].')
  w = vector([2,9,4])  # Ʊ���٥��ȥ������������ˡ
  puts(w[2])  # �� 9

  puts('Copy v to x and show x[2].')
  x = vector_copy(v)  # ʣ��
  puts(x[2])  # �� 9
  puts('Modify x[2] and show x[2] again.')
  x[2] = 0
  puts(x[2])  # �� 0
  puts('Original v[2] is not modified.')
  puts(v[2])  # �� 9

  puts('- matrix -')

  puts('Make matrix A = [[2 9 4] [7 5 3]] and show a[2,1].')
  a = make_matrix(2, 3)  # 2��3 ���������
  a[1,1] = 2
  a[1,2] = 9
  a[1,3] = 4
  a[2,1] = 7
  a[2,2] = 5
  a[2,3] = 3
  puts(a[2,1])  # �� 7
  puts('Show size of A.')
  rows, cols = matrix_size(a)  # a �Υ����������
  puts(rows)  # �� 2
  puts(cols)  # �� 3

  puts('Make matrix B = [[2 9 4] [7 5 3]] and show b[2,1].')
  b = matrix([[2,9,4], [7,5,3]])  # Ʊ�����������������ˡ
  puts(b[2,1])  # �� 7

  puts('Copy A to C and show c[2,1].')
  c = matrix_copy(a)  # ʣ��
  puts(c[2,1])  # �� 7
  puts('Modify c[2,1] and show c[2,1] again.')
  c[2,1] = 0
  puts(c[2,1])  # �� 0
  puts('Original a[2,1] is not modified.')
  puts(a[2,1])  # �� 7
end

#########################################################
# �٥��ȥ롦�����ɽ��

# �٥��ȥ��ɽ������ؿ� vector_print �����. �Ȥ�������򻲾�.
def vector_print(vec)
  dim = vector_size(vec)
  for i in 1..dim  # i = 1, 2, ..., dim �ˤĤ��ƥ롼�� (end �ޤ�)
    printf('%5.4g ', vec[i])  # 5ʸ��ʬ��������ݤ���4��ޤ�ɽ��
    puts('')  # ����
  end
  puts('')
end

def matrix_print(mat)
  rows, cols = matrix_size(mat)
  for i in 1..rows
    for j in 1..cols
      printf('%5.4g ', mat[i,j])
    end
    puts('')
  end
  puts('')
end

# ����������vector_print�ס�matrix_print�פ�Ĺ���Τǡ�
def vp(mat)
  vector_print(mat)
end
def mp(mat)
  matrix_print(mat)
end

### ��

if (matrix_test('print'))
  puts('Print vector [3,1,4]^T twice.')
  v = vector([3,1,4])
  vector_print(v)
  vp(v)
  puts('Print matrix [[2 9 4] [7 5 3]] twice.')
  a = matrix([[2,9,4], [7,5,3]])
  matrix_print(a)
  mp(a)
end

#########################################################
# �٥��ȥ롦������¡�����ܡ���

### �٥��ȥ�

# �� (�٥��ȥ� a �˥٥��ȥ� b ��­������: a �� a+b) --- ��#�װʹߤϥ�����
def vector_add(a, b)       # �ؿ���� (end �ޤ�)
  a_dim = vector_size(a)   # �ƥ٥��ȥ�μ��������
  b_dim = vector_size(b)
  if (a_dim != b_dim)      # �������������ʤ���С� (end �ޤ�)
    raise 'Size mismatch.' # ���顼
  end
  # �������餬����
  for i in 1..a_dim        # �롼�� (end �ޤ�): i = 1, 2, ..., a_dim
    a[i] = a[i] + b[i]     # ��ʬ���Ȥ�­������
  end
end

# ����� (�٥��ȥ� vec ��� num ��)
def vector_times(vec, num)
  dim = vector_size(vec)
  for i in 1..dim
    vec[i] = num * vec[i]
  end
end

### ����

# �� (���� a �˹��� b ��­������: a �� a+b)
def matrix_add(a, b)
  a_rows, a_cols = matrix_size(a)
  b_rows, b_cols = matrix_size(b)
  if (a_rows != b_rows)
    raise 'Size mismatch (rows).'
  end
  if (a_cols != b_cols)
    raise 'Size mismatch (cols).'
  end
  for i in 1..a_rows
    for j in 1..a_cols
      a[i,j] = a[i,j] + b[i,j]
    end
  end
end

# ����� (���� mat ��� num ��)
def matrix_times(mat, num)
  rows, cols = matrix_size(mat)
  for i in 1..rows
    for j in 1..cols
      mat[i,j] = num * mat[i,j]
    end
  end
end

# ���� a �ȥ٥��ȥ� v ���Ѥ�٥��ȥ� r �˳�Ǽ
def matrix_vector_prod(a, v, r)
  # �����������
  a_rows, a_cols = matrix_size(a)
  v_dim = vector_size(v)
  r_dim = vector_size(r)
  # �Ѥ��������뤫��ǧ
  if (a_cols != v_dim or a_rows != r_dim)
    raise 'Size mismatch.'
  end
  # �������餬����. a �γƹԤˤĤ��ơ�
  for i in 1..a_rows
    # a �� v ���б�������ʬ�򤫤����碌, ���ι�פ����
    s = 0
    for k in 1..a_cols
      s = s + a[i,k] * v[k]
    end
    # ��̤� r �˳�Ǽ
    r[i] = s
  end
end

# ���� a �ȹ��� b ���Ѥ���� r �˳�Ǽ
def matrix_prod(a, b, r)
  # �������������, �Ѥ��������뤫��ǧ
  a_rows, a_cols = matrix_size(a)
  b_rows, b_cols = matrix_size(b)
  r_rows, r_cols = matrix_size(r)
  if (a_cols != b_rows or a_rows != r_rows or b_cols != r_cols)
    raise 'Size mismatch.'
  end
  # �������餬����. a �γƹԡ�b �γ���ˤĤ��ơ�
  for i in 1..a_rows
    for j in 1..b_cols
      # a �� b ���б�������ʬ�򤫤����碌, ���ι�פ����
      s = 0
      for k in 1..a_cols
        s = s + a[i,k] * b[k,j]
      end
      # ��̤� r �˳�Ǽ
      r[i,j] = s
    end
  end
end

### ��

if (matrix_test('arith'))
  puts('- vector -')

  v = vector([1,2])
  w = vector([3,4])

  c = vector_copy(v)
  vector_add(c,w)
  puts('v, w, v+w, and 10 v')
  vp(v)
  vp(w)
  vp(c)

  c = vector_copy(v)
  vector_times(c,10)
  vp(c)

  puts('- matrix -')

  a = matrix([[3,1], [4,1]])
  b = matrix([[10,20], [30,40]])

  c = matrix_copy(a)
  matrix_add(c, b)
  puts('A, B, A+B, and 10 A')
  mp(a)
  mp(b)
  mp(c)

  c = matrix_copy(a)
  matrix_times(c, 10)
  mp(c)

  r = make_vector(2)
  matrix_vector_prod(a, v, r)
  puts('A, v, and A v')
  mp(a)
  vp(v)
  vp(r)

  r = make_matrix(2,2)
  matrix_prod(a, b, r)
  puts('A, B, and A B')
  mp(a)
  mp(b)
  mp(r)
end

#########################################################
# ��a + b �ʤɤȽ񤱤�褦

class MyVector
  def +(vec)
    c = vector_copy(self)
    vector_add(c, vec)
    return c
  end
  def -@()  # ñ��黻�ҡ�-��
    c = vector_copy(self)
    vector_times(c, -1)
    return c
  end
  def -(vec)
    return self + (- vec)
  end
  def *(x)
    dims = vector_size(self)
    if (dims == 1)
      return x * self[1]
    elsif x.is_a? Numeric
      c = vector_copy(self)
      vector_times(c, x)
      return c
    else
      raise 'Type mismatch.'
    end
  end
  def coerce(other)
    if other.is_a? Numeric
      return vector([other]), self
    else
      raise 'Unsupported type.'
    end
  end
end

class MyMatrix
  def +(mat)
    c = matrix_copy(self)
    matrix_add(c, mat)
    return c
  end
  def -@()  # ñ��黻�ҡ�-��
    c = matrix_copy(self)
    matrix_times(c, -1)
    return c
  end
  def -(mat)
    return self + (- mat)
  end
  def *(x)
    rows, cols = matrix_size(self)
    if (rows == 1 and cols == 1)
      return x * self[1,1]
    elsif x.is_a? Numeric
      c = matrix_copy(self)
      matrix_times(c, x)
      return c
    elsif x.is_a? MyVector
      r = make_vector(cols)
      matrix_vector_prod(self, x, r)
      return r
    elsif x.is_a? MyMatrix
      x_rows, x_cols = matrix_size(x)
      r = make_matrix(rows, x_cols)
      matrix_prod(self, x, r)
      return r
    else
      raise 'Type mismatch.'
    end
  end
  def coerce(other)
    if other.is_a? Numeric
      return matrix([[other]]), self
    else
      raise 'Unsupported type.'
    end
  end
end

### ��

if (matrix_test('op'))
  puts('- vector -')
  x = vector([1,2])
  y = vector([3,4])
  puts('x, y')
  vp(x)
  vp(y)
  puts('x+y, -x, y-x, x*10, 10*x')
  vp(x + y)
  vp(- x)
  vp(y - x)
  vp(x * 10)
  vp(10 * x)

  puts('- matrix -')
  a = matrix([[3,1], [4,1]])
  b = matrix([[10,20], [30,40]])
  puts('A, B')
  mp(a)
  mp(b)
  puts('A+B, -A, B-A, A*10, 10*A, A*B')
  mp(a + b)
  mp(- a)
  mp(b - a)
  mp(a * 10)
  mp(10 * a)
  mp(a * b)
  puts('A, x, and A*x')
  mp(a)
  vp(x)
  vp(a * x)
end

#########################################################
# LU ʬ�� (pivoting �ʤ�)

# LU ʬ�� (pivoting �ʤ�).
# ����ˤ�äƤϥ����ꥨ�顼���Ф�.
# ��̤� mat ���Ȥ˾��(������ʬ�� L, ������ʬ�� U).
def lu_decomp(mat)
  rows, cols = matrix_size(mat)
  # �Կ�(rows)�����(cols)�Ȥ�û������ s ���֤�
  if (rows < cols)
    s = rows
  else
    s = cols
  end
  # �������餬����
  for k in 1..s
    # �����ʳ���, mat �ϼ��ΤȤ��� (u, l �� U, L �δ�����ʬ. r �ϻĺ�.)
    #     u u u u u u
    #     l u u u u u
    #     l l r r r r  ���� k ��
    #     l l r r r r
    #     l l r r r r
    # �ڥ��� U ���� k �Ԥ�, �����ʳ��Ǥλĺ����Τ�� �� ���⤷�ʤ��Ƥ褤
    # �ڥ��� L ���� k ���׻�
    # ���̤˳�껻�ϼ�֤�������Τǡ���껻�β���򸺤餹����˾��ٹ�����
    x = 1.0 / mat[k,k]  # (mat[k,k] �� 0 ����, �����ǥ����ꥨ�顼)
    for i in (k+1)..rows
      mat[i,k] = mat[i,k] * x  # �פ���� mat[i,k] / mat[k,k]
    end
    # �ڥ��� �ĺ��򹹿�
    for i in (k+1)..rows
      for j in (k+1)..cols
        mat[i,j] = mat[i,j] - mat[i,k] * mat[k,j]
      end
    end
  end
end

# LU ʬ��η�̤�, ��Ĥι��� L, U ��ʬ��
def lu_split(lu)
  rows, cols = matrix_size(lu)
  # �Կ�������Ȥ�û������ r ���֤�
  if (rows < cols)
    r = rows
  else
    r = cols
  end
  # L �� rows��r, R �� r��cols
  lmat = make_matrix(rows, r)
  umat = make_matrix(r, cols)
  # L �����
  for i in 1..rows
    for j in 1..r
      if (i > j)
        x = lu[i,j]
      elsif (i == j)  # else if
        x = 1
      else
        x = 0
      end
      lmat[i,j] = x
    end
  end
  # R �����
  for i in 1..r
    for j in 1..cols
      if (i > j)
        x = 0
      else
        x = lu[i,j]
      end
      umat[i,j] = x
    end
  end
  return [lmat, umat]  # lmat �� umat ���Ȥ��֤�
end

### ��

if (matrix_test('lu'))
  a = matrix([[2,6,4], [5,7,9]])
  c = matrix_copy(a)
  lu_decomp(c)
  l, u = lu_split(c)
  puts('A, L, U, and L U')
  mp(a)
  mp(l)
  mp(u)
  mp(l * u)  # a ���������ʤ�
end

#########################################################
# ����

# ����. ���ι�����˲������.
def det(mat)
  # ��������ʤ��Ȥ��ǧ
  rows, cols = matrix_size(mat)
  if (rows != cols)
    raise 'Not square.'
  end
  # �������餬����. LU ʬ�򤷤ơ�
  lu_decomp(mat)
  # U ���г���ʬ���Ѥ�������
  x = 1
  for i in 1..rows
    x = x * mat[i,i]
  end
  return x
end

### ��

if (matrix_test('det'))
  a = matrix([[2,1,3,2], [6,6,10,7], [2,7,6,6], [4,5,10,9]])
  puts('A and det A = -12')
  mp(a)
  puts det(a)  # �� -12
end

#########################################################
# ϢΩ�켡������

# ������ A x = y ��� (A: ��������, y: �٥��ȥ�).
# A ���˲�����, ��� y �˾�񤭤����.
def sol(a, y)
  # ��������ǧ�Ͼ�ά
  # �ޤ� LU ʬ��
  lu_decomp(a)
  # ���Ȥϲ������ˤޤ�����
  sol_lu(a, y)
end

# (������) ������ L U x = y ���. ��� y �˾�񤭤����.
# L, U ���������� A �� LU ʬ�� (�ޤȤ�ư�Ĥι���˳�Ǽ���Ƥ���)
def sol_lu(lu, y)
  # �����������
  n = vector_size(y)
  # L z = y ���. �� z �� y �˾��.
  sol_l(lu, y, n)
  # U x = y (��Ȥ� z)���. �� x �� y �˾��.
  sol_u(lu, y, n)
end

# (¹����) L z = y ���. �� z �� y �˾��. n �� y �Υ�����.
# L, U ���������� A �� LU ʬ�� (�ޤȤ�ư�Ĥι���˳�Ǽ���Ƥ���)
def sol_l(lu, y, n)
  for i in 1..n
    # z[i] = y[i] - L[i,1] z[1] - ... - L[i,i-1] z[i-1] ��׻�����
    # ���Ǥ˵�ޤä��� z[1], ..., z[i-1] �� y[1], ..., y[i-1] �˳�Ǽ����Ƥ���
    for j in 1..(i-1)
      y[i] = y[i] - lu[i,j] * y[j]  # �¼��� y[i] - L[i,j] * z[j]
    end
  end
end

# (¹����) U x = y ���. �� x �� y �˾��. n �� y �Υ�����.
# L, U ���������� A �� LU ʬ�� (�ޤȤ�ư�Ĥι���˳�Ǽ���Ƥ���)
def sol_u(lu, y, n)
  # i = n, n-1, ..., 1 �ν�ǽ���
  #   �� ǰ�Τ������:
  #   ��ʪ��Ruby������ʤ������ʤ�������ȸ�򤷤ʤ��Ǥ�������.
  #   Ruby���Τ�ʤ��Ƥ��ɤ��褦, �����ʵ�ǽ����ˡ���������Ƥ��ޤ�.
  for k in 0..(n-1)
    i = n - k
    # x[i] = (y[i] - U[i,i+1] x[i+1] - ... - U[i,n] x[n]) / U[i,i] ��׻�����
    # ���Ǥ˵�ޤä��� x[i+1], ..., x[n] �� y[i+1], ..., y[n] �˳�Ǽ����Ƥ���
    for j in (i+1)..n
      y[i] = y[i] - lu[i,j] * y[j]  # �¼��� y[i] - U[i,j] * x[j]
    end
    y[i] = y[i] / lu[i,i]
  end
end

### ��

if (matrix_test('sol'))
  a = matrix([[2,3,3], [3,4,2], [-2,-2,3]])
  c = matrix_copy(a)
  y = vector([9,9,2])
  puts('A, y, and solution x of A x = y.')
  mp(a)
  vp(y)
  sol(c, y)
  vp(y)
  puts('A x')
  vp(a*y)
end

#########################################################
# �չ���

# �չ�����֤�. ���ι�����˲������.
def inv(mat)
  rows, cols = matrix_size(mat)
  # ��������ʤ��Ȥ��ǧ
  rows, cols = matrix_size(mat)
  if (rows != cols)
    raise 'Not square.'
  end
  # ��̤γ�Ǽ�����Ѱ�. ���������ñ�̹���ˤ��Ƥ���.
  ans = make_matrix(rows, cols)
  for i in 1..rows
    for j in 1..cols
      if (i == j)
        ans[i,j] = 1
      else
        ans[i,j] = 0
      end
    end
  end
  # �������餬����. LU ʬ�򤷤ơ�
  lu_decomp(mat)
  for j in 1..rows
    # ans �γ�����դȤ���, ϢΩ�켡������ A x = y ���.
    #   �� ������, ans �γ����ľ���ڤ�Ф��� sol_lu ���Ϥ���Ȥ褤�Τ���,
    #   ������ˡ�ϸ����¸. �����ʤ��Τ�, �����ǤϤ虜�虜,
    #   (1)���ԡ�, (2)�׻�, (3)��̤���᤹, �Ȥ��Ƥ���.
    v = make_vector(cols)
    for i in 1..cols
      v[i] = ans[i,j]
    end
    sol_lu(mat, v)
    for i in 1..cols
      ans[i,j] = v[i]
    end
  end
  return(ans)
end

if (matrix_test('inv'))
  a = matrix([[2,3,3], [3,4,2], [-2,-2,3]])
  c = matrix_copy(a)
  b = inv(c)
  puts('A and B = inverse of A.')
  mp(a)
  mp(b)
  puts('A B and B A')
  mp(a*b)
  mp(b*a)
end

#########################################################
# LU ʬ�� (pivoting �Ĥ�)
# ��̤� mat ���Ȥ˾�񤭤�, ����ͤȤ���, pivot table (�٥��ȥ� p)���֤�.
#
# �������̤�,
# A' = L U (A' �� A �ιԤ����줫�������, L �Ͼ廰��, U �ϲ�����) �Ȥ���ʬ��.
# A' �� i ���ܤϸ��ι��� A �� p[i] ����.
# p_ref(mat, i, j, p) ��, L (i>j)�ޤ��� U (i<=j)�� i,j ��ʬ��������.
def plu_decomp(mat)
  rows, cols = matrix_size(mat)
  # pivot table ���Ѱդ�,
  # pivot ���줿����γƹԤ����ι���ΤɤιԤ��б����Ƥ��뤫��Ͽ����.
  # mat[i,j] �ؤ�ľ�ܥ�����������, ɬ���ؿ� p_ref(�ͻ���), p_set(���ѹ�)��
  # �𤷤ơ�pivot ���줿����פإ����������뤳�Ȥˤ��,
  # lu_decomp �Υ����ɤ�ή�ѤǤ���.
  p = make_vector(rows)
  for i in 1..rows
    p[i] = i  # pivot table �ν����. ����ͤϡ�i ���ܤ� i ���ܡ�
  end
  # �Կ�(rows)�����(cols)�Ȥ�û������ s ���֤�
  if (rows < cols)
    s = rows
  else
    s = cols
  end
  # �������餬����
  for k in 1..s
    # �ޤ� pivoting �򤷤Ƥ���
    p_update(mat, k, rows, p)
    # �����������, lu_decomp �򤳤���������������
    #   mat[i,j] �� p_ref(mat, i, j, p)
    #   mat[i,j] = y �� p_set(mat, i, j, p, y)
    # �ڥ��� U ���� k �Ԥ�, �����ʳ��Ǥλĺ����Τ�� �� ���⤷�ʤ��Ƥ褤
    # �ڥ��� L ���� k ���׻�
    x = 1.0 / p_ref(mat, k, k, p)
    for i in (k+1)..rows
      y = p_ref(mat, i, k, p) * x
      p_set(mat, i, k, p, y)
    end
    # �ڥ��� �ĺ��򹹿�
    for i in (k+1)..rows
      x = p_ref(mat, i, k, p)
      for j in (k+1)..cols
        y = p_ref(mat, i, j, p) - x * p_ref(mat, k, j, p)
        p_set(mat, i, j, p, y)
      end
    end
  end
  # pivot table ������ͤȤ����֤�.
  return(p)
end

# pivoting ��Ԥ�.
# ����Ū�ˤ�, k ���ܤ�̤�����ս�Τ����������ͤ��������ʬ�� k ���ܤˤ�äƤ���.
def p_update(mat, k, rows, p)
  # ����(k ���ܤ�̤�����ս�)�Τ����ǥ����ԥ���(�����ͤ��������ʬ)��õ��.
  max_val = -777  # �Ǽ�ν�������ԥ���. ï�ˤ��餱��.
  max_index = 0
  for i in k..rows
    x = abs(p_ref(mat, i, k, p))
    if (x > max_val)  # �����ԥ�����ݤ�����
      max_val = x
      max_index = i
    end
  end
  # ���߹�(k)�ȥ����ԥ����(max_index)�򤤤줫��
  pk = p[k]
  p[k] = p[max_index]
  p[max_index] = pk
end

# pivot ���줿����� (i,j) ��ʬ���ͤ��֤�
def p_ref(mat, i, j, p)
  return(mat[p[i], j])
end

# pivot ���줿����� (i,j) ��ʬ���ͤ� val ���ѹ�
def p_set(mat, i, j, p, val)
  mat[p[i], j] = val
end

# ��������(��ؿ���ˡ�ǽ񤱤�褦��)
def abs(x)
  return(x.abs)
end

# LU ʬ��η�̤�, ��Ĥι��� L, U ��ʬ��
def plu_split(lu, p)
  rows, cols = matrix_size(lu)
  # �Կ�������Ȥ�û������ r ���֤�
  if (rows < cols)
    r = rows
  else
    r = cols
  end
  # L �� rows��r, R �� r��cols
  lmat = make_matrix(rows, r)
  umat = make_matrix(r, cols)
  # L �����
  for i in 1..rows
    for j in 1..r
      if (i > j)
        x = p_ref(lu, i, j, p)
      elsif (i == j)  # else if
        x = 1
      else
        x = 0
      end
      lmat[i,j] = x
    end
  end
  # R �����
  for i in 1..r
    for j in 1..cols
      if (i > j)
        x = 0
      else
        x = p_ref(lu, i, j, p)
      end
      umat[i,j] = x
    end
  end
  return [lmat, umat]  # lmat �� umat ���Ȥ��֤�
end

### ��

if (matrix_test('plu'))
  a = matrix([[2,6,4], [5,7,9]])
  c = matrix_copy(a)
  p = plu_decomp(c)
  l, u = plu_split(c, p)
  puts('A, L, U, and pivot table')
  mp(a)
  mp(l)
  mp(u)
  vp(p)
  puts('L U')
  mp(l * u)
end

#########################################################
# ��ư������å�
# matrix.rb �ȷ�̤�Ȥ餷���碌�ƥ����å�.
# ������������ɤޤʤ��ƹ����ޤ��� (�������פ��)

if ($c)
  require 'matrix'
  $eps = 1e-10
  class MyVector
    def to_a
     @a
    end
  end
  class MyMatrix
    def to_a
     @a
    end
  end
  def rmat(a)
    Matrix.rows a
  end
  def to_array_or_number(x)
    [Array, Matrix, Vector, MyVector, MyMatrix].find{|c| x.is_a? c} ? x.to_a : x
  end
  def aeq?(x, y)
    x = to_array_or_number x
    y = to_array_or_number y
    if x.is_a? Numeric
      y.is_a? Numeric and (x - y).abs < $eps
    elsif x.is_a? Array
      y.is_a? Array and
        x.size == y.size and
        not (0 ... x.size).map{|i| aeq? x[i], y[i]}.member? false
    else
      raise 'Bad type.'
    end
  end
  def rand_ary1(n)
    (1..n).map{|i| rand - 0.5}
  end
  def rand_ary2(m,n)
    (1..m).map{|i| rand_ary1 n}
  end
  def check_matmul(l,m,n)
    a = rand_ary2 l, m
    b = rand_ary2 m, n
    aeq? rmat(a) * rmat(b), matrix(a) * matrix(b)
  end
  def check_det(n)
    a = rand_ary2 n, n
    aeq? rmat(a).det, det(matrix(a))
  end
  def check_inv(n)
    a = rand_ary2 n, n
    aeq? rmat(a).inv, inv(matrix(a))
  end
  def check(label, repeat, proc)
    (1..repeat).each{|t| raise "#{label}" if !proc.call}
    puts "#{label}: ok"
  end
  [
    ['matmul', 100, lambda{check_matmul 6,5,4}],
    ['det', 100, lambda{check_det 7}],
    ['inv', 100, lambda{check_det 7}],
    ['aeq?', 1,
      lambda{
        ![
          # all pairs must be !aeq?
          [3, 3.14],
          [Vector[3], 3],
          [3, vector([3])],
          [Vector[1,2,3], vector([1,2,3,4])],
          [Vector[1,2,3,4], vector([1,2,3])],
          [Vector[1.1,2.2,3.3], vector([1.1,2.2000001,3.3])],
          [rmat([[1,2,3], [4,5,6]]), matrix([[1,2,3], [4.0000001,5,6]])],
        ].map{|a| !aeq?(*a)}.member? false}],
    ['----------- All Tests -----------', 1, lambda{true}],
    ['This must fail. OK if you see an error.', 1, lambda{aeq? 7.77, 7.76}],
  ].each{|a| check *a}
end
