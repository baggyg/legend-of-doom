class ZeldaBomb : ZeldaWeapon
{
    Default
    {
        //$Title Bombs
        Scale 0.5;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "BombAmmo";
        Weapon.SlotNumber 8;
        Inventory.PickupSound "zelda/getitem";
		Inventory.Pickupmessage "Picked up some bombs.";
        +WEAPON.NO_AUTO_SWITCH
        +WEAPON.NOAUTOSWITCHTO
    }

    States
    {
        Spawn:
            BOMB A -1;
            Loop;
        Ready:
            BOMH A 1 A_RaiseShield;
            Loop;
        Fire:
            TNT1 A 16 A_FireProjectile("ZeldaBombProj",0,1,0,-64);
            Goto Ready;
        Select:
            BOMH B 1 A_Raise;
            Loop;
        Deselect:
            BOMH B 1 A_Lower;
            Loop;
    }

    override bool CanPickup(Actor toucher)
    {
        return toucher.CountInv("ZeldaInfiniteBomb") < 1 && Super.CanPickup(toucher);
    }
}

class ZeldaInfiniteBomb : ZeldaBomb
{
    Default
    {
		Weapon.AmmoUse 0;
		Inventory.Pickupmessage "Picked up some bombs.";
        +WEAPON.NO_AUTO_SWITCH
    }

    States
    {
        Spawn:
            BOMB B -1;
            Loop;
        Ready:
            BOMJ A 1 A_RaiseShield;
            Loop;
        Fire:
            TNT1 A 16 A_FireProjectile("ZeldaBombProjRed",0,1,0,-64);
            Goto Ready;
        Select:
            BOMJ B 1 A_Raise;
            Loop;
        Deselect:
            BOMJ B 1 A_Lower;
            Loop;
    }

    override void AttachToOwner(Actor a)
	{
        if (a.CheckInventory("ZeldaBomb", 1))
		{
			a.TakeInventory("ZeldaBomb", 1);
		}
		Super.AttachToOwner(a);
	}
}

class ZeldaBombPickup : ZeldaBomb
{
    mixin InvisiblePickup;

    Default
    {
        //$Title Bombs Invisible
        +INVENTORY.ALWAYSPICKUP
    }

    override bool TryPickup (in out Actor toucher)
    {
        toucher.GiveInventory("ZeldaBomb", 1);
		return false;
    }
}

class ZeldaBomb20 : StoreItem
{
    Default
    {
        //$Title Bombs 20
        StoreItem.Cost 20;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "ZeldaBomb";
    }

    States
    {
        Spawn:
            BOMB A -1 BRIGHT;
            Stop;
    }

    override bool CanPickup(Actor toucher)
    {
        return toucher.CountInv("ZeldaInfiniteBomb") < 1 && Super.CanPickup(toucher);
    }
}

class ZeldaBombProj : Actor
{
    int aliveTime;

    Default
    {
        Speed 0;
        Scale 0.5;
        DamageFunction(4);
        DamageType "Bomb";
		SeeSound "zelda/bombdrop";
        Projectile;
        +NOTIMEFREEZE
        +RANDOMIZE
        +FORCEZERORADIUSDMG
        +THRUGHOST
        +BLOODLESSIMPACT
        +ALLOWTHRUBITS
        ThruBits(1);
    }

    States
    {
        Spawn:
            TNT1 A 0 A_JumpIf(aliveTime > 5, "Explode");
            BOMB A 4 BRIGHT { aliveTime++; }
            Loop;
        Explode:
            TNT1 A 0 A_StartSound("zelda/bombblow", CHAN_AUTO);
            TNT1 A 0
            {
                Spawn("ZeldaFog", pos + (32, 0, 0));
                Spawn("ZeldaFog", pos + (-32, 0, 0));
                Spawn("ZeldaFog", pos + (0, 32, 0));
                Spawn("ZeldaFog", pos + (0, -32, 0));
            }
            Goto Death;
        Death:
            TNT1 A 0 A_Explode(GetMissileDamage(0,1), 150, XF_NOSPLASH, 0, 24);
            Stop;
    }
}

class ZeldaBombProjRed : ZeldaBombProj
{
    States
    {
        Spawn:
            TNT1 A 0 A_JumpIf(aliveTime > 5, "Explode");
            BOMB B 4 BRIGHT { aliveTime++; }
            Loop;
    }
}

class BombAmmo : Ammo
{
	Default
	{
		Inventory.Amount 8;
		Inventory.MaxAmount 10;
		Ammo.BackpackAmount 8;
		Ammo.BackpackMaxAmount 20;
		Inventory.Icon "BOMBA0";
		Inventory.Pickupmessage "Picked up some bombs.";
	}
	States
	{
	Spawn:
		BOMB A -1;
		Stop;
	}
}

class ZeldaMoreBomb : StoreItem
{
    Default
    {
        //$Title Bombs More
        StoreItem.Cost 100;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "Backpack";
		Inventory.Pickupmessage "You can now carry more bombs!";
		-INVENTORY.ALWAYSRESPAWN
    }

    States
    {
        Spawn:
            RUP1 A -1 BRIGHT;
            Loop;
    }

    override bool TryPickup (in out Actor toucher)
    {
        if (toucher.CountInv("Backpack") > 0)
        {
            toucher.TakeInventory("ZeldaRupee", Cost);
            A_StartSound("zelda/rupees", CHAN_AUTO);
	    	Spawn("ZeldaInfiniteBomb", (toucher.pos.x, toucher.pos.y, 32));
            Destroy();
            return true;
        }
        else
        {
            return Super.TryPickup(toucher);
        }
    }

    override bool HandlePickup(Inventory item)
    {
        return Super.HandlePickup(item);
    }
}
