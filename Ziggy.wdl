include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var BossX;
var Speed;
var ZiggyMove;
var Type;
var LevelSpeed = 3;
var Delay = 0;
var ZiggyHit = 0;
var HitCounter = 0;
var Health = 12;
var CONST_HIT_DURATION = 1;
var Level = 1;
var EnemyToCome = 0;
var CantBeHit = 0;
var CurWeather = 0;
var TextDelay = 0;
var HitSND = 0;
var cZIGGY_DELAY = 60;
var MUS;
var Scene = 0;
var Intro = 0;
var Timer = 0;
var Counter = 0;
var Restart = 0;
var Orig[3];
var KillEmAll = 0;

var GameOverDelay = 50;

var ToKill = 8;

bmap Level1 = <ZigLev1.bmp>;
bmap Level2 = <ZigLev2.bmp>;
bmap Level3 = <ZigLev3.bmp>;
bmap Level4 = <ZigLev4.bmp>;
bmap Level5 = <ZigLev5.bmp>;

bmap YouWin = <YouWin.bmp>;
bmap YouLose = <YouLose.bmp>;

sound Birds = <SFX113.WAV>;
sound Fight = <SFX115.WAV>;

bmap N1 = <N1.pcx>;
bmap N2 = <N2.pcx>;

panel pWinLose
{
	bmap = YouWin;
	layer = 10;
	pos_x = 150;
	pos_y = 150;
	flags = refresh,d3d,overlay;
}


bmap ZigIcon1 = <ZigIcon1.pcx>;
bmap ZigIcon2 = <ZigIcon2.pcx>;

define Phase,skill1;

synonym MyZiggy { type entity; }

panel pH01 { bmap = ZigIcon1; layer = 0; pos_x = 75; pos_y = 420; flags = overlay,refresh; }
panel pH02 { bmap = ZigIcon1; layer = 0; pos_x = 115; pos_y = 420; flags = overlay,refresh; }
panel pH03 { bmap = ZigIcon1; layer = 0; pos_x = 155; pos_y = 420; flags = overlay,refresh; }
panel pH04 { bmap = ZigIcon1; layer = 0; pos_x = 195; pos_y = 420; flags = overlay,refresh; }
panel pH05 { bmap = ZigIcon1; layer = 0; pos_x = 235; pos_y = 420; flags = overlay,refresh; }
panel pH06 { bmap = ZigIcon1; layer = 0; pos_x = 275; pos_y = 420; flags = overlay,refresh; }
panel pH07 { bmap = ZigIcon1; layer = 0; pos_x = 315; pos_y = 420; flags = overlay,refresh; }
panel pH08 { bmap = ZigIcon1; layer = 0; pos_x = 355; pos_y = 420; flags = overlay,refresh; }
panel pH09 { bmap = ZigIcon1; layer = 0; pos_x = 395; pos_y = 420; flags = overlay,refresh; }
panel pH10 { bmap = ZigIcon1; layer = 0; pos_x = 435; pos_y = 420; flags = overlay,refresh; }
panel pH11 { bmap = ZigIcon1; layer = 0; pos_x = 475; pos_y = 420; flags = overlay,refresh; }
panel pH12 { bmap = ZigIcon1; layer = 0; pos_x = 515; pos_y = 420; flags = overlay,refresh; }

panel pE01 { bmap = ZigIcon2; layer = 0; pos_x = 75; pos_y = 20; flags = overlay,refresh; }
panel pE02 { bmap = ZigIcon2; layer = 0; pos_x = 115; pos_y = 20; flags = overlay,refresh; }
panel pE03 { bmap = ZigIcon2; layer = 0; pos_x = 155; pos_y = 20; flags = overlay,refresh; }
panel pE04 { bmap = ZigIcon2; layer = 0; pos_x = 195; pos_y = 20; flags = overlay,refresh; }
panel pE05 { bmap = ZigIcon2; layer = 0; pos_x = 235; pos_y = 20; flags = overlay,refresh; }
panel pE06 { bmap = ZigIcon2; layer = 0; pos_x = 275; pos_y = 20; flags = overlay,refresh; }
panel pE07 { bmap = ZigIcon2; layer = 0; pos_x = 315; pos_y = 20; flags = overlay,refresh; }
panel pE08 { bmap = ZigIcon2; layer = 0; pos_x = 355; pos_y = 20; flags = overlay,refresh; }
panel pE09 { bmap = ZigIcon2; layer = 0; pos_x = 395; pos_y = 20; flags = overlay,refresh; }
panel pE10 { bmap = ZigIcon2; layer = 0; pos_x = 435; pos_y = 20; flags = overlay,refresh; }

text txtEXIT
{
	string = "SHUME VA XJJOLF ENFKMB IFPBL JDK esc [HL";
	layer = 20;
	font = standard_font;
	pos_x = 10;
	pos_y = 470;
	flags = visible;
}

