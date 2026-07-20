include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var FireLength = 0;
var LeftBorder = 0;
var RightBorder = 0;

var SEN = 3;
var Death;

var stateRUNLEFT = 0;
var stateRUNRIGHT = 1;
var stateDUCK = 2;
var stateFIRE = 3;
var stateHIT = 4;
var pDMG = 16;

var sHealth;
var kHealth;

string cheatstring = "                                                                          ";

var Aim[3] = 0,0,0;
var Bullets = 20;

var Safe = 0;
var DuckHere = 1;

var Cheat1 = 0;
var Cheat2 = 0;
var Cheat3 = 0;

var MUS;

synonym Kavechnik { type entity; }
synonym Shoresh { type entity; }
synonym Piposh { type entity; }

sound CheatSound = <SFX035.WAV>;

define state,skill10;
define duration,skill11;
define health,skill12;

var DMG = 10;

bmap DuckIMG = <DuckHere.pcx>;

bmap bP20 = <finpnl20.pcx>;
bmap bP19 = <finpnl19.pcx>;
bmap bP18 = <finpnl18.pcx>;
bmap bP17 = <finpnl17.pcx>;
bmap bP16 = <finpnl16.pcx>;
bmap bP15 = <finpnl15.pcx>;
bmap bP14 = <finpnl14.pcx>;
bmap bP13 = <finpnl13.pcx>;
bmap bP12 = <finpnl12.pcx>;
bmap bP11 = <finpnl11.pcx>;
bmap bP10 = <finpnl10.pcx>;
bmap bP09 = <finpnl09.pcx>;
bmap bP08 = <finpnl08.pcx>;
bmap bP07 = <finpnl07.pcx>;
bmap bP06 = <finpnl06.pcx>;
bmap bP05 = <finpnl05.pcx>;
bmap bP04 = <finpnl04.pcx>;
bmap bP03 = <finpnl03.pcx>;
bmap bP02 = <finpnl02.pcx>;
bmap bP01 = <finpnl01.pcx>;
bmap bP00 = <finpnl0.pcx>;

bmap bPanel = <fPanel.pcx>;
bmap bBar = <fBar.pcx>;
bmap bpwr = <powrbar.pcx>;

panel GUI 
{
	bmap = bp20;
	pos_x = 0;
	pos_y = 0;
	layer = 2;
	flags = refresh,d3d,visible,overlay;

	window 5,5,19,346,bpwr,0,player.health;
}

panel pHealth
{
	bmap = bPanel;
	pos_x = 0;
	pos_y = 0;
	layer = 1;
	flags = refresh,d3d,visible,overlay;

	window 71,18,251,21,bBar,shealth,0;
	window 377,18,251,21,bBar,khealth,0;
}

panel DuckIcon
{
	bmap = DuckIMG;
	pos_x = 600;
	pos_y = 50;
	layer = 1;
	flags = refresh,d3d,visible,overlay;
}

sound SoldierFall = <SFX023.WAV>;
sound SoldierFall2 = <SFX028.WAV>;
sound Rearm = <SFX024.WAV>;
sound LaserBeam = <SFX025.WAV>;
sound Matah = <SFX026.WAV>;

function UpdatePanel
{
	if (Bullets == 20) { gui.bmap = bP20; }
	if (Bullets == 19) { gui.bmap = bP19; }
	if (Bullets == 18) { gui.bmap = bP18; }
	if (Bullets == 17) { gui.bmap = bP17; }
	if (Bullets == 16) { gui.bmap = bP16; }
	if (Bullets == 15) { gui.bmap = bP15; }
	if (Bullets == 14) { gui.bmap = bP14; }
	if (Bullets == 13) { gui.bmap = bP13; }
	if (Bullets == 12) { gui.bmap = bP12; }
	if (Bullets == 11) { gui.bmap = bP11; }
	if (Bullets == 10) { gui.bmap = bP10; }
	if (Bullets == 09) { gui.bmap = bP09; }
	if (Bullets == 08) { gui.bmap = bP08; }
	if (Bullets == 07) { gui.bmap = bP07; }
	if (Bullets == 06) { gui.bmap = bP06; }
	if (Bullets == 05) { gui.bmap = bP05; }
	if (Bullets == 04) { gui.bmap = bP04; }
	if (Bullets == 03) { gui.bmap = bP03; }
	if (Bullets == 02) { gui.bmap = bP00; }
	if (Bullets == 01) { gui.bmap = bP02; }
	if (Bullets == 00) { gui.bmap = bP01; }

	if (player.health <= 0) 
	{  
		if (Death == 0)
		{
			Death = 1;
			ShowRIP();
		}
	}

	if ((Shoresh != null) && (Kavechnik != null)) 
	{ 
		if ((Shoresh.health <= 0) && (Kavechnik.health <= 0)) 
		{ 
			Mansion[2] = 1;
			WriteGameData(0);

			waitt(32);
	
			Run ("Ending.exe");
		}
	}
}

