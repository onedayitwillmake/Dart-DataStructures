#import('dart:html');
#import('../oneday/ds/graph/EdgeNode.dart');
#import('../oneday/ds/graph/Graph.dart');

Graph aGraph;

void main() { 
  String graphText = '''
  4
  1,2
  1,5
  2,5
  2,3
  2,4
  3,4
  4,5  
  ''';
  
  aGraph = new Graph.fromSimpleText( graphText );
  print(aGraph);
}
