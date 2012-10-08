
/**
 * Provides a simple 2D Vector class
 * @author Mario Gonzalez | onedayitwillmake.com
 */ 
class Vec2 {
  num x;
  num y;
  
  /**
   * Creates a new [Vec2] instance with optional x,y values
   */
  Vec2([num this.x = 0, num this.y = 0]);
  
  /**
   * Normalizes [this] [Vec2] in place
   */ 
  void normalize() {
    num length = Math.sqrt(x*x+y*y);
    x /= length;
    y /= length;
  }
  
  /**
   * Rotes [this] by rad radians
   */
  void rotate( num rad ) {
    num cosRad = Math.cos( rad );
    num sinRad = Math.sin( rad );
    
    num temp = x*cosRad-y*sinRad;
    y = x*sinRad+y*cosRad;
    x = temp;
  }
  
  
  num cross(Vec2 v) => x*v.y - y*v.x;
  
  Vec2 negate() => new Vec2(-x, -y);
  
  Vec2 operator+(d) => (d is num) ? new Vec2(x + d, y + d) : new Vec2(x + d.x, y + d.y);

  Vec2 operator-(d) => (d is num) ? new Vec2(x - d, y - d) : new Vec2(x - d.x, y - d.y);

  Vec2 operator*(d) => (d is num) ? new Vec2(x * d, y * d) : new Vec2(x * d.x, y * d.y);

  Vec2 operator/(d) => (d is num) ? new Vec2(x / d, y / d) : new Vec2(x / d.x, y / d.y);

  String toString() => '(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)})';
}
