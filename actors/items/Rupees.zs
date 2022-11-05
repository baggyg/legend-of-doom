class ZeldaRupee : Ammo
{
    Default
    {
        //$Title Rupee
        Scale 0.4;
        Inventory.Amount 1;
		Inventory.MaxAmount 999;
		Inventory.InterHubAmount 999;
		Inventory.PickupSound "zelda/rupee";
		Inventory.Pickupmessage "Picked up a rupee!";
    }

    States
    {
        Spawn:
            RUP1 C -1 BRIGHT;
            Stop;
    }
}

class ZeldaRupee5 : ZeldaRupee
{
    Default
    {
        //$Title Rupee 5
        Inventory.Amount 5;
        Inventory.PickupSound "zelda/rupee5";
		Inventory.Pickupmessage "Picked up 5 rupees!";
    }

    States
    {
        Spawn:
            RUP5 A -1 BRIGHT;
            Stop;
    }
}

class ZeldaRupee20 : ZeldaRupee
{
    Default
    {
        //$Title Rupee 20
        Inventory.Amount 20;
		Inventory.Pickupmessage "Picked up 20 rupees!";
		Inventory.PickupSound "zelda/rupees";
    }

    States
    {
        Spawn:
            RUPT A -1 BRIGHT;
            Stop;
    }
}

class MoblinRupee : UniqueItem abstract
{
    Default
    {
        Scale 0.5;
		Inventory.PickupSound "zelda/rupees";
        +INVENTORY.ALWAYSPICKUP
    }

    States
    {
        Spawn:
            RUP1 A -1 BRIGHT;
            Stop;
    }
}

class MoblinRupee10 : MoblinRupee
{
    Default
    {
        //$Title Moblin Rupee 10
		Inventory.Pickupmessage "Picked up 10 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
	{
		toucher.GiveInventory("ZeldaRupee", 10);
		return Super.TryPickup(toucher);
	}
}

class MoblinRupee30 : MoblinRupee
{
    Default
    {
        //$Title Moblin Rupee 30
		Inventory.Pickupmessage "Picked up 30 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
	{
		toucher.GiveInventory("ZeldaRupee", 30);
		return Super.TryPickup(toucher);
	}
}

class MoblinRupee100 : MoblinRupee
{
    Default
    {
        //$Title Moblin Rupee 100
		Inventory.Pickupmessage "Picked up 100 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
	{
		toucher.GiveInventory("ZeldaRupee", 100);
		return Super.TryPickup(toucher);
	}
}

class ZeldaMoblinRupeeNeg20 : MoblinRupee
{
    Default
    {
		Inventory.Pickupmessage "You lost 20 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
    {
        toucher.TakeInventory("ZeldaRupee", 20);
        return Super.TryPickup(toucher);
    }
}

class ZeldaGameRupee : ZeldaRupee abstract
{
    property PriceTexture: PriceTexture;
    int PriceTexture;
    int LineId;

    Default
    {
        Scale 0.5;
		Inventory.PickupSound "zelda/rupees";
    }

    States
    {
        Spawn:
            RUP1 AB 8 BRIGHT;
            Loop;
    }

    override void DoPickupSpecial (Actor toucher)
    {
        let me = ZeldaGameRupee(self);
        let controller = MoneyGameController(StaticEventHandler.Find("MoneyGameController"));
        controller.EndGame();
        Super.DoPickupSpecial(toucher);
    }

    override bool CanPickup(Actor toucher)
    {
        return toucher.CountInv("ZeldaRupee") >= 10 && Super.CanPickup(toucher);
    }
}

class ZeldaGameRupee50 : ZeldaGameRupee
{
    Default
    {
        Inventory.Amount 50;
        ZeldaGameRupee.PriceTexture 3;
		Inventory.Pickupmessage "Picked up 50 rupees!";
    }
}

class ZeldaGameRupee20 : ZeldaGameRupee
{
    Default
    {
        Inventory.Amount 20;
        ZeldaGameRupee.PriceTexture 2;
		Inventory.Pickupmessage "Picked up 20 rupees!";
    }
}

class ZeldaGameRupeeNeg10 : ZeldaGameRupee
{
    Default
    {
        Inventory.Amount 0;
        ZeldaGameRupee.PriceTexture 1;
		Inventory.Pickupmessage "You lost 10 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
    {

        toucher.TakeInventory("ZeldaRupee", 10);
        return Super.TryPickup(toucher);
    }
}

class ZeldaGameRupeeNeg40 : ZeldaGameRupee
{
    Default
    {
        Inventory.Amount 0;
        ZeldaGameRupee.PriceTexture 0;
		Inventory.Pickupmessage "You lost 40 rupees!";
    }

    override bool TryPickup (in out Actor toucher)
    {
        toucher.TakeInventory("ZeldaRupee", 40);
        return Super.TryPickup(toucher);
    }
}
