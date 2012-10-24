part of geom;

class Circle extends Vec2 {
  /// Radius of this [Circle]
  num radius;

  /// PI * 2
  const TAU = Math.PI * 2;

  /// Creates a new [Circle] with [radius]
  Circle( num pX, num pY, this.radius) : super(pX, pY);

  /// Returns whether a point is contained within [this] [Circle]
  bool containsPoint( Vec2 p ) => ( distanceSquared(p) <= radius*radius );

  /// Returns [(x,y,radius)] string
  String toString() => ('X:(${x.toStringAsFixed(3)}, Y:${y.toStringAsFixed(3)}, R:${this.radius})');
}

/**
 * A [Circle] class which knows how to draw itself
 */
class DrawableCircle extends Circle {
  String color;
  String label;
  DrawableCircle( num pX, num pY, num pRadius, this.color, [this.label] ) : super(pX, pY, pRadius );

  /// Draws [this] circle into the provided [CanvasRenderingContext2D]
  void draw( Dynamic context ) {
    context.save();
    context.fillStyle = color;
    context.strokeStyle = '';
    context.beginPath();
    context.arc(x, y, radius, 0, TAU, false);
    context.fill();
    context.closePath();
  }
}