function UpdatePanel
{
	if (Health <= 0) 
	{ 
		pWinLose.bmap = YouLose;
		pWinLose.visible = on;

		txtEXIT.string = "VARL JDK esc FA BFU SHUL JDK enter LP [HL";
	}
	else { txtEXIT.string = "SHUME VA XJJOLF ENFKMB IFPBL JDK esc [HL"; }

	if (Health >= 1) { pH01.visible = on; } else { pH01.visible = off; }
	if (Health >= 2) { pH02.visible = on; } else { pH02.visible = off; }
	if (Health >= 3) { pH03.visible = on; } else { pH03.visible = off; }
	if (Health >= 4) { pH04.visible = on; } else { pH04.visible = off; }
	if (Health >= 5) { pH05.visible = on; } else { pH05.visible = off; }
	if (Health >= 6) { pH06.visible = on; } else { pH06.visible = off; }
	if (Health >= 7) { pH07.visible = on; } else { pH07.visible = off; }
	if (Health >= 8) { pH08.visible = on; } else { pH08.visible = off; }
	if (Health >= 9) { pH09.visible = on; } else { pH09.visible = off; }
	if (Health >=10) { pH10.visible = on; } else { pH10.visible = off; }
	if (Health >=11) { pH11.visible = on; } else { pH11.visible = off; }
	if (Health >=12) { pH12.visible = on; } else { pH12.visible = off; }

	if (Level != 5)
	{
		if (ToKill >= 1) { pE01.visible = on; } else { pE01.visible = off; }
		if (ToKill >= 2) { pE02.visible = on; } else { pE02.visible = off; }
		if (ToKill >= 3) { pE03.visible = on; } else { pE03.visible = off; }
		if (ToKill >= 4) { pE04.visible = on; } else { pE04.visible = off; }
		if (ToKill >= 5) { pE05.visible = on; } else { pE05.visible = off; }
		if (ToKill >= 6) { pE06.visible = on; } else { pE06.visible = off; }
		if (ToKill >= 7) { pE07.visible = on; } else { pE07.visible = off; }
		if (ToKill >= 8) { pE08.visible = on; } else { pE08.visible = off; }
		if (ToKill >= 9) { pE09.visible = on; } else { pE09.visible = off; }
		if (ToKill >=10) { pE10.visible = on; } else { pE10.visible = off; }
		if (ToKill <= 0)
		{
			if (pWinLose.visible == off) { sPlay ("SFX138.WAV"); }
			pWinLose.bmap = YouWin;
			pWinLose.visible = on;

			if (GetPosition(Voice) >= 1000000) 
			{ 
				pWinLose.visible = off;
				SetWeather();
				Level = Level + 1;
				SetLevel();

				Scene = 0;
				Timer = 0;
				stop_sound (MUS);

				if (Level == 2) { Intro = 1; }
				if (Level == 3) { Intro = 3.5; }
				if (Level == 4) { Intro = 3; }
				if (Level == 5) { Intro = 2; }
				if (Level == 6) { Intro = 4; }
				Restart = 1;

				while (Intro > 0) { wait(1); }
				SetWeather();
			}
		}
	}
}

function Again
{
	if ((pWinLose.visible == on) && (Health <= 0)) { main(); }
}

on_enter = Again();

panel GUI 
{
	bmap = N1;
	pos_x = 0;
	pos_y = 0;
	layer = 1;
	flags = refresh,d3d,visible,overlay;
}

panel Shadow
{
	bmap = N2;
	pos_x = 200;
	pos_y = 55;
	layer = 6;
	flags = refresh,d3d,visible,transparent;
}

text Credits
{
	string = "player 2 insert coin(s)";
	font = standard_font;
	pos_x = 420;
	pos_y = 10;
}

panel ShowLevel
{
	bmap = Level1;
	layer = 5;
	pos_x = 190;
	pos_y = 100;
	flags = refresh,d3d,overlay;
}

sound NIN01 = <NIN001.WAV>;
sound NIN02 = <NIN002.WAV>;
sound NIN03 = <NIN003.WAV>;
sound NIN04 = <NIN004.WAV>;
sound NIN05 = <NIN005.WAV>;
sound NIN06 = <NIN006.WAV>;
sound NIN07 = <NIN007.WAV>;
sound NIN08 = <NIN016.WAV>;
sound NIN09 = <NIN017.WAV>;
sound NIN10 = <NIN018.WAV>;
sound NIN11 = <NIN019.WAV>;
sound NIN12 = <NIN020.WAV>;
sound NIN13 = <NIN021.WAV>;
sound NIN14 = <NIN022.WAV>;
sound NIN15 = <NIN023.WAV>;
sound NIN16 = <NIN024.WAV>;
sound NIN17 = <NIN025.WAV>;
sound NIN18 = <NIN026.WAV>;
sound NIN19 = <NIN027.WAV>;
sound NIN20 = <NIN028.WAV>;

sound L15 = <SNG026.WAV>;
sound L24 = <SNG028.WAV>;
sound L3 = <SNG027.WAV>;

sound Hit1 = <SFX015.WAV>;
sound Hit2 = <SFX016.WAV>;
sound Hit3 = <SFX017.WAV>;
sound Hit4 = <SFX018.WAV>;
sound Hit5 = <SFX021.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	stop_sound (MUS);

	warn_level = 0;
	tex_share = on;

	load_level(<Ziggy.WMB>);

	VoiceInit();
	Initialize();

	Level = 1;
	SetLevel();

	pWinLose.visible = off;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

function SetLevel
{
	Health = 12;
	if (Level == 1) { ToKill = 4; LevelSpeed = 1.5; }
	if (Level == 2) { ToKill = 6; LevelSpeed = 2; }
	if (Level == 3) { ToKill = 8; LevelSpeed = 2.5; }
	if (Level == 4) { ToKill = 10; LevelSpeed = 3; }
	if (Level == 5) { ToKill = 0; }
}

action Boss
{
	if (Level == 1)
	{
		my.skill2 = 0;

		while (Level == 1 )
		{
			if (my.skill2 < 500)
			{
				Blink();
				ent_cycle ("Walk",my.skill1);
				my.skill1 = my.skill1 + 5;
				my.x = my.x + 3 * time;
				BossX = my.x;
				my.skill2 = my.skill2 + 1;
			}
			else
			{
				BossX = -1;
			}
			wait(1);
		}
	}
	else
	{
		my.invisible = on;
		my.shadow = off;
	}
}

