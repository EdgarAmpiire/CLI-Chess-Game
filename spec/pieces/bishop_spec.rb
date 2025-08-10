require_relative '../../lib/board'
require_relative '../../lib/pieces/bishop'

RSpec.describe Bishop do
  let(:board) { Board.new }
  let(:bishop) { Bishop.new(:white) }

  it "moves diagonally" do
    board.grid.each { |row| row.fill(nil) }
    board[4,4] = bishop
    moves = bishop.possible_moves(board, [4,4])
    expect(moves).to include([0,0], [7,7], [1,7], [7,1])
  end
end
