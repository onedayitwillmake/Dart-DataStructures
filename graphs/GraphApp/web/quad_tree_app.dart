import 'dart:html';
import 'dart:math' as Math;
import 'oneday/geom/geom.dart' as geom;
//import 'oneday/ds/ds.dart';
//import 'oneday/ds/layout/layout.dart';

//GGraph graph;
//ForceDirectedGraph forceGraph;
geom.QuadTree qt;

CanvasRenderingContext2D context;
int lastTime = null;

class SimpleObject implements geom.IQuadStorable {
  geom.Vec2 position;
  geom.Vec2 velocity;
  SimpleObject( num x, num y ) : position = new geom.Vec2(x,y), velocity = new geom.Vec2(0,0);
  
  bool isInRect( geom.Rect r ) => position.isInRect(r);
  bool intersectsRect( geom.Rect r ) => position.intersectsRect(r);
}
void main() { 
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  

  
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

void draw( num delta ) {
  
  

  qt = new geom.QuadTree(0, 0, context.canvas.width);
  
  var rand = new Math.Random( new Date.now().millisecondsSinceEpoch );
  for( int i = 0; i < 10; i++ ) {
    var so = new SimpleObject( rand.nextDouble() * context.canvas.width, rand.nextDouble() * context.canvas.height );
    qt.add( so );
  }
  
  context.clearRect(0, 0, context.canvas.width, context.canvas.height );
  context.lineWidth = 0.25;
  context.strokeStyle = "#FFFFFF";
  context.strokeStyle = "";
  context.lineWidth = 0;
  
//  print(qt.wrappedDictionary.length);
  context.beginPath();
  qt.wrappedDictionary.forEach(void f( geom.IQuadStorable key, value){
    SimpleObject so = key as SimpleObject;
    context.moveTo( so.position.x, so.position.y );
    context.arc( so.position.x, so.position.y, 5, 0, 360, false);
  });
  
  var d = drawQuad( qt.quadTreeRoot, 0 );
  context.closePath();
  context.stroke();
 }

int drawQuad( geom.QuadTreeNode quad, int depth ) {
  if( quad == null ) return depth;
  
  context.rect( quad.rect.x, quad.rect.y, quad.rect.width, quad.rect.height );
  
  
  drawQuad( quad.childBL, depth+1 );
  drawQuad( quad.childBR, depth+1 );
  drawQuad( quad.childTL, depth+1 );
  drawQuad( quad.childTR, depth+1 );
  
  return depth+1;
}



