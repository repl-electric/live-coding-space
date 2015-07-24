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
  args.each_slice(2).reduce([]){|acc, notes| acc += chord(notes[0],notes[1])}
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

module Sample
def self.matches(samples, matchers)
  samples = samples.sort!
  r = matchers.reduce(samples) do |filtered_samples,filter|
    if filtered_samples && !filtered_samples.empty?
    if filter.is_a?(Integer)
      filter = filter % filtered_samples.size
      [filtered_samples[filter]]
    elsif filter.is_a? Regexp
      filtered_samples.select{|s| s=~ filter}
    elsif filter.is_a? Range
      filter.to_a.map{|f| Sample.matches(filtered_samples, [f])}
    elsif filter.is_a? Array
      filter.map{|f| Sample.matches(filtered_samples, [f])}
    else
      filtered_samples.select{|s| s=~ /#{filter}/i}
    end
    end
  end

  if r && r.length == 1
    r[0]
  else
  if r && !r.empty?
    SonicPi::Core::RingVector.new(r)
  end
  end
end
end

module Mountain
  def self.pick(a)
    Mountain[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Mountain/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Ether
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Ether/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    Ether[a][0]
  end
end
module Frag
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Frag/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    Ether[a][0]
  end
end
module Eraser
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Eraser/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    Ether[a][0]
  end
end
module Scape
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Soundscape/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    Ether[a][0]
  end
end
module Ambi
 def self.pick(a)
   Ambi[a][0]
 end
 def self.[](*a)
   samples = Dir["/Users/josephwilk/Workspace/music/samples/Ambi/**/*.wav"]
   Sample.matches(samples, a)
 end
end
module Chill
 def self.pick(a)
   Chill[a][0]
 end
 def self.[](*a)
   samples = Dir["/Users/josephwilk/Workspace/music/samples/Chill/**/*.wav"]
   Sample.matches(samples, a)
 end
end
module Down
  def self.pick(a)
    Ambi[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Down/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Heat
  def self.pick(a)
    Heat[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Heat/**/*.wav"]
    Sample.matches(samples, a)
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
           root = root[0..-2] + (root[-1].to_i - octave_shift).to_s
           puts root
           degree(d.to_i.abs, root, s)
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
