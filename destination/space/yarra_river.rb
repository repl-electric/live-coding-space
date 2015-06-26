#Composed in Melbourne Australia (Not in Berlin, livecoding the-world?)
#By the Yarra River

bar = 1
quart = 2*bar
live_loop :schedule do
  cue :start
  7.times do
    cue :bar
    sleep bar;cue :quart
    cue :quart
    sleep bar
  end
end

def say(words)
  sync :bar
  with_fx :reverb, room: 100 do
  with_fx :lpf do
  use_synth :dark_sea_horn
  t = scale(:a1, :major_pentatonic, num_octaves: 2).shuffle
  notes = words.strip.split("").map(&:ord).map{|n| t[n%t.length]}
  notes.map{|n| if n.chr == " "
                  play n, release: 6, attack: 3
                  sleep 4
                else
                  play n, release: 4.0, attack: 2
                  sleep 2.0
                end
           }
end end end

live_loop :poem do
with_fx :level, amp: 0.2 do
say <<-FOREST
Tiger tiger burning bright
FOREST
end
end

live_loop :drums do
  use_synth :beep
  sync :bar
  sample :drum_bass_soft
  play :A3
end

live_loop :dark do; use_synth :dark_ambience; sync :bar
  play :A1
end

n_inc = 0
live_loop :high do; sync :quart; use_synth_defaults release: quart
  use_synth :singer
  play chord_degree(ring(1,3,4,   1,3,5)[n_inc], :A2, :major_pentatonic)
  n_inc+=1
end

live_loop :drums do; use_synth :growl; sync :bar
  play degree(1, :A2, :major), release: bar
  sleep bar
end

live_loop :chords do;with_fx :level, amp: 1.0 do;sync :bar ;with_fx :reverb, room: 0.8, mix: 0.5 do
 with_fx :slicer, phase: bar/4.0 do
  use_synth :tri; use_synth_defaults decay: bar*2, release: 1, attack: 0.2, amp: 0.2
  play chord_degree(4, :A2, :major)[0]
  sleep bar/2
  play chord_degree(4, :A2, :major)[1..2]
  sync :bar
  play chord_degree(4, :A2, :major)[1..2]
  end
  end
end
end

set_volume! 1.0
