default
{
    touch_start(integer total_number)
    {
        llGiveInventory(llDetectedKey(0), llGetInventoryName(INVENTORY_OBJECT, llFloor( llFrand((float) llGetInventoryNumber(INVENTORY_OBJECT)))));
    }
}
