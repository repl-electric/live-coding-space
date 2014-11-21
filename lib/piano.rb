module Piano
  ROOT ="/Users/josephwilk/Dropbox/repl-electric/samples/pi/9133__neatonk__misstereopiano/"

  FILE_FORMAT = "148532__neatonk__piano-"
  TYPE = ".wav"

  def self.note(n, type="med")
    "#{ROOT}#{FILE_FORMAT}#{type}-#{n.downcase}#{TYPE}"
  end
end
