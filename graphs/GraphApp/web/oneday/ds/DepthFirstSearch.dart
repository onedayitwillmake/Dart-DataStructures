part of ds;


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
//      resetGraph();
//      execute( graph.getNode(1) );
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

    edgeStateMap[ a.x ] = GraphSearch.STATE_DISCOVERED;
    processVertexEarly( a );

    time++;
    entryTimes[ a.x ] = time;

    // Successor vertex
    EdgeNode b = null;

    EdgeNode p = a;
    while( p != null ) {
      b = graph.getNode( p.y );

      if( b != null ) { // b exist, do stuff with it
        // edge a-b has not been discovered yet, process it for the first time and set it's parent to A
        if( edgeNodeIsNotDiscovered( b.x ) ) {
          parent[b] = a;
          processEdge( a, b );
          execute( b );
        } else if ( edgeStateMap[ b.x ] != GraphSearch.STATE_PROCESSED || graph.isDirected ) { // It is a back-edge, process
          processEdge( a, b );
        }
      }
      if( isFinished ) return;
      p = p.next;
    }

    processVertexLate( a );

    time++;
    exitTimes[ a.x ] = time;
    edgeStateMap[ a.x ] = GraphSearch.STATE_PROCESSED;
  }

  /// Returns a [ArticulationVerticesDelegate] instance
  void getArticulationVertices([ EdgeNode start ]) {
    resetGraph();

    // store the prev delegate, and set _delegate to a a new [ArticulationVerticesDelegate] instance
    GraphSearchDelegate prevDelegate = _delegate;

    ArticulationVerticesImpl articulationDelegate = new ArticulationVerticesImpl( this );
    _delegate = articulationDelegate;

    execute( start );
  }

  void getTopilogicalSort() {
    resetGraph();

    // store the prev delegate, and set _delegate to a a new [ArticulationVerticesDelegate] instance
    GraphSearchDelegate prevDelegate = _delegate;

    TopilogicalSortImpl topilogicalSortDelegate = new TopilogicalSortImpl( this );
    _delegate = topilogicalSortDelegate;
    topilogicalSortDelegate.execute();
  }
  /**
   * Determines the relationship of an edge between nodes a,b.
   * All edges are of type [EdgeNode.EDGE_TYPE_TREE], [EdgeNode.EDGE_TYPE_BACK], [EdgeNode.EDGE_TYPE_FORWARD] or [EdgeNode.EDGE_TYPE_CROSS]
   */
  int edgeClassification(EdgeNode a, EdgeNode b) {
    if ( parent[b] == a) return EdgeNode.EDGE_TYPE_TREE;
    if ( edgeNodeIsNotDiscovered(a.x) == false && edgeStateMap[b.x] != GraphSearch.STATE_PROCESSED ) return EdgeNode.EDGE_TYPE_BACK;
    if ( edgeStateMap[b.x] == GraphSearch.STATE_PROCESSED && (entryTimes[b.x] > entryTimes[a.x]) ) return EdgeNode.EDGE_TYPE_FORWARD;
    if ( edgeStateMap[b.x] == GraphSearch.STATE_PROCESSED && (entryTimes[b.x] < entryTimes[a.x]) ) return EdgeNode.EDGE_TYPE_CROSS;

    print("Warning: unclassified edge (${a.x}, ${b.x})");
  }

  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode v ) {
//    print("processing vertex ${v.x}");
    if( _delegate != null ) _delegate.processVertexEarly(v);
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
//    print("\tFound edge [${a.x}, ${b.x}]");
    if( _delegate != null ) _delegate.processEdge(a, b);
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode v ) {
    if( _delegate != null ) _delegate.processVertexLate(v);
  }
}

/// Given a Directed Acyclical Graph (DAG), it will topilogically sort the graph from left to right
class TopilogicalSortImpl implements GraphSearchDelegate, Disposable {

  /// A reference to the current stack maintained during the Topilogical sort
  List< int > sorted = new List<int>();

