#Mitte

define :support do
sleep 1
sample :guit_e_slide, rate: rrand(1.2,1.8), amp: 0.1
sleep 1
end

define :guitars do
with_fx :reverb, mix: 0.9 do
6.times do |c|
pattern = [[0.75, 0.75, 1.0, 1.2], [0.75, 0.75, 1.2, 1.0],
           [0.75, 0.75, 1.0, 1.0], [0.75, 0.75, 0.8, 1.0]].shuffle.first
sleep 2
sample :guit_e_fifths, rate: pattern[0], pan: rrand(-1,1)
sleep 2
sample :guit_e_fifths, rate: pattern[1], pan: rrand(-1,1)
sleep 2
sample :guit_e_fifths, rate: pattern[2], pan: rrand(-1,1)
sleep 2
sample :guit_e_fifths, rate: pattern[3], pan: rrand(-1,1)
sleep 1
end

sleep 4

6.times do |c|
pattern = [[0.8, 0.8, 1.0, 1.2], [0.8, 1.0, 0.8, 1.2],
           [0.8, 0.8, 1.0, 1.0], [0.6, 0.6, 0.8, 1.0]].shuffle.first
sleep 0.5
sample :guit_e_fifths, rate: pattern[0], pan: rrand(-1,1)
sleep 0.5
sample :guit_e_fifths, rate: pattern[1], pan: rrand(-1,1)
sleep 0.5
sample :guit_e_fifths, rate: pattern[2], pan: rrand(-1,1)
sleep 0.5
sample :guit_e_fifths, rate: pattern[3], pan: rrand(-1,1)
sleep 0.25 if c != 5 
end

1.times do |c|
pattern = [[0.8, 0.8, 1.0, 1.2], [0.8, 1.0, 0.8, 1.2],
           [0.8, 0.8, 1.0, 1.0], [0.6, 0.6, 0.8, 1.0]].shuffle.first
sleep 1
sample :guit_e_fifths, rate: pattern[0], pan: rrand(-1,1)
sleep 1
sample :guit_e_fifths, rate: pattern[1], pan: rrand(-1,1)
sleep 1
sample :guit_e_fifths, rate: pattern[2], pan: rrand(-1,1)
sleep 1
sample :guit_e_fifths, rate: pattern[3], pan: rrand(-1,1)
sleep 0.5 if c != 5 
end

4.times do
guit_sample = [:guit_harmonics].shuffle.first
rates = [0.8, 0.8, 1.0, 1.2, 1.4].shuffle
sleep 2
sample guit_sample, rate: rates[0], pan: rrand(-1,1)
sleep 2
sample guit_sample, rate: rates[1], pan: rrand(-1,1)
sleep 2
sample guit_sample, rate: rates[2], pan: rrand(-1,1)
sleep 2
sample guit_sample, rate: rates[3], pan: rrand(-1,1)
sleep 1
end
end
end

define :drums do
d = :ambi_choir
6.times {sleep 9}

2.times do
sample d, rate: 1.0, sustain: 2.5, attack: 0.01, pan_slide: 0.2, amp_slide: 0.1
sleep 2
end

6.times do
  sample d, rate: 1.0 , sustain: 1.5, attack: 0.01, pan_slide: 0.2, amp_slide: 0.1
  sleep 0.5
end

4.times {sleep 9}
end

define :beats do
sleep 7.5
s = [:ambi_piano, :ambi_glass_hum, :ambi_drone].shuffle.first
sample s, rate: 0.3
sleep 7.5
sample s, rate: 0.4
end

define :sam do
sleep 7.5
sample [:guit_harmonics, :guit_e_slide].shuffle.first, rate: 0.8, pan: rrand(-1,1)
end

define :chords do
with_fx :reverb do
with_fx :lpf do

use_synth :tri
 
use_synth_defaults  attack: 0.01, release: 4, sustain: 4, decay: 4.0, amp: 0.1,
    cutoff_slide: 0.4, note_slide: 0.4, sustain_level: 0.2, env_curve: 7
 
chords = [:F2, :F2, :A2, :C2].shuffle
 
sleep 2
play chord(chords[0], :minor)
sleep 2
play chord(chords[0], :minor)
sleep 2
play chord(chords[1], :minor)
sleep 2
play chord(chords[2], :minor)
sleep 1
end
end
end

define :highlights do
sample [:ambi_haunted_hum, :ambi_glass_hum].shuffle.first
sleep 4
end

in_thread(name: :a)  do loop{highlights} end
in_thread(name: :g)  do loop{sample :ambi_lunar_land; sleep 9; guitars} end
in_thread(name: :b)  do loop{beats} end
in_thread(name: :s)  do loop{sam} end
in_thread(name: :c)  do loop{chords} end
in_thread(name: :su) do 
  sleep(9*4) 
  loop{support} 
end

in_thread(name: :d) do loop{drums} end