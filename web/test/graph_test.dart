import 'dart:io';
import 'package:unittest/unittest.dart' as UnitTest;
import '../oneday/ds/ds.dart';
import '../oneday/geom/geom.dart';

void main() {
  
  UnitTest.test("Load graph from file system", (){
    
  File file = new File("../../data/simpleGraph01.txt");
  Future<String> finishedReading = file.readAsText( Encoding.ASCII );
  
  finishedReading.then(UnitTest.expectAsync1((text){
    var graph = new GGraph.fromSimpleText( text, false );
    
    // Trimmed result
    var expected = "1:54322:413:514:6215:109316:8747:868:769:1110510:119511:109";
    var result = graph.toString().replaceAll(new RegExp('\t|\n'), "");
    
    UnitTest.expect(result, UnitTest.equals(expected));
    }));
  });
  
  
  
}
