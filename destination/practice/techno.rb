use_bpm 120
_=nil
shader :iWave, 1.0
max_samples = 500
max_count = 500
octave = 3
max_length = 0.25
min_length = 0.20
@perc_f = Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'F#')").shuffle.take(128*2)
@perc_a =  Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'A')").shuffle.take(128)
@perc_d = Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'D')").shuffle.take(128)
@perc_c = Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'C#')").shuffle.take(128)
@perc_e = Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'E')").shuffle.take(128)
@perc_g = Dsp.query("select path,onset,offset,length from notes_fine where octave=#{octave} AND length < #{max_length} AND length > #{min_length} AND (note = 'G#')").shuffle.take(128)
#(@perc_c+@perc_f+@perc_a+@perc_d+@perc_g+@perc_e).each{|s| load_sample s["path"] if s}
#sleep 4
puts (@perc_c+@perc_f+@perc_a+@perc_d+@perc_g+@perc_e).count
def tuned_perc(note)
  #puts note
  case note
  when "F#" then  ring(*@perc_f.to_a.select{|p| p[:path] =~ /alto|sop/})
  when "C#" then  ring(*@perc_c.to_a.select{|p| p[:path] =~ /alto|sop/})
  when "A" then  @perc_a# ring(*@perc_a.to_a.select{|p| p["path"] =~ /alto|sop/})
  when "D" then  @perc_d# ring(*@perc_d.to_a.select{|p| p["path"] =~ /kick/})
  when "E" then  @perc_e# ring(*@perc_e.to_a.select{|p| p["path"] =~ /kick/})
  when "G#" then @perc_g# ring(*@perc_g.to_a.select{|p| p["path"] =~ /kick/})
  else []
  end
end

