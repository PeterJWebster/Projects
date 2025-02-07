package search;

import java.util.PriorityQueue;
import java.util.Comparator;

public class BestFirstFrontier implements Frontier {
    private final PriorityQueue<Node> frontierQueue;
    private final NodeFunction nodeFunction;
    private int maxNodesStored;

    public BestFirstFrontier(NodeFunction nodeFunction) {
        this.nodeFunction = nodeFunction;
        this.frontierQueue = new PriorityQueue<>(Comparator.comparingInt(Node::getValue));
        this.maxNodesStored = 0;
    }

    @Override
    public void add(Node node) {
        // Computes the node's value using the NodeFunction and set it, beofre adding to queue and increase max size if needed
        int nodeValue = nodeFunction.evaluate(node);
        node.setValue(nodeValue);

        frontierQueue.add(node);

        maxNodesStored = Math.max(maxNodesStored, frontierQueue.size());
    }

    @Override
    public Node remove() {
        return frontierQueue.poll();
    }

    @Override
    public boolean isEmpty() {
        return frontierQueue.isEmpty();
    }

    @Override
    public int getMaxNodesStored() {
        return maxNodesStored;
    }

    @Override
    public void clear() {
        frontierQueue.clear();
        maxNodesStored = 0;
    }
}
