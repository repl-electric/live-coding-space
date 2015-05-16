["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}
# ____ ____ _  _ ___  ____ _ ___  ____ ____
# |    |__| |\/| |__] |__/ | |  \ | __ |___
# |___ |  | |  | |__] |  \ | |__/ |__] |___
_ = nil
bar = 1.0
use_bpm 60

@polyrhythm = [2,3]

live_loop :bass do |m_idx|;with_fx :level, amp: 0.0 do
  sync :foo
  case (m_idx%8)
  when 0
    sample Ambi["SubKick_01"], amp: 3.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
  when 4
    sample Ambi["Impact_0#{(stretch (1..5).to_a, 8).tick(:b)}"], amp: 0.2
  end
  m_idx+=1
end;end

live_loop :beats do;with_fx :level, amp: 0.0 do
  sync :foo
  #sample Ambi["B_BrokenCres_01_SP"]
  sample Ambi["Cracklin_01"], rate: 0.95, amp: 0.2
end;end

live_loop :texture do;with_fx :level, amp: 0.0 do
  sync :foo
  with_fx :bitcrusher do
    sample Chill["am_pad80_warmth_B"], rate: pitch_ratio(note(:B2) - note((ring :FS2, :B2).tick(:d))),
      amp: 0.1
  end
  sleep sample_duration Chill["am_pad80_warmth_B.wav"], rate: pitch_ratio(note(:B2) - note(:FS2))
end;end

live_loop :foo do;with_fx :level, amp: 0.0 do
  density(@polyrhythm.sort.first) { play degree(5,:FS3, :major); sleep bar }
end;end

live_loop :bar, autocue: false do;with_fx :level, amp: 0.0 do
  sync :foo
  density(@polyrhythm.sort.last) do
    with_fx (knit :none,7, :echo, 1).tick(:r2), mix: 0.8, phase: bar/2.0  do
      n = degree((knit 3,8,4,8,5,2).tick(:r1), :FS3, :major)
      play n, pan: (Math.sin(vt*13)/1.5)
      sleep bar
      if n == degree(5, :FS3, :major)
        cue :start
      end
    end
  end
end;end

live_loop :bassline do |idx|;with_fx :level, amp: 0.0 do
  play (knit "Fs3",1).tick(:a), amp: 1.5, release: 2*bar, attack: 0.01
  2.times{sync :foo}
  with_synth :fm do
    play (knit "Cs2",3, "FS2" ,1, "B2", 2).tick(:a), amp: 2.5, release: 2*bar, attack: 0.01
  end
  #play degree((knit 5,4,6,4,7,1).tick(:r1), :FS3, :major), amp: 1.0, release: 2*bar, attack: 0.01 if idx % 4 ==0
  idx+=1
end;end

live_loop :highlight do |idx|;with_fx :level, amp: 0.0 do
  n = chord_seq(*%w{Cs4 7  Fs4 M  B3 M7})
  with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: (knit bar*8, 3, bar*6,1).tick(:q) do
    with_synth :hollow do
      2.times{sync :foo}
      play n.tick(:f),  attack: 0.5, amp: 0.7
    end
    1.times{sync :foo}
    play n.tick(:f), attack: 0.01, amp: 0.4, release: ring(2.0,0.5).tick(:r3)
    1.times{sync :foo}
  end
end;end

live_loop :high do;with_fx :level, amp: 0.0 do
  2.times{sync :start}
  sample (knit Ambi["MicroPerc_06"],3,Ambi["MicroPerc_07"],1).tick(:s)
end;end