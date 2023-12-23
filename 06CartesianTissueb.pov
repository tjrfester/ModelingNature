// Persistence of Vision Ray Tracer Scene Description File
// File: CartesianTissueb.pov

#version 3.6; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm
*/ 
 
 
//-----------------------------------Scene settings (Camera, light, background, random streams)-------------------------------------------------

global_settings {
  assumed_gamma 1.0
  max_trace_level 5
}

#declare Hauptkamerax = camera {
  location  <-20, 30, 30>
look_at   <11, 8,  11>
rotate <0, 0, 0>}

camera {Hauptkamerax}

// create a regular point light source
light_source {
  0*x                  // light's position (translated below)
  color rgb <1,1,1>    // light's color
  translate <-5, 50, 80>
}

light_source {
  0*x                  // light's position (translated below)
  color rgb <1,1,1> *0.2   // light's color
  translate <-30, 7, 0>
}

//Initialize random streams
#declare chance1 = seed (3);
#declare chance2 = seed (8);
#declare chance3 = seed (5);

/*
The following script first defines a cartesian distribution of elements modified by a certain degree of random variation. The positions are then filled with yellow spheres. 
In a second step a large blob is defined, where spheres at the positions just specified are substracted from a large sphere. The resulting structure is then cut by a cube
in order to better show the internal structure. 
*/

//----------------------------Definition of a cartesian distribution-------------------------------------------
                                                                            
//Below the parameters of the xyz-distribution are defined. You may change these parameters, but then you might also want to change the diameter of the large sphere used for the blob and the settings of the cube used for cutting. 

#declare NumberX = 11;                                                                          //Definition of the number of elements along the x-, y- and z-axis 
#declare NumberZ = 11; 
#declare NumberY = 11;  

#declare DistanceX = 2;                                                                         //Definition of the distances between elements along these axes  
#declare DistanceY = 2;  
#declare DistanceZ = 2; 

#declare Var = 2;                                                                               //This parameter defines the extent of random variation 

#declare Positions = array [NumberZ* NumberY* NumberX]                                          //This is the array storing the positions of the cartesian distribution

#declare counter = 0;                                                                           //Three nested loops for defining the 3D-cartesian distribution 

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
            #declare Positions [counter] = P1;                                                  //The positions are stored in the array.

            #declare counter = counter + 1;  

        #declare tickerx = tickerx + 1; 
        #end  
  
    #declare tickery = tickery + 1; 
    #end

#declare tickerz = tickerz + 1; 
#end


//The following box is used to prevent the outer layer of spheres from being displayed. 

#declare Limit = box { 
    <0, 0, 0>, <20, 20, 20> 
};   


//In the following loop positions are extracted from the array and used for placing spheres

#declare ticker = 0; 
#while ( ticker <counter)                                                                       //This loop extracts all positions from the array.
    #declare P1 = Positions [ticker];
    #if (inside (Limit, P1) = 1)                                                                //Here the outer layer of spheres is prevented from being displayed
    
        sphere {
            <0, 0, 0>, 0.88
            translate P1
            texture {
                pigment {
                    color rgb <1,0.6,0>     // solid color pigment
                }
                finish {
                    ambient 0.2          // ambient surface reflection color [0.1]
                    diffuse 1.2          // amount [0.6]
                    brilliance 1       // tightness of diffuse illumination [1.0]
                    specular 0.2       // amount [0.0]
                    roughness 0.9     // (~1.0..0.0005) (dull->highly polished) [0.05]
                } // finish
            }

        }
    #else
    #end
#declare ticker = ticker + 1; 
#end


//Below a blob is defined by substracting spheres placed on the positions defined above from a very large sphere. This blob is then cut by a cube to make the inner shape visible. 

intersection {

    blob {
        threshold 0.5 
    
        sphere {                                                                                 //This is the very large sphere
            <11, 11, 11>, 40, 1
        } 
       
        #declare ticker = 0; 
        #while ( ticker <counter)                                                                //Again positions are extracted from the array. 
            #declare P1 = Positions [ticker];
  
            sphere {                                                                             //These spheres are substracted 
                <0, 0, 0>, 1.76, -1 
                translate P1
            }    
        #declare ticker = ticker + 1; 
        #end
    } 

    box {                                                                                        //This box is used for cutting the blob. 
        <0, 0, 0>, <20, 20, 20> 
        texture {
            pigment {
                color rgb <0.3,0.7,0>     // solid color pigment
            }
            normal {
                bumps 1        // any pattern optionally followed by an intensity value [0.5]
                bump_size 0.5   // optional
                scale 0.05       // any transformations
            }
            finish {
                ambient 0.2          // ambient surface reflection color [0.1]
                diffuse 0.3         // amount [0.6]
                brilliance 1       // tightness of diffuse illumination [1.0]
                specular 0.1       // amount [0.0]
                roughness 0.9     // (~1.0..0.0005) (dull->highly polished) [0.05]
            } // finish
        } 
    }  
    
    texture {
        pigment {
            color rgb <0.1,0.5,0.>     // solid color pigment
        }
        normal {
            bumps 1        // any pattern optionally followed by an intensity value [0.5]
            bump_size 0.5   // optional
            scale 0.05       // any transformations
        }
        finish {
            ambient 0.2          // ambient surface reflection color [0.1]
            diffuse 0.6         // amount [0.6]
            brilliance 1       // tightness of diffuse illumination [1.0]
            roughness 0.9     // (~1.0..0.0005) (dull->highly polished) [0.05]
        } // finish
    }
} 

#declare Limit = box { 
    <0, 0, 0>, <20, 20, 20> 
};   





