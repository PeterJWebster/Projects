EXERCISE 1


> module Geography(Place, Direction(N,S,E,W), move, opposite, Wall, Size)
> where

> type Place = (Int, Int)

> data Direction = N | S | E | W deriving (Eq, Show)

> opposite :: Direction -> Direction
> opposite N = S
> opposite S = N
> opposite E = W
> opposite W = E

ghci> opposite E
W
ghci> opposite S
N

> move :: Direction -> Place -> Place
> move N (i,j) = (i,j+1)
> move S (i,j) = (i,j-1)
> move E (i,j) = (i+1,j)
> move W (i,j) = (i-1,j)

ghci> move E (2,2)
(3,2)
ghci> move S (0,0)
(0,-1)

> type Wall = (Place, Direction)

> type Size = (Int, Int)

EXERCISE 2

> data Maze = Maze Size [Wall]

> makeMaze :: Size -> [Wall] -> Maze
> makeMaze (x,y) walls = 
>   let boundaries = -- the four boundaries
>         [((0,j),   W) | j <- [0..y-1]] ++ -- westerly boundary
>         [((x-1,j), E) | j <- [0..y-1]] ++ -- easterly boundary
>         [((i,0),   S) | i <- [0..x-1]] ++ -- southerly boundary
>         [((i,y-1), N) | i <- [0..x-1]]    -- northerly boundary
>       allWalls = walls ++ boundaries ++ map reflect (walls ++ boundaries)
>  in Maze (x,y) allWalls

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (Maze _ walls) pos d = (pos,d) `elem` walls

> sizeOf :: Maze -> Size
> sizeOf (Maze size _) = size

> drawMaze :: Maze -> IO()
> drawMaze = putStr . concat . map drawRow . separateRows . getWalls

The 'getWalls' function takes a 'Maze' type and returns its 'walls' component

> getWalls :: Maze -> [Wall]
> getWalls (Maze _ walls) = walls

ghci> getWalls smallMaze
[((0,0),N),((2,2),E),((2,1),E),((1,0),E),((1,2),E),((1,1),N),((0,0),W),((0,1),W),((0,2),W),((3,0),E),((3,1),E),((3,2),E),((0,0),S),((1,0),S),((2,0),S),((3,0),S),((0,2),N),((1,2),N),((2,2),N),((3,2),N),((0,1),S),((3,2),W),((3,1),W),((2,0),W),((2,2),W),((1,2),S),((-1,0),E),((-1,1),E),((-1,2),E),((4,0),W),((4,1),W),((4,2),W),((0,-1),N),((1,-1),N),((2,-1),N),((3,-1),N),((0,3),S),((1,3),S),((2,3),S),((3,3),S)]

The following two functions return the dimensions of a maze given its walls component, which will be used as stopping conditions in the 'drawCellsVertical' and 'drawCellsHorizontal' functions

> height :: [Wall] -> Int
> height walls = maximum (map getY walls)
>    where getY ((_,j),_) = j
> width :: [Wall] -> Int
> width walls = maximum (map getX walls)
>    where getX ((i,_),d) | d == W    = i
>                         | d == S    = i+1
>                         | otherwise = 0

ghci> height (getWalls smallMaze)
3
ghci> width (getWalls largeMaze)
24

> separateRows :: [Wall] -> [[Wall]]
> separateRows walls = filterRows (height walls) walls

The 'filterRows' function separates the list of walls into a list of lists based on which row each wall appears in.

> filterRows :: Int -> [Wall] -> [[Wall]]
> filterRows (-1) _ = []
> filterRows n walls = [((i,j),d) | ((i,j),d) <- walls, j == n] : filterRows (n-1) walls

