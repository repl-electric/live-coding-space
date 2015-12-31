#require "/Users/josephwilk/Workspace/josephwilk/c++/sonic-pi/app/server/sonicpi/lib/sonicpi/osc/osc.rb"

$LOAD_PATH.unshift("/Users/josephwilk/Workspace/ruby/osc-ruby/lib/")
require "osc-ruby.rb"

#require 'osc-ruby'
unless defined?(SHADER_ROOT)
  SHADER_ROOT = "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lights/"
end
def shader(endpoint, *args)
  if endpoint.is_a?(Array)
    args = if(args[0].is_a?(Array))
      args[0]
    else
      args
    end
    endpoint.zip(args.cycle).each do |thing, value|
      shader(thing, value)
    end
  else
    endpoint = endpoint.to_s.gsub(/_/,"-") #Sorry
    if args.count == 1 && (endpoint.to_s != "shader" &&
                           endpoint.to_s != "vertex")
      args = [endpoint] + args
      endpoint = :uniform
    end
    if endpoint == :shader
      args[0] = "#{SHADER_ROOT}/#{args[0]}"
    end
    endpoint = "#{endpoint.to_s.gsub("smooth", "smoothed-uniform")}"
    endpoint = "#{endpoint.to_s.gsub("decay", "decaying-uniform")}"
    endpoint = "/#{endpoint}"
    @client ||= OSC::Client.new('localhost', 9177)
    begin
      
      args = args.map{|a| a.is_a?(Symbol) ? a.to_s : a}
      puts args
      @client.send(OSC::Message.new(endpoint, *args))
    rescue Exception
      puts $!
      puts "$!> Graphics not loaded"
    end
  end
end

#shader(:shader, "nil.glsl")
#shader(:uniform, "iColorFactor", 0.0)
#live_loop :dance do
#  shader(:suniform, "iColorFactor", 2.0)
#  sample :drum_heavy_kick
#  sleep 1
#end
