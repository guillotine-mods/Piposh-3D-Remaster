include <IO.wdl>;

define Anim,skill10;
define Speed,skill2;
define Hitting,skill3;
define HitType,skill15;
define Thrown,skill33;
define Health,skill17;
define hits,skill18;

synonym Opponent { type entity; }
synonym Player2 { type entity; }

string cheatstring = "                                                                          ";
string stringtemp = "                          ";

var BlahBlah = 0;
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; 	 // 16 bit colour D3D mode

var SkipDJ = 0;

var Intro = 0;
var FatZ = 0;
var Reloading;

var Holding = 0;

var Cheat1 = 0;
var Cheat2 = 0;
var Cheat3 = 0;

var AnimTemp;
var CurrentCamera = 1;
var CurrentCam = 1;
var Round;
var Shield = 0;
var GotHit = 0;
var TempHealth = 0;

var LoopCounter = 0;
var delay = 0;

var opphealth;
var piphealth;
var Death;

var Light = 1;
var LightDelay = 5;
var CONST_LENGTH = 380;
var TalkDelay;
var TalkFrame = 1;

bmap Back = <Horizon2.pcx>;
bmap bBlood = <Blood.bmp>;

var VSShow = 1;

//*** Panel ***
bmap bmpPanel1 = <PNL1.pcx>;
bmap bmpPanel2 = <PNL2.pcx>;
bmap bmpVS = <VS.pcx>;

//*** Piposh ***
bmap Piposh1 = <Piposh1.pcx>;
bmap Piposh2 = <Piposh2.pcx>;
bmap Piposh3 = <Piposh3.pcx>;
bmap Piposh4 = <Piposh4.pcx>;
bmap Piposh5 = <Piposh5.pcx>;
bmap Piposh6 = <Piposh6.pcx>;
bmap Piposh7 = <Piposh7.pcx>;

//*** Fatass ***
bmap Fatass1 = <Fatass1.pcx>;
bmap Fatass2 = <Fatass2.pcx>;
bmap Fatass3 = <Fatass3.pcx>;

//*** Chick ***
bmap Chick1 = <Chick1.pcx>;
bmap Chick2 = <Chick2.pcx>;
bmap Chick3 = <Chick3.pcx>;

//*** Yoyo ***
bmap Yoyo1 = <Yoyo1.pcx>;
bmap Yoyo2 = <Yoyo2.pcx>;
bmap Yoyo3 = <Yoyo3.pcx>;

//*** Capoeira ***
bmap Capo1 = <Capo1.pcx>;
bmap Capo2 = <Capo2.pcx>;
bmap Capo3 = <Capo3.pcx>;

//*** Bully ***
bmap Bully1 = <Bully1.pcx>;
bmap Bully2 = <Bully2.pcx>;
bmap Bully3 = <Bully3.pcx>;

panel Panel1
{
	layer = 0.5;
	bmap = bmpPanel1;
	flags = refresh,d3d,overlay;
	pos_y = 300;
}

panel Panel2
{
	layer = 0.5;
	bmap = bmpPanel2;
	flags = refresh,d3d,overlay;
	pos_y = 200;
}

panel Portrait1
{
	layer = 0.6;
	bmap = Fatass1;
	flags = refresh,d3d;
}

panel Portrait2
{
	layer = 0.6;
	bmap = Piposh1;
	flags = refresh,d3d;
}

panel VS
{
	layer = 0.5;
	bmap = bmpVS;
	flags = refresh,d3d,visible,overlay;
	pos_x = 180;
	pos_y = -200;
}

sound Bell = <SFX019.WAV>;

include <PWF.wdl>;

ENTITY FIGHT
{
	type = <FIGHT.mdl>;
	layer = 5;
	view = camera;
	x = 1000;
	y = 0;
	z = 0;
	flags = visible;
}

sound Hit1 = <SFX015.WAV>;
sound Hit2 = <SFX016.WAV>;
sound Hit3 = <SFX017.WAV>;
sound Hit4 = <SFX018.WAV>;
sound Hit5 = <SFX021.WAV>;

sound CheatSound = <SFX035.WAV>;

sound Chir = <SFX022.WAV>;

