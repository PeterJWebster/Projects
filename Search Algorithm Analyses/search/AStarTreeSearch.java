package search;

public class AStarTreeSearch {
    private final TreeSearch treeSearch;

    public AStarTreeSearch(NodeFunction heuristicFunction) {
        // Instantiate TreeSearch with a BestFirstFrontier parameterized by A* function
        this.treeSearch = new TreeSearch(new BestFirstFrontier(new AStarFunction(heuristicFunction)));
    }

    public Node findSolution(State initialState, GoalTest goalTest) {
        Node root = new Node(null, null, initialState, 0);

        return treeSearch.findSolution(root, goalTest);
    }

    public int getNodesGenerated() {
        return treeSearch.getNodesGenerated();
    }

    public int getMaxFrontierNodes() {
        return treeSearch.getMaxFrontierNodes();
    }
}
