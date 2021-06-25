 touch_start(integer total_number)
    {
        if(llSameGroup(llDetectedKey(0)))
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
       
        else
        {
            llSay(0, "You must belong to the same group as this item to receive items from this object.");
        }
       
    }
}
