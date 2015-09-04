["shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}

shader(:shader, "nil.glsl")
shader(:uniform, "iCellCount",  2.0)
shader(:uniform, "iCellMotion", 0.1)

shader(:uniform, "iSpaceMotion", 0.0)
shader(:uniform, "iSpaceWeight", 0.02)
shader(:uniform, "iMesh",       0.0)
shader(:mesh, 0.0)
