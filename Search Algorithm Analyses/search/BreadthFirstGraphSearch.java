package search;

public class BreadthFirstGraphSearch {
    private final GraphSearch graphSearch;

    public BreadthFirstGraphSearch() {
        // Instantiates GraphSearch with BreadthFirstFrontier
        this.graphSearch = new GraphSearch(new BreadthFirstFrontier());
    }

    public Node findSolution(State initialState, GoalTest goalTest) {
        // Creates the root node with no parent and no action for the initial state
        Node root = new Node(null, null, initialState, 0);

        return graphSearch.findSolution(root, goalTest);
    }

    public int getNodesGenerated() {
        return (graphSearch.getNodesGenerated());
    }

    public int getMaxFrontierNodes() {
        return (graphSearch.getMaxFrontierNodes());
    }
}