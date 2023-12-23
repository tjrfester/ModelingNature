// Persistence of Vision Ray Tracer Scene Description File
// File: Cartesian.pov

#version 3.6; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm
*/ 
 
 
//-----------------------------------Scene settings (Camera, light, background, coordinate system)-------------------------------------------------


global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}



#declare Camera = camera {
    location  <4.5, 3, -6>
    look_at   <4.5, 3,  0>
}

background {color rgb <1, 1, 1>}

camera {Camera}

// create a regular point light source
light_source {
    0*x                  // light's position (translated below)
    color rgb <1,1,1>    // light's color
    translate <10, 10, -30>
}

light_source {
    0*x                  // light's position (translated below)
    color rgb <0.6,0.6,0.6>    // light's color
    translate <0, 0, -10>
}  


//Initialize random streams
#declare chance1 = seed (3);
#declare chance2 = seed (8);
#declare chance3 = seed (5);



/*The following script uses three nested loops to generate a regular 3D-cartesian distribution. In the beginning there is the possiblity to define the number and distance of elements in all three dimension. 
Then the distribution is generated and labeled by spheres. 

Combined with random numbers, this distribution can be used to generate more or less random backgrounds.  

*/


//---------------------------Objects-----------------------------------------------------------------

//Definition of the number of elements along the x-, y- and z-axis

#declare NumberX = 10; 
#declare NumberZ = 4; 
#declare NumberY = 7;  


//Definition of the distances between elements along these axes

#declare DistanceX = 1;  
#declare DistanceY = 1;  
#declare DistanceZ = 1; 


//Definition of the starting position on each axis 

#declare XKoor = 0; 
#declare YKoor = 0; 
#declare ZKoor = 0;  

#declare Var = 2;

//Three nested loops for defining the 3D-cartesian distribution

#declare tickerz = 0; 
#while (tickerz < NumberZ )


    #declare ZKoor = tickerz * DistanceZ; 

    #declare tickery = 0; 
    #while (tickery < NumberY) 

        #declare YKoor = tickery * DistanceY; 

        #declare tickerx = 0; 
        #while (tickerx < NumberX) 

            #declare XKoor = tickerx * DistanceX;
            #declare P1 = <XKoor, YKoor, ZKoor>;                                                //The positions of the cartesian distribution are calculated
            #declare P1 = P1 + Var * (<rand(chance1), rand(chance2), rand(chance3)>-0.5);        //The positions are modified by random variation

            sphere { <0,0,0>, 0.1
                texture { pigment{ color rgb<0, 0, 1>}
                    finish { phong 1.0 reflection 0.00}
                } // end of texture
                scale<1,1,1>  rotate<0,0,0>  translate P1
            }  // end of sphere ----------------------------------- 

        #declare tickerx = tickerx + 1; 
        #end  

    #declare tickery = tickery + 1; 
    #end

#declare tickerz = tickerz + 1; 
#end

