include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

var Stage = 1;
var TheZ = 0;
var BeInvis = 0;

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var camera_dist = 240;   // camera distance to entity in 3rd person view
var cameraX[15] = 3563,1107,-1955,-5249,-8539,-10891,-12225,-12265,-11139,-8448,-5397,-2139,1123,3626,5188;
var cameraY[15] = 4427,5847,6579,6640,5778,4336,2778,883,-755,-2463,-3045,-2867,-2383,-941,774;
var cameratemp[3] = 0,0,0;
var DMG = 12;
var closest;
var filehandle;
var Dirt[3] = 0,0,0;
var Align;
var OriginalZ;
var OriginalX;
var OriginalPan;
var Destination;
var Type;
var Speed = 0.4;
var vDistance;
var TalkAnim = 0;
var WeatherEffect = 0;
var PlayerHit = 0;
var turn2 = 0;
var RoadTop = 0;
var GroundTop = 0;
var Talking = 0;
string cheatstring = "                                                               ";
var Cheat1 = 0;
var Cheat2 = 0;
var Cheat3 = 0;
var MisDelay = 0;
var Restart;
var PlayID;
var varLevelTemp;
var WeatherSet = 0;

bmap bPanel = <Bike.pcx>;

sound Music1 = <SNG001.WAV>;
sound Music2 = <SNG009.WAV>;
sound Music3 = <SNG016.WAV>;
sound Music4 = <SNG018.WAV>;
sound Music5 = <SNG017.WAV>;
sound Music6 = <SNG013.WAV>;

sound CheatSound = <SFX035.WAV>;

var Cheat1;

synonym TheJeep { type entity; }
synonym Bad1 { type entity; }
synonym Bad2 { type entity; }

sound SND1 = <MAR031.WAV>;
sound SND2 = <MAR009.WAV>;
sound SND3 = <MAR010.WAV>;
sound SND4 = <MAR011.WAV>;
sound SND5 = <KVC007.WAV>;
sound SND6 = <KVC008.WAV>;
sound SND7 = <KVC009.WAV>;
sound SND8 = <KVC010.WAV>;
sound SND9 = <KVC011.WAV>;
sound BGM = <SNG001.WAV>;
var SND;

view Mirror
{
	pos_x = 20;
	pos_y = 360;
	size_x = 200;
	size_y = 100;
	flags = visible;
}

view Mirror2
{
	pos_x = 420;
	pos_y = 360;
	size_x = 200;
	size_y = 100;
	flags = visible;
}

panel pPanel
{
	layer = -0.2;
	bmap = bPanel;
	pos_y = 330;
	flags = visible, d3d, refresh, overlay;
}

entity Meter
{
	type = <Mad.mdl>;
	layer = 5;
	flags = visible;
	view = camera;
	x = 105;
	y = 1;
	z = -33;
}

synonym TheVespa { type entity; }

define MineForce,skill40;
define MineElevation,skill41;
define MineStage,skill42;
define MineDiff,skill43;

sound Honk1 = <SFX007.wav>;
sound Honk2 = <SFX008.wav>;
sound Honk3 = <SFX009.wav>;

sound Bangy = <SFX010.wav>;
sound Mis_sound = <SFX011.wav>;
sound VespaEngine = <SFX012.wav>;

