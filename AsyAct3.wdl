include <IO.wdl>;

bmap bPNL = <AsyPNL.pcx>;
bmap bBar1 = <AsyBar1.pcx>;
bmap bBar2 = <AsyBar2.pcx>;

sound CheatSound = <SFX035.WAV>;

sound Scream = <SFX136.WAV>;
var SCRM = 0;
var Done = 0;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

var Health = 110;
var Batts = 110;

bmap NVision = <NVision.pcx>;

panel NightV
{
	bmap = NVision;
	flags = refresh,d3d,transparent;
	layer = 5;
}

panel pPanel
{
	layer = 2;
	bmap = bPNL;
	window 7,43,8,110,bBar2,0,Batts;
	window 7,242,8,110,bBar1,0,Health;
	flags = refresh,d3d,overlay,visible;
}

sound sMAD01 = <MAD001.WAV>;
sound sMAD02 = <MAD002.WAV>;
sound sMAD03 = <MAD003.WAV>;
sound sMAD04 = <MAD004.WAV>;
sound sMAD05 = <MAD005.WAV>;
sound sMAD06 = <MAD006.WAV>;
sound sMAD07 = <MAD007.WAV>;
sound sMAD08 = <MAD008.WAV>;
sound sMAD09 = <MAD009.WAV>;
sound sMAD10 = <MAD010.WAV>;
sound sMAD11 = <MAD011.WAV>;
sound sMAD12 = <MAD012.WAV>;
sound sMAD13 = <MAD013.WAV>;
sound sMAD14 = <MAD014.WAV>;
sound sMAD15 = <MAD015.WAV>;
sound sMAD16 = <MAD016.WAV>;
sound sMAD17 = <MAD017.WAV>;
sound sMAD18 = <MAD018.WAV>;
sound sMAD19 = <MAD019.WAV>;

sound Bang = <SFX131.WAV>;
sound Matka = <SFX132.WAV>;
sound Baseball = <SFX133.WAV>;
sound Zap = <SFX134.WAV>;

sound BGMusic = <SNG023.WAV>;

sound DOC1 = <DOC001.WAV>;
sound DOC2 = <DOC002.WAV>;
sound DOC3 = <DOC003.WAV>;
var DOC = 0;
var Opening = 0;

var RANGE = 200;

var Cheat1 = 0;
string cheatstring = "                                 ";

define CurrentInv,skill4;
define Anim,skill10;
define Speed,skill2;
define Floor,skill3;
define Path,skill5;
define Pushed,skill6;
define percent,skill15;
define PrevX,skill7;
define PrevY,skill9;
define T,skill4;
define XCheck,skill11;
define YCheck,skill14;
define ZCheck,skill20;
define Shocked,skill30;

Synonym MadX { type entity; }

synonym Pool { type entity; }
SYNONYM test_actor { TYPE entity; }
SYNONYM ent_marker { TYPE ENTITY; }	// marker entity, used in hunting
SYNONYM TempSyn { TYPE ENTITY; }

SYNONYM door1 { TYPE entity; }
SYNONYM door2 { TYPE entity; }
SYNONYM door3 { TYPE entity; }
SYNONYM door4 { TYPE entity; }
SYNONYM door5 { TYPE entity; }
SYNONYM door6 { TYPE entity; }

SYNONYM sdoor1 { TYPE entity; }
SYNONYM sdoor2 { TYPE entity; }
SYNONYM sdoor3 { TYPE entity; }
SYNONYM sdoor4 { TYPE entity; }
SYNONYM sdoor5 { TYPE entity; }
SYNONYM sdoor6 { TYPE entity; }

SYNONYM Mad1 { TYPE entity; }
SYNONYM Mad2 { TYPE entity; }
SYNONYM Mad3 { TYPE entity; }
SYNONYM Mad4 { TYPE entity; }
SYNONYM Mad5 { TYPE entity; }
SYNONYM Mad6 { TYPE entity; }
SYNONYM Mad7 { TYPE entity; }
SYNONYM Mad8 { TYPE entity; }
SYNONYM Mad9 { TYPE entity; }
SYNONYM Mad10 { TYPE entity; }

define n,skill8;

var TargetX [11];
var TargetY [11];
var TargetZ [11];

var DoorCount = 0;
var Pulkes = 20;
var Coins = 0;
var InCell = 0;

var Counter = 0;
var Phase = 0;

var XCheck;
var YCheck;
var Delay;
var BatCount = 0;

/*
var CellX1 = -559;
var CellX2 =  763;
var CellY1 =  529;
var CellY2 = -710;
var CellZ1 =  -25;
var CellZ2 =  115;
*/

var CellX1 [2];
var CellY1 [2];

var CellX2 [2];
var CellY2 [2];

var CellZ1 [2];
var CellZ2 [2];

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode

var percent = 0;
var factor = 0;
var MyWeapon = 2;

var filehandle;
string tempstring = "                                                 ";
var cameratemp[3] = 0,0,0;

var cameraX[9] = 1557.189,1771.000,1558.198,2545.821,3367.745,2667.000,-440.022,279.866,423.612;
var cameraY[9] = -180.094,156.417,651.000,641.485,-43.302,-383.107,-473.489,-8.625,621.263;

var TX [14] = 3667.512,2687.335,2986.185,2677.775,1588.571,623.720,255.457,-543.193,647.006,1616.667,1458.166,1570.927,1648.675,1773.997;
var TY [14] = -444.659,-318.102,130.646,541.199,622.389,603.049,-80.166,-425.846,-413.218,192.465,72.330,-252.182,95.993,-260.105;

