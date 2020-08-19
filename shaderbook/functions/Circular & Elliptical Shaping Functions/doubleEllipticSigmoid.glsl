#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
This sigmoid-shaped function is created by the 
joining of two elliptical arcs, and is a 
generalization of the Double-Circle Sigmoid. 
The arcs meet at the coordinate 
(a, b) in the unit square with a vertical tangent. */
float doubleEllipticSigmoid (float x, float a, float b){

  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  float newa = max(min_param_a, min(max_param_a, a)); 
  float newb = max(min_param_b, min(max_param_b, b));
 
  float y = 0.;
  if (x <= a){
    y = newb * (1. - (sqrt(pow(newa, 2.) - pow(x, 2.))/newa));
  } else {
    y = newb + ((1.-b)/(1.-newa)) * 
        sqrt(pow(1.-newa, 2.) - pow(x-1., 2.));
  }
  return y;
}


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = doubleEllipticSigmoid(
        st.x, 0.6, 0.5);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
