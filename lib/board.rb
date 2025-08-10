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

  def setup_pieces
    # Pawns
    8.times do |c|
      self[1,c] = Pawn.new(:black)
      self[6,c] = Pawn.new(:white)
    end

    # Rooks
    self[0,0] = Rook.new(:black); self[0,7] = Rook.new(:black)
    self[7,0] = Rook.new(:white); self[7,7] = Rook.new(:white)

    # Knights
    self[0,1] = Knight.new(:black); self[0,6] = Knight.new(:black)
    self[7,1] = Knight.new(:white); self[7,6] = Knight.new(:white)

    # Bishops
    self[0,2] = Bishop.new(:black); self[0,5] = Bishop.new(:black)
    self[7,2] = Bishop.new(:white); self[7,5] = Bishop.new(:white)

    # Queens
    self[0,3] = Queen.new(:black)
    self[7,3] = Queen.new(:white)

    # Kings
    self[0,4] = King.new(:black)
    self[7,4] = King.new(:white)
  end

  def print_board
    puts "  a b c d e f g h"
    @grid.each_with_index do |row, r| 
      line = "#{ 8 - r } "
      row.each_with_index do |cell, c|
        line += (cell ? cell.to_s : '.') + ' '
      end
      line += "#{ 8 - r }"
      puts line
    end
    puts "  a b c d e f g h" 
  end

  # Build all legal moves for a color/piece, excluding moves that leaves the king in check
  def legal_moves_for(from)
    fr, fc = from
    piece = self[fr, fc]
    return [] unless piece
    pseudo = piece.possible_moves(self, from)
    pseudo.select do |to|
      board_copy = deep_dup
      board_copy.perform_move(from, to, board_copy[fr,fc] || piece_copy(piece))
      !board_copy.in_check?(piece.color)
    end
  end

  def in_check?(color)
    king_pos = find_king(color)
    return false unless king_pos
    opponent_color = color == :white ? :black : :white
    opponent_positions = pieces_positions(opponent_color)
    opponent_positions.any? do |pos|
      r,c = pos
      p = self[r,c]
      p && p.possible_moves(self, pos).include(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)
    all_positions_for(color).none? do |pos|
      legal_moves_for(pos).any?
    end
  end

  def pieces_positions(color)
    positions = []
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        positions << [r,c] if cell && cell.color == color
      end
    end
    positions
  end

  def all_positions_for(color)
    pieces_positions(color)
  end

  def find_king(color)
    pieces_positions(color).each do |r, c|
      return [r,c] if self[r,c].is_a?(King)
    end
    nil
  end

  def to_serializable
    data = []
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        next unless cell
        data << { class: cell.class.name, color: cell.color, pos: [r,c], moved: cell.respond_to(:moved) ? cell.moved : nil }
      end
    end
    data
  end

  def self.from_serializable(data)
    b = Board.allocate
    b.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
    data.each do |h|
      klass = Object.const_get(h[:class])
      piece = klass.new(h[:color])
      piece.moved = h[:moved] if h[:moved] && piece.respond_to?(:moved=)
      r,c = h[:pos]
      b[r,c] = piece
    end
    b
  end

  def deep_dup
    dup_board = Board.allocate
    dup_grid = Array.new(8) { Array.new(8) }
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        dup_grid[r][c] = cell ? cell.dup_shallow : nil
      end
    end
    dup_board.instance_variable_set(:@grid, dup_grid)
    dup_board
  end

  private

  def piece_copy
    piece.dup_shallow
  end

end