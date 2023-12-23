// Persistence of Vision Ray Tracer Scene Description File
// File: SnailShell.pov

#version 3.5; // current version is 3.8

/* 
Information on Pov-Ray:
 
My personal introduction into Pov-Ray was the excellent book "3D-Welten, professionelle Animationen und fotorealistische Grafiken mit Raytracing" from 
Toni Lama by Carl Hanser Verlag München Wien, 2004. Apart of that I recommend the Pov-Ray-homepage (http://www.povray.org).

Further information on Pov-Ray can be found at https://sus.ziti.uni-heidelberg.de/Lehre/WS2021_Tools/POVRAY/POVRAY_PeterFischer.pdf,  
https://wiki.povray.org/content/Main_Page, https://de.wikibooks.org/wiki/Raytracing_mit_POV-Ray or, in german language, here: https://www.f-lohmueller.de/pov_tut/pov__ger.htm
*/

 

//-------------------------------------------------------------Scene settings (Camera, light, background)---------------------------------------------------------


global_settings {
    assumed_gamma 1.0
    max_trace_level 5
}


#declare Kamera = camera {
    location  <10, 11, -10 > *0.6
    look_at   <0, -1,  0>
}

camera {Kamera}

sky_sphere {pigment {rgb 1}}

// create a regular point light source
light_source {
  0*x                  // light's position (translated below)
  color rgb <1,1,1>    // light's color
  translate <-60, 70, 20>
}



/*
---------------------------------------------------Modeling approach---------------------------------------------- 

In the first part of the script a leaf from an Aeonium-plant is modeled by using a blob composed of several spheres with positive and negative 
field strength. This model was done completely by try and error. 

For positioning the leaves of our plantlet, we are defining a spiral. It is somewhat similar to the spiral from the snail shell, but this time the radial extension (distance from 
the center) increases in a linear way in rather small amounts. We will use the golden angle (137.5 degrees) for placing elements on this spiral. 
Originally I had included the (small) plant shoot and the leaf stalks in this model, but for sake of simplicity, here I will focus 
exclusively on positioning the leaves. 

As in the example of the snail shell the spiral is not completely flat. In this case y-coordinates are first increasing slightly and 
then decreasing, which was achieved by fitting a mixed quadratic equation to the task (completely by try and error). 

Apart from defining the positions where to place the leaves, next we have to scale and tilt the leaves: Scaling: With increasing age (or increasing 
ticker in the loop) leaves become larger, thats clear. But they also become wider. The initial, young leaves are pretty elongate, older leaves are 
rather laminar. Therefore we have to use different factors for scaling leaves in different dimensions and changing in different ways during the loop. 
Tilt: Young leaves are rather upright, old leaves are rather inflected. 

Our leave object is located on the x-axis with its base (where the leaf stalk should be) on the origin. For tilting the leaf, we have to rotate around the z-axis, 
for changing its with scaling along the z-axis. 

I defined the texture of the leaf in the loop, not within the leaf object. This gives us the opportunity to change the texture in the course of the loop. (Give old leaves 
another texture than young leaves. I didn't do this, but you might try.  
*/

//--------------------------------------------The leaf used for the plant------------------------------------------------------------------

#declare Leaf = blob {                                                        //The leaf lies on the x-axis, with its base on the origin
              
    threshold 0.6                                                             //the parts of this blob have been defined by try and error
  
    sphere { < 0,   0,    0>, 1, 1 
        scale <3, 0.15, 1.5>
    }

    sphere { < 1.5,   0,    1.9>, 2, -1 
    }

    sphere { < 1.5,   0,    -1.9>, 2, -1 
    } 

    sphere { < 0,   0,    0>, 1, 1 
        scale <1.4, 0.09, 0.29>
        translate <0, 0.025, 0>
    }
  
    scale <1, 1, 1.4> 
    translate <1.35, 0, 0>
} 
  

//--------------------------------------------The loop for scaling, tilting and positioning the leaves------------------------------------------------------------------

#declare LeafNumber = 45;                                                                            //Here I have defined the number of leaves, for you to be able to change this easily. All the other parameters further down can also be changed, of course.

#declare ticker = 0;
#while (ticker <LeafNumber)                                                                         //ticker corresponds to the age of leaves

    #declare P1 =  <0.015 + ticker * 0.03, 1 - ticker * ticker*0.00065 + ticker * 0.025, 0>;     //Here the position of the leaves is defined: P1. The radial distance from the center increases in a linear way within the loop
                                                                                                 //The y-coordinate, in contrast, first increases slightly, then decreases. Parameters of this equation have been found by try and error. 
    #declare P1 = vrotate (P1, <0, ticker * (-137.5), 0>);                                      //rotation by the golden angle

    #declare ScalingFactor = 0.25 + 0.0008 * ticker * ticker;                                 //Scaling of leaves: The basic ScalingFactor increases quadratically with leaf age. But it will be applied differently to length, thickness and width. 

    object {Leaf
        scale <ScalingFactor, 1 + ScalingFactor * 0.5, ScalingFactor + ScalingFactor * ticker * 0.007 >   //Scaling along the x-axis applies to the length of the leaf, scaling along the y-axis to its thickness and scaling along the z-axis to its width
        rotate <0, 0, 85/(0.001+ticker/3)- ticker *0.12>                                                        //Rotation around the z-axis; tilting the leaf 
        rotate <0, ticker * (-137.5), 0>                                                                   //Rotation around the y-axis; adding the right rotation according to its position on the spiral
        translate  P1                                                                                      //Placing the leaf onto its position.
        texture {
            pigment {
                color rgb <137/255,182/255,25/255>     
            } 
            normal {
                agate 0.10           
                agate_turb 0.8   
                scale 0.5
            }   
            finish {
                ambient 0.1          
                diffuse 0.6          
                specular 0.3      
            } 
        }
    }

    #declare ticker = ticker + 1;
#end 



