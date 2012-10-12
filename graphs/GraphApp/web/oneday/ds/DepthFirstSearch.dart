
class DepthFirstSearch {

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
   * A mapping from [EdgeNode] to times when the node was entered
   */
  Map< int, int >       entryTimes;
  
  /**
   * A mapping from [EdgeNode] to times when the node was exited
   */
  Map< int, int >       exitTimes;
  
  /**
   * A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
   */
  Map< EdgeNode, EdgeNode >  parentMap;                
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > lifoQueue;
  
  /**
   * The [Graph] instance to be processed
   */
  Graph graph;
  
  /// A delegate which follows the [BFSDelegate] interface
  BFSDelegate _delegate;
  
  /// Current vertex
  EdgeNode _a;    
  /// Successor vertex
  EdgeNode _b;
  
  /// Used to keep track of ancesstery 
  int time;
  bool isFinished;
  
  DepthFirstSearch( Graph this.graph ) {
    resetGraph();
    this.execute( graph.getNode(1) );
  }
  
/// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    time = 0;
    isFinished = false;
    edgeStateMap = new Map< int, int >();
    entryTimes = new Map< int, int >();
    exitTimes = new Map< int, int >();
    
    parentMap = new Map< EdgeNode, EdgeNode >();
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
  
  edgeNodeIsNotDiscovered( num x ) => ( edgeStateMap[ x ] != STATE_DISCOVERED && edgeStateMap[ x ] != STATE_PROCESSED );

  
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
