class BreadthFirstSearch implements BFSDelegate {
  
  static final num STATE_UNDISCOVERED = 0;    /// Vertex is in initial untouched states. Initially the only vertex in [UNDISCOVERED] is the start vertex
  static final num STATE_DISCOVERED = 1;      /// Vertex has been found, but we have not yet checked out all it's incident edges
  static final num STATE_PROCESSED = 2;       /// The vertex after we have visited all it's incident edges
  
  /**
   * A mapping from [EdgeNode] <-> either [UNDISCOVERED] or [DISCOVERED]
   */
  Map< int, int >       edgeStateMap = new Map< int, int >();
  
  /**
   * A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
   */
  Map< EdgeNode, EdgeNode >  parentMap = new Map< EdgeNode, EdgeNode >();                
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > fifoQueue = new Queue< EdgeNode >();
  
  /**
   * The [Graph] instance to be processed
   */
  Graph graph;
  
  EdgeNode _a;    /// Current vertex
  EdgeNode _b;    /// Successor vertex
  
  BreadthFirstSearch( Graph this.graph, EdgeNode start ) {
    EdgeNode p;
    
    // Add the start node to the queue and set it to discovered
    fifoQueue.addFirst( start );
    edgeStateMap[ start.id ] = STATE_DISCOVERED;
    
    num counter = 0;
    while( !fifoQueue.isEmpty() ) {
      _a = fifoQueue.removeFirst();
      
      processVertexEarly( _a );
      edgeStateMap[ _a.a ] = STATE_PROCESSED;
      
      p = _a;
      while( p != null && ++counter < 100 ) {
        _b = graph.getNode( p.b );
        
        // new edge
        if( edgeStateMap[ _b.a ] == null || graph.isDirected ) {
          processEdge( _a, _b );
        }
        
        // Since this is a new connection, add it to the queue and store it's parent
        if( edgeStateMap[ _b.a ] != STATE_DISCOVERED && edgeStateMap[ _b.a ] != STATE_PROCESSED ) {
          print("\t\tAdding to queue ${_b}");
          fifoQueue.addFirst( _b );
          edgeStateMap[ _b.a ] = STATE_DISCOVERED;
          parentMap[ _b ] = _a;
        }
        
        p = p.next;
      }
      processVertexLate( _a );
    }
  }
  
  processVertexEarly( EdgeNode a ) { 
    print("processed vertex ${a}");
  }
  
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a}, ${b}]");
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
