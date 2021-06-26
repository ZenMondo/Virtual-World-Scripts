///////////////////////////
// ZenMondo's SLURL Orgainzer 1.0
// Based On:
// Caledon Library Book Server 2.61 by ZenMondo Wormser
// Developed for Caledon Library System
//
// Presents a SLURL from a menu from which you can then teleport.
//  
//
//  The Destination Name and SLURLs are stored on a configuration notecard.
//
// The Format of the notecard is as follows
//  A Line with the Destination Name,
//  followed by a line with the SLURL of the Destination.
//
//  The notecard can be named anything, I suggesst descriptive names such as
//  "The Book of Houshold Management by Mrs. Isabella Beeton"  and not something
//  vaugue such as "urls".
//
//
//  An object containing this script is limited to one user at a time.
//////////////////////
 
 
///////////////////////////
// This work is licensed under the Creative Commons Attribution-Noncommercial-Share
// Alike 3.0 License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative
// Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
//
// Attribution:
//  If unmodified you must keep the filename intact
//  If a derivative work you must say "Based on the CodePoetry of ZenMondo Wormser"
//////////////////////////
 
//Global Variables
integer position = 0;
string notecard;
key query;
 
integer handle;
integer UserChan = 11811;
 
integer titleCounter = 0;
list titleData = [];
list urlData = [];
 
 
integer menuPage;
integer lastMenu;
 
key currentPatron = NULL_KEY;
integer reading = FALSE;
 
//Functions
 
//Compact function to put buttons in "correct" human-readable order ~ Redux
//Taken from http://lslwiki.net/lslwiki/wakka.php?wakka=llDialog
list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
 
//Function to Display the pages of the Menu
// Instead of defining my menus ahead of time
// (and in so doing putting a limit on the number of items)
// I build the pages of the menu dynamicaly
DisplayMenuPage(key id)
{
   
 
    //These are the buttons, they will be numbers
    // Based on what page of the menu we are on.
   
    string b1 = (string) (menuPage *9 +1);
    string b2 = (string) (menuPage *9 +2);
    string b3 = (string) (menuPage *9 +3);
    string b4 = (string) (menuPage *9 +4);
    string b5 = (string) (menuPage *9 +5);
    string b6 = (string) (menuPage *9 +6);
    string b7 = (string) (menuPage *9 +7);
    string b8 = (string) (menuPage *9 +8);
    string b9 = (string) (menuPage *9 +9);
 
   
    list menu = [b1, b2, b3, b4, b5, b6, b7, b8, b9, "<<PREV", "Bibl.", "NEXT>>"]; //will use the order_buttons function to put these in a good order for llDialog
   
    list menu_text = llList2List(titleData, menuPage * 9, menuPage * 9  + 8); //This is the part of the list for menu text for this page.
   
    integer menu_length = llGetListLength(menu_text);
   
    if(menu_length < 9) //Don't Need all the buttons
    {
        menu = llDeleteSubList(menu, menu_length, 8); //Trim the menu buttons
    }
   
    llDialog(id, llDumpList2String(menu_text, "\n"), order_buttons(menu), UserChan); //Display the Menu
}
 
default
{
    state_entry()
    {  
        menuPage = 0;
       
        UserChan = -((integer)llFrand(2147483646.0) + 1); //Choose a random  negative channel to use to aoid crossttalk with other books
       
       notecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
                     
       if(llGetInventoryType(notecard) == INVENTORY_NOTECARD)
        {
            llWhisper(0, "Reading Configuration Notecard.");
            query = llGetNotecardLine(notecard, position);
        }
       
        else
        {
            llWhisper(0, "Configuration notecard is not present in the object's inventory.");
        }
       
       
    }
 
    touch_start(integer total_number)
    {
       if(reading) //Book in use
       {
            if(currentPatron != llDetectedKey(0))
            {
                //Communicate using llDialog we are in a library after all
                // and its even quieter than a whisper.
                llDialog(llDetectedKey(0), "I'm sorry another patron is reading me at this time, please wait a moment and try again.", ["OK"], 1181111811);
            }
           
            else // Our reader
            {
                DisplayMenuPage(currentPatron); //Give the menu again but not more time
                                                // This is in case they accidently hit "ignore"
            }
        }
       
        else //Book is available and ready for use
        {
            currentPatron = llDetectedKey(0);
            reading = TRUE;
            handle = llListen(UserChan, "", currentPatron, "");
            llSetTimerEvent(90); //90 Second limit to make a choice or reset if walk away
            DisplayMenuPage(currentPatron);
        }
       
       
    }
   
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Bibl.") //Give them the notecard and they can look up the URLS on thier own
        {
            llGiveInventory(id, notecard);
           
            //We will assume they are done, as another menu would obstruct the dialog
            // To accept the notecard from the book.
            llSetTimerEvent(0);
            llListenRemove(handle);
            reading = FALSE;
            currentPatron = NULL_KEY;
            menuPage = 0;
           
        }
       
        else if(message == "<<PREV")
        {
            menuPage--;
            if(menuPage == -1)
            {
                menuPage = lastMenu;
            }
           
            DisplayMenuPage(currentPatron);
        }
       
        else if(message == "NEXT>>")
        {
            menuPage++;
            if(menuPage > lastMenu)
            {
                menuPage = 0;
            }
           
            DisplayMenuPage(currentPatron);
        }
       
        else //Patron Chose a Number
        {
            llSetTimerEvent(0);
            llListenRemove(handle);
           
            integer GoUrl = (integer) message;
            GoUrl--; //Humans like to count from 1, but computers like 0 better.    
           
           
            llInstantMessage(currentPatron, "Click here to Teleport: " + llList2String(urlData, GoUrl));
           
           
            reading = FALSE;
            currentPatron = NULL_KEY;
            menuPage = 0;
           
 
        }
    }
   
    timer()
    {
        llSetTimerEvent(0);
        llListenRemove(handle);
        llDialog(currentPatron, "I'm sorry time has expired to make a menu choice." , ["OK"], 1181111811);
        reading = FALSE;
        currentPatron = NULL_KEY;
        menuPage = 0;  
    }
   
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            //asuming the notecard has been edited or swapped out. If it wasn't that,
            // WHAT ELSE ARE YOU PUTTING IN? DON'T DO THAT! ONLY THE SCRIPT AND NOTECARD!
            llResetScript();
        }  
       
       
    }
   
   
 
 
    dataserver(key request, string data)
    {
        if(query == request)
        {
            if(data == EOF) //Then end of the notecard
            {
                if(titleCounter % 9 == 0) //Multiples of 9 won't round down right.
                {
                    --titleCounter;
                }
               
                lastMenu = llFloor(titleCounter / 9.0);  //How Many Pages of Menus we will use
                llWhisper(0, "Ready");
                //End of notecard!
            }
            else
            {
                //Do something with the data
               
                if (position % 2) // These lines 1,3,5,7... and so on will be URLs
                {
                    urlData += (list)(data);
                }
                else
                {
                    titleData += (list)((string)(++titleCounter) + ") " + data);
               
                }
               
                //llSay(0, "Added " + data +" to access list.");
               
                //Increase the position variable and
                ++position;
                //Continue reading the next lines.
                query = llGetNotecardLine(notecard, position);
            }
        }
    }
   
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
