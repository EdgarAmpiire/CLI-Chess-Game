require_relative '../../lib/board'
require_relative '../../lib/pieces/king'

RSpec.describe King do
  let(:board) { Board.new }
  let(:king) { King.new(:white) }

  before(:each) do
    board.grid.each { |row| row.fill(nil) }
  end

  it "Returns valid one square moves" do
    board[4,4] = king
    moves = king.possible_moves(board, [4,4])
    expect(moves).to contain_exactly(
      [3,3],[3,4],[3,5],
      [4,3],      [4,5],
      [5,3],[5,4],[5,5]
    )
  end

  it "cannot move onto a friendly piece" do
    board[4,4] = king
    board[3,4] = King.new(:white)
    moves = king.possible_moves(board, [4,4])
    expect(moves).not_to include([3,4])
  end

  it "can capture an enemy piece" do
    board[4,4] = king
    board[3,4] = King.new(:black)
    moves = king.possible_moves(board, [4,4])
    expect(moves).to include([3,4])
  end

  context 'castling' do
    before(:each) do
      # Set up empty board and place king and rooks in initial positions
      board.grid.each { |row| row.fill(nil) }
      board[7,4] = king
      board[7,0] = Rook.new(:white)
      board[7,7] = Rook.new(:white)
    end

    it 'allows kingside castling when path is clear and neither king nor rook have moved' do
      moves = king.possible_moves(board, [7,4])
      expect(moves).to include([7,6])  # g1 square for kingside castle
    end

    it 'allows queenside castling when path is clear and neither king nor rook have moved' do
      moves = king.possible_moves(board, [7,4])
      expect(moves).to include([7,2])  # c1 square for queenside castle
    end

    it 'does not allow castling if the king has moved' do
      king.moved = true
      moves = king.possible_moves(board, [7,4])
      expect(moves).not_to include([7,2])
      expect(moves).not_to include([7,6])
    end

    it 'does not allow castling if the rook has moved' do
      board[7,7].moved = true  # kingside rook moved
      moves = king.possible_moves(board, [7,4])
      expect(moves).not_to include([7,6]) # no kingside castle
      expect(moves).to include([7,2])     # queenside still possible

      board[7,0].moved = true  # queenside rook moved
      moves = king.possible_moves(board, [7,4])
      expect(moves).not_to include([7,2]) # no queenside castle now
    end

    it 'does not allow castling if squares between king and rook are occupied' do
      board[7,5] = Knight.new(:white)  # block kingside
      board[7,3] = Bishop.new(:white)  # block queenside
      moves = king.possible_moves(board, [7,4])
      expect(moves).not_to include([7,6])  # no kingside castle
      expect(moves).not_to include([7,2])  # no queenside castle
    end

    it 'does not allow castling through check' do
      # Place an enemy rook attacking the square the king would cross over on kingside
      board[6,5] = Rook.new(:black)
      allow(board).to receive(:square_attacked?).and_call_original
      # Stub square_attacked? to simulate that f1 (7,5) is attacked
      allow(board).to receive(:square_attacked?).with([7,5], :white).and_return(true)

      moves = king.possible_moves(board, [7,4])
      expect(moves).not_to include([7,6])  # kingside castle forbidden due to check on passing square
    end

   it 'does not allow castling while in check' do
  # Place an enemy rook attacking the king's position (e.g., black rook on 6,4 attacks white king on 7,4)
  board[6,4] = Rook.new(:black)

  moves = board.legal_moves_for([7,4])
  expect(moves).not_to include([7,2])  # no queenside castling
  expect(moves).not_to include([7,6])  # no kingside castling
  end

  end 
end
