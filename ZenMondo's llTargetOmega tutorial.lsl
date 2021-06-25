integer isSpinning;
 
 
//axis is in format <X, Y, Z> put a 1 in the axis around which you wish
//to rotate and a 0 in the axis you do not wish to rotate
vector axis = <0,0,1>;  
 
//spinrate is how fast you wish it to rotate.
// This is in radians per second. (There are 2 * PI Radians in a circle)
float spinrate = 3.0;
 
//Gain is used for phyiscal rotation. In a non-physical prim it still
//needs to be a non-zero value but has no other effect.
float gain = 1.0;
 
default
{
   
    touch_start(integer total_number)
    {
        if(isSpinning)
        {
            llTargetOmega(<0,0,0>, 0.0, 0.0); //Stop Spinning
            isSpinning = FALSE;
        }
       
        else
        {
            llTargetOmega(axis, spinrate, gain); //Start Spinning
            isSpinning = TRUE;
        }
       
    }
}
