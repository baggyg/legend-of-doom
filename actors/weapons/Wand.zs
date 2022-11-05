class ZeldaWand : FireCrystal
{
    Default
    {
        //$Title Wand
        Scale 0.5;
        Weapon.SlotNumber 6;
    }
}

class FireCrystal : ZeldaWeapon
{
    Default
    {
        Weapon.YAdjust 0;
        Inventory.PickupMessage "You got the wand!";
        -BLOODSPLATTER
        +WEAPON.TWOHANDED
    }

  States
  {
    Spawn:
        WAND A -1;
        Stop;
    Ready:
        FWND A 1 A_RaiseShield;
        Loop;
    Deselect:
        FWND A 1 A_Lower;
        Loop;
    Select:
        FWND A 1 A_Raise;
        Loop;
    Fire:
        TNT1 A 0 A_ClearOverlays;
        FWND B 0 BRIGHT;
        FWND B 4 BRIGHT;
        FWND B 0 A_FireProjectile ("WandProjectile", 0, 0, 0, 9);
        FWND C 4 BRIGHT;
        FWND D 4 BRIGHT;
        FWND E 4 BRIGHT;
        TNT1 A 5 ;
        FWND FA 4;
        FWND A 0 A_ReFire;
        Goto Ready;
  }
}

class WandProjectile : Rocket
{
    Default
    {
        Speed 10;
        Radius 11;
        Height 8;
        Scale 0.5;
        DamageFunction(2);
        SeeSound "zelda/wand";
        DeathSound "";
        Projectile;
        +THRUGHOST
        +NOTIMEFREEZE
        +BLOODLESSIMPACT
        -ROCKETTRAIL
    }

  States
  {
    Spawn:
        WANP AB  4 Bright;
        Loop;
    Death:
        TNT1 A 0
        {
            let player = players[consoleplayer].mo;
            if (target is "ZeldaPlayer" && player.CheckInventory("ZeldaBook", 1))
            {
                // Fire won't spawn on top of something, so it must
                // be offset in the direction of the player
                let vec = Vec3To(player);
                let spawnPos = pos + (10 * Signum(vec.x), 10 * Signum(vec.y), pos.z);
                let spawned = Spawn("CandleFire", spawnPos);
                spawned.Thrust(1, player.angle);
            }
        }
        S2MI B 8 Bright A_Explode(0);
        S2MI C 6 Bright;
        S2MI D 4 Bright;
        Stop;
  }

    int Signum(double x)
    {
        if (x > 0) return 1;
        if (x < 0) return -1;
        return 0;
    }
}

class ZeldaBook : UniqueItem
{
    Default
    {
        //$Title Book
        Inventory.PickupMessage "Picked up a spell book!";
        Inventory.PickupSound "zelda/fanfare";
        Scale 0.5;
    }

  	States
    {
        Spawn:
            BOOK A -1;
            Stop;
    }
}
