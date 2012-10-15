#import('dart:html');
#import('../../packages/unittest/unittest.dart');
#import('../oneday/ds/ds.dart');
#import('../oneday/geom/geom.dart');

/**
 * test('getDirectory', () {
  fs.root.getDirectory('nonexistent', flags:{},
    successCallback:
        expectAsync1((e) => 
            expect(false, 'Should not be reached'), count:0),
    errorCallback:
        expectAsync1((e) =>
            expect(e.code, equals(FileError.NOT_FOUND_ERR)));
});
*/
void main() {
  test('GraphLoading', (){
    var req = new HttpRequest.get("web/data/simpleGraph01.txt", (HttpRequest req ) {
      expectAsync1((e) => expect(false, 'Should not be reached'), count:0);
//      var aGraph = new Graph.fromSimpleText( req.responseText, false );
//      print(aGraph);
//    var bfs = new BreadthFirstSearch( aGraph, aGraph.getNode(1) );
//  var dfs = new DepthFirstSearch( aGraph, aGraph.getNode(1) );
    });
  });
}
