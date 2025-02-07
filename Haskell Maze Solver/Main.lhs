> import Geography
> import MyMazeBT

======================================================================

Draw a maze.

***************************************
*              Question 2             *
* Complete the definition of drawMaze *
***************************************

> drawMaze :: Maze -> IO()
> drawMaze maze = putStr(drawRows height maze)
>             where height = snd (sizeOf maze)

> drawRows :: Int -> Maze -> String
> drawRows n maze | n == -1   = ""
>                 | otherwise = drawRow n maze ++ drawRows (n-1) maze
>               where drawRow n maze = drawRowVertical n maze ++ drawRowHorizontal n maze

> drawRowVertical :: Int -> Maze -> String
> drawRowVertical n maze 
>                  | n == snd (sizeOf maze) = ""
>                  | otherwise              = drawCellsVertical width n maze ++ "\n"
>                      where width = fst (sizeOf maze)

> drawCellsVertical :: Int -> Int -> Maze -> String
> drawCellsVertical k n maze 
>                  | k == -1              = ""
>                  | hasWall maze (k,n) W = drawCellsVertical (k-1) n maze ++ "|  "
>                  | otherwise            = drawCellsVertical (k-1) n maze ++ "   "

> drawRowHorizontal :: Int -> Maze -> String
> drawRowHorizontal n maze = drawCellsHorizontal (width-1) n maze ++ "\n" 
>                      where width = fst (sizeOf maze)

> drawCellsHorizontal :: Int -> Int -> Maze -> String
> drawCellsHorizontal k n maze 
>                  | k == -1              = "+"
>                  | hasWall maze (k,n) S = drawCellsHorizontal (k-1) n maze ++ "--+"
>                  | otherwise            = drawCellsHorizontal (k-1) n maze ++ "  +"

ghci> drawMaze smallMaze
+--+--+--+--+
|     |  |  |
+  +--+  +  +
|        |  |
+--+  +  +  +
|     |     |
+--+--+--+--+
ghci> drawMaze impossibleMaze
+--+--+--+
|     |  |
+  +  +--+
|  |     |
+  +--+  +
|        |
+--+--+--+
ghci> drawMaze largeMaze
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
|  |     |  |  |  |  |              |  |  |  |           |  |  |     |
+  +--+  +  +  +  +--+--+--+--+--+  +  +  +  +--+--+--+  +  +  +--+  +
|     |  |  |  |           |     |  |     |              |  |        |
+  +  +  +  +  +--+--+--+  +  +  +  +--+--+--+--+--+--+--+  +--+--+--+
|  |  |  |  |  |           |  |  |                       |           |
+  +  +  +  +  +  +--+--+--+  +  +--+--+--+--+--+--+--+  +--+--+  +  +
|  |  |  |  |  |           |  |                       |           |  |
+  +  +  +  +--+--+--+--+  +  +--+--+--+--+--+--+--+--+--+--+--+--+  +
|  |     |                 |                                         |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

======================================================================

Solve the maze, giving a result of type:

> type Path = [Direction]

***************************************
*            Questions 3--4           *
*     Complete the definition of      *
*              solveMaze              *
***************************************

> solveMaze :: Maze -> Place -> Place -> Path
> solveMaze maze start target = solveMazeIter maze target [(start, [])]

> solveMazeIter :: Maze -> Place -> [(Place, Path)] -> Path
> solveMazeIter maze end partSol | (fst.head) partSol  == end  = (snd.head) partSol
>                                | otherwise = solveMazeIter maze end (tail partSol ++ 
>                                              (options.head) partSol)
>      where options x = north x ++ south x ++ east x ++ west x
>            north (x,ds) | hasWall maze x N  = []
>                         | otherwise         = [(move N x, ds ++ [N])]
>            south (x,ds) | hasWall maze x S  = []
>                         | otherwise         = [(move S x, ds ++ [S])]
>            east (x,ds) | hasWall maze x E  = []
>                        | otherwise         = [(move E x, ds ++ [E])]
>            west (x,ds) | hasWall maze x W  = []
>                        | otherwise         = [(move W x, ds ++ [W])]

ghci> solveMaze smallMaze (0,0) (3,2)
[E,N,E,S,E,N,N]
(0.01 secs, 424,136 bytes)
ghci> solveMaze largeMaze (0,0) (22,21)
^CInterrupted.

> solveMaze2 :: Maze -> Place -> Place -> Path
> solveMaze2 maze start target = fastSolveMazeIter maze target [(start, [])] []

