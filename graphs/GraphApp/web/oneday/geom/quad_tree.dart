/**
 * A quadtree datastructure, for efficient spatial subdivsion
 */
class QuadTree {
  Map< IQuadStorable, QuadTreeObject > wrappedDictionary = new Map< IQuadStorable, QuadTreeObject >();
  QuadTreeNode quadTreeRoot;
  
  QuadTree( int x, int y, int size ) {
    quadTreeRoot = new QuadTreeNode.fromExtents(null, x,y,size);
  }
  
  /// Adds an item
  add(IQuadStorable item) {
    QuadTreeObject wrappedObject = new QuadTreeObject(item);
    wrappedDictionary[item] = wrappedObject;
    quadTreeRoot._insert( wrappedObject );
  }
  
  /// Removes an item
  bool remove(IQuadStorable item) {
    var removedItem = wrappedDictionary.remove( item );
    if( removedItem != null ) { // Map.remove only returns the object if it was removed ( thus existed )
      quadTreeRoot._delete( wrappedDictionary[item], true );
      return true;
    }
    
    return false;
  }
  
  /// Removes all items
  clear() {
    wrappedDictionary.clear();
    quadTreeRoot._clear();
  }
  
  /// Determins whether the [QuadTree] contains a specific value
  bool contains( IQuadStorable item ) => wrappedDictionary.containsKey( item );
  
  /// The rectangluar bounds
  Rect quadRect() => quadTreeRoot.rect;
  
  /// Number of elements contained
  int count() => wrappedDictionary.length;
}

class QuadTreeNode {
  
  /// Maximum number of objects we will contain before splitting
  int maxObjectsPerNode = 2;
  
  /// The objects in this [QuadTreeNode]
  List< QuadTreeObject > objects;
  
  /// Area this [QuadTreeNode] represents
  Rect rect;
  
  /// Parent of this [QuadTreeNode]
  QuadTreeNode parent;
  
  // Children in clockwise order
  QuadTreeNode childTL;
  QuadTreeNode childTR;
  QuadTreeNode childBR;
  QuadTreeNode childBL;
  
  /// Creates a new [QuadTreeNode] from x,y topleft position that is 'width' in size 
  factory QuadTreeNode.fromExtents( QuadTreeNode parent, int x, int y, int size ) {
    return new QuadTreeNode( parent, new Rect(x,y, size, size) );
  }
  
  QuadTreeNode( this.parent, this.rect );

  
  /// Adds an item to the object list
  void _add( QuadTreeObject item ) {
    if( objects == null ) 
      objects = new List< QuadTreeObject >();
    
    item.owner = this;
    objects.addLast( item );
  }
  
  /// Removes an item from the object list
  void _remove( QuadTreeObject item ) {
    if( objects != null ) {
      int removeIndex = objects.indexOf(item, 0);
      if( removeIndex >= 0 ) {
        // Place the current last one at the index of the one we're removing
        objects[removeIndex] = objects.last();
        objects.removeLast();
      }
    }
  }
  
  /// Get the total for all objects in this QuadTreeNode including children
  int _objectCount() {
    int count = 0;
    
    // Add any objects we contain
    if( objects != null ) count += objects.length;
    
    // Add any objects our children contain
    if( childTL != null ) {
      count += childTL._objectCount();
      count += childTR._objectCount();
      count += childBR._objectCount();
      count += childBL._objectCount();
    }
    
    return count;
  }
  
  /// Subdivide this [QuadTreeNode] and move it's children in to the appropriate quads
  void _subdivide() {
    Vec2 size = new Vec2( rect.width /2, rect.height / 2 );
    Vec2 mid = new Vec2( rect.x + size.x, rect.y + size.y );
    
    childTL = new QuadTreeNode( this, new Rect( rect.left(), rect.top(), size.x, size.y ) );
    childTR = new QuadTreeNode( this, new Rect( mid.x, rect.top(), size.x, size.y ) );
    childBL = new QuadTreeNode( this, new Rect( rect.left(), mid.y, size.x, size.y ) );
    childBR = new QuadTreeNode( this, new Rect( mid.x, mid.y, size.x, size.y ) );
    
    // If they're completely contained by the quad, bump objects down
    for( int i = 0; i < objects.length; i++ ) {
      QuadTreeObject item = objects[i];
      
      QuadTreeNode destTree = _getDestinationTree( item );
      if( destTree != this ) {
        destTree._insert(item );
        _remove( item );
        i--;
      }
    }
  }

  /// Get the child Quad that would contain an object
  QuadTreeNode _getDestinationTree( QuadTreeObject  item ) {
    QuadTreeNode destTree = this;
    
    if( item.data.isInRect( childTL.rect ) ) {
      destTree = childTL;
    } else if( item.data.isInRect( childTR.rect ) ) {
      destTree = childTR;
    } else if( item.data.isInRect( childBR.rect ) ) {
      destTree = childBR;
    } else if( item.data.isInRect( childBL.rect ) ) {
      destTree = childBL;
    }
    
    return destTree;
  }
  