ghci> separateRows (getWalls smallMaze)
[[((0,3),S),((1,3),S),((2,3),S),((3,3),S)],[((2,2),E),((1,2),E),((0,2),W),((3,2),E),((0,2),N),((1,2),N),((2,2),N),((3,2),N),((3,2),W),((2,2),W),((1,2),S),((-1,2),E),((4,2),W)],[((2,1),E),((1,1),N),((0,1),W),((3,1),E),((0,1),S),((3,1),W),((-1,1),E),((4,1),W)],[((0,0),N),((1,0),E),((0,0),W),((3,0),E),((0,0),S),((1,0),S),((2,0),S),((3,0),S),((2,0),W),((-1,0),E),((4,0),W)]]

This function converts each row into a string by first converting the vertical walls, followed by the horizontal walls on the next line. The function 'deRow' is also defined here, which removes the row specification o f each wall in the list, as the the following function will need to work on every row of the maze, so it can't be specific to any one row when checking if a wall should be drawn.

> drawRow :: [Wall] -> String
> drawRow walls = drawRowVertical (map deRow walls) ++ "\n" ++ 
>                 drawRowHorizontal (map deRow walls) ++ "\n"
>           where deRow ((i,j),d) = ((i,-2),d)

> drawRowVertical :: [Wall] -> String
> drawRowVertical walls = drawCellsVertical walls 0

The following function iterates through each cell in a row and checks to see if a wall with that x co-ordinate exists. It then draws/doesn't draw the wall accordingly.

> drawCellsVertical :: [Wall] -> Int -> String
> drawCellsVertical walls n | n == width walls + 1  = ""
>                           | elem ((n,-2),W) walls = "|  " ++ drawCellsVertical walls (n+1)
>                           | otherwise             = "   " ++ drawCellsVertical walls (n+1)

> drawRowHorizontal :: [Wall] -> String
> drawRowHorizontal walls = drawCellsHorizontal walls 0

This one works exactly the same as 'drawCellsVertical', however the stopping condition now results in a "+", as each horizontal row ends with one.

> drawCellsHorizontal :: [Wall] -> Int -> String
> drawCellsHorizontal walls n | n == width walls      = "+"
>                             | elem ((n,-2),S) walls = "+--" ++ drawCellsHorizontal walls (n+1)
>                             | otherwise             = "+  " ++ drawCellsHorizontal walls (n+1)

ghci> drawMaze smallMaze
               
+--+--+--+--+
|     |  |  |  
+  +--+  +  +
|        |  |  
+--+  +  +  +
|     |     |  
+--+--+--+--+
ghci> drawMaze largeMaze
                        |  
+  +  +  +  +  +  +  +  +
                        |  
+  +  +  +  +  +  +  +  +
                        |  
