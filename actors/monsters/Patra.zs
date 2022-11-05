class PatraWave : Patra
{
    Default
    {
		Patra.WaveHeight 64;
    }
}

class Patra : ZeldaMonster
{
    mixin OrbitingChildren;

    Default
    {
        Health 9;
		DamageFunction(1);
        ZeldaMonster.DropGroup "D";
        Speed 4;
        Scale 3;
		SeeSound "zelda/boss3";
		ActiveSound "zelda/boss3";

        Patra.OrbitSpeed 1;
        Patra.ChildCount 7;
        Patra.ChildClass "BabyCaco";
		Patra.ChildShield true;
        Patra.ChildPulseSpeed 4;
        Patra.ChildDistance 32;
        Patra.ChildDistancePulse 256;
        Patra.ChildZ -1;

        +NOGRAVITY
        +FLOAT
    }

    States
	{
        Spawn:
            PATR AB 4 A_Look;
            Loop;
        See:
        Missile:
            PATR AB 4 A_Chase;
			Loop;

	}
}

class BabyCaco : Actor
{
    mixin HurtOnTouch;

    Default
    {
        Health 6;
        Speed 0;
        Scale 0.5;
        Radius 18;
        Scale 3;
		DamageFunction(4);
        PainChance 256;
		SeeSound "";
		ActiveSound "";
		PainSound "zelda/e_hit";
		DeathSound "zelda/e_die";
        Obituary "%o underestimated a Baby Patra.";
        HitObituary "%o was nibbled to death by a Baby Patra.";
        Monster;
        +NOGRAVITY
        +FLOAT
		+NOCLIP
        +NOBLOOD
        +NOBLOODDECALS
    }

	States
	{
        Spawn:
            BPAT AB 10 A_Look;
            Loop;
        See:
            BPAT AB 3 A_Chase;
            Loop;
        Melee:
        Missile:
            BPAT AB 5 A_FaceTarget;
            Goto See;
        Pain:
			#### # 2 A_Pain;
			#### # 0 A_SetRenderStyle(0.85, STYLE_TranslucentStencil);
			#### # 1 SetShade("ffffff");
			#### # 2 SetShade("ff0000");
			#### # 1 SetShade("ffffff");
			#### # 0 A_SetRenderStyle(1, STYLE_Normal);
			Goto See;
        Death:
            TNT1 A 1 { Spawn("ZeldaDead", pos); }
            Stop;
    }
}
