const express=require("express");
var http=require("http");
const app=express();
const port=process.env.PORT||3000;
var server=http.createServer(app);
const mongoose=require("mongoose");
const io=require("socket.io")(server);


//middleware
app.use(express.json());

//Database link
const DB='mongodb+srv://dalvimanas33:manas2003@cluster0.lmpkkz2.mongodb.net/?retryWrites=true&w=majority';

mongoose.connect(DB).then(()=>{
    console.log("Connection Successful!");
}).catch((e)=>{
    console.log(e);
});

server.listen(port,"0.0.0.0",()=>{
    console.log("Server started and running on port:" + port);
});