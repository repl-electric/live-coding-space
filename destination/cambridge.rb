["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
# ____ ____ _  _ ___  ____ _ ___  ____ ____                         \:o/
# |    |__| |\/| |__] |__/ | |  \ | __ |___    π=-    π=-   π=-      █
# |___ |  | |  | |__] |  \ | |__/ |__] |___   π=-   π=-   π=-      .||.   
_ = nil#.go
bar = 1.0
use_bpm 60
set_volume! 3.0
@polyrhythm = [2,3]

live_loop :intro do
sync :foo
with_fx :distortion, mix: (knit 0.0,3,1.0,1).tick(:v) do
#  sample Ether.all(/F#/)[2], amp: 3.0+rrand(0.0,0.2), rate: -1.0
end
end

live_loop :bass do |m_idx|;with_fx :level, amp: 0.5 do
   sync :foo
    case (m_idx%8)
    when 0,4,2,6
#    sample :drum_bass_soft, amp: 0.5, start: 0.01
     sample Mountain["SubKick_01"], amp: 3.5+rrand(0.0,0.2), rate: rrand(0.9,1.0)
#      sample Mountain.all("kick")[4], amp: 0.5
    when 1,3,4,5
    when 7
#       sample :drum_snare_soft, amp: 0.2, start: 0.01
      sample Mountain["Impact_0#{(stretch (1..5).to_a, 16).tick(:b)}"], rate: -1.0,amp: 0.2
    end
    m_idx+=1
end;end

live_loop :ghost do;with_fx :level, amp: 0.2 do
sync :foo
comment do
2.times{sleep bar/2.0;sample knit(Mountain["MICROPERC",7],8, Mountain["stick",5],2).tick(:asd), 
        amp: rrand(0.55,0.6), attack: rrand(0.0,0.05)}
end
2.times{sleep bar/2.0;sample knit(Mountain["microperc",6],2).tick(:asd), 
        amp: rrand(0.55,0.6), attack: rrand(0.0,0.05)}
end;end

live_loop :beats do;with_fx :level, amp: 0.5 do
    sync :foo
    #sample Mountain["B_BrokenCres_01_SP"]
    sample Mountain["Cracklin_01"], rate: 0.95, amp: 0.2
    sleep sample_duration(Mountain["Cracklin_01"], rate: 0.95)
end;end

live_loop :foo do;with_fx :level, amp: 0.5 do
    density(@polyrhythm.sort.first) do
      sample Mountain["pebble",0], start: rrand(0.0,0.01), rate: -1.0, amp: 0.4


comment do
      with_synth(:dark_ambience){play (knit 
       "Fs4",1,_,1,"Fs2",6,
       "B4", 1, "Ds5",1, "Bs2",6,
       "Ds5",1,_,1,"Ds2",6
).tick(:a), cutoff: 80, amp: 0.5, release: 2*bar, attack: 0.01}
end

##       "Fs4",1,_,1,"Fs2",6,
#         "Fs3",1
#).tick(:a), cutoff: 80, amp: 0.5, release: 2*bar, attack: 0.01}

      #play (knit "Fs2",2).tick(:a), amp: 1.5, release: bar/6.0, attack: 0.1
      with_fx (knit :echo,1,:none, 7).tick(:o), decay: bar*8 do 
       #play deg_seq(*%w{FS3 1_1_}).tick(:asd), release: bar*0.01, attack: 0.01; 
      end
sleep bar
end;end;end

#with_fx :reverb do
#with_fx :distortion do
#with_fx :slicer, phase: bar*8.0,smooth: 5.0, mix: 0.0 do
live_loop :bar, autocue: false do;with_fx :level, amp: 1.0 do
with_fx :reverb, room: 1.0, mix: 1.0, damp: 0.1 do

    sync :foo
    density(@polyrhythm.sort.last) do
      sample Mountain["HarshClash"], start: rrand(0.0,0.01), amp: 0.55
      with_fx (knit :none,7, :echo, (ring 7).tick(:d)).tick(:r2), mix: 0.8, phase: bar/2.0 do


#1   2   3   4  5   6       7
#F♯, G♯, A♯, B, C♯, D♯, and E♯

#3-notes   = 18

n = (knit
#:As3,8, :B3, 8, :Cs4,2,
#:As3,8, :B3, 9, :Cs4,1,
#:As3,8, :B3, 8, :Fs3,1, :Cs4,1,

:Fs3,8, :Es3, 8, :Cs4,2,
:Fs3,8, :As3, 9, :Cs4,1,
:Fs3,8, :B3,  8, :Fs3,1, :Cs4,1,

:Fs3,8, :Es3, 8, :Cs4,2,
:Fs3,8, :As3, 9, :Cs4,1,
:Fs3,8, :B3,  8, :Fs3,1, :Cs4,1,

#:Fs3,8, :Es3, 8, :Gs3,2,
#:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :As3, 8, :Fs3,1, :Fs3,1,

#:Fs3,8, :Es3, 8, :Gs3,2,
#:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :B3, 8, :Gs3,1, :Gs3,1,

#:B3,2, :As3,1,  :Gs3,1, :Fs3,1, :Cs4,2, :Ds4, 2, :Cs4, 8, :Ds4, 2

).tick(:r1)
        n = (knit :Fs3,8, :Es3, 8, :Cs4, 2,
                  :Fs3,8, :As3, 8, :Cs4, 2,
                  :Fs3,8, :B3,  8, :Fs3,1, :Cs4,1,

#:Fs3,8, :Es3, 8, :Gs3,2,
#:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :As3, 8, :Fs3,1, :Fs3,1,

#:Fs3,8, :Es3, 8, :Gs3,2,
##:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :B3, 8, :Gs3,1, :Gs3,1,



).tick(:asdasd)

#n = (stretch chord(:Fs3, 'M'),8, chord(:Es3, 'm'),8,
#             chord(:As3, 'sus4'),8, chord(:Cs4, 'M'),2).tick("asdasd")


#n = (stretch chord(:Fs3, 'sus4'),2, chord(:Fs3, 'M'),2,
#             chord(:Cs3, 'sus4'),2, chord(:Cs3, 'M'),2
#)

with_transpose((ring 0).tick(:tock)){
        with_synth(:dark_ambience){play n, pan: (Math.sin(vt*13)/1.5), amp: 1.8 ,decay: 0.1} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)
}
        with_synth(:beep){play n, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.20, 0.15,0.15, 0.15).tick(:sdf) ,decay: 0.0 + rrand(0.1,0.2), release: 0.3} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)