var CHR = 0;
var StageLoaded = 0;
var MUS;

sound Fell = <SFX020.WAV>;
//sound TamTam = <SFX112.WAV>;
sound TamTam = <SNG033.WAV>;


/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	StageLoaded = 0;
	wait(3);

	freeze_mode = 2;
	load_level(<Fight.WMB>);
	freeze_mode = 0;

	BlahBlah = 0;
	Reloading = 0;

	varLevelID = _VILLAGE;

	warn_level = 0;
	tex_share = on;
	clip_range = 10000;
	StageLoaded = 1;
	if (SkipDJ == 0) { Intro = 0; VSShow = 1; TalkFrame = 1; HealthBar.visible = off; VSImage.visible = off; }
	FatZ = 0;
	OppZ = 0;
	VS.pos_x = 180;
	VS.pos_y = -200;
	VS.visible = on;

	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	VoiceInit();
	Initialize();

	scene_map = Back;

	stop_sound (MUS);
}

function _player_intentions()
{
// Set the angular forces according to the player intentions
	aforce.PAN = -astrength.PAN*(KEY_FORCE.X+JOY_FORCE.X);
	aforce.TILT = astrength.TILT*(KEY_PGUP-KEY_PGDN);
	if(MOUSE_MODE == 0)
	{	// Mouse switched off?
		 aforce.PAN += -astrength.PAN*MOUSE_FORCE.X*mouseview*(1+KEY_SHIFT);
		 aforce.TILT += astrength.TILT*MOUSE_FORCE.Y*mouseview*(1+KEY_SHIFT);
	}
	aforce.ROLL = 0;
// Set ROLL force if ALT was pressed
	if(KEY_ALT != 0)
	{
		aforce.ROLL = aforce.PAN;
		aforce.PAN = 0;
	}

// Limit the forces in case the player
// pressed buttons, mouse and joystick simultaneously
	limit.PAN = 2*astrength.PAN;
	limit.TILT = 2*astrength.TILT;
	limit.ROLL = 2*astrength.ROLL;

	if(aforce.PAN > limit.PAN) {  aforce.PAN = limit.PAN; }
	if(aforce.PAN < -limit.PAN) {  aforce.PAN = -limit.PAN; }
	if(aforce.TILT > limit.TILT) {  aforce.TILT = limit.TILT; }
	if(aforce.TILT < -limit.TILT) {  aforce.TILT = -limit.TILT; }
	if(aforce.ROLL > limit.ROLL) {  aforce.ROLL = limit.ROLL; }
	if(aforce.ROLL < -limit.ROLL) {  aforce.ROLL = -limit.ROLL; }

// Set the cartesian forces according to the player intentions
	force.X = strength.X*(KEY_FORCE.Y+JOY_FORCE.Y);  // forward/back
	force.Y = strength.Y*(KEY_FORCE.X);     // side to side
	force.Z = strength.Z*(KEY_HOME-KEY_END);         // up and down
	if(MOUSE_MODE == 0)
	{	// Mouse switched off?
		force.X += strength.X*MOUSE_RIGHT*mouseview;
	}

// Limit the forces in case the player tried to cheat by
// operating buttons, mouse and joystick simultaneously
	limit.X = strength.X;
	limit.Y = strength.Y;
	limit.Z = strength.Z;

	if(force.X > limit.X) {  force.X = limit.X; }
	if(force.X < -limit.X) { force.X = -limit.X; }
	if(force.Y > limit.Y) {  force.Y = limit.Y; }
	if(force.Y < -limit.Y) { force.Y = -limit.Y; }
	if(force.Z > limit.Z) {  force.Z = limit.Z; }
	if(force.Z < -limit.Z) { force.Z = -limit.Z; }
}

action Cam
{
	my.skill5 = 0;

	while ((player == null) || (opponent == null)) { wait(1); }
	wait(1);

	while ((player.health > 0) && (opponent.health > 0))
	{
		if (VSShow == 0)
		{
			if (snd_playing(CHR) == 0) { play_sound (Chir,30); CHR = result; }
			if (Intro >= CONST_INTRO)
			{
				if (my.skill5 < 100)
				{
					FIGHT.pan = FIGHT.pan + 10 * time;
					FIGHT.x = FIGHT.x - 10 * time;
					my.skill5 = my.skill5 + 3 * time;
				}
			}
	
			updatepanel();
			if (my.skill2 < 0) { if (int(random(300)) == 150) { CurrentCamera = int(random(3)) + 1; my.skill2 = 200; } }
			my.skill2 = my.skill2 - 3 * time;
	
			if (CurrentCamera == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.pan = my.pan;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
			}
		}

		wait(1);
	}
}

