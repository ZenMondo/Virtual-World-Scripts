list users;
integer objectCount;
 
default
{
    state_entry()
    {
        objectCount = llGetInventoryNumber(INVENTORY_OBJECT);
        llSetText((string) objectCount + " items remaining", <0,1,0>, 1.0);
    }
 
    touch_start(integer total_number)
    {
        if(objectCount > 0)
        {
            string name = llDetectedName(0);
            if(llListFindList(users, [name]) == -1)
            {
                users = (users=[]) + users + name; //Add name to list
       
                llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_OBJECT, llFloor( llFrand((float) llGetInventoryNumber(INVENTORY_OBJECT))))); //This confusing bit gives a random object from inventory
             
                objectCount = llGetInventoryNumber(INVENTORY_OBJECT);
               
                if(objectCount > 0)
                {
                    llSetText((string) objectCount + " items remaining", <0,1,0>, 1.0);
                }
               
                else
                {
                    llInstantMessage(llGetOwner(), llGetObjectName() + " is empty");
                    llSetText((string) objectCount + " items remaining", <1,0,0>, 1.0);
                }
            }
           
            else
            {
                 llInstantMessage(llDetectedKey(0), "I am sorry but you have already received your free item. Save some for other people.");  
            }
        }        
    }
 
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            //This is not redundent. llGiveInventory does NOT trigger the changed event these two lines will allow the hovertext to change when ADDING objects
            objectCount = llGetInventoryNumber(INVENTORY_OBJECT);
            llSetText((string) objectCount + " items remaining", <0,1,0>, 1.0);
        }  
    }
}
