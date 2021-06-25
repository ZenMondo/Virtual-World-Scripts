///////////////////////
// ZenMondo's fancy note giver by ZenMondo Worsmer
//
//  On touch, will say a message, give a noteacard,
//  if there is a sound in the object's inventory, play it
//  and IM the owner that it has been touched and by whom.
//////////////////////
 
 
// This is the message that will be spoken when touched.
string say_this  = "Thank you for touching me.\n Enjoy your noteacard.";
 
default
{
   
 
    touch_start(integer total_number)
    {
        llSay(0, say_this);
        llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_NOTECARD, 0));
       
        if(llGetInventoryNumber(INVENTORY_SOUND))
        {
            llPlaySound(llGetInventoryName(INVENTORY_SOUND, 0), 1.0);
        }
       
        llInstantMessage(llGetOwner(), llDetectedName(0) + " has touhced me.");
       
    }
}
 