action WinCam
{
	my.skill11 = 0;
	Reloading = 0;
	msg.visible = off;

	while(1)
	{
		if ((player.health <= 0) || (opponent.health <= 0))
		{
			updatepanel();

			if (player.health <= 0)
			{
				pWinLose.bmap = YouLose;
				if (pWinLose.visible == off) { pWinLose.alpha = 0; }
				vec_set(temp,player.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
			}
			else
			{
				SkipDJ = 0;

				Village[Round - 1] = 1;
				WriteGameData(0);

				pWinLose.bmap = YouWin;
				if (pWinLose.visible == off) { pWinLose.alpha = 0; }
				vec_set(temp,opponent.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
			}

			pWinLose.visible = on;
			if (pWinLose.alpha < 100) { pWinLose.alpha = pWinLose.alpha + 0.3 * time; }

			my.x = my.x - 3 * time;

			if (CurrentCam == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.pan = my.pan;
				camera.tilt = my.tilt;
				camera.roll = my.roll;

				my.skill12 = my.skill12 + 1 * time;
				if (my.skill12 > 40)
				{
					my.skill12 = 0;
					if (CurrentCam == 1) { CurrentCam = 2; } else { CurrentCam = 1; }
				}
			}

			my.skill11 = my.skill11 + 1 * time;
			if (pWinLose.alpha >= 100)
			{
				if (player.health <= 0)
				{
					if (Death == 0)
					{
						Death = 1;
						ShowRIP();
					}
				}

				else
				{
					if (Round == 5)
					{
						Run ("VilEnd.exe");
					}
					else
					{
						if (Reloading == 0) { Reloading = 1; msg.string = "loading, please wait..."; msg.pos_x = 230; msg.pos_y = 220; msg.visible = on; main(); }
					}
				}
			}
		}

		wait(1);
	}
}

action PickMeUp
{
	if (Holding == 0) 
	{
		if (you == player) { my.skill1 = 1; my.skill10 = player.pan; Holding = 1; }
	}
}

action Pickup
{
	while ((player == null) || (opponent == null)) { wait(1); }

	my.pan = random(360);

	var Active;
	Active = int(random(6));

	if (Active == 3)
	{
		my.invisible = off;
		my.passable = off;
		my.shadow = on;
	}
	else
	{
		my.invisible = on;
		my.passable = on;
		my.shadow = off;
	}

	my.event = PickMeUp;
	my.enable_entity = on;
	my.enable_impact = on;
	my.enable_push = on;

	my.skill1 = 0;

	while(1)
	{
		if (my.skill1 == 1)
		{
			if (Holding == 0) { DestroyPickup(); }

			if (Holding == 1)
			{
				my.x = player.x;
				my.y = player.y;
				my.z = player.z + my.skill3;
				my.skill20 = 20;
			}

			if (Holding == 2)
			{
				my.skill40 = my.skill40 + 1 * time;
				if (my.skill40 > 10) { DestroyPickup(); }

				force.x = 20;

				//my.skill40 = my.skill40 - 1 * time;

				my.pan = my.skill10;

				scan_floor();
				move_gravity();
				actor_anim();

				my.z = my.z + my.skill20;
				my.skill20 = my.skill20 - 3 * time;

				if ((abs(my.x - opponent.x) < 50) && (abs(my.y - opponent.y) < 50)) { opponent.health = opponent.health - 20; shedblood (2); opponent.hits = 5; DestroyPickup(); }
			}
		}

		wait(1);
	}
}

function DestroyPickup
{
	Holding = 0;
	actor_explode();
}

ACTIoN Cheer
{
	while (1)
	{
		if (Round >= my.skill1) { my.invisible = on; } else { my.invisible = off; }
		my.anim = my.anim + 10;
		ent_cycle ("Cheer",my.anim);
		if my.anim > 1000 { my.anim = 1; }
		wait (1);
	}
}	

function StompPlayer
{
	dist.x = 2;  	// dx = vx * dt
	dist.y = 0;     // dy = vy * dt
	dist.z = 0;                      // dz = 0  (only gravity and jumping)

	// calculate absolute distance to move
	absdist.x = absforce.x * TIME * TIME;   // dx = ax*dt^2
	absdist.y = absforce.y * TIME * TIME;   // dy = ay*dt^2
	absdist.z = MY._SPEED_Z * TIME;         // dz = vz*dt

	move(opponent,dist,absdist);
}

function Round1
{
	if (opponent == null) { wait(1); }
		if (opponent.hitting == 0) { 
		{
			if (int(Random(20)) > 14)
			{
				opponent.hittype = 2;
			}
			else
			{
				opponent.hittype = 1;
			}
			opponent.hitting = 1; 
			opponent.skill21 = 0; 
			opponent.skill20 = opponent.z; 
		}
	}
}

function Round2
{
	if (opponent == null) { wait(1); }
		if (opponent.hitting == 0) { 
		{
			if (Random(2) > 1) { opponent.hittype = 2; } else { opponent.hittype = 1; }
			opponent.hitting = 1; 
			opponent.skill21 = 0; 
			opponent.skill20 = opponent.z; 
		}
	}
}

function CheckHit
{
	if (Round == 1)
	{
		if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { Holding = 0; HitSound(); ThrowPlayer2(); }
	}

	if (Round == 2)
	{
		if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { Holding = 0; HitSound(); ThrowPlayer(1); }

	}

	if (Round == 3) { Holding = 0; ThrowPlayer(1); }

	if (Round == 4)
	{
		if (opponent.health > 0) 
		{
			if (player.health) > 0 { player.Health = player.health / 2; shedblood (1); }
			Holding = 0; HitSound(); ThrowPlayer(0);
		}
	}

	if (Round == 5)
	{
		if (opponent.health > 0) 
		{
			player.health = player.health - (int(Random(150)) + 50); shedblood (1);
			Holding = 0; HitSound(); ThrowPlayer(0);
		}
	}
}

function ThrowPlayer(XX)
{
	my = player;
	player.thrown = 0;
	while (player.thrown < 101) 
	{
		dist.x = -2;
		dist.y = 0;
		dist.z = 0;

		absdist.x = absforce.x * TIME * TIME;
		absdist.y = absforce.y * TIME * TIME;
		absdist.z = MY._SPEED_Z * TIME;

		move(player,dist,absdist);
		player.thrown = player.thrown + 6 * time;
		ent_frame ("hit",player.thrown);
		wait(1);
		player.skill39 = 0;

		if (int(player.thrown) > 100) 
		{ 
			if (XX == 1) 
			{ 
				if (opponent.health > 0) 
				{
					play_entsound (my,fell,1000);
					if (Round == 1) { player.Health = player.Health - (int(Random(70)) + 30); shedblood (1); }
					if (Round == 2) { player.Health = player.Health - (int(Random(50)) + 40); shedblood (1); }
					if (Round == 3) { player.Health = player.Health - (int(Random(50)) + 40); shedblood (1); }
				}
			}
			while (player.skill39 < 100) { ent_frame ("hit",100); player.skill39 = player.skill39 + 5; wait(1); }
			while ((player.health > 0) && (player.skill39 < 200) && (player.skill39 >= 100)) 
			{
				ent_frame ("getup",player.skill39-100); 
				player.skill39 = player.skill39 + 5; 
				wait(1); 
			}
			if (player.health <= 0) { while(1) { wait(1); } }
		}
	}

	player.thrown = 0;
}

function ThrowPlayer2
{
	my = player;
	player.thrown = 0;

	while (player.thrown < 101) 
	{
		dist.x = -2;
		dist.y = 0;
		dist.z = 0;

		// calculate absolute distance to move
		absdist.x = absforce.x * TIME * TIME;
		absdist.y = absforce.y * TIME * TIME;
		absdist.z = MY._SPEED_Z * TIME;

		move(player,dist,absdist);
		player.thrown = player.thrown + 6 * time;
		ent_frame ("thrown",player.thrown);
		wait(1);
		player.skill39 = 0;

		if (int(player.thrown) > 100) 
		{
			if (opponent.health > 0) 
			{
				player.health = player.health - (int(Random(70)) + 30); shedblood (1);
				play_entsound (my,fell,1000);
				while (player.skill39 < 100) { ent_frame ("thrown",100); player.skill39 = player.skill39 + 5; wait(1); }
				if (player.health <= 0) { while(1) { wait(1); } }
			}
		}
	}

	player.thrown = 0;
}

action DJ
{
	wait(3);

	while(1)
	{
		ent_cycle ("Shuffle",my.skill1);
		my.skill1 = my.skill1 + 5;
		wait(1);
	}
}

action Native
{
	my.skill1 = my.y;
	my.skill5 = my.tilt;
	
	if (my.skill2 == 1)
	{
		if (Round == 2) { morph (<Fatass.mdl>,my); }
		if (Round == 3) { morph (<Chick.mdl>,my); }
		if (Round == 4) { morph (<Yoyo.mdl>,my); }
		if (Round == 5) { morph (<Capoeira.mdl>,my); }

		if (Round > 1) { my.tilt = my.skill5 + 90; my.scale_x = 0.7; my.scale_y = 0.7; my.scale_z = 0.7; }
	}

	while(1)
	{
		if (VSShow == 0)
		{
			ent_cycle ("Run",my.skill1);
			my.skill1 = my.skill1 + 5;
			my.y = my.y - 10 * time;
		}
		wait(1);
	}
}

action Pot
{
	if (Round > my.skill1) { my.invisible = off; } else { my.invisible = on; }
}

function cheat
{
	msg.pos_y = 450;
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"iron fist") == 1) { msg.string = "cheat enabled"; show_message(); cheat1 = 1; play_sound (CheatSound,100); }	
	if (str_cmpi (cheatstring,"anvil from hell") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }	
	if (str_cmpi (cheatstring,"medusa head") == 1) { msg.string = "cheat enabled"; show_message(); Cheat3 = 300; play_sound (CheatSound,100); }	
	str_cpy (cheatstring,"");
}

