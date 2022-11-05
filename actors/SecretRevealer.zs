class SecretRevealer : SecretTrigger
{
    int user_lineId, user_sectorId, user_stairFlatId, user_LineFlatId;

    // "Bomb" or "Fire"
    property user_triggeredBy: user_triggeredBy;
    string user_triggeredBy;

    Default
    {
        //$Title Secret Wall Trigger
        Radius 64;
        Height 64;
        SecretRevealer.user_triggeredBy "Bomb";
        +SHOOTABLE
        -NOBLOCKMAP
        -NOSECTOR
        -NOGRAVITY
        +INVISIBLE
        +NOBLOOD
    }

    States
    {
        Spawn:
            BOMB A -1;
            Stop;
    }

	override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        let mapController = MapController(StaticEventHandler.Find("MapController"));

        let isRegistered = mapController.IsSecretRegistered(user_lineId);

        if (isRegistered)
        {
            Reveal(self);
        }

        //Console.PrintF("Secret %i: %i", user_lineId, isRegistered);
    }

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (damagetype == user_triggeredBy)
        {
            let mapController = MapController(StaticEventHandler.Find("MapController"));
            mapController.RegisterSecret(user_lineId);
            // A_StartSound("misc/secret");
            Reveal(inflictor);
        }

        return Super.TakeSpecialDamage(self, self, damage, damagetype);
    }

    void Reveal(Actor inflictor)
    {
        //Console.PrintF("Revealing l:%i s:%i f:%i", user_lineId, user_sectorId, user_stairFlatId);

        if (level.levelnum == 1)
        {
            // Overworld bomb wall or bush
            CallACS("RevealSecret", user_lineId, user_sectorId, user_stairFlatId, user_LineFlatId);
        }
        else
        {
            // Dungeon bomb wall
            CallACS("OpenDoor", user_lineId, 1, 0);
        }

        Activate(inflictor);
    }
}

class SecretBush : SecretRevealer
{
    Default
    {
        //$Title Secret Bush
        Radius 16;
        SecretRevealer.user_triggeredBy "Fire";
        -INVISIBLE
        +SOLID
    }

    States
    {
        Spawn:
            BSHX A -1;
            Stop;
    }
}

class SecretBushBrown : SecretBush
{
    Default
    {
        //$Title Secret Bush Brown
    }

    States
    {
        Spawn:
            BSHY A -1;
            Stop;
    }
}

class SecretBushInvisible : SecretBush
{
    Default
    {
        //$Title Secret Bush Invisible
        +INVISIBLE
    }

    States
    {
        Spawn:
            BSHB A -1;
            Stop;
    }
}
