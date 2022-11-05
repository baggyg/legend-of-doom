class ZeldaMeat : ZeldaWeapon
{
    Actor meatSpawned;

    Default
    {
        Scale 0.5;
		Weapon.AmmoUse 0;
        Weapon.SlotNumber 9;
        Inventory.MaxAmount 1;
        Inventory.PickupMessage "You picked up meat!";
    }

    States
    {
        Spawn:
            MEAT A -1;
            Stop;
        Ready:
            MEAT B 1 A_RaiseShield;
            Loop;
        ReadyNoShow:
            TNT1 A 1 A_WeaponReady(WRF_NOPRIMARY | WRF_NOBOB);
            TNT1 A 1 A_JumpIf(!invoker.meatSpawned, "Ready");
            Loop;
        Fire:
            TNT1 A 1
            {
                if (invoker.meatSpawned) return;
                invoker.meatSpawned = Spawn("ZeldaMeatSpawn", pos);
            }
            Goto ReadyNoShow;
        Select:
            MEAT B 1 A_Raise;
            Loop;
        Deselect:
            MEAT B 1 A_Lower;
            Loop;
    }
}

class ZeldaMeat60 : StoreItem
{
    Default
    {
        //$Title Meat 60
        StoreItem.Cost 60;
        StoreItem.GiveAmount 1;
        StoreItem.GiveItem "ZeldaMeat";
    }

    States
    {
        Spawn:
            MEAT A -1 BRIGHT;
            Stop;
    }
}

class ZeldaMeat100 : ZeldaMeat60
{
    Default
    {
        //$Title Meat 100
        StoreItem.Cost 100;
    }
}

class ZeldaMeatSpawn : HateTarget
{
    Default
    {
        Scale 0.5;
    }

    States
    {
        Spawn:
            MEAT A -1;
            Stop;
    }

    int ticker;

    override void PostBeginPlay()
    {
        ticker = 175;   // 5s
        Actor mo;
        let monsterFinder = ThinkerIterator.Create("Actor");
        while (mo = Actor(monsterFinder.Next()))
        {
            if (mo.bIsMonster)
            {
                mo.target = self;
            }
        }

        ZeldaMoblinNpc moblinDude;
        let moblinFinder = ThinkerIterator.Create("ZeldaMoblinNpc");
        while (moblinDude = ZeldaMoblinNpc(moblinFinder.Next()))
        {
            if (CheckIfCloser(moblinDude, 256))
            {
                let swordName = "ZeldaSwordSilver";
                if (players[consoleplayer].mo.CountInv("ZeldaSwordWood") > 0) swordName = "ZeldaSwordWood";
                if (players[consoleplayer].mo.CountInv("ZeldaSwordMaster") > 0) swordName = "ZeldaSwordMaster";
                players[consoleplayer].mo.ACS_NamedExecuteAlways("GrumbleGrumble", 0, 29);
                players[consoleplayer].mo.A_SelectWeapon(swordName, SWF_SELECTPRIORITY);
            }
        }
    }

    override void Tick()
    {
        Super.Tick();
        ticker--;
        if (ticker > 0) return;
        Destroy();
    }
}
