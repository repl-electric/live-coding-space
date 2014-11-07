define :choir do |sample|
4.times do
sample sample, rate: 0.2, sustain: 2.5, attack: 0.01, pan_slide: 0.2, amp_slide: 0.1
sleep 2
end

loop do
6.times do
sample sample, rate: 0.3 , sustain: 1.5, attack: 0.01, pan_slide: 0.2, amp_slide: 0.1
sleep 1
end

6.times do
sample sample, rate: 0.4 , sustain: 1.5, attack: 0.01, pan_slide: 0.2, amp_slide: 0.1
sleep 0.5
end
end
end

define :drums do
  with_fx :reverb, room: 1 do
  4.times { sleep(2) }
  loop do
  
  5.times do
    sample :drum_tom_lo_soft, amp: 0.3, rate: 0.6
    sleep 1
  end
  
  sample :drum_tom_lo_soft, amp: 0.6, rate: 0.8
  sleep 0.5
  sample :drum_tom_lo_soft, amp: 0.6, rate: 0.8
  sleep 0.5
  
  6.times {sleep 0.5}
  
  end
  end
end

define :highlight1 do
  4.times { sleep(2) }
  3.times do
    sample :ambi_haunted_hum, amp: 0.5, rate: 0.7, curve: 7
    sleep 4
  end
  
end

define :support do
  6.times do
    sleep 1
  end

  4.times do
    sample :ambi_piano, rate: 0.8
    sleep 0.5
  end
  
  1.times do
    sample :ambi_piano, rate: 0.9
    sleep 0.5
  end  
  
  1.times do
    sample :ambi_piano, rate: 0.9
    sleep 0.5
  end  
end

define :guitar do
  with_fx :ixi_techno do
  1.times do  
    sleep 1
    sample :guit_e_slide, rate: 0.1
  end
  
  6.times do 
    sleep 1 
  end
  
  6.times do 
    sleep(0.5)
  end
  end
end

in_thread(name: :a) {choir :ambi_choir}
in_thread(name: :d) {drums}
in_thread(name: :e) {loop{highlight1}}
in_thread(name: :e) {loop{support}}
in_thread(name: :f) {loop{guitar}}

sample :ambi_lunar_land, curve: 7, release: 5, rate: 0.1

#with_fx :ixi_techno do
#  sample "/Users/josephwilk/Dropbox/repl-electric/samples/joe-typing-keyboard.wav"
#end
