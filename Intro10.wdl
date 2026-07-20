include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var Talking = 0;
var CamShow = 1;
var Counter = 0;
var SND = 0;
var StopCamera = 0;

sound Ambient = <SFX083.WAV>;
sound SearchSND = <SFX084.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	level_load("Intro10.wmb");

	VoiceInit();
	Initialize();

	SetVoice();
}

action PiposhRun
{
	while(1)
	{
		if (Scene > 4)
		{
			my.invisible = off;
			my.shadow = on;
			ent_cycle ("Run",my.skill1);
			my.skill1 = my.skill1 + 8 * time;
			my.x = my.x - 8 * time;
		}

		wait(1);
	}
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

			if (Scene == 10)
			{
				my.x = my.x - 0.8 * time;
				my.y = my.y + 0.4 * time;
			}
		}

		wait(1);
	}
}

action Soldier
{
	while(1)
	{
		ent_frame ("Stand",int(random(100)));
		waitt(int(random(32)));
	}
}

action Flash
{
	my.lightred = 255;
	my.lightblue = 255;
	my.lightgreen = 255;
	my.invisible = on;

	my.lightrange = 0;

	while(1)
	{
		my.lightrange = 0;

		if ((int(random(100)) == 50) && (StopCamera < 10))
		{
			StopCamera = StopCamera + 1;
			my.lightrange = random(500);
		}
		wait(1);
	}
}

action Piposh
{
	player = my;

	while(1)
	{
		if ((CamShow == 1) && (Counter == 0)) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 31)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP254.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("YCH012.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP255.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (31);
			}
	
			if (DialogChoice == 2) 
			{ 
				my.invisible = on; my.shadow = off;
				CamShow = 2; sPlay ("PIP256.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				CamShow = 1;
				DialogIndex = 0; Talking = 0;
				Scene = 5; SetVoice();
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP257.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("KRP016.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (31);
			}

			wait(1);
		}

		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }
		if (Talking == 1) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action PieceX
{
	while(1) { if (Counter < 1000) { my.invisible = on; } else { my.invisible = off; } if (CamShow != 2) { my.invisible = on; } wait(1); }
}

action PipSearch
{	
	while(1)
	{
		if (CamShow == 2) { my.invisible = off; } else { my.invisible = on; }

		if (CamShow == 2)
		{
			if (my.skill40 == 0) { play_sound (SearchSND,30); my.skill40 = 1; }

			if (Counter < 1000)
			{
				ent_cycle ("Search",Counter);
				Counter = Counter + 20 * time;
			}
			else
			{
				ent_frame ("GotIt",0);
				Talk2();
			}
		}

		wait(1);
	}
}

action Dome { while(1) { my.pan = my.pan + 0.2; wait(1); } }

action Ad
{
	my.skin = int(random(7)) + 1;
}

action Yachdal
{
	my.skill1 = my.pan;

	while(1)
	{
		if ((snd_playing (SND) == 0) && (StopCamera < 10)) { play_sound (ambient,50); sND = result; }

		if ((Scene == 3) || (Scene > 6)) { my.pan = my.skill1 - 45; } else { my.pan = my.skill1; }
		if (CamShow == 2) { my.pan = my.skill1 + 90; }

		if (Talking == 2) { Talk(); } else { Blink(); }
		if (Scene == 10) 
		{ 
			 if (GetPosition(Voice) < 600000) { ent_frame ("Kiss",0); my.skin = 1; } else { ent_frame ("stand",0); Talk(); }
		}

		wait(1);
	}
}

action Krupnik
{
	while(1)
	{
		if (Talking == 3) { my.invisible = off; my.shadow = on; Talk(); } else { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action Bracha
{
	my.skill1 = my.z;
	my.z = my.z - 40;

	while(1)
	{
		if (CamShow == 3) { my.invisible = off; } else { my.invisible = on; }

		if (Scene != 10)
		{
			if (Scene == 6) { if (my.z < my.skill1) { my.z = my.z + 1 * time; } }
			if (Scene > 6) { my.z = my.skill1; }
			if (Talking == 4) { Talk(); } else { Blink(); }
		}

		if (Scene == 10)
		{
			ent_frame ("stand",0);

			if (my.skin != 12) { my.skin = 8; }

			while (my.skin < 12)
			{
				my.skill2 = my.skill2 + 1 * time;
				if (my.skill2 > 10) { my.skin = my.skin + 1; my.skill2 = 0; }
				wait(1);
			}
		} 
			
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.wav"); Talking = 0; }
	if (Scene == 1) { sPlay ("OLY009.WAV"); Talking = 0; }
	if (Scene == 2) { sPlay ("YCH010.WAV"); Talking = 2; }
	if (Scene == 3) { sPlay ("YCH011.WAV"); Talking = 2; }
	if (Scene == 4) { DoDialog (31); }
	if (Scene == 5) { sPlay ("YCH013.WAV"); Talking = 2; }
	if (Scene == 6) { CamShow = 3; sPlay ("YCH014.WAV"); Talking = 2; }
	if (Scene == 7) { sPlay ("BRA026.WAV"); Talking = 4; }
	if (Scene == 8) { sPlay ("YCH015.WAV"); Talking = 2; }
	if (Scene == 9) { sPlay ("BRA027.WAV"); Talking = 4; }
	if (Scene ==10) { sPlay ("YCH016.WAV"); Talking = 2; }
	if (Scene ==11) { Run ("Intro6.exe"); }
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