var CameraEnabled = 1;
var MoviePlaying = 0;
var Movie = 0;
var TalkFrame = 0;

var invpos[3] = 20,20,20;
string MyInv,"                              ";
var MyStuff[10];
string ItemName,"                                                                      ";
var NumInv = 0;

var CS = 100;

entity Weapon
{
	type = <Bat.mdl>;
	layer = 3;
	flags = visible;
	view = camera;
	x = 100;
	y = -30;
	z = -53;
	roll = 10;
}

var PrevX;
var PrevY;
var PrevZ;

var TempX;
var TempY;
var TempZ;
var TempVec[3] = 0,0,0;
var Loop = 0;

var delay = 0;

var n = 1;
var closest = 0;

text InventoryName 
{
	layer = 5;
	pos_X = 340;
	pos_y = 380;
	font = standard_font;
	string = "              I've got nothing              ";
	flags = center_x;
}

sound Alarm2 = <ALR004.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _ASYLUM;

	warn_level = 0;
	tex_share = on;
	clip_range = 3000;
	
	load_level(<AsyAct3.WMB>);

	VoiceInit();
	Initialize();

	Cheat1 = 0;
	NightV.visible = off;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	play_loop (BGMusic,75);

	Health = 110;
	Batts = 110;
}

action Dummy
{
	my.invisible = on;
	my.passable = on;

	if (my.skill1 == 1) { CellX1[0] = my.x; CellY1[0] = my.y; CellZ1[0] = my.z; }
	if (my.skill1 == 2) { CellX2[0] = my.x; CellY2[0] = my.y; CellZ2[0] = my.z; }
	if (my.skill1 == 3) { CellX1[1] = my.x; CellY1[1] = my.y; CellZ1[1] = my.z; }
	if (my.skill1 == 4) { CellX2[1] = my.x; CellY2[1] = my.y; CellZ2[1] = my.z; }
}

action IntroCam
{
	while(1)
	{
		if (MoviePlaying == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;

			if (GetPosition (Voice) >= 1000000) { MoviePlaying = 0; }
		}

		wait(1);
	}
}

