package search;

public class BreadthFirstTreeSearch {
    private final TreeSearch treeSearch;

    public BreadthFirstTreeSearch() {
        // Instantiates GraphSearch with DepthFirstFrontier
        this.treeSearch = new TreeSearch(new BreadthFirstFrontier());
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
