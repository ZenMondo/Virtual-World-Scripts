/////////////////////////////////////////////
// ZenMondo's Not So Simple Tip Jar
//
// A Tip jar that allows a cut to be taken from the tip
// and only authorized users to log in
//
// A notecard named CONGIG must be in the object's contents with this script
//
// The Notecard is formatted as follows:
//
// Percentage That the person
// signed in will recieve (do not use a
// a percent sign)
//
// cut = 80
//
// List of Users that can sign into
// The Tip Jar. Seperate by commas
// NOTE: Names are CaSe SeNSiTiVe
// Put all the names on a single line
// (do not hit return)
//
// users = ZenMondo Wormser, Ume Niosaki
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
 
 
 
integer position = 0;
string notecard = "CONFIG";
key query;
 
key online_query;
 
integer total;
integer cut;
list users;
 
string sign_in_name;
key sign_in_key;
 
integer signed_in = FALSE;
 
integer isNameOnList( string name )
{
    integer len = llGetListLength( users );
    integer i;
    for( i = 0; i < len; i++ )
    {
        if( llList2String(users, i) == name )
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
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
     
        total = 0;
       
        llSetText("Click to Sign In...", <1,0,0>, 1.0);
       
        if(llGetInventoryType(notecard) == INVENTORY_NOTECARD)
        {
            query = llGetNotecardLine(notecard, position);
        }
       
        else
        {
            llOwnerSay(notecard + " is not a notecard in the object's inventory.");
        }
    }
 
    touch_start(integer total_number)
    {
        if(!signed_in)
        {
            if(isNameOnList(llDetectedName(0)))
            {
                //Sign In
                sign_in_name = llDetectedName(0);
                sign_in_key = llDetectedKey(0);
                llSetTimerEvent(60);
                signed_in = TRUE;
                total = 0;
                llSetText(sign_in_name + "\nL$ " + (string) total, <0,1,0>, 1.0);
            }
           
            else
            {
                llSay(0, "You are not authorized to sign in to this Tip Jar.");
            }  
        }
       
        else
        {
            if(sign_in_name == llDetectedName(0))
            {
                //Sign OUt
                sign_in_name = "";
                sign_in_key = NULL_KEY;
                llSetTimerEvent(0);
                signed_in = FALSE;
                llSetText("Click to Sign In...", <1,0,0>, 1.0);
            }                
        }
    }
   
    money(key giver, integer amount)
    {
        if(signed_in)
        {    
   
            llInstantMessage(giver, "Thank you for your generosity, " + llKey2Name(giver) +".");
            total += amount;
            llSetText(sign_in_name + "\nL$ " + (string) total, <0,1,0>, 1.0);
            float pay_out = (amount * cut) * 0.01;
           
            llGiveMoney(sign_in_key, (integer) pay_out);    
   
        }
 
        else
        {
            llGiveMoney(giver, amount);
            llInstantMessage(giver, "Thank you, but no one is signed into this tip jar");
        }
       
    }
       
     timer()
    {
        online_query = llRequestAgentData(sign_in_key, DATA_ONLINE);          
    }
   
    dataserver(key request, string data)
    {
        if(query == request)
        {
            if(data == EOF)
            {
                               
                llSay(0, "Ready");
                //End of notecard!
            }
            else
            {
                //Do something with the data
               
                list cmds = llParseString2List(data, ["="], []);
       
                string command = llStringTrim(llList2String(cmds, 0), STRING_TRIM);
                string value = llStringTrim(llList2String(cmds, 1), STRING_TRIM);
               
                if(llToLower(command) == "cut")
                {
                    cut = (integer) value;
                    llOwnerSay("Cut set to: " + value + "%");
                }
               
                if(llToLower(command) == "users")
                {
                   users = llCSV2List(value);        
                }
                //Increase the position variable and
                ++position;
                //Continue reading the next lines.
                query = llGetNotecardLine(notecard, position);
            }
        }
       
        if(request == online_query)
        {
            integer online = (integer) data;
       
            if(online)
            {
                ///Hunky Dory
                return;  
            }
       
            else
            {
                //Logged off or crashed or what have you.
                sign_in_name = "";
                sign_in_key = NULL_KEY;
                llSetTimerEvent(0);
                signed_in = FALSE;
                llSetText("Click to Sign In...", <1,0,0>, 1.0);
                return;
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
   
     run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
        {            
            //All is Hunky-Dory
            return;
        }
        else
        {
           
            llOwnerSay("This tip jar requires PERMISSION_DEBIT permission! Please Accept Debit Permissions.");
             llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
        }
    }
 
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