ACTION player_move2
{
	MoviePlaying = 1;
	sPlay ("ALR003.WAV");

	while (MoviePlaying == 1) { wait(1); }

	sPlay ("ALR002.WAV");

	if(MY.CLIENT == 0) { player = ME; } // created on the server?

	MY._TYPE = _TYPE_PLAYER;
	MY.ENABLE_SCAN = ON;	// so that enemies can detect me
	if((MY.TRIGGER_RANGE == 0) && (MY.__TRIGGER == ON)) { MY.TRIGGER_RANGE = 32; }

	if(MY._FORCE == 0) {  MY._FORCE = 1.5; }
	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }

	anim_init();      // init old style animation
	perform_handle();	// react on pressing the handle key


	// while we are in a valid movemode
	while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		// if we are not in 'still' mode
		if(MY._MOVEMODE != _MODE_STILL)
		{
			BatCount = BatCount + 1 * time;
			if (BatCount > 2) { if (Batts < 110) { Batts = Batts + 1; BatCount = 0; } }

			// Get the angular and translation forces (set aforce & force values)
			_player_force();

			// find ground below (set my_height, my_floornormal, & my_floorspeed)
			scan_floor();

			// if they are on or in a passable block...
			if( ((ON_PASSABLE != 0) && (my_height_passable < -MY.MIN_Z + 5)) || (IN_PASSABLE != 0) )
			{

				// if not already swimming or wading...
				if((MY._MOVEMODE != _MODE_SWIMMING) && (MY._MOVEMODE != _MODE_WADING))
				{
  					play_sound(splash,50);
  					MY._MOVEMODE = _MODE_SWIMMING;

					// stay on/near surface of water
					MY._SPEED_Z = 0;
  				}

				// if swimming...
  				if(MY._MOVEMODE == _MODE_SWIMMING) // swimming on/in a passable block
				{
					if(ON_PASSABLE == ON) // && (IN_PASSABLE != ON)) -> Not need with version 4.193+
					{
						// check for wading
						temp.X = MY.X;
    					temp.Y = MY.Y;
    		  			temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?
						trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
						trace(MY.POS,temp);

						if(RESULT > 0)
						{
							// switch to wading
							MY._MOVEMODE = _MODE_WADING;
 				 			MY.TILT = 0;       // stop tilting
							my_height = RESULT + MY.MIN_Z;	// calculate wading height
						}

 					}

				}// END swimming on/in a passable block

				// if wading...
 				if(MY._MOVEMODE == _MODE_WADING) // wading on/in a passable block
				{
  					// check for swimming
					temp.X = MY.X;
    					temp.Y = MY.Y;
    					temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?

    				//SHOOT MY.POS,temp;  // NOTE: ignore passable blocks
					trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
					trace(MY.POS,temp);
					if(RESULT == 0)
					{
						// switch to swimming
						MY._MOVEMODE = _MODE_SWIMMING;
					}
					else	// use SOLID surface for height (can't walk on water)
					{
	 					my_height = RESULT + MY.MIN_Z;    // calculate wading height
 					}
				} // END wading on/in a passable block
	 		} // END if they are on or in a passable block...
			else  // not in or on a passable block
			{
				// if wading or swimming while *not* on/in a passable block...
				if((MY._MOVEMODE == _MODE_SWIMMING) || (MY._MOVEMODE == _MODE_WADING))
				{
					// get out of the water (go to walk mode)
					MY._MOVEMODE = _MODE_WALKING;
					MY.TILT = 0;       // stop tilting
				}
 			} // END not in or above water


  			// if he is on a slope, change his angles, and maybe let him slide down
			if(MY.__SLOPES == ON)
			{
				// Adapt the player angle to the floor slope
				MY_ANGLE.TILT = 0;
				MY_ANGLE.ROLL = 0;
				if((my_height < 10) && ((my_floornormal.X != 0) || (my_floornormal.Y != 0) ))
				{	// on a slope?
					// rotate the floor normal relative to the player
					MY_ANGLE.PAN = -MY.PAN;
					vec_rotate(my_floornormal,MY_ANGLE);
					// calculate the destination tilt and roll angles
					MY_ANGLE.TILT = -ASIN(my_floornormal.X);
					MY_ANGLE.ROLL = -ASIN(my_floornormal.Y);
				}
				// change the player angles towards the destination angles
				MY.TILT += 0.2 * ANG(MY_ANGLE.TILT-MY.TILT);
				MY.ROLL += 0.2 * ANG(MY_ANGLE.ROLL-MY.ROLL);
			}
			else
			{
				// If the ROLL angle was not equal to zero,
				// apply a ROLL force to set the angle back
				//jcl 07-08-00 fix loopings on < 3 fps systems
				MY.ROLL -= 0.2*ANG(MY.ROLL);
			}

			// Now accelerate the angular speed, and change his angles
			// -old method- ACCEL	MY._ASPEED,aforce,ang_fric;
			temp = max(1-TIME*ang_fric,0);     // replaced min with max (to eliminate 'creep')
			MY._ASPEED_PAN  = (TIME * aforce.pan)  + (temp * MY._ASPEED_PAN);    // vp = ap * dt + max(1-(af*dt),0)  * vp
			MY._ASPEED_TILT = (TIME * aforce.tilt) + (temp * MY._ASPEED_TILT);
			MY._ASPEED_ROLL = (TIME * aforce.roll) + (temp * MY._ASPEED_ROLL);

  			temp = MY._ASPEED_PAN * MY._SPEED_X * 0.05;
			if(MY.__WHEELS)
			{	// Turn only if moving ahead
				//jcl 07-03-00 patch to fix movement
				MY.PAN += temp * TIME;
			}
			else
			{
				MY.PAN += MY._ASPEED_PAN * TIME;
			}
			MY.ROLL += (temp * MY._BANKING + MY._ASPEED_ROLL) * TIME;

			// the head angle is only set on the player in a single player system.
			if (ME == player)
			{
				head_angle.TILT += MY._ASPEED_TILT * TIME;
				//jcl 07-03-00 end of patcht

				// Limit the TILT value
				head_angle.TILT = ang(head_angle.TILT);
				if(head_angle.TILT > 80) { head_angle.TILT = 80; }
				if(head_angle.TILT < -80) { head_angle.TILT = -80; }
			}

			// disable strafing
			if(MY.__STRAFE == OFF)
			{
				force.Y = 0;	// no strafe
			}


			// if swimming...
			if(MY._MOVEMODE == _MODE_SWIMMING)
			{
 				// move in water
  				swim_gravity();
			}
			else // not swimming
			{
			
				// if wading...
				if(MY._MOVEMODE == _MODE_WADING)
				{
					wade_gravity();
				}
				else // not swimming or wading (not in water)
				{
					// Ducking or crawling...
					if((MY._MOVEMODE == _MODE_DUCKING) || (MY._MOVEMODE == _MODE_CRAWLING))
					{
						if(force.Z >= 0)
						{
							MY._MOVEMODE = _MODE_WALKING;
						}
						else	// still ducking
						{
							// reduce height by ducking value
							my_height += duck_height;
						}

					}
					else  // not ducking or crawling
					{
						// if we have a ducking force and are not already ducking or crawling...
						if((force.Z < 0) && (MY.__DUCK == ON))		// dcp 7/28/00 added __DUCK
						{
							// ...switch to ducking mode
							MY._MOVEMODE = _MODE_DUCKING;
							MY._ANIMDIST = 0;
							force.Z = 0;
						}
					}

					// Decide whether the actor can jump or not. He can't if he is in the air
					if((jump_height <= 0)
						|| (MY.__JUMP == OFF)
						|| (my_height > 4)
						|| (force.Z <= 0))
					{
						force.Z = 0;
					}

					// move on land
					move_gravity();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		// If I'm the only player, draw the camera and weapon with ME
//		if(client_moving == 0) { move_view(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION Metal_Material
{
	MY.Metal = on;
}

ACTION player_walk2
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 1;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;
	my.trigger_range = 10;

	player_move2();
}

function camerapositionwrite
{
	filehandle = file_open_append("Camera.txt");
	file_str_write (filehandle, "X: ");
	file_var_write(filehandle,player.x);
	file_str_write (filehandle, "Y: ");
	file_var_write(filehandle,player.y);
	file_str_write (filehandle, "Z: ");
	file_var_write(filehandle,player.z);
	msg.string = "Camera coordinates written to file";
	show_message();
	file_close(filehandle);
}

function changeview
{
	if player.Skill1 == 1 {
		player.Skill1 = 2;
	}
	else {
		player.Skill1 = 1;
	}
}

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	while (1)
	{

	if CameraEnabled == 1
	{
		if MyStuff[1] == 0 { str_cpy (MyInv,"none"); }
		if(player == NULL) { player = ME; }	
		vec_set(temp,player.x);
		vec_sub(temp,camera.x);
		if player.skill1 == 1 { vec_to_angle(camera.pan,temp); }
		
		n = 0;		
		temp = 100000;

		if player.Skill1 == 1 {
	
		while (n < cameraX.length) {

			cameratemp.x = cameraX[n];
			cameratemp.y = cameraY[n];
		
			if vec_dist(cameratemp.x,player.x) < temp {
				temp = vec_dist (cameratemp,player.x);
				closest = n;
			}
		n = n + 1;
		}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];

			if ((cameratemp.x == 1557.189) && (cameratemp.y == -180.094) && (player.z > -159))
			{ 
				cameratemp.z = 181.254; 
			}
			else
			{
				if (player.z < -160) { cameratemp.x = 1887; cameratemp.y = 86; cameratemp.z = -254; }
				if ((player.z < 28) && (player.z > -150)) { cameratemp.z =  -49; }
				if ((player.z > 32) && (player.z < 145)) { cameratemp.z = 73; }
				if (player.z > 150) { cameratemp.z = 195; }
			}
			// this is the stairs room which is not set to Piposh's Z

			vec_set(camera.x, cameratemp);
		}
		else {
			move_view_1st();
		}
	}
	wait(1);
	}

}

