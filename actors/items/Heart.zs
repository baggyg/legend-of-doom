class ZeldaSmallHeart : Stimpack
{
	mixin TimeLimited;

	Default
	{
		//$Title Heart small
		Scale 0.25;
		Inventory.Amount 8;
		Inventory.PickupSound "zelda/heart";
		Inventory.Pickupmessage "Picked up a small heart!";
	}

	States
	{
		Spawn:
			HRTR AB 8;
			Loop;
	}
}

class ZeldaSmallHeart10 : StoreItem
{
	Default
    {
        //$Title Heart 10
        StoreItem.Cost 10;
        StoreItem.GiveAmount 8;
        StoreItem.GiveItem "ZeldaSmallHeart";
        +INVENTORY.ISHEALTH
    }

    States
    {
        Spawn:
            HRTR A -1 BRIGHT;
            Stop;
    }
}
