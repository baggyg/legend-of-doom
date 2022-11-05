class ZeldaPowerBracelet : UniqueItem
{
    Default
	{
        //$Title Power Bracelet
		Inventory.PickupMessage "Picked up the Power Bracelet!";
		Inventory.PickupSound "zelda/fanfare";
		Scale 0.5;
    }

	States
    {
        Spawn:
            PWRB A -1;
            Stop;
    }
}