+  +  +  +  +  +  +  +  +
                        |                                               
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                       |                 |  |     |     |           |  
+  +--+--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +  +  +  +--+--+--+
|                    |  |  |  |           |  |  |  |  |  |  |     |  |  
+--+--+--+--+--+--+  +  +  +  +  +--+--+--+  +  +  +  +  +  +  +  +  +
|                    |  |  |  |  |           |  |  |  |     |  |  |  |  
+  +--+--+--+--+--+--+  +  +  +  +  +--+--+  +  +  +  +--+--+  +  +  +
|        |           |  |  |  |  |  |        |  |  |           |  |  |  
+--+--+  +  +--+--+--+  +--+  +  +  +  +--+--+--+  +--+--+--+  +  +  +
|     |  |           |        |     |  |        |     |        |  |  |  
+  +  +  +--+--+--+  +--+--+--+--+--+  +  +  +  +--+  +  +--+--+  +  +
|  |  |     |     |  |                 |  |  |  |     |        |  |  |  
+  +  +--+  +  +  +  +  +--+--+--+--+--+  +  +  +  +--+--+--+  +  +  +
|  |        |  |  |  |           |     |  |  |  |     |        |     |  
+  +--+--+--+  +  +  +--+--+--+  +  +--+  +  +  +--+  +  +--+--+--+--+
|              |  |  |           |  |  |  |  |        |              |  
+--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +--+--+--+--+--+--+--+  +
|                 |     |           |  |  |                       |  |  
+  +--+--+--+--+--+--+  +  +--+--+--+  +  +--+--+--+--+--+--+--+  +  +
|           |        |  |           |  |        |                 |  |  
+--+--+--+  +--+--+  +  +--+--+--+  +  +--+--+  +  +--+--+--+--+--+  +
|           |     |  |     |     |  |  |     |  |                    |  
+  +--+--+--+  +  +  +  +  +  +  +  +  +  +  +  +--+--+--+--+--+--+--+
|           |  |  |  |  |  |  |  |  |  |  |  |                       |  
+--+--+--+  +  +  +  +  +  +  +  +  +  +  +  +  +--+--+--+--+--+--+  +
|           |  |  |  |  |  |  |  |  |  |  |     |     |     |     |  |  
+  +--+--+--+  +  +  +  +  +  +  +  +  +  +--+--+--+  +  +  +  +  +  +
|  |     |     |     |  |     |  |  |  |           |  |  |  |  |     |  
+  +  +  +  +  +--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +  +--+--+
|  |  |  |  |        |           |  |           |  |     |     |     |  
+  +  +  +  +--+--+  +  +--+--+--+  +--+--+--+  +  +--+--+--+--+  +  +
|  |  |  |  |     |  |           |     |     |  |  |              |  |  
+  +  +  +  +  +  +  +--+--+--+  +  +  +  +  +  +  +  +--+--+--+--+  +
|  |  |     |  |  |  |           |  |  |  |  |  |        |     |     |  
+  +  +--+  +  +  +  +  +--+--+--+--+  +  +  +  +--+--+  +  +  +  +--+
|  |     |  |  |  |  |              |  |  |  |           |  |  |     |  |  
+  +--+  +  +  +  +--+--+--+--+--+  +  +  +  +--+--+--+  +  +  +--+  +  +
|     |  |  |  |           |     |  |     |              |  |        |  
+  +  +  +  +  +--+--+--+  +  +  +  +--+--+--+--+--+--+--+  +--+--+--+
|  |  |  |  |  |           |  |  |                       |           |  
+  +  +  +  +  +  +--+--+--+  +  +--+--+--+--+--+--+--+  +--+--+  +  +
|  |  |  |  |  |           |  |                       |           |  |  
+  +  +  +  +--+--+--+--+  +  +--+--+--+--+--+--+--+--+--+--+--+--+  +
|  |     |                 |                                         |  
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+


EXERCISE 3

> type Path = [Direction]

'solveMaze' is initialised with the partial solutions list containing just the start location, and and empty list (as the path to get there involves no moves)

> solveMaze :: Maze -> Place -> Place -> Path
> solveMaze maze start end = solveMazeIter maze end [(start, [])] 

Here, the guard conditions mean that if the location currently being evaluated is the end location, the path there can be returned. If the location hasn't been found, then the function need only consider the tail of the list, with the four adjacent squares appended.

> solveMazeIter :: Maze -> Place -> [(Place, Path)] -> Path
> solveMazeIter maze end partSol | (fst.head) partSol == end  = (snd.head) partSol
>                                | otherwise                  = solveMazeIter maze end (tail partSol ++ (options.head) partSol)
>                                               where options x = north x ++ south x ++ east x ++ west x
>                                                     north (x,ds) | elem (x, N) (getWalls maze)  = []
>                                                                  | otherwise                        = [(move N x, ds ++ [N])] 
>                                                     south (x,ds) | elem (x, S) (getWalls maze)  = []
>                                                                  | otherwise                        = [(move S x, ds ++ [S])] 
>                                                     east (x,ds) | elem (x, E) (getWalls maze)  = []
>                                                                 | otherwise                        = [(move E x, ds  ++ [E])] 
>                                                     west (x,ds) | elem (x, W) (getWalls maze)  = []
>                                                                 | otherwise                        = [(move W x, ds ++ [W])] 

ghci> solveMaze smallMaze (0,0) (3,2)
[E,N,E,S,E,N,N]
(0.00 secs, 501,120 bytes)
ghci> solveMaze largeMaze (0,0) (22,21)
^CInterrupted.


