//////////////
// Reset All Scripts by ZenMondo Wormser
//
// Drop in an object to reset all scripts
// This script deletes itself when done
////////////
 
 
default
{
    state_entry()
    {
        integer counter = 0;
        integer inventory_num = llGetInventoryNumber(INVENTORY_SCRIPT);
       
        list inventory_list;
       
        while(counter < inventory_num)
        {
            inventory_list = (inventory_list=[]) + inventory_list + llGetInventoryName(INVENTORY_SCRIPT, counter);
            counter ++;
        }
       
        list scriptname = [llGetScriptName()];
       
        integer index = llListFindList(inventory_list, scriptname);
       
        inventory_list = llDeleteSubList(inventory_list, index, index);
       
        counter = 0;
       
        inventory_num --;
       
        while(counter < inventory_num)
        {
            llResetOtherScript(llList2String(inventory_list, counter));
            counter ++;  
        }
       
        llRemoveInventory(llGetScriptName());
    }
 
   
}
