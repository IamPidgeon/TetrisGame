# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.


class MyPiece < Piece
	All_My_Pieces = [rotations(Piece::All_Pieces[0][0].push [2, 0]),
									 rotations([[0, 0], [1, 0], [0, 1]]), #small l 
									[Piece::All_Pieces[2][0].push([-2, 0]),
									 Piece::All_Pieces[2][1].push([0, -2])]].concat [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
									rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
									[[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
									[[0, 0], [0, -1], [0, 1], [0, 2]]],
									rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
									rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
									rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
									rotations([[0, 0], [1, 0], [0, -1], [-1, -1]])] 

	def initialize (point_array, board)
		super
	end
	
	def piece_size
		current_rotation.size
	end

	def self.next_piece (board, cheat)
		if cheat.any?
			 MyPiece.new([[[0, 0]]], board)
		else 
			 MyPiece.new(All_My_Pieces.sample, board)
		end
	end			
																				
end

class MyBoard < Board
	attr_accessor :cheat
	
	def initialize (game)
		super
		@cheat = []
		@current_block = MyPiece.next_piece(self, @cheat)
	end
	
	def next_piece
		@current_block = MyPiece.next_piece(self, @cheat)
		@cheat.pop
		@current_pos = nil
	end
	
	def add_cheat
		if !game_over? and @game.is_running? and score >= 100
			@score -= 100
			@game.update_score
			@cheat.push true
			draw
		end
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
		@root.bind('c', proc {@board.add_cheat})
	end
	
end




# Extras:
# 1. Fix interface
# 2. Add u button
