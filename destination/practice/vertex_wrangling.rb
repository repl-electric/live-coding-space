["samples","instruments","experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
#@vertex=1
shader :iWave, 0.4
shader :shader, "wave.glsl", "bits.vert", "points", 10000
shader :iScale, 0.0001
#shader :iMotion, 0.1
#shader :iDistort, 0.0
shader :iMotion, 0.01
#@opening = 0.0
#@vertex = 0¯
shader :iStarLight, 0.4
#@opening = 0.00001
shader :iScale, 1.9
shader :iDistort, 0.8

live_loop :beat do
  #  shader :decay, :iMotion, 0.01

  shader :decay, :iBeat, 8.0
  shader :"vertex-settings", "points", [@vertex,10000].min
  puts "Vertices active:#{@vertex}"
  #shader :iDistort, [@opening,1.0].min
  puts "Distortion:#{@opening}"
  @opening += 0.01
  @vertex += 1000
  #shader :iScale, 0.09
  #  shader :iScale, 0.89
  #sample ChillD[/drum_loop/,[9,9]].tick(:sample), cutoff: 80, amp: 0.5, beat_stretch: 8

  sleep 8
  #  shader :decay, :iBeat, 0.2
  #sample CineAmbi[/kick/,9], cutoff: 100, amp: 1.0
end

live_loop :sop do
  sleep 32
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    #    sample Fraz[/coil/,/c#/,0], cutoff: 80, amp: 0.8
  end
  sleep 32
end

#@distort ||=0
live_loop :light do
  sync :warm
  with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
    with_synth :hollow do
      #      @distort += 0.001
      #     shader :iDistort, @distort

      #shader :iMotion, rrand(0.0,0.01)

      with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
        #    synth :prophet, note: ring(:Cs2, :E2).tick, amp: 0.5, decay: 2, cutoff: 45
        #    synth :dsaw, note: ring(:Cs2, :E2).tick, amp: 0.5, decay: 2, cutoff: 45

      end

      #   play ring(:B3).tick, amp: 2.0, decay: 4
      sleep 2
      #      play ring(:CS4, :A3).tick(:r1), amp: 2.0, decay: 4
      #     play ring(:CS3, :A2).tick(:r2), amp: 2.0, decay: 4
      sleep 2
      #    play ring(:E3, :E3, :Fs3).tick(:r3), amp: 2.0, decay: 8
    end
  end
end

live_loop :beat do
  #  sync :warm
  sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 100, amp: 1.0
  sleep 2

  with_fx :distortion do
    with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
      sample Fraz[/snap/,[0,0]].tick(:sample), cutoff: 70, amp: 1.0
    end
  end
  #  sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 90, amp: 1.0
  sleep 2
end

live_loop :hats do
  #  sync :warm
  if spread(3,8).tick(:s)
    sample Ether[/hat/,[0,0]].tick(:sample), cutoff: rrand(80,100), amp: 0.1
  end

  if spread(7,11).tick(:s)
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      #      sample Ether[/noise/,0..4].tick(:sample), cutoff: rrand(80,100), amp: 0.1

    end

  end
  sleep 0.25
end

live_loop :warm do
  with_fx :lpf do
    s,s2 = nil
    #  @vertex += 10
    #   shader :"vertex-settings", "points", [@vertex, 10000].min
    # puts "Vertices: #{@vertex}"

    at do
      ring( 4,2).tick(:time).times do
        #      with_fx :reverb, mix: 1.0, room: 1. do
        #          with_fx :distortion, mix: 0.2 do
        with_synth :gpa do
          play ring(_
                    #:A4,:A3,:B4,
                    #:CS4,:CS3,:Fs4
                    ).tick, wave: 7, amp: 1.0
        end
        #         end
        #     end
        sleep 0.25
      end
    end

    s3 = play ring(:Fs3).tick(:n1), cutoff: 70, amp: 0.2, decay: 8.1

    chords = ring( chord(:Cs3)).tick(:chpro)
    with_synth :dark_sea_horn do
      #ring( :Fs3, :As2, :CS3)
      s = play ring(:Fs2).tick(:n1), cutoff: 70, amp: 0.5, decay: 8.1
      s = play ring(:Fs1).tick(:n1), cutoff: 70, amp: 0.5, decay: 8.1
    end

    with_synth :dark_sea_horn do
      #ring( :E3, :Cs3, :E3)
      s2 = play ring(:Cs3).tick(:n), cutoff: 70, amp: 0.5, decay: 8.1
    end
    s3 = play ring(:E3).tick(:n), cutoff: 70, amp: 0.5, decay: 8.1

    with_synth :dark_sea_horn do
      #ring( :E3, :Cs3, :E3)
      s2 = play ring(:A3).tick(:n), cutoff: 70, amp: 0.5, decay: 8.1
    end

    sleep 2
    5.times{
      #  shader :iDistort, @opening
      #  @opening += 0.0001
      # control s, note: scale(:FS2, :minor_pentatonic).shuffle.choose
      sleep 1
    }
  end
end
