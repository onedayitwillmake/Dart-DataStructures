part of geom;

/// A simple Rectangle class
class Rect implements IQuadStorable {
  /// TopLeft X position
  num x;

  /// TopLeft Y position
  num y;

  /// Width of the rectangle
  num width;

  /// Height of the rectangle
  num height;

//  /// Center point of the [Rect].
//  Vec2 center;
//
//  /// Size of the [Rect].
//  Vec2 size;
//
//  /// Extent of the [Rect].
//  Vec2 halfSize;

  /// Creates a new [Rect] instance.
  Rect( this.x, this.y, this.width, this.height ) {
//    center = new Vec2( (left() + right() ) /2, (top() + bottom() ) / 2 );
//    size = new Vec2( width, height );
//    halfSize = size/2;
  }

  /// Creates a new [Rect] instance from the center point and extents.
  factory Rect.fromExtents( Vec2 pCenter, Vec2 pHalfSize ) {
    return new Rect( pCenter.x - pHalfSize.x, pCenter.y - pHalfSize.y, pCenter.x + pHalfSize.x, pCenter.y + pHalfSize.y );
  }

  /// Does this rect contain the given point?
  bool containsPoint( Vec2 p ) => (p.x >= x && p.x <= x+width) && (p.y > y && p.y <= y+height);

  /// Does this [Rect] fully emcompass 'other'?
  bool containsRect( Rect other ) {
    return x < other.x && y < other.y && right() > other.right()  && bottom() > other.bottom();
  }

  /// Returns true if this object is inside of the [Rect] r
  bool isInRect( Rect other ) => other.containsRect( this );

  /// Returns true if the object intersects the Rect r
  bool intersectsRect( Rect r ) => (r.x < right() && r.right() > x && r.y < bottom() && r.bottom() > y);

  /// X coordinate of the [Rect].
  left() => x;

  /// Right most coordinate of the [Rect].
  right() => x+width;

  /// Y coordinate of the top-left corner of the rectangle.
  top() => y;

  /// [Rect]
  bottom() => y+height;

  /// A [Vec2] of the bottom-right corner of the [Rect].
  bottomRight() => new Vec2( right(), bottom() );

  /// A [Vec2] of the top-left corner of the [Rect].
  topLeft() => new Vec2( x, y );

  /// Area of the Rect
  area() => width*height;

  /// Aspect ratio of the Rect
  aspect() => width / height;

}