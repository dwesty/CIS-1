README
Authors: Kevin Yee, David West

Main_pa3.m
Main script for running code required for part 3. Takes in data and uses helper functions to find tip coordinates in body space for each frame. Outputs data to the folder '../PA-3 Output'. When running the program, if you want to change sample data by changing 'A-debug' in the main file. Input data is grabbed from PA-345 directory.

findClosestPtOnMesh(point,vertices,adjacencies)
Find the closest point on a mesh by iterating over the adjacency array. This may be improved by implementing a more efficient data structure

findClosestPtOnTri(pt,tri)
Finds the closes point on a triangle to another point in space.
pt: the column vector to project onto the plane
tri: the three column vector points that makeup the vertices of the triangle

findNearestNeighbor(pt,tree,index)
A work in progress. Uses tree search to find the nearest neighbor for the closest point on mesh algorithm.

getCoordinates(file,numCoords)
Parses mesh file to find vertex coordinates. Returns 3xN matrix where N is number of points and 3 is x,y,z.

getTriangles(file,numCoords)
Parses mesh file to find vertex coordinates of triangles. Returns 3xN matrix where N is number of triangles and 3 is x,y,z.

invTransformation(R,p)
Performs an inverse transformation of matrix with rotation and translation.

makeKdTree(pts, level, tree, index)
A work in progress. Forms KD-tree to be used in improved-efficiency 'closest point on mesh' algorithm.

projectOntoVector(origin,corner,point)
Projects point onto the line defined by corner and origin

ptCloudPtCloud(A,B)
Calculates the transformation from 3D point set A to 3D point set B. Both point sets must be inputted as 3-by-n matrices in the following form: [ x1;y1;z1, x2;y2;z2, x3;y3;z3, ...]
Resulting transformation follows pattern B = F*A

transform(transformation,point)
Perform a transformation on a point
transformation: 3x4 matrix where first 3 columns are 
rotation and fourth column is translation
point must be a column vector

