["shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}

shader(:shader, "nil.glsl")
shader(:uniform, "iCellCount",  2.0)
shader(:uniform, "iCellMotion", 0.001)

shader(:uniform, "iSpaceMotion", 0.1)
shader(:uniform, "iMesh",       0.0)
shader(:mesh, 0.0)