action Chick
{
	if (Level == 1)
	{
		sPlay ("SUR001.WAV");

		while(Level == 1)
		{
			if ((BossX > my.x) && (BossX != -1))
			{
				Talk();
				if (my.skill10 == 0) { sPlay ("SUR002.WAV"); my.skill10 = 1; }
				my.x = my.x + 3 * time;
				my.tilt = 90;
				ent_cycle("Scream",my.skill1);
			}
			else
			{
				Talk();
				ent_cycle ("Stand",my.skill1);
			}
				my.skill1 = my.skill1 + 10;
	
			wait(1);
		}
	}
	else
	{
		my.invisible = on;
		my.shadow = off;
	}

}

action Ziggy
{
	player = my;

	orig.x = my.x;
	orig.y = my.y;
	orig.z = my.z;

	SetWeather();

	if (Level != 1)
	{
		sPlay ("ZIG001.WAV");
		SetPosition(Voice,1000000);
	}

	my.skill1 = 1;
	my.skill2 = my.z;
	my.skill3 = 0;
	my.z = my.z + 100;
	Speed = 0.3;
	MyZiggy = my;

	if ((int(random(20)) == 10) && (Level != 1))
	{
		my.roll = 180;
		my.pan = 180;
	}

	while(1)
	{
		if (Restart == 1)
		{
			ZiggyHit = 0;

			if (Level != 1)
			{
				sPlay ("ZIG001.WAV");
				SetPosition(Voice,1000000);
			}

			my.x = orig.x;
			my.y = orig.y;
			my.z = orig.z;
			KillEmAll = 1;

			my.skill1 = 1;
			my.skill2 = my.z;
			my.skill3 = 0;
			my.z = my.z + 100;
			Speed = 0.3;
			MyZiggy = my;

			if ((int(random(20)) == 10) && (Level != 1))
			{
				my.roll = 180;
				my.pan = 180;
			}

			Restart = 0;
		}

		while (Intro > 0) { ZiggyHit = 0; wait(1); }

		UpdatePanel();

		if (Health <= 0) { my.x = my.x - 10 * time; my.z = my.z + 10 * time; }

		if ((ZiggyHit == 1) && (KillEmAll == 0) && (Intro == 0))
		{
			if (GetPosition(Voice) < 1000000) { Talk(); }
			if ((GetPosition(Voice) >= 1000000) && (Health > 0))
			{
				my.skill10 = int(random(14)) + 1;
				if (my.skill10 == 1) { sPlay("ZIG011.WAV"); }
				if (my.skill10 == 2) { sPlay("ZIG012.WAV"); }
				if (my.skill10 == 3) { sPlay("ZIG015.WAV"); }
				if (my.skill10 == 4) { sPlay("ZIG016.WAV"); }
				if (my.skill10 == 5) { sPlay("ZIG017.WAV"); }
				if (my.skill10 == 6) { sPlay("ZIG018.WAV"); }
				if (my.skill10 == 7) { sPlay("ZIG019.WAV"); }
				if (my.skill10 == 8) { sPlay("ZIG020.WAV"); }
				if (my.skill10 == 9) { sPlay("ZIG021.WAV"); }
				if (my.skill10 ==10) { sPlay("ZIG022.WAV"); }
				if (my.skill10 ==11) { sPlay("ZIG023.WAV"); }
				if (my.skill10 ==12) { sPlay("ZIG024.WAV"); }
				if (my.skill10 ==13) { sPlay("ZIG025.WAV"); }
				if (my.skill10 ==14) { sPlay("ZIG026.WAV"); }
			}
		}

		if (Level == 1)
		{
			if (BossX == -1)
			{
				if (my.skill1 >= 2)
				{
					if (GetPosition(Voice) < 1000000) { Talk(); } else { Blink(); }
				}

				if (Level == 1) { ShowLevel.bmap = Level1; }
				if (Level == 2) { ShowLevel.bmap = Level2; }
				if (Level == 3) { ShowLevel.bmap = Level3; }
				if (Level == 4) { ShowLevel.bmap = Level4; }
				if (Level == 5) { ShowLevel.bmap = Level5; }
				ShowLevel.visible = on;

				if (my.skill1 == 1)
				{
					ent_frame("Jump",0);
					my.z = my.z - Speed * time;
					my.x = my.x + 4 * time;
					Speed = Speed + 0.2 * time;
					if (my.z <= my.skill2) { my.skill1 = 2; }
				}
	
				if (my.skill1 == 2)
				{
					my.z = my.skill2;
					if ((my.skill10 == 0) && (Health > 0))
					{ 
						my.skill10 = int(random(5)) + 1;
						if (my.skill10 == 1) { sPlay ("ZIG001.WAV"); }
						if (my.skill10 == 2) { sPlay ("ZIG002.WAV"); }
						if (my.skill10 == 3) { sPlay ("ZIG003.WAV"); }
						if (my.skill10 == 4) { sPlay ("ZIG004.WAV"); }
						if (my.skill10 == 5) { sPlay ("ZIG005.WAV"); }
					}
	
					ent_frame ("Land",my.skill3);
					my.skill3 = my.skill3 + 15 * time;
					if (my.skill3 > 150) { my.skill1 = 3; my.skill3 = 0; }
				}
	
				if (my.skill1 == 3)
				{
					ent_frame ("Start",my.skill3);
					my.skill3 = my.skill3 + 30 * time;
					if (my.skill3 > 100) { my.skill1 = 4; my.skill3 = 0; ZiggyMove = 0; }
				}
	
				if (my.skill1 == 4)
				{
					my.roll = 0; my.pan = 20; SetMusic(); StartGame();
				}
			}

		}
		else 
		{ 
			if (my.skill1 == 1)
			{
				if (Level == 1) { ShowLevel.bmap = Level1; }
				if (Level == 2) { ShowLevel.bmap = Level2; }
				if (Level == 3) { ShowLevel.bmap = Level3; }
				if (Level == 4) { ShowLevel.bmap = Level4; }
				if (Level == 5) { ShowLevel.bmap = Level5; }
				ShowLevel.visible = on;

				ent_frame("Jump",0);
				my.z = my.z - Speed * time;
				my.x = my.x + 4 * time;
				Speed = Speed + 0.2 * time;
				if (my.z <= my.skill2) { my.skill1 = 2; }
			}
			if (my.skill1 == 2) { KillEmAll = 0; my.roll = 0; my.pan = 20; SetMusic(); StartGame(); }
		}

		wait(1);
	}
}

