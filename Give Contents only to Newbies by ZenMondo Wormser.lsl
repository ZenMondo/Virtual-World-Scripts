//////////////////////
//Give Contents only to Newbies by ZenMondo Wormser
//
// Just place in a prim, along with the inventory items to be given.
// To retrieve the inventory, have a newbie touch the prim.
//
// Contents will be given in a folder named what you want by changing
// a line below only to avatars younger than newb_age which you can change below.
//
//////////////////////
 
// Change "A gift to get you started"  to the name of the folder you want the object to give.(keep the quotes)
string folder_name = "A gift to get you started";
 
//Change age to number of days old
integer newb_age = 30;
 
key age_query;
key avatar_key;
 
 
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
 
 
 
//Function to give contents.
giveContents(key avatar)
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
       
       
        llGiveInventoryList(avatar, folder_name, inventory_list);
       
       
       
    }
 
 
default
{
   
 
    touch_start(integer total_number)
    {
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
                           
       
            if(total_days_old > newb_age)
            {  
                llSay(0, "I am sorry, these items are for avatars are " + (string) newb_age + " days old or younger.  You are " + (string) total_days_old + " days old.");
            }
       
            else
            {
                giveContents(avatar_key);  
            }
                 
        }  
    }  
   
}
