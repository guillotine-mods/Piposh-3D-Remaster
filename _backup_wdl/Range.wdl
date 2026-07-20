include <IO.wdl>;

var SEN = 3;
var SND;
var NumTries = 0;

sound INO1 = <INO001.WAV>;
sound INO2 = <INO002.WAV>;
sound INO3 = <INO003.WAV>;
sound INO4 = <INO004.WAV>;
sound INO5 = <INO005.WAV>;
sound INO6 = <INO006.WAV>;
sound INO7 = <INO007.WAV>;
sound INO8 = <INO008.WAV>;
sound INO9 = <INO009.WAV>;
sound INO0 = <INO010.WAV>;

sound ARB1 = <ARB001.WAV>;
sound ARB2 = <ARB002.WAV>;
sound ARB3 = <ARB003.WAV>;
sound ARB4 = <ARB004.WAV>;
sound ARB5 = <ARB005.WAV>;
sound ARB6 = <ARB006.WAV>;

sound STU1 = <STU003.WAV>;
sound STU2 = <STU004.WAV>;
sound STU3 = <STU005.WAV>;
sound STU4 = <STU006.WAV>;
sound STU5 = <STU007.WAV>;

sound GlassBreak = <SFX098.WAV>;
sound Jet = <SFX091.WAV>;
sound TVS = <SFX096.WAV>;

var STU = 0;
var Done = 0;

DEFINE muzzle_flash,<Fire.bmp>;

define Pop,skill20;
define Delay,skill21;
define Dying,skill22;
define OriginalZ,skill23;
define GoingUp,skill24;
define Type,skill25;
define Base,skill26;

var SkyTilt = 0;

var Health = 609;
var Health2 = 0;

var Terrorists = 20;
var Civilians = 5;

var cheat1 = 0;
var cheat2 = 0;
var cheat3 = 0;

string cheatstring = "";

var True = 1;
var False = 0;
var DEFAULT_DELAY = 10;
var Rapidness;
var DMG = 20;

var typeTerrorist = 1;
var typeCivilian = 2;

var MoviePlaying = 1;
var Death = 0;

bmap bTerr = <Hit1.pcx>;
bmap bTerrHit = <Hit2.pcx>;
bmap bCiv = <Hit3.pcx>;
bmap bCivHit = <Hit4.pcx>;
bmap bPanel = <Hit5.pcx>;
bmap bPass = <pass.pcx>;

bmap bSkip = <Skip.pcx>;

bmap bCongrat = <afri1.pcx>;

panel pCongrat
{
	bmap = bCongrat;
	pos_x = 200;
	pos_y = 70;
	layer = 4;
	flags = refresh,d3d;

	button = 0, 0, bCongrat, bCongrat, bCongrat, C1, null, null;
}

panel pSkip
{
	bmap = bSkip;
	flags = overlay,d3d,refresh;
	pos_x = 600;
	pos_y = 440;
	button = 0, 0, bSkip, bSkip, bSkip, D1, null, null;
}

function C1 { pCongrat.visible = off; }
function D1 { sPlay ("SFX138.WAV"); while (GetPosition (Voice) < 1000000) { wait(1); } Run ("Plane3.exe"); }

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var FireLength = 0;

panel GUI 
{
	bmap = bPanel;
	pos_x = 0;
	pos_y = 0;
	layer = 1;

	window 15,58,609,15,bpass,health2,0;

	flags = refresh,d3d,overlay;
}