> fastSolveMazeIter :: Maze -> Place -> [(Place, Path)] -> [Place] -> Path
> fastSolveMazeIter maze end partSol visited 
>    | partSol == []              = error "A solution cannot be found for this maze"
>    | (fst.head) partSol == end  = ((snd.head) partSol)
>    | otherwise                  = fastSolveMazeIter maze end (tail partSol ++ 
>                                   (options.head) partSol) (visited ++ 
>                                   [(fst.head) partSol])
>              where options x = north x ++ south x ++ east x ++ west x
>                    north (x,ds) | hasWall maze x N || elem (move N x) visited = []
>                                 | otherwise = [(move N x, ds ++ [N])]
>                    south (x,ds) | hasWall maze x S || elem (move S x) visited = []
>                                 | otherwise = [(move S x, ds ++ [S])]
>                    east (x,ds)  | hasWall maze x E || elem (move E x) visited  = []
>                                 | otherwise  = [(move E x, ds ++ [E])]
>                    west (x,ds)  | hasWall maze x W || elem (move W x) visited  = []
>                                 | otherwise  = [(move W x, ds ++ [W])]

ghci> solveMaze2 smallMaze (0,0) (3,2)
[E,N,E,S,E,N,N]
(0.01 secs, 131,096 bytes)
ghci> solveMaze2 largeMaze (0,0) (22,21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,
N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,
N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,
S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,
W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,
N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,
N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.11 secs, 12,183,504 bytes)
ghci> solveMaze2 impossibleMaze (0,0) (2,2)
*** Exception: A solution cannot be found for this maze
ghci> solveMaze2 emptyMaze (0,0) (3,3)
[N,N,N,E,E,E]
(0.01 secs, 272,552 bytes)

-- After MyMaze addition --

ghci> solveMaze2 smallMaze (0,0) (3,2)
[E,N,E,S,E,N,N]
(0.00 secs, 134,744 bytes)
ghci> solveMaze2 largeMaze (0,0) (22,21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,
N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,
N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,
S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,
W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,
N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,
N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.02 secs, 11,799,056 bytes)

In this new representation, the algorithm was much faster in its execution, however its memory usage was comparable with the previous representation.

Generic Maze:
ghci> drawMaze maze1
+--+--+--+--+--+--+--+--+--+
|           |              |  
+  +  +--+  +--+  +--+--+--+
|  |  |        |           |  
+  +  +--+--+--+--+--+--+  +
|  |        |              |  
+  +  +--+  +  +  +--+--+--+
|  |  |  |  |  |           |  
+  +  +  +  +  +--+--+--+  +
|  |  |     |  |           |  
+  +  +--+--+--+  +  +--+  +
|  |        |     |  |  |  |  
+  +--+--+  +  +--+  +  +  +
|           |  |  |     |  |  
+--+--+--+  +  +  +--+--+  +
|              |           |  
+--+--+--+--+--+--+--+--+--+
ghci> solveMaze2 maze1 (0,0) (8,7)
[E,E,E,E,N,N,E,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E]
(0.00 secs, 589,624 bytes)

Spiral Maze:
ghci> drawMaze spiralMaze
+--+--+--+--+--+--+--+--+--+--+--+--+
|                                   |
+  +--+--+--+--+--+--+--+--+--+--+--+
|  |                                |
+  +  +--+--+--+--+--+--+--+--+--+  +
|  |  |                          |  |
+  +  +  +--+--+--+--+--+--+--+  +  +
|  |  |  |                    |  |  |
+  +  +  +  +--+--+--+--+--+  +  +  +
|  |  |  |  |              |  |  |  |
+  +  +  +  +  +--+--+--+  +  +  +  +
|  |  |  |  |           |  |  |  |  |
+  +  +  +  +--+--+--+  +  +  +  +  +
|  |  |  |              |  |  |  |  |
+  +  +  +--+--+--+--+--+  +  +  +  +
|  |  |                    |  |  |  |
+  +  +--+--+--+--+--+--+--+  +  +  +
|  |                          |  |  |
+  +--+--+--+--+--+--+--+--+--+  +  +
|                                |  |
+--+--+--+--+--+--+--+--+--+--+--+  +
|                                   |
+--+--+--+--+--+--+--+--+--+--+--+--+
ghci> solveMaze2 spiralMaze (0,0) (11,10)
[E,E,E,E,E,E,E,E,E,E,E,N,N,N,N,N,N,N,N,N,W,W,W,W,W,W,W,W,W,W,S,S,S,S,S,S,S,E,E,E,E,E,E,E,E,N,N,N,N,N,W,W,W,W,W,W,S,S,S,E,E,E,E,N,W,W,W,N,E,E,E,E,S,S,S,W,W,W,W,W,W,N,N,N,N,N,E,E,E,E,E,E,E,E,S,S,S,S,S,S,S,W,W,W,W,W,W,W,W,W,W,N,N,N,N,N,N,N,N,N,E,E,E,E,E,E,E,E,E,E,E]

