package tour;

import search.*;

public class CompareRomaniaTourSearchWithAStar {
    public static void main(String[] args) {
        Cities romania = SetUpRomania.getRomaniaMapSmall();
        City startCity = romania.getState("Bucharest");
        City goalCity = romania.getState("Bucharest");

        GoalTest goalTest = new TourGoalTest(romania.getAllCities(), goalCity);

        NodeFunction heuristic = new RomaniaTourHeuristic(romania, goalCity);

        // A* Tree Search
        System.out.println("A* Tree Search:");
        AStarTreeSearch treeSearch = new AStarTreeSearch(heuristic);
        Node treeSolution = treeSearch.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(treeSolution);
        System.out.println("Nodes Generated (A* Tree Search): " + treeSearch.getNodesGenerated());
        System.out.println("Max Frontier Nodes (A* Tree Search): " + treeSearch.getMaxFrontierNodes());

        // A* Graph Search
        System.out.println("A* Graph Search:");
        AStarGraphSearch graphSearch = new AStarGraphSearch(heuristic);
        Node graphSolution = graphSearch.findSolution(new TourState(startCity), goalTest);
        new TourPrinting().printSolution(graphSolution);
        System.out.println("Nodes Generated (A* Graph Search): " + graphSearch.getNodesGenerated());
        System.out.println("Max Frontier Nodes (A* Graph Search): " + graphSearch.getMaxFrontierNodes());
    }
}
 /*
  * The A* algorithms use drastically fewer nodes, both generated in total
  * and the maximum on the frontier. This is because it isn't wasting time
  * by going down paths which aren't getting it closer to the end.
  */