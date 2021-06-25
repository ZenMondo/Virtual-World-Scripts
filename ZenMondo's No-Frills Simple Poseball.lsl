///////////////////////////////////////////
// ZenMondo's No-Frills Simple Poseball
//
//  Drop a single animation and this script
//  in the object to be sat upon.
//  Set your Sit Target in line 19
//////////////////////////////////////
 
 
// Set this to hide or not hide
// poseball when sat upon.
// TRUE will hide the poseball
// FALSE will not hide the poseball
integer hide = FALSE;
 
default
{
    state_entry()
    {
        llSitTarget(<0.0, 0.0, 0.5>, ZERO_ROTATION);  //Position where Avatar will Sit
    }
 
     changed(integer change)
    {
        if(change & CHANGED_LINK) // will be triggered if sat upon
        {
         
            key avatar = llAvatarOnSitTarget();
               
           
            if(avatar != NULL_KEY) //We have an avatar sitting
            {
                if(hide)
                {
                    llSetLinkAlpha(LINK_THIS, 0.0, ALL_SIDES);
                }
       
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
                // Permision to animate will be granted automatically
                // When sat upon so we skip the run_time_permissions()
                // event handler and assume permission is set  
               
                llStopAnimation("sit");
                llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
               
            }
           
            else //probably just stood up
            {
                llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));            
                if(hide)
                {
                    llSetLinkAlpha(LINK_THIS, 1.0, ALL_SIDES);
                }
            }
                 
        }
    }
}
