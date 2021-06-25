//////////////////////
//Inventory Dump (pay version) by ZenMondo Wormser
//
// Just place in a prim, along with the inventory items to be given.
// To retrieve the inventory, pay the prim.
// Contents will be given in a folder named what you want by changing
// a line below (default is Inventory Dump).
//////////////////////
 
// Change "Inventory Dump"  to the name of the folder you want the object to give.(keep the quotes)
string folder_name = "Inventory Dump";
 
// Change 1 to the amount you would like people to pay to recieve the inventory.
integer pay_amount = 1;
 
 
default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT); //To refund wrong amounts.
        llSetPayPrice(PAY_HIDE, [pay_amount, PAY_HIDE, PAY_HIDE, PAY_HIDE]);  
    }
 
    touch_start(integer num_detected)
    {
        llSay(0, "Pay me L$" + (string) pay_amount + " to recieve my contents");  
    }
   
   
    money(key giver, integer amount)
    {
        if(amount != pay_amount)
        {  
            llSay(0, "Wrong amount paid. Refunding...");
            llGiveMoney(giver, amount);
            return;
        }
       
        else
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
       
       
            llGiveInventoryList(giver, folder_name, inventory_list);
        }
       
       
    }
}
