PImage img;
String[] chalanges;
int[] chlng = new int[25];
boolean[] cmplt = new boolean[25];
public float seeD = 0;
int frmCnt = 0;

boolean[] cmplt1 = new boolean[25];

String server = "https://SereneDeeppinkLamp.memeyers.repl.co";

boolean playerChoise = false;//t=0, f=1

void setup(){
  javax.swing.JOptionPane.showMessageDialog(null, "If you have not read the readme.txt file, read it now.");
  String[] strar = loadStrings("config.txt");
  if(strar[0].charAt(0) == '0'){
    playerChoise = true;
  }else{
    playerChoise = false;
  }
  server = strar[1];
  chalanges = loadStrings("chalanges.txt");
  size(1200,800);
  img = loadImage("lay.png");
  frameRate(60);
  for(int i = 0;i < 25; i++){
    cmplt[i] = false;
  }
  randomise(random(0,1000));
  update();
  //.replace("]","").replace("[","").replace('"'+"","")
}

void randomise(float seed){
  randomSeed((long)seed);
  for(int i = 0;i < 24; i++){
    int v = int(random(0, chalanges.length));
    chlng[i] = v;
  }
  redraw();
  if(seeD != seed){
    seeD = seed;
    thread("updateSeed");
  }
}

void updateSeed(){
  loadStrings(server+"/setseed?key="+seeD);
}

boolean mouseDown = false;
void draw(){
  push();
  frmCnt ++;
  if(frmCnt >= 60){
    frmCnt = 0;
    thread("update");
  }
  //background(255,233,183);
  image(img,0,0);
  for(int j = 0;j < 5; j++){
    pop();
    push();
    textSize(20);
    translate(16, 217);
    translate(0, 114*j);
    for(int i = 0;i < 5;i++){
      if(cmplt[i+(j*5)]){
        fill(00,255,00);
        rect(0,0,114,114);
      }else{
        fill(255,233,183);
        rect(0,0,114,114);
      }
      fill(0,0,0);
      text(chalanges[chlng[i+(j*5)]],0,0,114,114);
      translate(114,0);
    }
  }
  pop();
  image(img,0,0);
  drawOpponent();
}

void drawOpponent(){
  translate(600,0);
  push();
  image(img,0,0);
  for(int j = 0;j < 5; j++){
    pop();
    push();
    textSize(20);
    translate(16, 217);
    translate(0, 114*j);
    for(int i = 0;i < 5;i++){
      if(cmplt1[i+(j*5)]){
        fill(00,255,00);
        rect(0,0,114,114);
      }else{
        fill(255,233,183);
        rect(0,0,114,114);
      }
      fill(0,0,0);
      text(chalanges[chlng[i+(j*5)]],0,0,114,114);
      translate(114,0);
    }
  }
  pop();
  image(img,0,0);
  translate(-600,0);
}

void update(){
  String[] s = loadStrings(server+"/seed");
  seeD = Float.parseFloat(s[0]);
  randomise(seeD);
  String up = "";
  for(int i = 0;i < cmplt.length; i++){
    if(cmplt[i]){
      up += "1";
    }else{
      up += "0";
    }
  }
  String[] load;
  if(playerChoise){
    loadStrings(server+"/set?key="+up);
  }else{
    loadStrings(server+"/set1?key="+up);
  }
  
  try{if(playerChoise){load = loadStrings(server+"/get1");}else{load = loadStrings(server+"/get");}
  char[] c = load[0].replace("]","").replace("[","").replace('"'+"","").replace(",","").toCharArray();
  for(int i = 0;i < c.length; i++){
    if(c[i] == '1'){
      cmplt1[i] = true;
    }else{
      cmplt1[i] = false;
    }
  }
  }catch(Exception e){e.printStackTrace();}
}

void keyPressed() {
  if(keyCode == 76){//l
      try{
        float f = Float.parseFloat(javax.swing.JOptionPane.showInputDialog("Enter Seed"));
        randomise(f);
      }catch(Exception e){javax.swing.JOptionPane.showMessageDialog(null, "Please input numbers");}
  }
  if(keyCode == 75){//k
    javax.swing.JOptionPane.showMessageDialog(null, "Your Seed is:"+ seeD);
  }
}
void mousePressed() {
  int x = (int)((mouseX - 16)/114);
  int y = (int)((mouseY - 217)/114);
  if(x < 5&& y<5&&x>= 0&&y >= 0){
    cmplt[x+(y*5)] = !cmplt[x+(y*5)];
  }
  redraw();
  draw();
}
