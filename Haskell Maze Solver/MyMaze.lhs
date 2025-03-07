Module to define the type of a maze

> module MyMaze (
>   Maze,
>   makeMaze, -- :: Size -> [Wall] -> Maze
>   hasWall,  -- :: Maze -> Place -> Direction -> Bool
>   sizeOf    -- :: Maze -> Size
> )
> where

> import Geography

We will represent a maze by its size and a list of its walls.

> data Maze = AMaze Size [Place] [Place] [Place] [Place]

The list of walls will be complete in the sense that we record
both sides of the wall; for example, if the list includes
((3,4), N), then it will also include ((3,5),S).

This function creates a maze given its size and a list of walls;
the list of walls might not be complete in the above sense.

> makeMaze :: Size -> [Wall] -> Maze
> makeMaze (x,y) walls =
>   let boundaries = -- the four boundaries
>         [((0,j),   W) | j <- [0..y-1]] ++ -- westerly boundary
>         [((x-1,j), E) | j <- [0..y-1]] ++ -- easterly boundary
>         [((i,0),   S) | i <- [0..x-1]] ++ -- southerly boundary
>         [((i,y-1), N) | i <- [0..x-1]]    -- northerly boundary
>       allWalls = walls ++ boundaries ++ map reflect (walls ++ boundaries)
>  in AMaze (x,y) [(i,j) | ((i,j), N) <- allWalls] [(i,j) | ((i,j), S) <- allWalls] [(i,j) | ((i,j), E) <- allWalls] [(i,j) | ((i,j), W) <- allWalls]

The following function "reflects" a wall; i.e. gives the representation as
seen from the other side; for example, reflect ((3,4), N) = ((3,5),S)

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

The following function tests whether the maze includes a wall in a particular
direction from a particular place:

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (AMaze _ norths souths easts wests) pos d | d == N = pos `elem` norths
>                                                   | d == S = pos `elem` souths
>                                                   | d == E = pos `elem` easts
>                                                   | d == W = pos `elem` wests

The following function returns the size of a maze:

> sizeOf :: Maze -> Size
> sizeOf (AMaze size _ _ _ _) = size

