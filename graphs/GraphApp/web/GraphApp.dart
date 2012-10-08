#import('dart:html');
#import('oneday/ds/ds.dart');


Graph aGraph;
CanvasRenderingContext2D context;

void main() { 
  CanvasElement canvas = query("#container");
  context = canvas.context2d;
  
  // Load the sample data
  var req = new HttpRequest.get("web/data/simpleGraph00.txt", onSuccess);
}

onSuccess( HttpRequest req ) {
  aGraph = new Graph.fromSimpleText( req.responseText );
  print(aGraph);
}
