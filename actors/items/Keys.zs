class ZeldaKey : UniqueItem
{
    Default
    {
        //$Title Key
		Inventory.MaxAmount 100;
		Inventory.InterHubAmount 100;
		Inventory.Pickupmessage "Picked up a key!";
		Inventory.PickupSound "zelda/getitem";
		Inventory.Icon "STKEYS0";
		Scale 0.5;
        +INVENTORY.HUBPOWER
    }

    States
    {
        Spawn:
            KEEY A -1;
            Stop;
    }
}

class ZeldaKeyPickup : UniqueItem
{
    mixin InvisiblePickup;

    Default
    {
        //$Title Key Invisible
		Scale 0.5;
		Inventory.Pickupmessage "Picked up a key!";
		Inventory.PickupSound "zelda/getitem";
        +INVENTORY.ALWAYSPICKUP
    }

    override bool TryPickup (in out Actor toucher)
    {
        toucher.GiveInventory("ZeldaKey", 1);
        return Super.CanPickup(toucher);
    }

    States
    {
        Spawn:
            KEEY A -1;
            Stop;
    }
}

class ZeldaKey100 : StoreItem
{
    Default
    {
        //$Title Key 100
        StoreItem.Cost 100;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "ZeldaKey";
    }

    States
    {
        Spawn:
            KEEY A -1 BRIGHT;
            Stop;
    }
}

class ZeldaKey80 : ZeldaKey100
{
    Default
    {
        //$Title Key 80
        StoreItem.Cost 80;
    }
}

class ZeldaLionKey : UniqueItem
{
    Default
    {
        //$Title Lion Key
		Scale 0.5;
		Inventory.MaxAmount 1;
		Inventory.InterHubAmount 1;
		Inventory.Pickupmessage "You got the Lion Key!";
        Inventory.PickupSound "zelda/fanfare";
		Inventory.Icon "STKEYS0";
    }

    States
    {
        Spawn:
            KEEE A -1;
            Stop;
    }
}
