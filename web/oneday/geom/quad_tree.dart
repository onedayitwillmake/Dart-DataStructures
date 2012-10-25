part of geom;

/// A quadtree datastructure, for efficient spatial subdivsion
class QuadTree {
  /// All objects contained in the [QuadTree]
  Map< IQuadStorable, QuadTreeObject > wrappedDictionary = new Map< IQuadStorable, QuadTreeObject >();

  /// Root node of the [QuadTree]
  QuadTreeNode quadTreeRoot;

  /// Maximum number of objects we will contain before splitting
  int maxObjectsPerNode = 2;

  /// Maximum depth of the tree, this superceedes maxObjectsPerNode
  int maxDepth = 4;

  QuadTree( int x, int y, int width, int height, [int pMaxObjectsPerNode=1, int pMaxDepth=10]) : maxObjectsPerNode=pMaxObjectsPerNode, maxDepth=pMaxDepth {
    _createRootNode(x,y,width,height);
  }

  /// Creates the [QuadTreeNode] which is the root of this tree
  void _createRootNode( int x, int y, int width, int height ) {
    quadTreeRoot = new QuadTreeNode.fromExtents(null, x,y, width, height, maxObjectsPerNode, maxDepth );
  }

  /// Adds a node
  void add(IQuadStorable item) {
    QuadTreeObject wrappedObject = new QuadTreeObject(item);
//    print("QuadTree::add\n\titem_id=${wrappedObject.UUID}");
      
    wrappedDictionary[item] = wrappedObject;
    quadTreeRoot.insert( wrappedObject );
  }

  /// Removes an node
  bool remove(IQuadStorable item) {
    
    var removedItem = wrappedDictionary.remove( item );
    if( removedItem != null ) { // Map.remove only returns the object if it was removed ( thus existed )
      quadTreeRoot.delete( removedItem, true );
      return true;
    }

    return false;
  }
  
  void getObjects( Rect searchRect, List< IQuadStorable > results ) => quadTreeRoot.getObjects( searchRect, results );
  
  /// Determins whether the [QuadTree] contains a specific value
  bool contains( IQuadStorable item ) => wrappedDictionary.containsKey( item );
  
  /// Removes all items
  clear() {
    wrappedDictionary.clear();
    quadTreeRoot.clear();
  }

  /// The rectangluar bounds
  Rect get quadRect => quadTreeRoot.rect;

  /// Number of elements contained
  int get count => wrappedDictionary.length;
}

/// The actual QuadTree recursive data-structure
class QuadTreeNode {

  /// Maximum number of objects we will contain before splitting
  int _maxObjectsPerNode;

  /// Maximum depth of the tree, this superceedes maxObjectsPerNode
  int _maxDepth;

  /// The objects in this [QuadTreeNode]
  List< QuadTreeObject > _objects;

  /// Parent of this [QuadTreeNode]
  QuadTreeNode _parent;
  
  /// Area this [QuadTreeNode] represents
  Rect rect;

  /// TopLeft [QuadTreeNode]
  QuadTreeNode childTL;
  /// TopRight [QuadTreeNode]
  QuadTreeNode childTR;
  /// BottomRight[QuadTreeNode]
  QuadTreeNode childBR;
  /// BottomLeft [QuadTreeNode]
  QuadTreeNode childBL;
  
  static int NEXT_UUID = 0;
  int UUID;
  
  
  /// Creates a new [QuadTreeNode] from x,y topleft position that is 'width' in size
  factory QuadTreeNode.fromExtents( QuadTreeNode parent, int x, int y, int width, int height, int pMaxObjectsPerNode, int pMaxDepth ) {
    return new QuadTreeNode( parent, new Rect(x,y, width, height), pMaxObjectsPerNode, pMaxDepth );
  }
  
  /// Constructor
  QuadTreeNode( this._parent, this.rect, this._maxObjectsPerNode, this._maxDepth ) {
    UUID = QuadTreeNode.NEXT_UUID++;
  }
  
  /// Creates a regular [QuadTree] node 
  QuadTreeNode createChildNode( QuadTreeNode parent, Rect aRect, int pMaxObjectsPerNode, int pMaxDepth ) {
    return new QuadTreeNode( parent, aRect, pMaxObjectsPerNode, pMaxDepth );
  }

