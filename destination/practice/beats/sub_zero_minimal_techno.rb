use_bpm 125
#sub-zero-minimal-techno

["instruments","shaderview","experiments", "log","samples","dsp","monkey"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
set_volume! 0.8
#https://www.attackmagazine.com/technique/beat-dissected/sub-zero-minimal-techno
_=nil
live_loop :drums do
  k1 = Tech[/Drum_Hits/,/kick/,4]
  h1,h2 = Tech[/Drum_Hits/,/hat/,0],Tech[/Drum_Hits/,/hat/,1]
  s1,s2 = Tech[/Drum_Hits/,/snare/,2], Tech[/Drum_Hits/,/snare/,3]
  p1 = Tech[/Drum_Hits/,/perc/,2]
  v1 = Tech[/vocal/,10]
  r1 = Tech[/cymbal/,8]
  kick = (ring *%w{k1 _ _ _})
  hat = (ring *%w{_ _ h1 _
                  _ _ h1 {path:h1,amp:0.25}
                  _ _ h1 _
                  _ _ h1 _})
  puts hat
  hat2 = (ring *%w{_ _ h2 _})
  snare = (ring *%w{_ _ _ _  s1 _ _ _})
  snare2 = (ring *%w{_ _ _ _ _ _ _ _
                     _ _ _ _ _ _ _ s2})
  voice = (ring *%w{ _ _ _ _ _ _ _ _
                     _ _ _ _ _ _ v1 _})
  cymbal = (ring *%w{_ _ _ _ _ _ _ _
                     _ _ _ _ _ _ _ _
                     _ _ _ _ _ _ _ _
                     _ _ _ r1 _ _ _ _})
  perc = (ring *%w{_ _ _ p1
                   _ _ p1 _
                   _ p1 _ _
                   _ _ _ _})
  (4).times{
    tick
    #smp eval(kick.look)
    smp eval(hat.look)
    #smp eval(hat2.look)
    #smp eval(snare.look)
    #smp eval(snare2.look)
    #smp eval(voice.look), finish: 0.05
    #smp eval(cymbal.look), finish: 0.1
    #smp eval(perc.look)
    sleep 1/4.0
  }
end
