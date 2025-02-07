package search;

public class IterativeDeepeningTreeSearch {
    private int nodesGenerated;
    private DepthFirstFrontier frontier;

    public Node findSolution(State initialState, GoalTest goalTest) {
        nodesGenerated = 0;
        int depthLimit = 0;
        Node solution = null;

        while (solution == null) {
            solution = depthLimitedSearch(initialState, goalTest, depthLimit);
            depthLimit++;
        }

        return solution;
    }

    private Node depthLimitedSearch(State initialState, GoalTest goalTest, int depthLimit) {
        frontier = new DepthFirstFrontier();
        Node root = new Node(null, null, initialState, 0); 
        frontier.add(root);
        nodesGenerated++;

        while (!frontier.isEmpty()) {
            Node currentNode = frontier.remove();

            if (goalTest.isGoal(currentNode.getState())) {
                return currentNode;
            }

            // If  node's depth is less than the limit, generate its children
            if (currentNode.depth < depthLimit) {
                for (Action action : currentNode.getState().getApplicableActions()) {
                    State childState = currentNode.getState().getActionResult(action);
                    Node childNode = new Node(currentNode, action, childState, currentNode.depth + 1);
                    frontier.add(childNode);

                    nodesGenerated++;
                }
            }
        }

        return null;
    }
    
    public int getNodesGenerated() {
        return nodesGenerated;
    }

    public int getMaxFrontierNodes() {
        return frontier.getMaxNodesStored();
    }
}
