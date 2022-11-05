class ZeldaWhistle : ZeldaWeapon
{
    int cooldown;

    Default
    {
        //$Title Whistle
        Weapon.SlotNumber 7;
		Weapon.AmmoUse 0;
        Scale 0.5;
    }

    States
    {
        Spawn:
            WSTL A -1;
            Loop;
        Ready:
            WSTL B 1 A_RaiseShield;
            Loop;
        Fire:
            TNT1 A 0
            {
                if (invoker.cooldown > 0)
                {
                    return;
                }

                invoker.cooldown = 100;
                A_StartSound("zelda/whistle", CHAN_WEAPON);

                if (level.levelnum != 1)
                {
                    // Look for Digdogger
                    let ti = ThinkerIterator.Create("Digdogger");
                    let dogger = Digdogger(ti.Next());
                    if (dogger)
                    {
                        // Console.PrintF("Digdogger present");
                        dogger.MakeSmall(invoker);
                    }
                    else
                    {
                        // Does the whistle do anything in dungeons?
                        // Console.PrintF("no dogger");
                    }
                }
                else if (pos.x > -11900 && pos.x < -10112 && pos.y < 1536 && pos.y > 640)
                {
                    ACS_NamedExecute("RevealLevel6", 0);
                    A_StartSound("misc/secret", CHAN_WEAPON);
                }
                else
                {
                    // Spawn tornado
                    let spawnPos = (pos.x + 800, pos.y, pos.z);
                    while (CheckPosition(spawnPos.xy) == false)
                    {
                        spawnPos.x -= Radius;
                    }
                    Spawn("Tornado", spawnPos);
                }
            }
            Goto Ready;
        Select:
            WSTL B 1 A_Raise;
            Loop;
        Deselect:
            WSTL B 1 A_Lower;
            Loop;
    }

    override void Tick()
    {
        if (cooldown > 0)
        {
            cooldown--;
        }
    }
}

class Tornado : Actor
{
    Default
    {
        Projectile;
        Radius 64;
        Scale 10;
        Speed 6;
        ThruBits(1);
        +BLOODLESSIMPACT
    }
    States
    {
        Spawn:
            TORN ABCD 4;
            Loop;
        Death:
            TNT1 A 1
            {
                let player = ZeldaPlayer(players[consoleplayer].mo);
                if (player && CheckRange(Radius+player.Radius+10, true) == false)
                {
                    TeleportPlayer();
                }
            }
            Stop;
    }

    override void PostBeginPlay()
    {
        A_ChangeVelocity(Speed*-1, 0, 0, CVF_REPLACE);
        Super.PostBeginPlay();
    }

    // Player should teleport to a random, already beaten dungeon
    // The overworld has `TornadoSpots` whose user_id matches the
    // user_id of Triforce pickups at the end of dungeons.
    void TeleportPlayer()
    {
        Array<string> triforces;
        let player = players[consoleplayer].mo;

        for (Inventory item = player.inv; item!=null; item = item.inv)
        {
            if (item.GetClassName() == "ZeldaTriforce")
            {
                let tri = ZeldaTriforce(item);
                // Console.PrintF("Player has triforce %s", tri.user_id);
                triforces.push(tri.user_id);
            }
        }

        // Loop through Tornado spots and warp to a random entry from `triforces`
        let randomSpot = triforces.Size() == 0
            ? "home"
            : triforces[Random(0, triforces.Size() -1)];

        TornadoSpot mo;
        let ti = ThinkerIterator.Create("TornadoSpot");
        while (mo = TornadoSpot(ti.Next()))
        {
            if (mo.user_id == randomSpot)
            {
                player.SetXYZ(mo.pos);
            }
        }
    }
}

class TornadoSpot : MapSpot
{
    string user_id;

    Default
    {
        //$Title Tornado Spot
    }
}
