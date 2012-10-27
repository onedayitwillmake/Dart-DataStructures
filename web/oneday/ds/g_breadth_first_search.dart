part of ds;

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

  void execute( {GGraphNode pStart, GGraphNode pGoal} ){

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
          processEdge( a.a, b.a );
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

  processEdge( GGraphNode u, GGraphNode v) {
    print("\tFound edge [${u}, ${v}]");
    if( _delegate != null ) _delegate.processEdge(u, v);
  }

  processVertexLate( GGraphEdge v ) {
    if( _delegate != null ) _delegate.processVertexLate(v);
  }
}

/// A simple GraphSearchDelegate whichi is used by the twocolor function to create a bi-partite graph
class GBiPartiteGraphImpl implements GGraphSearchDelegate {
  /// Whether this graph is bi-partite or not
  bool isBipartite = true;
  
  /// Stores the current color information for each [GGraphEdge]
  Map< GGraphNode, int > colorMapping = new Map< GGraphNode, int >();
  
  void processEdge( GGraphNode a, GGraphNode b ) {
    if( colorMapping[a] == colorMapping[b] ) {
      isBipartite = false;
      print("Warning: not bi-partite due to (${a}, ${b})");
    }
    
    colorMapping[b] = complement( colorMapping[a] );
  }
  
  /**
   *  Returns the complementory color for the type passed in.
   *  That is [GGraphSearch.COLOR_RED] if black is passed in, and [GGraphSearch.COLOR_BLACK] if red is passed in. If neither is passed in BreadthFirstSearch.COLOR_NONE is returned.
   */
  int complement( int color ) {
    if( color == BreadthFirstSearch.COLOR_RED ) return BreadthFirstSearch.COLORbLACK;
    if( color == BreadthFirstSearch.COLORbLACK ) return BreadthFirstSearch.COLOR_RED;
    return BreadthFirstSearch.COLOR_UNCOLORED;
  }
  
  // The following two callbacks are unused
  void processVertexEarly( GGraphEdge v ) {}
  void processVertexLate( GGraphEdge v ) {}
}