function HitSound
{
	Var HitS;

	if (snd_playing (HitSND) == 0)
	{
		HitS = int(random(5)) + 1;	
	
		if (HitS == 1) { play_entsound (my,Hit1,1000); }
		if (HitS == 2) { play_entsound (my,Hit2,1000); }
		if (HitS == 3) { play_entsound (my,Hit3,1000); }
		if (HitS == 4) { play_entsound (my,Hit4,1000); }
		if (HitS == 5) { play_entsound (my,Hit5,1000); }

		HitSND = result;
	}
}

function SetMusic
{
	if ((snd_playing (MUS) == 1) || (Intro > 0)) { return; }

	stop_sound (MUS);
	if (Level == 1) { play_loop (L15,100); }
	if (Level == 2) { play_loop (L24,100); }
	if (Level == 3) { play_loop (L3,100); }
	if (Level == 4) { play_loop (L24,100); }
	MUS = result;
}

function StartGame()
{
	ShowLevel.visible = off;

	TextDelay = TextDelay + 1 * time;
	if (TextDelay > 10) 
	{ 
		if (Credits.visible == on) { Credits.visible = off; } else { Credits.visible = on; }
		if (txtEXIT.visible == on) { txtEXIT.visible = off; } else { txtEXIT.visible = on; }

		TextDelay = 0; 
	}

	if (Level == 5)
	{
		if (BossX == 4)
		{
			sPlay ("ZIG006.WAV");
			BossX = 5;
		}

		if (BossX == 5)
		{
			Talk();
			if (GetPosition(Voice) >= 1000000) { BossX = 6; }
		}

		if ((BossX == 6) || (BossX == 7)) { Blink(); }

		if (BossX == 8)
		{
			sPlay ("ZIG007.WAV");
			BossX = 9;
		}

		if (BossX == 9)
		{
			Talk();
			if (GetPosition(Voice) >= 1000000) { BossX = 10; }
		}

	}

	if (ZiggyHit == 1)
	{
		if (HitCounter > 0)
		{
			ent_cycle ("Ouch",0);
			HitCounter = HitCounter - 3 * time;
			if (HitCounter <= 0) { ZiggyHit = 0; }
			ZiggyMove = 0;
			wait(1);
		}
	}
	else
	{
		Blink();

		if (Delay > 0) { Delay = Delay - 1 * time; }

		if (Delay <= 0)
		{
			if (int(random(5)) == 3) { if ((Intro == 0) && (pWinLose.visible == ofF)) { CreateEnemy(); } }
		}

		if (ZiggyMove == 0)
		{
			ent_cycle("Stand",my.skill3);
			my.skill3 = my.skill3 + 5;
		}

		if (ZiggyMove == 1)
		{
			ent_frame("Hit",my.skill3);
			my.skill3 = my.skill3 + my.skill10 * time;
			if (my.skill3 > 100) { ZiggyMove = 0; my.skill3 = 0; }
		}

		if (ZiggyMove == 2)
		{
			ent_frame("Kick",my.skill3);
			my.skill3 = my.skill3 + my.skill10 * time;
			if (my.skill3 > 100) { ZiggyMove = 0; my.skill3 = 0; }
	
		}

		if (ZiggyMove == 3)
		{
			ent_frame("Hop",my.skill3);
			my.skill3 = my.skill3 + my.skill10 * time;
			if ((my.skill3 > 20) && (my.skill3 < 80)) { CantBeHit = 1; } else { CantBeHit = 0; }
			if (my.skill3 > 100) { ZiggyMove = 0; my.skill3 = 0; CantBeHit = 0; }
		}
	}

}

function CreateEnemy
{
	if ((Intro > 0) || (pWinLose.visible == on)) { return; }

	Delay = cZIGGY_DELAY;

	temp.x = my.x + 300;
	temp.y = my.y;
	temp.z = my.z + 9;


	if (Level == 1) { create (<Enemy1.mdl>,temp.x,Enemy); }
	if (Level == 2) { create (<Enemy2.mdl>,temp.x,Enemy); }
	if (Level == 3) { create (<Enemy3.mdl>,temp.x,Enemy); }

	if (Level == 4)
	{
		EnemyToCome = int(random(4)) + 1;

		if (EnemyToCome == 1) { create (<Enemy1.mdl>,temp.x,Enemy); }
		if (EnemyToCome == 2) { create (<Enemy2.mdl>,temp.x,Enemy); }
		if (EnemyToCome == 3) { create (<Enemy3.mdl>,temp.x,Enemy); }
	}

}

