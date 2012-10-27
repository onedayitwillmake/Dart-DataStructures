part of ds;


/// A [GGraph] is an abstract data-structure which consist of a set of Vertices V together with a set E of edges (vertex pairs)
class GGraph {

  /// Is the [GGGraph] directed?
  bool isDirected;

  /// UUID incrementer
  int _uuid = 0;

  /// All [GGraphNode] nodes in the [GGraph]
  Map< int, GGraphNode > nodes = new Map< int, GGraphNode>();

  /// All GGraphEdge mapped as a linked list by the id of their respective [GGraphNode]
  Map< int, GGraphEdge > edges = new Map< int, GGraphEdge>();

  /// Creates a new [GGraph] and sets whether it is a directed graph or not
  GGraph( this.isDirected );

  /// Creates a [GGraph] from a text file such that each line contains an EdgeNode(a,b)
  factory GGraph.fromSimpleText( String graphText, bool isDirected ) {
    GGraph g  = new GGraph( isDirected );

    List<String> edgeInfo = graphText.split("\n");
    bool hasFoundFirstLine = false;

    for( String pair in edgeInfo ) {
      if( pair.startsWith("#") ) continue; // Comment - ignore
      
      /**
       * Found the first real line.
       * It contains only one value which is the number of vertices in the graph
       * 
       * Create N nodes
       */
      if( !hasFoundFirstLine ) {
        int n = int.parse(pair);
        for(int i = 1; i <= n; i++ ) {
           g.createNode(i);
        }
        
        
        hasFoundFirstLine = true;
        continue;
      }
      
      // For every pair - create an edge
      List<String> nodeInfo = pair.split(",");
      if( nodeInfo.length != 2 ) break; // Bad line, abort!

      // Create an Edge (a,b)
      g.insertEdge( int.parse(nodeInfo[0]), int.parse(nodeInfo[1]), g.isDirected );
    }

    return g;
  }

  /// Inserts an [EdgeNode] into the [Graph]
  void insertEdge( int a, int b, bool isDirected ) {
    
    GGraphNode x = getNode(a);
    GGraphNode y = getNode(b);

    GGraphEdge p = new GGraphEdge(x,y);
    

    // Linked list behavior for each adjacency list
    if( edges.containsKey( a ) ) {
      p.next = edges[a];
    }
    
    edges[a] = p;
    x.degree ++;

    // Call in reverse if isDirected
    if( !isDirected ) {
      insertEdge( b, a, true );
    }
  }

  /// Prints out all the [GGraphEdge] in this [GGraph]
  String toString() {
    StringBuffer output = new StringBuffer("");
    for( int i = 1; i <= nodes.length; i++ ) {
      output.add("${i}:" );

      GGraphEdge p = edges[i];
      while( p != null ) {
        output.add("\t${p.b.id}");
        p = p.next;
      }
      output.add("\n");
    }

    return output.toString();
  }

  /// Returns a [GGraphNode] for the given key, or creates one if it does not exist.
  GGraphNode createNode( int id ) {
    if( nodes.containsKey(id) ) return null;

    var p = new GGraphNode<DrawableCircle>( id, new DrawableCircle(0, 0, 5, "#FFFFFF", id.toString() ) );
    nodes[id] = p;

    return p;
  }

  /// Returns a node for a given id
  GGraphNode getNode( int id) => nodes[id];

  /// Returns the first [GGraphEdge] for a given [GGraphNode] id
  GGraphEdge getEdge( int id) => edges[id];
}