sound BGMusic = <SNG024.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _MANSION;

	warn_level = 0;
	tex_share = on;

	Bullets = 20;

	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	level_load("Final.wmb");

	VoiceInit();
	Initialize();

	scene_map = bmapBack1;

	SKY_MAP = sky;

	stop_sound (MUS);
	play_loop (BGMusic,75);
	MUS = result;
}

action blowLan
{
	_gib(20);
	actor_explode();
}

action Lantern
{
	my.event = blowLan;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	while (1)
	{
		my.lightrange = random(15) + 150;
		my.lightred = 128;
		my.lightgreen = 128;
		my.lightblue = 0;

		wait(1);
	}
}

action Clock
{
	while(1)
	{
		my.roll = my.roll + 6;
		waitt (16);
	}
}

action CamTarget
{
	my.skill22 = my.x;
	my.state = stateFIRE;
	my.skill30 = my.z;
	my.health = 346;

	cross_pos.x = -7;
	cross_pos.y = -7;

	pan_cross_show();

	player = my;

	while (1)
	{
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;

		my.pan = my.pan - mickey.x / SEN;
		my.tilt = my.tilt - mickey.y / SEN;

		if (my.tilt > 45) { my.tilt = 45; }
		if (my.tilt < -15) { my.tilt = -15; }

		camera.pan = my.pan;
		camera.tilt = my.tilt;
		camera.roll = my.roll / SEN;

		wait(1);
	}
}

function MoveRight
{
	if ((player.x + 25) < (player.skill22 + 200) && (player.state == stateFIRE)) { player.x = player.x + 25 * time; }
	CheckDuck();
}

function MoveLeft
{
	if ((player.x - 25) > (player.skill22 - 200) && (player.state == stateFIRE)) { player.x = player.x - 25 * time; }
	CheckDuck();
}

function CheckDuck()
{
	if ((player.x > (player.skill22 - 30)) && (player.x < (player.skill22 + 30))) 
	{ 
		DuckIcon.visible = on;
		DuckHere = 1;
	} 
	else
	{ 
		DuckIcon.visible = off;
		DuckHere = 0;
	}
}

