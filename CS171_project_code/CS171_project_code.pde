PImage scene, garbage; 

int garbage_x,garbage_y;

void setup() 
{
 size(1300,863); 
 scene = loadImage("prosessing Backgroung.jpg"); 
 
  garbage = loadImage("bins_small.png");
  test= loadImage("test.jpg");

 textureMode(NORMAL); 
 blendMode(BLEND); 
 noStroke(); 
 
 
 garbage_x=0; 
 garbage_y=0;
}
void draw()
{
  
  image(garbage, 100, 100,50,50);
  image(test,100,100);
  
  
 background(scene); 
 texture(garbage);
 
 //pushMatrix();
 //translate(garbage_x,garbage_y);
 
 //beginShape(); 
 //texture(garbage);
 

 
 //endShape(CLOSE); 
 //popMatrix(); 
} 
