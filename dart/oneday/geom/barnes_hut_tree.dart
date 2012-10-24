part of geom;

class BarnesHutTree extends QuadTree {
  // For Barnes-Hut algorithm
  // TODO: I'd really like to move this out of the QuadTree
  /// If true will calculate centerMass/mass when a node is added removed
  bool _isBarnesHutTree = false;
  /// Mass of this [QuadTree] (The total mass of each node it contains)
  num mass = 0;
  /// Center of mass of this node, based on it's children and their mass
  Vec2 centerMass;
  
  BarnesHutTree( int x, int y, int width, int height, [ int pMaxObjectsPerNode=3, int pMaxDepth=6]) : super(x,y,width,height,pMaxObjectsPerNode, pMaxDepth);
  
  void _createRootNode( int x, int y, int width, int height ) {
    quadTreeRoot = new BarnesHutTreeNode(null, new Rect(x,y, width, height), maxObjectsPerNode, maxDepth );
  }
}

/// Maintains a total mass, and center of gravity for all it's children
class BarnesHutTreeNode extends QuadTreeNode {
  /// Mass of this tree (cummaltive mass of all it's children)
  num mass = 0;
  
  /// Center of mass (based on all children and each one's relative mass)
  Vec2 centerMass;
  
  /// Constructor
  BarnesHutTreeNode( QuadTreeNode parent, Rect aRect, int maxObjectsPerNode, int maxDepth ) : super( parent, aRect, maxObjectsPerNode, maxDepth );
  
  QuadTreeNode createChildNode( QuadTreeNode parent, Rect aRect, int pMaxObjectsPerNode, int pMaxDepth ) {
    BarnesHutTreeNode node = new BarnesHutTreeNode( parent, aRect, pMaxObjectsPerNode, pMaxDepth );
    return node;
  }
  
  /// Assimilate this node into our [QuadTree] by adjusting our centerMass
  void _assimilateNode( QuadTreeObject aNode ) {
    if( centerMass == null ) { // Lazy creation
      centerMass = new Vec2(0,0);
    }
//    print("Position:${(aNode.data as IBarnesHutStorable).position}");
    
    centerMass.x = ( mass * centerMass.x + (aNode.data as IBarnesHutStorable).position.x ) / ( mass+1 );
    centerMass.y = ( mass * centerMass.y + (aNode.data as IBarnesHutStorable).position.y ) / ( mass+1 );
    mass += (aNode.data as IBarnesHutStorable).mass;
  }
}


/// To exist an BarnesHutTree we require a position and a mass for this object
abstract class IBarnesHutStorable extends IQuadStorable{
  Vec2 get position;
  num get mass;
}
