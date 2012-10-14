
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
  
  /// Current vertex
  EdgeNode _a;    
  /// Successor vertex
  EdgeNode _b;
  
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
  
  
  void execute( EdgeNode v ) {
    if( isFinished ) return;
    
    edgeStateMap[ v.a ] = STATE_DISCOVERED;
    processVertexEarly( v );
    
    time++;
    entryTimes[ v.a ] = time;
    
    
    
    EdgeNode p = v;
    while( p != null ) {
      print(p);
      _b = graph.getNode( p.b );     
      
      if( edgeNodeIsNotDiscovered( _b.a ) ) {
        parentMap[_b] = v;
        processEdge( v, _b );
        execute( _b );
      } else if ( edgeStateMap[ _b.a ] != STATE_PROCESSED /*|| graph.isDirected */ ) {
        processEdge( v, _b );
      }   
      
      if( isFinished ) return;
      p = p.next;
    }
    
    processVertexLate( v );
    time++;
    exitTimes[ v.a ] = time;
    edgeStateMap[ v.a ] = STATE_PROCESSED;
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
