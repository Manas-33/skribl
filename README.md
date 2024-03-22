# skribl

## Brief Description

This project is a real-time multiplayer game developed using Flutter for the frontend, MongoDB for the database, SocketIO for real-time communication, and Node.js for the backend. The game operates on a turn-based mechanism where each round a random word is generated, and players have to guess the drawing made by another player. Points are calculated after every round, and a leaderboard is dynamically maintained, fostering a competitive environment.

## Features

- Real-time multiplayer gameplay
- Turn-based drawing and guessing mechanism
- Dynamic leaderboard
- Points calculation based on correct guesses
- Chat functionality for players to communicate

## Prerequisites
- Flutter SDK
- MongoDB
- Node.js
- SocketIO

## Installation Guide
- Clone the repository:
```
git clone https://github.com/Manas-33/skribl.git
```
- Install flutter dependencies:
```
flutter pub get
```
- Navigate to the server directory:
```
cd server
```
- Install node packages:
```
npm install
```
- Start the server:
```
npm run dev
```
- Run the app:
```
cd ..
flutter run
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
