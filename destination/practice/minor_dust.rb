# (i,    iio,   III, iv, v,   VI, VII)
# F♯, G♯, A, B, C♯, D,  E. 
f=false;t=true

live_loop :frozen? do
  with_fx(:lpf, cutoff: (ramp *(range 30, 130,5)).tick(:kf)) do
    with_fx :reverb, room: 1, reps: 4 do
      use_random_seed 200
      notes = (scale :fs3, :minor_pentatonic, num_octaves: 4).take(4)
      16.times{
        with_synth(:blade){
          play notes.choose, release: 0.1, amp: rand + 2.0, cutoff: rrand(70, 120)
        }
        with_synth(:hollow){
          with_transpose(-12) do
            play notes.choose, release: 0.11, amp: 0.8, cutoff: rrand(70, 120)
          end
        }
        sleep 0.125
      }
    end
  end
end

live_loop :collect! do
  with_fx(:hpf, cutoff: 110, cutoff_slide: 2, mix: 0.8) do |fx|
    use_synth :dark_ambience
    play (ring 
    (chord :Fs3, "sus4"),
    (chord :A3, "M"),
    (chord :D3, "M"),
    (chord :Cs3, "m9")).tick(:notes), 
    release: 4.0, attack: 0.5, amp: 4.0, decay: 8.3,
    detune1: 24, detune2: -24
    8.times{sleep 1.0 ; control fx, cutoff: (ring 100, 130).tick(:fx)}
  end
end

live_loop :slice do
  with_fx(:echo, phase: 0.25, mix: 0.5) do
    with_fx(:slicer, phase: 0.25, mix: 0.5){
      sample Dust[/F#m/,4], cutoff: (range 40, 80, 5).tick(:cutoff), pan: rdist(1)
    }
  end
  sleep 8
end
                
live_loop :push do
  with_fx(:echo, phase: 0.25) do
    with_fx(:slicer, phase: 0.125) do
      sample Dust[/kick/, [4,3,5,3]].tick, amp: 1.0, cutoff: 130
    end
  end
  sleep 2.0
end

with_fx(:reverb, mix: 0.46, room: 0.7) do
  live_loop :pop do
    sleep  0.125*1
    if spread(7,8).tick(:hat)
      sample Dust[/hat/,[12,10]].tick(:d), amp: 0.1+rand*0.2 , 
      pan: 0.025,
      cutoff: (range 80,110,10).tick(:r)
    end
    if spread(6,11).tick(:hat)
      sample Dust[/hat/,[10,10]].tick(:d), amp: 0.1+rand*0.2, 
      pan: -0.025,
      cutoff: (range 100,80,10).tick(:r2)
    end

    if (knit f, 29, t, 1, f, 2).tick(:hatz)
      #sample Dust[/hat/,14], amp: 1.0, rate: (ring 0.5, 1.0, 2.0, 1.5).tick
      sample Scape[/SoftBrushHat/,0], cutoff: 130, amp: rand+0.1
    end
  end
end
