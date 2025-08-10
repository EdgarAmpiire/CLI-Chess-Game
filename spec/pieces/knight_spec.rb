require_relative '../../lib/board'
require_relative '../../lib/pieces/knight'

RSpec.describe Knight do
  let(:board) { Board.new }
  let(:knight) { Knight.new(:white) }

  it "moves in L-shapes" do
    board.grid.each { |row| row.fill(nil) }
    board[4,4] = knight
    moves = knight.possible_moves(board, [4,4])
    expect(moves).to contain_exactly(
      [6,5],[6,3],[2,5],[2,3],[5,6],[5,2],[3,6],[3,2]
    )
  end

  it "can jump over pieces" do
    board.grid.each { |row| row.fill(nil) }
    board[4,4] = knight
    board[4,5] = King.new(:white)
    expect(knight.possible_moves(board, [4,4])).to include([6,5])
  end
end
