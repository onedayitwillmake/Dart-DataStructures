part of ds;

/**
 * BreadthFirstSearch is graph search strategy which begins at the root node, and inspects all neighboring nodes,
 * and in turn inspects their neighboring nodes which were unvisited, and so on
 * Mario Gonzalez | onedayitwillmake.com
 */
class BreadthFirstSearch extends GraphSearch implements GraphSearchDelegate {
  static final int COLOR_UNCOLORED = 0;
  static final int COLOR_RED = 1;
  static final int COLORbLACK = 2;

  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > fifoQueue;

  BreadthFirstSearch( Graph aGraph, EdgeNode aStartNode ) : super( aGraph, aStartNode ) {
    resetGraph();
//    twocolor();
//    connectedComponents();
//    execute();
//    findPath( _start, graph.getNode(4) );
  }

  void dispose() {
    super.dispose();
    fifoQueue = null;
  }

  /// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    super.resetGraph();
    fifoQueue = new Queue< EdgeNode >();
  }

  void execute([ EdgeNode startNode = null ]) {

    if( startNode != null ) {
      _start = startNode;
    }

    EdgeNode a; // Current vertex
    EdgeNode b; // Connecting vertex

    EdgeNode p; // Temp pointer

    // Add the start node to the queue and set it to discovered
    fifoQueue.addFirst( _start );
    edgeStateMap[ _start.id ] = GraphSearch.STATE_DISCOVERED;

    while( !fifoQueue.isEmpty() ) {
      a = fifoQueue.removeFirst();

      processVertexEarly( a );
      edgeStateMap[ a.x ] = GraphSearch.STATE_PROCESSED;

      p = a;
      while( p != null ) {
        b = graph.getNode( p.y );
        if( b != null ) {
          // new edge
          if( (edgeStateMap.containsKey(b.x) && edgeStateMap[ b.x ] != GraphSearch.STATE_PROCESSED) || graph.isDirected ) {
            processEdge( a, b );
          }

          // Since this is a new connection, add it to the queue and store it's parent
          if( edgeNodeIsNotDiscovered( b.x ) ) {
            fifoQueue.addFirst( b );
            edgeStateMap[ b.x ] = GraphSearch.STATE_DISCOVERED;
            parent[ b ] = a;
          }
        }
        p = p.next;
      }
      processVertexLate( a );
    }
  }

  /// Returns a set of all the start nodes for every set of connected components
  List<EdgeNode > connectedComponents() {
    resetGraph();
    List<EdgeNode >connectedSets = new List<EdgeNode >();

    num c = 0;
    num i;
    for( i = 1; i <= graph.numVertices; i++ ) {
      if( edgeNodeIsNotDiscovered(i) ) {
        connectedSets.addLast( graph.getNode(i) );
        c = c+1;
        execute( graph.getNode(i) );
      }
    }

    return connectedSets;
  }

  /// Returns a mapping of [EdgeNode] to COLOR_RED | COLORbLACK if the graph is **bipartite**
  Map< EdgeNode, int > twocolor( ) {

    BiPartiteColorImpl twoColorHelper = new BiPartiteColorImpl();

    // Store the current delegate in a temporary variable
    GraphSearchDelegate prevDelegate = _delegate;
    _delegate = twoColorHelper;

    resetGraph();
    for( num i = 1; i <= graph.numVertices; i++ ) {
      EdgeNode n = graph.getNode(i);

      if(edgeNodeIsNotDiscovered( i ) ) {
        twoColorHelper.colorMapping[ n ] = COLOR_RED;
        execute( n );
      }
    }

    // Reset the delegate and return a copy
    _delegate = prevDelegate;
    return new Map.from( twoColorHelper.colorMapping );
  }

// GraphSearchDelegate METHODS
  processVertexEarly( EdgeNode v ) {
    print("processing vertex ${v.x}");
    if( _delegate != null ) _delegate.processVertexEarly(v);
  }

  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.x}, ${b.x}]");
    if( _delegate != null ) _delegate.processEdge(a, b);
  }

  processVertexLate( EdgeNode v ) {
    if( _delegate != null ) _delegate.processVertexLate(v);
  }
}

/**
 * A simple GraphSearchDelegate which is used by the twocolor function to create a bipartite graph coloring
 */
class BiPartiteColorImpl implements GraphSearchDelegate {
  /// Whether this graph is is bipartite or not
  bool isBiPartite = true;

  /// Stores the current coloring information for each [EdgeNode]
  Map< EdgeNode, int > colorMapping = new Map< EdgeNode, int >();


  void processEdge( EdgeNode a, EdgeNode b) {
    if( colorMapping[a] == colorMapping[b] ) {
      isBiPartite = false;
      print("Warning: not bipartite due to  (${a.x},${b.x})");
    }

    colorMapping[b] = complement( colorMapping[a] );
  }

  /**
   *  Returns the complementory color for the type passed in.
   *  That is BreadthFirstSearch.COLOR_RED if black is passed in, and BreadthFirstSearch.COLORbLACK if red is passed in. If neither is passed in BreadthFirstSearch.COLOR_NONE is returned.
   */
  int complement( int color ) {
    if( color == BreadthFirstSearch.COLOR_RED ) return BreadthFirstSearch.COLORbLACK;
    if( color == BreadthFirstSearch.COLORbLACK ) return BreadthFirstSearch.COLOR_RED;
    return BreadthFirstSearch.COLOR_UNCOLORED;
  }

  // The following two callbacks are unused
  void processVertexEarly( EdgeNode v ) {}
  void processVertexLate( EdgeNode v ) {}
}