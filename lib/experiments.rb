class SonicPi::Core::RingVector
  def stretch(n)
    args = [self.to_a, n]
    res = args.each_slice(2).flat_map do |values, num_its|
      if !values.respond_to? :flat_map
              values = [values]
            end
            knit(*values.flat_map{|v| [v, num_its]})
          end
          (res||[]).ring
  end

  def knit(*args)
    res = []
         args.each_slice(2) do |val, num_its|
           if num_its > 0
             res = res + ([val] * num_its)
           end
         end
    res.ring
  end
end

def chord_seq(*args)
  args.each_slice(2).reduce([]){|acc, notes| 
    chord_type = notes[1]
    i = 0
    if chord_type =~ /[abcxyz]$/
      invert_char = chord_type[-1]
      chord_type = chord_type[0..-2]
      i = {'a' => 1, 'b' => 2, 'c' => 3,
           'z' => -3, 'x' => -2, 'y' => -1}[invert_char]
    end
    acc += chord(notes[0],chord_type, invert: i)
  }
end

def note_to_sample(n, oct=1)
  if n
 n = n.is_a?(Integer) ? note_info(n).midi_string : n
 n = n.to_s
 n = n.split(/\d/)[0]
 n = n == "Eb" ? "Ds" : n
 n = n.gsub("s","#")
    /#{n}#{oct}/i
  else
   false
  end
end

def pat(s, bar, pat, *args)
pat.length.times do
 p = ring( *pat.split("\s"))
 sleep bar/4.0
 if p.hook(:pattern_ticker) == "x"
  sample *([s]+args)
 end
 p.tick(:pattern_ticker)
end
end

def deg_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.flatten
  pattern_and_roots = pattern_and_roots.map{|pat|
    if pat =~ /\*/
      note, factor = pat.split("*")
      ([note] * factor.to_i).join("")
    else
      pat
    end
  }.flatten

  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id|
    if(/^[-\d_]+$/ =~ accu[-1] && /^[-\d_]+$/ =~ id)
      accu[0..-2] << "#{accu[-1]}#{id}"
    else
      accu << id
  end}
  patterns = pattern_and_roots.select{|a| /^[-\d_]+$/ =~ a.to_s }
  roots   = pattern_and_roots.select{|a| /^[-\d_*]+$/ !~ a.to_s}

  notes = patterns.each_with_index.map do |pattern, idx|
    root = roots[idx]
    if(root[0] == ":")
      root = root[1..-1]
    end
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
    if(s == :minor)
      s = if    root.to_s[1] == "h"
        :harmonic_minor
      elsif root.to_s[1] == "m"
        :melodic_minor
      else :minor
      end
    end
    #MESSEY
    root = root[0..1] + root[2..-1] if root.length > 2
    pattern.
      scan(/(\d{1}|-\d{1})/).
      flatten.
      map{|d|
        if(d == "_" )
           nil
        elsif(d.to_i < 0) #Only support one octave down
           octave_shift = (d.to_i/10).abs
           new_root = root[0..-2] + (root[-1].to_i - octave_shift).to_s
           degree(d.to_i.abs, new_root, s)
        else
           degree(d.to_i, root, s)
        end}
  end.flat_map{|x| x}
 (ring *notes)
end

def note_seq(*patterns)
  patterns.reject{|a| a.empty?}.
  map{|a|
    note, factor = a.last.split("*")
    factor ||= "1"
    factor = factor.to_i
    a[-1] = note
    a.map{|s| s.gsub(/#/,"s")}.
      map{|s| [s.to_sym] * factor }.
      flatten}.
  flatten.ring
  end

def sample_and_sleep(*args)
  if args
    s = args.first
    sample *args
    sleep sample_duration(s)
  end
end

def bowed_s(name, *args)
  s = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/Bowed\ Notes/*_BowedGuitarNote_01_SP.wav"]
  s.sort!
  sample (if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end), *args
end
def live(name, opts={}, &block)
  idx = 0
  amp = if(opts[:amp])
    opts[:amp]
  else
    1
  end
  x = lambda{|idx|
    with_fx :level, amp: amp do
      block.(idx)
  end}
  live_loop name do |idx|
    x.(idx)
  end
end
