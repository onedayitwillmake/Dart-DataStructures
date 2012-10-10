class BreadthFirstSearch {
  
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
  Map< int, int >  parentMap = new Map< int, int >();                
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > fifoQueue = new Queue< EdgeNode >();
  
  /**
   * The [Graph] instance to be processed
   */
  Graph graph;
  
  EdgeNode _v;    /// Current vertex
  EdgeNode _y;    /// Successor vertex
  
  BreadthFirstSearch( Graph this.graph, EdgeNode start ) {
    EdgeNode p;
    
    // Add the start node to the queue and set it to discovered
    fifoQueue.add( start );
    edgeStateMap[ start.id ] = STATE_DISCOVERED;
    
    while( !fifoQueue.isEmpty() ) {
      _v = fifoQueue.first();
      /// process_vertex_early( v );
      edgeStateMap[ _v.id ] = STATE_PROCESSED;
      
      p = _v;
      while( p != null ) {
//        _y = p-> 
      }
    }
  }
}
