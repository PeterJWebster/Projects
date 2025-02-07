package search;

public class TreeSearch implements Search {
    private final Frontier frontier;
    private int nodesGenerated;

    public TreeSearch(Frontier frontier) {
        this.frontier = frontier;
        this.nodesGenerated = 0; 
    }

    @Override
    public Node findSolution(Node root, GoalTest goalTest) {
        frontier.add(root);
        nodesGenerated = 1;

        while (!frontier.isEmpty()) {
			Node node = frontier.remove();
			if (goalTest.isGoal(node.state))
				return node;
			else {
				for (Action action : node.state.getApplicableActions()) {
					State newState = node.state.getActionResult(action);
					frontier.add(new Node(node, action, newState, node.getDepth() + 1));
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
