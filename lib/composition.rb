def root(note_seq)
  note_seq.map{|n| note(n[0])}.compact.sort[0]
end

def degrees_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id| 
  if(!accu[-1].kind_of?(Symbol) && id.kind_of?(Integer))
    accu[0..-2] << "#{accu[-1]}#{id}"
  else
    accu << id
  end}
 patterns = pattern_and_roots.select{|a| /^[\d]+$/ =~ a.to_s } 
 roots   = pattern_and_roots.select{|a| /^[\d]+$/ !~ a.to_s}
 notes = patterns.each_with_index.map do |pattern, idx|
  root = roots[idx]
  if(root[0] == ":")
    root = root[1..-1]
  end
  s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  pattern.to_s.split("").map{|d| degree(d.to_i, root, s)}
 end.flat_map{|x| x}
 (ring *notes)
end

def deg_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id| 
  if(/^[\d_]+$/ =~ accu[-1] && /^[\d_]+$/ =~ id)
    accu[0..-2] << "#{accu[-1]}#{id}"
  else
    accu << id
  end}
  patterns = pattern_and_roots.select{|a| /^[\d_]+$/ =~ a.to_s } 
  roots   = pattern_and_roots.select{|a| /^[\d_]+$/ !~ a.to_s}
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
  root = root[0] + root[2..-1] if root.length > 2
  pattern.to_s.split("").map{|d| d == "_" ? nil : degree(d.to_i, root, s)}
 end.flat_map{|x| x}
 (ring *notes)
end

def chords_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| chord_degree(d.to_i, root, s)}
end