ACTION Walkingtemp
{
	MY._FORCE = 10;
	MY.X = 30;
	MY.Y = 30;
	actor_move();
}

ACTION Metal_Material
{
	MY.Metal = on;
}

ACTION Paint_Pad_Skin
{
	MY.Skin = MY.SKILL1;
}

ACTION Hit
{
	if (MyWeapon == 1) { play_sound (Bang,100); my.Pushed = int(Random(10)+5); }	// Matka pushes in a force of 5-15
	if (MyWeapon == 2) { play_sound (Bang,100); my.Pushed = int(Random(20)+20); }	// Baseball bat pushes in a force of 20-40
	my.percent = 0;
	my.pan = player.pan;

//	if (int(Random(10)) == 5) { CreateCoin(); }

}

ACTION Blah
{
	ent_marker = my;
}

ACTION FreeRoam
{
	my.speed = random(6) + 2;
	my.Pushed = 0;
	my.enable_scan = on;
	my.event = Hit;

	factor = (Random (13)+1);
	TargetX [my.n] = TX [factor];
	TargetY [my.n] = TY [factor];

	if (my.skill8 == 1)  { Mad1 = my; }
	if (my.skill8 == 2)  { Mad2 = my; }
	if (my.skill8 == 3)  { Mad3 = my; }
	if (my.skill8 == 4)  { Mad4 = my; }
	if (my.skill8 == 5)  { Mad5 = my; }
	if (my.skill8 == 6)  { Mad6 = my; }
	if (my.skill8 == 7)  { Mad7 = my; }
	if (my.skill8 == 8)  { Mad8 = my; }
	if (my.skill8 == 9)  { Mad9 = my; }
	if (my.skill8 == 10) { Mad10 = my; }

	while (1)
	{
		if (Cheat1 == 1)
		{
			my.lightrange = 200;
			my.lightred = 0;
			my.lightgreen = 255;
			my.lightblue = 0;
		}

		if (my.Pushed <= 0 && my.Shocked <= 0)
		{
			talk();

			my.percent = my.percent + 10 * time;
			ent_cycle ("walk",my.percent);
	
			temp.X = TargetX[my.n] - MY.X;
			temp.Y = TargetY[my.n] - MY.Y;
			temp.Z = TargetZ[my.n] - MY.Z;
			vec_to_angle(MY_ANGLE,temp);
			MY._TARGET_PAN = MY_ANGLE.PAN;
	
		   // turn towards target
			MY_ANGLE.PAN = MY._TARGET_PAN;
			MY_ANGLE.TILT = 0;
			MY_ANGLE.ROLL = 0;
			force = my.speed;
			actor_turn();
	
			if ent_marker == null {wait (1); }
	
			test_actor = ent_marker;
	
			test_actor.x = TargetX[my.n];
			test_actor.y = TargetY[my.n];
			test_actor.z = TargetZ[my.n];
		
			SHOOT MY.POS, test_actor.POS;
	
			IF((YOU != test_actor) && (RESULT < 50))	// too close to a wall...
			{
				// angle away from the wall.
				temp.X = (TARGET.X + (100 * NORMAL.X)) - MY.X;
				temp.Y = (TARGET.Y + (100 * NORMAL.Y)) - MY.Y;
				temp.Z = MY.Z;
				TO_ANGLE MY_ANGLE, temp;
				force = my.speed;
				actor_turn();
			}

			temp = (TargetX[my.n] - MY.X)*(TargetX[my.n] - MY.X)+(TargetY[my.n] - MY.Y)*(TargetY[my.n] - MY.Y);
			// walk towards target only if not too close
			if(temp < 100) // 10^2
			{
		
				factor = (Random (13)+1);
				TargetX [my.n] = TX [factor];
				TargetY [my.n] = TY [factor];
			}

			// walk towards ent_marker
			force = my.speed;
			MY._MOVEMODE = _MODE_WALKING;
			actor_move();
	
			factor = Random (500);
			if (factor > 400)
			{
				factor = (Random (13)+1);
				TargetX [my.n] = TX [factor];
				TargetY [my.n] = TY [factor];
		
			}
		}

		if ((int(random(100)) == 50) && (snd_playing (my.skill45) == 0) && (my.shocked <= 0))
		{
			my.skill40 = int(random(19)) + 1;

			if (my.skill40 == 1 ) { play_entsound (my,smad01,RANGE); }
			if (my.skill40 == 2 ) { play_entsound (my,smad02,RANGE); }
			if (my.skill40 == 3 ) { play_entsound (my,smad03,RANGE); }
			if (my.skill40 == 4 ) { play_entsound (my,smad04,RANGE); }
			if (my.skill40 == 5 ) { play_entsound (my,smad05,RANGE); }
			if (my.skill40 == 6 ) { play_entsound (my,smad06,RANGE); }
			if (my.skill40 == 7 ) { play_entsound (my,smad07,RANGE); }
			if (my.skill40 == 8 ) { play_entsound (my,smad08,RANGE); }
			if (my.skill40 == 9 ) { play_entsound (my,smad09,RANGE); }
			if (my.skill40 == 10) { play_entsound (my,smad10,RANGE); }
			if (my.skill40 == 11) { play_entsound (my,smad11,RANGE); }
			if (my.skill40 == 12) { play_entsound (my,smad12,RANGE); }
			if (my.skill40 == 13) { play_entsound (my,smad13,RANGE); }
			if (my.skill40 == 14) { play_entsound (my,smad14,RANGE); }
			if (my.skill40 == 15) { play_entsound (my,smad15,RANGE); }
			if (my.skill40 == 16) { play_entsound (my,smad16,RANGE); }
			if (my.skill40 == 17) { play_entsound (my,smad17,RANGE); }
			if (my.skill40 == 18) { play_entsound (my,smad18,RANGE); }
			if (my.skill40 == 19) { play_entsound (my,smad19,RANGE); }

			my.skill45 = result;
		}

		if (my.Shocked > 0)
		{ 
			my.Shocked = my.Shocked - 1 * time; 
			if (my.Shocked < 0) { my.Shocked = 0; }
		}

		if (my.Pushed > 0)
		{ 
			ent_cycle ("hit",my.percent);
			my.percent = my.percent + 10 * time;
			force = my.Pushed;
			MY._MOVEMODE = _MODE_WALKING;
			actor_move();
			my.Pushed = my.Pushed - 1 * time;
			if ((my.x == my.prevX) || (my.y == my.prevY)) { my.Pushed = 0; }
			if (my.Pushed <= 0) { my.percent = 0; }
			my.prevX = my.x;
			my.prevY = my.y;
		}


	wait(1);
	}
}