  /// Adds an item to the object list, this should only be called by 'insert'
  void _add( QuadTreeObject item ) {
//    print("QuadTreeNode::_add\n\tid= ${UUID} item_id=${item.UUID}");
    
    if( _objects == null ) {
      _objects = new List< QuadTreeObject >();
    }

    item.owner = this;
    _objects.addLast( item );
  }

  /// Removes an item from the object list, this should only be called by 'delete'
  void _remove( QuadTreeObject item ) {
    if( _objects != null ) {
      int removeIndex = _objects.indexOf(item, 0);
      if( removeIndex >= 0 ) {
        // Place the current last one at the index of the one we're removing
        _objects[removeIndex] = _objects.last();
        _objects.removeLast();
      }
    }
  }

  /// Get the total for all objects in this QuadTreeNode including children
  int _objectCount() {
    int count = 0;

    // Add any objects we contain
    if( _objects != null ) count += _objects.length;

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
//    print("QuadTreeNode::_subdivide\n\tid= ${UUID}");
    
    Vec2 size = new Vec2( rect.width /2, rect.height / 2 );
    Vec2 mid = new Vec2( rect.x + size.x, rect.y + size.y );

    childTL = createChildNode( this, new Rect( rect.left, rect.top, size.x, size.y ), _maxObjectsPerNode, _maxDepth - 1);
    childTR = createChildNode( this, new Rect( mid.x, rect.top, size.x, size.y ), _maxObjectsPerNode, _maxDepth - 1);
    childBL = createChildNode( this, new Rect( rect.left, mid.y, size.x, size.y ), _maxObjectsPerNode, _maxDepth - 1);
    childBR = createChildNode( this, new Rect( mid.x, mid.y, size.x, size.y ), _maxObjectsPerNode, _maxDepth - 1);

    // If they're completely contained by the quad, bump objects down
    for( int i = 0; i < _objects.length; i++ ) {
      
      QuadTreeObject item = _objects[i];
//      print("QuadTreeNode::PlaceChildren\n\ti ${i}, item_id:${item.UUID}, node_id: ${UUID}");
      
      QuadTreeNode destTree = _getDestinationTree( item );
      if( destTree != this ) {
        destTree.insert(item );
        _remove( item );
        i--;
//        print("Removed: i=${i}");
      }
    }
  }

  /// Get the child Quad that would contain an object
  QuadTreeNode _getDestinationTree( QuadTreeObject  item ) {
    QuadTreeNode destTree = this;

    if( item.data.isInRect( childTL.rect ) ) {
//      print("\t TL");
      destTree = childTL;
    } else if( item.data.isInRect( childTR.rect ) ) {
//      print("\t ");
      destTree = childTR;
    } else if( item.data.isInRect( childBR.rect ) ) {
//      print("\t BR");
      destTree = childBR;
    } else if( item.data.isInRect( childBL.rect ) ) {
//      print("\t BL");
      destTree = childBL;
    }
    return destTree;
  }

  /// Relocate an item after checking if it is no longer contained within our [Rect]
  void _relocate(  QuadTreeObject  item ) {

    // Still inside our parent?
    if( item.data.isInRect( rect ) ) {

      // Have we moved inside any of our children?
      if( childTL != null ) {
        QuadTreeNode destTree = _getDestinationTree( item );
        if( item.owner != destTree ) {
          // Delete the item from this quad and add it to our child
          QuadTreeNode formerOwner = item.owner;
          delete( item, false );
          destTree.insert( item );

          // Cleanup ourselves
          formerOwner._cleanUpwards();
        }
      }
    } else { // We don't fit - try to move to the parent
      if( _parent != null ) {
        _parent._relocate( item );
      }
    }
  }


