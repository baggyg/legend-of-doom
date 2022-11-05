class ZeldaTriforce : UniqueItem
{
    // ID of player spawner in overworld the player
    // will warp back to after picking up.
    int user_startpoint;

    Default
	{
        //$Title Triforce piece
		Inventory.PickupMessage "Picked up a Triforce of Wisdom piece!";
		Inventory.PickupSound "zelda/tforce";
        Scale 0.5;
        Inventory.MaxAmount 8;
        +INVENTORY.ALWAYSPICKUP
    }

	States
    {
        Spawn:
            TRIF AB 8;
            Loop;
    }

    override bool TryPickup (in out Actor toucher)
	{
        toucher.GiveInventory("ZeldaFairyDrop", 128);
        CallACS("HubTeleport", 1, user_startpoint, 1);
		return Super.TryPickup(toucher);
	}
}

class ZeldaTriforcePower : Inventory
{
    Default
    {
        Scale 2;
        Inventory.MaxAmount 1;
		Inventory.PickupSound "zelda/fanfare";
		Inventory.PickupMessage "Picked up a the Triforce of Power!";
    }

    States
    {
        Spawn:
            TPOW AB 8;
            Loop;
    }
}
