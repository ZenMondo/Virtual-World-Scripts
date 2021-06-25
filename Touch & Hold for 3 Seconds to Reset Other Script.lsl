//////////////////////////////////////////////////////////
//Touch & Hold for 3 Seconds to Reset Other Script
// CodePoetry by ZenMondo Wormser
//
//Place in the same prim as the script you want to reset
///////////////////////////////////////////////////////////

//The Name of the Script to be Reset
string ScriptName = "Chado HUD Button - Main Ceremony";

integer touchTimerStart;
integer touchTimerStop;

default
{
    touch_start(integer total_number)
    {
        touchTimerStart = llGetUnixTime();
    }
    
    touch_end(integer num_detected)
    {
        touchTimerStop = llGetUnixTime();   
        integer touchTime = touchTimerStop - touchTimerStart;
        
        if((touchTime >= 3) && (llDetectedKey(0) == llGetOwner()))
        {
            llResetOtherScript(ScriptName);
        }
        
        else
        {
            //llSay(0, "Click Mode");
            //User Click Menu goes here.            
            
        }
    } // end - touch_end

   
}
