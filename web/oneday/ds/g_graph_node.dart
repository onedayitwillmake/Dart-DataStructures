part of ds;


class GGraphNode<T> {

  /// A reference to the value stored in this node
  T value;

  /// Map containing links to other [GGGraphNode] we are connected to
  Map< int, GGraphNode<T> > arcs = new Map< int, GGraphNode<T> >();

  /// Pointer to next [GGraphNode] in the list
  GGraphNode<T> next;

  /// UUID if this [GGGraphNode]
  int id;
  
  /// How many connects does this [GGraphNode] have
  int degree =0;
  

  /// Creates a new [GGraphNode]
  GGraphNode( this.id, T this.value );

  int hashCode() => id;
  bool operator==( other ) => other == this;
}