function door_event2()
{
	_doorevent_check();
	if(RESULT) { BRANCH _door_swing2; }
}

function _door_swing2()
{
	if (Done == 1) { return; }

	if (door1 == NULL) { wait(1); }	
	if (door2 == NULL) { wait(1); }	
	if (door3 == NULL) { wait(1); }	
	if (door4 == NULL) { wait(1); }	
	if (door5 == NULL) { wait(1); }	
	if (door6 == NULL) { wait(1); }	

	MY.__MOVING = ON;

	if(MY.__GATE == ON)
	{
		if(MY.__SILENT == OFF) { PLAY_ENTSOUND ME,open_snd,66; }

		// open gate
		while(MY.__MOVING == ON)
		{
			wait(1);			// DcP - moved wait to the start of this block, before the __MOVING flag is set to OFF

			// calculate the 3D direction to move to
			MY._SPEED_X = MY._TARGET_X - MY.X;
			MY._SPEED_Y = MY._TARGET_Y - MY.Y;
			MY._SPEED_Z = MY._TARGET_Z - MY.Z;

			// check the distance to the target position, using pythagoras
			temp = MY._SPEED_X*MY._SPEED_X + MY._SPEED_Y*MY._SPEED_Y + MY._SPEED_Z*MY._SPEED_Z;

			// we have now the square of the distance to the target,
			// and must compare it with the square of the distance to move
			if(temp > MY._FORCE * TIME * MY._FORCE * TIME)
			{
				// if far, move with normal speed
				temp = MY._FORCE * TIME;
				vec_normalize(MY._SPEED,temp); // adjust the speed vector's length
			}
			else
			{	// if near, stop after moving the rest distance
				MY.__MOVING = OFF;
			}

  			move(ME,NULLSKILL,MY._SPEED);	// move in that direction

			// check to see if the door is stuck
			if(RESULT == 0)
			{
				// stop trying to move the gate
				break;
			}

			MY._SPEED_X = MY_SPEED.X;	// set the speed to the real distance covered
			MY._SPEED_Y = MY_SPEED.Y;	// for moving the player with the platform
			MY._SPEED_Z = MY_SPEED.Z;
		}

		MY._SPEED_X = 0;
		MY._SPEED_Y = 0;
		MY._SPEED_Z = 0;

		MY.__MOVING = OFF;

		// at end position, reverse the direction
		if(  (MY._TARGET_X == MY._ENDPOS_X)
			&&(MY._TARGET_Y == MY._ENDPOS_Y)
			&&(MY._TARGET_Z == MY._ENDPOS_Z))
		{
			MY._TARGET_X = MY._STARTPOS_X;
			MY._TARGET_Y = MY._STARTPOS_Y;
			MY._TARGET_Z = MY._STARTPOS_Z;

			// check to see if it closes automagically
			if(MY._PAUSE > 0)
			{
 				waitt(MY._PAUSE);
				BRANCH _door_swing;	// do it again
			}

		}
		else
		{
			MY._TARGET_X = MY._ENDPOS_X;
			MY._TARGET_Y = MY._ENDPOS_Y;
			MY._TARGET_Z = MY._ENDPOS_Z;

		}

		return; // END GATE movement
	}

	// check whether to open or to close
	if ((MY._CURRENTPOS < MY._ENDPOS) || (my.skill22 == 1)) // close door
	{
		if(MY.__SILENT == OFF) { PLAY_ENTSOUND ME,open_snd,66; }
		while (MY._CURRENTPOS < MY._ENDPOS) 
		{
			if(MY.__LID == ON)
			{
				MY.ROLL += MY._FORCE*TIME;
			}
			else
			{
				MY.PAN -= MY._FORCE*TIME;
			}
			MY._CURRENTPOS += ABS(MY._FORCE)*TIME;
			wait(1);
		}

		if (my.skill22 == 1)	// compansate for a bug
		{
			my.skill23 = my.pan;
			while (my.pan > my.skill23 - 180)
			{
				my.pan -= my._force * time;
				wait(1);
			}
		}

		my.skill22 = 0;

		if (my.skill8 == 1) { door1.passable = off; }
		if (my.skill8 == 2) { door2.passable = off; }
		if (my.skill8 == 3) { door3.passable = off; }
		if (my.skill8 == 4) { door4.passable = off; }
		if (my.skill8 == 5) { door5.passable = off; }
		if (my.skill8 == 6) { door6.passable = off; }

		my.pan = my.skill21;

		if(MY.__LID == ON)
		{
			MY.ROLL -= MY._CURRENTPOS-MY._ENDPOS;
		}
		else
		{
			MY.PAN += MY._CURRENTPOS-MY._ENDPOS;
		}
		MY._CURRENTPOS = MY._ENDPOS;
		if(MY.__LID == ON)
		{
			MY.PASSABLE = ON;	// otherwise the player won't fit through
		}
	}
	else  // MY._CURRENTPOS >= MY._ENDPOS	// open door
	{
		if(MY.__SILENT == OFF) { play_entsound(ME,close_snd,66); }
		while(MY._CURRENTPOS > 0)
		{
			if(MY.__LID == ON)
			{
				MY.ROLL -= MY._FORCE*TIME;
			}
			else
			{
				if (my.skill22 == 1) { MY.PAN -= MY._FORCE*TIME; } else { MY.PAN += MY._FORCE*TIME; }
			}
			MY._CURRENTPOS -= abs(MY._FORCE)*TIME;
			wait(1);
		}

		if (my.skill8 == 1) { door1.passable = on; }
		if (my.skill8 == 2) { door2.passable = on; }
		if (my.skill8 == 3) { door3.passable = on; }
		if (my.skill8 == 4) { door4.passable = on; }
		if (my.skill8 == 5) { door5.passable = on; }
		if (my.skill8 == 6) { door6.passable = on; }

		my.pan = my.skill20;

		if(MY.__LID == ON)
		{
			MY.ROLL -= MY._CURRENTPOS;
		}
		else
		{
			MY.PAN += MY._CURRENTPOS;
		}
		MY._CURRENTPOS = 0;
		if(MY.__LID == ON)
		{
			MY.PASSABLE = 0;
		}
	}

	MY.__MOVING = OFF;
}

