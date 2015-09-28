["log","experiments", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
f=false;t=true;_=nil
# Just messing around with SonicPi.
# Nothing polished, just learning the music and code thing.
@hold      = (ring *%w{2  0 0 0 0 0 0 0 0 0   0  1  0   1 0  0}.map(&:to_i))
@transpose = (ring *%w{-5 0 0 0 -5 0 0 0 0 -12 0 -2 -12 -2 0 -12}.map(&:to_i))
@velocity  = (ring *%w{100 100 49 100 118 78 110 114 100 127 100 127 115 100 100 100}.map(&:to_i))

live_loop :frozen? do
  synth :supersaw, note: chord(:Fs4, 'm').shuffle.choose, cutoff: 40, decay: 8, amp: 1.0

  #  with_fx(:lpf, cutoff: (ramp *(range 40, 130, 10)).tick(:cut3) ) do
  with_fx(:reverb, reps: 4, room: 1.0, mix: 0.9){
    use_random_seed 300#(ring 300, 200, 100).tick(:rand?)
    notes = scale(:Fs3, :minor_pentatonic, num_octaves: 2).drop(0).take(3).shuffle
    #notes = chord(:Cs3, 'm9').take(3)
    with_synth(:hollow){
      synth :supersaw, note: chord(:Cs4, 'm9').shuffle.choose, cutoff: 45,
      release:(ring 0.5, 1.0).tick(:r)
      16.times do
        with_transpose(@transpose.tick(:t)+12){
          play notes.tick, cutoff: rrand(80,100), cutoff:130,
          amp: 1.0 + rand,
          release: 0.125, release: @hold.tick(:release)+0.02,
          attack: 0.001 #/@velocity.tick(:attack)
        }
        blade_note = notes.choose
        with_fx(:distortion, mix: 0.2) do
          with_synth(:fm){
            with_transpose(@transpose.look(:t)){
              play (knit blade_note,1,_,1).tick(:bl), amp: 0.5, env_curv: 4,
              release: 0.2,
              attack: 0.01,
              cutoff: rrand(100,130)
            }
          }
        end
        #Maybe some bass?

        with_transpose(-24){
          with_synth(:dsaw){
            play (knit blade_note,1, :r, 63).tick(:bassline), attack: 0.3, cutoff: 60, amp: 0.4*rand, release: 2, decay: 8.0,
            detune: 12
          }
          with_synth(:prophet){
            play (knit blade_note,1, :r, 63).look(:bassline), attack: 0.35, cutoff: 60, amp: 0.4*rand, release: 2, decay: 8.0
          }
        }
        sleep 0.125*2
      end
    }
  }
  # end
end

live_loop :texture do
  sync :frozen?
end

live_loop :ending do
  # sample_and_sleep Mountain[/cracklin/,0], rate: 0.9, amp: 0.0
end

live_loop :drums do
  #  with_fx(:echo, phase: 0.125, decay: 4.0) do
  #    with_fx(:slicer, phase: 0.25) do
  sample Dust[/kick/, [3,2,4,5]].tick(:kick), amp: 3.5, cutoff: 135
  #   end
  # end
  sleep 1
  sample Dust[/clap/,1], amp: 0.2, cutoff: rrand(90,100)
  sleep 1
end

live_loop :oneshot do

  sleep 32
end

with_fx(:reverb, room: 0.8, mix: 0.7) do
  live_loop :hats do
    sleep 0.25
    sample Dust[/hat/,[1,1]].tick(:s),   cutoff: (range 60, 100).tick(:c),  amp: 0.65  if spread(7,11).tick
    sample Dust[/hat/,[0,1]].tick(:s2),  cutoff: (range 100, 60).tick(:c2), amp: 0.65 if spread(3,8).look

    if (knit f, 28, t,1,  f, 3).tick(:open)
      sample Scape[/brush/, 1], amp: 0.1 + rand, cutoff: rrand(100,120)
    end

  end
end
live_loop :chords do
  with_fx(:hpf, cutoff: 100, cutoff_slide: 2) do |fx|
    use_synth :dark_ambience
    notes = (ring
             chord(:Fs3,'sus4'),
             chord(:A3, 'M'),
             chord(:D3, 'M'),
             chord(:Cs3, "m9")).tick
    play notes, release: 2.0, attack: 0.5, decay: 8.2, detune1: 24, detune2: -24, amp: 0.1
    8.times{sleep 1; control fx, cutoff: (ring 80, 100).tick(:cutoff)}
  end
end

live_loop :texture2 do
  with_fx(:bitcrusher, mix: 0.08, sample_rate: 8*2000) do
    #sample Dust[/f#/, 10], amp: 0.5, cutoff: 80
  end
  sleep 8
end

live_loop :detroit do
  sample_and_sleep ChillD[/Detroit/, (ring /F#1/).tick], amp: 0.2

                                      end