var VENG = 0;
var DayOrNight;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	filehandle = file_open_read ("Arrive.dat");
		Stage = file_asc_read (filehandle);
	file_close (filehandle);

	warn_level = 0;
	tex_share = on;
	camera.fog = 15;
	mirror.fog = 15;
	mirror2.fog = 15;

	Speed = 0.4;
	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	Restart = 1;

	meter.roll = 0;
	vDistance = 0;
	BeInvis = 0;

	pPanel.visible = on;
	meter.visible = on;
	mirror.visible = on;
	mirror2.visible = on;

	load_level (<Desert.WMB>);

	if (WeatherSet == 0)
	{
		if (Stage == _VILLAGE) { let_it_rain(); }
		if (Stage == _VOLCANO) { let_it_snow(); }
		if (Stage == _MANSION) { storm(); }
	
		if (Stage != _MANSION) { night = 1; Set_Day(); fog_color = 1; camera.fog = 60; }
		
		WeatherSet = 1;
	}

	VoiceInit();
	Initialize();

	DayOrNight = int(random(6));

	if (DayOrNight == 3) { DayOrNight = 50; night = 0; } else { DayOrNight = 255; night = 1; }
	if (Stage == _MANSION) { DayOrNight = 50; }

	if (Stage == _TOWN)    { scene_map = bmapBack1; }
	if (Stage == _VILLAGE) { scene_map = bmapBack2; }
	if (Stage == _ASYLUM)  { scene_map = bmapBack3; }
	if (Stage == _OLYMPIC) { scene_map = bmapBack4; }
	if (Stage == _MANSION) { scene_map = bmapBack5; }
	if (Stage == _VOLCANO) { scene_map = bmapBack6; }

	sky_color.red = DayOrNight;
	sky_color.green= DayOrNight;
	sky_color.blue = DayOrNight;
	scene_color.red = DayOrNight;
	scene_color.green = DayOrNight;
	scene_color.blue = DayOrNight;

	if (DayOrNight == 50)
	{
		fog_color = 1; 
		camera.fog = 60;
	}
}

action Dome
{
	my.skin = 1;
	while(1) { my.pan = my.pan + 0.01 * time; wait(1); }
}

ACTION FogLight
{
	if (player == null) { wait(1); }

	while (1)
	{
		if ((player.pan == 90) && (DayOrNight == 50))
		{
			my.invisible = off;
			my.lightrange = random(2) + 110;
			my.lightred = 255;
			my.lightgreen = 255;
			my.lightblue = 0;

			my.x = player.x;
			my.y = player.y + 100;
		}
		else
		{
			my.invisible = on;
			my.lightrange = 0;
		}

		wait (1);
	 }
}

ACTION Piposh
{
	if (player == null) { wait(1); }

	stop_sound (PlayID);

	if (Stage == _ASYLUM) { play_loop (Music1,50); PlayID = result; }
	if (Stage == _VILLAGE) { play_loop (Music2,50); PlayID = result; }
	if (Stage == _OLYMPIC) { play_loop (Music3,50); PlayID = result; }
	if (Stage == _VOLCANO) { play_loop (Music4,50); PlayID = result; }
	if (Stage == _TOWN) { play_loop (Music5,50); PlayID = result; }
	if (Stage == _MANSION) { play_loop (Music6,50); PlayID = result; }

	while (1)
	{
		if (BeInvis == 1) { my.invisible = on; }

		if (MisDelay > 0) { MisDelay = MisDelay - 1 * time; }
		if (TalkAnim == 2) { ent_cycle ("Talk",my.skill10); my.skill11 = my.skill11 + 1; } else { ent_cycle ("Stand",0); }
		my.skill10 = my.skill10 + 10;
		if (my.skill10 == 1000) { my.skill10 = 0; }

		if (TalkAnim == 2) { if (GetPosition(Voice) >= 1000000) { TalkAnim = 0; } }

		my.x = player.x;
		my.y = player.y;
		my.z = player.z - 3;
		my.pan = player.pan;
		my.tilt = player.tilt;
		my.roll = player.roll;
		wait (1);
	 }
}

