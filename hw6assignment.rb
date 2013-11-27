# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.


#bugs
#1. square shape does not rotate if it comes out facing right
#2. sometimes the lines do not flush when special pieces are involved
#- maybe I have to copy all the functions that use next_piece
#- maybe copy-pasting in MyBoard.init will help
class MyPiece < Piece
	All_My_Pieces = [rotations(Piece::All_Pieces[0][0].push [2, 0]),		# P
									 rotations([[0, 0], [1, 0], [0, 1]]), #small l 
									 [Piece::All_Pieces[2][0].push([-2, 0]),
									  Piece::All_Pieces[2][1].push([0, -2])]].concat Piece::All_Pieces	# longer long
	
	def initialize (point_array, board)
		super
	end
	
	def piece_size
		current_rotation.size
	end
		
	def self.next_piece (board)
		MyPiece.new(All_My_Pieces.sample, board)
	end																			
end

class MyBoard < Board
	def initialize (game)
		super
		@current_block = MyPiece.next_piece(self)
	end
	
	def next_piece
		@current_block = MyPiece.next_piece(self)
		@current_pos = nil
	end
	
	def store_current
		locations = @current_block.current_rotation
		displacement = @current_block.position
		(0..(@current_block.piece_size - 1)).each{|index| 
			current = locations[index];
			@grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
			@current_pos[index]
		}
		remove_filled
		@delay = [@delay - 2, 80].max
	end
	
end

class MyTetris < Tetris
	def initialize
		super
	end
	
	def set_board
		super
		@canvas = TetrisCanvas.new
		@board = MyBoard.new(self)
		@canvas.place(@board.block_size * @board.num_rows + 3,
									@board.block_size * @board.num_columns + 6, 24, 80)
		@board.draw
	end
	
	def key_bindings
		super
		@root.bind('u', proc {@board.rotate_clockwise; @board.rotate_clockwise})
	end
	
end




# Extras:
# 1. Fix interface
# 2. Add u button
