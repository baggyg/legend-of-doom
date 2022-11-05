class Zol : ZeldaMonster
{
    Default
    {
        Health 2;
        DamageFunction(8);
        ZeldaMonster.DropGroup "C";
        Obituary "%o was killed by a Zol";
        Scale 4;
        Radius 34;
        Height 76;
        Mass 2000;
        Speed 4;
        MissileHeight 36;
    }

    States
    {
        Spawn:
            ZOL1 AB 10 A_Look;
            Loop;
        See:
            ZOL1 AABB 4 A_Chase;
            Loop;
        Melee:
            ZOL1 AB 8;
            ZOL1 AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            ZOL1 AB 8;
            Goto See;
    }

	override void Die(Actor source, Actor inflictor, int dmgflags)
    {
        let playerWeapon = players[consoleplayer].ReadyWeapon.GetClassName();
        if (playerWeapon == "ZeldaSwordWood")
        {
            Actor spawn;
            spawn = Spawn("Gel", (pos.x, pos.y, pos.z));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            spawn = Spawn("Gel", (pos.x, pos.y, pos.z));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            spawn = Spawn("Gel", (pos.x, pos.y, pos.z));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
            controller.ReportSpawns(SpawnedBy.user_id, 3, false);
        }
    	Super.Die(source, inflictor, dmgflags);
    }
}

class ZolGrey : Zol
{
    Default
    {
        Translation "124:124=95:95", "112:112=4:4", "119:119=85:85";
    }
}

class ZolBlack : Zol
{
    Default
    {
        Translation "124:124=7:7", "112:112=231:231", "119:119=95:95";
    }
}
