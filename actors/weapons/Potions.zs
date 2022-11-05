class ZeldaPotion : Weapon
{
	Default
	{
		Scale 0.5;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 0;
		Weapon.AmmoType "PotAmmo";
        Weapon.SlotNumber 8;
		Inventory.Pickupmessage "Picked up a potion!";
        +WEAPON.TWOHANDED
	}

    States
    {
        Spawn:
            POT1 A -1;
            Loop;

        Ready:
			TNT1 A 0 A_JumpIfInventory("PotAmmo", 2, "RedReady");
            POTG A 1 A_RaiseShield;
            Loop;

		RedReady:
            POTG B 1 A_RaiseShield;
			Loop;

        Select:
			TNT1 A 0 A_JumpIfInventory("PotAmmo", 2, "RedSelect");
            POTG A 1 A_Raise;
            Loop;

        RedSelect:
            POTG B 1 A_Raise;
            Loop;

        Deselect:
			TNT1 A 0 A_JumpIfInventory("PotAmmo", 2, "RedDeselect");
            POTG A 1 A_Lower;
			Loop;

        RedDeselect:
            POTG B 1 A_Lower;
            Loop;

        Fire:
            TNT1 A 0
			{
				let player = PlayerPawn(players[consoleplayer].mo);
				if (player.Health == player.GetMaxHealth()) return;

				HealThing(128);
				A_StartSound("zelda/fairy", CHAN_WEAPON);
				TakeInventory("PotAmmo", 1);
			}
            Goto Ready;
    }

    // For some reason, when this inherits ZeldaWeapon
    // The Potion weapon is always selectable even with
    // no ammo. When the shield stuff is applied directly,
    // it's not a problem.
    action void A_RaiseShield()
    {
        A_WeaponReady();
        A_SpawnItemEx("SHEELD", 15, 0, 15, flags: SXF_SETTARGET);

        let player = players[consoleplayer].mo;
        if (player && player.CountInv("ZeldaShield") > 0)
        {
            A_Overlay(2, "BigShieldReady");
        }
        else
        {
            A_Overlay(2, "ShieldReady");
        }
    }
}

class PotAmmo : Ammo
{
	Actor player;

	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 2;
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 2;
		Scale 0.5;
		Inventory.PickupSound "zelda/fanfare";
		Inventory.Pickupmessage "Picked up a potion!";
	}
}

// Special potion presented when choosing between
// HeartContainer and a potion.
class ZeldaUniquePotion : UniqueItem
{
	Default
	{
		//$Title Potion Unique
		Scale 0.5;
		Inventory.PickupSound "zelda/fanfare";
		Inventory.Pickupmessage "Picked up a potion!";
	}
	States
	{
		Spawn:
			POT2 A -1 BRIGHT;
			Stop;
	}

	override void DoPickupSpecial(Actor other)
	{
		let player = players[consoleplayer].mo;
		player.GiveInventory("PotAmmo", 2);
		Super.DoPickupSpecial(other);
	}

    override bool CanPickup(Actor toucher)
	{
		return toucher.CountInv("PotAmmo") < 2 && Super.CanPickup(toucher);
	}
}

class StorePotionBlue : StoreItem
{
    Default
    {
        StoreItem.Cost 40;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "PotAmmo";
		Inventory.Pickupmessage "Picked up a potion!";
    }

	States
    {
        Spawn:
            POT1 A -1 BRIGHT;
            Loop;
	}

	override bool CanPickup(Actor toucher)
    {
        return toucher.CountInv("PotAmmo") <= 1 && Super.CanPickup(toucher);
    }
}

class StorePotionRed : StoreItem
{
    Default
    {
        StoreItem.Cost 68;
        StoreItem.GiveAmount 2;
        StoreItem.GiveItem "PotAmmo";
		Inventory.Pickupmessage "Picked up a potion!";
    }

    States
    {
        Spawn:
            POT2 A -1 BRIGHT;
            Loop;
	}

	override bool CanPickup(Actor toucher)
    {
        return toucher.CountInv("PotAmmo") < 2 && Super.CanPickup(toucher);
    }
}
