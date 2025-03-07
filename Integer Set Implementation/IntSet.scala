// A class of objects to represent a set

class IntSet{
  // State: S : P(Int) (where "P" represents power set)

  // The following lines just define some aliases, so we can subsequently
  // write "Node" rather than "IntSet.Node".
  private type Node = IntSet.Node
  // Constructor
  private def Node(datum: Int, next: Node) = new IntSet.Node(datum, next)
  private def next = theSet.next

  // Init: S = {}
  private var theSet : Node = new Node(0,null)// or however empty set is represented

  /** Convert the set to a string.
    * (The given implementation is not sufficient.) */
  override def toString : String = {
    var string = "{"
    var current = theSet
    while (current.next != null){
      current = current.next
      if (string != "{"){ string += ","}
      string += current.datum
    }
    string += "}"
    return string
  }

  /** Add element e to the set
    * Post: S = S_0 U {e} */
  def add(e: Int) : Unit = {
    var current = theSet
    var alreadyInSet = false
    while (current.next != null && alreadyInSet == false){
      if (e == current.next.datum){
        alreadyInSet = true
      } 
      else if (e < current.next.datum){
        current.next = new Node(e, current.next)
        alreadyInSet = true  
      }
      current = current.next
    }
    if (alreadyInSet == false){current.next = new Node(e, null)}
  }

  /** Length of the list
    * Post: S = S_0 && returns #S */
  def size : Int = {
    var size = 0
    var current = theSet
    while (current.next != null){ size += 1; current = current.next }
    return size
  }

  /** Does the set contain e?
    * Post: S = S_0 && returns (e in S) */
  def contains(e: Int) : Boolean = {
    var current = theSet
    var found = false
    while (current.next != null && found == false){
      current = current.next
      if (current.datum == e){ found = true }
    }
    if (found == false){ return false } else { return true }
  }

  /** Return any member of the set.  (This is comparable to the operation
    * "head" on scala.collection.mutable.Set, but we'll use a name that does
    * not suggest a particular order.)
    * Pre: S != {}
    * Post: S = S_0 && returns e s.t. e in S */
  def any : Int = {
    var n = theSet
    if (size == 0){ throw new Exception("The set is empty") }
    else { return n.next.datum }
  }

  /** Does this equal that?
    * Post: S = S_0 && returns that.S = S */
  override def equals(that: Any) : Boolean = that match {
    case s: IntSet => {
      var same = true
      var x = theSet
      while (x.next != null){
        if (!s.contains(x.next.datum)){ same = false }
        x = x.next
      }
      var y = s.theSet
      while (y.next != null){
        if (!contains(y.next.datum)){ same = false }
        y = y.next
      }
      same 
    }
    case _ => false
  }

  /** Remove e from the set; result says whether e was in the set initially
    * Post S = S_0 - {e} && returns (e in S_0) */
  def remove(e: Int) : Boolean = {
    var current = theSet
    var removed = false
    while (current.next != null && !removed) {
      if (current.next.datum == e) {
        current.next = current.next.next
        removed = true
      } else {
        current = current.next
      }
    }
    removed    
  }
    
  /** Test whether this is a subset of that.
    * Post S = S_0 && returns S subset-of that.S */
  def subsetOf(that: IntSet) : Boolean = {
    var current = theSet.next
    var isSubset = true

    while (current != null && isSubset) {
      if (!that.contains(current.datum)) {
        isSubset = false
      }
      current = current.next
    }

    isSubset
  }

  // ----- optional parts below here -----

  /** return union of this and that.  
    * Post: S = S_0 && returns res s.t. res.S = this U that.S */
  def union(that: IntSet) : IntSet = {
    val result = new IntSet() // Create a new set to store the union
    var current = theSet.next

    // Add elements from the current set to the result set
    while (current != null) {
      result.add(current.datum)
      current = current.next
    }

    // Add elements from the provided set to the result set
    current = that.theSet.next 
    while (current != null) {
      result.add(current.datum)
      current = current.next
    }

    result
  }

  /** return intersection of this and that.  
    * Post: S = S_0 && returns res s.t. res.S = this intersect that.S */
  def intersect(that: IntSet) : IntSet = {
    val result = new IntSet() // Create a new set to store the intersection
    var current = theSet.next

    // Iterate through the elements of the current set
    while (current != null) {
      // If the element is also present in the provided set, add it to the result set
      if (that.contains(current.datum)) {
        result.add(current.datum)
      }
      current = current.next
    }

    result
  }

  /** map
    * Post: S = S_0 && returns res s.t. res.S = {f(x) | x <- S} */
  def map(f: Int => Int) : IntSet = {
    val result = new IntSet() // Create a new set to store the mapped elements
    var current = theSet.next

    // Iterate through the elements of the current set
    while (current != null) {
      // Apply the function f to the current element and add the result to the result set
      result.add(f(current.datum))
      current = current.next
    }

    result
  }

  /** filter
    * Post: S = S_0 && returns res s.t. res.S = {x | x <- S && p(x)} */
  def filter(p : Int => Boolean) : IntSet = {
    val result = new IntSet() // Create a new set to store the filtered elements
    var current = theSet.next

    // Iterate through the elements of the current set
    while (current != null) {
      // If the element satisfies the predicate p, add it to the result set
      if (p(current.datum)) {
        result.add(current.datum)
      }
      current = current.next
    }

    result
  }
  
  def setDifference(that: IntSet): IntSet = {
    val result = new IntSet() // Create a new set to store the difference
    var current = theSet.next

    // Iterate through the elements of the current set
    while (current != null) {
      // If the element is not present in the provided set, add it to the result set
      if (!that.contains(current.datum)) {
        result.add(current.datum)
      }
      current = current.next
    }

    result
  }

/*  def powerset(): Array[IntSet] = {
    // Calculate the size of the powerset
    val setSize = size
    val powersetSize = Math.pow(2, setSize).toInt

    // Initialize an array to store the powerset
    val powersetArray = new Array[IntSet](powersetSize)

    // Function to generate the powerset recursively
    def generatePowerset(set: IntSet.Node, index: Int, currentSubset: IntSet): Unit = {
      if (index == setSize) {
        // Add the current subset to the powerset array
        powersetArray(currentSubset.size) = currentSubset
      } else {
        // Generate subsets with the current element included and excluded
        generatePowerset(set.next, index + 1, currentSubset)
        currentSubset.add(set.next.datum)
        generatePowerset(set.next, index + 1, currentSubset)
      }
    }

    // Start generating the powerset from the empty set
    generatePowerset(theSet.next, 0, new IntSet())

    powersetArray
  }
*/

}


// The companion object
object IntSet{
  /** The type of nodes defined in the linked list */
  private class Node(var datum: Int, var next: Node)

  /** Factory method for sets.
    * This will allow us to write, for example, IntSet(3,5,1) to
    * create a new set containing 3, 5, 1 -- once we have defined 
    * the main constructor and the add operation. 
    * post: returns res s.t. res.S = {x1, x2,...,xn}
    *       where xs = [x1, x2,...,xn ] */
  def apply(xs: Int*) : IntSet = {
    val s = new IntSet; for(x <- xs) s.add(x); s
  }
}
