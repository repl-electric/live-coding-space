//nil. by Joseph Wilk <joseph@repl-electric.com>
uniform float iVolume;
uniform float iBeat;
uniform float iGlobalBeatCount;
uniform sampler2D iChannel0;
uniform float     iExample;

vec3 hsv2rgb(float h, float s, float v) {
  return mix(vec3(1.), clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float rand(vec2 co){return fract(sin(dot(co.xy ,vec2(2.9898,78.233))) * 58.5453);}
float rand2(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);}
float noise(float x, float y){return sin(1.5*x)*sin(1.5*y);}

vec3 hsvToRgb(float mixRate, float colorStrength){
  float colorChangeRate = 18.0;
  float time = fract(iGlobalTime/colorChangeRate);
  float movementStart = (mod(iGlobalBeatCount,16) == 0) ? 1.0 : 0.5;
  vec3 x = abs(fract((mod(iGlobalBeatCount,16)-1+time) + vec3(2.,3.,1.)/3.) * 6.-3.) - 1.;
  vec3 c = clamp(x, 0.,1.);
  //c = c*iBeat;
  //c = c * clamp(iBeat, 0.1, 0.4)+0.6;
  return mix(vec3(1.0), c, mixRate) * colorStrength;
}

vec4 lineDistort(vec4 cTextureScreen, vec2 uv1){
  float sCount = 900.;
  float nIntensity=0.1;
  float sIntensity=0.2;
  float noiseEntry = 0.0;
  float accelerator= 1000.0;

  // sample the source
  float x = uv1.x * uv1.y * iGlobalTime * accelerator;
  x = mod( x, 13.0 ) * mod( x, 123.0 );
  float dx = mod( x, 0.05 );
  vec3 cResult = cTextureScreen.rgb + cTextureScreen.rgb * clamp( 0.1 + dx * 100.0, 0.0, 1.0 );
  // get us a sine and cosine
  vec2 sc = vec2( sin( uv1.y * sCount ), cos( uv1.y * sCount ) );
  // add scanlines
  cResult += cTextureScreen.rgb * vec3( sc.x, sc.y, sc.x ) * sIntensity;

  // interpolate between source and result by intensity
  cResult = cTextureScreen.rgb + clamp(nIntensity, noiseEntry,1.0 ) * (cResult - cTextureScreen.rgb);

  return vec4(cResult, cTextureScreen.a);
}

float smoothbump(float center, float width, float x){
  float w2 = width/2.0;
  float cp = center+w2;
  float cm = center-w2;
  float c = smoothstep(cm, center, x) * (1.0-smoothstep(center, cp, x));
  return c;
}

void main(void){
  vec2 uv = gl_FragCoord.xy / iResolution.x;
  vec4 c = vec4(0.2);

  if(uv.x > 0.490 && uv.x < 0.512 && uv.y < 0.12 && uv.y > 0.1){//head
    c = rand2(uv*1.0)+c;
  }
  if(uv.x > 0.5 && uv.x < 0.505 && uv.y < 0.1 && uv.y > 0.09){//neck
    c = vec4(0.8)-c;
  }
  if(uv.x > 0.494 && uv.x < 0.512 && uv.y < 0.09){//body
    c = vec4(0.9)-c;
  }
  if(uv.x > 0.491 && uv.x < 0.493 && uv.y < 0.09 && uv.y > 0.008){//arm
    c = c+vec4(0.5);
  }
  if(uv.x > 0.513 && uv.x < 0.515 && uv.y < 0.09 && uv.y > 0.008){//arm
    c = c+vec4(0.5);
  }
  gl_FragColor = lineDistort(c, uv);
}
