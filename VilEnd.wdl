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
var ShowMe = 0;
var Cook = 0;
var Release = 0;

bmap btxt1 = <txt7.pcx>;
bmap btxt2 = <txt4.pcx>;
bmap btxt3 = <txt5.pcx>;
bmap btxt4 = <txt6.pcx>;

bmap bBtn1 = <btn1.pcx>;
bmap bBtn2 = <btn2.pcx>;
bmap bBtn3 = <btn3.pcx>;
bmap bBtn4 = <btn4.pcx>;
bmap bCredits = <credits.pcx>;
bmap b2Min = <2Min.pcx>;

panel pKtuvit
{
	bmap = btxt1;
	pos_y = 461;
	flags = refresh,d3d,transparent;
}

panel p2Min
{
	bmap = b2Min;
	flags = refresh,d3d;
}

panel pBack
{
	bmap = bcredits;
	layer = 10;
	flags = d3d,refresh;
}

panel pButton1
{
	pos_x = 500;
	pos_y = 350;
	layer = 11;
	flags = refresh,d3d;

	button = 0, 0, bBtn2, bBtn1, bBtn2, Opt1, null, null;
}

panel pButton2
{
	pos_x = 0;
	pos_y = 350;
	layer = 11;
	flags = refresh,d3d;

	button = 0, 0, bBtn4, bBtn3, bBtn4, Opt2, null, null;
}

function Opt1 { Release = 1; }
function Opt2 
{ 
	sPlay ("DOS003.WAV");
	while (GetPosition(Voice) < 1000000) { if (pBack.pos_y > -265) { pBack.pos_y = pBack.pos_y - 0.5 * time; } wait(1); }
	Release = 1;
}

sound Kick = <SFX015.WAV>;

sound Ring1 = <Ring01.WAV>;
sound Ring2 = <Ring02.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	level_load("VilEnd.wmb");

	VoiceInit();
	Initialize();

	SetVoice();

	scene_map = Null;
}

action Cam
{
	while(1)
	{
		if (Scene == 1) { CamShow = 3; }

		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			if (CamShow == 5) { camera.z = my.z + (int(random(3)) - 1) * 2; }
		}

		my.skill2 = my.skill2 - 1 * time;
		if (CamShow < 3) { if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; } }

		wait(1);
	}
}

action Piposh2
{
	while(1)
	{
		if (Scene == 1) { ent_frame ("Win",my.skill1); my.skill1 = my.skill1 + 2 * time; talk2(); my.invisible = off; }
		else { my.invisible = on; }

		wait(1);
	}
}

function Sneeze
{
	my.skill36 = 0;
	if (int(random(2)) == 1) { sPlay ("SFX123.WAV"); } else { sPlay ("SFX124.WAV"); } }
}

action Ami
{
	while(1)
	{
		if (ShowMe == 2) { my.invisible = off; } else { my.invisible = on; }
		talk();
		wait(1);
	}
}

