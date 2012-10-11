class BreadthFirstSearch implements BFSDelegate {
  
  /// Vertex is in initial untouched states. Initially the only vertex in [UNDISCOVERED] is the start vertex
  static final num STATE_UNDISCOVERED = 0;
  /// Vertex has been found, but we have not yet checked out all it's incident edges
  static final num STATE_DISCOVERED = 1;      
  /// The vertex after we have visited all it's incident edges
  static final num STATE_PROCESSED = 2;       
  
  static final int COLOR_UNCOLORED = 0;
  static final int COLOR_RED = 1;
  static final int COLOR_BLACK = 2;
  
  /**
   * A mapping from [EdgeNode] <-> either [UNDISCOVERED] or [DISCOVERED]
   */
  Map< int, int >       edgeStateMap;
  
  /**
   * A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
   */
  Map< EdgeNode, EdgeNode >  parentMap;                
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > fifoQueue;
  
  /**
   * The [Graph] instance to be processed
   */
  Graph graph;
  
  /// Start vertex
  EdgeNode _start;
  /// Current vertex
  EdgeNode _a;    
  /// Successor vertex
  EdgeNode _b;    
  
  BreadthFirstSearch( Graph this.graph, this._start ) {
    resetGraph();
    connectedComponents();
//    execute();
    
//    findPath( _start, graph.getNode(4) );
  }
  
  /// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    edgeStateMap = new Map< int, int >();
    parentMap = new Map< EdgeNode, EdgeNode >();
    fifoQueue = new Queue< EdgeNode >();
  }
  
  void execute([ EdgeNode startNode = null ]) { 
    
    if( startNode != null ) {
      _start = startNode;
    }
    
    EdgeNode p;
    
    // Add the start node to the queue and set it to discovered
    fifoQueue.addFirst( _start );
    edgeStateMap[ _start.id ] = STATE_DISCOVERED;
    
    
    while( !fifoQueue.isEmpty() ) {
      _a = fifoQueue.removeFirst();
      
      processVertexEarly( _a );
      edgeStateMap[ _a.a ] = STATE_PROCESSED;
      
      p = _a;
      while( p != null ) {
        _b = graph.getNode( p.b );
        
        // new edge
        if( edgeStateMap[ _b.a ] != STATE_PROCESSED || graph.isDirected ) {
          processEdge( _a, _b );
        }
        
        // Since this is a new connection, add it to the queue and store it's parent
        if( edgeStateMap[ _b.a ] != STATE_DISCOVERED && edgeStateMap[ _b.a ] != STATE_PROCESSED ) {
          fifoQueue.addFirst( _b );
          edgeStateMap[ _b.a ] = STATE_DISCOVERED;
          parentMap[ _b ] = _a;
        }
        
        p = p.next;
      }
      processVertexLate( _a );
    }
  }
  
  /// Returns the path from a start node, to an edge node. **IMPORTANT** Assumes the bfs ( [execute] ) has already been performed.
  List<EdgeNode> findPath( EdgeNode start, EdgeNode end ) {
    List<EdgeNode >path = new List<EdgeNode>();
    
    if( start == end || end == null ) {
      path.addLast( start );
      
      print("${start.a}");
    } else {
      findPath( start, parentMap[end] ); // Recurisve
      path.addLast( end );
      
      print("${end.a}");
    }
    
    return path;
  }
  
  /// Returns a set of all the start nodes for every set of connected components
  List<EdgeNode > connectedComponents() {
    resetGraph();
    List<EdgeNode >connectedSets = new List<EdgeNode >(); 
    
    num c = 0;
    num i;
    for( i = 1; i <= graph.numVertices; i++ ) {
      if( edgeStateMap[ i ] != STATE_DISCOVERED && edgeStateMap[ i ] != STATE_PROCESSED ) {
        connectedSets.addLast( graph.getNode(i) );
        c = c+1;
        execute( graph.getNode(i) );
      }
    }
    
    return connectedSets;
  }
  
//  /// Returns a mapping of [EdgeNode] to COLOR_RED | COLOR_BLACK if the graph is **bipartite**
//  Map< EdgeNode, int > twocolor() {
//    Map< EdgeNode, int > colorMapping = new Map< EdgeNode, int >();
//    
////    resetGraph();
////    for( i = 1; i <= graph.numVertices; i++ ) {
////       if( )
////    }
////    
////    
////    
//    return 
//  }
//  
//  
  
// BFSDELEGATE METHODS
  
  processVertexEarly( EdgeNode a ) { 
    print("processing vertex ${a.a}");
  }
  
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.a}, ${b.a}]");
  }
  
  processVertexLate( EdgeNode a ) {
    
  }
}
/**
 * An interface for processing nodes in the graph
 */
interface BFSDelegate {
  /// Called when an EdgeNode is popped from the queue
  processVertexEarly( EdgeNode a );       
  
  /// Called when a new Edge connection is found
  processEdge( EdgeNode a, EdgeNode b);  
  
  /// Called when the vertex has been fully processed ( All recursively connected nodes discovered )
  processVertexLate( EdgeNode a );       
}
