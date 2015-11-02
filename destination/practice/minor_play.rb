["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

#-------------------Activity log-------------------------------->

shader :shader, "voc.glsl", "bits.vert", "points", rrand(100,2000)
#shader :vertex, "sphere.vert","points", 500
#shader :iColor, 10.0
#shader :iZoom, 0.2
shader :iZoom, 0.9
shader :iStarLight, 1.0
shader :iStar, 2.0
shader :iCells, 1.0

#shader :vertex, "/Users/josephwilk/Workspace/c++/of_v0.8.4_osx_release/apps/myApps/shaderview/bin/data/sphere.vert",
#  :points, 1200

set_volume! 1.0

live_loop :go do
  #sample Ether[/f#/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5
  sleep 8
  #  sample_and_sleep Sink[/f#/].tick
end

shader :iWave, 1.0

live_loop :beat do
  sync :synth
  shader :decay, :iBeat, 1.0, 0.001
  #sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 50, amp: 2.0
  #  sample Sink[/f#m/].tick, amp: 0.5
  #  with_fx(:slicer, phase: 0.25*2, probability: 0) do
  #  end
  #  with_fx(:slicer, phase: 0.25) do
  #sample Dust[/beats/,2], beat_stretch: 8.0
  #sample Dust[/beats/,9], beat_stretch: 8.0, amp: 0.1
  # end

  #with_fx(:slicer, phase: 0.25*4, probability: 0) do
  #sample Dust[/f#m/,1], cutoff: 130, amp: 0.5
  #end

  #with_fx(:slicer, phase: 0.0, probability: 0) do
  #sample Dust[/am/,0], cutoff: 135, amp: 0.5
  #end

  with_fx(:echo, decay: 8.0, mix: 1.0, phase: 1.0) do
    # sample Dust[/whale/].tick, cutoff: 50
  end

  #sample Dust[/f#m/,0], cutoff: 40, amp: 0.5, beat_stretch: 8.0
  sleep 8
end
_=nil

live_loop :super do
  x= nil
  #synth :blade, note: :FS3, decay: 8.0,
  #  cutoff: 65
  with_fx(:slicer, phase: 0.25, probability: 0) do
    with_synth :supersaw do
      #      x = play chord(:Fs3, :m), note_slide: 0.05, cutoff: 65, decay: 8.0
    end
  end
  8.times{
    sleep 1.0;
    # control x, note: chord(:Fs4, :m).choose}
  }
end

live_loop :synth do
  use_synth :hollow
  with_fx(:reverb, room: 1.0, mix: 0.4, damp: 0.5) do |r_fx|
    notes = (ring
             (ring :Fs3, :a3, :Cs3),
             (ring :D3, :Fs3, :A3),
             (ring :E3, :Gs3, :B3),
             #(ring :Fs3, :a3, :Cs3)
             ).tick(:chords)

    with_transpose(-12) do
      synth :dsaw,
        note: notes.look,
        cutoff: 55, amp: 0.2, decay: rrand(7.0,8.2),
        release: 0.01, sustain: 0.01, detune: 24
    end

    with_transpose(12) do
      with_synth :fm do
        play notes.first, cutoff: 80, amp: 0.6
      end
    end

    32.times{
      #      with_fx(:slicer, phase: 0.25/2.0, probability: 0.5) do
      play notes.tick,
      wave: 0, decay: 0.01,
      attack: 0.01, sustain: 0.1, amp: 2.0, cutoff: 135
      sleep 0.25
      #     end
    }
  end
end