ACTION Grandma
{
	if (player == null) { wait(1); }

	while (1)
	{
		if (BeInvis == 1) { my.invisible = on; }

		if (TalkAnim == 1) { ent_cycle ("Talk",my.skill10); } else { ent_cycle ("Walk",my.skill10); }
		my.skill10 = my.skill10 + 10;
		if (my.skill10 == 1000) { my.skill10 = 0; }

		if (TalkAnim == 1) { if (GetPosition(Voice) >= 1000000) { TalkAnim = 2; sPlay ("PIP067.WAV"); } }

		if (TalkAnim == 0) 
		{ 
			if (int(random(300)) == 150) 
			{ 
				TalkAnim = 1; 
				temp = int(random(8)) + 1;
				if (temp == 1) { sPlay ("BRA007.WAV"); }
				if (temp == 2) { sPlay ("BRA008.WAV"); }
				if (temp == 3) { sPlay ("BRA009.WAV"); }
				if (temp == 4) { sPlay ("BRA010.WAV"); }
				if (temp == 5) { sPlay ("BRA011.WAV"); }
				if (temp == 6) { sPlay ("BRA012.WAV"); }
				if (temp == 7) { sPlay ("BRA013.WAV"); }
				if (temp == 8) { sPlay ("BRA014.WAV"); }
			} 
		}

		if (int(random(300)) == 150)
		{
			temp = int(random(9)) + 1;
			if (temp == 1) { play_entsound(my,SND1,1000); SND = result; Talking = 1; }
			if (temp == 2) { play_entsound(my,SND2,1000); SND = result; Talking = 1; }
			if (temp == 3) { play_entsound(my,SND3,1000); SND = result; Talking = 1; }
			if (temp == 4) { play_entsound(my,SND4,1000); SND = result; Talking = 1; }
			if (temp == 5) { play_entsound(my,SND5,1000); SND = result; Talking = 2; }
			if (temp == 6) { play_entsound(my,SND6,1000); SND = result; Talking = 2; }
			if (temp == 7) { play_entsound(my,SND7,1000); SND = result; Talking = 2; }
			if (temp == 8) { play_entsound(my,SND8,1000); SND = result; Talking = 2; }
			if (temp == 9) { play_entsound(my,SND9,1000); SND = result; Talking = 2; }
		}

		my.x = player.x;
		my.y = player.y;
		my.z = player.z - 3;
		my.pan = player.pan;
		my.tilt = player.tilt;
		my.roll = player.roll;
		wait (1);
	 }
}

function test
{
	var ID;
	ID = 16;

	filehandle = file_open_write ("Arrive.dat");
		file_asc_write (filehandle,ID);
	file_close (filehandle);

	ID = 8;

	filehandle = file_open_write ("Depart.dat");
		file_asc_write (filehandle,ID);
	file_close (filehandle);
}

//on_t = test();

action Heights
{
	if (my.skill1 == 1) { GroundTop = my.z; }
	if (my.skill1 == 2) { RoadTop = my.z; }
}

action Bang
{
	if (you.skill30 == 1)
	{
		play_entsound (my,Bangy,1000);
		PlayerHit = 10;
		Meter.roll = meter.roll + DMG;
	}

	if (you.skill30 == 2)
	{
		play_entsound (my,Bangy,1000);
		my = you;
		_gib(2);
		actor_explode();
	}
}

action MineHit
{
	if (event_type == event_entity)
	{
		if (you == player)
		{
			you.z = you.z + 20;
			PlayerHit = 10;
			Meter.roll = meter.roll + DMG;
			_gib(20);
			actor_explode();
		}
	}
}

action Vespa
{
	player = my;
	TheVespa = my;

	TheZ = my.z + 100;

	my.event = Bang;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.enable_block = on;

	OriginalZ = my.z;
	OriginalX = my.x;
	OriginalPan = my.pan;

	camera.x = my.x;
	camera.y = my.y - 200;
	camera.z = my.z + 50;

	while (1)
	{
		if (my.z < OriginalZ) { my.z = OriginalZ; }

		if (BeInvis == 1) { my.invisible = on; }

		if (snd_playing (VENG) == 0) { play_sound (VespaEngine,10); VENG = result; }

		if (Meter.roll < 180)
		{
			if (PlayerHit > 0)
			{
				PlayerHit = PlayerHit - 1;
				my.pan = my.pan + 30;
			}
			else
			{
				my.pan = OriginalPan;
			}
		}

		my.y = my.y + random(2) - 1;
		if (Meter.roll >= 180) { if (my.z > OriginalZ) { my.z = my.z - 0.1; } else { my.z = OriginalZ; } }

		if (Meter.roll < 180) { camera.z = camera.z + mickey.y; }

		my.x = my.x + mickey.x;
		LimitXZ();
		LookAtVespa();
		if (Meter.roll < 180) { EngineShake(); }
		if (int(random(20)) == 10 ) { AddScenery(); }
		if (int(random(50)) == 25) { AddTraffic(); }
		if (int(random(100)) == 50) { Addsign();    }
		SetMirror();

		if (Meter.roll < 180) { actor_move(); }

		ent_cycle ("Walk",my.skill32);
		my.skill32 = my.skill32 + 50 * time;

		if (Meter.roll >= 180) 
		{ 
			emit(20,MY.POS,particlefade3);

			if (my.skill40 != -10) { my.skill40 = my.skill40 + 1 * time; my.pan = my.pan + 50 * time; my.z = my.z + 50 * time; }
			camera.z = TheZ; 
			mirror.visible = off;
			mirror2.visible = off;
			ppanel.visible = off;
			meter.visible = off;

			if (my.skill40 > 30) { beinvis = 1; create(<dummy.mdl>,my.x,kaboom); my.skill40 = -10; my.invisible = on; waitt(64); main(); }
		}

		wait(1);
	}
}