action Handgun
{
	Death = 0;
	Piposh = my;
	my.near = on;

	while (1)
	{
		updatepanel();
		_player_intentions();

		if (key_force.x > 0) { MoveRight(); }
		if (key_force.x < 0 ) { MoveLeft(); }

		if (player.state == stateDUCK) { my.invisible = on; } else { my.invisible = off; }

		my.x = player.x; 

		if (FireLength > 0) 
		{ 
			LightOn(); 
			ent_frame ("Fire",100 - FireLength * 10); 
			FireLength = FireLength - 1; 
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

action Fire
{
	if ((FireLength == 0) && (player.state == stateFIRE) && (Bullets > 0))
	{
		PLAY_SOUND gun_wham,50;
		Bullets = Bullets - 1;
		FireLength = 10;
		CreateSpark();
	}
}

ACTION SparkHit
{
	if ((you == player) && (player.state == stateFIRE)) { player.Health = player.Health - DMG; }
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

ACTION Spark2
{
	my.passable = on;

	my.scale_x = 0.05;
	my.scale_y = 1;
	my.scale_z = 0.05;

	my.skill20 = 100;

	if (you == Shoresh)   { my.pan = shoresh.pan + 90; my.lightred = 255; my.y = my.y - 30; } 
	if (you == Kavechnik) { my.pan = kavechnik.pan + 90; my.lightblue = 255; my.lightgreen = 255; }

	my.lightrange = 20;

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

  	// my.near is set by the explosion
	while(MY.NEAR != ON)
	{
		wait(1); // wait at the loop beginning, to let it appear at the start position

		my.skill20 = my.skill20 - 1;
		if (my.skill20 < 0) { my.passable = off; }

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
		// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		move(ME,nullskill,fireball_speed);
	}
}

ACTION Spark3
{
	my.scale_x = 0.05;
	my.scale_y = 0.05;
	my.scale_z = 0.05;

	my.y = my.y - 30;

	my.lightgreen = 255;
	my.lightred = 255;
	my.lightblue = 255;

	my.lightrange = 20;

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
	//PLAY_SOUND gun_wham,50;
}

function CreateFire
{
	shot_speed.x = 20;
	shot_speed.y = 0;
	shot_speed.z = 0;
	my_angle.pan = my.pan;
	my_angle.tilt = my.tilt;
	my_angle.roll = my.roll;
	vec_rotate(shot_speed,my_angle);
	
	create(<Fireball.mdl>,my.x,Spark2);
	//PLAY_SOUND gun_wham,50;
}

function CreateFire2
{
	shot_speed.x = 20;
	shot_speed.y = 0;
	shot_speed.z = 0;
	my_angle.pan = my.pan;
	my_angle.tilt = my.tilt;
	my_angle.roll = my.roll;
	vec_rotate(shot_speed,my_angle);
	
	create(<Fireball.mdl>,my.x,Spark3);
	//PLAY_SOUND gun_wham,50;
}

action TableHit
{
	if (my.skill1 < 5)
	{
		my.skill2 = my.skill2 - 30;
		if (my.skill2 < 0) { my.skill1 = my.skill1 + 1; my.skill2 = 100; }
	}
	else { my.passable = on; }
}

action Table
{
	my.event = TableHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	my.skill1 = 0;
	my.skill2 = 100;

	while(1)
	{
		if (Cheat1 == 1) { my.skill1 = 5; my.passable = on; }
		ent_frame ("Phase",my.skill1 * 20);
		wait(1);
	}
}

action BadHit
{
	if (my.state != stateHIT)
	{
		my.state = stateHIT;
		my.duration = 10;
		my.health = my.health - pDMG;
		my.skill1 = 0;
	}
}

action BadGuy
{
	my.health = 251;
	my.event = BadHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	if (my.skill1 == 1) { RightBorder = my.x; Shoresh = my;}
	if (my.skill1 == 2) { LeftBorder = my.x; Kavechnik = my; }

	while(1)
	{
		if ((shoresh != null) && (kavechnik != null))
		{
			sHealth = 251 - shoresh.health;
			kHealth = 251 - kavechnik.health;
		}

		if ((my.health < 251) && (my.health > 0))
		{
			my.skill30 = my.skill30 + 1 * time;
			if (my.skill30 > 20) { my.health = my.health + 1; my.skill30 = 0; }
		}

		if (my.health < 0)
		{
			ent_frame ("Die",my.skill1);
			if (my.skill1 < 100) { my.skill1 = my.skill1 + 5; }
		}
		else
		{
			if (player.state == stateDUCK) { aim.z = player.z + 30; } else { aim.z = player.z; }

			//aim.pan = Piposh.pan;
			//aim.tilt = Piposh.tilt;
			//aim.roll = Piposh.roll;
			aim.x = Piposh.x;
			aim.y = Piposh.y;

			vec_set(temp,aim.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			if (my.duration < 0)
			{
				my.state = int(random(4));
				my.duration = random(100);
			}

			if ((Safe == 1) && (Cheat3 == 0)) { my.state = stateDUCK; } // Defend them while they cannot shoot

			my.duration = my.duration - 1;

			if (my.state == stateRUNRIGHT) 
			{ 
				if (Safe == 0) { Fire3(); }
				ent_cycle ("Right",my.skill1); 
				my.skill1 = my.skill1 + 3; 
				if (my.x < RightBorder) { my.x = my.x + 5*time; } else { my.state = stateFIRE; }
			}

			if (my.state == stateRUNLEFT) 
			{ 
				if (Safe == 0) { Fire3(); }
				ent_cycle ("Left",my.skill1); 
				my.skill1 = my.skill1 + 3; 
				if (my.x > LeftBorder) { my.x = my.x - 5*time; } else { my.state = stateFIRE; } 
			}

			if (my.state == stateHIT)
			{
				ent_frame ("Die",20);
			}

			if (my.state == stateDUCK) { ent_frame ("Duck",0); }
			if (my.state == stateFIRE) { ent_frame ("Stand",0); if (Safe == 0) { Fire3(); } }
		}

		wait(1);
	}
}

function Fire2
{
	if (Safe == 0)
	{
		if (my.state == stateFIRE) { if (int(random(20)) == 10) { CreateFire(); } } 
		else { if (int(random(50)) == 25) { play_entsound (my,LaserBeam,5000); CreateFire(); } }
	}
}

function Fire3
{
	if ((int(random(40)) == 20) && (Safe == 0)) { play_entsound (my,Matah,5000); CreateFire2(); }
}

action Fall
{
	my.skill4 = 100;
	my.y = my.y - 50;
	if (int(random(2)) == 1) { play_entsound (my,SoldierFall,5000); } else { play_entsound (my,SoldierFall2,5000); }
	while(my.skill4 > 0)
	{
		my.pan = my.pan + 90;
		my.skill4 = my.skill4 - 1;
		ent_frame("Fall",0);
		my.z = my.z - 30 * time;
		wait(1);
	}
	my.invisible = on;
	my.skill40 = 0;
	my.y = my.y + 50;
}

action Soldier
{
	my.invisible = on;
	my.skill1 = 0;
	my.skill3 = my.z;
	my.event = Fall;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	while (1)
	{
		if (Cheat2 == 1) { Fall(); }

		if (my.invisible == off)
		{
			if (Safe == 1) { ent_frame ("Fight",100); } else { ent_frame ("Fight",0); }

			my.state = stateFIRE;

			if (player.state == stateDUCK) { aim.z = player.z + 30; } else { aim.z = player.z; }

			aim.x = Piposh.x;
			aim.y = Piposh.y;

			vec_set(temp,aim.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			Fire3();
			//if (my.skill4 > 0) { my.pan = my.pan + 90; }
		}
		else
		{
			my.skill40 = my.skill40 + 1 * time;
			if (my.skill40 > 20)
			{
				if (int(random(600)) == 300) { my.z = my.skill3; my.invisible = off; }
			}
		}

		wait(1);
	}
}

on_mouse_left = Fire;
on_cud = Duck;
on_cuu = Duck;

action Duck
{
	if (DuckHere == 1)
	{
		if (player.state == stateFIRE) { player.state = stateDUCK; } else { player.state = stateFIRE; }

		if (player.state == stateFIRE) { player.z = player.skill30; }
		if (player.state == stateDUCK) { player.z = player.skill30 - 30; }
	}
}

action Chase
{
	my.skill3 = my.x;

	while(1)
	{
		my.x = my.x + 30 * time;
		if (my.skill1 == 1) { ent_Cycle ("Chase",my.skill2); } else { ent_cycle ("Run",my.skill2); }
		my.skill2 = my.skill2 + 5;
		if (my.x > (my.skill3 + 5000)) { my.x = my.skill3; }

		if ((my.x > (my.skill3 + 800)) && (my.x < (my.skill3 + 1800))) { Safe = 1; } else { Safe = 0; }

		wait(1);
	}
}

action Bullet
{
	while(1)
	{
		if ((my.invisible == on) && (Bullets == 0))
		{
			my.x = int(random(2));

			if (my.x == 0) { my.x = player.skill22 + random(180); } else { my.x = player.skill22 - random(180); }

			my.invisible = off;
		}

		if ((player.x > (my.x - 10)) && (player.x < (my.x + 10)) && (Bullets == 0)) { play_sound (Rearm,50); Bullets = 20; my.invisible = on; my.shadow = off; }
		my.pan = my.pan + 3 * time;
		wait(1);
	}
}

function cheat
{
	msg.pos_y = 60;
	msg.pos_x = 60;
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"earthquake") == 1) { msg.string = "cheat enabled"; show_message(); cheat1 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"airstrike") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"patriotism") == 1) { msg.string = "cheat enabled"; show_message(); Cheat3 = 1; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

on_tab = Cheat();