class Bishop < Piece
  
  def symbol  
    color == :white ? "♗" : "♝"
  end

  def line_moves(board, from)
    moves = []
    [[1,1],[1,-1],[-1,1],[-1,-1]].each do |dr, dc|
      r,c = from
      loop do
        r += dr; c += dc
        break unless r.between?(0,7) && c.between?(0,7)
        t = board[r, c]
        if t.nil?
          moves << [r,c] 
        else
          moves << [r,c] if enemy?(t)
          break
        end
      end
    end
    moves
  end

  def possible_moves(board, from)
    line_moves(board, from)
  end
end