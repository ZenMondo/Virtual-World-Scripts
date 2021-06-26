///////////////////////////////////////////////////////////////////////
// ZenMondo's Touch-n-Go Animator
//
// Animates a texture when clicked, and stops when clicked again.
//
//////////////////////////////////////////////////////////////////////
 
 
integer isAnimating;
integer haveTexture;
 
//Face of prim to display texture
integer side = 2;
 
//Number of Frames in animation texture
// x_frames = horizontal frames
// y_frames = vertical frames
integer x_frames = 12;
integer y_frames = 1;
 
//Start of Animation  0.0 is the first frame
float start = 0.0;
 
//length of animation 0.0 if you want it to loop back to the begining.
float length = 0.0;
 
//Rate in frames per second.
float rate = 10.0;
 
default
{
    state_entry()
    {
        string texture = llGetInventoryName(INVENTORY_TEXTURE, 0);
       
        if(llGetInventoryType(texture) == INVENTORY_TEXTURE) // test to see if texture is in inventory.
        {
            llSetTexture(texture, side);
            llSetTextureAnim(ANIM_ON | LOOP, side, x_frames, y_frames, start, length, rate);
            isAnimating = TRUE;
            haveTexture = TRUE;
        }
       
        else
        {
            llWhisper(0, "There is not a texture present in inventory.");
            llSetTextureAnim( FALSE , side, 1, 1, 0, 0, 0.0 ); //Turn off the Animation.
            haveTexture = FALSE;
        }  
    }
 
    touch_start(integer total_number)
    {
        if(haveTexture)
        {
            if(isAnimating)
            {
                llSetTextureAnim(ANIM_ON, side, x_frames, y_frames, -1.0, 0.0, rate); //Freeze Animation on the first frame.
                isAnimating = FALSE;
            }
       
            else
            {
                llSetTextureAnim(ANIM_ON | LOOP, side, x_frames, y_frames, start, length, rate);
                isAnimating = TRUE;
            }
        }    
    }
   
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY || change & CHANGED_TEXTURE)
        {
            llResetScript();
        }
    }
}
