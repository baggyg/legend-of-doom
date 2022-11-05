/**
* Swords based on XaserAcheron's [eriguns](https://github.com/XaserAcheron/eriguns) mod.
* Original sprites by Amuscaria.
*
* Ref:
* https://github.com/XaserAcheron/eriguns/blob/master/eriguns2/zscript/eriguns2/weapons/templarsword.txt
*/
class ZeldaSwordWood : ZeldaSword
{
    Actor shield;

	Default
	{
		//$Title Wep Sword Wood
		Inventory.PickupMessage "You got the wooden sword!";
        ZeldaSword.SwordProjectile "ZeldaSwordMissleWood";
		Tag "$TAG_WOODSWORD";
		+WEAPON.TWOHANDED
	}

	States
	{
		Spawn:
			HTSG A -1 Bright;
			Stop;
		Ready:
			HTSG B 1 A_RaiseShield();
			Loop;
		Deselect:
			HTSG B 1 A_Lower();
			Loop;
		Select:
			HTSG B 1 A_Raise();
			Loop;
        Fire:
            TNT1 A 0 A_ClearOverlays;
			HTSG B 1 A_WeaponOffset(16, 48);
			HTSG B 1 A_WeaponOffset(32, 64);
			HTSG B 1 A_WeaponOffset(48, 80);
		Hold:
			HTSG C 2 X_SwordSwing  (48,  0);
			HTSG C 2 A_WeaponOffset( 0, 48);
			HTSG D 2 X_SwordHit    ( 0, 32, 1, "ZeldaSwordMissleWood");
			HTSG E 2;
			HTSG F 2;
			HTSG F 2 A_WeaponOffset(-16, 80);
			TNT1 A 6 A_WeaponOffset(  0, 32);
			TNT1 A 6 A_ReFire();
		RaiseUp:
			HTSG B 1 A_WeaponOffset( 8, 64);
			HTSG B 1 A_WeaponOffset( 6, 56);
			HTSG B 1 A_WeaponOffset( 4, 48);
			HTSG B 1 A_WeaponOffset( 2, 40);
			Goto Ready;
	}

	override void AttachToOwner(Actor a)
	{
		Super.AttachToOwner(a);
		if(a.CheckInventory("BubbleGun", 1))
		{
			a.TakeInventory("BubbleGun", 1);
		}
	}
}

class ZeldaSwordSilver : ZeldaSword
{
	Default
	{
		//$Title Wep Sword Silver
		Inventory.PickupMessage "You got the silver sword!";
        ZeldaSword.SwordProjectile "ZeldaSwordMissleSilver";
		Tag "$TAG_SILVERSWORD";
	}

	States
	{
		Spawn:
			SWD2 A -1 Bright;
			Stop;
		Ready:
			STSG A 1 A_RaiseShield();
			Loop;
		Deselect:
			STSG A 1 A_Lower();
			Loop;
		Select:
			STSG A 1 A_Raise();
			Loop;
		Fire:
            TNT1 A 0 A_ClearOverlays;
			STSG A 1 A_WeaponOffset(16, 48);
			STSG A 1 A_WeaponOffset(32, 64);
			STSG A 1 A_WeaponOffset(48, 80);
			STSG A 0 A_WeaponOffset( 0, 32);
		Hold:
			STSG B 2 X_SwordSwing  (48,  0);
			STSG B 2 A_WeaponOffset( 0, 48);
			STSG C 2 X_SwordHit    ( 0, 32, 2, "ZeldaSwordMissleSilver");
			STSG D 2;
			STSG E 2;
			STSG E 2 A_WeaponOffset(-16, 80);
			TNT1 A 6 A_WeaponOffset(  0, 32);
			TNT1 A 6 A_ReFire();
		RaiseUp:
			STSG A 1 A_WeaponOffset(10, 72);
			STSG A 1 A_WeaponOffset( 8, 64);
			STSG A 1 A_WeaponOffset( 6, 56);
			STSG A 1 A_WeaponOffset( 4, 48);
			STSG A 1 A_WeaponOffset( 2, 40);
			Goto Ready;
	}

    override bool CanPickup(Actor toucher)
	{
		let containers = toucher.CountInv("ZeldaHeartContainerPickup") + toucher.CountInv("ZeldaHeartContainer");
		return containers >= 2 && Super.CanPickup(toucher);
	}

	override void AttachToOwner(Actor a)
	{
		Super.AttachToOwner(a);

		if (a.CheckInventory("BubbleGun", 1))
		{
			a.TakeInventory("BubbleGun", 1);
		}
		if (a.CheckInventory("ZeldaSwordWood", 1))
		{
			a.TakeInventory("ZeldaSwordWood", 1);
		}
	}
}

class ZeldaSwordMaster : ZeldaSword
{
	Default
	{
		//$Title Wep Sword Master
		Inventory.PickupMessage "You got the master sword!";
        ZeldaSword.SwordProjectile "ZeldaSwordMissleMaster";
		Tag "$TAG_MASTERSWORD";
	}

