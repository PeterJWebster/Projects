/**  With Scala 2.12 on Lab machines:

 * In normal circumstances the CLASSPATH is already set for you:

fsc TestTest.scala
scala org.scalatest.run TestTest

 * If you use jar files in your own space:

fsc -cp ./scalatest_2.12-3.0.5.jar:./scalactic_2.12-3.0.5.jar TestTest.scala
scala -cp ./scalatest_2.12-3.0.5.jar:./scalactic_2.12-3.0.5.jar org.scalatest.run TestTest

 * (Once this is working you can set your CLASSPATH in .bashrc) 
*/
import org.scalatest.funsuite.AnyFunSuite
// or import org.scalatest.funsuite.AnyFunSuite with
// ScalaTest 3.1 or later (where you won't need Scalatic)



class TestTest extends AnyFunSuite{
  test("toString() on empty set"){ 
    var x = new IntSet
    assert(x.toString == "{}") 
  }
  test("Adding one element"){
    var x = new IntSet
    x.add(1)
    assert(x.toString == "{1}")
  }
  test("Adding multiple elements"){
    var x = new IntSet
    x.add(1)
    x.add(3)
    x.add(2)
    assert(x.toString == "{1,2,3}")
  }
  test("Adding with use of apply()"){
    var x = IntSet(1,2,5)
    x.add(3)
    assert(x.toString == "{1,2,3,5}")
  }
  test("size() on empty set"){ 
    var x = new IntSet
    assert(x.size == 0) 
  }
  test("size() of 4"){
    var x = IntSet(1,2,5)
    x.add(3)
    assert(x.size == 4)
  }
  test("contains(3) on {2,5,3,1}"){
    var x = IntSet(2,5,3,1)
    assert(x.contains(3) == true)
  }
  test("contains(4) on {2,5,3,1}"){
    var x = IntSet(2,5,3,1)
    assert(x.contains(4) == false)
  }
  test("any() on {2,3,4}"){
    var x = IntSet(2,3,4)
    assert(x.any == 2)
  }
  test("any() on {}"){
    var x = IntSet()
    intercept[Exception] {
      x.any
    }
  }
  test("equals(1,2,3,4) on {1,2,3,4}"){
    var x = IntSet(1,2,3,4)
    var y = IntSet(1,2,3,4)
    assert(x.equals(y))
  }
  test("equals(2,3,1,4) on {1,2,3,4}"){
    var x = IntSet(1,2,3,4)
    var y = IntSet(2,3,1,4)
    assert(x.equals(y))
  }
  test("equals(2,3,4) on {1,2,3,4}"){
    var x = IntSet(2,3,4)
    var y = IntSet(1,2,3,4)
    assert(!x.equals(y))
  }
  test("equals() on {1}"){
    var x = IntSet()
    var y = IntSet(1)
    assert(!x.equals(y))
  }
  test("equals('test') on {1}"){
    var x = IntSet(1)
    var y = "test"
    assert(!x.equals(y))
  }
  test("remove(2) on {3,2,1}"){
    var x = IntSet(3,2,1)
    x.remove(2)
    assert(x.toString == "{1,3}")
  }
  test("remove(2) == true on {3,2,1}"){
    var x = IntSet(3,2,1)
    assert(x.remove(2) == true)
  }
  test("remove(2) == false on {3,4,1}"){
    var x = IntSet(3,4,1)
    assert(x.remove(2) == false)
  }
  test("subsetOf({7,3,8,9,24}) on {9,7,8}"){
    var x = IntSet(9,7,8)
    var y = IntSet(7,3,8,9,24)
    assert(x.subsetOf(y))
  }
  test("subsetOf({7,3,8,9,24}) on {9,7,8,2}"){
    var x = IntSet(9,7,8,2)
    var y = IntSet(7,3,8,9,24)
    assert(!x.subsetOf(y))
  }
  test("subsetOf({7,3,8,24}) on {9,7,8}"){
    var x = IntSet(9,7,8)
    var y = IntSet(7,3,8,24)
    assert(!x.subsetOf(y))
  }
  test("subsetOf({7,3,8,9,24}) on {}"){
    var x = IntSet()
    var y = IntSet(7,3,8,9,24)
    assert(x.subsetOf(y))
  }
  test("subsetOf() on {9,7,8}"){
    var x = IntSet(9,7,8)
    var y = IntSet()
    assert(!x.subsetOf(y))
  }
  test("union({4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(4,7,2,8)
    assert(x.union(y) == IntSet(4,7,2,8,5,3,1))
  }
  test("union({5,3,1,4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(5,3,1,4,7,2,8)
    assert(x.union(y) == IntSet(4,7,2,8,5,3,1))
  }
  test("union({4,7,2,8}) on {}"){
    var x = IntSet()
    var y = IntSet(4,7,2,8)
    assert(x.union(y) == IntSet(4,7,2,8))
  }
  test("union({}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet()
    assert(x.union(y) == IntSet(5,3,1))
  }
  test("union({4,7,2,8}) on {2,4,8,7}"){
    var x = IntSet(2,4,8,7)
    var y = IntSet(4,7,2,8)
    assert(x.union(y) == IntSet(4,7,8,2))
  }
  test("intersect({4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(4,7,2,8)
    assert(x.intersect(y) == IntSet())
  }
  test("intersect({5,3,1,4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(5,3,1,4,7,2,8)
    assert(x.intersect(y) == IntSet(5,3,1))
  }
  test("intersect({5,3,1,4,11,7,2,8}) on {5,3,1,11,24,32}"){
    var x = IntSet(5,3,1,11,24,32)
    var y = IntSet(5,3,1,4,11,7,2,8)
    assert(x.intersect(y) == IntSet(5,11,3,1))
  }
  test("intersect({4,7,2,8}) on {}"){
    var x = IntSet()
    var y = IntSet(4,7,2,8)
    assert(x.intersect(y) == IntSet())
  }
  test("intersect({}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet()
    assert(x.intersect(y) == IntSet())
  }
  test("intersect({4,7,2,8}) on {2,4,8,7}"){
    var x = IntSet(2,4,8,7)
    var y = IntSet(4,7,2,8)
    assert(x.intersect(y) == IntSet(4,7,8,2))
  }
  test("map(double()) on {7,3,1,2}"){
    def double(x: Int) : Int = x*2
    var x = IntSet(7,3,1,2)
    assert(x.map(double) == IntSet(4,2,6,14))
  }
  test("map(double()) on {}"){
    def double(x: Int) : Int = x*2
    var x = IntSet()
    assert(x.map(double) == IntSet())
  }
  test("map(square()) on {7,3,1,2}"){
    def square(x: Int) : Int = x*x
    var x = IntSet(7,3,1,2)
    assert(x.map(square) == IntSet(49,9,1,4))
  }
  test("map(subtracty()) on {7,3,1,2}"){
    val y = 3
    def subtracty(x: Int) : Int = x - y
    var x = IntSet(7,3,1,2)
    assert(x.map(subtracty) == IntSet(4,0,-2,-1))
  }
  test("filter(isEven) on {5,9,3,4,6}"){
    def isEven(x: Int) : Boolean = (x%2 == 0)
    var x = IntSet(5,9,3,4,6)
    assert(x.filter(isEven) == IntSet(4,6))
  }
  test("filter(isEven) on {}"){
    def isEven(x: Int) : Boolean = (x%2 == 0)
    var x = IntSet()
    assert(x.filter(isEven) == IntSet())
  }
  test("filter(between) on {5,9,3,4,6}"){
    val lower = 2
    val higher = 5
    def between(x: Int) : Boolean = (x >= lower && x <= higher)
    var x = IntSet(5,9,3,4,6)
    assert(x.filter(between) == IntSet(4,5,3))
  }
  test("filter(isPowerOfTwo) on {5,9,3,4,6,8}"){
    def isPowerOfTwo(x: Int): Boolean = {
      x > 0 && (x & (x - 1)) == 0
    }

    var x = IntSet(5,9,3,4,6,8)
    assert(x.filter(isPowerOfTwo) == IntSet(4,8))
  }
  test("setDifference({4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(4,7,2,8)
    assert(x.setDifference(y) == IntSet(5,3,1))
  }
  test("setDifference({5,3,1,4,7,2,8}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet(5,3,1,4,7,2,8)
    assert(x.setDifference(y) == IntSet())
  }
  test("setDifference({5,3,1,4,11,7,2,8}) on {5,3,1,11,24,32}"){
    var x = IntSet(5,3,1,11,24,32)
    var y = IntSet(5,3,1,4,11,7,2,8)
    assert(x.setDifference(y) == IntSet(24,32))
  }
  test("setDifference({4,7,2,8}) on {}"){
    var x = IntSet()
    var y = IntSet(4,7,2,8)
    assert(x.setDifference(y) == IntSet())
  }
  test("setDifference({}) on {5,3,1}"){
    var x = IntSet(5,3,1)
    var y = IntSet()
    assert(x.setDifference(y) == IntSet(5,3,1))
  }
  test("setDifference({4,7,2,8}) on {2,4,8,7}"){
    var x = IntSet(2,4,8,7)
    var y = IntSet(4,7,2,8)
    assert(x.setDifference(y) == IntSet())
  }
}
