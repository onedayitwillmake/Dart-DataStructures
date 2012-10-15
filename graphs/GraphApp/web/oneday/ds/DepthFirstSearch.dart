
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
      
      if( edgeNodeIsNotDiscovered( b.x ) ) {
        parent[b] = a;
        processEdge( a, b );
        execute( b );
      } else if ( edgeStateMap[ b.x ] != GraphSearch.STATE_PROCESSED /*|| graph.isDirected */ ) {
        processEdge( a, b );
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
  void findArticulationVertices([ EdgeNode start ]) {
    resetGraph();
    
    // store the prev delegate, and set _delegate to a a new [ArticulationVerticesDelegate] instance
    GraphSearchDelegate prevDelegate = _delegate;
    
    ArticulationVerticesDelegate articulationDelegate = new ArticulationVerticesDelegate( this.entryTimes, this.exitTimes, this.parent );
    _delegate = articulationDelegate;
  
    execute( start );
    
    articulationDelegate.onComplete();
  }
  
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

/**
 *  Used by the [findArticultionVertices] function 
 */
class ArticulationVerticesDelegate implements GraphSearchDelegate, Disposable {
  
  /// Keeps track of the current earliest reachable ancestor for an [EdgeNode]
  Map< int, int > reachableAncestor = new Map< int, int >();
  
  /// DFS tree outdegree of an [EdgeNode] v
  Map< int, int > treeOutDegree = new Map<int, int>();
  
  /// A mapping from [EdgeNode] to times when the node was entered
  Map< int, int >       entryTimes;
  
  /// A mapping from [EdgeNode] to times when the node was exited
  Map< int, int >       exitTimes;
  
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
    reachableAncestor[ v.x ] = v.x; // Initially the earliest reachable ancestor is itself
  }

  /// [GraphSearchDelegate] Processes an edge connecting two [EdgeNode]
  processEdge( EdgeNode a, EdgeNode b) {
    if( treeOutDegree[b.x] == null) treeOutDegree[b.x] = 0;
    else treeOutDegree[b.x] += 1;
    
    if( entryTimes[b.x] == null || entryTimes[ b.x ] < entryTimes[ reachableAncestor[a.x] ] )
      reachableAncestor[b.x] = a.x;
  }

  /// [GraphSearchDelegate] Processes a vertex after all it's children have been discovered and explored
  processVertexLate( EdgeNode v ) {
    bool root;        // is this vertex the root of the DFS tree?
    int time_v;       // earliest reachable time  for v
    int time_parent;  // earliest reachable time for parentMap[a]
    
    // Check for root cutnode
    if( parent[v] == null ) {
      if( treeOutDegree[v.x] > 1 ) 
        print("root articulation vertex: ${v.x}");
      
      return;
    }
    
    // Check for parent cutnode
    root = ( parent[ parent[v] ] == null ); // is parent[v] the root?
    if( (reachableAncestor[v.x] == parent[v].x ) && !root ) {
      print("parent articulation vertex: ${parent[v]}");
    }
    
    // Check for bridge cutnode
    if( reachableAncestor[v.x] == v.x ) {
      print("bridge articulation vertex: ${parent[v]}");
      
//      if( treeOutDegree[v.x] > 0 ) { // Test if V is not a leaf
//        print("bridge articulation vertex: ${v}");
//      }
    }
    
    time_v = entryTimes[ reachableAncestor[v.x] ];
    time_parent = entryTimes[ reachableAncestor[ parent[v].x ] ];
    
    if( time_v < time_parent )
        reachableAncestor[ parent[v].x ] = reachableAncestor[v.x];
  }

  onComplete() {
    entryTimes = null;
    exitTimes = null;
    parent = new Map< EdgeNode, EdgeNode>.from( parent );
  }
}
