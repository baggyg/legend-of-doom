class ZeldaWeapon : Weapon abstract
{
    Actor spawned;

    Default
    {
        +WEAPON.NODEATHINPUT
    }

    States
    {
        Ready:
            #### # 1 A_RaiseShield;
            Loop;

        ShieldReady:
            SLDW A 0 A_OverlayFlags(OverlayID(), PSPF_ADDWEAPON | PSPF_ADDBOB, 1);
            SLDW A 1 A_OverlayOffset(OverlayID(), 32, 170);
            SLDW A 1;
            Wait;

        BigShieldReady:
            SLDH A 0 A_OverlayFlags(OverlayID(), PSPF_ADDWEAPON | PSPF_ADDBOB, 1);
            SLDH A 1 A_OverlayOffset(OverlayID(), 32, 170);
            SLDH A 1;
            Wait;

        AltFire:
            #### # 0
            {
                // Do not fire if a boomerang is still flying
                if (invoker.spawned) return;

                let player = players[consoleplayer].mo;

                if (!player) return;

                if (player.CountInv("BoomerangBlue") >= 1)
                {
                    invoker.spawned = SpawnPlayerMissile("BoomerangProjBlue");
                }
                else if (player.CountInv("Boomerang") >= 1)
                {
                    invoker.spawned = SpawnPlayerMissile("BoomerangProj");
                }
            }
            Goto Ready;

        Deselect:
            #### # 1 A_Lower;
            Loop;
    }

    action void A_RaiseShield()
    {
        A_WeaponReady();

        A_SpawnItemEx("SHEELD", 30, 0, 15, flags: SXF_SETTARGET);

        // Draw shield overlay when weapon is not firing.
        let player = players[consoleplayer].mo;
        if (!player) return;

        let wep = players[consoleplayer].ReadyWeapon;
        if (!wep) return;

        let psp = players[consoleplayer].GetPSprite(PSP_WEAPON);

        let isReady =
            players[consoleplayer].AttackDown == false ||
            wep.InStateSequence(psp.CurState, wep.FindState("AltFire"));

        if (isReady && wep.GetClassName() != "Bow")
        {
            if (CountInv("ZeldaShield") > 0)
            {
                A_Overlay(5, "BigShieldReady");
            }
            else
            {
                A_Overlay(5, "ShieldReady");
            }
        }
    }
}
