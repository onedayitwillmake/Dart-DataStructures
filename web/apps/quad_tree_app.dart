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

  bool isInRect( geom.Rect other) => _rect.isInRect( other ); 
  bool intersectsRect( geom.Rect other ) => _rect.intersectsRect( other );
  geom.Vec2 getPosition() => _rect.getPosition();
  
  String toString() => _rect.toString();
}



void main() {
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  document.on.click.add(onMouseClick);

  
  qt =  new geom.QuadTree(0, 0, context.canvas.width, context.canvas.height, 1);
  int objectSize = 10;

  rand = new Math.Random(1983);
  for( int i = 0; i < 2; i++ ) {
    SimpleObject so = new SimpleObject( rand.nextDouble() * qt.quadRect.width, rand.nextDouble() * qt.quadRect.height, objectSize, objectSize);
    qt.add( so );
  }

  initRenderLoop();
}

void initRenderLoop() {
  lastTime = new Date.now().millisecondsSinceEpoch;
  window.requestAnimationFrame( update );
}


void update( int time ) {
  var delta = (time-lastTime)/1000;
  lastTime = time;

  draw( delta );
  window.requestAnimationFrame( update );
}

void draw( num delta ) {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height );
  context.lineWidth = 0.25;
  context.strokeStyle = "#FFFFFF";
  context.strokeStyle = "";
  context.lineWidth = 0;

  context.beginPath();
  qt.wrappedDictionary.forEach(void f( geom.IQuadStorable key, value){
    SimpleObject so = key as SimpleObject;
    context.moveTo( so._rect.x+5, so._rect.y );
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



