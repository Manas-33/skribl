# Skribl

A real-time multiplayer drawing and guessing game — think Skribbl.io, built with Flutter and Node.js.

One player draws a randomly assigned word while the rest race to guess it in the chat. Points are awarded based on how quickly each player guesses correctly. After all rounds, a leaderboard reveals the winner.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Backend | Node.js, Express |
| Real-time | Socket.IO |
| Database | MongoDB (Mongoose) |

## Features

- **Create or join rooms** — set a custom room name, choose 2–6 players, and pick 1–8 rounds
- **Turn-based gameplay** — each turn a random word is assigned to the current drawer
- **Live drawing canvas** — freehand drawing with colour picker and adjustable stroke width, plus a clear-canvas button
- **Real-time chat & guessing** — all players see the chat live; a correct guess is hidden from others and awards points
- **Score calculation** — points are based on how quickly a player guesses (faster = more points)
- **Dynamic leaderboard** — displayed at the end of the game or when players disconnect
- **Cross-platform** — runs on Android, iOS, Web, and desktop (Linux, macOS, Windows)

## Project Structure

```
skribl/
├── lib/                    # Flutter app source
│   ├── main.dart           # App entry point
│   ├── constants.dart      # Theme colours and global keys
│   ├── models/             # Drawing data models (custom painter, touch points)
│   └── views/              # UI screens and widgets
│       ├── home_page.dart          # Create / Join landing screen
│       ├── create_room_page.dart   # Room creation form
│       ├── join_room_page.dart     # Room join form
│       ├── waiting_lobby_page.dart # Pre-game lobby
│       ├── paint_page.dart         # Main game screen (canvas + chat)
│       ├── leaderboard.dart        # End-of-game results
│       └── widgets/                # Reusable UI components
├── server/                 # Node.js backend
│   ├── index.js            # Express server & Socket.IO event handlers
│   ├── models/             # Mongoose Room schema
│   └── api/
│       └── getWord.js      # Random word generator
├── android/ ios/ web/      # Platform-specific Flutter targets
└── pubspec.yaml            # Flutter dependencies
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ≥ 2.19.2)
- [Node.js](https://nodejs.org/) (v16+ recommended) with npm
- A [MongoDB](https://www.mongodb.com/) instance (local or Atlas)

## Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/Manas-33/skribl.git
cd skribl
```

### 2. Configure the server

Open `server/index.js` and replace the `DB` constant with your own MongoDB connection string:

```js
const DB = 'your-mongodb-connection-string';
```

### 3. Start the backend

```bash
cd server
npm install
npm run dev      # uses nodemon for hot-reload, or:
# npm start      # plain Node
```

The server listens on port **3000** by default. Set the `PORT` environment variable to override.

### 4. Install Flutter dependencies

```bash
cd ..            # back to project root
flutter pub get
```

### 5. Run the app

```bash
flutter run
```

To target a specific platform:

```bash
flutter run -d chrome          # Web
flutter run -d android         # Android emulator / device
flutter run -d ios             # iOS simulator / device
```

## How to Play

1. **Create a room** — enter your nickname, a room name, the number of players, and the number of rounds.
2. **Share the room name** with your friends so they can join.
3. **Wait in the lobby** until all players have joined.
4. **Take turns drawing** — when it's your turn, a word is assigned to you; draw it on the canvas.
5. **Guess in chat** — type your guess; a correct answer awards points based on speed.
6. **View the leaderboard** — after all rounds, scores are tallied and the winner is announced.

## Socket Events Reference

| Event | Direction | Description |
|---|---|---|
| `create-game` | Client → Server | Create a new room |
| `join-game` | Client → Server | Join an existing room |
| `msg` | Client ↔ Server | Send a chat message / guess |
| `paint` | Client → Server | Broadcast drawing points |
| `color-change` | Client → Server | Broadcast colour change |
| `stroke-width` | Client → Server | Broadcast stroke width change |
| `clean-screen` | Client → Server | Clear the canvas for all players |
| `change-turn` | Client → Server | Advance to the next player's turn |
| `updateScore` | Client → Server | Request updated scores |
| `show-leaderboard` | Server → Client | Display end-of-game results |

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Socket.IO documentation](https://socket.io/docs/)
- [Mongoose documentation](https://mongoosejs.com/docs/)
