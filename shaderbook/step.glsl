#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

float plot(vec2 step, float pct){
  return  smoothstep( pct-0.02, pct, step.y) -
          smoothstep( pct, pct+0.02, step.y);
}

// smoothstep
// step.y = clamp ( step.y - pct - 0.03 / (pct-0.02 - pct, 0, 1))
// return step.y = step.y * step.y  * (3 - 2 * step.y)
void main() {
    vec2 thisStep = gl_FragCoord.xy/u_resolution;

    // stepep will return 0.0 unless the value is over 0.5,
    // in that case it will return 1.0

    // when x is less than 1. the y will be 0
    // when x is greater than 1, the y will be 1
    float y = step(thisStep.x, 0.5);
    // y can only be 1 or 0
    vec3 color = vec3(y);

    // pct
    float pct = plot(thisStep, y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

     gl_FragColor = vec4(color,1.0);
}