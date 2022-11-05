/**
*   Provides actors with methods required to be tracked
*   properly by SpawnController.
*/
class ZeldaMonster : Actor abstract
{
    mixin HurtOnTouch;

    property DropGroup: DropGroup;
    string DropGroup;

	property ShowSpawnFog: ShowSpawnFog;
    bool ShowSpawnFog;

    Name LastDamageType;

    // Set by the ZeldaSpawner.SpawnMonsters
    ZeldaSpawner SpawnedBy;

    int RenderStyleCache;

	Default
    {
		Monster;
        Radius 32;
        Height 64;
        Speed 8;
		PainChance 256;
		SeeSound "";
		ActiveSound "";
		AttackSound "";
		PainSound "zelda/e_hit";
		DeathSound "zelda/e_die";
        ZeldaMonster.ShowSpawnFog true;
        ThruBits(2);
        +RANDOMIZE
        +FLOORCLIP
        +FORCEPAIN
        +LOOKALLAROUND
        +DONTHARMCLASS
        +DONTHARMSPECIES
        +NOINFIGHTSPECIES
        +NOBLOOD
        +NOBLOODDECALS
        +NOICEDEATH
	}

    States
    {
        See:
         	#### # 4 A_Chase;
         	Loop;
        Pain:
			#### # 2 A_Pain;
			#### # 0 A_SetRenderStyle(0.85, STYLE_TranslucentStencil);
			#### # 1 SetShade("ffffff");
			#### # 2 SetShade("ff0000");
			#### # 1 SetShade("ffffff");
			#### # 0 A_SetRenderStyle(1, RenderStyleCache);
            #### # 0 A_Jump(256, "See");
        Pain.Stun:
            #### # 1 { bNoPain = true; }
            #### # 0 A_SetRenderStyle(0.85, STYLE_TranslucentStencil);
			#### # 1 SetShade("ffffff");
			#### # 2 SetShade("ff0000");
			#### # 1 SetShade("ffffff");
			#### # 0 A_SetRenderStyle(1, RenderStyleCache);
            #### # 150 A_Pain;
            #### # 1 { bNoPain = false; }
            #### # 0 A_Jump(256, "See");
        Death:
            TNT1 A 1 A_SpawnItemEx("ZeldaDead", 0, 0, 10);
            Stop;
    }

    override void PostBeginPlay()
    {
        RenderStyleCache = GetRenderStyle();
    }

	override void Die(Actor source, Actor inflictor, int dmgflags)
	{
        let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
		controller.ReportDeath(SpawnedBy);

        let lootController = LootController(StaticEventHandler.Find("LootController"));

        // Damage flag 666 indicates a scripted
        // kill and shouldn't drop an item.
        if (DropGroup != "X" && dmgflags != 666)
        {
            string name; int chance; int amount;
            [name, chance, amount] = lootController.GetLoot(DropGroup, LastDamageType);
            // Console.PrintF("Loot: %s Amount: %i  Chance: %i", name, amount, chance);
            A_DropItem(name, amount, chance);
        }

        lootController.ReportKill();

        A_StartSound("zelda/e_die", CHAN_AUTO, CHANF_OVERLAP);
    	Super.Die(source, inflictor, dmgflags);
	}

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (inflictor.bIsMonster && damagetype != "ParentAbuse")
        {
            damage = 0;
        }
        // Using PainThreshold as a flag for the couple of enemies that should die from boomerang
        else if (damagetype == "Stun" && PainThreshold != 1)
        {
            damage = 0;
            SetStateLabel("Pain.Stun");
        }

        LastDamageType = damagetype;
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}

class ZeldaDead : Actor
{
    Default
    {
		+NOBLOCKMAP
		+NOGRAVITY
		+ZDOOMTRANS
        +NOBLOOD
        Scale 0.5;
    }

    States
    {
        Spawn:
            DEAD A 1;
        Mellee:
            DEAD ABCDEBCA 2;
            Stop;
    }
}
