#version 330 compatibility

// will be interpolated into the fragment shader:
out  vec2  vST;                 // texture coords
out  vec3  vN;                  // normal vector
out  vec3  vL;                  // vector from point to light
out  vec3  vE;                  // vector from point to eye
out  vec3  vMC;			// model coordinates

// for Mac users:
//	Leave out the #version line, or use 120
//	Change the "out" to "varying"

uniform float uA;
uniform float uP;

uniform float uLightX, uLightY, uLightZ;

vec3 LIGHTPOSITION = vec3( uLightX, uLightY, uLightZ );

#define PI 3.141592

void
main( )
{
	vST = gl_MultiTexCoord0.st;
	vec4 vert = gl_Vertex;
	float Y0 = 1.0; // 1 is a good one
	vert.z = uA*(Y0 - vert.y)*sin(2.0 * PI*vert.x/uP);
	vMC = gl_Vertex.xyz;

	vec4 ECposition = gl_ModelViewMatrix * vert; // eye coordinate position

	// calculate the normal using the cross product
	float dzdx = uA * (Y0 - vert.y)*(2.0 * PI / uP) * cos(2.0 * PI * vert.x / uP);
	float dzdy = -uA * sin(2.0 * PI * vert.x /uP);

	vec3 Tx = vec3(1.0, 0.0, dzdx);
	vec3 Ty = vec3(0.0, 1.0, dzdy);

	vN = normalize(cross(Tx, Ty));
	

	vL = LIGHTPOSITION - ECposition.xyz; // vector from the point to the light position
	vE = vec3( 0., 0., 5. ) - ECposition.xyz; // vector from the point to the eye position
	gl_Position = gl_ModelViewProjectionMatrix * vert;
}