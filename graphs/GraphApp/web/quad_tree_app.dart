import 'dart:html';
import 'oneday/geom/geom.dart' as geom;
import 'oneday/ds/ds.dart';
import 'oneday/ds/layout/layout.dart';

GGraph graph;
//ForceDirectedGraph forceGraph;

CanvasRenderingContext2D context;
int lastTime = null;

void main() { 
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  
}

void start() {
  lastTime = new Date.now().millisecondsSinceEpoch;
  window.requestAnimationFrame( update );
}

void update( int time ) {
  var delta = (time-lastTime)/1000;
  lastTime = time;
  
//  forceGraph.tick( delta );
  
  draw( delta );
  window.requestAnimationFrame( update );
}

void draw( num delta ) {
//  graph.nodes.forEach( void f(int key, GGraphNode thisNode) {
//    ( thisNode.value as geom.DrawableCircle ).draw( context );
//  });
}



