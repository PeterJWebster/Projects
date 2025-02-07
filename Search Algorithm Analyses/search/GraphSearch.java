package search;

import java.util.HashSet;
import java.util.Set;

public class GraphSearch implements Search {
    private final Frontier frontier;
    private final Set<State> explored;
    private int nodesGenerated;

    public GraphSearch(Frontier frontier) {
        this.frontier = frontier;
        this.explored = new HashSet<>();
        this.nodesGenerated = 0;
    }

    @Override
    public Node findSolution(Node root, GoalTest goalTest) {
        frontier.add(root);
        nodesGenerated = 1;

        while (!frontier.isEmpty()) {
            Node currentNode = frontier.remove();

            // If the current state is the goal state, returns the solution
            if (goalTest.isGoal(currentNode.getState())) {
                return currentNode;
            }

            // Marks the current state as explored
            explored.add(currentNode.getState());

            // Generates child nodes
            for (Action action : currentNode.getState().getApplicableActions()) {
                State childState = currentNode.getState().getActionResult(action);
                Node childNode = new Node(currentNode, action, childState, currentNode.getDepth() + 1);

                // Adds childNode to frontier if  hasn't been explored yet
                if (!explored.contains(childState)) {
                    frontier.add(childNode);
                    nodesGenerated++;
                }
            }
        }

        return null; 
    }

    @Override
    public int getNodesGenerated() {
        return nodesGenerated;
    }

    public int getMaxFrontierNodes() {
        return (frontier.getMaxNodesStored());
    }
}
