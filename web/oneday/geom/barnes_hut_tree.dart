part of geom;

class BarnesHutTree extends QuadTree {
  /**
  * Ratio s/d where S is the width of the region represented by the internal node, nad d is the distance between the body and the nodes center of mass
  */
  num theta = 0.5;
  /// If true will calculate centerMass/mass when a node is added removed
  bool _isBarnesHutTree = false;
  
  /// Mass of this [QuadTree] (The total mass of each node it contains)
  num mass = 0;
  /// Center of mass of this node, based on it's children and their mass
  Vec2 centerMass;
  
  /// Arbitary number representing the optimum distance
  num optimalDistance = 30;
  
  Function _calculateForceImp = null;
  
  BarnesHutTree( int x, int y, int width, int height, [ int pMaxObjectsPerNode=3, int pMaxDepth=6]) : super(x,y,width,height,pMaxObjectsPerNode, pMaxDepth) {
//    _calculateForceImp = _calculateForceGravity; 
  }
  
  void _createRootNode( int x, int y, int width, int height ) {
    quadTreeRoot = new BarnesHutTreeNode(null, new Rect(x,y, width, height), maxObjectsPerNode, maxDepth );
  }

 
  Vec2 calculateForce( IBarnesHutStorable item, BarnesHutTreeNode tree ) {
    if( tree.mass <= 0 ) {
      return null;
    }
    
    num distance = item.getPosition().distance( tree.centerMass );
    
    if( distance < 1e-8 ) {
      return null;
    }
    
    if( tree.mass == 1 ) {
      if( wrappedDictionary[item].owner == tree ) return null;
      return _calculateForceImp( item, tree, distance );
    }
    
    num s = tree.rect.width;
    num d = distance;
    
    if( s/d < theta ) {
      Vec2 f = _calculateForceImp( item, tree, distance );
      f.multiply( tree.mass );
      return f;
    }
    
    Vec2 f = new Vec2(0,0);
    
    f.add( calculateForce( item, tree.childTL ) );
    f.add( calculateForce( item, tree.childTR ) );
    f.add( calculateForce( item, tree.childBR ) );
    f.add( calculateForce( item, tree.childBL ) );
    
    return f;
  }
  /*
  void calculateForce( IBarnesHutStorable item, BarnesHutTreeNode tree, Vec2 force ) {
    if( tree.mass <= 0 ) {
      return;
    }

    num distanceSq = item.getPosition().distanceSquared( tree.centerMass );
    if( tree.childTL == null ) {
      if( distanceSq < 1e-8 ) {
        return;
      }
      
      Vec2 f = _calculateForceImp( item, tree, distanceSq );
      force.add(f);
      return;
    }
    
    if( distanceSq*theta > tree.rect.width * tree.rect.width ) {
      Vec2 f = _calculateForceImp( item, tree, distanceSq );
      f.multiply( tree.mass );
      force.add(f);
      
      return;
    }
    
    calculateForce( item, tree.childBL, force );
    calculateForce( item, tree.childTL, force );
    calculateForce( item, tree.childTR, force );
    calculateForce( item, tree.childBR, force );
    
  }
  
  */
  
  Vec2 _calculateForceSoftSpring( ISpatial node1, ISpatial node2, num distance ) {
    Vec2 a = node1.getPosition();
    Vec2 b = node2.getPosition();
    
    Vec2 f = new Vec2(0,0);
    num dx = b.x - a.x;
    num dy = b.y - a.y;
    
    if( dx+dy > 1 ) {
      num mag = Math.sqrt( dx*dx+dy*dy );
      num ext = mag - optimalDistance;
      f.x += (dx / mag * ext) * 0.1;
      f.y += (dy / mag * ext) * 0.1;
    }
    
    return f;
  }
  
  Vec2 calculateForceGravity( ISpatial node1, ISpatial node2, num distance ) {
    Vec2 a = node1.getPosition();
    Vec2 b = node2.getPosition();
//    distance -= optimalDistance;
    
    num EPS = 0.1;      // softening parameter
    

    
    num G = 100.06;
    
    num dx = b.x - a.x;
    num dy = b.y - a.y;
    num dist = Math.sqrt(dx*dx + dy*dy);

    if( dist < optimalDistance) return new Vec2(0,0);

    num F = G / (dist*dist + EPS*EPS);
    return new Vec2(F * dx / dist, F * dy / dist);
  }
}

/// Maintains a total mass, and center of gravity for all it's children
class BarnesHutTreeNode extends QuadTreeNode implements ISpatial {
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
    centerMass.x = ( mass * centerMass.x + (aNode.data as IBarnesHutStorable).getPosition().x ) / ( mass+1 );
    centerMass.y = ( mass * centerMass.y + (aNode.data as IBarnesHutStorable).getPosition().y ) / ( mass+1 );
    mass += (aNode.data as IBarnesHutStorable).mass;
  }
  
  void _remove( QuadTreeObject item ) {
    mass -= (item.data as IBarnesHutStorable).mass;
    super._remove( item );
  }
  
  Vec2 getPosition() => centerMass;
}


/// To exist an BarnesHutTree we require a position and a mass for this object
abstract class IBarnesHutStorable implements IQuadStorable{
  num get mass;
}
