include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var RunNow = 1;
var Scene = 0;
var CamShow = 0;
var Pics[17];

bmap bSid = <sid.pcx>;
bmap bCrack = <broke.pcx>;
bmap bEnd = <FIN.pcx>;

panel pCrack
{
	bmap = bCrack;
	layer = 3;
	flags = overlay, refresh, d3d;
}

panel pSid
{
	pos_y = -480;
	bmap = bSid;
	layer = 2;
	flags = overlay, transparent, refresh, d3d;
}

panel pEnd
{
	bmap = bEnd;
	layer = 20;
	flags = refresh,d3d;
}


sound GlassBreak = <SFX098.WAV>;
sound sSid = <SFX104.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	level_load("Ending.wmb");

	VoiceInit();
	Initialize();

	on_space = null;

	sPlay ("Wait.wav");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("SHK066.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("SHK067.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 1;
	while (Scene == 1) { wait(1); }
	sPlay ("KRP024.WAV"); on_space = FF;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 3;
	while (Scene != 5) { wait(1); }
	play_sound (sSid,100);
	sPlay ("PIP444.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 6;
	sPlay ("KRP025.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 5;
	sPlay ("PIP445.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 6;
	sPlay ("KRP026.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("KRP027.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 7;
	sPlay ("GRD001.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 8;
	sPlay ("YCH020.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("SHK068.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	while (Scene != 9) { wait(1); }
	sPlay ("KRP028.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 10;
	sPlay ("GRD002.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	pEnd.visible = on;
	waitt (32);

	Run ("Outro.exe");
}

action Vase
{
	my.invisible = on;
	my.shadow = off;
}

action Picture
{
	my.invisible = on;
	my.ambient = 50;
	my.skill1 = 1;

	while (my.skill1 == 1)
	{
		my.skin = int(random(16)) + 1;
		if (Pics[my.skin] == 0) { Pics[my.skin] = 1; my.skill1 = 0; }
		wait(1);
	}

	my.invisible = off;

}

action Sold
{
	while(1)
	{
		ent_frame ("Stand",int(random(100)));
		waitt(int(random(32)));
	}
}

action Cam
{
	my.skill22 = my.y;
	my.y = my.y - 800;

	while(Scene <= 8)
	{
		my.skill2 = my.skill2 - 1 * time;
		if (my.skill2 < 0) { CamShow = int(random(3)); my.skill2 = random(200) + 150; }

		if ((Scene == 0) || (Scene > 6)) { CamShow = 0; }
		if (my.y < my.skill22) { my.y = my.y + 3 * time; }

		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
		}

		if (Scene > 6)
		{
			my.y = my.y + 0.5 * time;
			if (my.skill12 < 180) { my.z = my.z - 1 * time; my.pan = my.pan - 6 * time; my.skill12 = my.skill12 + 6 * time; }
		}

		wait(1);
	}
}

action LastCam
{
	while(1)
	{
		if (Scene > 8)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;

			my.y = my.y - 1 * time;
		}

		wait(1);
	}
}

action PiposhRun
{
	my.skill40 = my.pan;

	while(1)
	{
		if (RunNow == my.skill1)
		{
			if (my.flag2 == on) { Talk(); }
			my.invisible = off; my.shadow = on;
			my.x = my.x + (20 * my.skill2) * time; 
			ent_cycle ("Run",my.skill3);
			my.skill3 = my.skill3 + 10 * time;
			my.skill4 = my.skill4 + 1 * time;
			if ((my.skill4 > 100) && (my.flag4 == off)) { RunNow = RunNow + 1; }

			if ((my.flag1 == on) && (my.skill4 > 10))
			{
				my.x = my.x - (20 * my.skill2) * time;
				ent_frame ("Hide",my.skill20);
				my.skill20 = my.skill20 + 7 * time;
			}

			if (my.flag3 == on)
			{
				my.skill5 = my.skill5 + 1 * time;
				if (my.skill5 > 120) { my.pan = my.skill40; }
				else
				{
					if (my.skill5 > 70) { ent_frame ("Stand",0); my.x = my.x - (20 * my.skill2) * time; my.pan = my.skill40 - 180; }
					else
					{
						if (my.skill5 > 50) { ent_frame ("Stand",0); my.x = my.x - (20 * my.skill2) * time; my.pan = my.skill40 - 90; }
					}
				}
			}

		}
		else { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action Krupnik
{
	my.skill1 = my.z;
	my.z = my.z - 150;
	my.skill2 = my.pan;

	while(1)
	{
		if (Scene < 5)
		{
			if (Scene == 1)
			{
				if (my.z < my.skill1) { my.z = my.z + 6 * time; } else { Scene = 2; }
			}

			if (Scene == 2)
			{
				Talk();			
				my.pan = my.skill2 - 90;
			}

			if (Scene == 3)
			{
				my.pan = my.skill2;
				morph (<KRP.mdl>,my);
				Scene = 4;
			}

			if (Scene == 4)
			{
				ent_frame ("Spill",my.skill20);
				my.skill20 = my.skill20 + 15 * time;
				if (my.skill20 > 100) { my.pan = my.skill2 - 90; morph (<Krupnik.mdl>,my); ent_frame ("Stand",0); Scene = 5; }
			}
		}

		else
		{
			if (Scene == 6) { Talk(); } else { ent_frame ("Stand",0); Blink(); }
		}

		wait(1);
	}
}

action Krupnik2
{
	while(1)
	{
		if (Scene == 9) { Talk(); } else { ent_frame ("Stand",0); Blink(); }
		wait(1);
	}
}

action Yach
{
	while(1)
	{
		if (Scene == 8)
		{
			my.y = my.y + 10 * time;
			ent_cycle ("Run",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			if (my.flag1 == on) { Talk(); }

			if (my.y > camera.y - 200) { if (my.flag1 == off) { my.invisible = on; my.shadow = off; } }

			if ((my.y > camera.y - 70) && (my.flag1 == on))
			{
				pCrack.visible = on;
				if (my.skill40 == 0) { play_sound (GlassBreak,100); my.skill40 = 1; }
				my.y = my.y - 10 * time;
				my.skill11 = my.skill11 + 1 * time;
				ent_frame ("Stand",0);
				if (my.skill11 < 10) { camera.z = camera.z + ((int(random(3)) - 1) * 20) * time; }
				else
				{
					pSid.visible = on;
					my.z = my.z - 5 * time;

					pSid.pos_y = pSid.pos_y + 9 * time;
					if (pSid.pos_y >= 0) { pSid.visible = off; Scene = 9; }
				}
			}
		}

		wait(1);
	}
}

action PipSid
{
	while(1)
	{
		if (Scene == 5) { my.invisible = off; my.shadow = on; Talk(); } else { ent_frame ("Stand",0); Blink(); }
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { ent_frame ("Talk",int(random(6)) * 20); }
}

function Blink()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}