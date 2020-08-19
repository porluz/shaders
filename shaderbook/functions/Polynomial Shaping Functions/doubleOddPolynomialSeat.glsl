#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
The previous Double-Cubic Seat function can be 
generalized to a form which uses any odd 
integer exponent. In the code below, the 
parameter n controls the flatness or breadth 
of the plateau region in the vicinity of the 
point (a,b). A good working range for n is 
the set of whole numbers from 1 to about 20.
*/
//---------------------------------------------------------------
float doubleOddPolynomialSeat (float x, float a, 
    float b, int n){

  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  float newa = min(max_param_a, max(min_param_a, a));  
  float newb = min(max_param_b, max(min_param_b, b)); 

  int p = 2 * n + 1;
  float y = 0.0;
  if (x <= newa){
    y = newb - newb * pow(1.0 - x/newa, float(p));
  } else {
    y = newb + (1.0-b)*pow((x-newa)/(1.0-newa), float(p));
  }
  return y;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution * 2.0 - 1.0;

    float y = doubleOddPolynomialSeat(
        st.x, 0.5, 0.7, 1);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}

