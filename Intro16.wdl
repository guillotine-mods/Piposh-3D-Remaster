include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var Talking = 0;
var CamShow = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	fog_color = 1;
	camera.fog = 30;
	vNoSave = 1;

	level_load("Intro16.wmb");

	lensflare_start();

	VoiceInit();
	Initialize();
}

action footprnt
{
	my.transparent = on;
	my.alpha = 100;

	while(1)
	{
		if (Scene == 4) { my.alpha = my.alpha - 0.7 * time; }
		wait(1);
	}
}

action Cam
{
	SetVoice();

	while(1)
	{
		if (CamShow == my.skill1)
		{
			if ((GetPosition(Voice) >= 1000000) && (Scene != 11)) { Scene = Scene + 1; SetVoice(); }

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
		}

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 24)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP205.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("SHK035.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogChoice = 0; DialogIndex = 0; Scene = 12; SetVoice();
			}
	
			if (DialogChoice == 2) 
			{
				sPlay ("PIP206.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("SHK036.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogChoice = 0; DialogIndex = 0; Scene = 12; SetVoice();
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP207.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("SHK037.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogChoice = 0; DialogIndex = 0; Scene = 12; SetVoice();
			}

			wait(1);
		}

		wait(1);
	}
}

action B1
{
	while(1)
	{
		if (Talking == 1) { Talk(); } else { Blink(); }
		if (Scene == 6) { ent_frame ("Duh",0); }
		wait(1);
	}
}

action B2
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		if (Scene == 4) { ent_cycle ("Wipe",my.skill1); my.skill1 = my.skill1 + 10 * time; }
		if (Scene > 4) { ent_frame ("WTalk",0); }

		wait(1);
	}
}

action B3
{
	while(1)
	{
		if (Talking == 3) { Talk2(); } else { my.skin = 1; }
		if (Scene == 1) { ent_frame ("Wrong",0); }
		if (Scene == 2) { ent_frame ("Look",0); }
		if (Scene == 3) { ent_frame ("Right",0); }

		wait(1);
	}
}

action B4
{
	while(1)
	{
		if (Talking == 4) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action B5
{
	my.skill1 = my.x;
	my.x = my.x - 50;

	while(1)
	{
		if (Talking == 5) 
		{ 
			my.invisible = off;
			my.shadow = on;

			if (my.x < my.skill1) 
			{ 
				Talk2(); 
				my.x = my.x + 2 * time; 
				ent_cycle ("Walk",my.skill2); 
				my.skill2 = my.skill2 + 8 * time; 
			} 
			else 
			{
				Talk();
				vec_set(temp,camera.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
			}
		}
		else { Blink(); }

		if (Scene == 9) { if (my.skill40 == 0) { morph (<PipCell.mdl>,my); my.skill40 = 1; } ent_frame ("Dial",0); }
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } 
	else { ent_frame ("Talk",int(random(5)) * 25); } }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

function Blink()
{
	ent_frame ("Stand",0);
	if (my.skill12 > 0) { my.skill12 = my.skill12 - 1 * time; }
	if (my.skill12 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill12 = 5; }
	}

}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

function SetVoice
{
	if (Scene == -1) { sPlay ("Wait.wav"); }
	if (Scene == 0) { CamShow = 1; Talking = 1; sPlay ("MAR024.WAV"); }
	if (Scene == 1) { CamShow = 2; Talking = 3; sPlay ("NAN012.WAV"); }
	if (Scene == 2) { CamShow = 2; Talking = 4; sPlay ("ROG008.WAV"); }
	if (Scene == 3) { CamShow = 2; Talking = 3; sPlay ("NAN013.WAV"); }
	if (Scene == 4) { CamShow = 3; Talking = 3; sPlay ("MAR025.WAV"); }
	if (Scene == 5) { CamShow = 3; Talking = 2; sPlay ("KVC027.WAV"); }
	if (Scene == 6) { CamShow = 3; Talking = 1; sPlay ("MAR026.WAV"); }
	if (Scene == 7) { CamShow = 4; Talking = 5; sPlay ("PIP203.WAV"); }
	if (Scene == 8) { CamShow = 4; Talking = 0; if (int(random(2)) == 1) { sPlay ("Ring01.WAV"); } else { sPlay ("Ring02.WAV"); } }
	if (Scene == 9) { CamShow = 4; Talking = 5; sPlay ("PIP204.WAV"); }
	if (Scene ==10) { CamShow = 4; Talking = 0; sPlay ("SHK034.WAV"); }
	if (Scene ==11) { DoDialog (24); }
	if (Scene ==12) 
	{ 
		Flag_First_Olympic = 1;
		WriteGameData (0);
		Run ("Olympic.exe"); 
	}
}