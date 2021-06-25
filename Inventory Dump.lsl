//////////////////////
//Inventory Dump by ZenMondo Wormser
//
// Just place in a prim, along with the inventory items to be given.
// To retrieve the inventory, just touch the prim.
// Contents will be given in a folder named what you want by changing
// a line below (default is Inventory Dump).
//////////////////////
 
// Change "Inventory Dump"  to the name of the folder you want the object to give.(keep the quotes)
string folder_name = "Inventory Dump";
 
 
default
{
   
 
    touch_start(integer total_number)
    {
        integer counter = 0;
        integer inventory_num = llGetInventoryNumber(INVENTORY_ALL);
       
        list inventory_list;
       
        while(counter < inventory_num)
        {
            inventory_list = (inventory_list=[]) + inventory_list + llGetInventoryName(INVENTORY_ALL, counter);
            counter ++;
        }
       
        list scriptname = [llGetScriptName()];
       
        integer index = llListFindList(inventory_list, scriptname);
       
        inventory_list = llDeleteSubList(inventory_list, index, index);
       
       
        llGiveInventoryList(llDetectedKey(0), folder_name, inventory_list);
       
       
       
    }
}
 
