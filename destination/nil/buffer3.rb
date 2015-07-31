["shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}

shader(:shader, "nil.glsl") 
shader(:uniform, "iCellCount",  1.0)
shader(:uniform, "iCellMotion", 0.0)
shader(:uniform, "iMesh",       1.0)
shader(:mesh, 1.0)
