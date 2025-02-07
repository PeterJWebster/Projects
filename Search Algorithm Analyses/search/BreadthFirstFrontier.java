package search;

import java.util.LinkedList;
import java.util.Queue;

public class BreadthFirstFrontier implements Frontier {
    private Queue<Node> queue;
    private int maxNodesStored = 0;

    public BreadthFirstFrontier() {
        queue = new LinkedList<>();
    }

    @Override
    public void add(Node node) {
        queue.add(node);
        maxNodesStored = Math.max(maxNodesStored, queue.size());
    }

    @Override
    public void clear() {
        queue.clear();
        maxNodesStored = 0;
    }

    @Override
    public boolean isEmpty() {
        return queue.isEmpty();
    }

    @Override
    public Node remove() {
        return queue.poll();
    }

    @Override
    public int getMaxNodesStored() {
        return maxNodesStored;
    }
}
