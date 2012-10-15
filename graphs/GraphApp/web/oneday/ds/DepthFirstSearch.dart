
class DepthFirstSearch extends GraphSearch {
  
  /**
   * A mapping from [EdgeNode] to times when the node was entered
   */
  Map< EdgeNode, int >       entryTimes;
  
  /**
   * A mapping from [EdgeNode] to times when the node was exited
   */
  Map< EdgeNode, int >       exitTimes;
  
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
    
    entryTimes = new Map< EdgeNode, int >();
    exitTimes = new Map< EdgeNode, int >();    
    
    lifoQueue = new Queue< EdgeNode >();
  }
  
  /// Executes a recursive DepthFirstSearch beginning at [a]
  void execute( EdgeNode a ) {
    
    if( isFinished ) return;
    
    edgeStateMap[ a.a ] = GraphSearch.STATE_DISCOVERED;
    processVertexEarly( a );
    
    time++;
    entryTimes[ a ] = time;
    
    // Successor vertex
    EdgeNode b = null;
    
    EdgeNode p = a;
    while( p != null ) {
      b = graph.getNode( p.b );     
      
      if( edgeNodeIsNotDiscovered( b.a ) ) {
        parent[b] = a;
        processEdge( a, b );
        execute( b );
      } else if ( edgeStateMap[ b.a ] != GraphSearch.STATE_PROCESSED /*|| graph.isDirected */ ) {
        processEdge( a, b );
      }   
      
      if( isFinished ) return;
      p = p.next;
    }
    
    processVertexLate( a );
    
    time++;
    exitTimes[ a ] = time;
    edgeStateMap[ a.a ] = GraphSearch.STATE_PROCESSED;
  }
  
  /// Returns a [ArticulationVerticesDelegate] instance which
  void findArticulationVertices([ EdgeNode start ]) {
    resetGraph();
    
    // store the prev delegate, and set _delegate to a a new [ArticulationVerticesDelegate] instance
    GraphSearchDelegate prevDelegate = _delegate;
    
    ArticulationVerticesDelegate articulationDelegate = new ArticulationVerticesDelegate( this.entryTimes, this.exitTimes, this.parent );
    _delegate = articulationDelegate;
    
    execute( start );
    
  }
  
  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode v ) { 
    print("processing vertex ${v.a}");
    if( _delegate != null ) _delegate.processVertexEarly(v);
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
    print("\tFound edge [${a.a}, ${b.a}]");
    if( _delegate != null ) _delegate.processEdge(a, b);
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode v ) {
    if( _delegate != null ) _delegate.processVertexLate(v);
  }
}

/**
 *  Used by the [findArticultionVertices] function 
 */
class ArticulationVerticesDelegate implements GraphSearchDelegate, Disposable {
  
  /// Keeps track of the current earliest reachable ancestor for an [EdgeNode]
  Map< EdgeNode, EdgeNode > reachableAncestor = new Map< EdgeNode, EdgeNode >();
  
  /// DFS tree outdegree of an [EdgeNode] v
  Map< int, int > treeOutDegree = new Map<int, int>();
  
  /// A mapping from [EdgeNode] to times when the node was entered
  Map< EdgeNode, int >       entryTimes;
  
  /// A mapping from [EdgeNode] to times when the node was exited
  Map< EdgeNode, int >       exitTimes;
  
  /// A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
  Map< EdgeNode, EdgeNode >  parent;
  
  ArticulationVerticesDelegate( this.entryTimes, this.exitTimes, this.parent );
  /// Clear memory
  void dispose() {
    entryTimes = null;
    exitTimes = null;
    treeOutDegree = null;
    reachableAncestor = null;
  }
  /// [GraphSearchDelegate] Processes the delegate when first discovered
  processVertexEarly( EdgeNode v ) { 
    reachableAncestor[ v ] = v; // Initially the earliest reachable ancestor is itself
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
//    print("\tFound edge [${a.a}, ${b.a}]");
    if( entryTimes[ b ] < entryTimes[ reachableAncestor[a] ] )
      reachableAncestor[b] = a;
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode v ) {
    bool root;        // is this vertex the root of the DFS tree?
    int time_v;       // earliest reachable time  for v
    int time_parent;  // earliest reachable time for parentMap[a]
    
    // Check for root cutnode
    if( parent[v] == null ) {
      if( treeOutDegree[v.a] > 1 ) 
        print("root articulation vertex: ${v.a}");
      
      return;
    }
    
    // Check for parent cutnode
    root = ( parent[ parent[v] ] == null ); // is parent[v] the root?
    if( (reachableAncestor[v] == parent[v] ) && !root ) {
      print("parent articulation vertex: ${parent[v]}");
    }
    
    // Check for bridge cutnode
    if( reachableAncestor[v] == v ) {
      print("bridge articulation vertex: ${parent[v]}");
      
      if( treeOutDegree[v.a] > 0 ) { // Test if V is not a leaf
        print("bridge articulation vertex: ${v}");
      }
    }
    
    time_v = entryTimes[ reachableAncestor[v] ];
    time_parent = entryTimes[ reachableAncestor[ parent[v] ] ];
    
    if( time_v < time_parent )
        reachableAncestor[ parent[v] ] = reachableAncestor[v];
  }
}
