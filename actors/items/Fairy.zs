class ZeldaFairyDrop : ZeldaSmallHeart
{
	Default
	{
		Inventory.PickupMessage "You picked up a fairy!";
		Inventory.PickupSound "zelda/fairy";
		Inventory.Amount 24;
        Monster;
        Speed 3;
		MaxStepHeight 16;
		MaxDropoffHeight 32;
        -COUNTKILL
        +FLOAT
        +DONTFALL
        +NOGRAVITY
        +NOCLIP
	}

	States
	{
		Spawn:
			FAIR AB 8 A_Look;
			Loop;
        See:
			FAIR AABBAABB 2 A_Wander;
            Loop;
	}

	override bool CanPickup(Actor toucher)
	{
		let player = PlayerPawn(toucher);
		if (player)
		{
			if (player.Health >= player.MaxHealth) return false;
			if (player.MaxHealth - player.Health < Amount) Amount = player.MaxHealth - player.Health;
		}
		return Super.CanPickup(toucher);
	}
}

class ZeldaFairy : Health
{
	Default
	{
		//$Title Fairy Fountain
		Inventory.PickupMessage "";
		Inventory.PickupSound "zelda/fairy";
		Inventory.Amount 128;
		Inventory.MaxAmount 128;
		Scale 0.5;
	}

	override bool ShouldStay()
	{
		return true;
	}

    override bool TryPickup (in out Actor toucher)
    {
		let player = PlayerPawn(toucher);
		if (player)
		{
			if (player.Health >= player.MaxHealth) return false;
			if (player.MaxHealth - player.Health < Amount) Amount = player.MaxHealth - player.Health;
		}
		return Super.TryPickup(toucher);
	}

	States
	{
		Spawn:
			FAIR AB 8;
			Loop;
	}
}
