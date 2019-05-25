import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//variables
  Minim minim;
  //Audio input 
  AudioInput input;
  AudioRecorder recorder;
  boolean doneRecording;
  //Audio output 
  AudioOutput output;
  FilePlayer player;
  //Frequency 
  FFT spectrum; 


void setup(){
  size(800, 600);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  //Audio intialize
  minim  = new Minim(this);
  input = minim.getLineIn(); //getting mic input 
  output = minim.getLineOut(); //getting speaker output
  recorder = minim.createRecorder(input, "originalRecording.wav"); //setting the input of the recording and its file 
  doneRecording = false;
  
}

void draw(){
  
  //UPDATE
  background(50);
  
  
  //CHECK
  if(mouseX > width/2 - 25 && mouseX < width/2  + 25){
    if(mouseY > height/4 - 10 && mouseY < height/4 + 10){
      if(mousePressed){
      
      }
    }
  }
  
    
  //DRAW
  fill(255);
  text("Audio Visualizer: ", 100, height/2 - 75); 
  for(int i = 1; i < input.bufferSize() - 1; i++){
    stroke(255);
    //get functions returns -1 to 1 so it needs to be multipled to be scaled 
    line(i, height/2 + input.left.get(i)*75, i + 1, height/2 + input.left.get(i+1)*75);
    
    
  }
  
  
  if(recorder.isRecording()){
    text("RECORDING", width -100, 50);
  }
  
  rect(width/2, height/4, 50, 20);
  
}  

void keyPressed(){
  
  if(key == 'r'){
    recorder.beginRecord();    
    doneRecording = false;
    print("Recording...");
  }
  
  if(keyCode == ENTER){
    player = new FilePlayer(recorder.save());  //sets the stream the player should read from   
    player.patch(output); //sends the output of the filplayer to the speaker 
    println("\nRecording Saved");
  }

  if(key == 'p'){
    if( player != null){ //plays the recording when the fileplayer has been initialized
       println("Playing recording");
       player.rewind();
       player.play();
       
    }
  }
  
}

void keyReleased(){

  if(key == 'r') {
    recorder.endRecord();
    doneRecording = true;
    
  }
  
}
