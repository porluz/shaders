#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
 This modified version of the Double-Cubic Seat 
 function uses a single variable to control the 
 location of its inflection point along the 
 diagonal of the unit square. A second parameter
 is used to blend this curve with the Identity 
 Function (y=x). Here, we use the variable b to
  control the amount of this blend, which has 
  the effect of tilting the slope of the curve's plateau in the 
  vicinity of its inflection point. 
  The adjustable flattening around the 
  inflection point makes this a useful shaping 
  function for lensing or magnifying 
  evenly-spaced data.
*/
//---------------------------------------------------------------
float doubleCubicSeatWithLinearBlend (float x, 
    float a, float b){

  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0;
  float max_param_b = 1.0;
  float newa = min(max_param_a, max(min_param_a, a));  
  float newb = min(max_param_b, max(min_param_b, b)); 
 // newb = 1.0 - newb; //reverse for intelligibility.
  float y = 0.0;
  if (x <= newa){
    y = newb * x + (1.0 - newb) * newa*(1.0 - pow(1.0 - x/newa, 3.0));
  } else {
    y = newb * x + (1.0 - b)*(newa + (1.0 - newa)
    * pow((x - newa)/(1.0 - newa), 3.0));
  }
  return y;
}


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution * 2.0 - 1.0;

    float y = doubleCubicSeatWithLinearBlend(
        st.x, 0.5, 0.7);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
