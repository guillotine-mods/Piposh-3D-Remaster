include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro12.WMB>);

	VoiceInit();
	Initialize();

	SetVoice();
}

action Cam
{
	wait(1);

	while(1)
	{
		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }
		
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.tilt = my.tilt;
		camera.pan = my.pan;
		camera.roll = my.roll;

		wait(1);
	}
}

action Rogale
{
	while(1)
	{
		if (Scene == 2)
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
		if ((Scene == 1) || (Scene == 3))
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
	while(1)
	{
		my.skill1 = my.skill1 + 1 * time;
		if (my.skill1 > 20) { my.skin = my.skin + 1; my.skill1 = 0; if my.skin > 9 { my.skin = 1; } }
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
	if (Scene == 0)  { sPlay ("Wait.wav"); }
	if (Scene == 1)  { sPlay ("NAN014.WAV"); }
	if (Scene == 2)  { sPlay ("ROG009.WAV"); }
	if (Scene == 3)  { sPlay ("NAN015.WAV"); }
	if (Scene == 4)  { Run ("AfterRac.exe"); }
}