part of ds;

class GraphSearch implements Disposable {
  /// Vertex is in initial untouched states. Initially the only vertex in [UNDISCOVERED] is the start vertex
  static final num STATE_UNDISCOVERED = 0;
  /// Vertex has been found, but we have not yet checked out all it's incident edges
  static final num STATE_DISCOVERED = 1;
  /// The vertex after we have visited all it's incident edges
  static final num STATE_PROCESSED = 2;


  /**
   * A mapping from [EdgeNode] <-> either [UNDISCOVERED] or [DISCOVERED]
   */
  Map< int, int >       edgeStateMap;

  /**
   * A mapping of [EdgeNode] (via their .id property) to another [EdgeNode]
   */
  Map< EdgeNode, EdgeNode >  parent;

  /**
   * The [Graph] instance to be processed
   */
  Graph graph;

  /// Start vertex
  EdgeNode _start;

  /// Goal vertex if applicable
  EdgeNode _goal;

  /// A delegate which follows the [BFSDelegate] interface
  GraphSearchDelegate _delegate;

  /// Constructor
  GraphSearch( this.graph, this._start );

  /// Clear memory
  void dispose() {
    edgeStateMap = null;
    parent = null;
    _start = null;
    _goal = null;
    _delegate = null;
  }

  /// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    edgeStateMap = new Map< int, int >();
    parent = new Map< EdgeNode, EdgeNode >();
  }

  /// Returns the path from a start node, to an edge node. **IMPORTANT** Assumes the search ( [execute] ) has already been performed.
  List<EdgeNode> findPath( EdgeNode start, EdgeNode end ) {
    List<EdgeNode >path = new List<EdgeNode>();

    if( start == end || end == null ) {
      path.addLast( start );

      print("${start.x}");
    } else {
      findPath( start, parent[end] ); // Recurisve
      path.addLast( end );

      print("${end.x}");
    }

    return path;
  }

  /// Returns true if this edge node has not yet been discovered
  edgeNodeIsNotDiscovered( num x ) => ( edgeStateMap[ x ] != STATE_DISCOVERED && edgeStateMap[ x ] != STATE_PROCESSED );
}

/**
 * An interface for processing nodes in the graph
 */
interface GraphSearchDelegate {
  /// Called when an EdgeNode is popped from the queue
  processVertexEarly( EdgeNode v );

  /// Called when a new Edge connection is found
  processEdge( EdgeNode u, EdgeNode v);

  /// Called when the vertex has been fully processed ( All recursively connected nodes discovered )
  processVertexLate( EdgeNode v );
}
