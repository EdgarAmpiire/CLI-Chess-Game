# ♟ CLI Chess Game

A **Command Line Chess Game** built in Ruby as the **final project** for the Ruby curriculum in [The Odin Project](https://www.theodinproject.com/).  
Play a full chess match in your terminal, with all standard chess rules implemented — including check, checkmate, stalemate, pawn promotion, castling, and en passant.

--- 

## 📜 Features
- Fully functional chess board rendered in the terminal
- All standard chess rules implemented:
  - ✅ Check & Checkmate detection
  - ✅ Stalemate detection
  - ✅ Pawn promotion
  - ✅ Castling
  - ✅ En passant
- Save and load games
- Play as White or Black
- Input validation to prevent illegal moves

---

## 🛠️ Installation & Setup
1. **Clone the repository**:
```bash
git clone https://github.com/EdgarAmpiire/CLI-Chess-Game.git
cd CLI-Chess-Game
```

2. **Install dependencies (Ruby 3.0+ recommended):**
```bash
bundle install
```
_(If you don’t have Bundler installed, run gem install bundler first.)_

---

## ▶️ How to Play
_Run the game from the terminal:_
```bash
ruby bin/chess.rb
```

**Commands in Game:**
- Make a move: Enter coordinates like e2 e4

- Save the game: Type save

- Quit the game: Type quit

- Load a saved game: Run the program and choose the load option

---

## 📂 Project Structure
```python
CLI-Chess-Game/
│
├── bin/
│   └── chess.rb              # Entry point to start the game
│
├── lib/
│   ├── board.rb              # Handles board state and logic
│   ├── game.rb               # Manages game loop, saving/loading
│   ├── player.rb             # Creates players
│   └──pieces/
│       ├── piece.rb          # Base Piece class
│       ├── king.rb           # ♔ King piece logic
│       ├── queen.rb          # Queen piece logic
│       ├── rook.rb           # Rook piece logic
│       ├── bishop.rb         # Bishop piece logic
│       ├── knight.rb         # Knight piece logic
│       └── pawn.rb           # Pawn piece logic
│
├── spec/                     # Test files (RSpec)
│   ├── board_spec.rb
│   ├── game_spec.rb
│   ├── player_spec.rb
│   ├── pieces/
│   │   ├── king_spec.rb
│   │   ├── queen_spec.rb
│   │   ├── rook_spec.rb
│   │   ├── bishop_spec.rb
│   │   ├── knight_spec.rb
│   │   └── pawn_spec.rb
│   └── spec_helper.rb
│
└── README.md
```

## 🧪 Running Tests
**This project uses RSpec for testing.**
_Run tests with:_
```bash
rspec
```

---

## 🏆 Credits
Built by **Edgar Ampiire** as part of The Odin Project Ruby curriculum.
