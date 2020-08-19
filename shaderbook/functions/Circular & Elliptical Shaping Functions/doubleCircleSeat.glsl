#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
This shaping function is formed by the meeting of two circular arcs, which join with a horizontal tangent. The parameter a, in the range [0...1], governs the location of the curve's inflection point along the
 diagonal of the unit square. */
 float doubleCircleSeat (float x, float a){
  float min_param_a = 0.0;
  float max_param_a = 1.0;
  float newa = max(min_param_a, min(max_param_a, a)); 

  float y = 0.;
  if (x <= a){
    y = sqrt(pow(newa, 2.) - pow(x-newa, 2.));
  } else {
    y = 1. - sqrt(pow(1. - newa, 2.) - pow(x - newa, 2.));
  }
  return y;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = doubleCircleSeat(
        st.x, 0.233);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
