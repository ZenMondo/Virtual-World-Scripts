/////////////////////////////
// ZenMondo's Not So Simple Door 2.1.5
//
// Full featured door script.
// Access list is contained on a notecard named 'users'
// Put an Avatar's Username on each line of the notecard.
//
// Access the door menu by clicking on the door.  The menu
// will dynamically change depending on the door's status.
//
// Place this script and the notecard 'users' in a box prim
// that has a Path Cut of Begin: 0.3750 End: 0.8750
/////////////////////////////
 
 
integer isClosed;
integer isLocked;
integer stayOpenFlag;
 
 
string AutoOption = "Stay Open";
string LockOption = "Lock";
string OpenOption = "Open";
 
list OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
 
key OwnerKey;
 
integer userChannel = -11811;
integer handle;
 
integer buttonFlag;
 
integer position = 0;
string notecard = "users";
key query;
list users;
 
 
OpenDoor()
{
    rotation rot = llGetRot();
    rotation delta = llEuler2Rot(<0,0,PI/8>);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
   
    isClosed = FALSE;
    OpenOption = "Close";
    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
}
 
CloseDoor()
{
    rotation rot = llGetRot();
    rotation delta = llEuler2Rot(<0,0,-PI/8>);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
           
    isClosed = TRUE;
    OpenOption = "Open";
    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
}
 
default
{
    state_entry()
    {
        OwnerKey = llGetOwner();
        userChannel = -((integer)llFrand(2147483646.0) + 1);
       
        isClosed = TRUE;
        isLocked = FALSE;
        stayOpenFlag = FALSE;
 
 
        AutoOption = "Stay Open";
        LockOption = "Lock";
        OpenOption = "Open";
       
        llSensorRepeat("", NULL_KEY, AGENT, 2.0, PI, 1.0);
       
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
        string touching_me = llToLower(llDetectedName(0));
       
        if(llDetectedKey(0) == OwnerKey || llListFindList(users, [touching_me]) != -1)
        {
            handle = llListen(userChannel, "", llDetectedKey(0), "");
            llDialog(llDetectedKey(0), "Door Options", OwnerMenu, userChannel);
            llSetTimerEvent(30);
        }
       
        else
        {
            if(!isLocked && isClosed)
            {
                llSensorRemove();
                OpenDoor();
                buttonFlag = TRUE;
                llSensorRepeat("", NULL_KEY, AGENT, 2.0, PI, 10.0);  
            }
        }
    }
   
    listen(integer channel, string name, key id, string message)
    {
        if (llListFindList(OwnerMenu, [message]) != -1)  // verify dialog choice
        {
            if(message == AutoOption)
            {
                if(AutoOption == "Stay Open")
                {
                    AutoOption = "Close Automaticaly";
                    stayOpenFlag = TRUE;
                    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
                }
                else
                {
                    AutoOption = "Stay Open";
                    stayOpenFlag = FALSE;
                    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
                }
            }
           
            if(message == LockOption)
            {
                if(LockOption == "Lock")
                {
                    LockOption = "Unlock";
                    isLocked = TRUE;
                    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
                }
               
                else
                {
                    LockOption = "Lock";
                    isLocked = FALSE;
                    OwnerMenu = [ AutoOption, LockOption,  OpenOption  ];
                }
               
            }
           
            if(message == OpenOption)
            {
                if(OpenOption == "Open")
                {
                    llSensorRemove();
                    OpenDoor();
                    buttonFlag = TRUE;
                    llSensorRepeat("", NULL_KEY, AGENT, 2.0, PI, 10.0);  
                   
                }
                else
                {
                    CloseDoor();
                }  
            }
        }
       
    }
   
   
    sensor(integer num_detected)
    {
        if(!isLocked && isClosed)
        {
            OpenDoor();
        }  
    }
   
    no_sensor()
    {
        if(buttonFlag)
        {
             llSensorRepeat("", NULL_KEY, AGENT, 2.0, PI, 1.0);
             buttonFlag = FALSE;
        }
   
       
        if(!stayOpenFlag && !isClosed)
        {
            CloseDoor();
        }
    }
   
    timer()
    {
        llSetTimerEvent(0);
        llListenRemove(handle);
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
               
                users = (users=[]) + users + llToLower(llStringTrim(data, STRING_TRIM));
               
                //llSay(0, "Added " + data +" to access list.");
               
                //Increase the position variable and
                ++position;
                //Continue reading the next lines.
                query = llGetNotecardLine(notecard, position);
            }
        }
    }
   
   
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llWhisper(0, "Control Given To:" + llKey2Name(llGetOwner()));
            llResetScript();
           
        }
       
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
   
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
