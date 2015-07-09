# blender vertice shuffler 1
# rob mac 2014

# settings:
# z coord threshold for selective moshes
thresh = -500
# lowest/highest run thresholds for main loop
loopslo = 1
loopshi = 5
# chance, as a fraction, of some action occuring
# eg. n2d3 = 2/3 = 66% chance per vertex per loop
numer = 1
denom = 10
# vertice number to start on
str = 0


import bpy
import bmesh
from random import randrange

me = bpy.context.object.data

bm = bmesh.new()   # create an empty BMesh
bm.from_mesh(me)   # fill it in from a Mesh
bm.verts.ensure_lookup_table()
swap = bm.verts[str]
for x in range(1, randrange(loopslo+1, loopshi+1)):
    func = 1
    for v in bm.verts:
        if v.co.z > thresh:
            check = randrange(1,denom+1)
            if check < numer:
                if func:
                  swap.co = v.co
                  func = 0
                else:
                  v.co = swap.co
                  func = 1

# Finish up, write the bmesh back to the mesh
bm.to_mesh(me)
bm.free()  # free and prevent further access