on_tab = Cheat();

function HitSound
{
	Var HitSS;
	HitSS = int(random(5)) + 1;	
	
	if (HitSS == 1) { play_entsound (my,Hit1,1000); }
	if (HitSS == 2) { play_entsound (my,Hit2,1000); }
	if (HitSS == 3) { play_entsound (my,Hit3,1000); }
	if (HitSS == 4) { play_entsound (my,Hit4,1000); }
	if (HitSS == 5) { play_entsound (my,Hit5,1000); }
}

action Anvil
{
	wait(1);
	my.invisible = on;
	my.shadow = off;

	while(1)
	{
		if (snd_playing(MUS) == 0) { play_sound (TamTam,40); MUS = result; }

		my.x = opponent.x;
		my.y = opponent.y;

		if (Cheat2 == 1)
		{
			my.invisible = off;
			my.shadow = on;

			if (my.z > opponent.z + 70) 
			{ 
				my.z = my.z - 50 * time;
			} 
			else 
			{ 
				opponent.health = 0; 
				opponent.invisible = on; 
				opponent.shadow = off;
				opponent.x = my.x; 
				opponent.y = my.y; 
			}
		}
		
		wait(1);
	}
}

action DJ2
{
	wait(3);

	player2 = my;

	while(1)
	{
		if (VSShow == 1)
		{
			SkipDJ = 1;

			if (TalkFrame == 1)
			{
				if (int(random(10)) == 5) { ent_frame ("Talk",int(random(5)) * 25); }
				Talk();
			}
			else
			{
				ent_cycle ("Shuffle",my.skill1);
				my.skill1 = my.skill1 + 30 * time;
				Blink();
			}
		}

		wait(1);
	}
}

