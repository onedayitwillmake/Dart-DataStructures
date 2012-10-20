part of layout;


class ForceDirectedGraph {
  Vec2    _kineticEnergy = new Vec2(0,0);
  GGraph  _graph;

  Rect _dimensions;

  ForceDirectedGraph( this._graph,  this._dimensions ) {
    randomizePositions();
  }

  void randomizePositions() {
    _graph.nodes.forEach( void f(int key, GGraphNode value) {
      print(value);
    });
  }

  void tick( delta ) {
    _graph.nodes.forEach( void f(int key, GGraphNode thisNode) {
      Vec2 netForce = new Vec2();

      // Repulsion
      _graph.nodes.forEach( void f(int key, GGraphNode otherNode) {
        if( thisNode == otherNode ) return;

      });
    });
  }

  void hooksAttraction( Vec2 pos, Vec2 target, Vec2 outVec ) {
    Vec2 displacement = pos - target;
    num len = 10.0;

////    floa
//
//    num x = (k*target.x) - (k1*pos.x) +
  }
}
