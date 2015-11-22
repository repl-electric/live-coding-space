uncomment do
  live_loop :looper do
    sync :organ

    sample ChillD[/drum_loop/, 10], beat_stretch: 8.0, amp: 0.98, cutoff: 85
    sample Frag[/kick/,0], amp: 0.5, cutoff: 80
    sleep 1.0
    sample Frag[/kick/,1], amp: 0.5,  cutoff: 90

    sleep 2.0
    sleep 1.0
    sample Frag[/kick/,0], amp: 0.5, cutoff: 80
    sleep 2.0
    sample Frag[/kick/,1], amp: 0.5,  cutoff: 80
    sleep 8-6
  end

  live_loop :hat do
    sleep 0.25/2.0
    #sample Frag[/hat/,0], amp: 1.0, cutoff: rrand(80,100)
  end

  live_loop :clapper do
    #sync :looper
    6.times{
      sleep 1
      #      sample Ambi[/clap/,3], amp: 1.0

    }
    sleep 2

  end
end