Worm Maze:
ghci> drawMaze (wormMaze (11,12))
+--+--+--+--+--+--+--+--+--+--+--+
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                             |  |
+  +--+--+--+--+--+--+--+--+  +  +
|                          |  |  |
+--+--+--+--+--+--+--+--+  +  +  +
|                       |  |  |  |
+  +--+--+--+--+--+--+  +  +  +  +
|                    |  |  |  |  |
+--+--+--+--+--+--+  +  +  +  +  +
|                 |  |  |  |  |  |
+  +--+--+--+--+  +  +  +  +  +  +
|              |  |  |  |  |  |  |
+--+--+--+--+  +  +  +  +  +  +  +
|           |  |  |  |  |  |  |  |
+  +--+--+  +  +  +  +  +  +  +  +
|        |  |  |  |  |  |  |  |  |
+--+--+  +  +  +  +  +  +  +  +  +
|     |  |  |  |  |  |  |  |  |  |
+  +  +  +  +  +  +  +  +  +  +  +
|  |     |     |     |     |     |
+--+--+--+--+--+--+--+--+--+--+--+
ghci> solveMaze2 (wormMaze (11,12)) (0,0) (10,11)
[N,E,S,E,N,N,W,W,N,E,E,E,S,S,S,E,N,N,N,N,W,W,W,W,N,E,E,E,E,E,S,S,S,S,S,E,N,N,N,N,N,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,S,S,S,E,N,N,N,N,N,N,N,N,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,S,S,S,S,S,S,S,S,S,E,N,N,N,N,N,N,N,N,N,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E]
ghci> drawMaze (zigzagMaze (15,16))
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                 |           |           |  |
+--+--+  +--+  +--+  +--+  +--+  +--+  +--+  +
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+  +--+  +--+  +--+  +--+  +--+  +--+  +--+--+
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+--+--+  +--+  +--+  +--+  +--+  +--+  +--+  +
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+  +--+  +--+  +--+  +--+  +--+  +--+  +--+--+
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+--+--+  +--+  +--+  +--+  +--+  +--+  +--+  +
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+  +--+  +--+  +--+  +--+  +--+  +--+  +--+--+
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+--+--+  +--+  +--+  +--+  +--+  +--+  +--+  +
|     |     |     |     |     |     |     |  |
+  +  +--+  +--+  +--+  +--+  +--+  +--+  +  +
|  |     |     |     |     |     |     |     |
+  +--+  +--+  +--+  +--+  +--+  +--+  +--+  +
|  |           |           |           |     |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
ghci> solveMaze2 (zigzagMaze (15,16)) (0,0) (14,15)
[N,N,E,S,E,S,E,E,N,W,N,W,N,W,N,W,N,N,E,S,E,S,E,S,E,S,E,S,E,S,E,E,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,N,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,E,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,N,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,N,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,E,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,S,E,N,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,W,N,E,E,S,E,S,E,S,E,S,E,S,E,S,E,N,N,W,N,W,N,W,N,W,N,E,E,S,E,S,E,N,N]


EXERCISE 7

--Without MyMazeBT.lhs--
ghci> solveMaze2 largeMaze (0,0) (22,21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.03 secs, 12,482,488 bytes)
--With MyMazeBT.lhs--
ghci> solveMaze2 largeMaze (0,0) (22,21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.02 secs, 15,631,200 bytes)



======================================================================

Some test mazes.  In both cases, the task is to find a path from the bottom
left corner to the top right.

First a small one

> smallMaze :: Maze
> smallMaze = 
>   let walls = [((0,0), N), ((2,2), E), ((2,1),E), ((1,0),E), 
>                ((1,2), E), ((1,1), N)]
>   in makeMaze (4,3) walls

Now a large one.  Define a function to produce a run of walls:

> run (x,y) n E = [((x,y+i),E) | i <- [0..n-1]]
> run (x,y) n N = [((x+i,y),N) | i <- [0..n-1]]

And here is the maze.

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

And now an impossible maze

