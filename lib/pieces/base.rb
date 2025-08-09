class Piece
  attr_reader :color
  attr_accessor :moved

  def initialize(color)
    @color = color
    @moved = false
  end

  # Return array of [r,c] possible moves ignoring check
  def possible_moves(board, from)
    []
  end

  def enemy?(other)
    other && other.color != color
  end

  def to_s
    symbol
  end

  def dup_shallow
    klass = self.class
    p = klass.new(color)
    p.moved = @moved
    p
  end
end