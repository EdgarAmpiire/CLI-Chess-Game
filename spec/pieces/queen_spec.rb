require_relative '../../lib/board'
require_relative '../../lib/pieces/queen'


RSpec.describe Queen do
  let(:board) { Board.new }
  let(:queen) { Queen.new(:white) }

    it "combine rook and bishop moves" do
      board.grid.each { |row| row.fill(nil) }
      board[4,4] = queen
      moves = queen.possible_moves(board, [4,4])
      expect(moves).to include([0,0], [7,7], [4,0], [4,7])
    end

    it "stops at a blocking piece" do
      board.grid.each { |row| row.fill(nil) }
      board[4,4] = queen
      board[4,6] = King.new(:white)
      moves = queen.possible_moves(board, [4,4])
      expect(moves).not_to include([4,7])
    end
  end
