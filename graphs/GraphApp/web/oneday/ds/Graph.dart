 /**
 * A [Graph] is an abstract data-structure which consist of a set of Vertices V together with a set E of edges (vertex pairs)
 * @author Mario Gonzalez | onedayitwillmake.com
 */ 
class Graph {
  
  /// adjancency info
  List<EdgeNode> edges;       
  /// outdegree of each vertex
  List<num> degree;           
  
  /// number of vertices in graph
  int numVertices = 0;        
  /// number of edges in the graph
  int numEdges = 0;           
  /// is the graph directed?
  bool isDirected;              
  
  /// Static UUID incrementer
  int _uuid = 0;
 
  /**
   * Creates a new [Graph] instance. 
   * The graph can either be 'undirected' (two way) or 'directed' (one way)
   */
  Graph( bool pIsDirected ) : isDirected = pIsDirected {
    num maxVerts = 1000;
    
    degree = new List<num>(maxVerts+1); 
    edges = new List<EdgeNode>(maxVerts+1);
    for(int i = 1; i <= maxVerts; i++) {
      degree[i] = 0;
      edges[i] = null;
    }
  }
  
  /**
   * Creates a [Graph] from a text file such that each line contains an EdgeNode(a,b)
   */
  factory Graph.fromSimpleText( String graphText ) {
    Graph g = new Graph( false );
    List<String> edgeInfo = graphText.split("\n");
    
    // First line should contain the number of vertices in the graph and nothing else
    g.numVertices = parseInt( edgeInfo[0] );
    edgeInfo.removeLast();  // \n is the last char in the file, remove
    edgeInfo.removeAt(0);   // remove the first line which contains only numvertices property
    
    for( String pair in edgeInfo ) {
      List<String> nodeInfo = pair.split(",");
      
      // Create an Edge (a,b)
      g.insertEdge( parseInt(nodeInfo[0]), parseInt(nodeInfo[1]), false );
    }
    
    return g;
  }
  
  /**
   * Inserts an [EdgeNode] into the [Graph]
   */
  insertEdge( num a, num b, bool directed ) {
    EdgeNode p = new EdgeNode( a, b, 0, nextUUID() );
    p.next = edges[a];
    
    edges[a] = p;
    degree[a]++;
    
    // Insert in reverse if undirected
    if( !directed ) {
      insertEdge(b, a, true);
    } else {
      numEdges++;
    }
  }
  
  /**
   * Interates thru all the [EdgeNode]'s in [this] [Graph]
   */
  String toString() {
    StringBuffer output = new StringBuffer("");
    for( int i = 1; i <= numVertices; i++ ) {
      output.add( i == 1 ? "" : "\n" ); // dont \n on first line
      output.add( "${i}:" );
      EdgeNode p = edges[i];
      while( p != null ) {
        output.add(" ${p.b}");
        p = p.next;
      }
    }
    
    return output.toString();
  }
  
  /// Returns an auto-incremented UUID
  int nextUUID() => ( ++_uuid );

  /// Given an node label, returns it from our edges array
  EdgeNode getNode( num x ) => ( edges[x] );
}
