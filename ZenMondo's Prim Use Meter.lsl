//UUID of the Avatar You want the Prim Count of
key avatar_key = "e48c9e28-20bf-4003-8c0c-b01fb78e2734";
 
//Number of Prims allowed
integer prim_limit = 20;
 
key name_query;
 
string user_name;
 
default
{
    state_entry()
    {
        name_query = llRequestAgentData(avatar_key, DATA_NAME);
        llSetText("Setting Up, Ready in 15 seconds.", <0,1,1>, 1.0);
        llSetTimerEvent(13);
    }
 
    dataserver(key queryid, string data)
    {
       
        if(queryid == name_query)
        {
            user_name = data;
            //llSay(0, data + " " + user_name);
        }
    }
   
    timer()
    {
        llSetTimerEvent(0);
        list prim_owners = llGetParcelPrimOwners(llGetPos());
       
        integer owner_pos = llListFindList(prim_owners, [avatar_key]);
 
        if(owner_pos != -1)
        {
            integer prim_count = llList2Integer(prim_owners, ++owner_pos);
 
            if(prim_count > prim_limit)
            {
                integer over = prim_count - prim_limit;
               
                llSetText(user_name +" is using\n" + (string) prim_count + " out of " + (string) prim_limit + " prims.\nReduce prim usage by " + (string) over + " prims.", <1,0,0>, 1.0);
            }
           
            else
            {
                integer under = prim_limit - prim_count;
               
                llSetText(user_name +" is using\n" + (string) prim_count + " out of " + (string) prim_limit + " prims.\nYou may rez up to " + (string) under + " additional prims.", <0,1,0>, 1.0);
            }
        }
       
        else
        {
            llSetText(user_name + " is not using any prims.\n You may rez " + (string) prim_limit + " prims.", <0,1,0>, 1.0);
        }
 
        llSetTimerEvent(300);
    }
   
         
}
