class Keese : ZeldaMonster
{
    Default
    {
		Health 1;
        DamageFunction(4);
        ZeldaMonster.DropGroup "X";
        Speed 10;
		Radius 32;
		Height 4;
        PainThreshold  1;
        Scale 1.5;
        +FLOAT
		+FLOATBOB
        +NOGRAVITY
        +DONTFALL
        +RETARGETAFTERSLAM
    }

	States
	{
        Spawn:
            KEES AB 10 A_Look;
            Loop;
        See:
            KEES AABB 4 A_Chase;
            Loop;
        Melee:
            KEES AB 8 A_FaceTarget;
            KEES AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            KEES AB 8;
            Goto See;
	}

    override void PostBeginPlay()
    {
        if (pos.z < 32)
        {
            SetXYZ((pos.x, pos.y, 32));
        }
    }
}

class KeeseBrown : Keese
{
    Default
    {
        Translation "203:203=177:177", "196:196=214:214";
    }
}
