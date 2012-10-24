import 'package:unittest/unittest.dart' as UnitTest;

void main() {
  UnitTest.test('HelloTest', () => 
      UnitTest.expect([1,2,3], 
                       UnitTest.orderedEquals([1,2,3]))
                       );
}