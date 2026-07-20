include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = -1;
var CamMark = 1;
var CamDelay = 50;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro7.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action Cam
{
	SetVoice();

	while(1)
	{
		if (Scene > 1) { CamDelay = CamDelay - 1 * time; }
		if ((CamDelay < 0) && (int(random(100)) == 50)) { if (CamMark == 1) { CamMark = 2; } else { CamMark = 1; } CamDelay = random(50) + 20; }
		if (Scene == 10) { Run ("Intro5.exe"); }
		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }
		
		if (CamMark == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.pan = my.pan;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

action Rogale
{
	while(1)
	{
		if ((Scene == 1) || (Scene == 7) || (Scene == 9))
		{
			if (int(random(40)) == 20) { ent_frame ("Talk",int(random(5)) * 25); }	
			my.skill11 = my.skill11 + 1 * time;
			if (my.skill11 > 1.5) { my.skin = int(random(7))+1; my.skill11 = 0; }
		}
		else
		{
			Blink();
			ent_cycle ("Stand",my.skill13);
			my.skill13 = my.skill13 + 5 * time;
		}

		wait(1);
	}
}

action Nanny
{
	while(1)
	{
		if (Scene == 8) { my.pan = 233; }
		if ((Scene == 2) || (Scene == 4) || (Scene == 6) || (Scene == 8))
		{
			if (int(random(20)) == 10) { ent_frame ("Pleed",int(random(6)) * 20); }
			my.skill11 = my.skill11 + 1 * time;
			if (my.skill11 > 1.5) { my.skin = int(random(7))+1; my.skill11 = 0; }
		}
		else
		{
			ent_frame ("Pleed",0);
			Blink();
		}

		wait(1);
	}
}

action AltiMan
{
	while(1)
	{
		if ((Scene == 3) || (Scene == 5))
		{
			if (int(random(20)) == 10) { ent_frame ("Talk",int(random(5)) * 25); }
			my.skill11 = my.skill11 + 1 * time;
			if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
		}
		else
		{
			ent_frame ("Talk",0);
			Blink();
		}

		wait(1);
	}
}

ACTION FlickerLight 
{
	SET MY.INVISIBLE,ON;

	SET MY.LIGHTRED,0;
	SET MY.LIGHTGREEN,0;
	SET MY.LIGHTBLUE,128;

		WHILE (Scene == 0) {
			MY.LIGHTRANGE = RANDOM (200)+150;
			WAITT 4;
		}
		my.lightrange = 0;
} 

action TV
{
	my.skill2 = 10;

	while(1)
	{
		my.skill1 = my.skill1 + 1 * time;
		if (Scene == 0) { if (my.skill1 > 2) { my.skin = my.skin + 1; if my.skin > 10 { my.skin = 1; } } }
		else
		{
			if (my.skill2 < 17)
			{
				if (my.skill1 > 2) { my.skill2 = my.skill2 + 1; my.skin = my.skill2; }
			}
		}

		wait(1);
	}
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

function SetVoice
{
	if (Scene == -1) { sPlay ("Wait.wav"); }
	if (Scene == 0)  { sPlay ("TEL001.WAV"); }
	if (Scene == 1)  { sPlay ("ROG005.WAV"); }
	if (Scene == 2)  { sPlay ("NAN008.WAV"); }
	if (Scene == 3)  { sPlay ("ALT001.WAV"); }
	if (Scene == 4)  { sPlay ("NAN009.WAV"); }
	if (Scene == 5)  { sPlay ("ALT002.WAV"); }
	if (Scene == 6)  { sPlay ("NAN010.WAV"); }
	if (Scene == 7)  { sPlay ("ROG006.WAV"); }
	if (Scene == 8)  { sPlay ("NAN011.WAV"); }
	if (Scene == 9)  { sPlay ("ROG007.WAV"); }
}