EXERCISE 4

The only difference here is that the 'visited' list of locations is initialised as an empty list, as none have been visited.

> solveMaze2 :: Maze -> Place -> Place -> Either String Path
> solveMaze2 maze start end = fastSolveMazeIter maze end [(start, [])] []

This function is the same as 'solveMazeIter', but in the recursive call the location that was just evaluated is added to the 'visited' list. 

> fastSolveMazeIter :: Maze -> Place -> [(Place, Path)] -> [Place] -> Either String Path
> fastSolveMazeIter maze end partSol visited | partSol == []              = Left "A solution cannot be found for this maze"
>                                            | (fst.head) partSol == end  = Right ((snd.head) partSol)
>                                            | otherwise                  = fastSolveMazeIter maze end (tail partSol ++ (options.head) partSol) (visited ++ [(fst.head) partSol])
>                                        where options x = north x ++ south x ++ east x ++ west x
>                                              north (x,ds) | elem (x, N) (getWalls maze) || elem (move N x) visited = []
>                                                           | otherwise = [(move N x, ds ++ [N])] 
>                                              south (x,ds) | elem (x, S) (getWalls maze) || elem (move S x) visited  = []
>                                                           | otherwise = [(move S x, ds ++ [S])] 
>                                              east (x,ds) | elem (x, E) (getWalls maze) || elem (move E x) visited  = []
>                                                          | otherwise  = [(move E x, ds  ++ [E])] 
>                                              west (x,ds) | elem (x, W) (getWalls maze) || elem (move W x) visited  = []
>                                                          | otherwise  = [(move W x, ds ++ [W])] 

ghci> solveMaze2 smallMaze (0,0) (3,2)
Right [E,N,E,S,E,N,N]
(0.00 secs, 145,728 bytes)
ghci> solveMaze2 largeMaze (0,0) (22,21)
Right [N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,
W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,
E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,
W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,
E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,
N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,
N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,
N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.05 secs, 11,864,920 bytes)


> run (x,y) n E = [((x,y+i),E) | i <- [0..n-1]]
> run (x,y) n N = [((x+i,y),N) | i <- [0..n-1]]

