use_bpm 120
require "mysql2"
_=nil
max_samples = 500
max_count = 500
@everything ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "repl_electric_samples")
octave = 4
@perc_f ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'F#')").to_a.shuffle.take(128))
@perc_a ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'A')").to_a.shuffle.take(128))
@perc_d ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'D')").to_a.shuffle.take(128))
@perc_c ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'C#')").to_a.shuffle.take(128))
@perc_e ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'E')").to_a.shuffle.take(128))
@perc_g ||= (ring *@everything.query("select path,onset,offset,length from notes where octave = #{octave} AND length < 0.25 AND (note = 'G#')").to_a.shuffle.take(128))

(@perc_c+@perc_f+@perc_a+@perc_d+@perc_g+@perc_e).each{|s|
load_sample s}
puts (@perc_c+@perc_f+@perc_a+@perc_d+@perc_g+@perc_e).count

def tuned_perc(note)
  puts note
  case note
  when "F#" then (ring *@perc_f.to_a.select{|p| p["path"] =~ /sop/})
  when "C#" then @perc_c #(ring *@perc_c.to_a.select{|p| p["path"] =~ /sop/})
  when "A" then @perc_a#(ring *@perc_a.to_a.select{|p| p["path"] =~ /sop/})
  when "D" then @perc_d#(ring *@perc_d.to_a.select{|p| p["path"] =~ /sop/})
  when "E" then @perc_e                   z#(ring *@perc_e.to_a.select{|p| p["path"] =~ /sop/})
  when "G#" then (ring *@perc_g.to_a.select{|p| p["path"] =~ /sop/})
  else []
  end
end

live_loop :techno, sync: :heart do
  s = Tech[/loop/,/120/, /f#m/]
  puts s
  sample s, amp: 0.2
  sleep sample_duration(s)-0.2
end

live_loop :perc_part, sync: :heart do
  tick
  if spread(1,22).look
    with_fx :reverb do
      synth :dark_sea_horn, note: (ring chord(:FS1, :m), chord(:A1, :m), chord(:D1, :M), chord(:E1, :M)).look[0], amp: 1.0, decay: 22.0, cutoff: 60
    end
  end
  changing = [spread(7,11).look, spread(1,4).look]
  #changing.shuffle! if dice(6) > 4
  n = (knit "F#",22, "A",22, "D",22, "E",22).tick(:ti)
  p1 = tuned_perc(n).tick(:s1)
  if changing[0] && p1
    #    synth :plucked, note: n.gsub("#","s"), decay: 0.25, attack: 0.001
    pos = [ratio_on(p1), ratio_off(p1)]
    pos.shuffle! if dice(32) > 1
    sample p1["path"], start: pos[0], finish: pos[1], amp: 2.0
  end
  n = (knit "A",22, "C#",22, "F#",22, "G#",22).tick(:t2i)
  p1 = tuned_perc(n).look
  if changing[1] && p1
    #   synth :plucked, note: n.gsub("#","s"), decay: 0.125, attack: 0.001
    pos = [ratio_on(p1), ratio_off(p1)]
    pos.shuffle! if dice(32) > 1
    sample p1["path"], start: pos[0], finish: pos[1], amp: 2.0
  end
  sleep 0.25
end

live_loop :hats, sync: :heart do
  with_fx :wobble, phase: 32 do
    with_fx :reverb, mix: 0.1 do
      with_fx :slicer, probability: 0.5 do
        sleep 0.5
        sample Frag[/hat/,(knit 65,9, 64,1).tick(:hats)], amp: 0.5, pan: (ring 0.25, -0.25).tick(:p), rate: (knit 0.5,2, 0.9,2).tick(:p2)
        sleep 0.5
      end
    end
  end
end

live_loop :heart do
  sample Mountain[/subkick/i,1], amp: 2.0
  sleep 1
  sample Mountain[/subkick/i,1], amp: 1.0, cutoff: 120
  sample Corrupt[/snare/,3], amp: 1.0, cutoff: (ring *(range 100, 135, 2.5)).tick
  sleep 1
end

def ratio_on(smp)
  if smp
    dur = sample_duration(smp["path"])
    smp["onset"]/dur+0.0
  end
end
def ratio_off(smp)
if smp
  dur = sample_duration(smp["path"])
  smp["offset"]/dur+0.0
  end
end
