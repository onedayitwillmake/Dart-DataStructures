part of ds;

/**
 * An [GGraphEdge] is a data-structure in a [Graph] which connects two [GGraphNode]
 */
class GGraphEdge {
  /// Points to a direct descendant
  static final int EDGE_TYPE_TREE = 0;

  /// Points back to ancesstor vertex
  static final int EDGE_TYPE_BACK = 1;

  /// Points to grandchild decendent vertex
  static final int EDGE_TYPE_FORWARD = 2;

  /// Links two unrelated vertices
  static final int EDGE_TYPE_CROSS = 3;

  /// start [GGraphNode]
  GGraphNode a;

  /// end [GGraphNode]
  GGraphNode b;

  /// Next [GGraphEdge] in list.
  GGraphEdge next;

  /// edge weight
  int weight;


  /// Creates an [GGraphEdge] with [GGraphNode] a, and [GGraphNode] b
  GGraphEdge( this.a, this.b );

  toString() => ( "(${a.id}->${b.id})" );
}
