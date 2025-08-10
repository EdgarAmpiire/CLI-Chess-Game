require_relative '../lib/player'

RSpec.describe Player do
  it "stores color" do
    player = Player.new(:white)
    expect(player.color).to eq(:white)
  end
end