> largeMaze :: Maze 
> largeMaze =
>   let walls = 
>         run (0,0) 3 E ++ run (1,1) 3 E ++ [((1,3),N)] ++ run (0,4) 5 E ++
>         run (2,0) 5 E ++ [((2,4),N)] ++ run (1,5) 3 E ++
>         run (1,8) 3 N ++ run (2,6) 3 E ++
>         run (3,1) 7 E ++ run (4,0) 4 N ++ run (4,1) 5 E ++ run (5,2) 3 N ++
>         run (4,6) 2 N ++ run (5,4) 3 E ++ run (6,3) 5 N ++ run (8,0) 4 E ++
>         run (6,1) 3 N ++ run (0,9) 3 N ++ run (1,10) 3 N ++ run (0,11) 3 N ++
>         run (1,12) 6 N ++ run (3,9) 4 E ++ run (4,11) 2 N ++
>         run (5,9) 3 E ++ run (4,8) 3 E ++ run (5,7) 5 N ++ run (6,4) 9 E ++
>         run (7,5) 3 N ++ run (8,4) 4 N ++ run (8,6) 3 N ++ run (10,5) 7 E ++
>         run (9,8) 3 E ++ run (8,9) 3 E ++ run (7,8) 3 E ++ run (8,11) 3 N ++
>         run (0,13) 5 N ++ run (4,14) 2 E ++ run (0,15) 2 E ++ 
>         run (1,14) 3 N ++ run (3,15) 2 E ++ run (0,17) 2 N ++ 
>         run (1,16) 2 E ++ run (2,15) 1 N ++ run (3,16) 3 N ++
>         run (2,17) 2 E ++ run (1,18) 6 N ++ run (4,17) 3 N ++ 
>         run (6,14) 7 E ++ run (5,13) 4 E ++ run (7,12) 2 E ++
>         run (8,13) 3 N ++ run (7,14) 3 N ++ run (10,14) 2 E ++
>         run (8,15) 5 N ++ run (7,16) 5 N ++ run (9,1) 2 E ++
>         run (10,0) 12 N ++ run (21,1) 1 E ++ run (10,2) 2 E ++
>         run (11,1) 7 N ++ run (17,1) 1 E ++ run (11,3) 3 E ++
>         run (12,2) 7 N ++ run (18,2) 2 E ++ run (19,1) 2 N ++
>         run (15,3) 3 N ++ run (14,4) 3 E ++ run (13,3) 3 E ++
>         run (12,4) 3 E ++ run (12,6) 3 N ++ run (11,7) 8 E ++ 
>         run (9,12) 3 N ++ run (12,14) 1 N ++ run (12,8) 10 E ++
>         run (0,19) 6 N ++ run (1,20) 6 N ++ run (7,18) 8 E ++
>         run (8,17) 1 N ++ run (8,18) 3 E ++ run (9,17) 4 E ++ 
>         run (10,18) 2 E ++ run (11,17) 2 E ++ run (10,20) 3 N ++
>         run (11,19) 3 N ++ run (12,18) 2 N ++ run (13,17) 2 N ++
>         run (13,13) 4 E ++ run (14,12) 7 N ++ run (13,11) 2 N ++
>         run (14,10) 2 E ++ run (13,9)2 E ++ run (14,8) 3 N ++ 
>         run (13,7) 3 N ++ run (15,5) 3 E ++ run (16,6) 3 E ++
>         run (18,5) 4 N ++ run (16,4) 2 N ++ run (13,20) 2 E ++
>         run (14,18) 4 E ++ run (20,2) 3 N ++ run (19,3) 2 E ++
>         run (18,4) 2 E ++ run (23,4) 1 E ++ run (22,4) 1 N ++
>         run (21,3) 1 N ++ run (20,4) 2 E ++ run (17,6) 4 N ++ 
>         run (20,7) 2 E ++ run (21,7) 2 N ++ run (21,6) 1 E ++ 
>         run (15,9) 1 E ++ run (17,8) 2 E ++ run (18,7) 2 E ++ 
>         run (19,8) 2 E ++ run (21,9) 1 E ++ run (16,9) 6 N ++
>         run (16,10) 7 N ++ run (15,11) 2 E ++ run (17,11) 5 N ++ 
>         run (14,14) 3 E ++ run (15,15) 6 E ++ run (17,14) 4 E ++
>         run (16,18) 4 E ++ run (15,17) 1 N ++ run (17,17) 3 N ++
>         run (15,13) 7 N ++ run (21,12) 2 E ++ run (16,16) 1 N ++
>         run (16,14) 1 N ++ run (17,15) 3 N ++ run (19,14) 4 N ++
>         run (20,15) 5 E ++ run (19,16) 2 N ++ run (21,16) 5 E ++
>         run (17,19) 2 E ++ run (18,20) 2 E ++ run (19,19) 2 E ++
>         run (18,18) 2 N ++ run (20,20) 3 N
>   in makeMaze (23,22) walls

> smallMaze :: Maze
> smallMaze = 
>   let walls = [((0,0), N), ((2,2), E), ((2,1),E), ((1,0),E), 
>                ((1,2), E), ((1,1), N)]
>   in makeMaze (4,3) walls

> maze1 :: Maze
> maze1 =
>   let walls = [((0,0), N), ((1,0), N), ((2,0),N), ((0,3),N), ((3,1),E), 
>                ((3,1), N), ((2,1), N), ((1,1), N), ((0,2), E), ((0,3), E)]
>   in makeMaze (7,5) walls

> impossibleMaze :: Maze
> impossibleMaze =
>   let walls = [((0,1), E), ((1,0),N), ((1,2), E), ((2,1), N)]
>   in makeMaze (3,3) walls
