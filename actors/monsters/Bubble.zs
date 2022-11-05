class Bubble : Actor
{
    Default
    {
        //$Title Bubble

        Speed 5;
        Damage 0;
        Monster;
        Radius 32;
        Height 56;
        Scale 0.75;
        Health 3000;
        PainChance 0;
        Mass 100;
        Bubble.DisableSeconds 5;
        +DONTTHRUST
        +NOICEDEATH
        +DONTHARMCLASS
        +DONTMORPH
        +NOBLOOD
        +NOBLOODDECALS
		+SPECIAL
    }

	property DisableSeconds: DisableSeconds;
    int DisableSeconds;

    int ticker;
    string playerWeapon;

    override void Touch (Actor toucher)
	{
        Super.Touch(toucher);

        if (toucher is "PlayerPawn" == false || toucher.CountInv("BubbleGun") > 0)
        {
            return;
        }

        ticker = 35 * DisableSeconds;
        playerWeapon = players[consoleplayer].ReadyWeapon.GetClassName();
        toucher.GiveInventory("BubbleGun", 1);
	}

    override void Tick()
    {
        Super.Tick();

        let player = players[consoleplayer].mo;

        if (ticker && ticker > 0)
        {
            ticker--;
        }
        else if (player.CountInv("BubbleGun") > 0 && playerWeapon)
        {
            player.TakeInventory("BubbleGun", 1);
            HDWeaponSelector.Select(player, playerWeapon, 1);
            playerWeapon = "";
        }
    }

    States
    {
        Spawn:
            BUBB AACAACAAC 1 Bright A_Look;
            Loop;
        See:
            BUBB AACAACAAC 1 Bright A_Wander;
            Loop;
	}
}

// A "weapon" given to the player when they bump into a bubble.
class BubbleGun : Weapon
{
    Default
    {
		Weapon.AmmoUse 0;
        +INVENTORY.ALWAYSPICKUP
    }

    States
    {
        Spawn:
            TNT1 A -1;
            Loop;
        Ready:
            TNT1 A 1 A_WeaponReady;
            Loop;
        Fire:
            TNT1 A 1 A_WeaponReady;
            Goto Ready;
        Select:
            TNT1 A 1 A_Raise;
            Loop;
        Deselect:
            TNT1 A 1 A_Lower;
            Loop;
    }

    override void AttachToOwner(Actor owner)
    {
        let ownr=PlayerPawn(owner);
        HDWeaponSelector.Select(ownr,"BubbleGun",1);
        super.AttachToOwner(owner);
    }
}


// Weapon switching technique from Hideous Destruction mod
// https://forum.zdoom.org/viewtopic.php?f=122&t=66455
// https://github.com/mc776/HideousDestructor/blob/dd2cf5f19cda9d0875b631a35f8c82d0cc6919b4/zscript/player/loadout.zs#L80
class HDWeaponSelector : Thinker
{
	Actor other;
	class<Weapon> weptype;

	static void Select(Actor caller, Class<Weapon> weptype, int waittime=10)
    {
		let thth = new("HDWeaponSelector");
		thth.weptype = weptype;
		thth.other = caller;
		thth.ticker = waittime;
	}

	int ticker;

	override void Tick()
    {
		ticker--;
		if (ticker>0) return;
		if (other) other.A_SelectWeapon(weptype);
		Destroy();
	}
}
