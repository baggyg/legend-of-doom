class CandleRed : ZeldaWeapon
{
    Default
    {
        //$Title Candle Red
        Scale 0.5;
		Weapon.AmmoUse 0;
        Weapon.SlotNumber 5;
        DamageType "Fire";
		Inventory.Pickupmessage "You got the red candle!";
        +WEAPON.NO_AUTO_SWITCH
        +WEAPON.TWOHANDED
    }

    States
    {
        Spawn:
            CNDL A -1;
            Loop;
        Ready:
            CNDR AE 8 BRIGHT A_RaiseShield;
            Loop;
        Fire:
            TNT1 A 0 A_StartSound("zelda/candle", CHAN_WEAPON);
            TNT1 A 16 A_FireProjectile("CandleFire",0,1,0,0);
            Goto Ready;
        Select:
            CNDR A 1 A_Raise;
            Loop;
        Deselect:
            CNDR A 1 A_Lower;
            Loop;
    }

    override void AttachToOwner(Actor a)
	{
		Super.AttachToOwner(a);

        if (self.GetClassName() == "CandleBlue")
        {
            return;
        }

        if (a.CheckInventory("CandleBlue", 1))
		{
			a.TakeInventory("CandleBlue", 1);
		}
	}
}

class CandleBlue : CandleRed
{
    Default
    {
		Inventory.Pickupmessage "You got the blue candle!";
    }

    States
    {
        Spawn:
            CNDL B -1;
            Loop;

        Select:
            TNT1 A 0 A_JumpIf(CanFire() == false, "SelectNoShow");
            CNDR B 1 A_Raise;
            Loop;
        SelectNoShow:
            CNDR D 1 A_Raise;
            Loop;

        Deselect:
            TNT1 A 0 A_JumpIf(CanFire() == false, "DeselectNoShow");
            CNDR B 1 A_Lower;
            Loop;
        DeselectNoShow:
            CNDR D 1 A_Lower;
            Loop;

        Ready:
            TNT1 A 0 A_JumpIf(CanFire() == false, "ReadyNoShow");
            CNDR BC 8 BRIGHT A_RaiseShield;
            Loop;
        ReadyNoShow:
            CNDR D 1 BRIGHT A_RaiseShield;
            TNT1 A 0
            {
                if (CanFire())
                {
                    return A_Jump(256, "Ready");
                }
                return A_Jump(256, "ReadyNoShow");
            }
        Fire:
            TNT1 A 0
            {
                if (CanFire() == false)
                {
                    return A_Jump(256, "ReadyNoShow");
                }
                A_StartSound("zelda/candle", CHAN_WEAPON);
                A_FireProjectile("CandleFire",0,1,0,0);
                RegisterFire();
                return A_Jump(256, "ReadyNoShow");
            }
    }

    override bool CanPickup(Actor toucher)
	{
		return toucher.CountInv("CandleRed") == 0 && Super.CanPickup(toucher);
	}

    action bool CanFire()
    {
        let zplayer = ZeldaPlayer(players[consoleplayer].mo);
        return zplayer && zplayer.CanFireCandle;
    }

    action void RegisterFire()
    {
        let zplayer = ZeldaPlayer(players[consoleplayer].mo);
        if (zplayer == null) return;
        zplayer.CandleFired();
    }
}

class CandleBlueStore : StoreItem
{
    Default
    {
        //$Title Store Blue Candle
        StoreItem.Cost 60;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "CandleBlue";
		Inventory.Pickupmessage "You got the blue candle!";
    }

    States
    {
        Spawn:
            CNDL B -1 BRIGHT;
            Loop;
    }
}

class CandleFire : Actor
{
    int aliveTime;

    Default
    {
        Speed 3;
        Scale 0.5;
        Projectile;
        DamageType "Fire";
        DamageFunction(1);
        +NOTIMEFREEZE
        +RANDOMIZE
        +STEPMISSILE
        +FORCEZERORADIUSDMG
        +FLOORHUGGER
        +BLOODLESSIMPACT
        +ALLOWTHRUBITS
        ThruBits(1);
    }

    States
    {
        Spawn:
            TNT1 A 0 A_JumpIf(aliveTime > 8, "Death");
            FIRE AB 8 BRIGHT { aliveTime++; }
            Loop;
        Death:
            TNT1 A 0 A_Die;
            Stop;
    }

    override void PostBeginPlay()
    {
        let controller = MapController(StaticEventHandler.Find("MapController"));
        controller.LightRoom();
    }
}
