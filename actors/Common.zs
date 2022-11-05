class ZeldaFog : Actor
{
    Default
	{
		+NOBLOCKMAP
		+NOTELEPORT
		+NOGRAVITY
		+ZDOOMTRANS
		+NOTIMEFREEZE
        +NOBLOOD
        +NOINTERACTION
		RenderStyle "Add";
	}

	States
    {
		Spawn:
			ZFOG ABABCBCBCC 6 BRIGHT;
			Stop;
	}
}

class ZeldaProjectile : Actor
{
	Default
	{
		Radius 6;
		Height 8;
		Speed 16;
        Scale 1.5;
		FastSpeed 20;
		DamageFunction(8);
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
        +ALLOWTHRUBITS
		+NOTIMEFREEZE
        +BLOODLESSIMPACT
        ThruBits(2);
	}

	States
	{
        Spawn:
            BALL AB 4 BRIGHT;
            Loop;
        Death:
            S2MI B 8 Bright;
            S2MI C 6 Bright;
            S2MI D 4 Bright;
            Stop;
	}
}

class SwordProjectile : ZeldaProjectile
{
    Default
    {
        Scale 3;
    }

    States
    {
        Spawn:
            SPRO ABCD 4 BRIGHT;
            Loop;
    }
}

class SwordProjectileTwo : SwordProjectile
{
    Default
    {
        DamageFunction(16);
    }
}

mixin class HurtOnTouch
{
    Default
    {
        +SPECIAL
    }

	override void Touch (Actor toucher)
	{
		toucher.DamageMobj (self, self, GetMissileDamage(0,1), DamageType);
        Super.Touch(toucher);
	}
}

mixin class InvisiblePickup
{
    Default
    {
        +INVISIBLE
        +Inventory.RESTRICTABSOLUTELY
    }

    override bool CanPickup(Actor toucher)
	{
		return !bInvisible && Super.CanPickup(toucher);
	}
}

mixin class TimeLimited
{
	int ticksToLive;

	override void PostBeginPlay()
	{
        Super.PostBeginPlay();
		ticksToLive = 1050; // 30s default
	}

	override void Tick()
	{
		Super.Tick();
		if (GetAge() > ticksToLive)
		{
			self.Destroy();
		}
	}
}