ACTION celldoor2			// Opens and close Asylum cell doors on second floor
{
	if (my.skill8 == 1) { sdoor1 = my; }
	if (my.skill8 == 2) { sdoor2 = my; }
	if (my.skill8 == 3) { sdoor3 = my; }
	if (my.skill8 == 4) { sdoor4 = my; }
	if (my.skill8 == 5) { sdoor5 = my; }
	if (my.skill8 == 6) { sdoor6 = my; }

	my.skill20 = my.pan;
	my.skill21 = my.pan + 180;

	my.enable_click = on;
	my.enable_scan = off;
	MY.EVENT = door_event2;
	if(MY._FORCE == 0)  { MY._FORCE  = 5;  }
	if(MY._ENDPOS == 0) { MY._ENDPOS = 90; }
}

ACTION Needle
{
	if (you == player)
	{
		if (Health > 0)
		{
			if (snd_playing (SCRM) == 0) { play_sound (Scream,100); SCRM = result; }
			Health = Health - (int(Random(7)+1)) / 3;
		}
		else
		{
			if (my.skill29 == 0)
			{
				ShowRIP();
				my.skill29 = 1;
			}
		}
	}
}

ACTION Doctors
{
	my.event = Needle;
	my.enable_entity = on;
	if(MY._FORCE == 0) {  MY._FORCE = 2; }
	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	MY._WALKFRAMES = int(MY._WALKFRAMES);
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = 13; }
	MY._WALKDIST = MY._WALKFRAMES / temp;

	while (MoviePlaying == 1) { wait(1); }

	while(1)
	{
		if (Cheat1 == 1)
		{
			my.lightrange = 400;
			my.lightred = 255;
			my.lightgreen = 0;
			my.lightblue = 0;
		}

		if ((snd_playing(DOC) == 0) && (my.shocked <= 0))
		{
			DOC = int(random(3)) + 1;
			if (DOC == 1) { play_entsound (my,DOC1,RANGE); DOC = result; }
			if (DOC == 2) { play_entsound (my,DOC2,RANGE); DOC = result; }
			if (DOC == 3) { play_entsound (my,DOC3,RANGE); DOC = result; }
		}

		if (snd_Playing(DOC) == 0) { DOC = 0; }

		if (my.Shocked <= 0)
		{
			talk();
			// calculate a direction to walk into
			temp.X = player.X - MY.X;
			temp.Y = player.Y - MY.Y;
			temp.Z = 0;
			vec_to_angle(MY_ANGLE,temp);  // 10/31/00 replace TO_ANGLE
	
			// turn towards player
			MY_ANGLE.TILT = 0;
			MY_ANGLE.ROLL = 0;
			force = MY._FORCE * 2;
			actor_turn();
	
			// walk towards him
			force = MY._FORCE;
			MY._MOVEMODE = _MODE_WALKING;
			actor_move();
	
		}

		if (my.Shocked > 0) { my.Shocked = my.Shocked - 2 * time; }

		WAIT(1);	
	}
}

