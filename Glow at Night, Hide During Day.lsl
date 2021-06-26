default
{
    state_entry()
    {
        llSetTimerEvent(300);
    }

    timer()
    {
        vector sunpos = llGetSunDirection();
        
        if(sunpos.z <= 0) //Night
        {
            llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_GLOW, ALL_SIDES, 0.20]); 
        }
        
        else // Day
        {
            llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_GLOW, ALL_SIDES, 0.0]);
        }  
    }
}
