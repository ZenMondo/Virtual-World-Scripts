////////////////////////////////////////////////
// Play Animation  and  loop sounds on Attach
// CodePoetry by ZenMondo Wormser
//
// Place an animagtion and any number of sounds in the object's inventory.
// A looping animston is best
//
// Attach the object anywhere to trigger the animation and start playing the sounds.
//
// Sounds will pick up from last played when re-attached.
//
//////////////////////////////////////////////////////////


integer num_sounds;
float sound_length = 10.0; //Length of Sound clips in seconds
integer sound_counter = 0;

default
{
    
    
     attach(key attached)
    {
        if (attached != NULL_KEY)   // object has been //attached//
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            num_sounds = llGetInventoryNumber(INVENTORY_SOUND);
            llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
            llPlaySound(llGetInventoryName(INVENTORY_SOUND, sound_counter), 1.0);
            llSetTimerEvent(sound_length);
         
        }
        else  // object has been detached
        {
            llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
            llSetTimerEvent(0.0);
        }
    }
    
    timer()
    {
        sound_counter++;
        if(sound_counter == num_sounds) //out of sounds
        {
            sound_counter = 0;   //loop back to begining
        }  
        
        llPlaySound(llGetInventoryName(INVENTORY_SOUND, sound_counter), 1.0);
    }
}
