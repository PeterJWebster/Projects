> module MyMazeBT (
>   Maze,
>   makeMaze, -- :: Size -> [Wall] -> Maze
>   hasWall,  -- :: Maze -> Place -> Direction -> Bool
>   sizeOf    -- :: Maze -> Size
> )
> where

> import Geography

We will represent a maze by its size and a list of its walls.

> data BTree = Empty | Fork BTree Place BTree deriving Show
> data Maze = AMaze Size BTree BTree BTree BTree

> makeTree :: [Place] -> BTree
> makeTree [] = Empty
> makeTree [x] = Fork Empty x Empty
> makeTree xs = Fork (makeTree firstHalf) (head secondHalf) (makeTree (tail secondHalf)) 
>   where (firstHalf,secondHalf) = splitAt (length xs `div` 2) xs

> search :: Place -> BTree -> Bool
> search (i,j) Empty = False
> search (i,j) (Fork left (k,l) right) | i > k  = search (i,j) right
>                                      | i == k = if j > l then search (i,j) right else (if j == l then True else search (i,j) left)
>                                      | i < k  = search (i,j) left

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
>  in AMaze (x,y) (makeTree (msort [(i,j) | ((i,j), N) <- allWalls])) 
>                 (makeTree (msort [(i,j) | ((i,j), S) <- allWalls])) 
>                 (makeTree (msort [(i,j) | ((i,j), E) <- allWalls])) 
>                 (makeTree (msort [(i,j) | ((i,j), W) <- allWalls]))

> msort :: [Place] -> [Place]
> msort [] = []
> msort [x] = [x]
> msort xs = merge (msort ls) (msort rs)
>      where (ls,rs) = splitAt ((length xs) `div` 2) xs
> merge :: [Place] -> [Place] -> [Place]
> merge [] ys = ys
> merge xs [] = xs
> merge xs ys | fst (head xs) < fst (head ys) = (head xs) : merge (tail xs) ys
>             | fst (head xs) == fst (head ys) = if snd (head xs) <= snd (head ys) then (head xs) : merge (tail xs) ys else (head ys) : merge xs (tail ys)
>             | otherwise = (head ys) : merge xs (tail ys)


The following function "reflects" a wall; i.e. gives the representation as
seen from the other side; for example, reflect ((3,4), N) = ((3,5),S)

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

The following function tests whether the maze includes a wall in a particular
direction from a particular place:

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (AMaze _ norths souths easts wests) pos d | d == N = search pos norths
>                                                   | d == S = search pos souths
>                                                   | d == E = search pos easts
>                                                   | d == W = search pos wests

The following function returns the size of a maze:

> sizeOf :: Maze -> Size
> sizeOf (AMaze size _ _ _ _) = size
