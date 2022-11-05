class ZeldaLadder : UniqueItem
{
    Default
	{
        //$Title Ladder
		Inventory.PickupMessage "Picked up a ladder!";
		Inventory.PickupSound "zelda/fanfare";
		Scale 0.5;
    }

	States
    {
        Spawn:
            LADR A -1;
            Stop;
    }
}