action Kaboom
{
	play_sound (bangy,100);
	_gib(500);
	actor_explode();
}

function SetMirror
{
	if (TheJeep == null) { wait(1); }

	Mirror.x = player.x;
	Mirror.y = player.y - 30;
	Mirror.z = player.z + 50;
	Mirror.pan = 270;

	Mirror2.x = TheJeep.x;
	Mirror2.y = TheJeep.y + 100;
	Mirror2.z = TheJeep.z + 50;
	Mirror2.pan = 270;
}

function LookAtVespa
{
	vec_set(temp,player.x);
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
}

function EngineShake
{
	player.z = player.z + (int(random(2)) - 1) * 0.2;
}

function LimitXZ
{
	if (player.x > OriginalX + 200) { player.x = OriginalX + 200; }
	if (player.x < OriginalX - 200) { player.x = OriginalX - 200; }
	if (camera.z > OriginalZ + 200) { camera.z = OriginalZ + 200; }
	if (camera.z < OriginalZ + 50)  { camera.z = OriginalZ + 50;  }
}

action Road
{
	if ((Stage == _ASYLUM) || (Stage == _MANSION))
	{
		if (my.skill1 == 1) { morph (<DesGr1.WMB>,my); }
		if (my.skill1 == 2) { morph (<DRoad1.WMB>,my); }
	}

	if (Stage == _VILLAGE)
	{
		if (my.skill1 == 1) { morph (<DesGr2.WMB>,my); }
		if (my.skill1 == 2) { morph (<DRoad2.WMB>,my); }
	}

	if (Stage == _OLYMPIC)
	{
		if (my.skill1 == 1) { morph (<DesGr3.WMB>,my); }
		if (my.skill1 == 2) { morph (<DRoad3.WMB>,my); }
	}

	if (Stage == _VOLCANO)
	{
		if (my.skill1 == 1) { morph (<DesGr4.WMB>,my); }
		if (my.skill1 == 2) { morph (<DRoad4.WMB>,my); }
	}

	if (Stage == _TOWN)
	{
		if (my.skill1 == 1) { morph (<DesGr5.WMB>,my); }
		if (my.skill1 == 2) { morph (<DRoad5.WMB>,my); }
	}

	while (1) 
	{ 
		my.v = my.v - 50*time;
		wait (1);
	}
}

action Rail
{
	my.passable = on;
	if (Stage != _TOWN) { my.invisible = on; }

	while(Stage == _TOWN)
	{
		my.u = my.u + 50 * time;
		wait(1);
	}
}

action Sign
{
	my.skin = int(random(11)) + 1;

	while (my.z < player.z - 30)
	{
		my.z = my.z + 10*time;
		wait(1);
	}

	while(1)
	{
		my.y = my.y - 50*time;
		if (my.y < player.y - 5000) { Kill(); }
		wait(1);
	}
}

function AddSign
{
	if (Meter.roll >= 180) { return; }
	Temp.y = player.y + 8000;
	temp.z = player.z - 200;
	Align = int(random(2)+1);
	if (Align == 1) { temp.x = -473; } else { temp.x = 327; }
	Create (<SSign.mdl>,temp.x,Sign); }
}

