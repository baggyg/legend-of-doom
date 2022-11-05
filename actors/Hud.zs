class ZeldaHud : BaseStatusBar
{
	// A map of equipable items and their hud image
	// Todo: Look into inventory.icon or maybe pulling out spawn sprite state img
	Dictionary weaponImages;

	// Hud display stuff
	HudData d;
	Color bgColor;
	HUDFont smallFont;

	static const string heartImages[] =
	{
		"HARTEMTY",
		"HART1QRT", "HART1QRT",
		"HARTHALF", "HARTHALF",
		"HART3QRT", "HART3QRT",
		"HARTFULL", "HARTFULL"
	};

	int baseX, baseY, autoBaseX, autoBaseY;
	int tAlign, iAlign;

    override void Init()
	{
		Super.Init();
		SetSize(0, 320, 200);

		Font fnt = "CONFONT";
		smallFont = HUDFont.Create(fnt);
		baseX = 80;
		baseY = 180;
        autoBaseX = 200;
        autoBaseY = 50;
		iAlign = DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM;
		tAlign = DI_TEXT_ALIGN_LEFT | DI_SCREEN_CENTER_BOTTOM;
		bgColor = Color(255, 0, 0, 0);
		weaponImages = Dictionary.Create();
		weaponImages.Insert("ZeldaSwordWood", "SWD1A0");
		weaponImages.Insert("ZeldaSwordSilver", "SWD2A0");
		weaponImages.Insert("ZeldaSwordMaster", "SWD3A0");
		weaponImages.Insert("Bow", "AROWA0");
		weaponImages.Insert("ZeldaSilverArrow", "AROWB0");
		weaponImages.Insert("Boomerang", "BOOMHUD1");
		weaponImages.Insert("BoomerangBlue", "BOOMHUD2");
		weaponImages.Insert("ZeldaBomb", "BOMBA0");
		weaponImages.Insert("ZeldaBombPickup", "BOMBA0");
		weaponImages.Insert("ZeldaInfiniteBomb", "BOMBB0");
		weaponImages.Insert("BombAmmo", "BOMBA0");
		weaponImages.Insert("CandleBlue", "CNDLB0");
		weaponImages.Insert("CandleRed", "CNDLA0");
		weaponImages.Insert("ZeldaRaft", "RAFTA0");
		weaponImages.Insert("ZeldaBook", "BOOKA0");
		weaponImages.Insert("ZeldaPowerBracelet", "PWRBA0");
		weaponImages.Insert("ZeldaLadder", "LADRA0");
		weaponImages.Insert("ZeldaLionKey", "KEEEA0");
		weaponImages.Insert("ZeldaMeat", "MEATA0");
		weaponImages.Insert("ZeldaWhistle", "WSTLA0");
		weaponImages.Insert("ZeldaWand", "WANDA0");
		weaponImages.Insert("ZeldaPotBlue", "POT1A0");
		weaponImages.Insert("ZeldaPotRed", "POT2A0");
		weaponImages.Insert("ZeldaLetter", "MAP2A0");
		weaponImages.Insert("ZeldaRingBlue", "RINGA0");
		weaponImages.Insert("ZeldaRingRed", "RINGB0");
	}

	override void Tick()
	{
		Super.Tick();

		// Mugshot
		d.PlayerImg = TexMan.GetName(GetMugShot(5));

		if(CPlayer.mo.CountInv("ZeldaRingRed") > 0)
		{
			d.PlayerImg.Replace("STF", "RRN");
		}
		else if(CPlayer.mo.CountInv("ZeldaRingBlue") > 0)
		{
			d.PlayerImg.Replace("STF", "BRN");
		}

		// HUD values
		let playerMaxHealth = (CPlayer ? CPlayer.mo.GetMaxHealth() : 0);
		d.PlayerHealth = (CPlayer ? CPlayer.mo.Health : 0);
		d.HeartCount =  (playerMaxHealth / 8);
		d.Bombs = CPlayer.mo.CountInv("BombAmmo");
        d.BombInfinite = CPlayer.mo.CountInv("ZeldaInfiniteBomb") > 0;
		d.Keys = CPlayer.mo.CountInv("ZeldaKey");
		d.Rupees = CPlayer.mo.CountInv("ZeldaRupee");
		setImage(d.Lion, "ZeldaLionKey");

		let potNum = CPlayer.mo.CountInv("PotAmmo");
		if (potNum == 2)
		{
			d.Potion = weaponImages.At("ZeldaPotRed");
		}
		else if (potNum == 1)
		{
			d.Potion = weaponImages.At("ZeldaPotBlue");
		}
		else
		{
			setImage(d.Potion, "ZeldaLetter");
		}

		// Weapon
		if (CPlayer.ReadyWeapon != null)
		{
			let weaponClass = CPlayer.ReadyWeapon.GetClassName();

			if (weaponClass == "ZeldaPotion")
			{
				d.WeaponImg = potNum == 1
                    ? weaponImages.At("ZeldaPotBlue")
                    : weaponImages.At("ZeldaPotRed");
			}
            else if (weaponClass == "Bow")
            {
				d.WeaponImg = CPlayer.mo.CountInv("ZeldaSilverArrow") > 0
                    ? weaponImages.At("ZeldaSilverArrow")
                    : weaponImages.At("Bow");
            }
			else
			{
				d.WeaponImg = weaponImages.At(weaponClass);
			}
		}
	}

	void setImage(out string img, string inventoryItem, int howMany = 0)
	{
        img = CPlayer.mo.CountInv(inventoryItem) > howMany ? weaponImages.At(inventoryItem) : "";
	}

	override void Draw (int state, double TicFrac)
	{
		Super.Draw(state, TicFrac);

		if (!CPlayer) return;

		if (!automapactive)
			DrawGameHud();
	}

    override bool DrawPaused(int player)
    {
		setImage(d.Meat, "ZeldaMeat");
		setImage(d.Raft, "ZeldaRaft");
		setImage(d.Book, "ZeldaBook");
		setImage(d.Wand, "ZeldaWand");
		setImage(d.Ladder, "ZeldaLadder");
		setImage(d.Whistle, "ZeldaWhistle");
		setImage(d.Brace, "ZeldaPowerBracelet");

		setImage(d.Bomb, "ZeldaInfiniteBomb");
        if (!d.Bomb) setImage(d.Bomb, "BombAmmo");

		setImage(d.Ring, "ZeldaRingRed");
		if (!d.Ring) setImage(d.Ring, "ZeldaRingBlue");

		setImage(d.Candle, "CandleBlue");
		if (!d.Candle) setImage(d.Candle, "CandleRed");

		setImage(d.Boomerang, "BoomerangBlue");
		if (!d.Boomerang)setImage(d.Boomerang, "Boomerang");

		setImage(d.Bow, "ZeldaSilverArrow");
		if (!d.Bow) setImage(d.Bow, "Bow");

        d.Triforce = "TRI"..CPlayer.mo.CountInv("ZeldaTriforce");

        DrawPauseScreen();

        return false;
    }

	void DrawGameHud()
	{
		// Background box
		Fill(bgColor, baseX-20, baseY-23,baseX+135, baseY+50);

		// Player frame
		DrawImage(d.PlayerImg, (baseX, baseY), iAlign, 1, (-1, -1), (1.25, 1.25));

		// Rupees
        DrawImage("RUPEEBAG", (baseX+25, baseY-13), iAlign, 1, (-1, -1), (0.15, 0.15));
		DrawImage("X", (baseX+33, baseY-13), iAlign, 1, (-1, -1), (0.15, 0.15));
		DrawString(smallFont, ""..d.Rupees, (baseX+35, baseY-18), tAlign);

		// Keys
		DrawImage("KEYMENU", (baseX+25, baseY), iAlign, 1, (-1, -1), (0.15, 0.15));
        DrawImage("X", (baseX+33, baseY), iAlign, 1, (-1, -1), (0.15, 0.15));
		if (d.Lion)
			DrawString(smallFont, "A", (baseX+35, baseY-5), tAlign);
		else
			DrawString(smallFont, ""..d.Keys, (baseX+35, baseY-5), tAlign);

		// Bombs
        DrawImage("BOMMMENU", (baseX+25, baseY+10), iAlign, 1, (-1, -1), (0.15, 0.15));
        DrawImage("X", (baseX+33, baseY+10), iAlign, 1, (-1, -1), (0.15, 0.15));
        if (d.BombInfinite)
		    DrawString(smallFont, "A", (baseX+35, baseY+5), tAlign);
        else
		    DrawString(smallFont, ""..d.Bombs, (baseX+35, baseY+5), tAlign);

		// Sword box
        DrawImage("WEPFRAME", (baseX+75, baseY), iAlign, 1, (-1, -1), (0.25, 0.25));
        DrawImage(d.WeaponImg, (baseX+75, baseY), iAlign, 1, (-1, -1), (0.35, 0.35));

		// Hearts
		let yHeartOffset = 6;
		let xHeartOffset = 100;
		let playerHealth = d.PlayerHealth;
		let heartCount = d.HeartCount;

		for (let i = 0; i < heartCount; i++)
		{
			DrawImage(HeartImages[Clamp(playerHealth, 0, 8)], (baseX+xHeartOffset, baseY+yHeartOffset), iAlign, 1, (-1, -1), (1.5, 1.5));
			playerHealth -= 8;
			if (i == 7)
			{
				xHeartOffset = 100;
				yHeartOffset -= 12;
			}
			else
			{
				xHeartOffset += 12;
			}
		}

		// if (state == HUD_StatusBar)
		// {
		// 	BeginStatusBar();
		// }
		// else if (state == HUD_Fullscreen)
		// {
        //     Console.PrintF("HUD_Fullscreen");
		// 	// BeginHUD();
		// 	// DrawFullScreenStuff(TicFrac);
		// }
	}

    void DrawPauseScreen()
    {
		Fill(bgColor, autoBaseX-280, autoBaseY, baseX+410, baseY-330);
        DrawImage("ITMFRAME", (autoBaseX+80, autoBaseY-60), iAlign, 1, (-1, -1), (2.25, 2.25));

		// On top row
		DrawImage(d.Raft, (autoBaseX-5, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Book, (autoBaseX+30, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Ring, (autoBaseX+60, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Ladder, (autoBaseX+100, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Lion, (autoBaseX+135, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Brace, (autoBaseX+165, autoBaseY-125), iAlign, 1, (-1, -1), (0.5, 0.5));

		// Top row
		DrawImage(d.Boomerang, (autoBaseX, autoBaseY-80), iAlign, 1, (-1, -1), (0.4, 0.4));
		DrawImage(d.Bomb, (autoBaseX+50, autoBaseY-80), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Bow, (autoBaseX+100, autoBaseY-80), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Candle, (autoBaseX+160, autoBaseY-80), iAlign, 1, (-1, -1), (0.5, 0.5));

		// Bottom row
		DrawImage(d.Whistle, (autoBaseX, autoBaseY-40), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Meat, (autoBaseX+50, autoBaseY-40), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Potion, (autoBaseX+100, autoBaseY-40), iAlign, 1, (-1, -1), (0.5, 0.5));
		DrawImage(d.Wand, (autoBaseX+160, autoBaseY-40), iAlign, 1, (-1, -1), (0.5, 0.5));

        // Triforce
        DrawImage(d.Triforce, (autoBaseX-160, autoBaseY-80), iAlign, 1, (-1, -1), (2, 2));
    }
}

struct HudData
{
	string WeaponImg;
	string PlayerImg;
	int HeartCount;
	int PlayerHealth;
	int Rupees;
	int Keys;
	int Bombs;
    string Triforce;
	string Raft;
	string Ladder;
	string Book;
	string Ring;
	string Candle;
	string Lion;
	string Brace;
	string Boomerang;
	string BoomerangBlue;
	string Bomb;
    bool BombInfinite;
	string Bow;
	string Whistle;
	string Meat;
	string Potion;
	string PotionRed;
	string PotionBlue;
	string PotionLetter;
	string Wand;
	string Letter;
}
