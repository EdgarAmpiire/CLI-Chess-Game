require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

RSpec.describe Pawn do
  let(:board) { Board.new }

  before(:each) do
    board.grid.each { |row| row.fill(nil) }
  end

  it "moves one square forward if empty" do
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    expect(pawn.possible_moves(board, [6,4])).to include([5,4])
  end

  it "moves two squares forward from start" do
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    expect(pawn.possible_moves(board, [6,4])).to include([4,4])
  end

  it "captures diagonally" do
    pawn = Pawn.new(:white)
    board[6,4] = pawn
    board[5,5] = Pawn.new(:black)
    expect(pawn.possible_moves(board, [6,4])).to include([5,5])
  end

  context 'en passant' do
    it 'allows en passant capture immediately after opponent pawn moves two squares' do
      white_pawn = Pawn.new(:white)
      black_pawn = Pawn.new(:black)

      board[3,4] = white_pawn       # white pawn on e5
      board[1,5] = black_pawn       # black pawn on f7

      # Black pawn moves two squares forward from f7 to f5
      expect(board.move([1,5], [3,5], :black)).to be true

      # White pawn should now have en passant capture move at f6 (2,5)
      moves = white_pawn.possible_moves(board, [3,4])
      expect(moves).to include([2,5])

      # Perform en passant capture
      expect(board.move([3,4], [2,5], :white)).to be true

      # Black pawn at f5 (3,5) should be captured (removed)
      expect(board[3,5]).to be_nil

      # White pawn should be at f6 (2,5)
      expect(board[2,5]).to eq white_pawn
    end

    it 'does not allow en passant capture if not performed immediately' do
      white_pawn = Pawn.new(:white)
      black_pawn = Pawn.new(:black)

      board[3,4] = white_pawn
      board[1,5] = black_pawn

      expect(board.move([1,5], [3,5], :black)).to be true

      # White makes another unrelated move, forfeiting en passant right
      another_white_pawn = Pawn.new(:white)
      board[6,0] = another_white_pawn
      expect(board.move([6,0], [5,0], :white)).to be true

      # Now white pawn no longer has en passant move available
      moves = white_pawn.possible_moves(board, [3,4])
      expect(moves).not_to include([2,5])
    end
  end
end