ACTION CheckCells
{
	if (Done == 1) { return; }

	Done = 1;
	Opening = 1;

	if (Mad1  == NULL) { wait(1); }
	if (Mad2  == NULL) { wait(1); }
	if (Mad3  == NULL) { wait(1); }
	if (Mad4  == NULL) { wait(1); }
	if (Mad5  == NULL) { wait(1); }
	if (Mad6  == NULL) { wait(1); }
	if (Mad7  == NULL) { wait(1); }
	if (Mad8  == NULL) { wait(1); }
	if (Mad9  == NULL) { wait(1); }
	if (Mad10 == NULL) { wait(1); }

	Phase = 0;

	CloseAllDoors();
	while (Phase < 1) { wait(1); }

		Counter = 0;
		my.T = 0;
		my.XCheck = 0;
		my.YCheck = 0;
		my.ZCheck = 0;
		Loop = 1;

	while (Loop < 11) 
	{
		InCell = 0;
		if (Loop == 1 ) { my = Mad1; }
		if (Loop == 2 ) { my = Mad2; }
		if (Loop == 3 ) { my = Mad3; }
		if (Loop == 4 ) { my = Mad4; }
		if (Loop == 5 ) { my = Mad5; }
		if (Loop == 6 ) { my = Mad6; }
		if (Loop == 7 ) { my = Mad7; }
		if (Loop == 8 ) { my = Mad8; }
		if (Loop == 9 ) { my = Mad9; }
		if (Loop == 10) { my = Mad10; }

		if ((my.x > CellX1[0]) && (my.x < CellX2[0]) && (my.y < CellY1[0]) && (my.y > CellY2[0]) && (my.z < CellZ1[0]) && (my.z > CellZ2[0])) { InCell = 1; }
		if ((my.x > CellX1[1]) && (my.x < CellX2[1]) && (my.y < CellY1[1]) && (my.y > CellY2[1]) && (my.z < CellZ1[1]) && (my.z > CellZ2[1])) { InCell = 1; }

		if (InCell == 1) { Counter = Counter + 1; }
		Loop = Loop + 1;
	}

	if (Counter > 8)
	{
		sPlay ("ALR005.WAV"); while (GetPosition (Voice) < 1000000) { wait(1); }
		sPlay ("PIP492.WAV"); while (GetPosition (Voice) < 1000000) { wait(1); }

		Asylum[2] = 1;
		Piece[4] = 1;	// Got a vase piece!
		WriteGameData (0);

		Run ("Intro8.exe");
	}
	else
	{
		play_sound (Alarm2,100);
		OpenAllDoors();
		while (opening != 0) { wait(1); }
	}

	Done = 0;
}

ACTION Switch
{
	my.event = checkcells;
	my.enable_click = on;
}

function CloseAllDoors
{
	if (sdoor1 == NULL) { wait (1); }
	if (sdoor2 == NULL) { wait (1); }
	if (sdoor3 == NULL) { wait (1); }
	if (sdoor4 == NULL) { wait (1); }
	if (sdoor5 == NULL) { wait (1); }
	if (sdoor6 == NULL) { wait (1); }

	play_entsound(ME,close_snd,66);

	if (door1.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor1.pan = sdoor1.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door1.passable = off; } else { sdoor1.skill22 = 1; }
	sdoor1.pan = sdoor1.skill21;
	if (door2.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor2.pan = sdoor2.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door2.passable = off; } else { sdoor2.skill22 = 1; }
	sdoor2.pan = sdoor2.skill21;
	if (door3.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor3.pan = sdoor3.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door3.passable = off; } else { sdoor3.skill22 = 1; }
	sdoor3.pan = sdoor3.skill21;
	if (door4.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor4.pan = sdoor4.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door4.passable = off; } else { sdoor4.skill22 = 1; }
	sdoor4.pan = sdoor4.skill21;
	if (door5.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor5.pan = sdoor5.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door5.passable = off; } else { sdoor5.skill22 = 1; }
	sdoor5.pan = sdoor5.skill21;
	if (door6.passable == on) { DoorCount = 0; while (DoorCount < 180) { sdoor6.pan = sdoor6.pan - 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door6.passable = off; } else { sdoor6.skill22 = 1; }
	sdoor6.pan = sdoor6.skill21;

	Phase = 1;
}

function OpenAllDoors
{
	if (sdoor1 == NULL) { wait (1); }
	if (sdoor2 == NULL) { wait (1); }
	if (sdoor3 == NULL) { wait (1); }
	if (sdoor4 == NULL) { wait (1); }
	if (sdoor5 == NULL) { wait (1); }
	if (sdoor6 == NULL) { wait (1); }

	if (door1.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor1.pan = sdoor1.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door1.passable = on; }
	sdoor1.pan = sdoor1.skill20;
	if (door2.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor2.pan = sdoor2.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door2.passable = on; }
	sdoor2.pan = sdoor2.skill20;
	if (door3.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor3.pan = sdoor3.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door3.passable = on; }
	sdoor3.pan = sdoor3.skill20;
	if (door4.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor4.pan = sdoor4.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door4.passable = on; }
	sdoor4.pan = sdoor4.skill20;
	if (door5.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor5.pan = sdoor5.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door5.passable = on; }
	sdoor5.pan = sdoor5.skill20;
	if (door6.passable == off) { DoorCount = 0; while (DoorCount < 180) { sdoor6.pan = sdoor6.pan + 5 * time; DoorCount = DoorCount + 5 * time; wait(1); } door6.passable = on; }
	sdoor6.pan = sdoor6.skill20;

	Opening = 0;
}

action definedoor
{
	// Define blocking polygon for the cell doors
	if (my.skill8 == 1) { door1 = my; }
	if (my.skill8 == 2) { door2 = my; }
	if (my.skill8 == 3) { door3 = my; }
	if (my.skill8 == 4) { door4 = my; }
	if (my.skill8 == 5) { door5 = my; }
	if (my.skill8 == 6) { door6 = my; }
}

ACTION dyna_light {
	SET MY.INVISIBLE,ON;
	SET MY.LIGHTRED,128;
	SET MY.LIGHTGREEN,10;
	SET MY.LIGHTBLUE,10;
		WHILE (1) {
			MY.LIGHTRANGE = RANDOM (1000)+100;
			if (Cheat1 == 1) { my.lightrange = 0; }
		WAITT 4;
	}
} 

ACTION SparkHit
{
	if (you != NULL) { you.Shocked = you.Shocked + int(Random(100)+100); }	// Cattle prod shocks at a power of 100-200 (addative)
	remove (my);
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

	MY.LIGHTRED = light_bullet.RED;
	MY.LIGHTGREEN = light_bullet.GREEN;
	MY.LIGHTBLUE = light_bullet.BLUE;
	MY.LIGHTRANGE = 100;
	MY.AMBIENT = 100;

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

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

		if((MY._FIREMODE & BULLET_SMOKETRAIL) == BULLET_SMOKETRAIL)
		{
			temp = 3 * TIME;
			if(temp > 6) { temp = 6; }	// generate max 6 particels
			emit(temp,MY.POS,particle_fade); 	// smoke trail
		}

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		move(ME,nullskill,fireball_speed);
	}
}

