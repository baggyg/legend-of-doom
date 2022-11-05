class Peahat : ZeldaMonster
{
    Default
    {
        Health 2;
        DamageFunction(4);
        ZeldaMonster.DropGroup "D";
        Scale 3;
        Speed 8;
        Obituary "%o was killed by Peahat";
    }

	States
	{
        Spawn:
            PEAH AB 4 A_Look;
            Loop;
        See:
            Goto Jump;
        Melee:
            PEAH B 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto Jump;
        Jump:
            TNT1 A 0 { bShootable = false; bSolid = false; }
            PEAH A 0 A_SetFloat;
            PEAH A 0 A_NoGravity;
            PEAH A 10 ThrustThingZ(0, 20, 0, 1);
            PEAH A 0 A_Stop;
            PEAH ABBABABABABABABABABABAB 7 A_Chase;
            Goto Land;
        Wound:
            #### # 2 A_Pain;
			#### # 0 A_SetRenderStyle(0.85, STYLE_TranslucentStencil);
			#### # 1 SetShade("ffffff");
			#### # 2 SetShade("ff0000");
			#### # 1 SetShade("ffffff");
			#### # 0 A_SetRenderStyle(1, STYLE_Normal);
			Goto Jump;
        Land:
            TNT1 A 0 A_Stop;
            TNT1 A 0 { bShootable = true; bSolid = true; }
            PEAH A 0 A_UnsetFloat;
            PEAH A 25 A_LowGravity;
            PEAH A 70;
            PEAH A 70;
            Goto Jump;
    }
}
