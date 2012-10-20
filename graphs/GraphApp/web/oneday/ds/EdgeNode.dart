part of ds;

/**
 * An [EdgeNode] is a data-structure in a [Graph] which connects two nodes
 * It is implemented here as a LinkedList
 * @author Mario Gonzalez | onedayitwillmake.com
 */
class EdgeNode {
  /// Points to a direct descendant
  static final int EDGE_TYPE_TREE = 0;

  /// Points back to ancesstor vertex
  static final int EDGE_TYPE_BACK = 1;

  /// Points to grandchild decendent vertex
  static final int EDGE_TYPE_FORWARD = 2;

  /// Links two unrelated vertices
  static final int EDGE_TYPE_CROSS = 3;

  /// start node
  num x = 0;
  /// end node
  num y = 0;

  /// edge weight
  int weight = 0;

  /// UUID of this [EdgeNode]
  int id;

  /// next edge in list
  EdgeNode next = null;

  /** Creates an [EdgeNode] with pY as the connecting vertex */
  EdgeNode( num pA, num pB, num pId, num pWeight ) : x = pA, y = pB, weight = pWeight, id = pId {}

  toString() => ( "(${x}->${y})" );
}