function ZiggyJump
{
	if (Intro > 0) { return; }
	if ((ZiggyMove == 0) && (ZiggyHit == 0) && (Health > 0))
	{
		MyZiggy.skill3 = 0;
		MyZiggy.skill10 = 6;
		ZiggyMove = 3;
	}
}

function ZiggyKick
{
	if (Intro > 0) { return; }
	if ((ZiggyMove == 0) && (ZiggyHit == 0) && (Health > 0))
	{
		MyZiggy.skill3 = 0;
		MyZiggy.skill10 = 6;
		ZiggyMove = 2;
	}
}

function ZiggyPunch
{
	if (Intro > 0) { return; }
	if ((ZiggyMove == 0) && (ZiggyHit == 0) && (Health > 0))
	{
		MyZiggy.skill3 = 0;
		MyZiggy.skill10 = 15;
		ZiggyMove = 1;
	}
}

on_z = ZiggyPunch;
on_x = ZiggyKick;
on_c = ZiggyJump;

action Enemy
{
	my.Phase = 0; // Enemy phase

	my.scale_x = 0.15;
	my.scale_y = 0.15;
	my.scale_z = 0.15;

	my.shadow = on;

	my.pan = 320;

	while(1)
	{
		if (KillEmAll == 1) { remove (my); return; }

		if (ToKill <= 0) { my.x = my.x + 10 * time; my.z = my.z + 10 * time; }
 
		if (my.Phase == 0)	// Enemy approaches
		{
			my.x = my.x - LevelSpeed * time;
			ent_cycle("Walk",my.skill5);
			my.skill5 = my.skill5 + 15 * time;

			// Enemy can throw shurikans
			if (int(random(200)) == 100) { create (<Shurikan.mdl>,my.x,Shurikan); my.Phase = 5; }
			if (my.x < (MyZiggy.x + 80)) { my.Phase = 1; }
		}

		if (My.Phase == 1)	// Decide whether to jump or to attack
		{
			ent_frame ("Walk",0);

			if (int(random(20)) == 10)
			{
				if (int(random(2)) == 1) { my.Phase = 2; my.skill3 = 0; } else { my.Phase = 3; my.skill3 = 0; }
			}
		}

		if (My.Phase == 2)	// Enemy kicking
		{
			if (ZiggyMove == 2) 
			{ 
				if (my.x > player.x)
				{
					HitSound();
					KillMe(); 
				}
				else
				{
					ent_cycle ("Jump",my.skill3); 
					my.skill3 = my.skill3 + 5;
					my.x = my.x - 8 * time;
					my.z = my.z + 2 * time;

				}
			}
			else
			{
				if (my.skill10 == 0) 
				{ 
					ent_cycle ("Jump",my.skill3); 
					my.skill3 = my.skill3 + 5;
					my.x = my.x - 8 * time;
					my.z = my.z + 2 * time;
					if (my.skill3 > 500) { actor_explode(); }
					if ((ZiggyHit == 0) && (my.skill40 == 0))
					{
						if (Health > 0) { HitSound(); }
						my.skill40 = 1;
						Health = Health - 1;
						ZiggyHit = 1;
						HitCounter = CONST_HIT_DURATION;
					}
				}
			}
		}

		if (My.phase == 3)	// Enemy hitting
		{
			if (ZiggyMove == 1) 
			{ 
				HitSound();
				KillMe(); 
			}
			else
			{
				if (my.skill10 == 0) 
				{ 
					ent_frame ("Hit",my.skill3); 
					my.skill3 = my.skill3 + 5;
					if (my.skill3 > 50) { my.Phase = 1; my.skill3 = 0; }
					if ((ZiggyHit == 0) && (my.skill40 == 0))
					{
						if (Health > 0) { HitSound(); }
						my.skill40 = 1;
						Health = Health - 1;
						ZiggyHit = 1;
						HitCounter = CONST_HIT_DURATION;
					}
				}
			}

		}

		if (My.phase == 5)	// Enemy throwing shurikan
		{
			ent_frame ("Hit",my.skill3);
			my.skill3 = my.skill3 + 5;
			if (my.skill3 > 50) { my.Phase = 0; my.skill3 = 0; }

		}


		wait(1);
	}
}

action Shurikan
{
	my.shadow = on;

	fade_color.RED = 255;
	fade_color.GREEN = 255;
	fade_color.BLUE = 255;

	while(1)
	{
		if (Level == 5)
		{
			MY.LIGHTRED = 128;
			MY.LIGHTGREEN = 0;
			MY.LIGHTBLUE = 0;
			MY.LIGHTRANGE = 100;
			MY.AMBIENT = 100;
			my.x = my.x - 4 * time;

			temp = 3 * TIME;
			if(temp > 20) { temp = 20; }		// generate max 6 particels
			emit(temp,MY.POS,particlefade); 	// smoke trail

		}

		my.x = my.x - 6 * time;
		if (Level == 5) { my.x = my.x + 2 * time; }
		my.tilt = my.tilt + 10;
		my.skill1 = my.skill1 + 1;

		if ((my.x < MyZiggy.x + 10) && (CantBeHit == 0)) 
		{ 
			if (my.x > MyZiggy.x)
			{
				Health = Health - 1;
				ZiggyHit = 1; 
				HitCounter = CONST_HIT_DURATION; 
				//_gib(5); 
				actor_explode(); 
			}
		}

		if (my.skill1 > 200) { actor_explode(); }
		wait(1);
	}
}

