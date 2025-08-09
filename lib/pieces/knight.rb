class Knight < Piece
  
  def symbol
    color == :white ? "♘" : "♞"
  end

  def possible_moves(board, from)
    r,c = from
    offsets = [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
    offsets.map { |dr, dc| [r+dr, c+dc] }
    .select { |nr, nc| nr.between?(0,7) && nc.between?(0,7) }
    .select { |nr, nc| (board[nr, nc].nil? || enemy?(board[nr, nc])) } #board[nr][nc]
  end
end