  void _relocate(  QuadTreeObject  item ) {
    
    // Still inside our parent?
    if( item.data.isInRect( rect ) ) {
      
      // Have we moved inside any of our children?
      if( childTL != null ) {
        QuadTreeNode destTree = _getDestinationTree( item );
        if( item.owner != destTree ) {
          // Delete the item from this quad and add it to our child
          QuadTreeNode formerOwner = item.owner;
          _delete( item, false );
          destTree._insert( item );
          
          // Cleanup ourselves
          formerOwner._cleanUpwards();
        }
      }
    } else { // We don't fit - try to move to the parent
      if( parent != null ) {
        parent._relocate( item );
      }
    }
  }
  
  
  void _cleanUpwards() {
    if( childTL != null ) {
      
      // If all the children are empty, delete the children
      if( childTL.isEmptyLeaf() && 
          childTR.isEmptyLeaf() &&
          childBL.isEmptyLeaf() &&
          childBR.isEmptyLeaf() ) {
        childTL = null;
        childTR = null;
        childBL = null;
        childBR = null;
        
        // We don't have any objects, have our parent call clean on itself
        if( parent != null && count() == 0 ) 
          parent._cleanUpwards();
      }
    } else if( parent != null && count() == 0 ) { // This object itself could be one of 4 empty leaf nodes, tell parent to clean up
      parent._cleanUpwards();
    }
  }
  

  _clear() {
    if( childTL != null ) {
      childTL._clear();
      childTR._clear();
      childBL._clear();
      childBR._clear();
    }
    
    if( objects != null ) {
      objects.clear();
      objects = null;
    }
    
    childTL = null;
    childTR = null;
    childBL = null;
    childBR = null;
  }

  /**
   * Deletes an item from the [QuadTreeNode].
   * If the object is removed causes this quad to have no objects in it's children, it's children will be removed as well
   */
  _delete(QuadTreeObject item, bool clean) {
    if( item.owner != null ) {
      if( item.owner == this ) {
        _remove( item );
        
        if( clean )
          _cleanUpwards();
      } else {
        item.owner._delete( item, clean );
      }
    }
  }

  /// Insert an item into the [QuadTreeNode].
  void _insert(QuadTreeObject item) {
     // If this quad doesn't contain the items rect don't do anything unless we're the rootquad
    if( ! item.data.isInRect( rect ) ) {
      assert( parent == null );
      if( parent == null ) {
        _add( item );
      } else { 
        return;
      }
    }
    
    // There is room to add this object
    if( objects == null || ( childTL == null && objects.length + 1 <= maxObjectsPerNode) ) {
      _add( item );
    } else {
      /// Create quads and bump existing objects down
      if( childTL == null ){
        _subdivide();
      }
      
      QuadTreeNode destTree = _getDestinationTree( item );
      if( destTree == this ) {
       _add( item );
      } else {
        destTree._insert( item );
      }
    }
  }
  
  /// Moves the [QuadTreeObject] in the tree
  void _move( QuadTreeObject item ) {
    if( item.owner != null ) {
      item.owner._relocate( item );
    } else {
      _relocate( item );
    }
  }
  
  /// Returns aoo the objects in this tree that are contained within the supplied [Rect]
  List< IQuadStorable > _getObjects( Rect searchRect ) {
    List< IQuadStorable > results = new List< IQuadStorable >();
    _getObjectsImpl( searchRect, results );
    return results;
  }

  void _getObjectsImpl( Rect searchRect, List< IQuadStorable > results ) {
    if( results == null ) return;
    if( searchRect.containsRect( rect ) ) {
      _getAllObjects( results );
    } else if ( searchRect.intersectsRect( rect ) ) { // Add objects that intersect with the searchRect
      
      if( objects != null ) { // We have an object list - run through each one
        objects.forEach(void f( QuadTreeObject item ){ 
          if( item.data.intersectsRect( searchRect ) ) {
            results.addLast( item.data );
          }
        });
      }
      
      // Recurse through our children
      if( childTL != null ) {
        childTL._getObjectsImpl( searchRect, results );
        childTR._getObjectsImpl( searchRect, results );
        childBL._getObjectsImpl( searchRect, results );
        childBR._getObjectsImpl( searchRect, results );
      }
    }
  }
  
  void _getAllObjects( List< IQuadStorable > results ) {
    if( objects != null ) { // We have an object list - run through each one
      objects.forEach(void f( QuadTreeObject item ) => results.addLast( item.data ) );
    }
    
    if( childTL != null ) {
      childTL._getAllObjects( results );
      childTR._getAllObjects( results );
      childBL._getAllObjects( results );
      childBR._getAllObjects( results );
    }
  }
  
  topLeftChild() => childTL;
  topRightChild() => childTR;
  bottomRightChild() => childBR;
  bottomLeftChild() => childBL;
  
  count() => _objectCount();
  
  /// Returns true if this is an empty leaf node
  isEmptyLeaf() => _objectCount() == 0 && childTL == null;
  
}

class QuadTreeObject {
  
  QuadTreeNode  owner;
  IQuadStorable data;
  
  QuadTreeObject( this.data );
  
  /// Clear memory for GC
  void dispose() {
    owner = null;
    data = null;
  }
}

interface IQuadStorable {
  bool isInRect( Rect r );
  bool intersectsRect( Rect r );
}