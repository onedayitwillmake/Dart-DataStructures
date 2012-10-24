import 'dart:html';
import 'dart:math' as Math;
import '../oneday/geom/geom.dart' as geom;

geom.BarnesHutTree bt;
CanvasRenderingContext2D context;
int lastTime = null;

void main() {
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  document.on.click.add(onMouseClick);

  bt = new geom.BarnesHutTree(0, 0, context.canvas.width, context.canvas.height, 1);
  var rand = new Math.Random( new Date.now().millisecondsSinceEpoch );
  SimpleObject so = null;
  for( int i = 0; i < 10; i++ ) {
    so = new SimpleObject( rand.nextDouble() * context.canvas.width, rand.nextDouble() * context.canvas.height );
    bt.add( so );
  }
  
  
  print(so.hashCode());
  bt.remove( so );

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
  bt.add(new SimpleObject( e.clientX, e.clientY-100) );
}

void draw( num delta ) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height );
  context.lineWidth = 0.25;
  context.strokeStyle = "#FFFFFF";
  context.strokeStyle = "";
  context.lineWidth = 0;

//  print(qt.wrappedDictionary.length);
  context.beginPath();
  bt.wrappedDictionary.forEach(void f( geom.IQuadStorable key, value){
    SimpleObject so = key as SimpleObject; 
    context.moveTo( so.position.x+5, so.position.y );
    context.arc( so.position.x, so.position.y, 5, 0, 360, false);
  });

  drawQuad( bt.quadTreeRoot, 0 );
  context.closePath();
  context.stroke();
 }

void drawQuad( geom.BarnesHutTreeNode quad, int depth ) {
  if( quad == null ) return;

  context.rect( quad.rect.x, quad.rect.y, quad.rect.width, quad.rect.height );
  
  if( quad.centerMass != null ) {
    context.moveTo( quad.centerMass.x+3, quad.centerMass.y);
    context.arc( quad.centerMass.x, quad.centerMass.y, 3, 0, 360, false);
  }
 
  drawQuad( quad.childBL, depth+1 );
  drawQuad( quad.childBR, depth+1 );
  drawQuad( quad.childTL, depth+1 );
  drawQuad( quad.childTR, depth+1 );
}


class SimpleObject extends geom.IBarnesHutStorable {
  geom.Vec2 position;
  geom.Vec2 velocity;
  num mass = 1;
  
  SimpleObject( num x, num y ) : position = new geom.Vec2(x,y), velocity = new geom.Vec2(0,0);

  bool isInRect( geom.Rect r ) => position.isInRect(r);
  bool intersectsRect( geom.Rect r ) => position.intersectsRect(r);
}


