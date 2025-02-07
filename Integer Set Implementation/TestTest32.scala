/**  
With Scala 2.12 and ScalaTest 3.2.2:
fsc -cp ./scalatest-app_2.12-3.2.2.jar TestTest32.scala
scala -cp ./scalatest-app_2.12-3.2.2.jar org.scalatest.run TestTest32

This is the version to start with if you are using a recent version of ScalaTest.
(The lab machines were on an older version last time I checked: 3.1.4.)
*/
import org.scalatest.funsuite.AnyFunSuite


class TestTest32 extends AnyFunSuite{ 
  var x = 0
  test("x=0"){ assert(x===0) }
  x = 1
  test("x=1"){ assert(x===1) }
}


/*
//  Corrected:
class TestTest extends AnyFunSuite{
  var x = 0
  test("x=0"){ 
    x=0
    assert(x===0) 
  }
  test("x=1"){ 
    x=1
    assert(x===1)
  }
}
*/  
