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
    moves
  end
end