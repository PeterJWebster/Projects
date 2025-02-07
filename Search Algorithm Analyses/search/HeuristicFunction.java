package search;

import npuzzle.Tiles;

public class HeuristicFunction implements NodeFunction {

    @Override
    public int evaluate(Node node) {
        Tiles state = (Tiles) node.getState();
        return calculateMisplacedTiles(state);
    }

    private int calculateMisplacedTiles(Tiles tiles) {
        int misplacedCount = 0;
        int width = tiles.getWidth();

        // Iterates through all positions in the  grid
        for (int row = 0; row < width; row++) {
            for (int column = 0; column < width; column++) {
                int tile = tiles.getTile(row, column);

                // Calculates  expected value for this position in goal state
                int goalTile = (row * width + column + 1) % (width * width); 

                // Counts as misplaced if the tile not empty and not in its goal position
                if (tile != Tiles.EMPTY_TILE && tile != goalTile) {
                    misplacedCount++;
                }
            }
        }
        return misplacedCount;
    }
}
