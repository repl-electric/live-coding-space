require 'osc-ruby'
SHADER_ROOT = "/Users/josephwilk/Workspace/c++/of_v0.8.4_osx_release/apps/myApps/shaderview/bin/data/"
def :shader(endpoint, *args)
  if endpoint == :shader
    args[0] = "#{SHADER_ROOT}/#{args[0]}"
  end
  endpoint = "/#{endpoint.to_s.gsub("suniform", "smoothed-uniform")}"
  @client ||= OSC::Client.new('localhost', 9177)
  begin
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