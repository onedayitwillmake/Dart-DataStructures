import 'package:unittest/unittest.dart' as UnitTest;
//import 'package:unittest/html_enhanced_config.dart';
import '../oneday/geom/geom.dart';

const num EPSILON = 0.0001;

void main() {

  // Create a vector with arguments and without
  UnitTest.test('Creation', function(){
    Vec2 v = new Vec2();
    UnitTest.expect(v.x, UnitTest.equals(0) );
    UnitTest.expect(v.y, UnitTest.equals(0));
  });

  UnitTest.test('Valid normalization', function(){
    var v = new Vec2(10,0);
    v.normalize();
    UnitTest.expect(v.x, UnitTest.closeTo(1, EPSILON));
    UnitTest.expect(v.y, UnitTest.closeTo(0, EPSILON));
  });

  UnitTest.test('Distance', function(){
    num dist = new Vec2(1, 1).distance( new Vec2(100, 100) );
    UnitTest.expect(dist, UnitTest.closeTo(140.0071426749364, EPSILON));
  });

  UnitTest.test('Distance Squared', function(){
    num dist = new Vec2(1, 1).distanceSquared( new Vec2(100, 100) );
    UnitTest.expect(dist, UnitTest.closeTo(140.0071426749364 * 140.0071426749364, EPSILON));
  });

  UnitTest.test('isInRect', function() {
    Rect r = new Rect(0, 0, 100, 100);
    UnitTest.expect( new Vec2(50, 50).isInRect(r), UnitTest.isTrue );
    UnitTest.expect( new Vec2(101, 101).isInRect(r), UnitTest.isFalse );
  });

  UnitTest.test('Make sure intersectsRect returns same values as isInRect', function() {
    Rect r = new Rect(0, 0, 100, 100);
    UnitTest.expect( new Vec2(50, 50).intersectsRect(r), UnitTest.isTrue );
    UnitTest.expect( new Vec2(101, 101).intersectsRect(r), UnitTest.isFalse );
  });

  UnitTest.test('Test operator + and -', function() {
    var v = new Vec2(10, 10) + new Vec2(5, 5);
    UnitTest.expect(v.x, UnitTest.closeTo(15, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(15, EPSILON) );

    v += new Vec2(5, 5);
    UnitTest.expect(v.x, UnitTest.closeTo(20, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(20, EPSILON) );

    v -= new Vec2(5, 5);
    UnitTest.expect(v.x, UnitTest.closeTo(15, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(15, EPSILON) );

    v = v - new Vec2(5, 5);
    UnitTest.expect(v.x, UnitTest.closeTo(10, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(10, EPSILON) );
  });

  UnitTest.test('Test operator * and /', function() {
    Vec2 v = new Vec2(10, 10);
    v *= 10;
    UnitTest.expect(v.x, UnitTest.closeTo(100, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(100, EPSILON) );

    v *= new Vec2(0.5, 0.5);
    UnitTest.expect(v.x, UnitTest.closeTo(50, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(50, EPSILON) );

    // Operator /
    v = new Vec2(10, 10);
    v /= 10;
    UnitTest.expect(v.x, UnitTest.closeTo(1, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(1, EPSILON) );

    v /= new Vec2(0.5, 0.5);
    UnitTest.expect(v.x, UnitTest.closeTo(2, EPSILON) );
    UnitTest.expect(v.y, UnitTest.closeTo(2, EPSILON) );
  });
}