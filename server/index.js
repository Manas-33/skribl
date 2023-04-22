const express=require("express");
var http=require("http");
const app=express();
const port=process.env.PORT||3000;
var server=http.createServer(app);
const mongoose=require("mongoose");
const io=require("socket.io")(server);
const Room=require('./models/Room');
const getWord=require("./api/getWord");
//middleware
app.use(express.json());

//Database link
const DB='mongodb+srv://dalvimanas33:manas2003@cluster0.lmpkkz2.mongodb.net/?retryWrites=true&w=majority';

mongoose.connect(DB).then(()=>{
    console.log("Connection Successful!");
}).catch((e)=>{
    console.log(e);
});


io.on('connection',(socket)=>{
    console.log('hey');
    //create game callback
    socket.on('create-game',async({nickname,name,occupancy,maxRounds})=>{
        try {
            const existingRoom= await Room.findOne({name});
            if(existingRoom){
                socket.emit("notCorrectGame","Room with that name already exixts!");
                return;

            }
            let room =new Room();
            const word=getWord();
            room.word=word;
            room.name=name;
            room.occupancy=occupancy;
            room.maxRounds=maxRounds;
            let player={
                socketID:socket.id,
                nickname,
                isPartyLeader:true
            }
            room.players.push(player);
            room=await room.save();
            socket.join(name);
            io.to(name).emit('updateRoom',room);
        } catch (error) {
            console.log(error)
        }
    });
    //join game callback
    socket.on('join-game',async({nickname,name})=>{
        try {

            let room= await Room.findOne({name});

            if(!room){
                socket.emit('notCorrectGame','Please eneter a valid room name!');
                return;
            }

            if(room.isJoin){
                let player= {
                    socketID:socket.id,
                    nickname
                }
                room.players.push(player);
                socket.join(name);

                if(room.players.length==room.occupancy){
                    room.isJoin=false;
                }

                room.turn=room.players[room.turnIndex];
                room=await room.save();

                io.to(name).emit('updateRoom',room);

            }else{
                socket.emit('notCorrectGame','The game is in progress, please try');
            }
        } catch (error) {
            console.log(error);
        }
    });
    //message socket
    socket.on('msg', async (data) => {
        console.log(data);
        try{
            if(data.msg === data.word) {
                let room = await Room.find({name: data.roomName});
                let userPlayer = room[0].players.filter(
                    (player) => player.nickname === data.username
                )
                if(data.timeTaken !== 0) {
                    userPlayer[0].points += Math.round((200/ data.timeTaken) * 10);
                }
                room = await room[0].save();
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: 'Guessed it!',
                    guessedUserCtr: data.guessedUserCtr + 1,
                })
                socket.emit('closeInput', "");
            } else {
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: data.msg,
                    guessedUserCtr: data.guessedUserCtr,
                })
            }
        } catch(err) {
            console.log(err.toString());
        }
    })

    //change turn socket
    socket.on('change-turn', async (name) => {
        try {
            let room = await Room.findOne({name});
            let idx = room.turnIndex;
            if(idx + 1 === room.players.length) {
                room.currentRound += 1;
            }
            if(room.currentRound <= room.maxRounds) {
                const word = getWord();
                room.word = word;
                room.turnIndex = (idx+1) % room.players.length;
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(name).emit('change-turn', room);
            }else{
                io.to(name).emit('show-leaderboard', room.players);
            }
        } catch (error) {
            console.log(error.toString());
        }
    });

    //white board sockets
    socket.on('paint',({details,roomName})=>{
        io.to(roomName).emit('points',{details:details});
    });

    //Color changer socket
    socket.on('color-change',({color,roomName})=>{
        io.to(roomName).emit('color-change',color);
    });

    //stroke width socket
    socket.on('stroke-width',({value,roomName})=>{
        io.to(roomName).emit('stroke-width',value);
    });

    //clean screen socket
    socket.on('clean-screen',(roomName)=>{
        io.to(roomName).emit('clean-screen','');
    });

    //update score socket
    socket.on('updateScore', async (name) => {
        try {
            const room = await Room.findOne({name});
            io.to(name).emit('updateScore',room);
        } catch (error) {
            console.log(error.toString());
        }
    });

    //id user disconnects
    socket.on('disconnect', async() => {
        try {
            let room = await Room.findOne({ "players.socketID": socket.id });
            for (let i = 0; i < room.players.length; i++) {
                const element = room.players[i];
                if (element.socketID === socket.id) {
                    room.players.splice(i,1);
                    break;
                }
            }
            room = await room.save();
            if(room.players.length === 1){
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            }else{
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        } catch (error) {
            console.log(error);
        }
    });    
});

//listen
server.listen(port,"0.0.0.0",()=>{
    console.log("Server started and running on port:" + port);
});