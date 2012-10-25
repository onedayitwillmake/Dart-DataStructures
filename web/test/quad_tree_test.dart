import 'package:unittest/unittest.dart' as UnitTest;
import 'dart:math' as Math;
import '../oneday/geom/geom.dart';

void main() {
  UnitTest.test('Adding objects', function(){
    QuadTree qt = defaultTree();
    Math.Random rand = defaultRandom();

    var s, e;

    s = e = new Date.now().millisecondsSinceEpoch;
    print("Duration:${e-s}");

    SimpleObject so;
    for( int i = 0; i < 2; i++ ) {
      so = new SimpleObject( rand.nextDouble() * qt.quadRect.width, rand.nextDouble() * qt.quadRect.height);
//      print("${so.r.x}, ${so.r.y}");
      qt.add( so );
    }
    print("Done");
    e = new Date.now().millisecondsSinceEpoch;
    print("Duration:${e-s}");
    UnitTest.expect(qt.count, UnitTest.equals(2) );
  });
//
//  UnitTest.test("Don't add existing object", function(){
//    QuadTree qt = defaultTree();
//    SimpleObject so = new SimpleObject(10, 10);
//    qt.add(so);
//    qt.add(so);
//    UnitTest.expect(qt.count, UnitTest.equals(1) );
//  });
//
//  UnitTest.test("Removing objects", function(){
//    QuadTree qt = defaultTree();
//    var so = new SimpleObject(10, 10);
//    qt.add(so);
//    UnitTest.expect( qt.remove(so), UnitTest.isTrue );
//  });
//
  UnitTest.test("Removing non-existing object", function(){
    QuadTree qt = defaultTree();
    UnitTest.expect( qt.remove( new SimpleObject(10, 10) ), UnitTest.isFalse );
  });

//  UnitTest.test('Throw error when attempting to remove null', () {
//    QuadTree qt = defaultTree();
//    UnitTest.expect(()=> qt.remove(null),UnitTest.throwsNullPointerException);
//  });

//  UnitTest.test('Get objects', () {
//    QuadTree qt = defaultTree();
//    Math.Random rand = defaultRandom();
//    int objectSize = 100;
//
//    List< SimpleObject > objs = new List< SimpleObject >();
//    objs.add( new SimpleObject(50, 50, objectSize, objectSize) );
//    objs.add( new SimpleObject(450, 450, objectSize, objectSize) );
//    objs.add( new SimpleObject(501, 100, objectSize, objectSize) );
//
//    objs.forEach( (e)=> qt.add(e) );
//
//    List< SimpleObject > results = new List< SimpleObject>();
//    qt.getObjects( new Rect(0,0, 51, 51), results );
//
//    print(results);
//  });
}

QuadTree defaultTree() => new QuadTree(0,0,1000,1000, 1);
Math.Random defaultRandom() => new Math.Random(1);

class SimpleObject implements IQuadStorable {
  Rect r;
  Vec2 velocity;
  SimpleObject(num x, num y, {num width: 1, num height: 1}) : r = new Rect(x,y,width,height), velocity = new Vec2(0,0);

  bool isInRect( Rect r ) => new Vec2(r.x, r.y).isInRect(r);
  bool intersectsRect( Rect r ) => r.intersectsRect(r);
}
