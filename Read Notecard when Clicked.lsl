string notecard;
integer position = 0;
key query;
 
default
{
    state_entry()
    {
        notecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
       
        position = 0;
    }
 
    touch_start(integer total_number)
    {
        if(llGetInventoryType(notecard) == INVENTORY_NOTECARD)
        {
            query = llGetNotecardLine(notecard, position);
        }
       
         
    }
   
   dataserver(key request, string data)
    {
        if(query == request)
        {
            if(data == EOF) //Then end of the notecard
            {
               
           
            position = 0;
   
            }
            else
            {
                //Do something with the data
               
                llSay(0, data);
                llSleep(2);
               
                             
                //Increase the position variable and
                ++position;
                //Continue reading the next lines.
                query = llGetNotecardLine(notecard, position);
            }
        }
    }
       
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }    
    }    
}
 
