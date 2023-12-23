// Persistence of Vision Ray Tracer Scene Description File
// File: Erythrocyte.pov

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
    max_trace_level 5
}

#declare Cameraz = camera {
    location  <1, 4, -12> *0.8
    look_at   <0, 0,  0>
}

camera {Cameraz}

sky_sphere {pigment {rgb 1}}

// create a regular point light source
light_source {
  0*x                  
  color rgb <1,1,1>    
  translate <100, 100, -30>
} 
light_source {
  0*x                  
  color rgb <1,1,1>    
  translate <100, 10, -10>
}  

/*
---------------------------------------------------Modeling approach---------------------------------------------- 

Erythrocytes are simple, round platelets with a thickened rim including some distortions. I am using a simple planar, polar distribution to model them and two arbitrarily chosen
positions to distort the whole arrangement. The script is divided into two parts. In the first part the positions are defined and stored in an array, in the second part the 
positions from the array are filled with metaballs for a blob. The problem with arrays is that you have to know in advance, how many positions you want to store. 
(Arrays with insufficient spaces will result in error messages.) Accordingly the first step in part 1 is estimating the number of positions and defining an array. 
*/ 


//--------------------------------------------Positions-----------------------------------------------------------------

//The basic structure consists of several concentric rings with increasing numbers of elements. First let's define some features: 

#declare NumberRings = 6;                                                               //Number of rings
#declare Distance = 0.56;                                                           //Distance of rings
#declare InitialAngle = 30;                                                         //Angles between elements in the inner-most ring
#declare IF1 = <3.8, 0, 3.8>;                                                       //Interference 1
#declare IF2 = <-3.8, 0, 3.8>;                                                      //Interference 2

//Data will be stored in a two-dimensional array. The first dimension will refer to the various circles. Therefor its size corresponds to the number of rings (NumberU)
//The second dimension will refer to the elements in one ring. Since the outer-most ring contains the largest amount of elements we take the number of these elements 
//as the maximum threshold for the size of the second dimension. 

#declare FinalAngle = InitialAngle/NumberRings;                                        //Angles between elements in the outer-most circle
#declare OuterElementsMax = 360/FinalAngle;                                        //Number of elements in the outer-most circle 

#declare Positions = array [NumberRings][OuterElementsMax];                             // Here the array is defined.

//Positions are defined in two nested loops: The outer loop passes through the various circles, the inner loop through the various elements belonging to one given circle. 
 
#declare ticker = 0;
#while (ticker <NumberRings) 

    #declare Radius = ticker * Distance;                                            //Radius refers to the actual radius of the various rings
    
    #if (ticker = 0)                                                                //This if-statement is used to avoid problems at the origin. Here ticker and Radius equal zero 
        #declare dAngle = 360; 
    #else
        #declare dAngle = InitialAngle/ticker; 
    #end
    
    #declare NumberElements = 360/dAngle;                                               //Here the number of elements for each ring is calculated
    #declare ticker2 = 0;                                                               //This second loop finds positions for each element from a given ring. 
    
    #while (ticker2 <NumberElements)
        #declare Angle = ticker2 * dAngle; 
        #declare P1 = <Radius, 0, 0>;
        #declare P1 = vrotate (P1, <0, Angle, 0>);
        #declare YShift = 6*(1/(vlength(P1-IF1)) - 1/(vlength(P1-IF2)));                 //Here the deviation of the y-coordinate in dependance on the distance to the interfering points IF1 and IF2 is defined
        #declare P1b = P1 + <0, YShift, 0>;                                              //And here this deviation is applied.

        #if (vlength(P1)>0 & vlength(P1b)>0)                                             //This if-statement is used to exclude the origin
            #declare P1c = P1b*vlength(P1)/vlength(P1b);				//correction of the new, distorted positions 
        #else
            #declare P1c = P1b;
        #end

        #declare Positions[ticker][ticker2] = P1c;					//stores the positions into the array.

    #declare ticker2 = ticker2 + 1;
    #end										//end of inner loop

#declare ticker = ticker + 1;
#end											//end of outer loop


//----------------------------------------------Objects (Blob)---------------------------------------------

// Definition of two normals for the blob texture

#declare Normal1 =     normal {
    agate 0.4         // any pattern optionally followed by an intensity value [0.5]
    scale 4.8       // any transformations
}

#declare Normal2 =     normal {
    crackle 0.8         // any pattern optionally followed by an intensity value [0.5]
    //bump_size 2.0   // optional
    //accuracy 0.02   // changes the scale for normal calculation [0.02]
    scale 0.01       // any transformations
}

//Definition of the blob: the loops are defined in the same way as above. Within the loops positions are taken from the array and used for placing metaballs constituting the blob. 

blob {
    // threshold (0.0 < threshold <= StrengthVal) surface falloff threshold #
    threshold 0.6

    #declare ticker = 0;
    #while (ticker <NumberRings)

        #if (ticker = NumberRings-1)//Ery-Border
            #declare RadiusSphere = 1.2;
        #else
            #declare RadiusSphere = 0.75;
        #end

        #declare Radius = ticker * Distance;

        #if (ticker = 0) 
            #declare dAngle = 360; 
        #else
            #declare dAngle = 30/ticker; 
        #end 

        #declare NumberElements = 360/dAngle;

        #declare ticker2 = 0;
        #while (ticker2 <NumberElements)
           
            #declare P1 = Positions [ticker][ticker2]; 				//Positions are extracted from the array
            sphere { <0, 0, 0>, RadiusSphere, 1 				//Metaballs are placed on these positions
                translate P1
            }  

        #declare ticker2 = ticker2 + 1;
        #end

    #declare ticker = ticker + 1;
    #end

    texture{									//Here comes the texture of the erythrocyte
        pigment {
            color rgbt <1,0,0>     // solid color pigment
        }
        // texture component
        normal {
            average
            normal_map {
                [1, Normal1 ]
                [1, Normal2 ]
            }
        } 
// control an object's surface finish
        finish {
            ambient 0.2          // ambient surface reflection color [0.1]
            // (---diffuse lighting---)
            diffuse 1.2         // amount [0.6]
            brilliance 1       // tightness of diffuse illumination [1.0]
            // (---phong highlight---)
           specular 0.3
           // phong 0.5          // amount [0.0]
           // phong_size 80      // (1.0..250+) (dull->highly polished) [40]
        } // finish

    }
}