function CreateSpark
{
	shot_speed.x = 100;
	shot_speed.y = 0;
	shot_speed.z = 0;
	my_angle.pan = player.pan;
	my_angle.roll = player.roll;
	my_angle.tilt = player.tilt;
	vec_rotate(shot_speed,my_angle);
	
	create(<Spark.mdl>,player.x,Spark);

}

function WeaponHit
{
	if (MyWeapon == 1 || MyWeapon == 2) {		// Natka or Bat
		if (MyWeapon == 1) { play_sound (Baseball,100); } else { play_sound (Matka,100); }
		weapon.roll = 0;
		weapon.tilt = weapon.tilt - 15;
		wait(1);
		weapon.roll = -20;
		weapon.tilt = weapon.tilt - 15;
		wait(1);
		Weapon.roll = -40;
		weapon.tilt = weapon.tilt - 15;
		wait (1);
		send_handle();
		weapon.roll = -20;
		weapon.tilt = weapon.tilt + 15;
		wait(1);
		weapon.roll = 0;
		weapon.tilt = weapon.tilt + 15;
		wait(1);
		weapon.roll = 10;
		weapon.tilt = weapon.tilt + 15;
	}
	else
	{
		if (Batts >= 30)
		{
			play_sound (Zap,100);
			Batts = Batts - 30;
			Weapon.tilt = weapon.tilt - 30;
			weapon.roll = weapon.roll - 10;
			wait (1);
			Weapon.tilt = weapon.tilt - 30;
			weapon.roll = weapon.roll - 10;
			wait (1);
			Weapon.tilt = weapon.tilt - 30;
			weapon.roll = weapon.roll - 10;
			CreateSpark();
			wait (1);
			Weapon.tilt = weapon.tilt + 30;
			weapon.roll = weapon.roll + 10;
			wait (1);
			Weapon.tilt = weapon.tilt + 30;
			weapon.roll = weapon.roll + 10;
			wait (1);
			Weapon.tilt = weapon.tilt + 30;
			weapon.roll = weapon.roll + 10;
			wait (1);
		}
	}
}

function ChangeWeapon
{
	if (MyWeapon == 1) { morph (<Matka.mdl>,weapon); }
	if (MyWeapon == 2) { morph (<Bat.mdl>,weapon); }
	if (MyWeapon == 3) { morph (<Prod.mdl>,weapon); }
}

function SwitchWeapon
{
	if (weapon.skill1 == 0)
	{
		weapon.skill1 = 1;
		weapon.skill2 = 0;
		while (weapon.skill2 < 30)
		{
			weapon.z = weapon.z - 3;
			weapon.skill2 = weapon.skill2 + 1;
			wait (1);
		}
	
		MyWeapon = MyWeapon + 1;
		if MyWeapon == 4 { MyWeapon = 1; }
		ChangeWeapon();
	
		weapon.skill2 = 0;
		while (weapon.skill2 < 30)
		{
			weapon.z = weapon.z + 3;
			weapon.skill2 = weapon.skill2 + 1;
			wait (1);
		}
		Weapon.skill1 = 0;
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

on_F1 = SwitchWeapon();
on_ctrl = WeaponHit();
on_tab = cheat();

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"lightning storm") == 1) { Mad1.shocked = CS; Mad2.shocked = CS; Mad3.shocked = CS; Mad4.shocked = CS; Mad5.shocked = CS; Mad6.shocked = CS; Mad7.shocked = CS; Mad8.shocked = CS; Mad9.shocked = CS; Mad10.shocked = CS; msg.string = "cheat enabled"; show_message(); play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"morphium") == 1) { msg.string = "cheat enabled"; show_message(); health = 110; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"night vision") == 1) { msg.string = "cheat enabled"; show_message(); Cheat1 = 1; NightV.visible = on; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}