#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Plot a line on Y using a value between 
// 0.0-1.0
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    // get coordinates x, y
	vec2 st = (gl_FragCoord.xy/u_resolution) * 2.0 - 1.0;

    // create a plot y initialized to the x
    float y = pow(cos(PI * st.x / 2.0), 2.0);
    
    vec3 color = vec3(y);

    // Plot a line
    float pct = plot(st, y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

	gl_FragColor = vec4(color,1.0);
}
