import 'package:unittest/unittest.dart' as UnitTest;
import 'dart:math' as Math;
import '../oneday/geom/geom.dart';

void main() {
  UnitTest.test('Adding objects', function(){
    QuadTree qt = defaultTree();
    Math.Random rand = defaultRandom();
    int objectSize = 100;
    
    for( int i = 0; i < 1000; i++ ) {
      qt.add( new SimpleObject( rand.nextDouble() * qt.quadRect.width, rand.nextDouble() * qt.quadRect.height, objectSize, objectSize) );
    }
    
    UnitTest.expect(qt.count, UnitTest.equals(1000) );
  });

  UnitTest.test("Don't add existing object", function(){
    QuadTree qt = defaultTree();
    SimpleObject so = new SimpleObject(10, 10);
    qt.add(so);
    qt.add(so);
    UnitTest.expect(qt.count, UnitTest.equals(1) );
  });

  UnitTest.test("Removing objects", function(){
    QuadTree qt = defaultTree();
    var so = new SimpleObject(10, 10);
    qt.add(so);
    UnitTest.expect( qt.remove(so), UnitTest.isTrue );
  });
  
  UnitTest.test("Removing all objects", function(){
    QuadTree qt = defaultTree();
    Math.Random rand = defaultRandom();
    int objectSize = 100;
    
    for( int i = 0; i < 1000; i++ ) {
      qt.add( new SimpleObject( rand.nextDouble() * qt.quadRect.width, rand.nextDouble() * qt.quadRect.height, objectSize, objectSize) );
    }
    qt.clear();
    UnitTest.expect( qt.count, UnitTest.equals(0) );
  });

  UnitTest.test("Removing object not in tree returns false", function(){
    QuadTree qt = defaultTree();
    UnitTest.expect( qt.remove( new SimpleObject(10, 10) ), UnitTest.isFalse );
  });

  UnitTest.test('Throw error when attempting to remove object that is null', () {
    QuadTree qt = defaultTree();
    UnitTest.expect(()=> qt.remove(null),UnitTest.throwsNullPointerException);
  });

  UnitTest.test('Get objects', () {
    QuadTree qt = defaultTree();
    Math.Random rand = defaultRandom();
    int objectSize = 100;

    List< SimpleObject > objs = new List< SimpleObject >();
    objs.add( new SimpleObject(50, 50, objectSize, objectSize) );
    objs.add( new SimpleObject(450, 450, objectSize, objectSize) );
    objs.add( new SimpleObject(501, 100, objectSize, objectSize) );
    objs.add( new SimpleObject(601, 100, objectSize, objectSize) );

    objs.forEach( (e)=> qt.add(e) );

    List< SimpleObject > results = new List< SimpleObject>();
    qt.getObjects( new Rect(0,0, 51, 51), results );
    UnitTest.expect( results.length, UnitTest.equals(1) );
    
    
    results = new List< SimpleObject>();
    qt.getObjects( new Rect(0,0, 49, 49), results );
    UnitTest.expect( results.length, UnitTest.equals(0) );
  });
}

QuadTree defaultTree() => new QuadTree(0, 0, 1000, 1000, 1);
Math.Random defaultRandom() => new Math.Random(1);

class SimpleObject implements IQuadStorable {
  Rect _rect;
  Vec2 velocity;
  SimpleObject(num x, num y, [num width=10, num height=10]) : _rect = new Rect(x,y,width,height), velocity = new Vec2(0,0);

  bool isInRect( Rect r ) => _rect.isInRect(r);
  bool intersectsRect( Rect r ) => _rect.intersectsRect(r);
  String toString() => _rect.toString();
}
