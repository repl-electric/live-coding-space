use_bpm 90

live_loop :rwa do
  use_synth :prophet
  use_synth_defaults detune: 12, cutoff: 50, detune: 12, amp: 2.0
  #sample Fraz[/kick/,1], amp: 4.0

  notes = (knit :FS1, 1, :Fs1, 2, :A1, 1)

  play notes.tick, attack: 0.01, decay: 2.0

  #sample Fraz[/loop/,/Dm/,0]
  #sample Fraz[/loop/,/Dm/,1]

  sample Fraz[/loop/, /C#m/, 0]

  #sample Fraz[/loop/,3], amp: 1.0, beat_stretch: 8.0
  #sample Fraz[/loop/,3], amp: 2.0, beat_stretch: 4.0
  sleep 1
  #  sample Fraz[/kick/,0], amp: 1.0
  play notes.tick, attack: 0.01, decay: 0.1
  sleep 0.5
  #play notes.tick, attack: 0.01, decay: 0.1
  # sample Fraz[/kick/,1], amp: 1.0
  play notes.tick, attack: 0.01, decay: 0.1
  sleep 2

  #sample Fraz[/loop/,3], amp: 2.0, beat_stretch: 4.0

  play notes.tick, attack: 0.01, decay: 1.0
  #sample Fraz[/kick/,0], amp: 1.0
  sleep 1.5
  #sample Fraz[/kick/,1], amp: 1.0
  sleep 3.0
end

live_loop :another do
  #sample Fraz[/loop/,0], amp: 0.5, beat_stretch: 4.0
  sleep 4
end

live_loop :bass do
  sync :rwa
  #sample Fraz[/coil/, /c#m/, 1], amp: 2.0

  use_synth :dark_sea_horn
  with_fx(:reverb, room: 1.0, mix: 1.0, damp: 0.5) do |r_fx|
    #synth :hollow, note: chord(:E3,'7').tick, decay: 8.0, detune: 12, amp: 1.5
    #synth :prophet, note: :E2, cutoff: 60,
    #  decay: 8.0, detune: 12, amp: 5.5
  end
  with_fx(:slicer, phase: 0.25*2, probability: 0, wave: 0) do
    play (ring :A2, :D2, :E2).tick(:a), attack: 0.01, decay: 8.0, amp: 1.0, cutoff: 100
  end
  sleep 8
end
_=nil
live_loop :apeg do
  #sync :rwa
  #use_random_seed 300
  with_fx(:reverb, room: 1.0, mix: 0.5, damp: 0.5) do |r_fx|
    use_synth :twang
    #use_synth :plucked
    with_fx(:slicer, phase: 0.5, probability: 0) do
      play (ring (chord(:Fs2, 'm11')+[_]).choose).tick, release: 0.01, amp: 1.0
    end
    sleep 0.125*4.0
  end
end
