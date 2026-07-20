include <IO.wdl>;

synonym Piposh { type entity; }

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Dance = 1;
var Scene = 0;
var Talking = 0;
var Genia = 0;

sound Vin = <SFX105.WAV>;

bmap bSom = <Ami.pcx>;
bmap bOvr = <Someover.bmp>;

panel pSom
{
	layer = 2;
	bmap = bSom;
	pos_x = 0;
	pos_y = 460;
	flags = refresh,d3d;
}

panel pOvr
{
	layer = 3;
	bmap = bOvr;
	pos_x = 223;
	pos_y = 460;
	flags = refresh,d3d;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;
	vNoSave = 1;

	load_level(<Studio.WMB>);

	VoiceInit();
	Initialize();

	DialogIndex = -1;

	SetVoice();
}

action StartDialog
{
	if (Talking == 0) { DoDialog (0); }
}

action Ami
{
	pOvr.visible = on;
	pSom.visible = on;

	my.event = StartDialog;
	my.enable_click = on;

	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }

		if (POvr.pos_x > -310) 
		{ 
			POvr.pos_x = POvr.pos_x - 8 * time; 
		}
		else
		{
			my.skill34 = my.skill34 + 1 * time;
			my.skill35 = my.skill35 + 1 * time;

			if (my.skill34 > 60) 
			{ 
				pOvr.pos_y = pOvr.pos_y + 1 * time;
				pSom.pos_y = pSom.pos_y + 1 * time;
			}

			if (my.skill35 > 5) 
			{ 
				if (POvr.visible == on) { pOvr.visible = off; } else { pOvr.visible = on; }
				my.skill35 = 0; 
			}
		}

		wait(1);
	}
}

action Naknik
{
	Piposh = my;
	my.skin = 9;

	while(1)
	{
		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 0)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP001.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("AMI002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP002.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = -1; Talking = 0;
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP003.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP004.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("AMI003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP005.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = -1; Talking = 0;
			}

			if (DialogChoice == 3) 
			{
				if ((Genia == 0) && (DialogChoice == 3))
				{
					sPlay ("PIP006.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AMI004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP007.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					Genia = 1; 
					DoDialog (0);
				}

				if ((Genia == 1) && (DialogChoice == 3))
				{
					sPlay ("PIP531.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AMI004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP008.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					Genia = 2;
					DoDialog (0);
				}

				if ((Genia == 2) && (DialogChoice == 3))
				{
					sPlay ("PIP531.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AMI007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP009.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					DialogIndex = -1; Talking = 0; Genia = 0;
				}

			}
	
			wait(1);
		}

		if (Dance == 1)
		{
			ent_cycle ("Dance",my.skill22);
			my.skill22 = my.skill22 + 1.5 * time;
			Talk2();
		}
		else
		{
			if (Talking == 1) { Talk(); } else { Blink(); }
		}

		wait(1);
	}
}

action Dummy
{
	while(1)
	{
		if (snd_playing(my.skill40) == 0) { play_entsound (my,vin,1000); my.skill40 = result; }
		wait(1);
	}
}

action TheCam
{
	while(1)
	{
		if (Talking == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

action TheCam2
{
	while(1)
	{
		if ((Talking == 2) || (Talking == 0))
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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

action ShikKlik
{
	if (Talking == 0)
	{
		Dialog.visible = off;
		HideText();
		DialogIndex = -1;
		sPlay ("SHK001.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { wait(1); }
		sPlay ("PIP010.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
		sPlay ("SHK002.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { wait(1); }
		sPlay ("PIP011.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
		
		Run ("Shiks.exe");
	}
}

action ShikNote
{
	my.event = ShikKlik;
	my.enable_click = on;
}

function SetVoice
{
	if (scene == 0) { sPlay ("Wait.wav"); }
	if (Scene == 1) { sPlay ("SNG010.WAV"); Talking = 1; }
	if (Scene == 2) { Dance = 0; sPlay ("AMI001.WAV"); Talking = 2; }
	if (Scene == 3) { DoDialog (0); }
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}