include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var Talking = 0;
var CamShow = 1;
var Counter = 0;
var Phase = 0;

bmap Nof = <Horizon2.pcx>;
bmap btxt1 = <txt1.pcx>;
bmap btxt2 = <txt2.pcx>;
bmap btxt3 = <txt3.pcx>;
bmap btxt4 = <txt4.pcx>;
bmap btxt5 = <txt5.pcx>;

panel pKtuvit
{
	bmap = btxt1;
	pos_y = 461;
	flags = refresh,d3d,transparent;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	level_load("VilInt.wmb");

	VoiceInit();
	Initialize();

	SetVoice();

	scene_map = Nof;
}

action Cam
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			if (Talking == 4) { camera.z = my.z + (int(random(3)) - 1) * 2; }
		}

		if (Scene > 1)
		{
			my.skill2 = my.skill2 - 1 * time;
			if (CamShow < 3) { if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; } }
		}

		wait(1);
	}
}

action Piposh
{
	player = my;
	my.skill30 = my.pan;

	my.skill10 = my.x;
	my.skill11 = my.y;

	while(1)
	{
		if ((CamShow < 3) && (Counter == 0)) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (Scene == 1) { if (GetPosition (Voice) > 400000) { my.pan = my.skill30 + 60; } }
		if (Scene > 1) { my.pan = my.skill30 + 160; }

		while (DialogIndex == 15)
		{
			blink();

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP545.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("OSN002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP546.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (15);
			}
	
			if (DialogChoice == 2) 
			{ 
				on_space = null;	// Fixed: skipping sounds cause problems for this animation
				sPlay ("PIP548.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				pKtuvit.bmap = btxt1;
				pKtuvit.visible = on;
				sPlay ("GOD001.WAV"); Talking = 4; CamShow = 4; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				pKtuvit.visible = off;
				sPlay ("OSN003.WAV"); Talking = 2; CamShow = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				pKtuvit.bmap = btxt2;
				pKtuvit.visible = on;
				sPlay ("GOD002.WAV"); Talking = 4; CamShow = 4; while (GetPosition(Voice) < 1000000) { Blink(); if (GetPosition(Voice) > 500000) { pKtuvit.bmap = btxt3; CamShow = 3; } if (GetPosition(Voice) > 700000) { ent_cycle ("Walk",my.skill9); my.skill9 = my.skill9 + 10 * time; my.x = my.x - 10 * time; my.y = my.y - 10 * time; } wait(1); }
				pKtuvit.visible = off;
				Phase = 1;
				Talking = 1;
				sPlay ("PIP549.WAV");

				while (Phase != 0) { wait(1); }

				CamShow = 1;

				sPlay ("GOD004.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("OSN004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

				Flag_First_Village = 1;
				WriteGameData (0);

				Run ("Fight.exe");
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP547.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("WIF005.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); CamShow = 1; wait(1); }
				sPlay ("SHA006.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); CamShow = 1; wait(1); }
				DoDialog (15);
			}

			wait(1);
		}

		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }
		if (Talking == 1) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action Goddy
{
	my.skill1 = my.pan;

	while(1)
	{
		ent_cycle ("Frame",my.skill11); my.skill11 = my.skill11 + 5 * time;
		if (CamShow > 2) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		if (Talking == 5) { my.pan = my.skill1 + 40; }
		wait(1);
	}
}

action Mic
{
	while(1)
	{
		if (CamShow > 2) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action Piposh2
{
	my.invisible = on;

	my.skill1 = my.x;
	my.x = my.x - 200;

	while (1)
	{
		if (Phase == 1) 
		{ 
			my.invisible = off;
			Talk2(); 
			if (my.x < my.skill1) 
			{ 
				my.x = my.x + 10 * time; 
				ent_cycle ("Walk",my.skill9); 
				my.skill9 = my.skill9 + 10 * time; 
			} 
			else 
			{ 
				Phase = 2; 
			} 
		}

		if (Phase == 2) 
		{ 
			if (my.skill20 < 100) 
			{ 
				ent_frame ("Fkick",my.skill20); 
				my.skill20 = my.skill20 + 10 * time; 
				if (my.skill20 > 80) { if (my.skill40 == 0) { sPlay ("GOD003.WAV"); Talking = 5; my.skill40 = 1; } }
			} 
			else 
			{ 
				my.skin = 1;
				ent_frame ("Stand",0);
				while (GetPosition(Voice) < 1000000) { wait(1); }
				Phase = 0; 
			} 
		} 

		wait(1);
	}
}

action Chief
{
	while(1)
	{
		if (Talking == 2) { talk(); } else { blink(); }
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.wav"); Talking = 0; }
	if (Scene == 1) { sPlay ("PIP116.WAV"); Talking = 1; }
	if (Scene == 2) { sPlay ("OSN001.WAV"); Talking = 2; }
	if (Scene == 3) { DoDialog (15); }
}

action Blinker
{
	while (1)
	{
		if (my.flag1 == on) { if (Talking == 3) { talk(); } else { blink(); } } else { blink(); }
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(20)) == 10) 
	{ 
		if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } 
		else 
		{ 
			if (my.flag1 != on) { ent_frame ("Talk",int(random(5)) * 25); } else { ent_frame ("Speech",int(random(23)) * 4.54); }
		}

		if (Talking == 3) { ent_frame ("Talk",int(random(7)) * 16.6); }
	}
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

function Blink()
{
	ent_frame ("Stand",0);
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}