class LightsOut

  @pos_fx = []

  @all_lights = 0
  @all_combo = 0
  @square_side = 0

  attr_reader :initial_lights

  def initialize(lights, square_side)
    @initial_lights = lights
    generate_pos_fx(square_side)
    @all_lights = 2**(square_side**2) - 1
    @all_combo = 2**(square_side**2 + 1) - 1
    @square_side = square_side
    p "pos_fx = " + @pos_fx.to_s
  end

  #do line by line, column by column
  #current_board = int representation of board
  #tiles_pressed = bits of tiles being pressed, solution being built
  #current_tile = 0..nb_tile - 1
  def progressive_solve(current_board, tiles_pressed, current_tile)
    return tiles_pressed if current_board == @all_lights
    return false if current_tile >= @pos_fx.size

    retval = false

    #do nothing hypothesis
    if check_below_ok(current_board, current_tile)
      retval = progressive_solve(current_board, tiles_pressed, current_tile + 1)
    end

    #activate hypothesis
    press_current_tile_hypothesis = current_board ^ @pos_fx[current_tile]
    if !retval && check_below_ok(press_current_tile_hypothesis, current_tile)
      retval = progressive_solve(press_current_tile_hypothesis, tiles_pressed | (1 << current_tile), current_tile + 1)
    end

    return retval
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

  #check if belows current_tile, after throwing a hypothesis, we get an unsolvable board
  #current_tile = 0..@pos_fx.size - 1
  def check_below_ok(current_board, current_tile)
    return true if current_tile < @square_side

    all_below_tiles_on = 1 << (current_tile - @square_side + 1) - 1

    (all_below_tiles_on & current_board) == all_below_tiles_on
  end

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

  # return int xor transformation following pressed switches as an integer
  def xor_transfo(int)
    retval = 0

    (0..(@pos_fx.length - 1)).each do |i|
      retval ^= @pos_fx[i] if (int & 1 << i) > 0
    end

    retval
  end

end
