class ZeldaMap : UniqueItem
{
    Default
	{
        //$Title Map
		Inventory.PickupMessage "Picked up a map!";
		Inventory.PickupSound "zelda/fanfare";
		Inventory.MaxAmount 0;
        Scale 0.5;
		+COUNTITEM
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.ALWAYSPICKUP
    }

	States
    {
        Spawn:
            MAP1 A -1 BRIGHT;
            Stop;
    }

    override bool TryPickup (in out Actor toucher)
	{
		level.allmap = true;
		GoAwayAndDie();
		return true;
	}
}

class ZeldaMapInvisible : UniqueItem
{
    mixin InvisiblePickup;

    Default
	{
        //$Title Map
		Inventory.PickupMessage "Picked up a map!";
		Inventory.PickupSound "zelda/fanfare";
		Inventory.MaxAmount 0;
        Scale 0.5;
        +INVISIBLE
		+COUNTITEM
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.ALWAYSPICKUP
    }

	States
    {
        Spawn:
            MAP1 A -1;
            Stop;
    }

    override bool TryPickup (in out Actor toucher)
	{
		level.allmap = true;
		GoAwayAndDie();
		return true;
	}
}
