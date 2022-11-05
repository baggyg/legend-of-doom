class Boomerang : Weapon
{
    Actor spawned;

    Default
    {
        //$Title Boomerang
        Weapon.AmmoUse 0;
        Scale 2.5;
        +INVISIBLE
        +WEAPON.NO_AUTO_SWITCH
    }

    States
    {
        Spawn:
            BOOM A -1;
            Stop;
        Ready:
            BOMR A 1 A_WeaponReady;
            Loop;
        ReadyNoShow:
            // TNT1 A 1 A_WeaponReady;
            TNT1 A 1 A_JumpIf(!invoker.spawned, "Ready");
            Loop;
        Fire:
            TNT1 A 8
            {
                if (invoker.spawned) return;
                invoker.spawned = SpawnPlayerMissile("BoomerangProj");
            }
            Goto ReadyNoShow;
        Select:
            BOMR A 1 A_Raise;
            Loop;
        Deselect:
            BOMR A 1 A_Lower;
            Loop;
    }

    override bool CanPickup(Actor toucher)
    {
        return !bInvisible && toucher.CountInv("BoomerangBlue") < 1 && Super.CanPickup(toucher);
    }
}

class BoomerangBlue : Boomerang
{
    Default
    {
        //$Title Boomerang blue
    }

    States
    {
        Spawn:
            BOOM B -1;
            Stop;
        Ready:
            BOMR B 1 A_WeaponReady;
            Loop;
        Fire:
            TNT1 A 8
            {
                // This is no longer used since Boomerang
                // was made the alt-fire for everything.
                // Boomerang projectiles are spawned by ZeldaWeapon if
                // the Boomerang item is in the player's inventory.
                if (invoker.spawned) return;
                int alflags = invoker.bOffhandWeapon ? ALF_ISOFFHAND : 0;
                invoker.spawned = SpawnPlayerMissile("BoomerangProjBlue", aimflags: alflags);
            }
            Goto ReadyNoShow;
        Select:
            BOMR B 1 A_Raise;
            Loop;
        Deselect:
            BOMR B 1 A_Lower;
            Loop;
    }

    override void AttachToOwner(Actor a)
    {
        Super.AttachToOwner(a);
        if (a.CheckInventory("Boomerang", 1))
        {
            a.TakeInventory("Boomerang", 1);
        }
    }
}

// Based on Jarewill's example
// https://forum.zdoom.org/viewtopic.php?f=122&t=72179
class BoomerangProj : Actor
{
    int backtime;

    Default
    {
        DamageFunction(1);
        DamageType "Stun";
        Radius 6;
        Height 8;
        Speed 10;
        FastSpeed 20;
        Projectile;
        Scale 2.5;
        +RANDOMIZE
        +ZDOOMTRANS
        +NOTIMEFREEZE
        +THRUGHOST
        +BLOODLESSIMPACT
        +ALLOWTHRUBITS
        ThruBits(1);
    }

    States
    {
    Spawn:
        TNT1 A 0 NoDelay A_StartSound("zelda/arrow", CHAN_WEAPON, CHANF_LOOP);
        TNT1 A 0 A_JumpIf(backtime > 5, "Back");
        BOOM CCDDEEFF 2 BRIGHT
        {
            backtime++;
        }
        Loop;
    Back:
        TNT1 A 0 {tracer=target;}
        BOOM CCDDEEFF 2 BRIGHT
        {
            if (tracer == null) return;

            A_Tracer2();

            if (Distance2D(tracer) <= 15.0)
            {
                Destroy();
            }
        }
        Goto Back+1;

    Death:
        TNT1 A 0
        {
            tracer=target;
        }
        BOM1 ABC 3 BRIGHT;
        Stop;
    }
}

class BoomerangProjBlue : BoomerangProj
{
    Default
    {
        Speed 20;
        FastSpeed 30;
    }

    States
    {
        Spawn:
            TNT1 A 0 NoDelay A_StartSound("zelda/arrow", CHAN_WEAPON, CHANF_LOOP);
            TNT1 A 0 A_JumpIf(backtime > 15,"Back");
            BOOM GGHHIIJJ 2 BRIGHT
            {
                backtime++;
            }
            Loop;
        Back:
            TNT1 A 0 {tracer=target;}
            BOOM GGHHIIJJ 2 BRIGHT
            {
                if (tracer)
                {
                    A_Tracer2();
                    if (Distance2D(tracer)<=16.0)
                    {
                        Destroy();
                    }
                }
            }
            Goto Back+1;
    }
}
