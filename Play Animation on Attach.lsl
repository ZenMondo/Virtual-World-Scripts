default
{
   
   
     attach(key attached)
    {
        if (attached != NULL_KEY)   // object has been //attached//
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
         
        }
        else  // object has been detached
        {
            llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));            
        }
    }
}
 
