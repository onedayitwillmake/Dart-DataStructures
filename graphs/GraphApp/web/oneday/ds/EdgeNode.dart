class EdgeNode {
  num y = 0;          // adjency info
  int weight = 0;     // edge weight info
  EdgeNode next = null;  // next edge in list
  
  /** Creates an [EdgeNode] with pY as the connecting vertex */
  EdgeNode( num pY, num pWeight ) : y = pY, weight = pWeight {}  
}
