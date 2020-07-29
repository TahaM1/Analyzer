import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Collections;
import java.util.Arrays;

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
    FFT fft;
    FFT fftLog;
    int highest;
    float highestAmp;
    int sampleRate; 
    int timeSize;
    float scale = 1; 
  //Audio file
   boolean run = false;
   float[] freqArr = new float[85];
  //Amplitude rectangle
    PVector pos = new PVector();
    PVector siz = new PVector(40, 0);
   
   
   
void setup(){
  
  size(800, 600);
  textAlign(CENTER, CENTER);
  rectMode(CORNER);
  
   minim  = new Minim(this);
  
  //Analysis
    highest = 0;
    sampleRate = 44100; // 
    timeSize = 1024;  //bufferSize
  //Audio intialize
    input = minim.getLineIn(Minim.STEREO, 2048, sampleRate); //getting mic input 
    //audioFile = minim.loadFile("sample.wav", 2048);
    output = minim.getLineOut(Minim.MONO, timeSize, sampleRate); //getting speaker output
    
    fft = new FFT(2048, 44100);
    fft.noAverages();
    
 
 
}

void draw(){
  
  //UPDATE
    background(50);
    fft.forward(input.mix);
    textSize(30);
    text("Frequency Visualizer", width/2, height/8);
    float centerFreq = 0;
    textSize(12);
    
  //CHECK
    
    
      
  //DRAW
  
    //drawing averages of frequencies 
    stroke(255);
    for(int i = 5; i < fft.specSize()/6; i++){ //going through the bands
      
      float freq = fft.indexToFreq(i); //frequency of i band
      
      
      println("Freq: " + freq + " index: " + i + " amp: " + fft.getBand(i));
      
      //records if i's amplitude is bigger than the highest 
      if(fft.getBand(i) > fft.getBand(highest)){
        highest = i; 
        highestAmp = fft.getBand(i);
        println("new high!");
      }
      
      //shows what band frequency your mouse is on 
      if(mouseX > i*4-1 + 50 && mouseX < (i+1)*4 + 50){
        stroke(255, 0, 0);
        text("Frequency of the Band: " + (int)fft.indexToFreq(i) + "Hz", width/2, height/1.25);
      } else { 
        stroke(255);
      }
      
      // drawing the amplitudes of bands
      line(i * 4 +50, height/2, i * 4+ 50, height/2 - fft.getBand(i) * scale);
      line(i * 4 +50, height/2, i * 4+ 50, height/2 + fft.getBand(i) * scale);
    
    }
    //prints the frequency with the highest amplitude found 
    println("HIGHEST Freq: " + fft.indexToFreq(highest) + " index: " + highest + " amp: " + highestAmp);
    //text("Highest Amplitude: " + (int)fft.indexToFreq(highest) + "Hz", width/2, height/1.25);
   
}
