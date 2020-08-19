#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
It is possible to generate sigmoid patterns by joining a symmetric pair of polynomials at the center of the unit square. The exponents in these equations (controlled by the integer parameter n) control the steepness of the wall separating the squelched values from the boosted ones; a suggested range for the whole number n is from 1 to about 10. Of these, the sigmoid created with a 2nd-order (quadratic) exponent comes closest to the Raised Inverted Cosine, 
approximating it to within 2.8%.
*/
float doublePolynomialSigmoid (float x, float a, 
    float b, int n){
  
  float y = 0.0;
  float fn = float(n);
  if (mod(fn, 2.0) == 0.0) { 
    // even polynomial
    if (x <= 0.5) {
      y = pow(2.0 * x, fn) / 2.0;
    } else {
      y = 1.0 - pow(2.0 * (x - 1.0), fn) / 2.0;
    }
  } 
  else { 
    // odd polynomial
    if (x <= 0.5) {
      y = pow(2.0 * x, fn) / 2.0;
    } else {
      y = 1.0 - pow(2.0 * (x - 1.0), fn) / 2.0;
    }
  }

  return y;
}
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = doublePolynomialSigmoid(
        st.x, 0.1, 0.3, 2);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}


