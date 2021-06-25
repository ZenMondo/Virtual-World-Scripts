/////////////////////////////////////////
// Teleport Noobs Home by ZenMondo Wormser
//
// When an avatar enters a parcel younger than a defined age,
// the avatar is teleported home and sent a message.
//
// NOTE: This script must be placed in an object that has the samne
// same owner as the owner of the land. If the land is group owned, it
// must be deeded to the group that owns the land.
/////////////////////////////////////////////////
 
 
//Change age to number of days old
integer newb_age = 7;
 
key age_query;
key avatar_key;
 
string avatar_name;
 
 
 
integer date2days(string data)
{
    integer result;
    list parse_date = llParseString2List(data, ["-"], []);
    integer year = llList2Integer(parse_date, 0);
 
    result = (year - 2000) * 365; // Bias Number to year 2000 (SL Avatars Born After Date)
    list days = [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ];
 
    result += llList2Integer(days, (llList2Integer(parse_date, 1) - 1));
    if (year/4 == llRound(year/4)) result += 1;
    result += llList2Integer(parse_date, 2);
 
    return result;
}
 
default
{
    state_entry()
    {
        llSensorRepeat("", NULL_KEY, AGENT, 96.0, PI, 0.5);
    }
 
    sensor(integer num_detected)
    {
            avatar_name = llDetectedName(0);
            avatar_key = llDetectedKey(0);
            age_query = llRequestAgentData(llDetectedKey(0), DATA_BORN);
         
    }
   
    dataserver(key queryid, string data)
    {
        if(queryid == age_query)
        {
            string born_on = data;  //Get the Date Avatar was born
            string today = llGetDate();
           
            integer born_on_day =  date2days(born_on);
            integer today_day = date2days(today);
           
            integer total_days_old = today_day - born_on_day;
                           
       
            if(total_days_old <= newb_age)
            {  
                llTeleportAgentHome(avatar_key);
                llInstantMessage(avatar_key, "Sorry " + avatar_name + " but due to recent circumstances, your account is too young to be admitted to this parcel.");
            }
       
           
                 
        }  
    }  
   
   
}
