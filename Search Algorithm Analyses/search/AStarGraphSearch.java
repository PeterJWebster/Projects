package search;

public class AStarGraphSearch {
    private final GraphSearch graphSearch;

    public AStarGraphSearch(NodeFunction heuristicFunction) {
        // Instantiates GraphSearch with a BestFirstFrontier parameterized by A* function
        this.graphSearch = new GraphSearch(new BestFirstFrontier(new AStarFunction(heuristicFunction)));
    }

    public Node findSolution(State initialState, GoalTest goalTest) {
        Node root = new Node(null, null, initialState, 0);

        return graphSearch.findSolution(root, goalTest);
    }

    public int getNodesGenerated() {
        return graphSearch.getNodesGenerated();
    }

    public int getMaxFrontierNodes() {
        return graphSearch.getMaxFrontierNodes();
    }
}
