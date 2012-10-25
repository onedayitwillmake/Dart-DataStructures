import 'package:unittest/unittest.dart' as UnitTest;
import '../oneday/geom/geom.dart';

const num EPSILON = 0.0001;

void main() {

  UnitTest.test('Creation', function(){
    Rect r1 = new Rect(1, 2, 10, 20);

    UnitTest.expect( r1.x, UnitTest.equals(1) );
    UnitTest.expect( r1.y, UnitTest.equals(2) );
    UnitTest.expect( r1.width, UnitTest.equals(10) );
    UnitTest.expect( r1.height, UnitTest.equals(20) );
  });

  UnitTest.test('Rect.fromExtents', function(){
    Rect r1 = new Rect.fromExtents(new Vec2(6, 12), new Vec2(5,10) );

    UnitTest.expect( r1.x, UnitTest.equals(1) );
    UnitTest.expect( r1.y, UnitTest.equals(2) );
    UnitTest.expect( r1.width, UnitTest.equals(10) );
    UnitTest.expect( r1.height, UnitTest.equals(20) );
  });

  UnitTest.test('Left, Right, Top, Bottom, TopLeft, BottomRight', function(){
    Rect r1 = new Rect(1, 2, 10, 20);
    UnitTest.expect( r1.left, UnitTest.equals(1));
    UnitTest.expect( r1.right, UnitTest.equals(11));
    UnitTest.expect( r1.top, UnitTest.equals(2));
    UnitTest.expect( r1.bottom, UnitTest.equals(22));
    UnitTest.expect( r1.topLeft().x, UnitTest.equals(1) );
    UnitTest.expect( r1.topLeft().y, UnitTest.equals(2) );
    UnitTest.expect( r1.bottomRight().x, UnitTest.equals(11) );
    UnitTest.expect( r1.bottomRight().y, UnitTest.equals(22) );
  });

  UnitTest.test('containsPoint', function(){
    Rect r1 = new Rect(5, 5, 10, 10);

    UnitTest.expect( r1.containsPoint( new Vec2(5, 5) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsPoint( new Vec2(5, 8) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsPoint( new Vec2(8, 10) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsPoint( new Vec2(10, 10) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsPoint( new Vec2(15, 15) ), UnitTest.isTrue );

    UnitTest.expect( r1.containsPoint( new Vec2(0, 0) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsPoint( new Vec2(5, 16) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsPoint( new Vec2(16, 5) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsPoint( new Vec2(16, 16) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsPoint( new Vec2(-100, 100) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsPoint( new Vec2(-5, 0) ), UnitTest.isFalse );
  });

  UnitTest.test('containsRect', function(){
    Rect r1 = new Rect(0,0, 10, 10);

    UnitTest.expect( r1.containsRect( new Rect(1,1,5,5) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsRect( new Rect(0,0,10,10) ), UnitTest.isTrue );
    UnitTest.expect( r1.containsRect( new Rect(9,0,1,10) ), UnitTest.isTrue );

    UnitTest.expect( r1.containsRect( new Rect(0,0,10,11) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsRect( new Rect(1,0,10,10) ), UnitTest.isFalse );
    UnitTest.expect( r1.containsRect( new Rect(9,0,2,10) ), UnitTest.isFalse );
  });

  UnitTest.test('intersectsRect', function(){
    Rect r1 = new Rect(0,0, 10, 10);

    UnitTest.expect( r1.intersectsRect( new Rect(1,1,5,5) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(1,1,1,1) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(0,0,10,10) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(9,0,1,10) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(0,0,10,11) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(1,0,10,10) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(9,0,2,10) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect.fromExtents(new Vec2(9,9),new Vec2(1,1) ) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(10,10,1,1) ), UnitTest.isTrue );

    UnitTest.expect( r1.intersectsRect( new Rect(11,10,1,1) ), UnitTest.isFalse );    // [X] other.starts after r1.ends, fail
    UnitTest.expect( r1.intersectsRect( new Rect(-10,0,5,10) ), UnitTest.isFalse );   // [X] other.ends before r1.starts, fail
    UnitTest.expect( r1.intersectsRect( new Rect(0,11,1,1) ), UnitTest.isFalse );     // [Y] other.starts after r1.ends, fail
    UnitTest.expect( r1.intersectsRect( new Rect(0,-5,1,1) ), UnitTest.isFalse );     // [Y] other.ends before r1.starts, fail

    UnitTest.expect( r1.intersectsRect( new Rect(0,0,1,1) ), UnitTest.isTrue );
    UnitTest.expect( r1.intersectsRect( new Rect(10,10,1,1) ), UnitTest.isTrue );
  });
}