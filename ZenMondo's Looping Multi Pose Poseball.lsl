integer num_animations;
integer animating;
string current_anim;
integer anim_counter;

integer handle;



default
{
    state_entry()
    {
        num_animations = llGetInventoryNumber(INVENTORY_ANIMATION);        
        llListen(1, "", NULL_KEY, "");  // For "show" and "hide" commands
        llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);  //Position where Avatar will Sit
        anim_counter = 0;

    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message == llToLower("hide"))
        {
            llSetAlpha(0.0, ALL_SIDES);   
            return;
        }
        
        else if(message == llToLower("show"))
        {
            llSetAlpha(1.0, ALL_SIDES);   
            return;
        }  
    }

    changed(integer change)
    {
        if(change & CHANGED_LINK) // will be triggered if sat upon
        {
          
            key avatar = llAvatarOnSitTarget();
                
            
            if(avatar != NULL_KEY) //We have an avatar sitting
            {
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
                
                llSetAlpha(0.0, ALL_SIDES);
                
                anim_counter  = 0;
                llStopAnimation("Sit");
                current_anim = llGetInventoryName(INVENTORY_ANIMATION, anim_counter);
                llStartAnimation(current_anim);
                animating = TRUE;
                llSetTimerEvent(30);
                
            }
            
            else //probably just stood up
            {
               
                if(animating == TRUE)
                {
                    llStopAnimation(current_anim); 
                    animating = FALSE;
                    llSetTimerEvent(0);
                }
                
                llSetAlpha(1.0, ALL_SIDES);
            }
                  
        } 
        
        if(change & CHANGED_INVENTORY) //Something Added or removed. Lets just assume an animation
        {
            num_animations = llGetInventoryNumber(INVENTORY_ANIMATION);
        }        
    }
    
    
    timer()
    {
        anim_counter ++;
        if(anim_counter == num_animations)
        {
            anim_counter = 0;
        }
        
        llStopAnimation(current_anim);
        current_anim = llGetInventoryName(INVENTORY_ANIMATION, anim_counter);
        llStartAnimation(current_anim);   
    }
    
    on_rez(integer start_param)
    { 
        llResetScript(); 
    }
}
