def degrees_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id| 
  if(!accu[-1].kind_of?(Symbol) && id.kind_of?(Integer))
    accu[0..-2] << "#{accu[-1]}#{id}"
  else
    accu << id
  end}
 patterns = pattern_and_roots.select{|a| (a.kind_of?(Fixnum) || a.kind_of?(String))} 
 roots   = pattern_and_roots.select{|a| a.kind_of? Symbol}
 notes = patterns.each_with_index.map do |pattern, idx|
  root = roots[idx]
  s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  pattern.to_s.split("").map{|d| degree(d.to_i, root, s)}
 end.flat_map{|x| x}
 (ring *notes)
end

def chords_seq(pattern, root, s=nil)
  if !s
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
  end
  pattern.to_s.split("").map{|d| chord_degree(d.to_i, root, s)}
end