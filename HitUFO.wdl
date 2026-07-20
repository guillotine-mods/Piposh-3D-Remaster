include <IO.wdl>;

bmap bPigs = <pigs.pcx>;
bmap bBar = <pigsbar.pcx>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Dir;
var Stop;
var Level = 200;
var UFOLeft = 30;
var TimeLeft = 0;
var Dying = 0;

define Timer,skill27;
define Delay,skill28;
define Kind,skill29;
define OriginalZ,skill30;

var GameOverDelay = 50;
var CONSTNONE = 0;
var CONSTUFO =  1;
var CONSTNOT =  2;

bmap YouLose = <YouLose.bmp>;

panel pWinLose
{
	bmap = YouLose;
	layer = 10;
	pos_x = 150;
	pos_y = 150;
	flags = refresh,d3d,overlay;
}

text txtEXIT
{
	string = "SHUME VA XJJOLF ENFKMB IFPBL JDK esc [HL";
	layer = 20;
	font = standard_font;
	pos_x = 10;
	pos_y = 470;
	flags = visible;
}

panel pTimeLeft
{
	bmap = bPigs;
	window 287,18,316,16,bBar,TimeLeft,0;
	digits 193,25,2,standard_font,1,UFOLeft;
	flags = refresh,visible;
}

sound BGMusic = <SNG030.WAV>;
sound HammerHit = <SFX135.WAV>;

synonym Hammer { type entity; }

var BGM;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	level_load("HitUFO.WMB");

	VoiceInit();
	Initialize();

	Dir = 0;
	Level = 200;
	UFOLeft = 30;
	TimeLeft = 0;
	Dying = 0;
	GameOverDelay = 5;

	pWinLose.visible = off;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	stop_sound (BGM);
	play_loop (BGMusic,50);
	BGM = result;
}

action Cam
{
	while(1)
	{
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.tilt = my.tilt;
		camera.roll = my.roll;

		wait(1);
	}
}

action HitMeNow
{
	Hammer.invisible = off;
	Hammer.x = my.x;
	Hammer.y = my.y;
	waitt(3);
	hammer.invisible = on;
}

function CheckHit
{
	if (Dir == my.skill20) 
	{ 
		my.z = my.OriginalZ; 

		if (my.Kind == CONSTUFO) 
		{
			my.skill31 = int(random(7)) + 1;
			if (my.skill31 == 1) { sPlay ("UFO001.WAV"); }
			if (my.skill31 == 2) { sPlay ("UFO002.WAV"); }
			if (my.skill31 == 3) { sPlay ("UFO003.WAV"); }
			if (my.skill31 == 4) { sPlay ("UFO004.WAV"); }
			if (my.skill31 == 5) { sPlay ("UFO005.WAV"); }
			if (my.skill31 == 6) { sPlay ("UFO006.WAV"); }
			if (my.skill31 == 7) { sPlay ("UFO007.WAV"); }

			Level = Level - 10; 
			UFOLeft = UFOLeft - 1;

			if (UFOLeft <= 0) 
			{ 
				AFG[22] = 1;
				AFG_Show.skin = 22;

				AFG_Show.tilt = random(20) - 10;

				AFG_Show.visible = on;
				AFG_Show.alpha = 100;

				waitt (60);

				AFG_Show.transparent = on;
	
				while(AFG_Show.alpha > 3) { AFG_Show.alpha = AFG_Show.alpha - 3 * time; wait(1); }

				AFG_Show.alpha = 0;
				AFG_Show.visible = off;

				Run ("MOI.exe");
			}
		} 
		else 
		{ 
			if (my.Kind == CONSTNOT)
			{
				my.skill30 = int(random(3)) + 1;
				if (my.skill30 == 1) { sPlay ("PIG001.WAV"); }
				if (my.skill30 == 2) { sPlay ("PIG002.WAV"); }
				if (my.skill30 == 3) { sPlay ("PIG003.WAV"); }
				while (GetPosition (Voice) < 1000000) { Dying = 1; Stop = 1; wait(1); } TimeLeft = 316;
			}
		}

		my.Timer = -100;
	}
}