function AddScenery
{
	if (Meter.roll >= 180) { return; }
	Temp.y = player.y + 8000;
	Temp.z = player.z - 200;
	Align = int(random(2)+1);
	if (Align == 1) { temp.x = (random(1500) + 500) * -1; } else { temp.x = random(1500) + 500; }
	Type = int(random(3)) + 1;

	if (Stage == _ASYLUM)
	{
		if (Type == 1) { Create (<Deadtree.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Rocks.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Rockz.mdl>,Temp.x,Move); }
	}

	if (Stage == _VILLAGE)
	{
		if (Type == 1) { Create (<Bush2.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Rocks.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Tree2.mdl>,Temp.x,Move); }
	}

	if (Stage == _OLYMPIC)
	{

		if (Type == 1) { Create (<Cactus.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Deadcow.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Palm2.mdl>,Temp.x,Move); }
	}

	if (Stage == _VOLCANO)
	{
		if (Type == 1) { Create (<Snowman.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Deadtree.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Bear.mdl>,Temp.x,Move); }
	}

	if (Stage == _TOWN)
	{
		if (Type == 1) { Create (<Boat.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Shark.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Mermaid.mdl>,Temp.x,Move); }
	}

	if (Stage == _MANSION)
	{
		if (Type == 1) { Create (<Ripper.mdl>,Temp.x,Move); }
		if (Type == 2) { Create (<Deadtree.mdl>,Temp.x,Move); }
		if (Type == 3) { Create (<Grave2.mdl>,Temp.x,Move); }
	}
}

function AddTraffic
{
	if (Meter.roll >= 180) { return; }
	Temp.y = player.y + 8000;
	Temp.z = player.z - 200;
	temp.x = random(400) - 273;
	Type = int(random(6)) + 1;
	if (Type == 1) { Create (<OilTank.mdl>,Temp.x,Traffic);  }
	if (Type == 2) { Create (<FarmTruk.mdl>,Temp.x,Traffic); }
	if (Type == 3) { Create (<Mechbesh.mdl>,Temp.x,Traffic); }
	if (Type == 4) { Create (<WarCar.mdl>,Temp.x,Traffic);   }
	if (Type == 5) { Create (<SportCar.mdl>,Temp.x,Traffic); }
	if (Type == 6) { Create (<Taxi.mdl>,Temp.x,Traffic);     }
}
	
action Move
{
	drop_shadow();

	my.pan = random(360);

	while (my.z < GroundTop)
	{
		my.z = my.z + 10*time;
		wait(1);
	}

	while(1)
	{
		my.y = my.y - 50*time;
		if (my.y < player.y - 5000) { Kill(); }
		wait(1);
	}
}

action KillEntity
{
	Remove (you);
}

action Killer
{
	my.event = KillEntity;
	my.enable_entity = on;
}

function Kill { Remove(my); }

action DestinationReach
{
	Align = my.z;

	// Decide which destination to show

	if (Stage == _ASYLUM)  { morph (<Asylum.mdl>,my);   }	// Desert 1
	if (Stage == _VILLAGE) { morph (<MapVil.mdl>,my);   }	// Grass
	if (Stage == _OLYMPIC) { morph (<Stadium.mdl>,my);  }	// Desert 2
	if (Stage == _VOLCANO) { morph (<MapMount.mdl>,my); }	// Snow
	if (Stage == _TOWN)    { morph (<Town2.mdl>,my);    }	// Water
	if (Stage == _MANSION) { morph (<Mansion.mdl>,my);  }	// Night

	my.scale_x = 1.1;
	my.scale_y = 1.1;
	my.scale_z = 1.1;
	my.z = Align;

	while(1)
	{
		if (Restart == 1)
		{
			Restart = 0;
			my.scale_x = 1.1;
			my.scale_y = 1.1;
			my.scale_z = 1.1;
			my.z = Align;
		}

		if (my.scale_x < 20)
		{
			if (my.z < player.z) 
			{ 
				my.z = my.z + Speed*time; 
			}
			else
			{
				my.scale_x = my.scale_x + (Speed/10)*time;
				my.scale_y = my.scale_x;
				my.scale_z = my.scale_x;
				//my.y = my.y + Speed*time;
			}
		}
		else
		{
			player.y = player.y + 50 * time;
			vDistance = vDistance + 3 * time;

			if (vDistance > 150)
			{
				// Change Level
				GoToLocation (Stage);
			}
		}

		wait(1);
	}
}

