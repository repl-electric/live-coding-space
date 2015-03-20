beat = 1/2.0

def degrees_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| degree(d.to_i, root, s)}
end

wood_s = "/Users/josephwilk/Dropbox/repl-electric/samples/Analog\ Snares\ \&\ Claps/17\ \ EMT140\ \(1\).wav"

live :drums do |n|
  cue :hit
  cue :half_hit
  sleep beat/2
  cue :half_hit
  sleep beat/2
  cue :half_hit
  sleep beat/4
  cue :half_hit
  sleep beat/4
  cue :half_hit
  sleep beat/2
  n+=1
end

live :pulse3, amp: 4.0 do |p_inc|
 sync :half_hit
 with_synth :hollow do
#   with_fx :echo, phase: beat/8 do
   sample wood_s, amp: 0.9, start: 0.08
 #  end
   play (ring *degrees_seq(1113111311131114, :Cs3))[p_inc], attack: 0.01, release: beat/2, amp: 4.00
   with_synth :growl do
   play (ring *degrees_seq(1113111311131114, :Cs5))[p_inc], attack: 0.001, release: beat/2, amp: 4.00
   end
   sleep beat/4
 end
 p_inc+=1
end

live_loop :holloweded do |z_inc|
  hollowed_synth (ring *degrees_seq(111111114, :Cs3, :major))[z_inc]
  sleep beat
  z_inc+=1
end

set_volume! 4.0
