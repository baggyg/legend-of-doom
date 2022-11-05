class ZeldaShield : Inventory
{
    Default
    {
        Inventory.Amount 1;
        Inventory.MaxAmount 1;
    }
}

class ZeldaShield160 : ZeldaShield90
{
    Default
    {
        //$Title Shield 160
        StoreItem.Cost 160;
    }
}

class ZeldaShield130 : ZeldaShield90
{
    Default
    {
        //$Title Shield 130
        StoreItem.Cost 130;
    }
}

class ZeldaShield90 : StoreItem
{
    Default
    {
        //$Title Shield 90
        StoreItem.Cost 90;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "ZeldaShield";
        Scale 1.5;
    }

    States
    {
        Spawn:
            SHLD A -1 BRIGHT;
            Stop;
    }
}

/**
*   Sheeld class introduced by kalensar
*/
class Sheeld : Actor
{
    Default
    {
        Projectile;
        Health 1000;
        Height 56;
        Radius 24;
        -NOBLOCKMAP
        +NOBLOOD
        +NOTIMEFREEZE
        +NOCLIP
        +FLOAT
        +SHOOTABLE
        +NOGRAVITY
        +SHIELDREFLECT
        +BLOODLESSIMPACT
        // +REFLECTIVE
        +ALLOWTHRUBITS
        ThruBits(1);
    }

    States
    {
        Spawn:
            TNT1 A 0;
            Stop;
    }

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (damagetype == "Bomb")
        {
            return Super.TakeSpecialDamage(inflictor, source, 0, damagetype);
        }

        let inflictorClass = inflictor.GetClassName();

        if (inflictor.bMissile && inflictorClass != "SpikeTrap")
        {
            // OctorockBall has damage type = weak and so can always be blocked
            // Otherwise, the player must have ZeldaShield which blocks any projectile.
            if (damagetype == "Weak" || target.CountInv("ZeldaShield") > 0)
            {
                damage = 0;
                A_StartSound("zelda/shield", CHAN_AUTO);
            }
        }

        if (damage > 0 && target is "ZeldaPlayer")
        {
            target.DamageMobj(inflictor, source, damage, damagetype);
        }

        let lootController = LootController(StaticEventHandler.Find("LootController"));
        lootController.ReportPlayerHit();

        return Super.TakeSpecialDamage(inflictor, source, 0, damagetype);
    }
}
