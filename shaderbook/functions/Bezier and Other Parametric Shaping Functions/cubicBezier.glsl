#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Helper functions:
float slopeFromT (float t, float A, float B, float C){
  float dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C); 
  return dtdx;
}

float xFromT (float t, float A, float B, float C, float D){
  float x = A*(t*t*t) + B*(t*t) + C*t + D;
  return x;
}

float yFromT (float t, float E, float F, float G, float H){
  float y = E*(t*t*t) + F*(t*t) + G*t + H;
  return y;
}

/* 
The Cubic Bezier is a workhorse of computer graphics; most designers will recognize it from Adobe Illustrator 
and other popular vector-based drawing programs. Here, this extremely flexible curve is used in as a signal-shaping 
function, which requires the user to specify two locations in the unit square (at the coordinates a,b and c,d) 
as its control points. By setting the two control points (a,b) and (c,d) to various locations, the Bezier curve 
can be used to produce sigmoids, seat-shaped functions, ease-ins and ease-outs.

Bezier curves are customarily defined in such a way that y and x are both functions of another variable t. 
In order to obtain y as a function of x, it is necessary to first solve for t using successive approximation, 
making the code longer than one might first expect. The implementation here is adapted from 
the Bezmath Postscript library by Don Lancaster. */
float cubicBezier (inout float x, inout float a, inout float b, inout float c, inout float d){

  float y0a = 0.00; // initial y
  float x0a = 0.00; // initial x 
  float y1a = b;    // 1st influence y   
  float x1a = a;    // 1st influence x 
  float y2a = d;    // 2nd influence y
  float x2a = c;    // 2nd influence x
  float y3a = 1.00; // final y 
  float x3a = 1.00; // final x 

  float A = x3a - 3.*x2a + 3.*x1a - x0a;
  float B = 3. * x2a - 6.*x1a + 3. * x0a;
  float C = 3. * x1a - 3. * x0a;   
  float D =   x0a;

  float E =   y3a - 3.*y2a + 3.*y1a - y0a;    
  float F = 3.*y2a - 6.*y1a + 3.*y0a;             
  float G = 3.*y1a - 3. * y0a;             
  float H =   y0a;

  // Solve for t given x (using Newton-Raphelson), then solve for y given t.
  // Assume for the first guess that t = x.
  float currentt = x;
  const int nRefinementIterations = 5;
  for (int i=0; i < nRefinementIterations; i++){
    float currentx = xFromT (currentt, A,B,C,D); 
    float currentslope = slopeFromT (currentt, A,B,C);
    currentt -= (currentx - x)*(currentslope);
    //currentt = constrain(currentt, 0,1);
    currentt = clamp(currentt, 0.,1.);
  } 

  float y = yFromT (currentt,  E,F,G,H);
  return y;
}


float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    vec2 endPt;
    float a = 0.5;

    float b = 0.7;

    float c = 0.7;

    float d = 0.2;


    float y = cubicBezier(
        st.x, a, b, c, d);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