with_transpose((ring -12,12).tick(:toack)){
        #with_synth(:prophet){play n, cutoff: 80, amp: 0.3, attack: 0.1, release: 0.5, pan: (Math.sin(vt*13)/1.5), decay: 0.1} #,release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)       
}
        sleep bar
puts n
        if n == degree(5, :FS3, :major)
          cue :start
        end
      end
    end

end;end;end
#end;
#end

live_loop :bassline do |idx|;with_fx :level, amp: 0.2 do
with_fx :reverb, mix: 0.2, damp: 0.3 do;with_fx :distortion, mix: 0.9 do
    #play (knit "Fs3",1).tick(:a), amp: 1.5, release: 2*bar, attack: 0.01
    4.times{sync :foo}
    notes = (knit _,3, "Fs1" ,1, "B1", 2)
    n = notes.tick(:a)
    with_transpose(0) do
    with_synth :beep do
#      play n, amp: 0.5, release: 2*bar, attack: 0.01, cutoff: 60
    end;end
    #use_synth :prophet
    with_transpose(12) do
 #     play (knit _,1, _,2, "Fs1" ,1, "B1", 2).tick(:a), cutoff: 60, amp: 0.5, release: (knit 2.0*bar,5,2.0*bar,1).tick(:sd), attack: 0.01
    end

#comment do
notes = (knit 
#"Fs2",2, "B2",2 ,"Cs2",2,              
#"Fs2",2, "B2",1, "As2",1, "Gs2",1, "Cs2",1, 
"Cs3",2, "Gs2",2, "As2",2,
"Cs3",2, "Gs2",2, "As2",2,
"B2",2,  "Gs2",2, "As2",2,
).tick(:a)
 play notes, amp: 0.8, release: (knit 3.9*bar,5, bar*4.1,1).tick(:lpo), attack: 0.01 
 with_transpose(-12) do
   with_synth(:beep){play notes, amp: 0.5, release: 4*bar, attack: 0.01, cutoff: 60}
 end;end;end
#end 

#                5        1        4   
#1   2   3   4  5   6       7
#F♯, G♯, A♯, B, C♯, D♯, and E♯

#(I, ii, iii, IV, V, vi, viio)

# iii
#chord(:As3, "m")    #A#  -  C#  -   E#
#chord(:As3, 'sus4')

#1         7        5
#:Fs3,8, :Es3, 8, :Cs4,2,
##:Fs3,8, :As3, 9, :Cs4,1,
#:Fs3,8, :B3, 8,  :Fs3,1, :Cs4,1,


# ├─ (ring :Fs, :B, :Cs)  sus4 F#  1 4 5
# └─ (ring :Gs, :Cs, :Ds) sus4 Gs  2 5 6
# ├─ (ring :As, :Cs, :F)
# ├─ (ring :B, :E, :Fs)
# ├─ (ring :Cs, :Fs, :Gs)
# ├─ (ring :Ds, :Gs, :As)
# ├─ (ring :F, :As, :C)

#  3       4       5     
#:As3,8, :B3, 8, :Cs4,2,
#:As3,8, :B3, 9, :Cs4,1,
#:As3,8, :B3, 8, :Fs3,1, :Cs4,1,

# I

#  1       -7       5     
#:Fs3,8, :Es3, 8, :Cs4,2,
#:Fs3,8, :As3, 9, :Cs4,1,
#:Fs3,8, :B3, 8,  :Fs3,1, :Cs4,1,

#I

#1         -7       2
#:Fs3,8, :Es3, 8, :Gs3,2,
#:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :As3, 8, :Fs3,1, :Fs3,1,

#I

#1         -7       2
#:Fs3,8, :Es3, 8, :Gs3,2,
#:Fs3,8, :As3, 9, :Gs3,1,
#:Fs3,8, :B3, 8, :Gs3,1, :Gs3,1,

    #play degree((knit 5,4,6,4,7,1).tick(:r1), :FS3, :major), amp: 1.0, release: 2*bar, attack: 0.01 if idx % 4 ==0
    idx+=1
end;end


live_loop :highlight do |idx|;with_fx :level, amp: 0.5 do
    n = chord_seq(*%w{Cs3 7 Fs3 M B3 M7})
    with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: (knit bar*8, 3, bar*6,1).tick(:q) do
      with_synth :hollow do
        2.times{sync :foo}
        play n.tick(:f),  attack: 0.5, amp: 2.0
      end
      1.times{sync :foo}
      play n.tick(:f), attack: 0.01, amp: 0.4, release: ring(2.0,0.5).tick(:r3)
      1.times{sync :foo}
    end
end;end


live_loop :high do;with_fx :level, amp: 1.0 do
    2.times{sync :start}
    #with_fx :echo, decay: 16 do  
      sample (knit Mountain["microperc_06"],3,Mountain["microperc_07"],1).tick(:s)
    #end

end;end

