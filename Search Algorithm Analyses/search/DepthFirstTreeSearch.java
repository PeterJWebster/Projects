package search;

public class DepthFirstTreeSearch {
    private final TreeSearch treeSearch;

    public DepthFirstTreeSearch() {
        // Instantiates TreeSearch with DepthFirstFrontier
        this.treeSearch = new TreeSearch(new DepthFirstFrontier());
    }

    public Node findSolution(State initialState, GoalTest goalTest) {
        // Creates the root node with no parent and no action for the initial state
        Node root = new Node(null, null, initialState, 0);

        return treeSearch.findSolution(root, goalTest);
    }

    public int getNodesGenerated() {
        return (treeSearch.getNodesGenerated());
    }

    public int getMaxFrontierNodes() {
        return (treeSearch.getMaxFrontierNodes());
    }
}
