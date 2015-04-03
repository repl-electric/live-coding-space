def csample(name)
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  sample_path = "#{root}/#{name}"
#  load_sample sample_path
  sample_path
end

def with_echo(args, &block)
  with_fx :echo do
    block
  end
end

def live(name, opts={}, &block)
  (@__live_cache ||= []) << name
  @__live_cache = @__live_cache.uniq
  
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


def begone(name)
  raise "could not find #{name} to silence" unless @user_methods.method_defined?(name)

  __info "Silencing #{name}"

  define(name) do |*args|
    sleep 1
  end
end

def solo(name)
  if @user_methods.method_defined?(name)
    (@__live_cache - [name]).map{|n| silence(n)}
  else
    raise "could not find #{name}"
  end
end

def fadeout
  vol = 1
  while(vol >= 0) do
    set_volume! vol
    vol -= 0.08
    sleep 1
  end
end

DEGREES = {:i    => 0,
               :ii   => 1,
               :iii  => 2,
               :iv   => 3,
               :v    => 4,
               :vi   => 5,
               :vii  => 6,
               :viii => 7,
               :ix   => 8,
               :x    => 9,
               :xi   => 10,
               :xii  => 11}

def resolve_degree_index(degree)
  if idx = DEGREES[degree]
      return idx
    elsif degree.is_a? Numeric
      return degree - 1
   else
        raise InvalidDegreeError, "Invalid scale degree #{degree.inspect}, expecting #{DEGREES.keys.join ','} or a number"
   end
end

def degree(degree, tonic, scale)
  scale = SonicPi::Scale.new(tonic, scale)
  index = resolve_degree_index(degree)
  scale.notes[index]
end
