

// Author: Inigo Quiles
// Title: Parabola

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

//A phase shifted sinc curve can be useful 
// if it starts at zero and ends at zero, 
// for some bouncing behaviors (suggested by 
// Hubert-Jan). Give k different integer values
//  to tweak the amount of bounces. 
// It peaks at 1.0, but that take negative 
// values, which can make it unusable in some applications.
float sinc( float x, float k ) {
    float a = PI * (k * x - 1.0);
    return sin(a) / a;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    //vec2 st = gl_FragCoord.xy/u_resolution;

    vec2 st = (gl_FragCoord.xy/u_resolution) * 2.0 - 1.0;

    float y = sinc(st.x, 10.0);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}


