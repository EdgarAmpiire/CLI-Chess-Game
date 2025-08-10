require_relative '../../lib/board'
require_relative '../../lib/pieces/king'

RSpec.describe King do
  let(:board) { Board.new }
  let(:king) { King.new(:white) }

    it "Returns valid one square moves" do
      board.grid.each { |row| row.fill(nil) }
      board[4,4] = king
      moves = king.possible_moves(board, [4,4])
      expect(moves).to contain_exactly(
      [3,3],[3,4],[3,5],
      [4,3],      [4,5],
      [5,3],[5,4],[5,5]
      )
    end

    it "cannot move onto a friendly piece" do
      board.grid.each { |row| row.fill(nil) }
      board[4,4] = king
      board[3,4] = King.new(:white)
      moves = king.possible_moves(board, [4,4])
      expect(moves).not_to include([3,4])
    end

    it "can capture an enemy piece" do
      board.grid.each { |row| row.fill(nil) }
      board[4,4] = king
      board[3,4] = King.new(:black)
      moves = king.possible_moves(board, [4,4])
      expect(moves).to include([3,4])
    end
end