function KillMe()
{
	if (my.skill10 == 0) { 	ToKill = ToKill - 1; }
	my.skill10 = 1;

	if (my.skill36 == 0)
	{
		my.skill11 = int(random(20)) + 1;
		if (my.skill11 == 1) { play_sound (NIN01,100); }
		if (my.skill11 == 2) { play_sound (NIN02,100); }
		if (my.skill11 == 3) { play_sound (NIN03,100); }
		if (my.skill11 == 4) { play_sound (NIN04,100); }
		if (my.skill11 == 5) { play_sound (NIN05,100); }
		if (my.skill11 == 6) { play_sound (NIN06,100); }
		if (my.skill11 == 7) { play_sound (NIN07,100); }
		if (my.skill11 == 8) { play_sound (NIN08,100); }
		if (my.skill11 == 9) { play_sound (NIN09,100); }
		if (my.skill11 ==10) { play_sound (NIN10,100); }
		if (my.skill11 ==11) { play_sound (NIN11,100); }
		if (my.skill11 ==12) { play_sound (NIN12,100); }
		if (my.skill11 ==13) { play_sound (NIN13,100); }
		if (my.skill11 ==14) { play_sound (NIN14,100); }
		if (my.skill11 ==15) { play_sound (NIN15,100); }
		if (my.skill11 ==16) { play_sound (NIN16,100); }
		if (my.skill11 ==17) { play_sound (NIN17,100); }
		if (my.skill11 ==18) { play_sound (NIN18,100); }
		if (my.skill11 ==19) { play_sound (NIN19,100); }
		if (my.skill11 ==20) { play_sound (NIN20,100); }
		my.skill36 = 1;
	}

	while(1)
	{
		ent_frame ("Die",0);
		my.skill10 = my.skill10 + 3 * time;
		my.x = my.x + 5 * time;
		my.z = my.z + 5 * time;
		if (my.skill10 > 200) { actor_explode(); }
		wait(1);
	}
}

action Fog
{
	while(1)
	{
		my.u = my.u + my.skill1 * time;
		wait(1);
	}
}

action EvilBoss
{
	my.skill40 = 0;
	my.skill1 = 1;
	my.skill3 = 0;
	my.invisible = on;
	my.skill10 = my.x;
	my.x = my.x + 80;
	BossX = 1;

	while(1)
	{
		my.y = player.y;

		if (Level == 5)
		{
			while (Intro > 0) { wait(1); }

			my.invisible = off;
			my.shadow = on;

			if (BossX == 1)
			{
				Blink();
				my.x = my.x - 1 * time;
				ent_cycle("Walk",my.skill2);
				my.skill2 = my.skill2 + 5;
				if (my.x <= my.skill10) { BossX = 2; }
			}

			if (BossX == 2)
			{
				sPlay ("BOS004.WAV");
				BossX = 3;
			}

			if (BossX == 3)
			{
				Talk();
				if (GetPosition(Voice) >= 1000000) { BossX = 4; }
			}

			if ((BossX == 4) || (BossX == 5)) { Blink(); }

			if (BossX == 6)
			{
				sPlay ("BOS005.WAV");
				BossX = 7;
			}

			if (BossX == 7)
			{
				Talk();
				if (GetPosition(Voice) >= 1000000) { BossX = 8; }
			}

			if ((BossX == 8) || (BossX == 9)) { Blink(); }

			if (BossX == 10)
			{
				if (snd_playing (MUS) == 0) { play_loop (L15,50); MUS = result; }
				if (my.skill1 == 1)
				{
					if (my.skill40 >= 2)
					{
						if ((ZiggyMove == 1) || (ZiggyMove == 2))
						{
							my.skill1 = 3;
						}
					}

					ent_frame("Stand",0);
					if (int(random(40)) == 20) 
					{ 
						my.x = my.x + 3 * time; 
						create (<spark.mdl>,my.x,Shurikan); 
						my.skill3 = my.skill3 + 3 * time;
					}
					if (my.skill3 > 10) { my.skill40 = my.skill40 + 1; my.skill1 = 2; my.skill2 = 0; }
				}
		
				if (my.skill1 == 2)
				{
					if (my.x > player.x + 50)
					{
						my.x = my.x - 3 * time;
						ent_cycle("Walk",my.skill2);
					}
					else { my.x = player.x + 50; my.skill40 = 2; }

					my.skill2 = my.skill2 + 7.5 * time;

					if (my.skill2 > 200) { my.skill1 = 1; my.skill2 = 0; my.skill3 = 0; }
				}

				if (my.skill1 == 3)
				{
					if (pWinLose.visible == off) { sPlay ("SFX138.WAV"); }
					pWinLose.bmap = YouWin;
					pWinLose.visible = on;

					my.x = my.x + 10 * time;
					my.z = my.z + 10 * time;

					if (GetPosition(Voice) >= 1000000) 
					{ 
						pWinLose.visible = off;
						SetWeather();
						Level = 6;
						Scene = 0;
						Timer = 0;
						Intro = 4;
						stop_sound (MUS);
					}
					
				}
			}
		}
		else
		{
			my.invisible = on;
			my.shadow = off;
		}

		wait(1);
	}
}

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 100;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = fade_color.RED;
		MY_COLOR.GREEN = fade_color.GREEN;
		MY_COLOR.BLUE = fade_color.BLUE;
	}
	else
	{
		MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

function SetWeather
{
	if (Level == 1) { Storm(); }
	if (Level == 3) { let_it_rain(); }
	if (Level == 4) { let_it_snow(); }
	if (Level == 5) { Storm(); }
}

action SkyX
{
	while(1)
	{
		my.pan = my.pan + 0.5 * time;
		wait(1);
	}
}

action FogX
{
	while(1)
	{
		my.pan = my.pan - my.skill1 * time;
		wait(1);
	}
}

action Ground
{
	my.ambient = 100;
	while(1)
	{
		if (Level == my.skill1) { my.invisible = off; } else { my.invisible = on; }
		wait(1);
	}
}

function Talk()
{
	my.skill13 = my.skill13 + 1 * time;
	if (my.skill13 > 1.5) { my.skin = int(random(8))+1; my.skill13 = 0; }
}

function Blink()
{
	if (my.skill12 > 0) { my.skill12 = my.skill12 - 1 * time; }
	if (my.skill12 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill12 = 5; }
	}
}