  /// Reference to calling [DepthFirstSearch] instance we are running on
  DepthFirstSearch _caller;

  TopilogicalSortImpl( this._caller );

  void dispose() {
    sorted = null;
    _caller = null;
  }

  /// Performs the topilogical sort
  void execute() {
    for( int i = 1; i <= this._caller.graph.numVertices; i++ ) {
      if( _caller.edgeNodeIsNotDiscovered(i) ) {
        _caller.execute( _caller.graph.getNode( i ) );
      }
    }

    print("Sorted:\n--\n${sorted}\n--\n");
  }

  /// Called when an EdgeNode is popped from the queue
  void processVertexEarly( EdgeNode v ) {
    sorted.addLast( v.x );
  }

  /// Called when a new Edge connection is found
  void  processEdge( EdgeNode a, EdgeNode b) {
    int edgeClass = _caller.edgeClassification(a, b);
    if( edgeClass == EdgeNode.EDGE_TYPE_BACK ) {
      print("Warning: directed cycle found, not a DAG");
    }
  }

  /// Called when the vertex has been fully processed ( All recursively connected nodes discovered )
  void processVertexLate( EdgeNode v ){}
}

/** Used by the [findArticultionVertices] function  **/
class ArticulationVerticesImpl implements GraphSearchDelegate, Disposable {

  /// Keeps track of the current earliest reachable ancestor for an [EdgeNode]
  Map< int, int > reachableAncestor = new Map< int, int >();

  /// DFS tree outdegree of an [EdgeNode] v
  Map< int, int > treeOutDegree = new Map<int, int>();

  /// Reference to calling [DepthFirstSearch] instance we are running on
  DepthFirstSearch _caller;

  ArticulationVerticesImpl( this._caller );

  /// Clear memory
  void dispose() {
    _caller = null;

    treeOutDegree = null;
    reachableAncestor = null;
  }
  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode v ) {
    reachableAncestor[ v.x ] = v.x; // Initially the earliest reachable ancestor is itself
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
    int edgeClass = _caller.edgeClassification(a, b);

    if( edgeClass == EdgeNode.EDGE_TYPE_TREE ) {
      if( treeOutDegree[b.x] == null) { treeOutDegree[b.x] = 0;
      } else { treeOutDegree[b.x] += 1;
      }
    }

    if( edgeClass == EdgeNode.EDGE_TYPE_BACK && _caller.parent[a] != b) {
      if( _caller.entryTimes[b.x] == null || _caller.entryTimes[ b.x ] < _caller.entryTimes[ reachableAncestor[a.x] ] ) {
        reachableAncestor[b.x] = a.x;
      }
    }
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode v ) {
    bool root;        // is this vertex the root of the DFS tree?
    int time_v;       // earliest reachable time  for v
    int time_parent;  // earliest reachable time for parentMap[a]

    // Check for root cutnode
    if( _caller.parent[v] == null ) {
      if( treeOutDegree.containsKey(v.x) && treeOutDegree[v.x] > 1 ) {
        print("root articulation vertex: ${v.x}");
      }

      return;
    }

    // Check for parent cutnode
    root = ( _caller.parent[ _caller.parent[v] ] == null ); // is parent[v] the root?
    if( (reachableAncestor[v.x] == _caller.parent[v].x ) && !root ) {
      print("parent articulation vertex: ${_caller.parent[v]}");
    }

    // Check for bridge cutnode
    if( reachableAncestor[v.x] == v.x ) {
      print("bridge articulation vertex: ${_caller.parent[v]}");

      if( treeOutDegree.containsKey(v.x) && treeOutDegree[v.x] > 0 ) { // Test if V is not a leaf
        print("bridge articulation vertex: ${v}");
      }
    }

    time_v = _caller.entryTimes[ reachableAncestor[v.x] ];
    time_parent = _caller.entryTimes[ reachableAncestor[ _caller.parent[v].x ] ];

    if( time_v < time_parent ) {
        reachableAncestor[ _caller.parent[v].x ] = reachableAncestor[v.x];
    }
  }
}
