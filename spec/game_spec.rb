require 'fileutils'
require_relative '../lib/game'

RSpec.describe Game do
  let(:game) { Game.new }

  after(:each) do
    FileUtils.rm_rf(Game::SAVE_DIR)
  end

  it "saves and loads a game" do
    game.save("testgame")
    expect(File).to exist(File.join(Game::SAVE_DIR, "testgame.yaml"))
    game.load_game("testgame")
    expect(game.instance_variable_get(:@board)).to be_a(Board)
  end

  it "switches turns after valid move" do
    board = game.instance_variable_get(:@board)
    board.grid.each { |row| row.fill(nil) }
    board[7,4] = King.new(:white)
    board[0,4] = King.new(:black)
    board[6,4] = Pawn.new(:white)

    expect(
      board.move([6,4],[4,4], :white)
    ).to be true
  end
end
