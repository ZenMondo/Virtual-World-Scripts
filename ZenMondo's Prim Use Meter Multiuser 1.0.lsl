//UUID of the Avatar You want the Prim Count of
list avatar_keys = ["e48c9e28-20bf-4003-8c0c-b01fb78e2734", "ce0614e8-c9f1-4533-b0d2-18e3f8bb8f43"];
 
//Number of Prims allowed
integer prim_limit = 20;
 
key name_query;
 
list user_names;
 
integer listlength;
 
integer count = 0;
 
integer prim_count;
 
list prim_owners;
 
 
default
{
    state_entry()
    {
        listlength = llGetListLength(avatar_keys);
       
        name_query = llRequestAgentData(llList2Key(avatar_keys, count), DATA_NAME);
        //llSay(0, "count = " + (string) count);
       
       
        llSetText("Setting Up, Ready in Soon.", <0,1,1>, 1.0);
        llSetTimerEvent(13);
    }
 
    dataserver(key queryid, string data)
    {
       
        if(queryid == name_query)
        {
            user_names += [data];
            //llSay(0, data + " " + llList2CSV(user_names));
           
            if(count < listlength)
            {
                count++;
                name_query = llRequestAgentData(llList2Key(avatar_keys, count), DATA_NAME);
                //llSay(0, "count = " + (string) count);
            }
           
        }
    }
   
    timer()
    {
        llSetTimerEvent(0);
        prim_count = 0;
        prim_owners = llGetParcelPrimOwners(llGetPos());
       
        //integer owner_pos = llListFindList(prim_owners, avatar_keys);
       
        integer len = llGetListLength(prim_owners);
        integer i;
        for( i = 0; i < len; i++ )
        {
            integer c;
            for( c = 0; c < listlength ; c++)
            {
                if( llList2Key(avatar_keys, c) == llList2Key(prim_owners, i) )
                {
                    prim_count += llList2Integer(prim_owners, i+1);
                }
            }
        }
           
       
   
   
        if(prim_count != 0)
        {
            //integer prim_count = llList2Integer(prim_owners, ++owner_pos);
 
            if(prim_count > prim_limit)
            {
                integer over = prim_count - prim_limit;
               
                llSetText(llList2CSV(user_names) +" are using\n" + (string) prim_count + " out of " + (string) prim_limit + " prims.\nReduce prim usage by " + (string) over + " prims.", <1,0,0>, 1.0);
            }
           
            else
            {
                integer under = prim_limit - prim_count;
               
                llSetText(llList2CSV(user_names) +" are using\n" + (string) prim_count + " out of " + (string) prim_limit + " prims.\nYou may rez up to " + (string) under + " additional prims.", <0,1,0>, 1.0);
            }
       
        }
       
        else
        {
            llSetText(llList2CSV(user_names) + " are not using any prims.\n You may rez " + (string) prim_limit + " prims.", <0,1,0>, 1.0);
        }
 
        llSetTimerEvent(300);
    }
   
         
}
