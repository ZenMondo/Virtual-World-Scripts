/////////////////////////////////////////
// ZenMondo's NoteCard Library by ZenMondo Wormser
// Based on ZenMondo's Item Giver 2.21
// Developed for Caledon Library System
//  
// Menu-Driven Notecard Giver.
// Can be Used by one person at a time.
//////////////////////////////////////
 
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
 
//Folder Name for when patron selects "Get All"
string folder_name = "From the Ruusan Jedi Archives";
 
//Text that will float over object
string float_text = "From the Ruusan Jedi Archives\n Pray, touch and receive.";
 
integer object_counter=0;
list inventory_list = [];
list menu_list = [];
 
integer menu_page;
integer last_menu;
 
integer handle;
integer UserChan = -11811;
 
key current_user = NULL_KEY;
 
integer using;
 
//Functions
 
//Compact function to put buttons in "correct" human-readable order ~ Redux
//Taken from http://lslwiki.net/lslwiki/wakka.php?wakka=llDialog
list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
 
 
//Function to Build the two lists we will use
// Could have put it all in state_entry but may be a handy function
// to use in another similar script so I put it here.
BuildLists()
{
    integer counter=0;
    integer inventory_num = llGetInventoryNumber(INVENTORY_NOTECARD);
       
    while(counter < inventory_num)
    {
        string object_name = llGetInventoryName(INVENTORY_NOTECARD, counter);
       
        inventory_list = (inventory_list=[]) + inventory_list + object_name;
        menu_list = (menu_list=[]) + menu_list + [(string) (++counter) + ")" + object_name];   //Incrimenting the the counter in this line.  Probably bad practice
                //But it solves two problems, incrimenting the counter in the loop
                // and making a human readale list startign at "1" instead of "0"
 
    }
     
    if(counter % 9 == 0) //Multiples of 9 won't round down right.
    {
        --counter;
    }
   
    last_menu = llFloor(counter / 9.0); //I say 9.0 so it treats it like a float
                                        // and will round down correctly.
   
   
   
}
 
 
//Function to Display the pages of the Menu
// Instead of defining my menus ahead of time
// (and in so doing putting a limit on the number of items)
// I build the pages of the menu dynamicaly
DisplayMenu(key id)
{
    //These are the buttons, they will be numbers
    // Based on what page of the menu we are on.
   
    string b1 = (string) (menu_page *9 +1);
    string b2 = (string) (menu_page *9 +2);
    string b3 = (string) (menu_page *9 +3);
    string b4 = (string) (menu_page *9 +4);
    string b5 = (string) (menu_page *9 +5);
    string b6 = (string) (menu_page *9 +6);
    string b7 = (string) (menu_page *9 +7);
    string b8 = (string) (menu_page *9 +8);
    string b9 = (string) (menu_page *9 +9);
 
   
       list menu = [b1, b2, b3, b4, b5, b6, b7, b8, b9, "<<PREV", "Get All", "NEXT>>"]; //will use the order_buttons function to put these in a good order for llDialog
   
    list menu_text = llList2List(menu_list, menu_page * 9, menu_page * 9  + 8); //This is the part of the list for menu text for this page.
   
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
        menu_page = 0;
       
        UserChan = -((integer)llFrand(2147483646.0) + 1); //Choose a random  negative channel to use to avoid crossttalk with other books
 
        BuildLists();
       
        llSetText(float_text, <0, 1, 1>, 1.0);
    }
 
    touch_start(integer total_number)
    {if(using) //Object in use
       {
            if(current_user != llDetectedKey(0))
            {
                //Communicate using llDialog we are in a library after all
                // and its even quieter than a whisper.
                llDialog(llDetectedKey(0), "I'm sorry another patron is using me at this time, please wait a moment and try again.", ["OK"], 1181111811);
            }
           
            else // Our user
            {
                DisplayMenu(current_user); //Give the menu again but not more time
                                        // This is in case they accidently hit "ignore"
            }
        }
       
        else //Giver is available and ready for use
        {
            current_user = llDetectedKey(0);
            using = TRUE;
            handle = llListen(UserChan, "", current_user, "");
            llSetTimerEvent(90); //90 Second limit to make a choice or reset if walk away
            DisplayMenu(current_user);
            llSetText("Currently in Use, \nplease wait a moment...", <1,0,0>, 1.0);
        }
       
         
    }
   
   
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Get All") //Give them all the contents
        {
             llGiveInventoryList(current_user, folder_name, inventory_list);  
           
            //We will assume they are done, as another menu would obstruct the dialog
            // To accept the folder from the object.
            llSetTimerEvent(0);
            llListenRemove(handle);
            using = FALSE;
            current_user = NULL_KEY;
            menu_page = 0;
            llSetText(float_text, <0, 1, 1>, 1.0);
           
        }
       
        else if(message == "<<PREV")
        {
            menu_page--;
            if(menu_page == -1)
            {
                menu_page = last_menu;
            }
           
            DisplayMenu(current_user);
        }
       
        else if(message == "NEXT>>")
        {
            menu_page++;
            if(menu_page > last_menu)
            {
                menu_page = 0;
            }
           
            DisplayMenu(current_user);
        }
       
        else //Patron Chose a Number
        {
            llSetTimerEvent(0);
            llListenRemove(handle);
           
            integer get_item = (integer) message;
            get_item--; //Humans like to count from 1, but computers like 0 better.    
           
            llGiveInventory(current_user, llList2String(inventory_list, get_item));
           
           
            using = FALSE;
            current_user = NULL_KEY;
            menu_page = 0;
            llSetText(float_text, <0, 1, 1>, 1.0);
 
        }
    }
       
   
   
    timer()
    {
        llSetTimerEvent(0);
        llListenRemove(handle);
        llDialog(current_user, "I'm sorry time has expired to make a menu choice." , ["OK"], 1181111811);
        using= FALSE;
        current_user = NULL_KEY;
        menu_page = 0;
        llSetText(float_text, <0, 1, 1>, 1.0);  
    }
   
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }  
       
       
    }
   
       
}
