["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

#-------------------Activity log-------------------------------->

shader :shader, "/Users/josephwilk/Workspace/c++/of_v0.8.4_osx_release/apps/myApps/shaderview/bin/data/something.glsl"

set_volume! 0.5

#Live coding music and lights.
#Everything you *hear* is driven by this code.
#Everything you *see* is driven by code.

shader :iWave, 0.0
shader :iGlow, 0.0
shader :iColor, 1.0
shader :iZoom, 0.1

with_fx(:reverb, room: 1.0, mix: 0.9, damp: 0.0) do |r_fx|
  live_loop :warming_up do
    with_fx(:bitcrusher, mix: 0.01, bits: 8, sample_rate: 20000, cutoff: 40) do
      #      sample Corrupt[/guitar/,/fx/].shuffle.tick(:sample), cutoff: rrand(70,90), amp: 0.2, beat_stretch: 16
    end
    sleep 16
  end
end

live_loop :coils do
  with_fx(:reverb, room: 0.7, mix: 0.4, damp: 0.5) do |r_fx|
    #   sample Fraz[/coil/,/F#/,0], cutoff: 130, amp: 0.5
  end
  sleep 32
end

live_loop :interferance do
  #  sample Ether[/interference/,/F#m/,3], cutoff: 130, amp: 0.5
  sleep 8
end

with_fx(:reverb, room: 0.8, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :bows_over_the_water do
    #sample Mountain[/bow/, /F#/], cutoff: 65
    sleep 64
  end
end

live_loop :sop do
  with_fx(:reverb, room: 0.8, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx(:flanger, feedback: 0.8) do
      #      sample Sop[/F#/,[0,0]].tick(:sample), cutoff: rrand(60,75), amp: 0.5
    end
  end
  sleep 16
end

live_loop :something_is_missing________ do
  use_random_seed 200

  with_fx :reverb, room: 1.0, reps: 4 do
    notes = scale(:Fs4, :minor, num_octaves: 3).take(3).shuffle
    #    sample Corrupt[/f#m/,11..18].tick
    sync :waves
    16.times{
      with_synth :pretty_bell do
        play (knit notes.choose,2, _,2, notes.choose,4).tick(:n), cutoff: 70, amp: 0.0, decay: 0.1,
          detune: 24, release: (ring 0.05,0.1).tick(:r),
          attack: 0.01

        synth :dark_ambience,
          note: (knit notes.choose,1, _,3).tick(:dark),
          cutoff: 100,
          amp: 2.0,
          release: 1.0,
          attack: 2.0
      end
      sleep 0.25
    }
  end
end

live_loop :light do
  use_random_seed 300
  notes = [chord(:FS3, 'sus4'),
           chord(:FS3, 'sus2'),
           chord_degree(5, :fs3, :minor),
           chord(:Cs3, 'm7+5'),
           ].choose.shuffle
  4.times{
    i_hollow(notes, amp: 1.9, cutoff: rrand(55,60))
    sleep 4
  }
end

live_loop :waves do
  #sync :warming_up
  shader :iIt, rrand(5,40);
  shader :decay, :iBeat, 1.0, 0.001
  #sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 130, amp: 8.5

  with_fx(:echo, decay: 0.5, mix: 1.0, phase: 0.25) do
    #    with_fx(:slicer, phase: 0.25, probability: 0.01) do
    #    sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 75, amp: 0.5
    #  end
  end

  # with_fx :echo, phase: 0.25 do
  with_fx(:slicer, phase: 2.0 ,invert_wave: 0, smooth: 1.0) do
    sample Corrupt[/organic/, 10], amp: 1.0,    beat_stretch: 8/2.0
  end
  # end

  #  sample Corrupt[/organic/, 10], amp: 1.0, rate: 1.0, beat_stretch: 8/1.0

  sleep 8/2.0

  #  sample Fraz[/clap/,3], cutoff: 100


  with_fx(:slicer, decay: 0.25, mix: 1.0, phase: 0.5, probability: 0.5) do
    #  sample Corrupt[/organic/, 10], amp: 1.0, rate: -1.0, beat_stretch: 8/4.0
  end
end

live_loop :darkness_rising do
  #use_random_seed 300
  with_synth :dark_sea_horn do
    play scale(:Fs2, :minor_pentatonic,
               num_octaves: 1).take(2).shuffle.choose, cutoff: 55, amp: 0.35*0.0, decay: 8.1
  end
  sleep 8
end
