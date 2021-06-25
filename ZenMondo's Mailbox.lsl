//////////////////////////////////////
// ZenMondo's Mailbox by ZenMondo Wormser
//
// Displays Online Status, as well as accepting
// notecard "mail" to be be delivered to owner.
//
// Cleans Up after itself, deletes non-notecards.
//
//
// LICENSE:
//
//  This script is given for free, and may NOT be
//  resold or used in a commercial product.
//  You may copy and distribute this script for free.
//  When you redistribute or copy this script, you must
//  do so with FULL PERMS (modify, copy, and transfer),
//  and leave this notice intact.
//
//  You are free to modify this code, but any derivitive
//  scripts must not be used in a commercial product or
//  or sold, and must contain this license.  
//
//  This script is provided free for learning
//  purposes, take it apart, break it, fix it,
//  learn something.  If you come up with something
//  clever, share it.
//
//  Questions about codepoetry (scripting) can always be addressed
//  to me, ZenMondo Wormser.
//
/////////////////////////////////////////
 
key online_query;
 
key name_query;
 
string user_name;
 
default
{
    state_entry()
    {
        llAllowInventoryDrop(TRUE);
        name_query = llRequestAgentData(llGetOwner(), DATA_NAME);
        llSetText("Setting Up, Ready in one minute.", <0,1,1>, 1.0);
        llSetTimerEvent(60);
       
       
    }
 
    timer()
    {
        online_query = llRequestAgentData(llGetOwner(),DATA_ONLINE);          
    }
   
    dataserver(key queryid, string data)
    {
       
        if(queryid == name_query)
        {
            user_name = data;
            //llSay(0, data + " " + user_name);
        }
       
        if(queryid == online_query)
        {
            integer online = (integer) data;
       
            if(online)
            {
                llSetText(user_name + "\nIs ONLINE\nDrop a NoteCard into me to Send " + user_name + " a message.", <0,1,0>, 1.0);
                return;  
            }
       
            else
            {
                llSetText(user_name + "\nIs OFFLINE\nDrop a NoteCard into me to Send " + user_name + " a message.", <1,0,0>, 1.0);
                return;
            }
       
        }    
    }
   
    changed(integer mask)
    {
        if(mask & (CHANGED_ALLOWED_DROP | CHANGED_INVENTORY))
        {
            integer num_notes = llGetInventoryNumber(INVENTORY_NOTECARD);
           
            if(num_notes > 0)
            {
                string note_name = llGetInventoryName(INVENTORY_NOTECARD, 0);
                           
                llSay(0, "Sending Notecard, '" + note_name +"' please stand by.");
           
                llGiveInventory(llGetOwner(), note_name);
               
                llInstantMessage(llGetOwner(), "A NoteCard has been sent to you: " + note_name);
                llSay(0, "The Notecard, " + note_name + " has been sent. Thank you.");
               
           
                llRemoveInventory(note_name);
               
                num_notes = llGetInventoryNumber(INVENTORY_NOTECARD);
               
                while(num_notes > 0) // They dropped more than one notecard. Clean it up
                {  
                    note_name = llGetInventoryName(INVENTORY_NOTECARD, 0);
                     
                    llSay(0, "Deleting " + note_name + ". It was not submitted.  Try Dropping one note at a time.");
                   
                    llRemoveInventory(note_name);
                   
                    num_notes = llGetInventoryNumber(INVENTORY_NOTECARD);
                   
                }
               
            }
           
            else //Not a Notecard
            {
               //find out what was dropped and remove it.  
               
               
                list inventory;
                integer num_inv = llGetInventoryNumber(INVENTORY_ALL); // Should be 2
                integer counter = 0;
                while(counter < num_inv)
                {
                    inventory += [llGetInventoryName(INVENTORY_ALL, counter)];
                    counter ++;  
                }
               
                // WHat we expect to find
                list this_script = [llGetScriptName()];
               
                //Delete this script (which belong in the inventory) from the list
                integer index = llListFindList(inventory, this_script);
                inventory = llDeleteSubList(inventory, index, index);
               
               
                index = llGetListLength(inventory);
               
               
                //Just in case they snuck in more than one inventory item
                while (index >= 1)
                {                
                    llSay(0, "That was not a notecard. Removing " + llList2String(inventory, 0));
                    llRemoveInventory(llList2String(inventory, 0));
                    inventory = llDeleteSubList(inventory, 0, 0);
                    index = llGetListLength(inventory);  
                }
            }
        }
    }
   
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
