require_relative '../../lib/board'
require_relative '../../lib/pieces/rook'

RSpec.describe Rook do
  let(:board) { Board.new }
  let(:rook) { Rook.new(:white) }

  it "moves in straight lines" do
    board.grid.each { |row| row.fill(nil) }
    board[4,4] = rook
    moves = rook.possible_moves(board, [4,4])
    expect(moves).to include([0,4], [7,4], [4,0], [4,7])
  end

  it "stops at blocking piece" do
    board.grid.each { |row| row.fill(nil) }
    board[4,4] = rook
    board[4,5] = King.new(:white)
    moves = rook.possible_moves(board, [4,4])
    expect(moves).not_to include([4,6])
  end
end
