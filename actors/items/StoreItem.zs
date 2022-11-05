class StoreItem : Inventory abstract
{
    Default
    {
        Scale 0.5;
        Inventory.RespawnTics 150;
        Inventory.PickupSound "zelda/fanfare";
		+INVENTORY.ALWAYSRESPAWN
    }

    property Cost: Cost;
	int Cost;

    property GiveAmount: GiveAmount;
    int GiveAmount;

    property GiveItem: GiveItem;
	string GiveItem;

	override bool CanPickup(Actor toucher)
	{
		return toucher.CountInv("ZeldaRupee") >= Cost;
	}

    override bool TryPickup (in out Actor toucher)
	{
		toucher.TakeInventory("ZeldaRupee", Cost);
		A_StartSound("zelda/rupees", CHAN_AUTO);
		if (GiveItem) toucher.GiveInventory(GiveItem, GiveAmount);
		return Super.TryPickup(toucher);
	}

    override bool HandlePickup(Inventory item)
    {
        return false;
    }
}
