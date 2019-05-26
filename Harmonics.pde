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
  FilePlayer filePlayer;
  AudioPlayer audioFile;
  //Analysis
  FFT fftLinear;
  FFT fftLog;
  int highest;
  float highestAmp;
  int sampleRate; 
  int timeSize;
  float scale = 4; 
  //Audio file
   boolean run = false;

void setup(){
  
  size(800, 600);
  textAlign(CENTER, CENTER);
  rectMode(CORNERS);
  
   minim  = new Minim(this);
  
  //Analysis
    highest = 0;
    sampleRate = 44100; // 
    timeSize = 1024;  //bufferSize
  //Audio intialize
    input = minim.getLineIn(Minim.MONO, timeSize, sampleRate); //getting mic input 
    output = minim.getLineOut(Minim.MONO, timeSize, sampleRate); //getting speaker output
    recorder = minim.createRecorder(input, "originalRecording.wav"); //setting the input of the recording and its file 
    audioFile = minim.loadFile("originalRecording.wav", 1024);
    
    audioFile.loop();
    
    fftLinear = new FFT(audioFile.bufferSize(), audioFile.sampleRate());
    fftLinear.linAverages(30);
    
    fftLog = new FFT(audioFile.bufferSize(), audioFile.sampleRate());
    fftLog.logAverages(22 , 3);
    
    
 
}

void draw(){
  
  //UPDATE
    background(50);
    fftLinear.forward(audioFile.mix);
    fftLog.forward(audioFile.mix);
    float centerFreq = 0;
    
  //CHECK
    
    
      
  //DRAW
  
    //Visualizes audio input 
    
    //text("Audio Visualizer: ", 100, height/2 - 75); 
    //for(int i = 1; i < input.bufferSize() - 1; i++){
    //  stroke(255);
    //  //get functions returns -1 to 1 so it needs to be multipled to be scaled 
    //  line(i, height/2 + input.left.get(i)*75, i + 1, height/2 + input.left.get(i+1)*75);
    //}
    
    
    
    
    
    //for (int i = 0; i < audioPlayer.bufferSize() - 1; i++){
    //  line(i, 50 + audioPlayer.left.get(i)*50, i+1, 50 + audioPlayer.left.get(i+1)*50);
    //  line(i, 150 + audioPlayer.right.get(i)*50, i+1, 150 + audioPlayer.right.get(i+1)*50);
    //}
    
    stroke(255);
    for(int i = 0; i < fftLinear.specSize(); i++){
      line(i, height/3, i, height/3 - fftLinear.getBand(i) * scale);
    }
    
    //noStroke();
    //int widthOfBar = int(width/fftLinear.avgSize());
    //for(int i = 0; i < fftLinear.avgSize(); i++)
    //{
    //  // if the mouse is inside the bounds of this average,
    //  // print the center frequency and fill in the rectangle with red
    //  if ( mouseX >= i*widthOfBar && mouseX < i*widthOfBar + widthOfBar )
    //  {
    //    centerFreq = fftLinear.getAverageCenterFrequency(i);
        
    //    fill(255);
    //    text("Linear Average Center Frequency: " + centerFreq, width/2, 2*height/3 - 300);
        
    //    fill(255, 0, 0);
    //  }
    //  else
    //  {
    //      fill(255);
    //  }
    //  // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
    //  rect(i*widthOfBar, 2*height/3, i*widthOfBar + widthOfBar, 2*height/3 - fftLinear.getAvg(i)* scale);
    //}
    
    for(int i = 0; i < fftLog.avgSize(); i++){
    
      centerFreq = fftLog.getAverageCenterFrequency(i);
      float averageWidth = fftLog.getAverageBandWidth(i);
      
      float lowFreq = centerFreq - averageWidth/2;
      float highFreq = centerFreq + averageWidth/2;
      
      int x1 = (int)fftLog.freqToIndex(lowFreq);
      int x2 = (int)fftLog.freqToIndex(highFreq);
      
      if( mouseX >= x1 && mouseX < x2){
        
        fill(255, 200, 0);
        text("Log average center Frequency: " + centerFreq, width/2, height/2);
        fill(255, 0, 0);
       
      } else {
      
        fill(255);
        
      }
            
      rect(x1 , height, x2, height - fftLog.getAvg(i) * scale);
      
    }
    
    if(recorder.isRecording()){
      text("RECORDING", width -100, 50);
    }
   
}  

void keyPressed(){
  
  if(key == 'r'){
    recorder.beginRecord();    
    
    print("Recording...");
  }
  
  if(keyCode == ENTER){
    recorder.save();   
    
    println("\nRecording Saved");
  }

  if(key == 'p'){
   
    playAudio("originalRecording.wav");
    println("playing");
  }
  
}

void keyReleased(){

  if(key == 'r') {
    recorder.endRecord();
   
    
  }
  
}

void playAudio(String fileName){

  audioFile = minim.loadFile(fileName);
  audioFile.rewind();
  audioFile.play();
  
}
