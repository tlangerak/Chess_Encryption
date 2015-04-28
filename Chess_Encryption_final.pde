import processing.net.*; 
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;

ClipHelper cp = new ClipHelper(); //to copy to clipboard
boolean[] keys = new boolean[526];
boolean checkKey(String k)
{
  for (int i = 0; i < keys.length; i++)
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) return keys[i];  
  return false;
}

Client myClient; //socket with python

PImage R; //all images for pieces
PImage N;
PImage B;
PImage K;
PImage Q;
PImage P;
PImage r;
PImage n;
PImage b;
PImage k;
PImage q;
PImage p;
PImage img;

int t=0; //to draw rows/columns
int ro=-1;//^^
int co=0;//^^

String dataIn; // Data received from enige
String position[]=new String[64];//String to keep track of positions
int imageWidth; //for postion pieces
int imageHeight;//^^

int c1; //to translate mousepress to column/row
int c2;
int r1;
int r2;
String cs1="";
String cs2="";
String rs1="";
String rs2="";//^^
int toggle=0;//switch between first and second mousepress
String saved = "";//result of move eg. e2e3
String poem[]; //string of letters for password
String result[]; //actually password given (this can be different from actual password
String password[]= {
  "b1c3", "g1f3", "e2e3", "f1d3", "e1g1", "d2c3", "f3e5", "h2h3", "c2d3", "d3d4", "f2f3", "f1e1" //the moves that are needed for correct password
};
String alphabet= "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"; //to generate random letter
String pass ="";//the correct password
int moveTracker = 0;//to track position in array for moves

void setup() {
  open("C:/Users/Administrator/Desktop/Chess_Encryption_v3/sunfish.py");//start python file with engine
  size (800, 800); //set GUI
  background (0);
  noStroke();
  smooth();
  poem = split(pass, " "); //create string of letters from password
  result=new String[poem.length];//setup string with correct length
  myClient = new Client(this, "", 8080);//start connection with chess engine
  myClient.write("connection established");//check connection
}

void draw() { 
  drawBoard();
  dataReceive();
  drawPieces();
}

void drawBoard() { // draw the board(Doh)
  for (int x=0; x<= (width); x+=width/8) { //8 steps width
    t++;
    for (int y=0; y<= (height); y+=height/4) {//4 step height
      if (t%2==1) { //alternate blackwhite with whiteblack drawing depending on row
        fill(255);
        rect (x, y, width/8, height/8);
        fill(150);
        rect (x, y+height/8, width/8, height/8);
      } else {
        fill(150);
        rect (x, y, width/8, height/8);
        fill(255);
        rect (x, y+height/8, width/8, height/8);
      }
    }
  } 
  t=0;
}

void drawPieces() { //draw pieces (doh)
  co=0;
  ro=-1;
  for (int i=0; i<position.length; i++) { //translate string of 64 getting a collumn and row for each of 64 (8x8)
    co=i%8;
    if (co==0) {
      ro++;
    }

    imageWidth=width/8*co; // set size position
    imageHeight=height/8*ro;

    if (position[i]!=null) {
      if (position[i].equals(".")==false) {
        if (position[i].toLowerCase().equals(position[i])==true) {
          image(loadImage(position[i]+"b.png"), imageWidth, imageHeight, width/9, height/9); //draw correct image
        } else {
          image(loadImage(position[i]+"w.png"), imageWidth, imageHeight, width/9, height/9);
        }
      }
    }
  }
}

void dataReceive() { //monitor the input from chess engine
  int x=0;
  x=0;
  if (myClient.available() > 0) { //if available
    dataIn = myClient.readString(); //read
    if (dataIn.length()>75) { //if it is of correct length (not the "Not a Valid input" thingy)
      for (int i=0; i<dataIn.length (); i++) { //for everything in the data
        if (dataIn.toLowerCase().charAt(i)=='p'||dataIn.toLowerCase().charAt(i)=='b'||dataIn.toLowerCase().charAt(i)=='n'||dataIn.toLowerCase().charAt(i)=='r'||dataIn.toLowerCase().charAt(i)=='q'||dataIn.toLowerCase().charAt(i)=='k'||dataIn.toLowerCase().charAt(i)=='.') { //only useful characters
          position[x]=dataIn.substring(i, i+1);//save into position
          x++;

          if (x==64) {
            println(position);
          }
        }
      }
    } else {
      println(dataIn);
    }
  }
}

void mousePressed() { //to move the pieces
  if (toggle==0) { //to toggle between first and second mousepress. 
    r1=mouseY;
    c1=mouseX; //save mouse postions
    for (int i=0; i<8; i++) {
      if (c1>=width/8*i && c1<width/8*(i+1)) { //correlate each postion with column
        c1=i+1;
        switch(c1) {
        case 1:
          cs1="a";
          break;
        case 2:
          cs1="b";
          break;
        case 3:
          cs1="c";
          break;
        case 4:
          cs1="d";
          break;
        case 5:
          cs1="e";
          break;
        case 6:
          cs1="f";
          break;
        case 7:
          cs1="g";
          break;
        case 8:
          cs1="h";
          break;
        }
      }
      if (r1>=width/8*i && r1<width/8*(i+1)) { //correlate postion with row
        r1=8-i;
        rs1=str(r1);
      }
    }
    toggle=1;
  } else {
    r2=mouseY; //do the same for the second click
    c2=mouseX;
    for (int i=0; i<8; i++) {
      if (c2>=width/8*i && c2<width/8*(i+1)) {
        c2=i+1;
        switch(c2) {
        case 1:
          cs2="a";
          break;
        case 2:
          cs2="b";
          break;
        case 3:
          cs2="c";
          break;
        case 4:
          cs2="d";
          break;
        case 5:
          cs2="e";
          break;
        case 6:
          cs2="f";
          break;
        case 7:
          cs2="g";
          break;
        case 8:
          cs2="h";
          break;
        }
      }
      if (r2>=width/8*i && r2<width/8*(i+1)) {
        r2=8-i;
        rs2=str(r2);
      }
    }
    saved=cs1+rs1+cs2+rs2;
    println(saved);
    myClient.write(saved); //write it to the chess engine
    toggle=0;

    checkPassword(); //lets check the password :D
  }
}

void checkPassword() {
  if (moveTracker < password.length) { //if it is correct add the correct letter into the result array
    if (saved.equals(password[moveTracker].toLowerCase())==true) {
      result[moveTracker]=poem[moveTracker];
      saved="empty";
      moveTracker++;
    }

    if (moveTracker < password.length) {//add false line to the resuult if the move was false. 
      if (saved.equals(password[moveTracker].toLowerCase())!=true && saved.equals("empty")!=true) {
        int c=int(random(0, 62));
        String t = alphabet.substring(c, c+1);
        result[moveTracker]=t;
        saved="empty";
        moveTracker++;
      }
    }
  } 
  if (moveTracker == password.length) {
    link("http://bit.ly/1Oxbnv6"); //if all letters have been gathered open the website.
  }
  String cop="";
  for (int i=0; i<moveTracker; i++) {
    print(result[i]);
    cop=cop+result[i];
  }
  cp.copyString(cop); //copy to clipboard to use on website
  println("");
}

