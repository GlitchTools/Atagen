# blender vertice shuffler 2
# rob mac 2014


# settings
# amount of vertices to shuffle
count = 50
# how severely do we mosh them? 0.10-1.00
pain = .15

import bpy
import bmesh
from random import randrange

me = bpy.context.object.data
vlen = 0

bm = bmesh.new()   # create an empty BMesh
bm.from_mesh(me)   # fill it in from a Mesh
vlen = len(bm.verts)

for x in range(1, count):
    swappos = randrange(1, vlen)
    swap = bm.verts[swappos].co
    dir = randrange(1, 2)
    if swap.z > 0.01 and swap.x > -0.005 and swap.x < 0.005:
#      print(swap.x)
      if dir > 1:
        np = int((vlen-swappos)*pain)  
        move = randrange(int(np/2), np)
        bm.verts[swappos+move].co = swap      
      else:
        np = -(swappos-vlen)
        np = int(np*pain)
        if np < 2:
            np = 2
        move = randrange(int(np/2), np)
        bm.verts[swappos-move].co = swap      

# Finish up, write the bmesh back to the mesh
bm.to_mesh(me)
bm.free()  # free and prevent further access
