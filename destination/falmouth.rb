["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
# A B Cs D E Fs Gs A

use_bpm 60
_=nil
bar = 1.5

live_loop :clock do
  cue :whole; cue :half; cue :quarter
  sleep bar/4.0; cue :quarter
  sleep bar/4.0; cue :half; cue :quarter
  sleep bar/4.0; cue :quarter
  sleep bar/4.0
end

live_loop :back do; with_fx :level, amp: 0.2 do
  use_synth :tri
  sync :whole
  play degree(1, :A3, :major),attack: 0.21, amp: 0.7
  sync :half
  play degree(5, :A3, :major),attack: 0.1, release: 1.0
end;end

live_loop :doo do |d_idx|; with_fx :level, amp: 0.5 do |l_fx|
3.times{sync :whole}
with_fx :distortion do |d_fx|
with_fx (ring :echo).tick(:C), decay: (knit 8,3, 10,1).tick(:A) do
play (knit chord(:D4, 'sus4'),3,
           chord_degree(1, :D4, :major),1).tick(:B) , attack: 0.01, release: 0.5
if (d_idx % 4) == 3
  control d_fx, mix: 0.5
  #control l_fx, amp: 1.0
  sync :whole
else
  #control l_fx, amp: 0.8
end
end;end;end
d_idx +=1
end

live_loop :back2 do with_fx :level, amp: 0.0 do
play (knit chord(:A3, 'sus4'),8,
           chord_degree(1, :A3, :major),8).tick(:A) , attack: 0.1, release: 0.1, decay: 0.1, amp: 0.8
sleep bar/4.0
end;end
live_loop :back2 do with_fx :level, amp: 0.0 do
with_fx :pan do
with_fx :distortion do
with_fx :echo, phase: 0.1, decay: 0.01 do
sync :quarter
play (knit :B4, 3, :D5, 2).tick(:G), attack: 0.001, release: 0.3
sleep bar/2.0
play (knit :B4, 3, :D5, 2).tick(:G), attack: 0.001, release: 0.3
sleep bar
end;end;end;end;end

live_loop :bass do with_fx :level, amp: 0.0 do
sync :whole
with_fx :reverb,room: 1.0, mix: 1.0 do
play (knit chord(:D3, 'sus4').last,4,
           chord(:A3, 'M').last,4).tick(:G), release: bar*4, attack: bar, amp: 0.5
end;end;end

live_loop :ghost do
sync :whole
4.times do
sample Ether["pebble"], amp: 0.2, start: rrand(0.05, 0.1)
sleep bar/4.0
end
end

live_loop :apeg do; with_fx :level, amp: 0.0 do
with_transpose(0) do
play (ring :A3, :A3, :A3, :E3,
           :A3, :A3, :A3, :E3,
           :A3, :A3, :A3, :E3,
           :A3, :D3, :A3, :D3
).tick(:A)
end
sleep bar/8.0
end;end

live_loop :apeg1 do; with_fx :level, amp: 0.5 do
density(3) do
sample Mountain["microperc_01"], start: rrand(0.05,0.1)
with_fx :pan, pan: (Math.sin(vt*13)/1.5)+0.1 do
play (knit :Fs4, 4, :D4,2).tick :C
sleep bar/2
end;end;end;end

live_loop :apeg2,autocue: false do; with_fx :level, amp: 0.5 do
sync :apeg1
sample Mountain["microperc_07"]
with_fx :pan, pan: -(Math.sin(vt*13)/1.5)-0.1 do
density(2) do
  play (knit :D4, 4, :E4, 3, :Fs4, 1).tick :B
sleep bar/2
end;end;end;end