live_loop :techno, sync: :heart do
  s = Tech[/loop/,/120/, /f#m/]
  puts s.split("/")[-1]
  sample s, amp: 0.1
  sleep sample_duration(s)-0.2
end

_=nil
live_loop :voices_rolling, sync: :heart do
  tick
  #with_fx :vowel, vowel_sound: 1 do
  with_fx :slicer, phase: 0.25, wave: 0, probability: 1.0 do
    synth :dark_sea_horn, note:  knit(_, 31, :FS2, 1, _,31, :D2,1,  _,31, :E2,1).look, decay: 31, amp: 1.0
  end
  with_fx :slicer, phase: 0.5, wave: 0, invert_wave: 1, probability: 1.0 do
    synth :dark_sea_horn, note:  knit(_, 31, :FS3, 1, _,31, :Fs3,1,  _,31, :Cs3,1).look, decay: 31, amp: 1.0
  end
  with_fx :slicer, phase: 0.25, wave: 0, invert_wave: 1, probability: 1.0 do
    synth :dark_sea_horn, note:  knit(_, 31, :Fs1, 1, _,31, :A1,1,  _,31, :Cs1,1).look, decay: 31
  end
  #end
  
  with_fx :bitcrusher do
    with_fx :krush do
      with_fx :wobble, phase: 32 do
        sleep 1/2.0
        sample  ring(*@perc_f.to_a.select{|p| p[:path] =~ /alto/}
                     # @perc_c.to_a.select{|p| p["path"] =~ /alto|sop/}
                     ).look[:path], amp: 1.0, cutoff: 80
        sleep 1/2.0
      end
    end
  end
end

live_loop :melo do
  s = Tech[/120/, /F#/,0]
  puts s.split("/")[-1]
  sample s
  sleep 32
end

live_loop :perc_part, sync: :heart do
  use_random_seed  knit(1,8,4,8,4,8,1,8).look
  it = scale(:Fs3, :minor_pentatonic, no_octaves: 2).shuffle.take(3)
  with_fx :slicer, mix: 0.0, phase: 0.125 do
    with_fx :lpf, cutoff: 130 do
      8.times{
        tick
        with_fx  knit(:none,11, :echo,1).look, phase: 0.25, decay: 2.0 do
          if spread(1,22).look
            with_fx :reverb do
              #synth :dark_sea_horn, note:  ring(chord(:FS1, :m), chord(:A1, :m), chord(:D1, :M), chord(:E1, :M)).look[0], amp: 1.0, decay: 22.0, cutoff: 60
            end
          end
          changing = [spread(7,11).look, spread(3,8).look]
          #changing.shuffle! if dice(6) > 4
          n =  knit("F#", 22, "A", 22, "D",22, "E",22).tick(:ti)
          p1 = tuned_perc(n).take(64).tick(:s1)
          if changing[0] && p1
            #            synth :plucked, note: n.gsub("#","s"), amp: 0.3, decay: 0.125, attack: 0.001, cutoff:  ramp(* range(100, 135, 5)).tick(:Ramspey)
            pos = [ratio_on(p1), ratio_off(p1)]
            pos.shuffle! if dice(32) > 1
            nudge = 0.0#(n == "E") ? (p1["length"]*0.1 / p1["length"])  : 0.0
            sample p1[:path], start: pos[0], finish: pos[1]+nudge, amp: 2.0
          end
          n =  knit("A",22, "C#",22, "F#",22, "G#",22).tick(:t2i)
          p1 = tuned_perc(n).take(32).look
          if changing[1] && p1
            #synth :plucked, note: n.gsub("#","s"), decay: 0.125, attack: 0.001, cutoff: 120, cutoff:  ramp(* range(0, 135, 5)).tick(:Ramspey)
            pos = [ratio_on(p1), ratio_off(p1)]
            pos.shuffle! if dice(32) > 1
            sample p1[:path], start: pos[0], finish: pos[1], amp: 2.0
          end
        end
        sleep 0.25
      }
    end
  end
end

with_fx :reverb, mix: 0.1 do
  with_fx :wobble, phase: 32 do
    live_loop :hats, sync: :heart do
      with_fx :slicer, probability: 0.5 do
        sleep 0.5
        if  ring(1,0,1,0,
                 1,0,1,0,
                 1,0,1,0,
                 0,1,1,0).tick == 1
          sample Corrupt[/hat/,3], cutoff: 120, amp: 1.0
        end
        sleep 0.5
      end
    end
  end
end

live_loop :heart do
  s = Junk[/120/,/InsectRepelent/]
  sample Fraz[/120/].tick, amp: 1.0, beat_stretch: 16
  s = Tech[/loop/,/120/,9]
  sample s, rate: 1, cutoff:  ring(* range(100,135,5)).tick(:up)
  d = sample_duration s
  at do
    sleep 2*4
    sample s, rate: 1, cutoff:  ring(* range(100,135,5)).tick(:up)
  end
  8.times{|n|
    if n % 8 == 7
      sample Mountain[/subkick/,0], amp: 2
      #      sample Corrupt[/kick/,1..2].tick(:c), amp: 2
      sleep 1.0/2.0
      sample Mountain[/subkick/,0], amp: 2
      
      #sample Mountain[/subkick/,1], amp: 2
      sleep 1.0/2.0
      sample Corrupt[/snare/,3], amp: 1
      
      #sample Mountain[/subkick/,1], amp: 2
      #     sample Mountain[/subkick/,0], amp: 1
      #sample Corrupt[/snare/,3], amp: 1
      #sample Mountain[/snare/,4], amp: 1
      #sample Corrupt[/snare/,5..6].tick(:s), amp: 1
      sleep 1.0
    else
      sample Mountain[/subkick/,0], amp: 2
      #sample Corrupt[/kick/,1..2].tick(:c), amp: 2
      sleep 1.0
      sample Mountain[/subkick/,0], amp: 2
      
      #sample Mountain[/subkick/,1], amp: 2
      sample Corrupt[/snare/,3], amp: 1
      #    sample Mountain[/subkick/,0], amp: 1
      
      #  sample Mountain[/snare/,4], amp: 1
      #  sample Corrupt[/snare/,5..6].tick(:s), amp: 1
      sleep 1.0
    end
  }
  #sample Corrupt[/snare/i,4], amp: 1
  #  sample ChillD[/120/, 1].tick
  #  sample Mountain[/subkick/i,1], amp: 2
  # sleep 4.0
  # sample Mountain[/subkick/i,1], amp: 2
  #  sleep 4.0
  #sample Corrupt[/snare/i,4], amp: 1
  #sample Mountain[/subkick/i,1], amp: 2
  #sleep 4.0
end

def ratio_on(smp)
  if smp
    dur = sample_duration(smp[:path])
    smp[:onset]/dur+0.0
  end
end
def ratio_off(smp)
if smp
  dur = sample_duration(smp[:path])
  smp[:offset]/dur+0.0
  end
end

set_volume! 1.0