action DestinationDepart
{
	filehandle = file_open_read ("Depart.dat");
		varLevelTemp = file_asc_read (filehandle);
	file_close (filehandle);

	Align = my.z;

	// Decide which destination to show

	if (VarLevelTemp == _VILLAGE) { morph (<MapVil.mdl>,my); }
	if (VarLevelTemp == _ASYLUM)  { morph (<Asylum.mdl>,my); }
	if (VarLevelTemp == _TOWN)    { morph (<Town2.mdl>,my); }
	if (VarLevelTemp == _MANSION) { morph (<Mansion.mdl>,my); }
	if (VarLevelTemp == _OLYMPIC) { morph (<Stadium.mdl>,my); }
	if (VarLevelTemp == _VOLCANO) { morph (<MapMount.mdl>,my); }

	my.scale_x = 20;
	my.scale_y = 20;
	my.scale_z = 20;
	my.z = Align;

	while(1)
	{
		if (Restart == 1)
		{
			Restart = 0;
			my.scale_x = 20;
			my.scale_y = 20;
			my.scale_z = 20;
			my.z = Align;
		}

		if (my.z > player.z) 
		{ 
			my.z = my.z - Speed * time; 
		}
		else
		{
			my.scale_x = my.scale_x - (Speed / 10) * time;
			my.scale_y = my.scale_x;
			my.scale_z = my.scale_x;
		}
		wait(1);
	}
}


function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 300;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = 128;
		MY_COLOR.GREEN = 128;
		MY_COLOR.BLUE = 128;
	}
	else
	{
		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

function particlefade2()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 100;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 255;
		MY_COLOR.BLUE = 0;
	}
	else
	{
		MY_COLOR.GREEN = MY_COLOR.GREEN - 30 * time;
		MY_SIZE = MY_SIZE - 1 * time;
		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

function particlefade3()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 300;
		MY_SPEED.X = (RANDOM(2)-1);
		MY_SPEED.Y = (RANDOM(2)-1);
		MY_SPEED.Z = -5;
		MY_COLOR.RED = random(128);
		MY_COLOR.GREEN = MY_COLOR.RED;
		MY_COLOR.BLUE = MY_COLOR.RED;
	}
	else
	{
		if(MY_AGE > 100) { MY_ACTION = NULL; }
	}
}

function ShotMis
{
	if (Meter.roll >= 180) { return; }
	if ((Cheat3 == 1) && (MisDelay <= 0))
	{
		MisDelay = 20;
		temp.x = player.x;
		temp.y = player.y + 50;
		temp.z = player.z + 20;
		create (<Missile.mdl>,temp.x,Missile2);
	}
}

on_mouse_left = ShotMis();

action Traffic
{
	my.push = 200;
	my.skill30 = 1;
	drop_shadow();

	while (my.z < RoadTop)
	{
		my.z = my.z + 10*time;
		wait(1);
	}

	while(1)
	{
		temp = 3 * TIME;
		if(temp > 6) { temp = 6; }
		emit(temp,MY.POS,particlefade);

		my.y = my.y - 100 * time; 
		force.y = - 150;
	
		// find ground below
		scan_floor();
		move_gravity();
		actor_anim();
		wait(1);

		if (int(random(100)) == 50) 
		{ 
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,Honk1,1000); }
			if (my.skill40 == 2) { play_entsound (my,Honk2,1000); }
			if (my.skill40 == 3) { play_entsound (my,Honk3,1000); }
		}

		if (my.y < player.y - 5000) { actor_explode(); }
	}
}

action Jeep
{
	TheJeep = my;

	if ((Bad1 == null) || (Bad2 == null)) { wait(1); }

	while(1)
	{
		if (Meter.roll < 180)
		{
			if ((int(random(50)) == 25) && (Cheat2 == 0)) { create (<Mine.mdl>,my.x,Mine); }
			if ((int(random(100)) == 50) && (Cheat2 == 0)) { create (<Missile.mdl>,my.x,Missile); }
		}

		if (my.x < player.x) { my.x = my.x + 10*time; bad1.x = bad1.x + 10 * time; bad2.x = bad2.x + 10 * time; turn2 = 1; }
		if (my.x > player.x) { my.x = my.x - 10*time; bad1.x = bad1.x - 10 * time; bad2.x = bad2.x - 10 * time; turn2 = 2; }

		if (abs(my.x - player.x) < 10) { turn2 = 0; }

		if (turn2 == 0) { ent_frame ("Frame",0); }
		if (turn2 == 2) { ent_frame ("Left",0); }
		if (turn2 == 1) { ent_frame ("Right",0); }

		wait(1);
	}
}

