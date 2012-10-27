part of ds;

/**
 *  The base class for graph-search algorithms.
 */
class GGraphSearch implements Disposable {
  /// Vertex is in initial untouched states. Initially the only vertex in [UNDISCOVERED] is the start vertex
  static final num STATE_UNDISCOVERED = 0;
  /// Vertex has been found, but we have not yet checked out all it's incident edges
  static final num STATE_DISCOVERED = 1;
  /// The vertex after we have visited all it's incident edges
  static final num STATE_PROCESSED = 2;

  /// A mapping from [GGraphEdge] <-> either [UNDISCOVERED] or [DISCOVERED]
  Map< GGraphEdge, int > edgeState;

  /// A mapping of [GGraphEdge] (via their .id property) to another [GGraphEdge]
  Map< GGraphEdge, GGraphEdge > parent;

  /// The [GGraph] instance to be processed.
  GGraph graph;

  /// Start vertex
  GGraphNode start;

  /// Goal vertex if applicable
  GGraphNode goal;

  /// A delegate which follows the [BFSDelegate] interface
  GGraphSearchDelegate _delegate;

  /// If true the search will stop  at the next possible point
  bool isFinished;


  GGraphSearch( this.graph, this.start, this.goal );

  /// Clear for GC
  void dispose() {
    edgeState = null;
    parent = null;
    start = null;
    goal = null;
    _delegate = null;
  }

  /// Resets all book keeping properties of this BFS (fifoQueue, parentMap, edgeStateMap)
  void resetGraph() {
    edgeState = new Map< GGraphEdge, int >();
    parent = new Map< GGraphEdge, GGraphEdge >();
  }

  /// Returns the path from a start node, to an edge node. **IMPORTANT** Assumes the search ( [execute] ) has already been performed.
  List<GGraphEdge> findPath( GGraphEdge start, GGraphEdge end ) {
    List<GGraphEdge >path = new List<GGraphEdge>();

    if( start == end || end == null ) {
      path.addLast( start );
      print("${start.a}");
    } else {
      findPath( start, parent[end] ); // Recurisve
      path.addLast( end );
      print("${end.a}");
    }

    return path;
  }

  /// Returns true if this edge node has not yet been discovered
  bool edgeNodeIsNotDiscovered( GGraphEdge e ) => ( edgeState[ e ] != STATE_DISCOVERED && edgeState[ e ] != STATE_PROCESSED );

  /// Returns true if this edge node has not yet been processed
  bool edgeNodeIsNotProccessed( GGraphEdge e ) => ( edgeState.containsKey(e) == false || edgeState[ e ] != STATE_PROCESSED );
}


/// An interface for processing nodes in the graph
interface GGraphSearchDelegate {
  /// Called when an EdgeNode is popped from the queue
  processVertexEarly( GGraphEdge v );

  /// Called when a new Edge connection is found
  processEdge( GGraphNode a, GGraphNode b);

  /// Called when the vertex has been fully processed ( All recursively connected nodes discovered )
  processVertexLate( GGraphEdge v );
}
