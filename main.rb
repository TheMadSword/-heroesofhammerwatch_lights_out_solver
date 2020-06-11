# Input : array in form of binary format, from bottom-left to top-right, bottom first,
# i.e. :
# 000010100 = 20 would be :
#
# OOO
# OXO
# OOX
# 1- get size, check if square
# 2- generate POS_FX

input_nb = ARGV.first

if input_nb.nil? \
  || !(Math.sqrt(input_nb.to_s.length) % 1).zero? \
  || !(Math.sqrt(input_nb.to_s.count('01')) % 1).zero?
  raise ArgumentError.new("No args given following format '0101', '010101010', etc.")
end

require_relative 'lights_out'

problem = ARGV.first.to_i(2)

square_side = Math.sqrt(input_nb.to_s.length).to_i

p "Problem (#{problem}): "
LightsOut.ascii_print(problem, square_side)

lo = LightsOut.new(problem, square_side)

solution = lo.bruteforce_solve

p "Solution (in #{lo.count_bits(solution)} steps): "
LightsOut.ascii_print(solution, square_side)
