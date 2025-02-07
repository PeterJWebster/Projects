package search;

import java.util.Stack;

public class DepthFirstFrontier implements Frontier {
    private Stack<Node> stack;
    private int maxNodesStored = 0;

    public DepthFirstFrontier() {
        stack = new Stack<>();
    }

    @Override
    public void add(Node node) {
        stack.push(node);
        maxNodesStored = Math.max(maxNodesStored, stack.size());
    }

    @Override
    public void clear() {
        stack.clear();
        maxNodesStored = 0;
    }

    @Override
    public boolean isEmpty() {
        return stack.isEmpty();
    }

    @Override
    public Node remove() {
        return stack.pop();
    }

    @Override
    public int getMaxNodesStored() {
        return maxNodesStored;
    }
}
