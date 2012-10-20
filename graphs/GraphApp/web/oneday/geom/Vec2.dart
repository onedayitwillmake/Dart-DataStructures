part of geom;


/**
 * Provides a simple 2D Vec2 class
 * @author Mario Gonzalez | onedayitwillmake.com
 */
class Vec2 implements IQuadStorable {
  num x;
  num y;

  ///Creates a new [Vec2] instance with optional x,y values
  Vec2([num this.x = 0, num this.y = 0]);

  /// Normalizes [this] [Vec2] in place
  void normalize() {
    num length = Math.sqrt(x*x+y*y);
    x /= length;
    y /= length;
  }

  /// Rotates [this] by rad radians
  void rotate( num rad ) {
    num cosRad = Math.cos( rad );
    num sinRad = Math.sin( rad );

    num temp = x*cosRad-y*sinRad;
    y = x*sinRad+y*cosRad;
    x = temp;
  }

  /// Returns the distance to a [Vector]
  num distance( Vec2 p ) {
    num dx = x - p.x;
    num dy = y - p.y;
    return Math.sqrt( dx*dx + dy*dy);
  }

  /// Returns the distance squared to another [Vector]
  num distanceSquared( Vec2 p ) {
    num dx = x - p.x;
    num dy = y - p.y;
    return dx*dx + dy*dy;
  }

  /// Returns true if this [Vec2] is inside of the [Rect]
  bool isInRect( Rect r ) => r.containsPoint( this );
  bool intersectsRect( Rect r ) => r.containsPoint( this );

  /// Returns the cross-product (scalar value) of this and another [Vector]
  num cross(Vec2 v) => x*v.y - y*v.x;

  /// Returns the dot-product (scalar value) of this and another [Vector]
  num dot( Vec2 v ) => x*v.x + y*v.y;

  /// Returns a new [Vector] which is a negation of this one
  Vec2 negate() => new Vec2(-x, -y);

  /// Returns a new [Vector] by adding [v]
  Vec2 operator+(v) => new Vec2(x + v.x, y + v.y);

  Vec2 operator-(v) => new Vec2(x - v.x, y - v.y);

  Vec2 operator*(v) => (v is num) ? new Vec2(x * v, y * v) : new Vec2(x * v.x, y * v.y);

  Vec2 operator/(v) => (v is num) ? new Vec2(x / v, y / v) : new Vec2(x / v.x, y / v.y);

  String toString() => '(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)})';
}
