class Ganon : ZeldaMonster
{
    Default
    {
        Health(17);
        DamageFunction(16);
        ZeldaMonster.DropGroup "G";
        Scale 3;
		SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
        +MISSILEMORE
        +GHOST
        +NOCLIP
    }

    States
    {
        Spawn:
            GANO AB 30 A_Look;
            Loop;
        See:
            TNT1 A 0
            {
                A_SetTranslucent(0, 0);
                bShootable = true;
                bGhost = true;
            }
            GANO ABCDE 4 A_Chase;
            Loop;
        Pain:
            #### # 0 A_JumpIf(Health == 1, "Hurt");
            #### # 1
            {
                A_SetTranslucent(1, 0);
                bShootable = false;
            }
            #### # 70;
            #### # 0 { TeleMove(); }
            Goto See;
        Melee:
        Missile:
            #### # 8 A_FaceTarget;
            #### # 6 A_SpawnProjectile("ZeldaProjectile",42,0,0,0);
            #### # 8 A_FaceTarget;
            Goto See;
        Hurt:
            GANO FG 4;
            #### # 1
            {
                A_SetTranslucent(1, 0);
                bShootable = true;
                bGhost = false;
            }
            #### # 150;
            #### # 1
            {
                // If Ganon isn't killed during his brown,
                // hurt phase he heals to full health.
                Health = Default.Health;
                TeleMove();
            }
            Goto See;
    }

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (Health == 1 && damagetype != "SilverArrow")
        {
            damage = 0;
        }
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }

    private void TeleMove()
    {
        let newPos = GetSpawnPosition();
        SetXYZ(newPos);
    }

    private Vector3 GetSpawnPosition()
    {
        FCheckPosition fCheckPos;
        let spawnDest = GetPosition();
        while (!CheckPosition(spawnDest.xy, false, fCheckPos) || fCheckPos.CurSector.GetUDMFString("user_spawntype") != "Land")
        {
            spawnDest = GetPosition();
        }

        return spawnDest;
    }

    private Vector3 GetPosition()
    {
        let teleRadius = 400;
        return (pos.x + Random(-teleRadius, teleRadius),
                pos.y + Random(-teleRadius, teleRadius),
                pos.z );
    }
}
