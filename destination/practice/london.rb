_ = nil
bar = 1.0
def bowed_s(name, *args)
  s = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/Bowed\ Notes/*_BowedGuitarNote_01_SP.wav"]
puts s
  s.sort!
  sample (if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end), *args
end
def live(name, opts={}, &block)
  idx = 0
  amp = if(opts[:amp])
    opts[:amp]
  else
    1
  end
  x = lambda{|idx|
    with_fx :level, amp: amp do
      block.(idx)
  end}
  live_loop name do |idx|
    x.(idx)
  end
end

@polyrhythm = [2,3]

live_loop :bass do
  sync :foo
  sample "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One Shots/Kick/SubKick_01_SP.wav", amp: 3.0
  sample "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/Bass/135_C_SwellBass_01_SP.wav",  rate: pitch_ratio(note(:Cs3) - note(:C3)), amp: 0.1
  bowed_s "F#", rate: 0.5, amp: 0.1
end

live_loop :foo do
  #sample "/Users/josephwilk/Dropbox/repl-electric/samples/Guitar\ Tails/92_Eb_Plucked_01_SP.wav", rate: pitch_ratio(note(:Fs2) - note(:Eb3))
  density(@polyrhythm.sort.first) { play degree(1, :FS3, :major); sleep bar }
end

live_loop :bar, autocue: false do
  sync :foo
  density(@polyrhythm.sort.last) do
  with_fx (knit :none,7, :echo, 1).tick(:r2), mix: 0.8, phase: bar/2.0  do
      n = degree((knit 3,8,4,8,5,2).tick(:r1), :FS3, :major)
    play n; sleep bar 
    if n == degree(5, :FS3, :major)
      cue :start  
    end
end
end
end

live_loop :high do
 2.times{sync :start}
 sample (knit "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One\ Shots/Perc/MicroPerc_06_SP.wav",3,
              "/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/One\ Shots/Perc/MicroPerc_07_SP.wav",1).tick(:s)

end
