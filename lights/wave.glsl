uniform sampler2D iChannel0;
uniform float     iExample;
uniform float     iBeat;
uniform float     iWave;
uniform float iGlow;

#define PI  3.14159  
#define EPS .8  

#define T 1.5  // Thickness  
#define W 1.5   // Width  
#define A .5  // Amplitude  
#define V 0.1   // Velocity  


vec4 lineDistort(vec4 cTextureScreen, vec2 uv1){
  float sCount = 900.;
  float nIntensity=0.8;
  float sIntensity=0.8;
  float noiseEntry = 0.0001;
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


void main(void){
vec2 c = gl_FragCoord.xy / iResolution.xy;  
	vec4 s = texture2D(iChannel0, c * .5)*iWave+0.5;  
	c = vec2(0., A*s.y*sin((c.x*W+iGlobalTime*V)* 2.5)) + (c*2.-1.);  
	float g = max(abs(s.y/(pow(c.y, 0.1*sin(s.x*PI))))*T,  
				  abs(.1/(c.y+EPS)));  
  vec4 wave = vec4(g+sin(iBeat+iGlobalTime*0.1)*g*s.y*(2.9+iBeat), g*s.w*.1, g*g * iGlow, 1.);
	gl_FragColor = lineDistort(wave, c);  
} 
