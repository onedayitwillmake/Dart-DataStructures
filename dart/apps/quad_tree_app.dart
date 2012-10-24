import 'dart:html';
import 'dart:math' as Math;
import '../oneday/geom/geom.dart' as geom;

geom.QuadTree qt;
CanvasRenderingContext2D context;
int lastTime = null;


class SimpleObject implements geom.IQuadStorable {
  geom.Rect r;
  geom.Vec2 velocity;
  SimpleObject(num x, num y, [num width=1, num height=1]) : r = new geom.Rect(x,y,width,height), velocity = new geom.Vec2(0,0);

  bool isInRect( geom.Rect other ) => r.isInRect(other);
  bool intersectsRect( geom.Rect other ) => r.intersectsRect(other);
}



void main() {
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  document.on.click.add(onMouseClick);
  
  geom.QuadTree qt =  new geom.QuadTree(0,0,1000,1000, 1);
  Math.Random rand = new Math.Random(1);
  int objectSize = 100;
  
  List< SimpleObject > objs = new List< SimpleObject >();
  objs.add( new SimpleObject(50, 50, objectSize, objectSize) );
//    objs.add( new SimpleObject(450, 450, objectSize, objectSize) );
//    objs.add( new SimpleObject(501, 100, objectSize, objectSize) );
  
  objs.forEach( (e)=> qt.add(e) );
  
  List< SimpleObject > results = qt.getObjects( new geom.Rect(0,0, 51, 51) );
  
//
//  qt = new geom.QuadTree(0, 0, context.canvas.width, context.canvas.height, 1);
//  var rand = new Math.Random( new Date.now().millisecondsSinceEpoch );
//  for( int i = 0; i < 100; i++ ) {
//    var so = new SimpleObject( rand.nextDouble() * context.canvas.width, rand.nextDouble() * context.canvas.height );
//    qt.add( so );
//  }
//  
  start();
}

void start() {
  lastTime = new Date.now().millisecondsSinceEpoch;
  window.requestAnimationFrame( update );
}


int i = 0;
void update( int time ) {
  var delta = (time-lastTime)/1000;
  lastTime = time;

//  forceGraph.tick( delta );

//  if( i++ % 60 == 0 )
  draw( delta );
  window.requestAnimationFrame( update );
}

void onMouseClick( MouseEvent e) {
  qt.add(new SimpleObject( e.clientX, e.clientY-100) );
}

void draw( num delta ) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height );
  context.lineWidth = 0.25;
  context.strokeStyle = "#FFFFFF";
  context.strokeStyle = "";
  context.lineWidth = 0;

//  print(qt.wrappedDictionary.length);
//  context.beginPath();
//  qt.wrappedDictionary.forEach(void f( geom.IQuadStorable key, value){
//    SimpleObject so = key as SimpleObject;
//    context.moveTo( so.r.position.x+5, so.position.y );
//    context.arc( so.position.x, so.position.y, 5, 0, 360, false);
//  });

  drawQuad( qt.quadTreeRoot, 0 );
  context.closePath();
  context.stroke();
 }

void drawQuad( geom.QuadTreeNode quad, int depth ) {
  if( quad == null ) return;

  context.rect( quad.rect.x, quad.rect.y, quad.rect.width, quad.rect.height );


  drawQuad( quad.childBL, depth+1 );
  drawQuad( quad.childBR, depth+1 );
  drawQuad( quad.childTL, depth+1 );
  drawQuad( quad.childTR, depth+1 );
}



