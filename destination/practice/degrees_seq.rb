beat = 1.0/4.0
live_loop :test do |h_inc|
  play degrees_seq(:Cs3, "868885555444433335544441111", 
                   :Cs2, 88818181818181,
                   :Cs2, 88838383838383, 
                   :Cs2, 88858585858585,
                   :Cs2, 86888888888888,  
                   :Cs3, 11)[h_inc], 
                   attack: 0.01, release: (ring beat, beat, beat*4, beat*4)[h_inc]
  sleep beat
  h_inc+=1
end

live_loop :test2 do |h_inc|
  sync :test
  case h_inc % 32 
  when 16..32
  play degrees_seq(:Cs3, 8)[h_inc], attack: 0.01, release: beat*4
  sleep beat
  play degrees_seq(:Cs3, 1)[h_inc], attack: 0.01, release: beat*4
  sleep beat
  play degrees_seq(:Cs2, 1)[h_inc], attack: 0.01, release: beat*4
  else
  play degrees_seq(:Cs2, 1)[h_inc], attack: 0.01, release: beat*4
  sleep beat
  play degrees_seq(:Cs2, 1)[h_inc], attack: 0.01, release: beat*4
  sleep beat
  play degrees_seq(:Cs2, 1)[h_inc], attack: 0.01, release: beat*4
  end
  h_inc+=1
end

live_loop :test3 do |h_inc|
  sync :test
  with_fx :lpf, cutoff: 60 do
  with_synth :saw do
    play degrees_seq(:Cs2, 1111122224444)[h_inc], attack: 0.2, release: beat*8
    sleep beat*4
  end
  end
  h_inc+=1
end

live_loop :test4 do |h_inc|
  sync :test
  with_fx(:reverb, room: 1, mix: 0.6, dry: 0.1){
    sample (ring :drum_tom_lo_soft, :drum_tom_mid_soft, :drum_tom_hi_soft)[h_inc], rate: 0.6, amp: 1.0, start: 0.05
  }
  sleep beat*14
  h_inc+=1
end

live_loop :test4 do |h_inc|
  4.times{sync :test}
  sample :elec_lo_snare, amp: 0.05, start: rand(0.1)
end
