require_relative 'pieces/base'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def self.algebraic_to_coord(s)
    file = s[0].downcase.ord - 'a'.ord
    rank = 8 - s[1].to_i
    [rank, file] 
  end

  def self.coord_to_algebraic(coord)
    r, f = coord
    "#{(f + 'a'.ord).chr}#{8 - r}" 
  end

  def [](r, c)
    @grid[r][c]
  end

  def []=(r, c, piece)
    @grid[r][c] = piece  
  end

  def move(from, to, color)
    fr, fc = from
    tr, tc = to
    piece = self[fr, fc]
    return false unless piece
    return false unless piece.color == color
    legal = legal_moves_for(from)
    return false unless legal.include?([tr, tc])
    perform_move(from, to, piece)
    true
  end

  def perform_move(from, to, piece)
    fr, fc = from; tr, tc = to
    self[tr, tc] = piece
    self[fr, fc] = nil
    piece.moved = true if piece.respond_to?(:moved=)

    # Pawn promotion (to queen) if reaches last rank
    if piece.is_a?(Pawn) && ( tr == 0 || tr == 7 )
      self[tr, tc] = Queen.new(piece.color)
    end
  end

  
end