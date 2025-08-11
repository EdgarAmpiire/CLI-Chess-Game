class Pawn < Piece
  
  def symbol
    color == :white ? "♙" : "♟"
  end

  def possible_moves(board, from)
    r, c = from
    moves = []
    dir = color == :white ? -1 : 1 

    # forward one
    fr = r + dir
    if fr.between?(0,7)
      moves << [fr, c] if board[fr, c].nil?
      
      # forward two from initial
      if !moved && board[fr, c].nil?
        fr2 = r + dir * 2
        moves << [fr2, c] if fr2.between?(0,7) && board[fr2, c].nil?
      end
    end

    # captures
    [[dir, -1], [dir, 1]].each do |dr, dc|
      nr, nc = r + dr, c + dc
      next unless nr.between?(0,7) && nc.between?(0,7)
      target = board[nr, nc]
      moves << [nr, nc] if target && enemy?(target)

      # en passant capture
      moves << [nr, nc] if [nr, nc] == board.en_passant_target
    end

    moves
  end
end