panel Civ1   { bmap = bCiv ; pos_x = 430; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Civ2   { bmap = bCiv ; pos_x = 460; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Civ3   { bmap = bCiv ; pos_x = 490; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Civ4   { bmap = bCiv ; pos_x = 520; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Civ5   { bmap = bCiv ; pos_x = 550; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }

panel Terr1  { bmap = bTerr; pos_x = 10 ; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr2  { bmap = bTerr; pos_x = 40 ; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr3  { bmap = bTerr; pos_x = 70 ; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr4  { bmap = bTerr; pos_x = 100; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr5  { bmap = bTerr; pos_x = 130; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr6  { bmap = bTerr; pos_x = 160; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr7  { bmap = bTerr; pos_x = 190; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr8  { bmap = bTerr; pos_x = 220; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr9  { bmap = bTerr; pos_x = 250; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }
panel Terr10 { bmap = bTerr; pos_x = 280; pos_y = 0; flags = d3d,refresh,overlay; layer = 2;  }

panel Terr11 { bmap = bTerr; pos_x = 25 ; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
panel Terr12 { bmap = bTerr; pos_x = 55 ; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
panel Terr13 { bmap = bTerr; pos_x = 85 ; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
panel Terr14 { bmap = bTerr; pos_x = 115; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
panel Terr15 { bmap = bTerr; pos_x = 145; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
//panel Terr16 { bmap = bTerr; pos_x = 175; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
//panel Terr17 { bmap = bTerr; pos_x = 205; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
//panel Terr18 { bmap = bTerr; pos_x = 235; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
//panel Terr19 { bmap = bTerr; pos_x = 265; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }
//panel Terr20 { bmap = bTerr; pos_x = 295; pos_y = 15; flags = d3d,refresh,overlay; layer = 3; }

function ResetPanel
{
	Terr1.bmap = bTerr;
	Terr2.bmap = bTerr;
	Terr3.bmap = bTerr;
	Terr4.bmap = bTerr;
	Terr5.bmap = bTerr;
	Terr6.bmap = bTerr;
	Terr7.bmap = bTerr;
	Terr8.bmap = bTerr;
	Terr9.bmap = bTerr;
	Terr10.bmap = bTerr;
	Terr11.bmap = bTerr;
	Terr12.bmap = bTerr;
	Terr13.bmap = bTerr;
	Terr14.bmap = bTerr;
	Terr15.bmap = bTerr;
//	Terr16.bmap = bTerr;
//	Terr17.bmap = bTerr;
//	Terr18.bmap = bTerr;
//	Terr19.bmap = bTerr;
//	Terr20.bmap = bTerr;

	Civ1.bmap = bCiv;
	Civ2.bmap = bCiv;
	Civ3.bmap = bCiv;
	Civ4.bmap = bCiv;
	Civ5.bmap = bCiv;
}

function UpdatePanel
{
//	if (Terrorists < 20) { Terr20.bmap = bTerrHit; }
//	if (Terrorists < 19) { Terr19.bmap = bTerrHit; }
//	if (Terrorists < 18) { Terr18.bmap = bTerrHit; }
//	if (Terrorists < 17) { Terr17.bmap = bTerrHit; }
//	if (Terrorists < 16) { Terr16.bmap = bTerrHit; }
	if (Terrorists < 15) { Terr15.bmap = bTerrHit; }
	if (Terrorists < 14) { Terr14.bmap = bTerrHit; }
	if (Terrorists < 13) { Terr13.bmap = bTerrHit; }
	if (Terrorists < 12) { Terr12.bmap = bTerrHit; }
	if (Terrorists < 11) { Terr11.bmap = bTerrHit; }
	if (Terrorists < 10) { Terr10.bmap = bTerrHit; }
	if (Terrorists < 9)  { Terr9.bmap  = bTerrHit; }
	if (Terrorists < 8)  { Terr8.bmap  = bTerrHit; }
	if (Terrorists < 7)  { Terr7.bmap  = bTerrHit; }
	if (Terrorists < 6)  { Terr6.bmap  = bTerrHit; }
	if (Terrorists < 5)  { Terr5.bmap  = bTerrHit; }
	if (Terrorists < 4)  { Terr4.bmap  = bTerrHit; }
	if (Terrorists < 3)  { Terr3.bmap  = bTerrHit; }
	if (Terrorists < 2)  { Terr2.bmap  = bTerrHit; }
	if (Terrorists < 1)  
	{ 
		Terr1.bmap  = bTerrHit; 

		if (Done == 0) { Done = 1; sPlay ("SFX138.WAV"); while (GetPosition (Voice) < 1000000) { wait(1); } }

		if (Civilians == 5) { pCongrat.visible = on; }
		while (pCongrat.visible == on) { wait(1); }

		Run ("Plane3.exe");
	}

	if (Civilians < 5)   { Civ5.bmap = bCivHit; }
	if (Civilians < 4)   { Civ4.bmap = bCivHit; }
	if (Civilians < 3)   { Civ3.bmap = bCivHit; }
	if (Civilians < 2)   { Civ2.bmap = bCivHit; }
	if (Civilians < 1)   { Civ1.bmap = bCivHit; Restart(); }

	Health2 = 609 - Health;

	if (Health <= 0) { Restart(); }
}

function ShowPanel
{
	GUI.visible = on;
	Terr1.visible = on;
	Terr2.visible = on;
	Terr3.visible = on;
	Terr4.visible = on;
	Terr5.visible = on;
	Terr6.visible = on;
	Terr7.visible = on;
	Terr8.visible = on;
	Terr9.visible = on;
	Terr10.visible = on;
	Terr11.visible = on;
	Terr12.visible = on;
	Terr13.visible = on;
	Terr14.visible = on;
	Terr15.visible = on;
//	Terr16.visible = on;
//	Terr17.visible = on;
//	Terr18.visible = on;
//	Terr19.visible = on;
//	Terr20.visible = on;
	Civ1.visible = on;
	Civ2.visible = on;
	Civ3.visible = on;
	Civ4.visible = on;
	Civ5.visible = on;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	NumTries = NumTries + 1;
	if (NumTries > 3) { pSkip.visible = on; }

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	level_load("Range.wmb");

	VoiceInit();
	Initialize();

	Health = 609;

	Terrorists = 15;	// Fixed: was 20, too many terrorists evidentally
	Civilians = 5;

	Rapidness = 400;

	ResetPanel();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	if (MoviePlaying == 1)
	{
		DoDialog (4);

		while (Dialog.visible == on) { wait(1); }

		while (DialogIndex == 4)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP041.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("KRP010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				DoDialog (4);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP042.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("KRP011.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("PIP043.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("KRP012.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("PIP044.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("KRP013.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Talking = 0; MoviePlaying = 0; ShowPanel(); stop_sound (snd);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP045.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("KRP014.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				DoDialog (4);
			}

			wait(1);
		}
	}
}

action Cam
{
	while (MoviePlaying == 1)
	{
		SkyTilt = (int(random(3)) - 1) * time;
		my.roll = my.roll + SkyTilt;
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.tilt = my.tilt;
		camera.roll = my.roll;
		camera.pan = my.pan;

		wait(1);
	}

	remove (my);
}

action PIP
{
	while (MoviePlaying == 1)
	{
		if (snd_playing (SND) == 0) { play_sound (Jet,30); SND = result; }
		if (Talking == my.skill1) { Talk(); } else { Blink(); }
		wait(1);
	}

	remove (my);
}

action CamTarget
{
	player = my;
	Death = 0;

	while (MoviePlaying == 1) { wait(1); }

	cross_pos.x = -7;
	cross_pos.y = -7;

	pan_cross_show();

	while (1)
	{
		updatepanel();
		if ((snd_playing(STU) == 0) && (int(random(300)) == 150))
		{
			my.skill30 = int(random(5)) + 1;

			if (my.skill30 == 1) { play_entsound (my,STU1,500); STU = result; }
			if (my.skill30 == 2) { play_entsound (my,STU2,500); STU = result; }
			if (my.skill30 == 3) { play_entsound (my,STU3,500); STU = result; }
			if (my.skill30 == 4) { play_entsound (my,STU4,500); STU = result; }
			if (my.skill30 == 5) { play_entsound (my,STU5,500); STU = result; }
		}

		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;

		my.pan = my.pan - mickey.x / SEN;
		my.tilt = my.tilt - mickey.y / SEN;

		if (my.tilt > 45) { my.tilt = 45; }
		if (my.tilt < -15) { my.tilt = -15; }

		SkyTilt = (int(random(3)) - 1) * time;

		if (abs(ang(my.roll)) < 20) { my.roll = my.roll + SkyTilt; }

		camera.pan = my.pan;
		camera.tilt = my.tilt;
		camera.roll = my.roll / SEN;

		wait(1);

	}
}

action Ground
{
	while(1)
	{
		if (MoviePlaying == 0) { if (abs(ang(my.tilt)) < 20) { my.tilt = my.tilt + SkyTilt; } }
		my.v = my.v - 10 * time;
		wait(1);
	}
}

action SkyX
{
	while(1)
	{
		my.u = my.u + 5 * time;
		if (MoviePlaying == 0) { if (abs(ang(my.tilt)) < 20) { my.tilt = my.tilt + SkyTilt; } }
		wait(1);
	}
}

action Handgun
{
	my.invisible = on;
	while (MoviePlaying == 1) { wait(1); }
	my.invisible = off;
	my.near = on;

	while (1)
	{
		if (snd_playing (SND) == 0) { play_sound (Jet,20); SND = result; }

		if (FireLength > 0) 
		{ 
			LightOn(); 
			ent_frame ("Fire",100 - FireLength * 10); 
			FireLength = FireLength - 3 * time; 
		} 
		else 
		{ 
			LightOff(); 
			ent_frame ("Aim",0); 
		}

		my.pan = my.pan - mickey.x / SEN;
		my.roll = my.roll + mickey.y / SEN;

		if (my.roll > 15) { my.roll = 15; }
		if (my.roll < -45) { my.roll = -45; }

		wait(1);
	}
}

function LightOn()
{
	MY.LIGHTRED = 255;
	MY.LIGHtgreen = 255;
	MY.LIGHTBLUE = 0;
	MY.LIGHTRANGE = 200;
	my.unlit = on;
	MY.AMBIENT = 100;
}

function LightOff()
{
	MY.LIGHTRED = 0;
	MY.LIGHTGREEN = 0;
	MY.LIGHTBLUE = 0;
	MY.LIGHTRANGE = 0;
	my.unlit = off;
	MY.AMBIENT = 100;
}


on_mouse_left = Fire;

action Fire
{
	if (MoviePlaying == 0)
	{
		if (FireLength <= 0)
		{
			FireLength = 10;
			CreateSpark();
		}
	}
}

ACTION SparkHit
{
	if(EVENT_TYPE != EVENT_ENTITY) { create(bullethole_map,my.x,bullet_hole); }

	remove (me);
}

ACTION Spark
{
	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale

	MY.ENABLE_BLOCK = ON;
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_STUCK = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = SparkHit;

	MY.FACING = ON;	// in case of fireball

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;

	my.skill20 = player.pan;
	my.skill21 = player.tilt;
	my.skill22 = player.roll;

  	// my.near is set by the explosion
	while(MY.NEAR != ON)
	{
		wait(1); // wait at the loop beginning, to let it appear at the start position

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
		// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		move(ME,nullskill,fireball_speed);

		my.pan = my.skill20;
		my.tilt = my.skill21;
		my.roll = my.skill22;

	}
}


function CreateSpark
{
	shot_speed.x = 200;
	shot_speed.y = 0;
	shot_speed.z = 0;
	my_angle.pan = player.pan;
	my_angle.tilt = player.tilt;
	my_angle.roll = player.roll;
	vec_rotate(shot_speed,my_angle);
	
	create(<UziBul.mdl>,player.x,Spark);
	PLAY_SOUND gun_wham,50;
}

function glass_gib(numberOfParts)
{
	temp = 0;
	while(temp < numberOfParts)
	{
		create(<Shard.mdl>, my.pos, _gib_action);
		temp += 1;
	}
}

function spark_gib(numberOfParts)
{
	temp = 0;
	while(temp < numberOfParts)
	{
		create(<fb2.mdl>, my.pos, _gib_action);
		temp += 1;
	}
}

action WindowHit
{
	stop_sound (my.skill40);
	play_entsound (my,glassbreak,2000);
	glass_gib(20);
	remove (my);
}

action Window
{
	my.event = WindowHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	my.invisible = on;

	while (MoviePlaying == 1) { wait(1); }
	
	my.invisible = off;
}

action TV
{
	my.event = WindowHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	while(1)
	{
		if (snd_playing (my.skill40) == 0) { play_entsound (my,TVS,600); my.skill40 = result; }

		my.skill1 = my.skill1 + 1;
		my.skin = my.skin + 1;
		waitt(4);
		if (my.skin > 12) { my.skin = 1; }
		my.skill1 = 0;
		wait(1);
	}
}

action TargetHit
{
	if (my.Pop == True) 
	{
		my.tilt = 20;
		my.roll = -20;

		if (my.Type == typeCivilian)
		{
			if (cheat2 == 0)
			{
				Civilians = Civilians - 1; 
				my.skin = my.base + 2; 
			}

			my.skill30 = int(random(10)) + 1;

			if (my.skill30 == 1) { play_entsound (my,INO1,500); }
			if (my.skill30 == 2) { play_entsound (my,INO2,500); }
			if (my.skill30 == 3) { play_entsound (my,INO3,500); }
			if (my.skill30 == 4) { play_entsound (my,INO4,500); }
			if (my.skill30 == 5) { play_entsound (my,INO5,500); }
			if (my.skill30 == 6) { play_entsound (my,INO6,500); }
			if (my.skill30 == 7) { play_entsound (my,INO7,500); }
			if (my.skill30 == 8) { play_entsound (my,INO8,500); }
			if (my.skill30 == 9) { play_entsound (my,INO9,500); }
			if (my.skill30 ==10) { play_entsound (my,INO0,500); }
		} 
		else 
		{ 
			Terrorists = Terrorists - 1; 
			Rapidness = Terrorists * 20; 
			my.skin = my.base + 2; 

			my.skill30 = int(random(6)) + 1;

			if (my.skill30 == 1) { play_entsound (my,ARB1,500); }
			if (my.skill30 == 2) { play_entsound (my,ARB2,500); }
			if (my.skill30 == 3) { play_entsound (my,ARB3,500); }
			if (my.skill30 == 4) { play_entsound (my,ARB4,500); }
			if (my.skill30 == 5) { play_entsound (my,ARB5,500); }
			if (my.skill30 == 6) { play_entsound (my,ARB6,500); }
		}

		my.Dying = True; 
		my.Pop = False;

		if (cheat3 == 1) { _gib(20); actor_explode(); }
	}
}

action Terrorist
{
	my.event = TargetHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.OriginalZ = my.z;
	my.Type = typeCivilian;

	my.Pop = False;

	while (MoviePlaying == 1) { wait(1); }

	while(1)
	{
		if (my.dying == False) { my.skin = my.Base; }

		if (my.Dying == True)
		{
			my.passable = on;
			my.z = my.z - 5 * time; 
			if (my.z < my.OriginalZ) { my.z = my.OriginalZ; my.Pop = False; my.Dying = False; }
		}

		if (my.GoingUp == True)
		{
			my.tilt = 0;
			my.roll = 0;
			my.passable = off;
			my.z = my.z + 10 * time;
			if (my.z > (my.OriginalZ + 60)) { my.GoingUp = False; }
		}

		if ((int(random(Rapidness)) == int(Rapidness / 2)) && (my.Pop == False))
		{
			if (int(random(6)) == 3)
			{ 
				my.Type = typeTerrorist; 
				my.base = (int(random(3)) + 1);
				if (my.base == 2) { my.base = 4; }
				if (my.base == 3) { my.base = 7; }
				my.Delay = DEFAULT_DELAY * 1.8; 	// So that he will not shoot while rising and give the player a chance.
			} 
			else 
			{ 
				my.Type = typeCivilian; 
				my.base = (int(random(3)) + 1);
				if (my.base == 1) { my.base = 10; }
				if (my.base == 2) { my.base = 13; }
				if (my.base == 3) { my.base = 16; }
				my.Delay = DEFAULT_DELAY * 2; 
			}

			my.GoingUp = True;
			my.Pop = True;
		}

		if (my.Pop == True)
		{
			my.Delay = my.Delay - 1 * time;
			if ((my.Delay < 10) && (my.type == typeCivilian)) { my.skin = my.Base + 1; }
			if (my.Delay < 0)
			{
				if (my.Type == typeCivilian) { my.Dying = True; }
				if (my.Type == typeTerrorist) { my.skin = my.base + 1; Health = Health - DMG; my.delay = DEFAULT_DELAY; } // terrorist shooting
			}
		}

		wait(1);
	}
}

action TNTBlow
{
	spark_gib(20);
	lighton();
	actor_explode();
}

action TNT
{
	my.event = TNTBlow;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.OriginalZ = my.z;
	my.Type = typeCivilian;
}


action CloudX
{
	my.skill1 = my.y;

	while (1)
	{
		my.y = my.y - 100 * time;
		if (my.y < (my.skill1 - 3000)) { my.y = my.skill1; }
		wait(1);
	}
}

action CloudMaster
{
	while(1)
	{
		if (int(random(10)) == 5) { create (<Cloud.mdl>,my.x,CloudX); }
		wait(1);
	}
}

function Restart
{
	if (Death == 0)
	{
		Death = 1;
		ShowRIP();
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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
