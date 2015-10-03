require 'osc-ruby'
unless defined?(SHADER_ROOT)
  SHADER_ROOT = "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lights/"
end
def shader(endpoint, *args)
  if endpoint == :shader
    args[0] = "#{SHADER_ROOT}/#{args[0]}"
  end
  endpoint = "/#{endpoint.to_s.gsub("smooth", "smoothed-uniform")}"
  endpoint = "/#{endpoint.to_s.gsub("decay", "decaying-uniform")}"
  @client ||= OSC::Client.new('localhost', 9177)
  begin
    args = args.map{|a| a.is_a?(Symbol) ? a.to_s : a}
    @client.send(OSC::Message.new(endpoint, *args))
  rescue Exception 
    puts "$!> Graphics not loaded"
  end
end

#shader(:shader, "nil.glsl")
#shader(:uniform, "iColorFactor", 0.0)
#live_loop :dance do
#  shader(:suniform, "iColorFactor", 2.0)
#  sample :drum_heavy_kick
#  sleep 1
#end
