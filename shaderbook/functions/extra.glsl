//Almost Identity (I)
/* Imagine you don't want to change a value 
unless it's zero or very close to it, in which 
case you want to replace the value with a small 
constant. Then, rather than doing a conditional 
branch which introduces a discontinuity, 
you can smoothly blend your value with your 
threshold. Let m be the threshold (anything above 
m stays unchanged), and n the value things will 
take when your input is zero. Then, the following 
function does the soft clipping (in a cubic fashion):
*/
float almostIdentity( float x, float m, float n )
{
    if( x > m ) return x;
    const float a = 2.0*n - m;
    const float b = 2.0*m - 3.0*n;
    const float t = x/m;
    return (a*t + b)*t*t + n;
}

// Almost Unit Identity
/* This is another near-identiy function, 
but this one maps the unit interval to itself. 
But it is special in that not only remaps 0 to 0 
and 1 to 1, but has a 0 derivative at the origin 
and a derivative of 1 at 1, making it ideal for 
transitioning things from being stationary to 
being in motion as if they had been in motion 
the whole time. It's equivalent to the Almost 
Identiy above with n=0 and m=1, basically. And 
since it's a cubic just like smoothstep() and 
therefore very fast to evaluate:
*/

float almostUnitIdentity( float x )
{
    return x*x*(2.0-x);
}

// Almost Identity (II)
/* A different way to achieve a near identity 
that can also be used as smooth-abs() is through 
the square root of a biased square, instead of 
a cubic polynomail. I saw this technique first 
in a shader by user "omeometo" in Shadertoy. 
This approach can be a bit slower than the 
cubic above, depending on the hardware. And 
while it has zero derivative, it has a non-zero 
second derivative, which could cause problems 
in some situations:
*/

float almostIdentity( float x, float n )
{
    return sqrt(x*x+n);
}