action HitMe
{
	my.z = my.z - 120;
	my.OriginalZ = my.z;
	my.skill3 = -100;
	my.skill2 = 4;

	while (1)
	{
		if (pWinLose.visible == on) 
		{ 
			my.invisible = on; 
			txtEXIT.string = "VARL JDK esc FA BFU SHUL JDK enter LP [HL";
		} 
		else 
		{ 
			my.invisible = off; 
			txtEXIT.string = "SHUME VA XJJOLF ENFKMB IFPBL JDK esc [HL";
		}

		if ((int(random(20)) == 10) && (my.Kind == CONSTNONE) && (Dir != my.skill20))
		{
			my.skill2 = int(random(4));
			if (my.skill2 == 0) { morph (<Farm1.mdl>,my); my.Kind = CONSTNOT; }
			if (my.skill2 == 1) { morph (<Farm2.mdl>,my); my.Kind = CONSTNOT; }
			if (my.skill2 == 2) { morph (<Farm3.mdl>,my); my.Kind = CONSTNOT; }
			if (my.skill2 == 3) { morph (<UFO.mdl>,my); my.Kind = CONSTUFO; }

			my.Delay = 0;
			my.Timer = 120;
		}

		if (my.Timer > 0) { my.z = my.z + 10 * time; my.Timer = my.Timer - 10 * time; CheckHit(); }

		if ((my.Timer <= 0) && (my.OriginalZ < my.z)) 
		{ 
			if (my.Timer != -100)
			{
				if (my.Kind != CONSTNONE) { CheckHit(); }
				my.Delay = my.Delay + 1 * time; 

				if (my.Delay > Level / 10) 
				{ 
					my.z = my.z - 10 * time; 
					if (my.z <= my.OriginalZ) { my.Kind = CONSTNONE; my.Timer = -100; my.z = my.OriginalZ; }
				}
			}

			if (my.Timer == -100) { my.Kind = CONSTNONE; my.Timer = 0; }
		}

		wait(1);
	}
}

function tDown  { if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 1; Stop = 0; } } }
function tUp 	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 2; Stop = 0; } } }
function tRight	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 3; Stop = 0; } } }
function tLeft  { if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 4; Stop = 0; } } }
function tLU	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 5; Stop = 0; } } }
function tRU	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 6; Stop = 0; } } }
function tRD	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 7; Stop = 0; } } }
function tLD	{ if (Dying == 0) { if (Stop == -1) { play_sound (HammerHit,100); Dir = 8; Stop = 0; } } }

on_cud = tDown();
on_cuu = tUp();
on_cur = tRight();
on_cul = tLeft();
on_home = tLU();
on_pgup = tRU();
on_pgdn = tRD();
on_end = tLD();

action Mallet
{
	Stop = -1;

	while(1)
	{
		if (my.skill40 > 0) { my.skill40 = my.skill40 - 1 * time; }
		if (my.skill40 <= 0)
		{
			my.skin = 1;
			if (int(random(100)) == 50) { my.skin = 2; my.skill40 = 3; }
		}

		TimeLeft = TimeLeft + 0.5 * time;

		if (TimeLeft >= 316) { pWinLose.visible = on; }
		if (Stop != -1) { Stop = Stop + 1 * time; }

		if (Dir == 0) { ent_frame ("Standby",0); }
		if (Dir == 1) { ent_frame ("7",0); }	// Down Center
		if (Dir == 2) { ent_frame ("2",0); }	// Up Center
		if (Dir == 3) { ent_frame ("5",0); }	// Center Right
		if (Dir == 4) { ent_frame ("4",0); }	// Center Left
		if (Dir == 5) { ent_frame ("1",0); }	// Up Left
		if (Dir == 6) { ent_frame ("3",0); }	// Up Right
		if (Dir == 7) { ent_frame ("8",0); }	// Down Right
		if (Dir == 8) { ent_frame ("6",0); }	// Down Left

		if (Stop > 3) { Dir = 0; Stop = -1; }

		waitt(1);
	}
}

action Dummy
{
	return;
	my.lightblue = random(255);
	my.lightred = random(255);
	my.lightgreen = random(255);
	my.lightrange = 500;

	while(1)
	{
		my.lightrange = my.lightrange + (random(3) - 1) * 5;

		if (my.lightrange > 1000) { my.lightrange = 1000; }
		if (my.lightrange < 0) { my.lightrange = 0; }

		wait(1);
	}
}

action Dummy2
{
	return;
	my.lightblue = 255;
	my.lightred = 0;
	my.lightgreen = 0;
	my.lightrange = 3000;

	while(1)
	{
		TimeLeft = TimeLeft + 1;
		my.lightrange = my.lightrange - 1;
		waitt(3);

		if (TimeLeft >= 316) 
		{ 
			pWinLose.visible = on;
		}
	}
}

function Again
{
	if (pWinLose.visible == on)
	{
		if (AFG_Show.visible == off) { main(); } 
	}
}

function quitUFO
{
	Run ("MOI.exe");
}

on_enter = Again();
on_esc = quitUFO();