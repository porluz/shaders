


#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
Trigonometric functions like cos() and sin() 
are ubiquitous in natural sciences, engineering and 
animation, but they can be expensive to compute. 
If a situation calls for millions of trigonometric 
operations per second, substantial speed optimizations
 can be obtained by using an approximation 
 constructed from simple arithmetic functions. 
 An example is the Blinn-Wyvill polynomial 
 approximation to the Raised Inverted Cosine, 
 which diverges from the authentic (scaled) 
 trigonometric function by less than 0.1% within 
 the range [0...1]. It also shares some of the 
 Raised Inverted Cosine's key properties, 
 having flat derivatives at 0 and 1, 
 and the value 0.5 at x=0.5. It has the strong 
 advantage that it is relatively efficient to compute,
  since it is comprised exclusively from simple 
  arithmetic operations and cacheable fractions. 
  Unlike the Raised Inverted Cosine, it does not 
  have infinite derivatives, but since it is a 
  sixth-order function, this limitation 
is unlikely to be noticed in practice.
This would be a useful approximation for the cos() and sin() trigonometric functions for a small microprocessor (such as an Arduino) which has limited speed and math capabilities.
*/
float blinnWyvillCosineApproximation (float x){
  float x2 = x*x;
  float x4 = x2*x2;
  float x6 = x4*x2;
  
  float fa = (4.0/9.0);
  float fb = (17.0/9.0);
  float fc = (22.0/9.0);
  
  float y = fa*x6 - fb*x4 + fc*x2;
  return y;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution * 2.0 - 1.0;

    float y = blinnWyvillCosineApproximation(st.x);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
