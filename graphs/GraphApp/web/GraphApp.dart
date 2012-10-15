#import('dart:html');
#import('oneday/ds/ds.dart');
#import('oneday/geom/geom.dart');

Graph aGraph;
CanvasRenderingContext2D context;

void main() { 
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  
  // Load the sample data
  var req = new HttpRequest.get("web/data/simpleGraph02.txt", onSuccess);
}

onSuccess( HttpRequest req ) {
  aGraph = new Graph.fromSimpleText( req.responseText, true );
  print(aGraph);
//  
//  print("--");
//  print(  new Graph.fromSimpleText( req.responseText, false ) );
//  
//  var bfs = new BreadthFirstSearch( aGraph, aGraph.getNode(1) );
//  var dfs = new DepthFirstSearch( aGraph, aGraph.getNode(1) );
//  dfs.resetGraph();
//  dfs.execute( aGraph.getNode(1)  );
//  dfs.findArticulationVertices( aGraph.getNode(1) );
}
