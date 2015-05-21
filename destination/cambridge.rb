["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
# ____ ____ _  _ ___  ____ _ ___  ____ ____                         \:o/
# |    |__| |\/| |__] |__/ | |  \ | __ |___    π=-    π=-   π=-      █
# |___ |  | |  | |__] |  \ | |__/ |__] |___   π=-   π=-   π=-      .||.   
_ = nil
bar = 1.0
use_bpm 60
set_volume! 3.0
@polyrhythm = [2,3]

live_loop :bass do |m_idx|;with_fx :level, amp: 1.0 do
    sync :foo
    case (m_idx%8)
    when 0,4,2, 6
      sample Mountain["SubKick_01"], amp: 3.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
    when 1,3,4,5
    when 7
      sample Mountain["Impact_0#{(stretch (1..5).to_a, 16).tick(:b)}"], rate: -1.0,amp: 0.2
    end
    m_idx+=1
end;end

live_loop :beats do;with_fx :level, amp: 1.0 do
    sync :foo
    #sample Mountain["B_BrokenCres_01_SP"]
    sample Mountain["Cracklin_01"], rate: 0.95, amp: 0.2
    sleep sample_duration(Mountain["Cracklin_01"], rate: 0.95)
end;end

live_loop :texture do;with_fx :level, amp: 0.0 do
    sync :foo
    with_fx :bitcrusher do
      sample Ambi["am_pad80_warmth_B"], rate: pitch_ratio(note(:B2) - note((ring :FS2, :B2).tick(:d))),
        amp: 0.2
    end
    sleep sample_duration Ambi["am_pad80_warmth_B.wav"], rate: pitch_ratio(note(:B2) - note(:FS2))
end;end

live_loop :foo do;with_fx :level, amp: 1.0 do
    density(@polyrhythm.sort.first) do
      sample Mountain["pebble"], start: rrand(0.0,0.01), rate: -1.0

      with_synth(:dark_ambience){play (knit "Fs3",1,"Fs2",1).tick(:a), cutoff: 80, amp: 1.5, release: 2*bar, attack: 0.01}
      play (knit "Fs3",1).tick(:a), amp: 1.5, release: 2*bar, attack: 0.01
      play deg_seq(*%w{F3 1}); sleep bar
end;end;end

live_loop :bar, autocue: false do;with_fx :level, amp: 1.0 do
    sync :foo
    density(@polyrhythm.sort.last) do
      sample Mountain["HarshClash"], start: rrand(0.0,0.01)

      with_fx (knit :none,7, :echo, 7).tick(:r2), mix: 0.8, phase: bar/2.0  do
        n = degree((knit 3,8,4,8,5,2).tick(:r1), :FS3, :major)
        play n, pan: (Math.sin(vt*13)/1.5)
        sleep bar
        if n == degree(5, :FS3, :major)
          cue :start
        end
      end
    end
end;end

live_loop :bassline do |idx|;with_fx :level, amp: 1.0 do
    #play (knit "Fs3",1).tick(:a), amp: 1.5, release: 2*bar, attack: 0.01
    2.times{sync :foo}
    with_synth :beep do
      play (knit "Cs2",3, "FS1" ,1, "B1", 2).tick(:a), amp: 2.5, release: 2*bar, attack: 0.01, cutoff: 60
    end
    play (knit "Cs2",3, "FS2" ,1, "B2", 2).tick(:a), amp: 0.5, release: 2*bar, attack: 0.01

    #play degree((knit 5,4,6,4,7,1).tick(:r1), :FS3, :major), amp: 1.0, release: 2*bar, attack: 0.01 if idx % 4 ==0
    idx+=1
end;end

live_loop :highlight do |idx|;with_fx :level, amp: 1.0 do
    n = chord_seq(*%w{Cs3 7  Fs3 M  B3 M7})
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

live_loop :highlight2 do |idx|;with_fx :level, amp: 0.0 do
    n = chord_seq(*%w{Cs4 7  Fs4 M  B4 M7})
        16.times{sync :foo}

with_synth :pretty_bell do
      with_fx :echo, decay: 6*bar do
      with_fx :flanger, mix: 0.5, depth: 12, feedback: 0.1, phase_offset: bar/2.0 do
      with_synth(:tri){play :Fs1}
      play (chord :Fs3, 'M').tick(:p),
            pan: (Math.sin(vt*13)), amp: 0.2, attack: 0.2
      sleep (ring bar).tick(:v)
end
end;end
end;end

live_loop :high do;with_fx :level, amp: 1.0 do
    2.times{sync :start}
    sample (knit Mountain["MicroPerc_06"],3,Mountain["MicroPerc_07"],1).tick(:s)
end;end
