package tour;

import search.*;

public class CompareRomaniaTourSearch {
    public static void main(String[] args) {
        System.out.println("This is a comparison of different search algorithms on the Romania tour problem");
        System.out.println();
        
        Cities romania = SetUpRomania.getRomaniaMapSmall();
        City startCity = romania.getState("Bucharest");

        GoalTest goalTest = new TourGoalTest(romania.getAllCities(), startCity);
        
        // Breadth-First Tree Search
        System.out.println("Breadth-First Tree Search:");
        BreadthFirstTreeSearch bfsTree = new BreadthFirstTreeSearch();
        Node solution1 = bfsTree.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(solution1);
        int nodes1 = bfsTree.getNodesGenerated();
        System.out.println("Number of nodes generated:");
        System.out.println(nodes1);
        int frontierNodes1 = bfsTree.getMaxFrontierNodes();
        System.out.println("Max number of frontier nodes generated:");
        System.out.println(frontierNodes1);

        // Breadth-First Graph Search
        System.out.println("\nBreadth-First Graph Search:");
        BreadthFirstGraphSearch bfsGraph = new BreadthFirstGraphSearch();
        Node solution2 = bfsGraph.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(solution2);
        int nodes2 = bfsGraph.getNodesGenerated();
        System.out.println("Number of nodes generated:");
        System.out.println(nodes2);
        int frontierNodes2 = bfsGraph.getMaxFrontierNodes();
        System.out.println("Max number of frontier nodes generated:");
        System.out.println(frontierNodes2);
/*
        // Depth-First Tree Search
        System.out.println("\nDepth-First Tree Search:");
        DepthFirstTreeSearch dfsTree = new DepthFirstTreeSearch();
        Node solution3 = dfsTree.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(solution3);
        int nodes3 = dfsTree.getNodesGenerated();
        System.out.println("Number of nodes generated:");
        System.out.println(nodes3);
        int frontierNodes3 = dfsTree.getMaxFrontierNodes();
        System.out.println("Max number of frontier nodes generated:");
        System.out.println(frontierNodes3);
*/
        // Depth-First Graph Search
        System.out.println("\nDepth-First Graph Search:");
        DepthFirstGraphSearch dfsGraph = new DepthFirstGraphSearch();
        Node solution4 = dfsGraph.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(solution4);
        int nodes4 = dfsGraph.getNodesGenerated();
        System.out.println("Number of nodes generated:");
        System.out.println(nodes4);
        int frontierNodes4 = dfsGraph.getMaxFrontierNodes();
        System.out.println("Max number of frontier nodes generated:");
        System.out.println(frontierNodes4);

        // Iterative Deepening Tree Search
        System.out.println("\nIterative Deepening Tree Search:");
        IterativeDeepeningTreeSearch idTree = new IterativeDeepeningTreeSearch();
        Node solution5 = idTree.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(solution5);
        int nodes5 = idTree.getNodesGenerated();
        System.out.println("Number of nodes generated:");
        System.out.println(nodes5);
        int frontierNodes5 = idTree.getMaxFrontierNodes();
        System.out.println("Max number of frontier nodes generated:");
        System.out.println(frontierNodes5);
        
    }
}
