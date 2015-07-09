

bl_info = {
 "name": "Mesh Waves",
 "author": "rob mac",
 "version": (0, 5),
 "blender": (2, 7, 3),
 "location": "3d View Object Menu->Mesh Waves",
 "description": "Applies various sinusoidal functions to mesh.",
 "category": "Mesh"}


import bpy
import bmesh
from bpy.types import Operator  
from bpy.props import FloatProperty, BoolProperty
from math import sin, cos, pi


class Waves(bpy.types.Operator):  
 """Mesh Waves"""  
 bl_idname = "object.meshwave"  
 bl_label = "Mesh Waves"  
 bl_options = {'REGISTER', 'UNDO'}  
  
 pSinFreq = FloatProperty(  
   name="Sine Frequency",
   description="Sine Frequency",
   default=10.00,
   min=0.00,
   options={'ANIMATABLE'},  
   )  
 pCosFreq = FloatProperty(  
   name="Cosine Frequency",  
   description="Cosine Frequency",  
   default=10.00,
   min=0.00,
   options={'ANIMATABLE'},  
   )  
 pSinAmp = FloatProperty(  
   name="Sine Amplitude",  
   description="Sine Amplitude",  
   default=0.20,
   min=-2.00,
   max=2.00,
   options={'ANIMATABLE'},  
   )  
 pCosAmp = FloatProperty(  
   name="Cosine Amplitude",  
   description="Cosine Amplitude",  
   default=0.20,
   min=-2.00,
   max=2.00,
   options={'ANIMATABLE'},  
   )
 pOffset = FloatProperty(
   name="Wave Offset",  
   description="Wave Offset",  
   default=0.00,
   min=0.00,
   max=360.00,
   options={'ANIMATABLE'},  
   )

 XbyX = BoolProperty(
    name = "X*X",
    default=False,
    description = "X*X"
   )    
 XbyY = BoolProperty(
    name = "X*Y",
    default=False,
    description = "X*Y"
   )    
 XbyZ = BoolProperty(
   name = "X*Z",
   default=False,
   description = "X*Z"
   )    
 YbyY = BoolProperty(
   name = "Y*Y",
   default=False,
   description = "Y*Y"
   )    
 YbyX = BoolProperty(
   name = "Y*X",
   default=False,
   description = "Y*X"
   )    
 YbyZ = BoolProperty(
   name = "Y*Z",
   default=False,
   description = "Y*Z"
   )    
 ZbyX = BoolProperty(
   name = "Z*X",
   default=False,
   description = "Z*X"
   )    
 ZbyY = BoolProperty(
   name = "Z*Y",
   default=False,
   description = "Z*Y"
   )    
 ZbyZ = BoolProperty(
   name = "Z*Z",
   default=False,
   description = "Z*Z"
   )    


  
 def execute(self, context):  
  me = bpy.context.object.data
  bm = bmesh.new() 
  bm.from_mesh(me) 
  bm.verts.ensure_lookup_table()
  vlen = len(bm.verts)
  AmpSin = self.pSinAmp
  AmpCos = self.pCosAmp
  FreqSin = self.pSinFreq
  FreqCos = self.pCosFreq
  Offset = self.pOffset / 180
  min = [None for x in range(3)]
  max = [None for x in range(3)]
  for v in bm.verts:
    if min[0] is None:
        min[0] = v.co.x
    elif v.co.x < min[0]:
        min[0] = v.co.x
    if min[1] is None:
        min[1] = v.co.y
    elif v.co.y < min[1]:
        min[1] = v.co.y
    if min[2] is None:
        min[2] = v.co.z
    elif v.co.z < min[2]:
        min[2] = v.co.z
    if max[0] is None:
        max[0] = v.co.x
    elif v.co.x > max[0]:
        max[0] = v.co.x
    if max[1] is None:
        max[1] = v.co.y
    elif v.co.y > max[1]:
        max[1] = v.co.y
    if max[2] is None:
        max[2] = v.co.z
    elif v.co.z > max[2]:
        max[2] = v.co.z
    dis = [max[x]-min[x] for x in range(len(min))]

  for v in bm.verts:
    if self.XbyX:
     v.co.x += AmpSin*sin((2*pi*FreqSin*(v.co.x - min[0])/dis[0])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.x - min[0])/dis[0]))
    if self.XbyY:
     v.co.x += AmpSin*sin((2*pi*FreqSin*(v.co.y - min[1])/dis[1])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.y - min[1])/dis[1]))
    if self.XbyZ:    
     v.co.x += AmpSin*sin((2*pi*FreqSin*(v.co.z - min[2])/dis[2])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.z - min[2])/dis[2]))
    if self.YbyX:
     v.co.y += AmpSin*sin((2*pi*FreqSin*(v.co.x - min[0])/dis[0])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.x - min[0])/dis[0]))
    if self.YbyY:
     v.co.y += AmpSin*sin((2*pi*FreqSin*(v.co.y - min[1])/dis[1])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.y - min[1])/dis[1]))
    if self.YbyZ:
     v.co.y += AmpSin*sin((2*pi*FreqSin*(v.co.z - min[2])/dis[2])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.z - min[2])/dis[2]))
    if self.ZbyX:
     v.co.z += AmpSin*sin((2*pi*FreqSin*(v.co.x - min[0])/dis[0])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.x - min[0])/dis[0]))
    if self.ZbyY:
     v.co.z += AmpSin*sin((2*pi*FreqSin*(v.co.y - min[1])/dis[1])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.y - min[1])/dis[1]))
    if self.ZbyZ:
     v.co.z += AmpSin*sin((2*pi*FreqSin*(v.co.z - min[2])/dis[2])) \
     + AmpCos*cos((2*pi*FreqCos*(v.co.z - min[2])/dis[2]))

  bm.to_mesh(me)
  bm.free()
  return {'FINISHED'}  
  
 @classmethod  
 def poll(cls, context):  
  ob = context.active_object  
  return ob is not None and ob.mode == 'OBJECT'  
  
def add_object_button(self, context):  
 self.layout.operator(  
  Waves.bl_idname,  
  text=Waves.__doc__,  
  icon='PLUGIN')  
  
def register():  
 bpy.utils.register_class(Waves)  
 bpy.types.VIEW3D_MT_object.append(add_object_button)  
  
def unregister():  
 bpy.utils.unregister_class(Waves)  
      
if __name__ == "__main__":  
 register()  
