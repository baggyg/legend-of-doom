class ZeldaClock : PowerupGiver
{
    mixin TimeLimited;

    Default
    {
        //$Title Clock
        Scale 0.5;
        Inventory.PickupSound "zelda/getitem";
		Inventory.Pickupmessage "You picked up a clock!";
    }

    States
    {
        Spawn:
            CLOK A -1 bright;
            Stop;
    }

    override bool TryPickup (in out Actor toucher)
	{
        toucher.GiveInventory("PowerTimeFreezer", 1);
		return Super.TryPickup(toucher);
	}
}
