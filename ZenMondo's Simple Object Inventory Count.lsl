///////////////////////////////////////////
// ZenMondo's Simple Object Inventory Count
//
//  Place this script in an object and touch it to say how many items are in its inventory.
//
//////////////////////////////////////////////
 
 
default
{
   
    touch_start(integer total_number)
    {
        integer inventory_num = llGetInventoryNumber(INVENTORY_ALL);
        llSay(0, "This Object conatins " + (string)inventory_num + " items in its inventory including this script.");
    }
}
 
