require_relative '../lib/board'

RSpec.describe Board do
  before(:each) { @board = Board.new }

  it "places pieces in starting positions" do
    expect(@board[0,0]).to be_a(Rook)
    expect(@board[7,4]).to be_a(King)
  end

  it "converts coordinates to algebraic notation" do
    expect(Board.coord_to_algebraic([7,0])).to eq("a1")
    expect(Board.algebraic_to_coord("a1")).to eq([7,0])
  end

  it "detects check" do
    @board.grid.each { |row| row.fill(nil) }
    @board[7,4] = King.new(:white)
    @board[0,4] = King.new(:black)
    @board[1,4] = Queen.new(:black)
    expect(@board.in_check?(:white)).to be true
  end

  it "detects checkmate" do
    @board.grid.each { |row| row.fill(nil) }
    @board[7,4] = King.new(:white)   # e1
    @board[6,3] = Rook.new(:black)   # d2 - covers escape square
    @board[6,5] = Rook.new(:black)   # f2 - covers escape square
    @board[6,4] = Queen.new(:black)  # e2 - puts king in check

    expect(@board.checkmate?(:white)).to be true
  end

  it "serializes and deserializes board" do
    data = @board.to_serializable
    restored = Board.from_serializable(data)
    expect(restored[0,0]).to be_a(Rook)
  end
end
