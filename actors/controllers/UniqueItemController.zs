/**
*   UniqueItem is something that should only spawn one time.
*   After it's picked up, it should not spawn again when
*   going back and forth between HUB world maps.
*
*   It seems like one of the actor or inventory flags would
*   trigger this behavior, but I can't seem to find it and
*   the items like letter to old lady respawn every time I
*   enter a dungeon and return to the overworld.
*
*   UniqueItemController will be responsible for tracking which
*   UniqueItems a player has picked up and will remove them
*   from a map when the world loads.
*/
class UniqueItem : Inventory abstract
{
    string user_id;

	override void DoPickupSpecial(Actor toucher)
	{
        let controller = UniqueItemController(StaticEventHandler.Find("UniqueItemController"));
		controller.RegisterUniquePickup(user_id);
        Super.DoPickupSpecial(toucher);
	}
}

/**
*   Keeps track of unique items and removes
*   them from the map if the player already
*   has it in their inventory.
*/
class UniqueItemController : StaticEventHandler
{
    InventoryData data;

    override void WorldLoaded(WorldEvent e)
    {
        data = InventoryData.Get();
        RemoveItems();
    }

    void RegisterUniquePickup(string itemName)
    {
        if (!itemName || itemName == "") return;
        // Console.PrintF("Registering item %s", itemName);
        data.uniqueItems.Insert(itemName, "pickedup");
        RemoveItems();
    }

    bool IsPickedUp(string itemId)
    {
        return data.uniqueItems.At(itemId) != "";
    }

    void RemoveItems()
    {
        UniqueItem mo;
        let ti = ThinkerIterator.Create("UniqueItem");
        while (mo = UniqueItem(ti.Next()))
        {
            if (!mo.owner && data.uniqueItems.At(mo.user_id) != "")
            {
                mo.Destroy();
            }
        }
    }
}

/**
*   Data structure for tracking UniqueItems picked up by the player.
*   Is persistent across all HUB maps.
*/
class InventoryData : Thinker
{
    Dictionary uniqueItems;

	InventoryData Init()
    {
		ChangeStatNum(STAT_STATIC);
        uniqueItems = Dictionary.Create();
		return self;
	}

	static InventoryData Get()
    {
		let it = ThinkerIterator.Create("InventoryData", STAT_STATIC);
		let p = InventoryData(it.Next());
		if (p == null) p = new("InventoryData").Init();
		return p;
	}
}
