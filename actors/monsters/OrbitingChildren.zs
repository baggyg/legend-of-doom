// Experiment in named properties on a mixin.
// Used by Patra and Manhandla
mixin class OrbitingChildren
{
	// Required. The class that will be spawned
	// Default: null
	property ChildClass: ChildClass;
	String ChildClass;

	// Required. How many children to spawn
	// Default: null
	property ChildCount: ChildCount;
	int ChildCount;

	// How fast the children orbit around parent
	// Default: 1
	property OrbitSpeed: OrbitSpeed;
	int OrbitSpeed;

	// How far away the spawned children are placed
	// Default: 64
	property ChildDistance: ChildDistance;
	int ChildDistance;

	// How far away children move from `ChildDistance`
	// when they pulse away from the parent.
	// Default: null
	property ChildDistancePulse: ChildDistancePulse;
	int ChildDistancePulse;

	// How fast the children move away from and back
	// towards the parent.
	// Default: 2
	property ChildPulseSpeed: ChildPulseSpeed;
	int ChildPulseSpeed;

	// Sets z offset for the children.
	// Default: parent.pos.z
	property ChildZ: ChildZ;
	int ChildZ;

	// If set will cause the ring of orbiting children
	// to wobble as the child z values move up and down.
	// Without out this, a standard circular orbit will occur.
	// Default: 0
	property WaveHeight: WaveHeight;
	int WaveHeight;

	// Must be used with `WaveHeight` causes more of
	// a wavy affect in addition to the wobble.
	// Values like 0.5 and 2.0 produce interestin, though uneven functions/movements.
	// Default: 1
	property WaveLength: WaveLength;
	double WaveLength;

	// If True then the parent will not be killable
	// until all spawned children are dead.
	// Default: false
	property ChildShield: ChildShield;
	bool ChildShield;

    // Force children to point away from center, not
    // towards the player. Avoid using A_FaceTarget on children.
    property FixChildAngles: FixChildAngles;
    bool FixChildAngles;

    // Used to make manhandla increase speed as
    // children are killed.
    // Default: false
    property SpeedIncreaseOnChildDeath: SpeedIncreaseOnChildDeath;
    bool SpeedIncreaseOnChildDeath;

	// Internal tracking
	Array<Actor> Children;
    Array<int> ChildAngles;
    int rotateOffset;
	int pulseOffset;
	double angleInc;

	int zChange;
	int zVariance;
	int zOffset;
	int pulseChange;

    override void PostBeginPlay()
    {
		if (!WaveHeight) WaveHeight = 0;
		if (!WaveLength) WaveLength = 1;
		if (!ChildZ) ChildZ = pos.z;
		if (!ChildDistance) ChildDistance = 64;
		if (!ChildPulseSpeed) ChildPulseSpeed = 2;
		if (!SpeedIncreaseOnChildDeath) SpeedIncreaseOnChildDeath = 0;
		pulseChange = ChildDistancePulse ? ChildPulseSpeed : 0;
		zChange = WaveHeight ? 1 : 0;
		zVariance = WaveHeight;
		angleInc = 360 / ChildCount;
        rotateOffset = 0;
		pulseOffset = 0;

        int angle, i;
        for (i = 0; i < ChildCount; i++)
        {
            angle = i * angleInc;
            Children.Push(Spawn(ChildClass, Vec3Angle(ChildDistance, angle)));
        }

		Super.PostBeginPlay();
    }

    override void Tick()
    {
        Super.Tick();

        rotateOffset += OrbitSpeed;

        if (rotateOffset >= 360)
		{
			// Reset after one full rotation so
			// rotateOffset doesn't go on and on.
			rotateOffset = 1;
		}

		// Move children in and out.
		if (pulseOffset >= ChildDistancePulse || pulseOffset < 0)
		{
			pulseChange = pulseChange * -1;
		}
		pulseOffset += pulseChange;

		// Might be more smooth if this sort of check
		// were done on each individual child z.
		if (zVariance >= WaveHeight)
		{
			zOffset = -1 * zChange;
		}
		else if (zVariance <= WaveHeight * -1)
		{
			zOffset = 1 * zChange;
		}
		zVariance += zOffset;

        int angle, i;
		double z;
        for (i = 0; i < Children.Size(); i++)
        {
			// Make sure that Children.Size() shrinks when a spawn is killed
			if (!Children[i])
			{
				Children.Delete(i, 1);

                A_StartSound("zelda/e_die");

                if (SpeedIncreaseOnChildDeath > 0)
                {
                    Speed += SpeedIncreaseOnChildDeath;
                }

				continue;
			}

			// Move child
            angle = i * angleInc + rotateOffset;
		 	z = zVariance * sin(angle / WaveLength) + ChildZ;
			Children[i].SetOrigin(Vec3Angle(ChildDistance+pulseOffset, angle, z), true);

            if (FixChildAngles)
            {
                Children[i].angle = i * (360 / ChildCount);
            }
        }
    }

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
	{
		if (ChildShield && Children.Size() > 0)
		{
			damage = 0;
		}
		return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
	}
}
