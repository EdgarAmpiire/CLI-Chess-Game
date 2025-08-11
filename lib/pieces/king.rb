class King < Piece
  def symbol 
    color == :white ? "♔" : "♚"
  end

  def possible_moves(board, from)
    r,c = from
    moves = []
    [-1,0,1].each do |dr|
      [-1,0,1].each do |dc|
        next if dr==0 && dc==0
        nr, nc = r+dr, c+dc
        next unless nr.between?(0,7) && nc.between?(0,7)
        target = board[nr, nc]
        moves << [nr, nc] if target.nil? || enemy?(target)
      end
    end

    # Castling
    moves.concat(castling_moves(board,from))

    moves
  end

  private

  def castling_moves(board, from)
    return [] if moved # King has moved -> No Castling

    r, c = from 
    castling = []

    # King side Castling (right rook)
    if can_castle?(board, r, c, 7)
      castling << [r, c + 2] 
    end

    # Queen side Castling (left rook)
    if can_castle?(board, r, c, 0)
      castling << [r, c - 2]
    end

    castling
  end

  def can_castle?(board, r, c, rook_col)
    rook = board[r, rook_col]
    return false unless rook.is_a?(Rook) && !rook.moved && rook.color == color

    step = rook_col > c ? 1 : -1
    col_range = rook_col > c ? (c + 1...rook_col) : (rook_col + 1...c)

    # Check if squares between are empty
    return false unless col_range.all? { |col| board[r, col].nil? }

    # Check that the king is not in check and doesn't pass through check
    [c, c + step, c + 2 * step].each do |col|
      return false if board.square_attacked?([r, col], color)
    end
    true
  end
end