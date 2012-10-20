import 'dart:html';
import '../oneday/geom/geom.dart' as geom;
import '../oneday/ds/ds.dart';
import '../oneday/ds/layout/layout.dart';

GGraph graph;
ForceDirectedGraph forceGraph;

CanvasRenderingContext2D context;
int lastTime = null;

void main() {
  CanvasElement canvas = query("#container");
  context = canvas.context2d;

  // Load the sample data
  var req = new HttpRequest.get("web/data/simpleGraph00.txt", onSuccess);
}

onSuccess( HttpRequest req ) {
//  aGraph = new Graph.fromSimpleText( req.responseText, true );

  graph = new GGraph.fromSimpleText( req.responseText, false );
  var bfs = new GBreadthFirstSearch( graph, graph.getNode(1), null );
  bfs.resetGraph();
  bfs.execute();

  forceGraph = new ForceDirectedGraph( graph, new geom.Rect(0, 0, context.canvas.width, context.canvas.height ) );
//  print(aGraph);
//
//  print("--");
//  print(  new Graph.fromSimpleText( req.responseText, false ) );
//
//  var bfs = new BreadthFirstSearch( aGraph, aGraph.getNode(1) );
//  bfs.execute();
//  var dfs = new DepthFirstSearch( aGraph, aGraph.getNode(1) );
//  dfs.getTopilogicalSort();
//  dfs.resetGraph();
//  dfs.execute( aGraph.getNode(1)  );
//  dfs.getArticulationVertices( aGraph.getNode(1) );
  start();
}

void start() {
  lastTime = new Date.now().millisecondsSinceEpoch;
  window.requestAnimationFrame( update );
}

void update( int time ) {
  var delta = (time-lastTime)/1000;
  lastTime = time;

  forceGraph.tick( delta );

  draw( delta );
  window.requestAnimationFrame( update );
}

void draw( num delta ) {
  graph.nodes.forEach( void f(int key, GGraphNode thisNode) {
    ( thisNode.value as geom.DrawableCircle ).draw( context );
  });
}



