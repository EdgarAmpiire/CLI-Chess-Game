require 'yaml'
require_relative 'board'
require_relative 'player'

class Game
  SAVE_DIR = 'saves'
  def initialize
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    @board = Board.new
    @players = { white: Player.new(:white), black: Player.new(:black) }
    @turn = :white
  end

  def run
    loop do
      system('clear') || system('cls')
      puts "Turn: #{@turn.capitalize}"
      @board.print_board
      if @board.in_check?(@turn)
        if @board.checkmate?(@turn)
          puts "Checkmate! #{@turn == :white ? 'Black' : 'White'} wins."
          break  
        else
          puts 'Check!'
        end
      end

      print "Enter move (e.g e2 e4), 'save Name', 'load Name', or 'quit': "
      input = gets&.strip
      break unless input
      case input
      when  /^save\s+(\S+)/i
        name = $1
        save(name)
        puts "Saved to #{name}.yaml"
        sleep 1
      when  /^load\s+(\S+)/i
        name = $1
        load_game(name)
      when /^quit$/i
        puts 'Goodbye'; break
      when /^(?:[a-h][1-8])\s+(?:[a-h][1-8])$/i
        from_s, to_s = input.split
        from = Board.algebraic_to_coord(from_s)
        to = Board.algebraic_to_coord(to_s)
        unless @board.move(from, to, @turn)
          puts "Illegal move -- Try again."
          sleep 1
        else
          @turn = opposite(@turn)
        end
      else
        puts "Invalid Command"
        sleep 1
      end
    end
  end

  def save(name)
    safe = name.to_s.strip
    safe = File.basename(safe)
    safe = safe.gsub(/\s+/, '_')
    safe = safe.gsub(/[^0-9A-Za-z_\-]/, '')

    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    filename = File.join(Dir.pwd, SAVE_DIR, "#{safe}.yaml")

    data = { board: @board.to_serializable, turn: @turn }
    File.write(filename, YAML.dump(data))

    puts "Saved to #{filename}"
  end

  def load_game(name)
    path = File.join(SAVE_DIR, "#{name}.yaml")
    unless File.exist?(path)
      puts "No save named #{name}."
      sleep 1
      return
    end
    data = YAML.load_file(path)
    @board = Board.from_serializable(data[:board])
    @turn = data[:turn]
  end

  private

  def opposite(color)
    color == :white ? :black : :white
  end

end