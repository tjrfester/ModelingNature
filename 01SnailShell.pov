// Persistence of Vision Ray Tracer Scene Description File
// File: ?.pov

#version 3.6; // current version is 3.8

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


//---------------------------Spiral parameters-----------------------------------------------------------------

//Spiral parameters; these parameters have been derived by simple trial and error - just try to play around yourself a bit!

#declare Inclination = 0.01045; 							//The main variable for the exponential function used. 
#declare HeightVariable = 0.105; 							//This variable affects the extension of the spiral in y-direction 
#declare RadiusVariable = 0.0355; 							//This variable affects the extension of the spiral perpendicular to the y-direction
#declare ThicknessVariable = 0.04; 							//This variable affects the "thickness" of the snail body

//Starting position on y-axis
#declare YStart = 3.9;

//--------------------------Objects-----------------------------------------------------------------------------

union {											//This union contains the complete snail shell
	blob {											//This blob contains the empty snail shell without the stripes
		threshold 0.6
	
		#declare ticker = 0;
		#while (ticker < 400)
	
	
			#declare Angle = 5.5 * ticker; 						//Our snail will be composed of spheres rotated by increments of 5.5 degrees
		
			#declare Radius = RadiusVariable * exp (Inclination*ticker);			
			#declare DeltaY = HeightVariable * exp (Inclination*ticker);
			#declare Gauge = ThicknessVariable * exp (Inclination*ticker);
		
		
			sphere { <0, 0, 0>, 1.2*Gauge , 0.3       				// This sphere produces the solid shell
				translate <Radius, YStart - DeltaY, 0>
				rotate <0, Angle, 0>
				pigment {
					color rgb<255/255, 160/255, 50/255>
				}
			}
	
	
			sphere { <0, 0, 0>, 0.9*Gauge , -1             				// And this sphere is substracted and produces the inner void
				translate <0.9*Radius, YStart - DeltaY, 0>
				rotate <0, Angle, 0>
				pigment {
					color rgb<255/255, 255/255, 255/255>   			// solid color pigment
				}
			}
	
	
			// Decorations - "spikes"
		
			#if (mod(ticker, 10) = 0)    						// a spike is inserted every thenth element
			// OR #if (!mod(ticker, 10))  
		
				sphere { <0, 0, 0>, Gauge/3 , 0.5
					scale <4, 1, 1>
					translate <Gauge, 0, 0>
					rotate <0, 0, 50>                          		// This rotation produces the upper row of spikes
					translate <Radius, YStart - DeltaY, 0>
					rotate <0, Angle, 0>
					pigment {
						color rgb<20/255, 0/255, 0/255>   		// solid color pigment
					}
				}
			
				sphere { <0, 0, 0>, Gauge/3 , 0.5
					scale <4, 1, 1>
					translate <Gauge, 0, 0>
					rotate <0, 0, -15>                       		// and this rotation produces the lower row of spikes
					translate <Radius, YStart - DeltaY, 0>
					rotate <0, Angle, 0>
					pigment {
						color rgb<20/255, 0/255, 0/255>   		// solid color pigment
					}
				}
		
			#else
			#end 									// end if
		
		
			#declare ticker = ticker + 1;
		#end 										// end while
	} 											// end blob (snail shell with spikes)




	//Stripes


	blob {
  	threshold 0.6

	#declare ticker = 0;
		#while (ticker<396)								//This loop produces the same spiral as above
	
			#declare Angle = 5.5 * ticker;
		
			#declare Radius = RadiusVariable * exp(Inclination*ticker);
			#declare DeltaY = HeightVariable * exp(Inclination*ticker);
			#declare Gauge = ThicknessVariable * exp(Inclination*ticker);
		
			#declare ticker2 = 0;
			#while (ticker2< 10)
				sphere { <0, 0, 0>, 0.1*Gauge , 1					
					scale <1, 0.5 4>
					translate <0.8*Gauge, 0, 0>				//Spheres are not positioned at the center of the spiral but on the rim of the spiral
					rotate <0, 0, -25+ticker2*10>          			// This rotation produces the various stripes
					translate <Radius, YStart - DeltaY, 0>
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
}												//end union
