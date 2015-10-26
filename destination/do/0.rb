["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

#This is a very experimental version of Sonic Pi
#This annoying flicker :(


shader :iCells, 0.0
shader :iStars, 0.0
shader :iStarLight, 0.0
shader :iStarsMotion, 0.0


set_volume! 5.0

with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
  live_loop :test do
    shader :iBeat, rand*0.1
    use_random_seed 300
    #sample Mountain[/bow/, /F#/,0], cutoff: 90, amp: 0.5
    #sample Corrupt[/guitar/,/F#m/].shuffle.tick(:sample), cutoff: rrand(60,70), amp: 0.5, beat_stretch: 8
    sleep 8
  end
end

live_loop :something_else do
  sync :test
  #with_fx(:slicer, phase: 0.25*2, probability: 0) do
    with_fx(:echo, decay: 1.0, mix: 1.0, phase: 0.25) do
      sample Fraz[/kick/,0], cutoff: 70, amp: 0.5
    end
  #end

  with_fx(:flanger, feedback: 0.5) do
#    sample Corrupt[/Organic/, 0], cutoff: 75, amp: 0.5, beat_stretch: 16.0
    sleep 16/4.0
  end

 # sample Corrupt[/clap/,[0,0]].tick(:sample), cutoff: 30, amp: 0.5, beat_stretch: 16/4.0
  #Very very buggy build :Odd.

  with_fx(:slicer, mix: 0.5, probability: 0.5) do
    #sample Corrupt[/Organic/, 0], cutoff: 75, amp: 0.5, beat_stretch: 16.0, rate: -1.0
    sleep 16/4.0
  end
  #with_fx(:slicer, mix: 0.5) do
  #sample Corrupt[/Organic/, 0], cutoff: 75, amp: 0.5, beat_stretch: 16.0*2.0
  #end
  #end
end

live_loop :movement2 do
  #sync :test
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|

    if spread(7,11).tick
      #     sample Dust[/hat/,Range.new(1, 4)].tick(:sample), cutoff: 65, amp: 0.4, pan: 0.25
    end
    if spread(3,7).look
      #      sample Dust[/hat/,Range.new(1, 2)].tick(:sample), cutoff: 65, amp: 0.4, pan: -0.25
    end
  end

  #MAchine is hurting.....
  sleep 0.25*8
end

live_loop :something_something_something do
  sync :test
  #sample Corrupt[/keys/,1], cutoff: (ramp 70, 120).tick(:antoher), amp: 0.5, beat_stretch: 16.0
  sleep 16
end

live_loop :some_one_shots do
  #Random here, I'm taking the entire sample set and just grabbing one.
  #See what happens
  #sample Corrupt[//,1], cutoff: 60, amp: 0.2, beat_stretch: 16
  sleep 16
end

live_loop :coils do
  shader :iInvert, [1.0,0.0].choose
  with_fx(:bitcrusher, mix: 0.1, bits: 8, sample_rate: 20000) do
    sample Ether[/interference/, /Fm/, 1], cutoff: 70, amp: 0.8, beat_stretch: 16
  end

  sleep 16
end

shader :iStarMotion, 0.0

live_loop :corrupted_bass do
  with_fx(:flanger, feedback: 0.5) do
    with_fx(:reverb, room: 0.9, mix: 1.0, damp: 0.5, damp_slide: 1.0) do |r_fx|
      #      sample Sop[/f#/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5, beat_stretch: 8
      8.times{sleep 1 ; control r_fx, damp: rand}
    end
  end
end

live_loop :bass2 do
#  use_random_seed (ring 300, 400).tick
  with_fx(:reverb, reps: 4) do
  with_synth :hollow do
    #Tooooo loud
    n = scale(:Fs3, :minor_pentatonic, num_octaves: 3).take(3).shuffle
16.times {
    hollow n, cutoff: 70, amp: 0.5, decay: 0.25
    sleep 0.5
}
end
  end
end

live_loop :bass do
  use_random_seed (ring 300, 400).tick
  with_synth :dark_sea_horn do
    #Tooooo loud
    n = scale(:Fs2, :minor_pentatonic, num_octaves: 3).take(2).shuffle
    play n, cutoff: 40, amp: 0.2, decay: 8.1
  end
  sleep 8
end
