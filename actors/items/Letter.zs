class ZeldaLetter : UniqueItem
{
    Default
	{
        //$Title Letter
		Inventory.PickupMessage "Picked up a letter!";
		Inventory.PickupSound "zelda/fanfare";
        Scale 0.5;
    }

	States
    {
        Spawn:
            MAP2 A -1;
            Stop;
    }
}


