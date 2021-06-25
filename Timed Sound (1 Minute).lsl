// Will play the first sound in an object's inventory every 60 seconds
// No controls whatsoever so spammy as hell, the only way to get it to be quiet
// is to pick up the object or set the script to not running.
// Basically just an example for playing a sound and using the timer event
 
default
{
    state_entry()
    {
        llPlaySound(llGetInventoryName(INVENTORY_SOUND, 0), 1.0);
        llSetTimerEvent(60);
    }
 
    timer()
    {
       llPlaySound(llGetInventoryName(INVENTORY_SOUND, 0), 1.0);
    }
}
 