action Scenary
{
	my.skill10 = Level;

	while(1)
	{
		if (my.skill10 != Level)
		{
			if (Level == 1)
			{
				if (my.skill1 == 1) { morph (<Pagoda.mdl>,my); } else { morph (<JapArc.mdl>,my); }
			}

			if (Level == 2)
			{
				if (my.skill1 == 1) { morph (<Wall.mdl>,my); } else { morph (<Cactus.mdl>,my); }
			}

			if (Level == 3)
			{
				if (my.skill1 == 1) { morph (<Palmtree.mdl>,my); } else { morph (<Bush2.mdl>,my); }
			}

			if (Level == 4)
			{
				if (my.skill1 == 1) { morph (<airball.mdl>,my); } else { morph (<tower.mdl>,my); }
			}

			if (Level == 5)
			{
				if (my.skill1 == 1) { morph (<asylum.mdl>,my); } else { morph (<columb2.mdl>,my); }
			}

			my.skill10 = Level;
		}

		wait(1);
	}
}

function quitziggy
{
	Run ("Inn.exe");
}

action Cam
{
	my.passable = on;
	my.invisible = on;

	while (1)
	{
		if (Intro == 0)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

action intCam
{
	my.passable = on;
	my.invisible = on;

	while(1)
	{
		if (Intro > 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

action intCam2
{
	my.passable = on;
	my.invisible = on;

	while(1)
	{
		if (Intro == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

action Dome
{
	my.skin = 2;
	while(1) { my.pan = my.pan + 0.2 * time; wait(1); }
}

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 200;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		//MY_COLOR.RED = fade_color.RED;
		//MY_COLOR.GREEN = fade_color.GREEN;
		//MY_COLOR.BLUE = fade_color.BLUE;

		MY_COLOR.RED = 0;
		MY_COLOR.GREEN = 0;
		MY_COLOR.BLUE = 255;

	}
	else
	{
		MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		if(MY_AGE > 50) { MY_ACTION = NULL; }
	}
}

action Actor
{
	while (1)
	{
		if (Intro != 4) { if (my.skill1 == 3) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; } }
		if (Intro == 4) { if (my.skill1 == 2) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; } }

		if (Intro > 1)
		{
			if (int(random(300)) == 150) { play_sound (birds,20); }
			if ((Intro == 2) && (Timer > 100))
			{
				if (Scene == 0) { sPlay ("BOS002.WAV"); Scene = 1; }
				if (Scene == 1) { if (my.skill1 == 2) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
	
				if (GetPosition(Voice) >= 1000000) { Intro = 0; }
			}

			if ((Intro == 3) && (Timer > 100))
			{
				if (Scene == 0) { sPlay ("SUR003.WAV"); Scene = 1; }
				if (Scene == 1) { if (my.skill1 == 1) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 1) { if (GetPosition(Voice) >= 1000000) { Scene = 2; } }
				if (Scene == 2) { sPlay ("BOS003.WAV"); Scene = 3; }
				if (Scene == 3) { if (my.skill1 == 2) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 3) { if (GetPosition(Voice) >= 1000000) { Intro = 0; } }
			}


			if ((Intro == 3.5) && (Timer > 100))
			{
				if (Scene == 0) { sPlay ("SUR006.WAV"); Scene = 1; }
				if (Scene == 1) { if (my.skill1 == 1) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 1) { if (GetPosition(Voice) >= 1000000) { Scene = 2; } }
				if (Scene == 2) { sPlay ("BOS006.WAV"); Scene = 3; }
				if (Scene == 3) { if (my.skill1 == 2) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 3) { if (GetPosition(Voice) >= 1000000) { Intro = 0; } }
			}


			if ((Intro == 4) && (Timer > 100))
			{
				if ((Scene != 1) && (Scene != 5) && (Scene != 9) && (Scene != 10)) { if (my.skill1 == 3) { ent_frame ("stand",0); } }
				if (Scene == 0) { sPlay ("ZIG008.WAV"); Scene = 1; }
				if (Scene == 1) { if (my.skill1 == 3) { if (int(random(20)) == 10) { ent_frame ("Land",int(random(9)) * 12.5); } my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 1) { if (GetPosition(Voice) >= 1000000) { Scene = 2; } }
				if (Scene == 2) { sPlay ("SUR004.WAV"); Scene = 3; }
				if (Scene == 3) { if (my.skill1 == 1) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 3) { if (GetPosition(Voice) >= 1000000) { Scene = 4; } }
				if (Scene == 4) { sPlay ("ZIG009.WAV"); Scene = 5; }
				if (Scene == 5) { if (my.skill1 == 3) { if (int(random(20)) == 10) { ent_frame ("Land",int(random(9)) * 12.5); } my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 5) { if (GetPosition(Voice) >= 1000000) { Scene = 6; } }
				if (Scene == 6) { sPlay ("SUR005.WAV"); Scene = 7; }
				if (Scene == 7) { if (my.skill1 == 1) { my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 7) { if (GetPosition(Voice) >= 1000000) { Scene = 8; } }
				if (Scene == 8) { sPlay ("ZIG010.WAV"); Scene = 9; }
				if (Scene == 9) { if (my.skill1 == 3) { if (int(random(20)) == 10) { ent_frame ("Land",int(random(9)) * 12.5); } my.skill11 = my.skill11 + 1 * time; if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; } } }
				if (Scene == 9) { if (GetPosition(Voice) >= 1000000) { Scene = 10; } }
				if (Scene == 10)
				{
					if (my.skill40 == 0) { sPlay ("SFX114.WAV"); my.skill40 = 1; }
					if (my.skill1 == 3) { my.z = my.z + 5 * time; ent_frame ("Special",0); my.pan = my.pan + 60 * time; emit(10,MY.POS,particlefade); }
					if (my.skill1 == 1) { my.z = my.z + 20 * time; my.x = my.x + 20 * time; }
					if (my.skill1 == 4) { my.z = my.z + 20 * time; my.x = my.x - 20 * time; }
					Counter = Counter + 1 * time;
					if (Counter > 200) 
					{
						AFG[23] = 1;
						WriteGameData(0);

						AFG_Show.skin = 23;
	
						AFG_Show.tilt = random(20) - 10;
	
						AFG_Show.visible = on;
						AFG_Show.alpha = 100;
	
						waitt (60);
	
						AFG_Show.transparent = on;
		
						while(AFG_Show.alpha > 3) { AFG_Show.alpha = AFG_Show.alpha - 3 * time; wait(1); }
	
						AFG_Show.alpha = 0;
						AFG_Show.visible = off;
	
						Run ("Inn.exe");
					}
				}
			}
		}

		wait(1);
	}
}

action Ninja
{
	my.skill3 = my.x + 350;
	my.skill4 = my.x - 350;
	my.skill10 = my.pan;

	while(1)
	{
		if (Intro == 1)
		{
			if ((Scene == 0) && (my.skill1 == 3))
			{
				my.x = my.x + 5 * time;
				ent_cycle ("Walk",my.skill2);
				my.skill2 = my.skill2 + 10 * time;
				if (my.x >= my.skill3) { ent_frame ("Stand",0); Scene = 1; SetVoice(); }
			}

			if (Scene == 1)
			{
				if (my.skill1 == 3) { if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
			}
	
			if (Scene == 2)
			{
				if (my.skill1 == 1) { if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
			}

			if (Scene == 3)
			{
				if (my.skill1 == 2) { if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
			}

			if (Scene == 4)
			{
				if (my.skill1 == 3) { ent_frame ("Mad",0); } else { ent_frame ("Frame",0); }
			}

			if (Scene == 5)
			{
				if (my.skill1 == 1) { my.pan = 300; if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
			}
	
			if (Scene == 6)
			{
				if (my.skill1 == 3) { if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
			}

			if (Scene == 7)
			{
				if (my.skill1 == 2) { if (int(random(5)) == 2) { ent_frame ("Talk",int(random(5)) * 25); } } else { ent_frame ("Frame",0); }
				if (my.skill1 == 1) { my.pan = my.skill10; }
			}
	
			if (Scene == 8)
			{
				if (my.skill1 == 1) { my.invisible = on; my.shadow = off; }
				if (my.skill1 == 2) { my.invisible = on; my.shadow = off; }
			}

			if ((Scene == 9) && (my.skill1 == 4))
			{
				if (my.x > my.skill4)
				{
					ent_cycle ("Walk",my.skill20);
					my.skill20 = my.skill20 + 10 * time;
					my.x = my.x - 10 * time;
				}
				my.skill11 = my.skill11 + 1 * time;
				if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
			}

			if (Scene > 0) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }
		}

		wait(1);
	}
}

action FCloud
{
	while(1)
	{
		if (Intro == 1)
		{
			ent_cycle ("Frame",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			my.pan = my.pan + 10 * time;
			if (Scene == 8) { if (snd_playing(my.skill40) == 0) { play_sound (Fight,50); my.skill40 = result; } my.invisible = off; }
		}
		wait(1);
	}
}

action Bush
{
	my.skill10 = my.x;

	while(1)
	{
		if (Intro == 0) { my.x = my.skill10; }
		else
		{
			my.x = my.x + my.skill1 * time;
			Timer = Timer + 1 * time;
		}
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 1 ) { sPlay ("NIN008.WAV"); }
	if (Scene == 2 ) { sPlay ("NIN009.WAV"); }
	if (Scene == 3 ) { sPlay ("NIN010.WAV"); }
	if (Scene == 4 ) { sPlay ("NIN011.WAV"); }
	if (Scene == 5 ) { sPlay ("NIN012.WAV"); }
	if (Scene == 6 ) { sPlay ("NIN013.WAV"); }
	if (Scene == 7 ) { sPlay ("NIN014.WAV"); }
	if (Scene == 8 ) { sPlay ("NIN015.WAV"); }
	if (Scene == 9 ) { sPlay ("BOS001.WAV"); }
	if (Scene == 10) { Intro = 0; }
}

on_esc = quitziggy();