/**
 * An [EdgeNode] is a data-structure in a [Graph] which connects two nodes
 * It is implemented here as a LinkedList
 * @author Mario Gonzalez | onedayitwillmake.com
 */
class EdgeNode {
  /// start node  
  num a = 0;         
  /// end node
  num b = 0;          
  
  /// edge weight
  int weight = 0;     
  
  /// UUID of this [EdgeNode]
  int id;             
  
  /// next edge in list
  EdgeNode next = null;
  
  /** Creates an [EdgeNode] with pY as the connecting vertex */
  EdgeNode( num pA, num pB, num pId, num pWeight ) : a = pA, b = pB, weight = pWeight, id = pId {}
  
  toString() => ( "(${a}->${b})" );
}
