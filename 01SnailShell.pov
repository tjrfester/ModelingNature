// Persistence of Vision Ray Tracer Scene Description File
// File: SnailShell.pov

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
	// radiosity {}
}


#declare Cameraz = camera {
	location  <1, 0, -10>
	look_at   <0, 0,  0>
}

camera {Cameraz}

sky_sphere {pigment {rgb 1}}


// create a regular point light source
light_source {
    0*x                  // light's position (translated below)
	color rgb <1,1,1>    // light's color
	translate <1, 1, -200>
}


light_source {
	0*x                  // light's position (translated below)
	color rgb <1,1,1>    // light's color
	translate <-100, 100, 00>
}


// Light in the opening of the snail shell

light_source {
	0*x                  // light's position (translated below)
	color rgb <1,1,1>    // light's color
	translate <2, -2.5, 0>
}


/*
---------------------------------------------------Modeling approach---------------------------------------------- 

Snails are forming logarithmic spirals. The radial extension of the shell, its position along the y-axis and the width of the shell 
can all be described by exponential equations in dependence of the radius of the snail turns. Interestingly these three independent 
equations can have identical exponents. 

RadialExtension = ScalingFactorR X e to the power of (ExponentialFactor x Angle)
DistanceAlongY = ScalingFactorY X e to the power of (ExponentialFactor x Angle)
ShellWidth = ScalingFactorW X e to the power of (ExponentialFactor x Angle)

In the beginning of the following script these equations and suitable ScalingFactors and ExponentialFactors are defined. 
ScalingFactors and ExponentialFactors can be used to modify snail shapes - feel free to try it!

The snail parameters determined by the equations are used to define positions of spheres, which are fused to a blob. A spiral of 
similar parameters but slightly smaller width and  negative field strength is used to make this shell hollow. 

Furthermore, we add two types of decorations: decorations fused with the blob and decorations added as separate objects. For defining 
the positions of decorations we use the same logarithmic spiral and add the width of the shell to place these positions on the outside of the shell. 
*/ 



//--------------------------------------------Objects-----------------------------------------------------------------

//Spiral parameters; these parameters have been derived by simple trial and error - just try to play around yourself a bit!

#declare ExponentialFactor = 0.01045; 							//The exponential factor for all three exponential equations;  
#declare ScalingFactorY = 0.105; 							//Scaling factor for the equation determining the distance along the y-axis.  
#declare ScalingFactorR = 0.0355; 							//Scaling factor for the equation determining the radial extension. 
#declare ScalingFactorW = 0.04; 							//Scaling factor for the equation determining the shell width. 



#declare YStart = 3.9;                                      //Starting position on y-axis

blob {
	threshold 0.6
	
	#declare ticker = 0;
	#while (ticker < 400)
	
	
		#declare Angle = 5.5 * ticker; 						//Our snail will be composed of spheres rotated by increments of 5.5 degrees
		
		#declare RadialExt = ScalingFactorR * exp (ExponentialFactor*ticker);			
		#declare DistanceY = ScalingFactorY * exp (ExponentialFactor*ticker);
		#declare ShellWidth = ScalingFactorW * exp (ExponentialFactor*ticker);
		
		
		sphere { <0, 0, 0>, 1.2*ShellWidth , 0.3       				// This sphere produces the solid shell
			translate <RadialExt, YStart - DistanceY, 0>
			rotate <0, Angle, 0>
			pigment {
				color rgb<255/255, 160/255, 50/255>
			}
		}
	
	
		sphere { <0, 0, 0>, 0.9*ShellWidth , -1             				// And this sphere is substracted and produces the inner void
			translate <0.9*RadialExt, YStart - DistanceY, 0>
			rotate <0, Angle, 0>
			pigment {
				color rgb<255/255, 255/255, 255/255>   			// solid color pigment
			}
		}
	
	
		// Decorations - "spikes"
		
		#if (mod(ticker, 10) = 0)    						// the mod-function returns the residue of a division (here ticker divided by 10). This residue equals 0 only for 10, 20, 30 etc. 
		                                                    //Therefore a spike is inserted only every 10th turn. 
		// OR #if (!mod(ticker, 10))  
		
			sphere { <0, 0, 0>, ShellWidth/3 , 0.5
				scale <4, 1, 1>
				translate <ShellWidth, 0, 0>                    // Here the position is placed on the outer side of the shell ...
				rotate <0, 0, 50>                          		// ... and rotated around the shell. This rotation around the z-axis produces the upper row of spikes  ...
				translate <RadialExt, YStart - DistanceY, 0>
				rotate <0, Angle, 0>
				pigment {
					color rgb<20/255, 0/255, 0/255>   		// solid color pigment
				}
			}
			
			sphere { <0, 0, 0>, ShellWidth/3 , 0.5
				scale <4, 1, 1>
				translate <ShellWidth, 0, 0>
				rotate <0, 0, -15>                       		// ... and this rotation around the z-axis produces the lower row of spikes
				translate <RadialExt, YStart - DistanceY, 0>
				rotate <0, Angle, 0>
				pigment {
					color rgb<20/255, 0/255, 0/255>   		// solid color pigment
				}
			}
		
		#else
		#end 									// end if
		
		
		#declare ticker = ticker + 1;
	#end 										// end while
} 											// end blob




//Decorations - stripes

//We need a second blob for the stripes, otherwise their colors would get mixed up with the main blob's color. 

blob {
  threshold 0.6

#declare ticker = 0;
	#while (ticker<396)								//Since this is a new loop, we also have to define the functions for our shell parameters once again. We want to obtain the same logarithmic spiral, so we take the same equations.
	
		#declare Angle = 5.5 * ticker;
		
		#declare RadialExt = ScalingFactorR * exp(ExponentialFactor*ticker);
		#declare DistanceY = ScalingFactorY * exp(ExponentialFactor*ticker);
		#declare ShellWidth = ScalingFactorW * exp(ExponentialFactor*ticker);
		
		#declare ticker2 = 0;
		#while (ticker2< 10)
			sphere { <0, 0, 0>, 0.1*ShellWidth , 1					
				scale <1, 0.5 4>
				translate <0.8*ShellWidth, 0, 0>				// Here the position is placed on the outer side of the shell ...
				rotate <0, 0, -25+ticker2*10>          			// ... and rotated around the shell. This loop produces 10 different rotation angles with 25 degrees difference, i.e. 10 stripes.
				translate <RadialExt, YStart - DistanceY, 0>
				rotate <0, Angle, 0>
				pigment {
					color rgb<20/255, 0/255, 0/255>
				}
			}
			
			#declare ticker2 = ticker2 + 1;
		#end 									// end inner while
		
		#declare ticker = ticker + 1;
	#end // end outer while
} 											// end blob