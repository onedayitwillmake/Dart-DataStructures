
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
  
  /// A delegate which follows the [BFSDelegate] interface
  BFSDelegate _delegate;
  
  /// Used to keep track of ancesstery 
  int time;
  bool isFinished;
  
  DepthFirstSearch( Graph aGraph, EdgeNode aStartNode ) : super( aGraph, aStartNode ) {
      resetGraph();
      execute( graph.getNode(1) );
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
  
  processVertexEarly( EdgeNode a ) { 
    print("processing vertex ${a.a}");
    if( _delegate != null ) _delegate.processVertexEarly(a);
  }
  
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.a}, ${b.a}]");
    if( _delegate != null ) _delegate.processEdge(a, b);
  }
  
  processVertexLate( EdgeNode a ) {
    if( _delegate != null ) _delegate.processVertexLate(a);
  }
}
