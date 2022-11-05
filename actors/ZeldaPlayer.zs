class ZeldaPlayer : DoomPlayer
{
    // Stores location where the player last used
    // the candle. Blue candles can't be used repeatedly
    // in a given area.
    bool CanFireCandle;
    Vector3 LastFirePos;

    property DamageCooldown: DamageCooldown;
    int DamageCooldown;

	Default
	{
		Player.DisplayName "Link";
		DeathSound "zelda/linkdie";

		Health 24;
		Player.MaxHealth 24;
		Player.MugShotMaxHealth 24 ;
		Player.StartItem "BubbleGun";
        ZeldaPlayer.DamageCooldown 35;

		Player.WeaponSlot 1, "Fist", "ZeldaSwordWood", "ZeldaSwordSilver", "ZeldaSwordMaster";
		Player.WeaponSlot 2, "Bow";
		Player.WeaponSlot 3, "ZeldaBomb", "ZeldaInfiniteBomb";
		Player.WeaponSlot 4, "CandleBlue", "CandleRed";
		Player.WeaponSlot 5, "ZeldaWand";
		Player.WeaponSlot 6, "ZeldaWhistle";
		Player.WeaponSlot 7, "ZeldaMeat";
		Player.WeaponSlot 8, "ZeldaPotion";
		Player.WeaponSlot 0, "BubbleGun";

        // Player.ForwardMove 1, 2;
        // Player.SideMove 1, 2;

        +NOBLOOD
	}

    // Called on game first start
	override void PostBeginPlay()
	{
       	Super.PostBeginPlay();

        CanFireCandle = true;

        //GiveAll();

        if (CountInv("ZeldaPotion") < 1)
		{
            GiveInventory("ZeldaPotion", 1);
        }
	}

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
	{
		if (!inflictor || DamageCooldown > 0 || level.IsFrozen())
        {
            return Super.TakeSpecialDamage(inflictor, source, 0, damagetype);
        }

        // Reduce damage if wearing a ring.
		if (CountInv("ZeldaRingRed") > 0)
		{
			damage *= 0.25;
		}
		else if (CountInv("ZeldaRingBlue") > 0)
		{
			damage *= 0.5;
		}

        // Reset damage cooldown
        if (damage > 0)
        {
            DamageCooldown = Default.DamageCooldown;
        }

        let lootController = LootController(StaticEventHandler.Find("LootController"));
        lootController.ReportPlayerHit();

		return Super.TakeSpecialDamage(self, self, damage, damagetype);
	}

	override void Die(Actor source, Actor inflictor, int dmgflags)
	{
        A_ClearOverlays(5, 5);
		S_ChangeMusic("");
		Super.Die(source, inflictor, dmgflags);
	}

    override void Tick()
    {
        // Throttle damage
        if (DamageCooldown > 0)
        {
            DamageCooldown--;
        }

        // Track blue candle flame distance
        if (CanFireCandle == false && (pos - LastFirePos).Length() > 1000)
        {
            CanFireCandle = true;
        }

        Super.Tick();
    }

    void CandleFired()
    {
        LastFirePos = pos;
        CanFireCandle = false;
    }

	void GiveAll()
	{
		GiveInventory("ZeldaRupee", 2);
		GiveInventory("ZeldaLetter", 1);
		GiveInventory("ZeldaInfiniteBomb", 1);
		GiveInventory("ZeldaRaft", 1);
		GiveInventory("ZeldaLadder", 1);
		GiveInventory("ZeldaShield", 1);
		GiveInventory("ZeldaPowerBracelet", 1);

        Spawn("ZeldaMeat", pos);
        Spawn("BoomerangBlue", pos);
        // Spawn("Bow", pos);
		// Spawn("ZeldaSilverArrow", pos);
        Spawn("CandleRed", pos);
        Spawn("ZeldaWhistle", pos);
        Spawn("ZeldaWand", pos);

		Spawn("PotAmmo", pos);
		Spawn("PotAmmo", pos);
		Spawn("ZeldaBook", pos);
		Spawn("ZeldaLionKey", pos);
		Spawn("ZeldaRingRed", pos);
		Spawn("ZeldaSwordMaster", pos);

        Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
		Spawn("ZeldaHeartContainerPickup", pos);
	}
}
