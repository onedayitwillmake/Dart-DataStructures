class GraphSearch {
  /// Vertex is in initial untouched states. Initially the only vertex in [UNDISCOVERED] is the start vertex
  static final num STATE_UNDISCOVERED = 0;
  /// Vertex has been found, but we have not yet checked out all it's incident edges
  static final num STATE_DISCOVERED = 1;      
  /// The vertex after we have visited all it's incident edges
  static final num STATE_PROCESSED = 2;
  
  
  /**
   * A mapping from [EdgeNode] <-> either [UNDISCOVERED] or [DISCOVERED]
   */
  Map< int, int >       edgeStateMap;
  
  /**
   * A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
   */
  Map< EdgeNode, EdgeNode >  parentMap;
  
  /**
   * The [Graph] instance to be processed
   */
  Graph graph;
  
  /// Start vertex
  EdgeNode _start;
  
  GraphSearch( this.graph, this._start );
  
  /// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    edgeStateMap = new Map< int, int >();
    parentMap = new Map< EdgeNode, EdgeNode >();
  }
  
  /// Returns true if this edge node has not yet been discovered
  edgeNodeIsNotDiscovered( num x ) => ( edgeStateMap[ x ] != STATE_DISCOVERED && edgeStateMap[ x ] != STATE_PROCESSED );
}
