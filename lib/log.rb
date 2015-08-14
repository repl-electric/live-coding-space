def note_inspect(n,ns="")
  n = [n] unless n.respond_to?(:map)
  if n
    "#{ns}[#{(n||[]).map{|n| n ? for_joes_brain(note_info(n).midi_string) : "_"}}]"
  else
    "#{ns}[ _ ]"
  end
end

def for_joes_brain(n)
  case n
    when /^Ab/
      n.gsub("Ab","Gs")
    when /^Bb/
      n.gsub("Bb", "As")
    when /^Eb/
      n.gsub("Eb", "Ds")
    when /^F\d/
      n.gsub("F", "Es")
  else
    n
  end
end