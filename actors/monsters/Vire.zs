class Vire : ZeldaMonster
{
    Default
    {
        Health 4;
        DamageFunction(8);
        ZeldaMonster.DropGroup "B";
        OBITUARY "%o was killed a Vire";
        Scale 3;
        Speed 10;
        +Float
        +FloatBob
        +NoGravity
    }

    States
    {
        Spawn:
            VIRE AABB 8 A_Look;
            Loop;
        See:
            VIRE AABB 4 A_Chase;
        Melee:
            VIRE AB 8 A_FaceTarget;
            VIRE A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            VIRE AB 8;
            Goto See;
    }

    override void PostBeginPlay()
    {
        if (pos.z < 32)
        {
            SetXYZ((pos.x, pos.y, 32));
        }

        Super.PostBeginPlay();
    }

    override void Die(Actor source, Actor inflictor, int dmgflags)
    {
        bFloatBob = 0;
        let playerWeapon = players[consoleplayer].ReadyWeapon.GetClassName();
        if (playerWeapon == "ZeldaSwordWood")
        {
            Actor spawn;
            spawn = Spawn("KeeseBrown", (pos.x, pos.y, 32));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            spawn = Spawn("KeeseBrown", (pos.x, pos.y, 32));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            spawn = Spawn("KeeseBrown", (pos.x, pos.y, 32));
            ZeldaMonster(spawn).SpawnedBy = SpawnedBy;

            let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
            controller.ReportSpawns(SpawnedBy.user_id, 3, false);
        }
    	Super.Die(source, inflictor, dmgflags);
    }
}