action intCam
{
	my.skill1 = 0;
	while (player2 == null) { wait(1); }

	while(1)
	{

	while (Reloading != 0) { wait(1); }

	if (VSShow == 1)
	{
		my._movemode = 1;

		if (Round == 1) { sPlay ("WWF001.WAV"); }
		if (Round == 2) { sPlay ("WWF003.WAV"); }
		if (Round == 3) { sPlay ("WWF004.WAV"); }
		if (Round == 4) { sPlay ("WWF005.WAV"); }
		if (Round == 5) { sPlay ("WWF006.WAV"); }

		Panel1.pos_x = 800;
		Panel2.pos_x = -CONST_LENGTH;

		Panel1.visible = on;
		panel2.visible = on;

		Portrait1.pos_x = 835;
		Portrait1.pos_y = 315;
		Portrait2.pos_x = -CONST_LENGTH + 95;
		Portrait2.pos_y = 215;

		Portrait1.visible = on;
		Portrait2.visible = on;

		SelectPortrait();

		my.skill1 = 0;
		my.skill2 = my.z;
		my.invisible = on;
		my.passable = on;

		actor_init();

		// attach next path
		temp.pan = 360;
		temp.tilt = 180;
		temp.z = 1000;
		result = scan_path(my.x,temp);
		if (result == 0) { my._MOVEMODE = 0; }	// no path found

		// find first waypoint
		ent_waypoint(my._TARGET_X,1);

		while (my._MOVEMODE > 0)
		{
			// find direction
			temp.x = MY._TARGET_X - MY.X;
			temp.y = MY._TARGET_Y - MY.Y;
			temp.z = 0;
			result = vec_to_angle(my_angle,temp);

			force = 3;

			// near target? Find next waypoint
			// compare radius must exceed the turning cycle!
			if (result < 25) { ent_nextpoint(my._TARGET_X); }

			// turn and walk towards target
			actor_turnto(my_angle.PAN);
			actor_move();
			my.z = my.skill2;

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			vec_set(temp,player2.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);

			if (my.skill1 < CONST_LENGTH/2)
			{
				Panel1.pos_x = Panel1.pos_x - 2;
				Panel2.pos_x = Panel2.pos_x + 2;
				Portrait1.pos_x = Portrait1.pos_x - 2;
				Portrait2.pos_x = Portrait2.pos_x + 2;
				my.skill1 = my.skill1 + 1;
			}
			else { if (VS.pos_y < 220) { VS.pos_y = VS.pos_y + 15 * time; } }

			if (VS.pos_y >= 220)
			{
				if (GetPosition(Voice) >= 1000000)
				{
					TalkFrame = TalkFrame + 1;

					if (Round < 5) { if (TalkFrame == 4) { VSShow = 0; VSImage.visible = on; HealthBar.visible = on; VS.visible = off; Panel1.visible = off; Panel2.visible = off; Portrait1.visible = off; Portrait2.visible = off; my._movemode = 0; } }
					if (Round == 5) { if (TalkFrame == 5) { VSShow = 0; VSImage.visible = on; HealthBar.visible = on; VS.visible = off; Panel1.visible = off; Panel2.visible = off; Portrait1.visible = off; Portrait2.visible = off; my._movemode = 0; } }

					if (Round == 1) 
					{ 
						if (TalkFrame == 2) { sPlay ("FIG001.WAV"); }
						if (TalkFrame == 3) { sPlay ("PIP122.WAV"); }
					}
	
					if (Round == 2) 
					{ 
						if (TalkFrame == 2) { sPlay ("FIG002.WAV"); }
						if (TalkFrame == 3) { sPlay ("PIP123.WAV"); }
					}
	
					if (Round == 3) 
					{ 
						if (TalkFrame == 2) { sPlay ("FIG003.WAV"); }
						if (TalkFrame == 3) { sPlay ("PIP124.WAV"); }
					}

					if (Round == 4) 
					{ 
						if (TalkFrame == 2) { sPlay ("FIG004.WAV"); }
						if (TalkFrame == 3) { sPlay ("PIP125.WAV"); }
					}

					if (Round == 5) 
					{ 
						if (TalkFrame == 2) { sPlay ("PIP126.WAV"); }
						if (TalkFrame == 3) { sPlay ("FIG005.WAV"); }
						if (TalkFrame == 4) { sPlay ("PIP127.WAV"); }
					}
				}

				if (Round < 5) { if (TalkFrame == 2) { OppTalk(); } if (TalkFrame == 3) { PiposhTalk(); } }
				else { if ((TalkFrame == 2) || (TalkFrame == 4)) { PiposhTalk(); } if (TalkFrame == 3) { OppTalk(); } }

				if (GetPosition(Voice) >= 1000000) { TalkFrame = TalkFrame + 1; }
			}


			// Wait one tick, then repeat
			wait(1);
			}
		}
		wait(1);
	}
}

