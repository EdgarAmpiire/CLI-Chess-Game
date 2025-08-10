require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

RSpec.describe Pawn do
  let(:board) { Board.new }

  it "moves one square forward if empty" do
    board.grid.each { |row| row.fill(nil) }
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    expect(pawn.possible_moves(board, [6,4])).to include([5,4])
  end

  it "moves two squares forward from start" do
    board.grid.each { |row| row.fill(nil) }
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    expect(pawn.possible_moves(board, [6,4])).to include([4,4])
  end

  it "captures diagonally" do
    board.grid.each { |row| row.fill(nil) }
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    board[5,5] = Pawn.new(:black)
    expect(pawn.possible_moves(board, [6,4])).to include([5,5])
  end
end
