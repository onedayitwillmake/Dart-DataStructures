
class DepthFirstSearch extends GraphSearch {
  
  /**
   * A mapping from [EdgeNode] to times when the node was entered
   */
  Map< int, int >       entryTimes;
  
  /**
   * A mapping from [EdgeNode] to times when the node was exited
   */
  Map< int, int >       exitTimes;
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > lifoQueue;
 
  /// Used to keep track of ancesstery 
  int time;
  bool isFinished;
  
  DepthFirstSearch( Graph aGraph, EdgeNode aStartNode ) : super( aGraph, aStartNode ) {
      resetGraph();
      execute( graph.getNode(1) );
  }
  
  void dispose() {
    super.dispose();
    lifoQueue = null;
    exitTimes = null;
    entryTimes = null;
  }
  
/// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    super.resetGraph();
    
    time = 0;
    isFinished = false;
    
    entryTimes = new Map< int, int >();
    exitTimes = new Map< int, int >();    
    
    lifoQueue = new Queue< EdgeNode >();
  }
  
  /// Executes a recursive DepthFirstSearch beginning at [a]
  void execute( EdgeNode a ) {
    
    if( isFinished ) return;
    
    edgeStateMap[ a.a ] = STATE_DISCOVERED;
    processVertexEarly( a );
    
    time++;
    entryTimes[ a.a ] = time;
    
    // Successor vertex
    EdgeNode b = null;
    
    EdgeNode p = a;
    while( p != null ) {
      b = graph.getNode( p.b );     
      
      if( edgeNodeIsNotDiscovered( b.a ) ) {
        parentMap[b] = a;
        processEdge( a, b );
        execute( b );
      } else if ( edgeStateMap[ b.a ] != STATE_PROCESSED /*|| graph.isDirected */ ) {
        processEdge( a, b );
      }   
      
      if( isFinished ) return;
      p = p.next;
    }
    
    processVertexLate( a );
    
    time++;
    exitTimes[ a.a ] = time;
    edgeStateMap[ a.a ] = STATE_PROCESSED;
  }
  
  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode a ) { 
    print("processing vertex ${a.a}");
    if( _delegate != null ) _delegate.processVertexEarly(a);
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.a}, ${b.a}]");
    if( _delegate != null ) _delegate.processEdge(a, b);
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode a ) {
    if( _delegate != null ) _delegate.processVertexLate(a);
  }
}

class ArticulationVerticesDelegate implements GraphSearchDelegate {
  
  /// Keeps track of the current earliest reachable ancestor for an [EdgeNode]
  Map< EdgeNode, EdgeNode > reachableAncestor = new Map< EdgeNode, EdgeNode >();
  
  /// DFS tree outdegree of an [EdgeNode] v
  Map< EdgeNode, int > treeOutDegree = new Map<EdgeNode, int>();
  
  /// A mapping from [EdgeNode] to times when the node was entered
  Map< int, int >       entryTimes;
  
  /// A mapping from [EdgeNode] to times when the node was exited
  Map< int, int >       exitTimes;
  
  ArticulationVerticesDelegate( this.entryTimes, this.exitTimes );
  
  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode a ) { 
    reachableAncestor[ a ] = a; // Initially the earliest reachable ancestor is itself
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.a}, ${b.a}]");
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode a ) {
  }
}
