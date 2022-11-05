class ZeldaRaft : UniqueItem
{
    Default
	{
        //$Title Raft
		Inventory.PickupMessage "Picked up a raft!";
		Inventory.PickupSound "zelda/fanfare";
		Scale 0.5;
    }

	States
    {
        Spawn:
            RAFT A -1;
            Stop;
    }
}