	States
	{
		Spawn:
			SWD3 A -1 Bright;
			Stop;
		Ready:
			MTSP A 1 A_RaiseShield();
			Loop;
		Deselect:
			MTSP A 1 A_Lower();
			Loop;
		Select:
			MTSP A 1 A_Raise();
			Loop;
		Fire:
            TNT1 A 0 A_ClearOverlays;
			MTSP A 1 A_WeaponOffset(16, 48);
			MTSP A 1 A_WeaponOffset(32, 64);
			MTSP A 1 A_WeaponOffset(48, 80);
			MTSP A 0 A_WeaponOffset( 0, 32);
		Hold:
			MTSP B 2 X_SwordSwing  (48,  0);
			MTSP B 2 A_WeaponOffset( 0, 48);
			MTSP C 2 X_SwordHit    ( 0, 32, 4, "ZeldaSwordMissleMaster");
			MTSP D 2;
			MTSP E 2;
			MTSP E 2 A_WeaponOffset(-16, 80);
			TNT1 A 6 A_WeaponOffset(  0, 32);
			TNT1 A 6 A_ReFire();
		RaiseUp:
			MTSP A 1 A_WeaponOffset(10, 72);
			MTSP A 1 A_WeaponOffset( 8, 64);
			MTSP A 1 A_WeaponOffset( 6, 56);
			MTSP A 1 A_WeaponOffset( 4, 48);
			MTSP A 1 A_WeaponOffset( 2, 40);
			Goto Ready;
	}

    override bool CanPickup(Actor toucher)
	{
		let containers = toucher.CountInv("ZeldaHeartContainerPickup") + toucher.CountInv("ZeldaHeartContainer");
		return containers >= 9 && Super.CanPickup(toucher);
	}

	override void AttachToOwner(Actor a)
	{
		Super.AttachToOwner(a);
        if (a.CheckInventory("BubbleGun", 1))
		{
			a.TakeInventory("BubbleGun", 1);
		}
		if (a.CheckInventory("ZeldaSwordSilver", 1))
		{
			a.TakeInventory("ZeldaSwordSilver", 1);
		}
		if (a.CheckInventory("ZeldaSwordWood", 1))
		{
			a.TakeInventory("ZeldaSwordWood", 1);
		}
	}
}

class ZeldaSword : ZeldaWeapon abstract
{
    bool CanMissile;
    Actor SpawnedSword;

    property SwordProjectile: SwordProjectile;
    string SwordProjectile;

	Default
	{
		Scale 0.5;
        Weapon.SelectionOrder 1;
        Weapon.SlotNumber 1;
        Weapon.SlotPriority 100;
		+WEAPON.WIMPY_WEAPON;
		+WEAPON.MELEEWEAPON;
		+WEAPON.NOALERT;
	}

	action void X_SwordSwing(double offsetX, double offsetY)
	{
		A_WeaponOffset(offsetX, offsetY);
		A_StartSound("zelda/sword_slash", CHAN_WEAPON);
	}

	action void X_SwordHit(double offsetX, double offsetY, int damage, string missleClass)
	{
        if (player == null) return;

		int alflags = invoker.bOffhandWeapon ? ALF_ISOFFHAND : 0;

		A_WeaponOffset(offsetX, offsetY);

		if (invoker.SpawnedSword || player.Health < player.mo.GetMaxHealth())
		{
			A_CustomPunch(damage, true, CPF_NOTURN, "NoPuff", 150);
		}
		else
		{
			invoker.SpawnedSword = SpawnPlayerMissile (missleClass, aimflags: alflags);
		}
	}
}

/**
* Missles
*/
class ZeldaSwordMissleWood : ZeldaSwordMissle
{
	Default
	{
      	DamageFunction (1);
	}

    States
	{
		Spawn:
            S1MI A 50 Bright;
            Goto Death;
	}
}

class ZeldaSwordMissleSilver : ZeldaSwordMissle
{
	Default
	{
      	DamageFunction (2);
	}

    States
	{
		Spawn:
			S2MI A 50 Bright;
			Goto Death;
	}
}

class ZeldaSwordMissleMaster : ZeldaSwordMissle
{
	Default
	{
      	DamageFunction (4);
	}

    States
	{
		Spawn:
			S3MI A 50 Bright;
			Goto Death;
	}
}

class ZeldaSwordMissle : Actor abstract
{
	Default
	{
        Radius 11;
		Height 8;
		Speed 20;
		SeeSound "zelda/sword_shoot";
		DeathSound "";
		Projectile;
		+NOTIMEFREEZE
        +THRUGHOST
        +BLOODLESSIMPACT
	}

    States
	{
		Death:
			S2MI E 4 Bright A_Explode(0);
			S2MI B 4 Bright;
			S2MI C 3 Bright;
			S2MI D 2 Bright;
			Stop;
	}
}

class NoPuff : Actor
{
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+ALLOWPARTICLES
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Translucent";
		Alpha 0;
	}
	States
	{
	Spawn:
		PUFF A 4 Bright;
		PUFF B 4;
	Melee:
		PUFF CD 4;
		Stop;
	}
}
