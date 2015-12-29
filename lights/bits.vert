uniform sampler2D iChannel0;
uniform float iBeat;
uniform float iScale;
uniform float iConstrict;
uniform float iMotion;
uniform float iKick;
uniform float iDistort;
uniform float iForm;

float rand2(vec2 co){
  return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec3 posf2(float t, float i) {
	return vec3(
      sin(t+i*.9553) +
      sin(t*1.311+i) +
      sin(t*1.4+i*1.53) +
      sin(t*1.84+i*.76),
      sin(t+i*.79553+2.1) +
      sin(t*1.311+i*1.1311+2.1) +
      sin(t*1.4+i*1.353-2.1) +
      sin(t*1.84+i*.476-2.1),
      sin(t+i*.5553-2.1) +
      sin(t*1.311+i*1.1-2.1) +
      sin(t*1.4+i*1.23+2.1) +
      sin(t*1.84+i*.36+2.1)
	)*.2;
}

vec3 posf0(float t) {
  return posf2(t,-1.)*3.5;
}

vec3 posf(float t, float i) {
  return posf2(t*.3,i) + posf0(t);
}

vec3 push(float t, float i, vec3 ofs, float lerpEnd) {
  float snd = pow(texture2D(iChannel0, vec2(.02+.5 * ofs.x, 0.)).x, 8.);
  vec3 pos = posf(t,i) + ofs;
  
  //pos += iBeat*0.1;
    
  vec3 posf = fract(pos+.5)-.5;
  
  float l = length(posf)*2.;
  vec3 r = (- posf + posf/l)*(1.0-smoothstep(lerpEnd,1.,l));

  //Lines through jumping
  //return 0.01*rand2(vec2(t,i))+r;
  
  if(iDistort > 0.0){
    r.x += min(iDistort,0.2)*rand2(vec2(i,i));
  }
  
  //vec4 s = texture2D(iChannel0, vec2(i,t))*0.0002;
  //return s.xyz + r.xyz;

  return r;
}

void main() {
  float time = iGlobalTime * iMotion;
  //time = time + iKick*(0.5+0.5*sin(iKick*iGlobalTime));
  time += iKick*0.01;
  
  float constrict = min(iDistort,1.0);
  float snd = pow(texture2D(iChannel0, vec2(gl_VertexID, 0.)).x, 8.);
  
  float i = (gl_VertexID + cos(gl_VertexID)) * constrict;

  vec3 pos = posf(time,i);
  vec3 ofs = vec3(snd);

  for (float f = -10.; f < 10.; f++) {
    snd = texture2D(iChannel0, vec2(f * ofs.x, 0.8)).x*0.0005;
    if(rand2(ofs.xy) > 0.5){
	    ofs += push((time+snd+f*.05),i,ofs, 2.-exp(-f*.1));
    }
    else{
      //ofs += push((time-snd+f*.05),i,ofs, 2.-exp(-f*.1));
      ofs *= push((time-snd+f*.05),i,ofs, 2.-exp(-f*.1));
    }
  }

  if(iForm > 0.0){
    ofs += push(time, i, ofs, .999) * iForm;
  }
  
  pos -= posf0(time);
  pos += ofs;

  //pos.yz *= mat2(.8,9.6,-.6,.8);  
  pos.yz   *= mat2(.8,.6,-.6,.8);
  pos.xz   *= mat2(.8,.6,-.6,.8);
  
  pos *= 1.;
  pos.z += .7;
  
  pos.xy *= .6/pos.z;
  
  gl_Position = vec4(pos.x, pos.y*iResolution.x/iResolution.y, 0, 1);
  float size = (1./pos.z)*6;
  if(iScale < 0.1){
    if(mod(iGlobalTime, 128.0) > 64.0){
      size = ((1./pos.z)*iScale)+iBeat;
    } 
  }
  else{
    size = ((1./pos.z)*iScale)+iBeat*5;
  }
  gl_PointSize  = size; 
  gl_FrontColor = vec4(abs(normalize(ofs))*.3+.7,1);
}
