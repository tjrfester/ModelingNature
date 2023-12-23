// Persistence of Vision Ray Tracer Scene Description File
// File: SphericalBlob.pov

#version 3.6; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm
*/ 
 
 
//-----------------------------------Scene settings (Camera, light, background)-------------------------------------------------


global_settings {
	assumed_gamma 1.0
	max_trace_level 25
}



// orthographic projection using parallel camera rays
// Could be used to render a planar image map, for example
#declare Ortho = camera {
	orthographic
	location <0, 7, 0>    // position & direction of view
	look_at  <0,0,0>
	right 1.2*8*x            // horizontal size of view
	up 1.2*6*y               // vertical size of view
}



camera {Ortho}


background {color rgb <1, 1, 1>}


// create a regular point light source
light_source {
	0*x                  // light's position (translated below)
	color rgb <1,1,1>    // light's color
	translate <-100, 100, 30>
} 
light_source {
	0*x                  // light's position (translated below)
	color rgb <0.6,0.6,0.6>    // light's color
	translate <0, 100, -10>
}  


/*
//Das Koordinatensystem

cylinder { <-1000, 0, 0>, <1000, 0, 0>, 1 
	pigment {
		color rgb <1,0,0>     // solid color pigment
	}
}

cylinder { <0, -1000, 0>, <0, 1000, 0>, 1 
	pigment {
		color rgb <0,1,0>     // solid color pigment
	}
}

cylinder { <0, 0, -1000>, <0, 0, 1000>, 1 
	pigment {
		color rgb <0,0,1>     // solid color pigment
	}
} 
*/

/*The random blob is a good example for a spherical, 3D-polar distribution. I can be used, e.g.,  for various forms of leukocytes, enveloped virus particles etc.. It can be produced by randomly rotating metaballs around the origin by two axes (e.g, x-axis and y-axis).
*/
 
//---------------------------Objects-----------------------------------------------------------------       

#declare chance1 = seed (5); 						//Definition of random numbers

blob {
	threshold 0.6

	#declare ticker = 0; 
	#while (ticker < 250) 

		sphere { <0, 0, 0>, 1.5, 1				//These spheres are randomly placed between 0 and 3 units on the z-axis and subsequently randomly rotated aroung the y- and x-axis. 
		translate <0, 0, 3*rand(chance1)>   rotate <0, 360 * rand(chance1), 0>   rotate <360*rand(chance1), 0, 0>
 		texture{ 
			pigment {color rgb <0,208/255,1>}
			finish {specular 0.6 }}
		} 

	#declare ticker = ticker + 1; 
	#end 
}

