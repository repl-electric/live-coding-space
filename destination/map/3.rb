_=nil
["log","experiments", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
shader(:texture, "tex16.png", 3)

live_loop :highlight do
  with_fx(:lpf, cutoff: 100) do
    16.times{sync :apeg}
    with_transpose(0) do
      i_deter(    deg_seq(%w{Fs4 1*3 1*5}).tick,
                  deg_seq(%w{Fs4 3   5}).stretch(3).tick, amp: 0.8*1,
                  damp_time: 0.25*1.0)
      shader("decaying-uniform", :iWave, 1.0, 0.01)
    end
  end
end

live_loop :apeg do
  with_fx(:lpf, cutoff: 130, mix: 0.0){
    root = (knit :Fs3, 16, :As3, 16, :Ds3, 16).tick(:notes)
    with_transpose(-24){
      with_synth(:dsaw){play (knit root,1, _, 15).tick(:bass), release: 1.5, decay: 2.5, amp: 0.8, cutoff: 60}
      with_synth(:prophet){play (knit root,1, _, 15).look(:bass), release: 1.5, decay: 2.0, amp: 0.5, cutoff: 60}
      if (knit root,1, _, 15).look(:bass)
        shader("decaying-uniform", :iBeat, 1.0, 0.001)
      end
    }
    sleep 0.25 * 1
  }
end

with_fx(:reverb, room: 1.0, mix: 1.0){ |r_fx|
  live_loop :chorus do
    #use_random_seed 300
    notes = (knit
             #    chord(:Fs3, "M")[1..-1], 7,  #F A C
             #   chord(:Fs3, 'maj9')[0..-1], 1,  #
             #  chord(:As3, 'M')[1..-1], 8,  # A C E
             # chord(:Ds3, "m")[1..-1], 8,  # D F A

             chord_degree(1, :fs3, :major)[1..-1], 8,
             chord_degree(3, :fs3, :major)[1..-1], 8,
             chord(:Ds3, "m")[1..-1], 8,

             chord(:Fs3, 'sus4')[1..-1], 8,
             chord(:As3, 'm+5')[1..-1], 8,
             chord(:Ds3, "m7")[1..-1], 8,   #D F A C

             chord(:Fs3, 'sus4')[1..-1], 8,
             chord(:As3, 'm+5')[1..-1], 8,

             chord(:Cs3, :M)[1..-1], 4,
             chord(:Cs3, :maj9)[1..-1],4


             )

    1.times{sync :apeg}
    with_synth(:hoover)do
      #play notes.tick(:h)[0], amp: 0.03
    end

    com = scale(:Fs3, :major_pentatonic, num_octaves: 3).drop(0).take(3).shuffle

    1.times{sync :apeg}
    with_synth(:zawa){play com.tick, cutoff: 40, attack: 0.01}
    with_synth(:hollow){
      4.times{control r_fx, damp: rrand(0.0,1.0) ; sleep 0.25/4.0}
      play notes.look(:h).to_a.shuffle.choose, amp: (knit 1.0,4, 0.0,4).tick(:amp),
      release: 0.5, decay: 1.0, cutoff: (ring rrand(60,105)).tick(:cut),
      res: (ring 0.97,0.99).tick(:xcut)
      puts note_inspect(notes.look(:h), "CHORD")


      if(notes.look(:h) == chord(:Ds3, "m7")[1..-1])
        cue :lovely
        #sample (knit Frag[/coils/, /F#/,0] ,1,   _,7).tick(:s)
        with_fx(:flanger){
          sample (knit "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/G#_HarmBow_01_SP.wav" ,1,   _,7,
                  "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/D#_BowedGuitarNote_01_SP.wav",1,_,7,
                  Mountain[/G#_BowedHarmSoft/,0],1,_,7
                  ).tick(:s), cutoff: 80, amp: 0.15*1
        }
        #   sample (knit Sop[/F#4/,/down/,1] ,1,   _,7).tick(:s)
      end
    }
  end
}
live_loop :sea do
  32.times{sync :apeg}
  synth :dark_ambience, note: (ring :Fs3, :Es3).tick, decay: 8.0, amp: 2.0, detune1: 24, detune2: 12
end

shader(:uniform, :iCells, 0.0)

live_loop :d do
  4.times{sync :apeg}
  with_fx(:echo, phase: 0.25, decay: 1) do
    with_fx(:slicer, phase: 0.125) do
      sample Mountain[/subkick/,1], cutoff: 100
    end
  end
  shader("decaying-uniform", "iKick", rand)
  4.times{sync :apeg}
  sample Mountain[/subkick/,0], cutoff: 100
  shader("decaying-uniform", "iKick", 1.0)
end

live_loop :hats do
  sync :apeg
  sample Frag[/hat/, Range.new(0, (ring 4, 6).tick(:inner))].tick, cutoff: rrand(70,90)
  shader("decaying-uniform", :iHit, 1.0)
end


shader(:uniform, "iStarLight", 0.5)

shader(:uniform, "iSpaceMotion", 0.05)
shader(:uniform, "iStarLight", 0.5)
shader(:uniform, "iFlyingSpeed", 0.0)
shader(:uniform, "iStars", 1.0)
