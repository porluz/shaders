#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
This function defines an axis-aligned quadratic 
(parabola) which passes through a user-supplied 
point (a,b) in the unit square. 
Caution: Not all points in the unit square will 
pass by 0,0 and 1,1.
*/
float quadraticThroughAGivenPoint (float x, 
    float a, float b){
  
  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  float newa = min(max_param_a, max(min_param_a, a));  
  float newb = min(max_param_b, max(min_param_b, b)); 
  
  float A = (1.0 - newb)/(1.0 - newa) - (newb/newa);
  float B = (A*(newa * newa) - newb)/newa;
  float y = A * (x*x) - B * (x);
  y = min(1.0, max(0.0,y)); 
  
  return y;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = quadraticThroughAGivenPoint(
        st.x, 0.5, 0.7);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
