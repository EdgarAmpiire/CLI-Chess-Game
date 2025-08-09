class Queen < Piece
  def symbol
    color == :white ? "♕" : "♛"
  end

  def possible_moves(board, from)
    Rook.new(color).line_moves(board, from) + Bishop.new(color).line_moves(board, from)
  end
end