package search;

public class AStarFunction implements NodeFunction {
    private final NodeFunction heuristicFunction;

    public AStarFunction(NodeFunction heuristicFunction) {
        this.heuristicFunction = heuristicFunction;
    }

    @Override
    public int evaluate(Node node) {
        int g = node.getPathCost(); // the cost of the path so far
        int h = heuristicFunction.evaluate(node); //  heuristic estimate of remaining cost
        return g + h; // f(n) = g(n) + h(n)
    }
}
