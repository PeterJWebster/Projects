package tour;

import search.Node;
import search.NodeFunction;

import java.util.Set;

public class RomaniaTourHeuristic implements NodeFunction {
    private final City goalCity;
    private final Cities cities;

    public RomaniaTourHeuristic(Cities cities, City goalCity) {
        this.cities = cities;
        this.goalCity = goalCity;
    }

    @Override
    public int evaluate(Node node) {
        TourState tourState = (TourState) node.getState();

        Set<City> unvisitedCities = getUnvisitedCities(tourState);

        if (unvisitedCities.isEmpty()) {
            return 0; 
        }

        // Find city from unvisited cities that is furthest away
        City currentCity = tourState.currentCity;
        int maxDistance = 0;
        City furthestCity = null;
        for (City city : unvisitedCities) {
            int distance = currentCity.getShortestDistanceTo(city);
            maxDistance = Math.max(maxDistance, distance);
            furthestCity = city;
        }

        int distanceToGoal = furthestCity.getShortestDistanceTo(goalCity);

        return maxDistance + distanceToGoal;
    }

    private Set<City> getUnvisitedCities(TourState tourState) {
        Set<City> unvisitedCities = cities.getAllCities();
        unvisitedCities.removeAll(tourState.visitedCities);
        return unvisitedCities;
    }
}
