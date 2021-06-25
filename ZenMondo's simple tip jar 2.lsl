////////////////////////////
// ZenMondo's simple tip jar 2
//
// Collects Tips and displays total.
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
 
 
integer total;
 
default
{
    state_entry()
    {
        total = 0;
        llSetText(llKey2Name(llGetOwner())+"'s Tip Jar\nTotal Tips: L$" + (string) total, <0,1,0>, 1.0);
    }
 
    money(key giver, integer amount)
    {
        llSay(0, "Thank you for your generosity, " + llKey2Name(giver) +".");
        total += amount;
        llSetText(llKey2Name(llGetOwner())+"'s Tip Jar\nTotal Tips: L$" + (string) total, <0,1,0>, 1.0);
    }
   
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
