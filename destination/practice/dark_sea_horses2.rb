#use_bpm 60
["samples","instruments","experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
_=nil
live_loop :warm do
  c = _
  co = ring(
    [:FS2, :E3, :A3],
    [:A2,  :Cs3, :E3],
    [:Cs2,  :E3, :Gs3, :B4],
    [:D2,  :Fs3, :A3,  :CS3],
    [:E2,  :Gs3, :B3,  :D3]
  ).tick
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    with_transpose -12 do
      synth :prophet, note: co[0], cutoff: 55, decay: 4.0, amp: 2.0, attack: 0.5
      synth :dsaw,    note: co[0], cutoff: 50, decay: 4.0, amp: 2.0, attack: 1.0
    end
  end
  synth :gpa, note: co[-1], decay: 4.0
  sleep 1

  with_fx :lpf, cutoff: 80 do
    with_synth :"dark_sea_horn" do
      c  = play co[0], cutoff: 80, decay: 8.0#, noise1: 0
      c2 = play co[1], cutoff: 60, decay: 7.0#, noise1: 0
      c2 = play co[2], cutoff: 60, decay: 7.0#,# noise1: 0
    end
  end
  sleep 1
  6.times{
    sleep 1;
    candidate = scale(:fs3, :minor_pentatonic).shuffle.choose
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      with_transpose 12 do
        i_hollow(candidate, amp: ramp( *range( 0.1, 8.0, 0.1)).tick(:s2lwower))
      end

    end
    control c, note: candidate,
    noise1: ring( 0,2).tick(:n1), noise2: ring(0).tick(:n2),
    max_delay: rand
  }
end

live_loop :light do
  use_synth :dark_sea_horn
  play ring( :Cs4, :D4), cutoff: 80, decay: 16.0, noise1: 0, amp: 2.0, noise1_freq: 200
  with_synth :hollow do
    play ring( :Cs4, :D4), cutoff: 50, decay: 16.0, noise1: 0, amp: 2.0, noise1_freq: 200
  end
  sleep 16
end

live_loop :voices do
  with_fx :lpf do
    with_fx :bitcrusher, mix: 0.2, sample_rate: 1500 do
      #sample Words[/tothink/,[0,0]].tick(:sample), cutoff: 120, amp: 4.0,
      # finish: 0.125
    end
  end
  sleep 32
end

live_loop :hollow do
  #synth :hollow, note: ring( :E3, :E4).tick, amp: 0.2, decay: 2.0
  sleep 8
end

live_loop :perc do
  with_fx :bpf,centre: :FS4 do
    with_fx :distortion, mix: 0.5 do
      #sample CineAmbi[/loop/,/perc/,0], beat_stretch: 16, cutoff: 80, amp: 1.0
    end
  end
  sleep 16
end


live_loop :drums do
  # sample Frag[/kick/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5
  sample Mountain[/subkick/,[0,0,0,0]].tick(:sample), cutoff: 90, amp: 0.5
  with_fx :slicer, phase: ring( 0.5, 1.0).tick, smooth: 0.1 do
    sample CineAmbi[/kick/,0], cutoff: 45, amp: 1.0
    # sample CineAmbi[/loop/,/f#/,2], amp: 2.0
  end
  # sample CineAmbi[/loop/,/B_/,15], amp: 0.4
  #  sample CineAmbi[/GrowlingBass/,2], amp: 8.0, rpitch: -5
  # sleep 1
  #  sleep 1
  sleep 4
end
