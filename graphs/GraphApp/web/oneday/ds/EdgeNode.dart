/**
 * An [EdgeNode] is a data-structure in a [Graph] which connects two nodes
 * It is implemented here as a LinkedList
 * @author Mario Gonzalez | onedayitwillmake.com
 */
class EdgeNode {
  num y = 0;          // adjency info
  int weight = 0;     // edge weight info
  int id;
  EdgeNode next = null;  // next edge in list
  
  /** Creates an [EdgeNode] with pY as the connecting vertex */
  EdgeNode( num pY, num pId, num pWeight ) : y = pY, weight = pWeight, id = pId {}  
}
