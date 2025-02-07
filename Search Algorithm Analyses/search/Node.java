package search;

public class Node {
	public final Node parent;
	public final Action action;
	public final State state;
    public final int pathCost;
    public int value;
    public final int depth;
	
	public Node(Node parent, Action action, State state, int depth) {
		this.parent = parent;
		this.action = action;
		this.state = state;
        this.depth = depth;

        if (parent == null) {
            this.pathCost = 0; 
        } else {
            this.pathCost = parent.getPathCost() + action.getCost();
        }
	}

    public State getState() {
        return state; 
    }

    public Node getParent() {
        return parent;
    }

    public Action getAction() {
        return action;
    }

    public int getPathCost() {
        return pathCost; 
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value){
        this.value = value;
    }

    public int getDepth() {
        return depth; 
    }
}
