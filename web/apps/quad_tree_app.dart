import 'dart:html';
import 'dart:math' as Math;
import '../oneday/geom/geom.dart' as geom;

geom.QuadTree qt;
Math.Random rand;
CanvasRenderingContext2D context;
int lastTime = null;


class SimpleObject implements geom.IQuadStorable {
  geom.Rect _rect;
  geom.Vec2 velocity;
  SimpleObject(num x, num y, num width, num height ) : _rect = new geom.Rect(x,y,width,height), velocity = new geom.Vec2(0,0);

  bool isInRect( geom.Rect r ){
    print("${_rect.x}, ${_rect.y}");
    return new geom.Vec2(_rect.x, _rect.y).isInRect(r);
  }
  bool intersectsRect( geom.Rect r ) => r.intersectsRect(r);
  String toString() => _rect.toString();
}



void main() {
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  document.on.click.add(onMouseClick);

//  geom.Rect r1 = new geom.Rect( 690.01, 607.72, 100, 100);
//  geom.Rect r2 = new geom.Rect( 487.64, 285.51, 100, 100);
//  
//  geom.Rect TL = new geom.Rect(0,0,500,500);
//  geom.Rect TR = new geom.Rect(500, 0, 500, 500);
//  geom.Rect BL = new geom.Rect(0, 500, 500, 500);
//  geom.Rect BR = new geom.Rect(500, 500, 500, 500);
//  
  //item.data.isInRect( childTL.rect )
//  print( r1.isInRect(TL) );
//  print( r1.isInRect(TR) );
//  print( r1.isInRect(BL) );
//  print( r1.isInRect(BR) );
//  print(r2);
  
  qt =  new geom.QuadTree(0,0, 1000,1000, 1);
  int objectSize = 1;
  
  int startTime = new Date.now().millisecondsSinceEpoch;
  qt.add( new SimpleObject( 690.01, 607.72, objectSize, objectSize) );
  qt.add( new SimpleObject( 487.64, 285.51, objectSize, objectSize) );
  print("Time: ${new Date.now().millisecondsSinceEpoch - startTime }");
//  start();
//  
  start();
  
  
//  rand = new Math.Random(1);
  
//  
//  var s = new Date.now().millisecondsSinceEpoch;
//  var e;
//  print("S:${s}");
//  List< SimpleObject > objs = new List< SimpleObject >();
//  objs.add( new SimpleObject(50, 50, objectSize, objectSize) );
//  objs.add( new SimpleObject(450, 450, objectSize, objectSize) );
//  objs.add( new SimpleObject(501, 100, objectSize, objectSize) );
//  
//  objs.forEach( (e)=> qt.add(e) );
//  
  
//  SimpleObject so;
//  for( int i = 0; i < 2; i++ ) {
//    so = new SimpleObject( rand.nextDouble() * qt.quadRect.width, rand.nextDouble() * qt.quadRect.height, objectSize, objectSize);
//    print(so);
//    qt.add( so );
//  }
//  
//  print("Time: ${new Date.now().millisecondsSinceEpoch - s }");
  


//  
//  List< SimpleObject > results = new List< SimpleObject>();
//  qt.getObjects( new geom.Rect(0,0, 51, 51), results );
//  print( results );
//  
//
//  qt = new geom.QuadTree(0, 0, context.canvas.width, context.canvas.height, 1);
//  var rand = new Math.Random( new Date.now().millisecondsSinceEpoch );
//  for( int i = 0; i < 100; i++ ) {
//    var so = new SimpleObject( rand.nextDouble() * context.canvas.width, rand.nextDouble() * context.canvas.height );
//    qt.add( so );
//  }
//  

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
  context.clearRect(0, 0, context.canvas.width, context.canvas.height );
  context.lineWidth = 0.25;
  context.strokeStyle = "#FFFFFF";
  context.strokeStyle = "";
  context.lineWidth = 0;

//  print(qt.wrappedDictionary.length);
  context.beginPath();
  qt.wrappedDictionary.forEach(void f( geom.IQuadStorable key, value){
    SimpleObject so = key as SimpleObject;
    context.moveTo( so._rect.x+5, so._rect.y );
    //context.arc( so.r.x, so.r.y, 5, 0, 360, false);
    context.rect( so._rect.x, so._rect.y, so._rect.width, so._rect.height );
  });

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


void onMouseClick( MouseEvent e) {
  var s = new Date.now().millisecondsSinceEpoch;
  qt.add( new SimpleObject( e.clientX, e.clientY-100, 100, 100) );
  print("Time: ${new Date.now().millisecondsSinceEpoch - s }");
}



