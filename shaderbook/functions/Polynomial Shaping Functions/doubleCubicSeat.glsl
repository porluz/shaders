#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
This seat-shaped function is formed by joining 
two 3rd-order polynomial (cubic) curves. 
The curves meet with a horizontal inflection point 
at the control coordinate (a,b) in the unit square.
*/
float doubleCubicSeat (float x, float a, float b) {
  
  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  float newa = min(max_param_a, max(min_param_a, a));  
  float newb = min(max_param_b, max(min_param_b, b)); 
  
  float y = 0.0;
  if (x <= a) {
    y = newb - newb * pow(1.0 - x/newa, 3.0);
  } else {
    y = newb + (1.0 - newb) 
    * pow((x - newa)/(1.0 - newa), 3.0);
  }
  return y;
}


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution * 2.0 - 1.0;

    float y = doubleCubicSeat(st.x, 0.5, 0.1);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
