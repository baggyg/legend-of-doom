class Bow : Weapon
{
    Default
    {
        //$Title Bow
        Scale 0.5;
        Weapon.AmmoUse 1;
        Weapon.AmmoType "ZeldaRupee";
        Weapon.SlotNumber 2;
        Inventory.PickUpMessage "You got a bow!";
        +WEAPON.NOALERT
        +WEAPON.NOAUTOSWITCHTO
        +WEAPON.TWOHANDED
    }

    States
    {
        Spawn:
            BOOW A -1;
            Stop;

        Select:
            TNT1 A 0 A_JumpIfInventory("ZeldaSilverArrow",1,"Select_Ice");
            DBOW A 1 A_Raise;
            Loop;
        Deselect:
            TNT1 A 0 A_JumpIfInventory("ZeldaSilverArrow",1,"Deselect_Ice");
            DBOW A 1 A_Lower;
            Loop;
        Ready:
            TNT1 A 0 A_JumpIfInventory("ZeldaSilverArrow",1,"Ready_Ice");
            DBOW A 1 A_WeaponReady;
            Loop;
        Fire:
            TNT1 A 0 A_JumpIfInventory("ZeldaSilverArrow",1,"Fire_Ice");
            DBOW B 3;
            DBOW C 3;
            Goto Hold;
        Hold:
            TNT1 A 0 A_JumpIfInventory("ZeldaSilverArrow",1,"Hold_Ice");
            DBOW D 5;
            TNT1 A 0 A_Refire;
            TNT1 A 0 A_FireProjectile("ArrowProj",0,1,5,0);
            DBOW E 3 A_StartSound("zelda/arrow", CHAN_WEAPON);
            DBOW FBA 3;
            Goto Ready;

        Select_Ice:
            PBOW A 1 A_Raise;
            Loop;
        Deselect_Ice:
            PBOW A 1 A_Lower;
            Loop;
        Ready_Ice:
            PBOW AAAEEE 1 A_WeaponReady;
            Goto Ready;
        Fire_Ice:
            PBOW B 3;
            PBOW C 3;
            // PBOW C 3 A_StartSound("BOWREADY", CHAN_WEAPON);
            Goto Hold;
        Hold_Ice:
            PBOW DF 3;
            TNT1 A 0 A_Refire;
            TNT1 A 0 A_FireProjectile("IceArrow",0,1,5,0);
            DBOW E 3 A_StartSound("zelda/arrow", CHAN_WEAPON);
            DBOW F 3;
            PBOW BA 3;
            Goto Ready;
    }
}

/////////////////////////////////////
/////////////PROJECTILES/////////////
/////////////////////////////////////

class ArrowProj : Actor
{
    Default
    {
        Radius 8;
        Height 2;
		DamageFunction(2);
        DamageType "Arrow";
        Speed 36;
        Projectile;
        +THRUGHOST
        +DONTREFLECT
        +NOTIMEFREEZE
        +BLOODLESSIMPACT
        Scale 0.8;
    }
    States
    {
        Spawn:
            MARW A 1;
            Loop;
        Death:
            TNT1 A 1;
            Stop;
    }
}

class IceArrow : ArrowProj
{
    Default
    {
		DamageFunction(4);
        DamageType "SilverArrow";
    }

    States
    {
        Spawn:
            MARW A 2 bright A_SpawnItem("IceArrowTrail",0,0,0);
            Loop;
        Death:
            TNT1 A 0 A_AlertMonsters;
            SHEX ABCDE 3 bright;
            Stop;
    }
}

class IceArrowTrail : Actor
{
    Default
    {
        Renderstyle "Add";
        +NOGRAVITY
    }
    States
    {
        Spawn:
            ICPR IJKLM 3;
            Stop;
    }
}

//  Possession of this item triggers ice arrow states for Bow
class ZeldaSilverArrow : Inventory
{
    Default
    {
        //$Title Silver Arrows
        Scale 0.5;
        Inventory.Amount 1;
        Inventory.MaxAmount 1;
        Inventory.PickupSound "zelda/fanfare";
        Inventory.PickupMessage "You got the silver arrows!";
    }

    States
    {
        Spawn:
            AROW B -1;
            Stop;
    }
}