action Piposh
{
	player = my;

	while(1)
	{
		if (Scene == 2) { if (my.flag1 == on) { my.invisible = off; } else { my.invisible = on; } }
		if (Scene >= 3) { if (my.flag2 == on) { my.invisible = off; } else { my.invisible = on; } }

		while (Dialog.visible == on) { CamShow = 4; Blink(); wait(1); }

		while ((DialogIndex == 16) & (my.flag2 == on))
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP551.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				sPlay ("Shevet.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 10; Blink(); wait(1); }
				DoDialog (16);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP552.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				pKtuvit.bmap = btxt2;
				pKtuvit.visible = on;
				sPlay ("GOD005.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { CamShow = 5; Blink(); wait(1); }
				pKtuvit.visible = off;
				DoDialog (16);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP553.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				sPlay ("MAR013.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("KVC014.WAV"); Talking = 8; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("MAR014.WAV"); Talking = 7; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("KVC015.WAV"); Talking = 8; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("MAR015.WAV"); Talking = 7; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("KVC016.WAV"); Talking = 8; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				sPlay ("MAR016.WAV"); Talking = 7; while (GetPosition(Voice) < 1000000) { CamShow = 6; Blink(); wait(1); }
				p2Min.visible = on;
				waitt(32);
				p2Min.visible = off;
				ShowMe = 1;
				pKtuvit.bmap = btxt1;
				pKtuvit.visible = on;
				Cook = 0;
				sPlay ("MAR019.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				pKtuvit.visible = off;
				Cook = 1;
				sPlay ("MAR034.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				sPlay ("KVC017.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				Cook = 2;
				sPlay ("MAR017.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				Cook = 0;
				sPlay ("MAR018.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				sPlay ("KVC018.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				Cook = 3;
				sPlay ("MAR020.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }

				sPlay ("PIP554.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) 
				{ 
					if (my.skill35 == 0) { if (int(random(2)) == 1) { play_sound (Ring1,50); } else { play_sound (Ring1,50); } my.skill35 = 1; }
					CamShow = 4; 
					if (GetPosition(Voice) < 500000) { Talk(); }
					else { if (my.skill38 == 0) { morph(<Pipspet.mdl>,my); my.skill38 = 1; } ent_frame ("Dial",100); talk2(); }

					wait(1); 
				}

				sPlay ("SHK027.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }

				DoDialog (17);
			}

			wait(1);
		}

		while ((DialogIndex == 17) & (my.flag2 == on))
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP555.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				ShowMe = 1; Cook = 0; sPlay ("MAR021.WAV"); Talking = 9; while (GetPosition(Voice) < 1000000) { CamShow = 7; Blink(); wait(1); }
				sPlay ("KVC019.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 99; Blink(); wait(1); }
				morph (<Piposh.mdl>,my);
				CamShow = 1; sPlay ("OSN006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				pKtuvit.bmap = btxt3;
				pKtuvit.visible = on;
				sPlay ("GOD006.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { CamShow = 5; Blink(); wait(1); }
				pKtuvit.visible = off;
				CamShow = 2; sPlay ("OSN007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				pKtuvit.bmap = btxt4;
				pKtuvit.visible = on;
				sPlay ("GOD007.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { CamShow = 5; Blink(); wait(1); }
				pKtuvit.visible = off;
				CamShow = 1; sPlay ("OSN008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				pKtuvit.bmap = btxt4;
				pKtuvit.visible = on;
				sPlay ("GOD008.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { CamShow = 5; Blink(); wait(1); }
				pKtuvit.visible = off;
				sPlay ("PIP562.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				ShowMe = 2; sPlay ("AMI008.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 2; Blink(); wait(1); }
				ShowMe = 1; sPlay ("PIP563.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }

				ReturnToMap();

			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP560.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				sPlay ("SHK028.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }
				sPlay ("PIP561.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }

				pBack.visible = on;
				Release = 0;

				while (Release == 0)
				{
					if (pBack.pos_y > -265) { pBack.pos_y = pBack.pos_y - 0.5 * time; }

					if (pBack.pos_y < -100)
					{
						if (my.skill25 == 0)
						{
							my.skill25 = 1;
							pButton1.visible = on;
							sPlay ("DOS001.WAV");
							while (GetPosition(Voice) < 1000000) { if (pBack.pos_y > -265) { pBack.pos_y = pBack.pos_y - 0.5 * time; } wait(1); }
							pButton2.visible = on;
							sPlay ("DOS002.WAV");
						}
					}

					wait(1);
				}

				pBack.visible = off;
				pBack.pos_y = 0;
				pButton1.visible = off;
				pButton2.visible = off;

				sPlay ("DOS004.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }

				DoDialog (17);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP556.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				Sneeze(); while (GetPosition(Voice) < 1000000) { ent_frame ("Sneeze",my.skill36); my.skill36 = my.skill36 + 15 * time; CamShow = 4; wait(1); }
				sPlay ("SHK029.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }

				sPlay ("PIP557.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				Sneeze(); while (GetPosition(Voice) < 1000000) { ent_frame ("Sneeze",my.skill36); my.skill36 = my.skill36 + 15 * time; CamShow = 4; wait(1); }
				sPlay ("SHK030.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }

				sPlay ("PIP558.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }
				Sneeze(); while (GetPosition(Voice) < 1000000) { ent_frame ("Sneeze",my.skill36); my.skill36 = my.skill36 + 15 * time; CamShow = 4; wait(1); }
				sPlay ("SHK031.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { CamShow = 4; Blink(); wait(1); }

				sPlay ("PIP559.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { CamShow = 4; Talk(); wait(1); }

				DoDialog (17);
			}


			wait(1);
		}

		if (GetPosition(Voice) >= 1000000) { if (my.flag2 == on) { Scene = Scene + 1; SetVoice(); } }
		if (Talking == 1) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action Bad1
{
	while(1)
	{
		if (Talking == 6) { talk2(); }
		else
		{
			if (Talking == 7) { talk(); }
			else { blink(); }
		}

		wait(1);
	}
}

action Bad2
{
	while(1)
	{
		if (Talking == 8) { talk(); } else { blink2(); ent_cycle ("Stand",my.skill1); my.skill1 = my.skill1 + 5 * time; }
		wait(1);
	}
}

action Bad1xx
{
	while(1)
	{
		ent_frame ("Lie",0);
		talk2();
		wait(1);
	}
}

action Bad1x
{
	while(1)
	{
		if (Talking == 9) 
		{ 
			if (Cook == 0) { talk(); }
			if (Cook == 1) { ent_frame ("What",0); talk2(); }
			if (Cook == 2) { ent_cycle ("Jump",my.skill1); my.skill1 = my.skill1 + 20 * time; talk2(); }
			if (Cook == 3) { if (my.skill40 == 0) { play_sound (Kick,100); ent_frame ("Kick",0); my.skill40 = 1; } talk(); }
		} 
		else { blink(); }

		if (ShowMe == 1) { my.invisible = off; } else { my.invisible = on; }
		wait(1);
	}
}

action Bad2x
{
	my.skill2 = my.y;
	my.y = my.y - 100;

	while(1)
	{
		if (Talking == 10) { talk(); } else { if (my.skill40 == 0) { blink2(); } else { blink(); } }

		if (ShowMe == 1) 
		{
			my.invisible = off; 
			if (my.y < my.skill2) { ent_cycle ("Walk",my.skill1); my.skill1 = my.skill1 + 10 * time; my.y = my.y + 5 * time; } else { my.skill40 = 1; }
			if (Cook == 3) { my.y = my.y - 30 * time; my.z = my.z + 10 * time; }
		} 
		else { my.invisible = on; }

		wait(1);
	}
}

action Goddy
{
	my.skill1 = my.pan;

	while(1)
	{
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

action Chief
{
	while(1)
	{
		if (Talking == 2) { talk(); } else { blink(); }
		wait(1);
	}
}

action Cheer
{
	my.skill1 = my.z;
	my.skill12 = 14;
	my.skill28 = my.pan;

	while(1)
	{
		if (GetPosition(Voice) < 730000)
		{
			ent_cycle ("Dance",my.skill2);
			my.skill2 = my.skill2 + 10 * time;
			talk2();
		} else { Blink(); }

		if ((my.flag1 == on) && ((CamShow == 10) || (CamShow == 11)))
		{
			if (GetPosition(Voice) > 800000) 
			{ 
				CamShow = 11; my.z = my.skill1; 
				if (GetPosition(Voice) < 880000)
				{
	 				if (GetPosition(Voice) > 810000) { my.pan = my.skill28 + 30; }
 					if (GetPosition(Voice) > 830000) { my.pan = my.skill28; }
	 				if (GetPosition(Voice) > 850000) { my.pan = my.skill28 - 30; }
					if (GetPosition(Voice) > 870000) { my.pan = my.skill28; } 
				}
			}
			else 
			{
				if (GetPosition(Voice) > 600000) { my.z = my.z + my.skill12 * time; if ((my.z > (my.skill1 + 40)) || (my.z < (my.skill1 - 40))) { my.skill12 = -my.skill12; } }
			}
		}

		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.wav"); Talking = 0; }
	if (Scene == 1) { sPlay ("PIP550.WAV"); Talking = 1; }
	if (Scene == 2) { CamShow = 1; sPlay ("OSN005.WAV"); Talking = 2; }
	if (Scene == 3) { DoDialog (16); }
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

function Blink2()
{
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