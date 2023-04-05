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
                socketId:socket.id,
                nickname,
                isPartyLeader:true
            }
            room.players.push(player);
            room=await room.save();
            socket.join(room);
            io.to(name).emit('updateRoom',room);
        } catch (error) {
            console.log(error)
        }
    });
});

//listen
server.listen(port,"0.0.0.0",()=>{
    console.log("Server started and running on port:" + port);
});