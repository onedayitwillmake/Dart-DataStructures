class GBreadthFirstSearch extends GGraphSearch implements GGraphSearchDelegate {
  static final int COLOR_UNCOLORED = 0; 
  static final int COLOR_RED = 1;
  static final int COLORbLACK = 2;
  
  Queue< GGraphEdge > fifoQueue = new Queue< GGraphEdge >();
  
  GBreadthFirstSearch( GGraph pGraph, GGraphNode pStart, GGraphNode pGoal ) : super( pGraph, pStart, pGoal );
  
  /// Resets all book keeping properties of this BFS
  void resetGraph() {
    super.resetGraph();
    fifoQueue = new Queue< GGraphEdge >();
  }
  
  void dispose() {
    super.dispose();
    fifoQueue = null;
  }
  
  void execute( [GGraphNode pStart, GGraphNode pGoal] ){
    
    if( pStart == pGoal && pStart != null ) return; // Already at goal
    
    if( pStart != null ) start = pStart;
    if( pGoal != null ) goal = pGoal;
    
    GGraphEdge a = graph.getEdge( start.id ); // Current vertex
    GGraphEdge b;                             // Connecting vertex
    
    GGraphEdge p;                             // Temp pointer to next
    
    fifoQueue.addFirst( a );
    edgeState[ a ] = GGraphSearch.STATE_DISCOVERED;
    
    while( !fifoQueue.isEmpty() ) {
      a = fifoQueue.removeFirst();
      processVertexEarly( a );
      edgeState[ a ] = GGraphSearch.STATE_PROCESSED;
      
      p = a;
      while( p != null ) {
        b = graph.getEdge( p.b.id );
        if( b == null ) { p = p.next; continue; }
        
        if( edgeNodeIsNotProccessed( b ) || graph.isDirected ) {
          processEdge( a, b );
        }
        
        if( edgeNodeIsNotDiscovered( b ) ) {
          fifoQueue.addFirst( b );
          edgeState[ b ] = GraphSearch.STATE_DISCOVERED;
          parent[ b ] = a;
        }
        
        p = p.next;
      }
      
      processVertexLate( a );
    }
    
  }
  
// -- GGraphSearchDelegate
  processVertexEarly( GGraphEdge v ) { 
    print("processing vertex ${v.a}");
    if( _delegate != null ) _delegate.processVertexEarly(v);
  }
  
  processEdge( GGraphEdge u, GGraphEdge v) {
    print("\tFound edge [${u.a}, ${v.a}]");
    if( _delegate != null ) _delegate.processEdge(u, v);
  }
  
  processVertexLate( GGraphEdge v ) {
    if( _delegate != null ) _delegate.processVertexLate(v);
  }
}
