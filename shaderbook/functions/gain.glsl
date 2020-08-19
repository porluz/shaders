

// Author: Inigo Quiles
// Title: Parabola

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;

/*
Remapping the unit interval into the unit interval 
by expanding the sides and compressing the center, 
and keeping 1/2 mapped to 1/2, that can be done with 
the gain() function. This was a common function in RSL
 tutorials (the Renderman Shading Language). k=1 is 
 the identity curve, k<1 produces the classic gain() 
 shape, and k>1 produces "s" shaped curces. 
 The curves are symmetric (and inverse) for 
 k=a and k=1/a.
*/
float gain(float x, float k) 
{
    float a = 0.5 * pow(2.0*((x<0.5)?x:1.0-x), k);
    return (x<0.5)?a:1.0-a;
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    //vec2 st = gl_FragCoord.xy/u_resolution;

    vec2 st = (gl_FragCoord.xy/u_resolution);

    float y = gain(st.x, 0.5);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}