action LightX
{
	my.lightred = my.skill1;
	my.lightgreen = my.skill2;
	my.lightblue = my.skill3;

	my.invisible = on;

	while(1)
	{
		LightDelay = LightDelay - 1 * time;
		if (LightDelay < 0) { LightDelay = 5; Light = int(random(3)) + 1; }

		if (my.skill4 == Light) { my.lightrange = 200; } else { my.lightrange = 0; }

		wait(1);
	}
}

function SelectPortrait
{
	if (Round == 1) { Portrait1.bmap = Fatass1; }
	if (Round == 2) { Portrait1.bmap = Chick1; }
	if (Round == 3) { Portrait1.bmap = Yoyo1; }
	if (Round == 4) { Portrait1.bmap = Capo1; }
	if (Round == 5) { Portrait1.bmap = Bully1; }
}

function PiposhTalk
{
	TalkDelay = TalkDelay + 1 * time;
	if (TalkDelay > 1)
	{
		TalkDelay = 0;

		temp = int(random(7)) + 1;
		if (temp == 1) { Portrait2.bmap = Piposh1; }
		if (temp == 2) { Portrait2.bmap = Piposh2; }
		if (temp == 3) { Portrait2.bmap = Piposh3; }
		if (temp == 4) { Portrait2.bmap = Piposh4; }
		if (temp == 5) { Portrait2.bmap = Piposh5; }
		if (temp == 6) { Portrait2.bmap = Piposh6; }
		if (temp == 7) { Portrait2.bmap = Piposh7; }
	}
}

