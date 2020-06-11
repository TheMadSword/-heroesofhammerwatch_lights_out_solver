class LightsOut

  @pos_fx = []
  POS_HERP_FX = [
    "000001011".to_i(2), # "000000001", #0, x=11
    "000010111".to_i(2), # "000000010", #1, x=21
    "000100110".to_i(2), # "000000100", #2, x=31
    "001011001".to_i(2), # "000001000", #3, x=12
    "010111010".to_i(2), # "000010000", #4, x=22
    "100110100".to_i(2), # "000100000", #5, x=32
    "011001000".to_i(2), # "001000000", #6, x=13
    "111010000".to_i(2), # "010000000", #7, x=23
    "110100000".to_i(2), # "100000000", #8, x=33
  ]

  @all_lights = 0
  ALL_LIGHTS = 2**9 - 1
  @all_combo = 0

  public

  def initialize(lights, square_side)
    @initial_lights = lights
    generate_pos_fx(square_side)
    @all_lights = 2**(square_side**2) - 1
    @all_combo = 2**(square_side**2 + 1) - 1
    p "pos_fx = " + @pos_fx.to_s
    p "POS_HERP_FX = " + POS_HERP_FX.to_s
  end

  # return int xor transformation following pressed switches as an integer
  def xor_transfo(int)
    retval = 0

    (0..(@pos_fx.length - 1)).each do |i|
      retval ^= @pos_fx[i] if (int & 1 << i) > 0
    end

    retval
  end

  def bruteforce_solve
    retval = nil
    (0..@all_combo).each do |switches|
      transfo = xor_transfo(switches)
      if @initial_lights ^ transfo == @all_lights
        retval = switches
        break
      end
    end
    p "Not found" if retval.nil?
    retval
  end

  def self.ascii_print(int, side)
    (0..side - 1).reverse_each do |y|
      p ascii_line(int, side, y * side)
    end
  end

  def self.ascii_line(int, side, start_i)
    retval = ""
    (start_i..start_i + side - 1).each do |bit|
      retval += check_bit(int, bit).to_s
    end
    retval
  end

  def self.check_bit(int, bit_pos)
    (int & 1 << bit_pos) > 0 ? 1 : 0
  end

  def count_bits(int)
    retval = 0
    (0..(@pos_fx.length - 1)).each do |i|
      retval += 1 if (int & 1 << i) > 0
    end

    retval
  end

  private

  def generate_pos_fx(side)
    @pos_fx = []
    (0..(side**2 - 1)).each do |i|
      x = i % side
      y = i / side

      pos = 0
      pos += 1 << i
      pos += 1 << i - 1 if x > 0
      pos += 1 << i + 1 if x < side - 1
      pos += 1 << i - side if y > 0
      pos += 1 << i + side if y < side - 1
      @pos_fx << pos
    end
  end

end
