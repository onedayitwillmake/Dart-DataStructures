/**
 * BreadthFirstSearch is graph search strategy which begins at the root node, and inspects all neighboring nodes, 
 * and in turn inspects their neighboring nodes which were unvisited, and so on  
 * Mario Gonzalez | onedayitwillmake.com
 */
class BreadthFirstSearch extends GraphSearch implements BFSDelegate {     
  static final int COLOR_UNCOLORED = 0; 
  static final int COLOR_RED = 1;
  static final int COLOR_BLACK = 2;
  
  /**
   * A FIFO style Queue used to store [DISCOVERED] graph vertices
   */
  Queue< EdgeNode > fifoQueue;
  
  /// A delegate which follows the [BFSDelegate] interface
  BFSDelegate _delegate;
  
  /// Current vertex
  EdgeNode _a;    
  /// Successor vertex
  EdgeNode _b;    
  
  BreadthFirstSearch( Graph aGraph, EdgeNode aStartNode ) : super( aGraph, aStartNode ) {
    resetGraph();
//    twocolor();
//    connectedComponents();
//    execute();
//    findPath( _start, graph.getNode(4) );
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
    
    EdgeNode p;
    
    // Add the start node to the queue and set it to discovered
    fifoQueue.addFirst( _start );
    edgeStateMap[ _start.id ] = STATE_DISCOVERED;
    
    
    while( !fifoQueue.isEmpty() ) {
      _a = fifoQueue.removeFirst();
      
      processVertexEarly( _a );
      edgeStateMap[ _a.a ] = STATE_PROCESSED;
      
      p = _a;
      while( p != null ) {
        _b = graph.getNode( p.b );
        
        // new edge
        if( edgeStateMap[ _b.a ] != STATE_PROCESSED || graph.isDirected ) {
          processEdge( _a, _b );
        }
        
        // Since this is a new connection, add it to the queue and store it's parent
        if( edgeNodeIsNotDiscovered( _b.a ) ) {
          fifoQueue.addFirst( _b );
          edgeStateMap[ _b.a ] = STATE_DISCOVERED;
          parentMap[ _b ] = _a;
        }
        
        p = p.next;
      }
      processVertexLate( _a );
    }
  }
  
  /// Returns the path from a start node, to an edge node. **IMPORTANT** Assumes the bfs ( [execute] ) has already been performed.
  List<EdgeNode> findPath( EdgeNode start, EdgeNode end ) {
    List<EdgeNode >path = new List<EdgeNode>();
    
    if( start == end || end == null ) {
      path.addLast( start );
      
      print("${start.a}");
    } else {
      findPath( start, parentMap[end] ); // Recurisve
      path.addLast( end );
      
      print("${end.a}");
    }
    
    return path;
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
  
  /// Returns a mapping of [EdgeNode] to COLOR_RED | COLOR_BLACK if the graph is **bipartite**
  Map< EdgeNode, int > twocolor( ) {
    
    BiPartiteColorDelegate twoColorHelper = new BiPartiteColorDelegate();
    
    // Store the current delegate in a temporary variable
    BFSDelegate prevDelegate = _delegate;
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
  
// BFSDELEGATE METHODS
  
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
/**
 * An interface for processing nodes in the graph
 */
interface BFSDelegate {
  /// Called when an EdgeNode is popped from the queue
  processVertexEarly( EdgeNode a );       
  
  /// Called when a new Edge connection is found
  processEdge( EdgeNode a, EdgeNode b);  
  
  /// Called when the vertex has been fully processed ( All recursively connected nodes discovered )
  processVertexLate( EdgeNode a );       
}

/**
 * A simple BFSDelegate which is used by the twocolor function to create a bipartite graph coloring
 */
class BiPartiteColorDelegate implements BFSDelegate {
  /// Whether this graph is is bipartite or not
  bool isBiPartite = true;
  
  /// Stores the current coloring information for each [EdgeNode]
  Map< EdgeNode, int > colorMapping = new Map< EdgeNode, int >();
  
  
  void processEdge( EdgeNode a, EdgeNode b) {
    if( colorMapping[a] == colorMapping[b] ) {
      isBiPartite = false;
      print("Warning: not bipartite due to  (${a.a},${b.a})");
    }
    
    colorMapping[b] = complement( colorMapping[a] );
  }
  
  /**
   *  Returns the complementory color for the type passed in.
   *  That is BreadthFirstSearch.COLOR_RED if black is passed in, and BreadthFirstSearch.COLOR_BLACK if red is passed in. If neither is passed in BreadthFirstSearch.COLOR_NONE is returned.
   */ 
  int complement( int color ) {
    if( color == BreadthFirstSearch.COLOR_RED ) return BreadthFirstSearch.COLOR_BLACK;
    if( color == BreadthFirstSearch.COLOR_BLACK ) return BreadthFirstSearch.COLOR_RED;
    return BreadthFirstSearch.COLOR_UNCOLORED;
  }
  
  // The following two callbacks are unused
  void processVertexEarly( EdgeNode a ) {}
  void processVertexLate( EdgeNode a ) {}
}