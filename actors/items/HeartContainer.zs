// Placed in boss rooms
class ZeldaHeartContainer : ZeldaHeartContainerPickup
{
    mixin InvisiblePickup;

    Default
    {
        //$Title Heart container boss

        // Unsure why, but +INVISIBLE from InvisiblePickup
        // mixin isn't applying. Maybe `ZeldaHeartContainerPickup`
        // is overriding it?
        +INVISIBLE
    }
}

// Placed in overworld
class ZeldaHeartContainerPickup : UniqueItem
{
    Default
    {
        //$Title Heart container
		Scale 0.5;
		Inventory.MaxAmount 13;
		Inventory.InterHubAmount 13;
		Inventory.PickupSound "zelda/fanfare";
		Inventory.Pickupmessage "Picked up a heart container!";
		+COUNTITEM
        +INVENTORY.HUBPOWER
		+INVENTORY.ALWAYSPICKUP
    }

    States
    {
        Spawn:
            HRTB A -1 BRIGHT;
            Loop;
    }

	override void DoPickupSpecial(Actor toucher)
	{
		let player = players[consoleplayer].mo;
        player.MugShotMaxHealth += 8;
        player.MaxHealth += 8;
        player.GiveInventory("ZeldaSmallHeart", 8);
        Super.DoPickupSpecial(toucher);
	}
}
