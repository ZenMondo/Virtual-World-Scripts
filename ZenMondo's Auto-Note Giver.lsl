/////////////////////
// ZenMondo's Auto-Note Giver
//
// Gives all the notecards in
// the object's inventory to agents in
// in sesnor range.
//
// Based on a Free Visitor List maker
// by Aaron Linden.
//
///////////////////////
 
// Global variables
list visitor_list;
float range = 10.0; // in meters
float rate = 1.0; // in seconds
 
 
// Functions
integer isNameOnList( string name )
{
    integer len = llGetListLength( visitor_list );
    integer i;
    for( i = 0; i < len; i++ )
    {
        if( llList2String(visitor_list, i) == name )
        {
            return TRUE;
        }
    }
    return FALSE;
}
 
 
default
{
    state_entry()
    {
        llSensorRepeat( "", "", AGENT, range, TWO_PI, rate );
        llSetTimerEvent(86400);  //24 hours
       
    }
 
   
    sensor( integer number_detected )
    {
        integer i;
        for( i = 0; i < number_detected; i++ )
        {
            if( llDetectedKey( i ) != llGetOwner() )
            {
                string detected_name = llDetectedName( i );
                if( isNameOnList( detected_name ) == FALSE )
                {
                    visitor_list += detected_name;
                   
                    integer num_notes = llGetInventoryNumber(INVENTORY_NOTECARD);
                    integer j;
                    for( j = 0; j < num_notes ; j++ )
                    {
                        llGiveInventory( llDetectedKey(i), llGetInventoryName(INVENTORY_NOTECARD, j));  
                    }
                   
                   
                }
            }
        }    
    }
   
    timer()
    {
        visitor_list = llDeleteSubList(visitor_list, 0, llGetListLength(visitor_list));  
    }
}