function OppTalk
{
	TalkDelay = TalkDelay + 1 * time;
	if (TalkDelay > 1)
	{
		TalkDelay = 0;

		temp = int(random(3)) + 1;
		if (temp == 1) 
		{ 
			if (Round == 1) { Portrait1.bmap = Fatass1; }
			if (Round == 2) { Portrait1.bmap = Chick1; }
			if (Round == 3) { Portrait1.bmap = Yoyo1; }
			if (Round == 4) { Portrait1.bmap = Capo1; }
			if (Round == 5) { Portrait1.bmap = Bully1; }
		}
		if (temp == 2) 
		{ 
			if (Round == 1) { Portrait1.bmap = Fatass2; }
			if (Round == 2) { Portrait1.bmap = Chick2; }
			if (Round == 3) { Portrait1.bmap = Yoyo2; }
			if (Round == 4) { Portrait1.bmap = Capo2; }
			if (Round == 5) { Portrait1.bmap = Bully2; }
		}
		if (temp == 3) 
		{ 
			if (Round == 1) { Portrait1.bmap = Fatass3; }
			if (Round == 2) { Portrait1.bmap = Chick3; }
			if (Round == 3) { Portrait1.bmap = Yoyo3; }
			if (Round == 4) { Portrait1.bmap = Capo3; }
			if (Round == 5) { Portrait1.bmap = Bully3; }
		}
	}
}

function bloodstream
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = 5 * (random(3) - 1);
		MY_SPEED.Y = 5 * (random(3) - 1);
		MY_SPEED.Z = random(5) + 15;

		MY_SIZE = random(200) + 200;
		MY_MAP = bBlood;
		MY_FLARE = ON;
		my_transparent = on;
		return;
	}
	// Add gravity
	MY_SPEED.Z -= 2;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	if(MY_AGE >= 2000)
	{
		MY_ACTION = NULL;
	}
}

function ShedBlood (which)
{
	if ((which == 1) && (player.health > 0)) { emit (20,player.x,bloodstream); }
	if ((which == 2) && (opponent.health > 0)) { emit (20,opponent.x,bloodstream); }
}

function Talk()
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

function Blink2()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}