> impossibleMaze :: Maze
> impossibleMaze =
>   let walls = [((0,1), E), ((1,0),N), ((1,2), E), ((2,1), N)]
>   in makeMaze (3,3) walls

And now an empty maze

> emptyMaze = makeMaze (4,4) []

Some mazes of my own devising:

> maze1 :: Maze 
> maze1 =
>   let walls = 
>         run (0,0) 3 N ++ run (3,1) 5 E ++ run (0,2) 5 E ++ run (1,1) 2 N ++ run (4,0) 2 E ++ 
>         run (5,1) 1 N ++ run (5,1) 1 E ++ run (6,0) 2 N ++ run (7,1) 2 E ++ run (7,2) 1 N ++ 
>         run (6,2) 1 E ++ run (5,2) 1 E ++ run (4,3) 2 E ++ run (4,5) 3 N ++ run (1,6) 1 E ++ 
>         run (1,3) 2 E ++ run (2,4) 1 E ++ run (2,5) 2 N ++ run (1,3) 2 E ++ run (2,2) 2 N ++ 
>         run (2,4) 1 N ++ run (5,3) 3 N ++ run (6,4) 3 N ++ run (3,7) 1 E ++ run (2,6) 1 N ++
>         run (4,6) 1 N ++ run (4,6) 1 E ++ run (6,6) 3 N ++ run (4,2) 1 N ++ run (7,5) 1 N
>   in makeMaze (9,8) walls


> createSpiral :: (Int, Int) -> [Wall]
> createSpiral (x,y) = 
>  [((i,j), E) | i <- [0..(div (x-1) 2 -1)], j <- [0..(y)], j < (y-1) - i, j > i + 1] ++ 
>  [((i,j), W) | i <- [(div x 2 + 1)..(x-1)], j <- [0..(y)], j > (x-1) - i, j < i + (y-x-1)] ++
>  [((i,j), S) | i <- [0..(x)], j <- [(div y 2 + 1)..(y-1)], j > (y-1) - i, j > i + (y-x-1)] ++
>  [((i,j), N) | i <- [0..(x)], j <- [0..(div (y-1) 2 -1)], j < i + 1, j < (x-1) - i]

> spiralMaze :: (Int,Int) -> Maze
> spiralMaze (a,b) = makeMaze (a,b) (createSpiral (a,b))


> createWorm :: (Int, Int) -> [Wall] 
> createWorm (x,y) = -- Works best when x and y are the same
>  [((i,0), W) | i <- [0..(min x y - 1)], i `mod` 2 == 1] ++
>  [((0,j), S) | j <- [0..(min x y - 1)], j `mod` 2 == 0] ++
>  [((i,j), E) | i <- [1..(x)], j <- [1..(y)], (j-1) <= (i-1)] ++
>  [((i,j), N) | i <- [1..(x)], j <- [1..(y)], (j-1) >= (i-1)]

> wormMaze :: (Int, Int) -> Maze
> wormMaze (a,b) = makeMaze (a,b) (createWorm (a,b))


> createZigzag :: (Int, Int) -> [Wall]
> createZigzag (x,y) = 
>  [((i,j), S) | i <- [1..(x-2)], j <- [1..(y-1)], mod (i+j) 2 == 0] ++
>  [((i,j), W) | i <- [1..(x)], j <- [1..(y-2)], mod (i+j) 2 == 0] ++
>  [((i,0), E) | i <- [0..(x)], mod i 4 == 0] ++
>  [((0,j), N) | j <- [0..(x)], mod (j-2) 4 == 0] ++
>  [((i,y-1), W) | i <- [(3 - mod y 4)..(x-1)], mod (i + mod y 4 - 2) 4 == 0] ++
>  [((x-1,j), N) | j <- [(mod x 4)..(y-1)], mod (j - (if mod x 4 < 2 then (2 - mod x 4) else (3 - mod x 4))) 4 == 0]
>  where rightRow | mod x 4 == 0 = [((x-1,j), N) | j <- [2..(y-1)], mod (j - 2) 4 == 0]
>                 | mod x 4 == 1 = [((x-1,j), N) | j <- [1..(y-1)], mod (j - 1) 4 == 0]
>                 | mod x 4 == 2 = [((x-1,j), N) | j <- [2..(y-1)], mod (j + 1) 4 == 0]
>                 | mod x 4 == 3 = [((x-1,j), N) | j <- [2..(y-1)], mod j 4 == 0]

> zigzagMaze :: (Int, Int) -> Maze
> zigzagMaze (a,b) = makeMaze (a,b) (createZigzag (a,b))
