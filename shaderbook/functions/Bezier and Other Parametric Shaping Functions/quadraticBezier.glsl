#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
This function defines a 2nd-order (quadratic) Bezier curve with a single�user-specified spline control point 
(at the coordinate a,b) in the unit square. This function is guaranteed to have the same entering and exiting 
slopes as the Double-Linear Interpolator. Put another way, this curve allows the user to precisely specify its rate of 
change at its endpoints in the unit square. */
float quadraticBezier (inout float x, inout float a, inout float b){
  // adapted from BEZMATH.PS (1993)
  // by Don Lancaster, SYNERGETICS Inc. 
  // http://www.tinaja.com/text/bezmath.html

  float epsilon = 0.00001;
  a = max(0., min(1., a)); 
  b = max(0., min(1., b)); 
  if (a == 0.5){
    a += epsilon;
  }
  
  // solve t from x (an inverse operation)
  float om2a = 1. - 2.*a;
  float t = (sqrt(a*a + om2a*x) - a)/om2a;
  float y = (1.-2.*b)*(t*t) + (2.*b)*t;
  return y;
}

float quadraticBezierVec (float x, vec2 a){
  // adapted from BEZMATH.PS (1993)
  // by Don Lancaster, SYNERGETICS Inc. 
  // http://www.tinaja.com/text/bezmath.html

  float epsilon = 0.00001;
  a.x = clamp(a.x,0.0,1.0); 
  a.y = clamp(a.y,0.0,1.0); 
  if (a.x == 0.5){
    a += epsilon;
  }
  
  // solve t from x (an inverse operation)
  float om2a = 1.0 - 2.0 * a.x;
  float t = (sqrt(a.x*a.x + om2a*x) - a.x)/om2a;
  float y = (1.0-2.0*a.y)*(t*t) + (2.0*a.y)*t;
  return y;
}


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float a = 0.9;
    float b = 0.2;
    float y = quadraticBezier(
        st.x, a, b);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