action Badx1
{
	Bad1 = my;
	while(1)
	{
		if (Talking == 1) { Talk(); } else { Blink(); }
		if (turn2 == 0) { ent_frame ("Stand",0); }
		if (turn2 == 1) { ent_frame ("Left",0); }
		if (turn2 == 2) { ent_frame ("Right",0); }
		wait(1);
	}
}

action Badx2
{
	Bad2 = my;
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action MineHit2
{
	if (event_type == event_entity)
	{
		if ((you.skill30 == 1) || (you.skill30 == 2))
		{
			_gib(20);
			actor_explode();
			my = you;
			_gib(100);
			actor_explode();
		}
	}
}

function _gib_action()
{
	// scall the bits down by the actor_scale amount
	vec_scale(MY.SCALE_X,actor_scale);

	// Init gib bit
	MY._SPEED_X = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Y = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Z = RANDOM(35) + 15;          // 15 -> 50
	MY._SPEED_Y = -50;

	MY._ASPEED_PAN = RANDOM(35) + 35;       // 35 -> 70
	MY._ASPEED_TILT = RANDOM(35) + 35;      // 35 -> 70
	MY._ASPEED_ROLL = RANDOM(35) + 35;      // 35 -> 70

	MY.ROLL = RANDOM(180);	// start with a random orientation
	MY.PAN = RANDOM(180);

	MY.PUSH = -1;	// allow user/enemys to push thru

	// Animate gib-bit
	MY.SKILL9 = RANDOM(50);
	while(MY.SKILL9 > -75)
	{
		abspeed[0] = MY._SPEED_X * TIME;
		abspeed[1] = MY._SPEED_Y * TIME;
		abspeed[2] = MY._SPEED_Z * TIME;

		if (meter.roll >= 180)
		{
			my._speed_z = -30; 
		}
		else
		{
			MY._SPEED_Y = -50;
		}

		MY.PAN += MY._ASPEED_PAN * TIME;
		MY.TILT += MY._ASPEED_TILT * TIME;
		MY.ROLL += MY._ASPEED_ROLL * TIME;

		vec_scale(absdist,movement_scale);	// scale absolute distance by movement_scale
		MOVE  ME,NULLSKILL,abspeed;

		IF(BOUNCE.Z)
		{
			MY._SPEED_Z = -(MY._SPEED_Z/2);
			if(MY._SPEED_Z < 0.25)
			{
				MY._SPEED_X = 0;
				MY._SPEED_Y = -50;
				MY._SPEED_Z = 0;
				MY._ASPEED_PAN = 0;
				MY._ASPEED_TILT = 0;
				MY._ASPEED_ROLL = 0;
			}
		}

		MY._SPEED_Z -= 2;
		MY.SKILL9 -= 1;

		wait(1);
	}


	// Fade out
	MY.transparent = ON;
	MY.alpha = 100;
	while(1)
	{
   	MY.alpha -= 5*time;
		if(MY.alpha <=0)
		{
			// remove
			remove(ME);
			return;
		}

   	wait(1);
	}
}

action Mine
{
	drop_shadow();
	my.event = MineHit;
	my.enable_entity = on;
	my.enable_block = on;
	my.enable_impact = on;
	my.enable_push = on;

	my.MineForce = 1;
	my.MineElevation = 40;
	my.MineStage = 1;
	my.MineDiff = random(2) - 1;

	my.skill30 = 2;

	while(1)
	{
		if (my.MineStage == 1)
		{
			MineWorks();

			my.y = my.y + my.MineForce * time;
			my.z = my.z + my.MineElevation * time;
			my.x = my.x + my.MineDiff * time;

			my.MineForce = my.MineForce + 1 * time;
			my.MineElevation = my.MineElevation - 1 * time;

			if (my.MineElevation < 1) { my.MineStage = 2; }
		}

		if (my.MineStage == 2)
		{
			MineWorks();

			my.y = my.y + my.MineForce * time;
			my.z = my.z - my.MineElevation * time;
			my.x = my.x + my.MineDiff * time;

			my.MineForce = my.MineForce - 1 * time;
			my.MineElevation = my.MineElevation + 1 * time;

			if (my.MineElevation > 39) { my.pan = player.pan - 90; my.MineStage = 3; }
		}

		if (my.MineStage == 3)
		{
			my.z = player.z;
			my.tilt = player.tilt;
			my.roll = player.roll;

			force.y = -50;
	
			scan_floor();
			move_gravity();
			actor_anim();

			if (my.y < player.y - 500) { actor_explode(); }
		}

		wait(1);
	}
}

function MineWorks
{
	temp = 3 * TIME;
	if(temp > 6) { temp = 6; }
	emit(temp,MY.POS,particlefade);

	my.pan = my.pan + 10*time;
	my.tilt = my.tilt + 10*time;
	my.roll = my.roll + 10*time;
}

action Missile
{
	drop_shadow();
	my.event = MineHit;
	my.enable_entity = on;
	my.enable_block = on;
	my.enable_impact = on;
	my.enable_push = on;
	my.skill2 = my.z;
	my.MineDiff = random(2) - 1;

	while(1)
	{
		if ((my.y >= player.y) && (my.skill40 == 0)) { 	play_entsound (my,mis_sound,1000); my.skill40 = 1; }
		temp = 3 * TIME;
		if(temp > 6) { temp = 6; }
		emit(temp,MY.POS,particlefade2);

		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 10 * time;

		force.x = my.MineDiff;
		force.y = 5;

		scan_floor();
		move_gravity();
		actor_anim();

		my.z = my.skill2;

		my.skill20 = my.skill20 + 1 * time;
		if (my.skill20 > 300) { actor_explode(); }
		wait(1);
	}
}

action Missile2
{
	my.shadow = on;
	my.event = MineHit2;
	my.enable_entity = on;
	my.enable_block = on;
	my.enable_impact = on;
	my.enable_push = on;
	my.skill2 = my.z;

	while(1)
	{
		temp = 3 * TIME;
		if(temp > 6) { temp = 6; }
		emit(temp,MY.POS,particlefade2);

		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 10 * time;

		force.y = 30;

		scan_floor();
		move_gravity();
		actor_anim();

		my.z = my.skill2;

		my.skill20 = my.skill20 + 1 * time;
		if (my.skill20 > 100) { actor_explode(); }
		wait(1);
	}
}

function set_day ()
{
	if (night == 0) {return;}
	SKY_MAP = sky_day;
	CLOUD_MAP = cloud_day;
	sky_color.red = 25;
	sky_color.green= 25;
	sky_color.blue = 25;
	night = 0;
	while (1)
	{
		sky_color.red += 25*time;
		sky_color.green += 25*time;
		sky_color.blue += 25*time;
		camera.fog -= 5 * time;
		if (sky_color.red >= 250 && sky_color.green >= 250 && sky_color.blue >= 250)
		{
			fog_color = 0;
			sky_color.red = 250;
			sky_color.green = 250;
			sky_color.blue = 250;
			break;
		}
		wait (1);
	}
}

function Talk()
{
	if (snd_playing(SND) == 0) { Talking = 0; }
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
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

function lightning ()
{
	temp = RANDOM(20);
	IF (temp <=10 ) {lightning1 ();}
	ELSE {lightning2 ();}
}

function lightning1 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	CAMERA.FOG -= 80;
	WAITT	1;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 30;
	WAITT	2;
	CAMERA.FOG += 20;
	WAITT	1;
	SKY_MAP = sky_light;
	CAMERA.FOG -= 40;
	WAITT	3;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 30;
	WAITT	1;
	SKY_MAP = sky;
	CAMERA.FOG += 40;
	WAITT	2;
	SKY_MAP = sky_light2;
	CAMERA.FOG -= 30;
	WAITT	1;
	SKY_MAP = sky;
	CAMERA.FOG += 30;
}

function lightning2 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	CAMERA.FOG -= 80;
	WAITT	4;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 50;
	WAITT	3;
	SKY_MAP = sky_light;
	CAMERA.FOG -= 40;
	WAITT	2;
	SKY_MAP = sky;
	CAMERA.FOG += 70;
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"hyperdrive") == 1) { msg.string = "cheat enabled"; show_message(); Cheat1 = 1; Speed = 0.8; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"cease fire") == 1) { msg.string = "cheat enabled"; show_message(); Cheat2 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"war vespa") == 1)  { msg.string = "cheat enabled"; show_message(); Cheat3 = 1; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

on_tab = cheat();