  /// An item has been removed ( or relocated to another node in the tree ), recursively clean up
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
        if( _parent != null && count() == 0 ) {
          _parent._cleanUpwards();
        }
      }
    } else if( _parent != null && count() == 0 ) { // This object itself could be one of 4 empty leaf nodes, tell parent to clean up
      _parent._cleanUpwards();
    }
  }


  /// Recursively removes all objects
  clear() {
    if( childTL != null ) {
      childTL.clear();
      childTR.clear();
      childBL.clear();
      childBR.clear();
    }

    if( _objects != null ) {
      _objects.clear();
      _objects = null;
    }

    childTL = null;
    childTR = null;
    childBL = null;
    childBR = null;
  }
  
  /// Insert an item into the [QuadTreeNode].
  void insert(QuadTreeObject item) {
//    print("QuadTreeNode::insert\n\tid= ${UUID} item_id=${item.UUID}");
    
//    print("${UUID}");
     // If this quad doesn't contain the items rect don't do anything unless we're the rootquad
    if( !item.data.isInRect( rect ) ) {
      assert( _parent == null );
      if( _parent == null ) { 
        _add( item );
      } else {
        return;
      }
    } else {
      _assimilateNode( item );
    }

    // There is room to add this object
    if( _objects == null || ( childTL == null && _objects.length + 1 <= _maxObjectsPerNode) || _maxDepth == 0 ) {
      _add( item );
    } else {
//      print("${UUID} | ${_objects.length}");
      
      /// Create quads and bump existing objects down
      if( childTL == null ) {
        _subdivide();
      }
  
      /// Try adding it to one of our children
      QuadTreeNode destTree = _getDestinationTree( item );
      if( destTree == this ) {
       _add( item );
      } else {
        destTree.insert( item );
      }
    }
  }
  

  /**
   * Deletes an item from the [QuadTreeNode].
   * If the object is removed causes this quad to have no objects in it's children, it's children will be removed as well
   */
  delete(QuadTreeObject item, bool clean) {
    
    
    if( item.owner != null ) {
      if( item.owner == this ) {
        _remove( item );

        if( clean ) {
          _cleanUpwards();
        }
      } else {
        item.owner.delete( item, clean );
      }
    }
  }
  
  /// Assimilate this node into our tree (subclasses should overwrite this)
  void _assimilateNode( QuadTreeObject aNode ){}

  /// Moves the [QuadTreeObject] in the tree
  void _move( QuadTreeObject item ) {
    if( item.owner != null ) {
      item.owner._relocate( item );
    } else {
      _relocate( item );
    }
  }

  /// Returns all the objects in this tree that are contained within the supplied [Rect]
  void getObjects( Rect searchRect,  List< IQuadStorable > results ) {
    _getObjectsImpl( searchRect, results );
  }

  /// Implementation which recursively retrieves all objects in it's children, if searchRect is either contained or intersects our [Rect]
  void _getObjectsImpl( Rect searchRect, List< IQuadStorable > results ) {
    if( results == null ) return;
    
    // We fully contain this rectangle, simply return whatever we have
    if( searchRect.containsRect( rect ) ) {
      _getAllObjects( results );
    } else if ( searchRect.intersectsRect( rect ) ) { // Add objects that intersect with the searchRect
      if( _objects != null ) { // We have an object list - run through each one
        _objects.forEach(void f( QuadTreeObject item ){
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

  /// Implemenation which is called blindly returns all the objects recursively stored in this node
  void _getAllObjects( List< IQuadStorable > results ) {
    if( _objects != null ) { // We have an object list - run through each one
      _objects.forEach(void f( QuadTreeObject item ) => results.addLast( item.data ) );
    }

    if( childTL != null ) {
      childTL._getAllObjects( results );
      childTR._getAllObjects( results );
      childBL._getAllObjects( results );
      childBR._getAllObjects( results );
    }
  }
  
  /// The number of objects in this [QuadTreeNode]
  count() => _objectCount();

  /// Returns true if this is an empty leaf node
  isEmptyLeaf() => _objectCount() == 0 && childTL == null;

}
/// Used by the [QuadTree] to store an object with a reference to it's parent
class QuadTreeObject {
  QuadTreeNode  owner;
  IQuadStorable data;
  
  int UUID;
  static int NEXT_UUID = 0;
  
  QuadTreeObject( this.data ) : UUID=NEXT_UUID++;

  /// Clear memory for GC
  void dispose() {
    owner = null;
    data = null;
  }
}

/// Implement this interface to be able to place it into the [QuadTree]
abstract class IQuadStorable {
  bool isInRect( Rect r );
  bool intersectsRect( Rect r );
}