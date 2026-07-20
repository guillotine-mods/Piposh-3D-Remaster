include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var AFG_Select = 1;
var V1;
var V2;
var Dim;
var GayCall = 0;
var ArabCall = 0;
var Scene = 0;
var DialogStage = 0;
var TalkedOnce = 0;
var CheatEnabled = 0;
var SetArab = 0;
var ArabKilled = 0;
var Loc = 1;
var MoviePlaying = 0;
var FlashIt = 0;
var LimitX = 0;
var AFGCount;

var DummyY = 0;
var DummyX = 0;

var Joke1A = 0;
var Joke1B = 0;

var A[3] = 0,0,0;

bmap Photo1 = <Phot1.pcx>;
bmap Photo2 = <Phot2.pcx>;
bmap Photo3 = <Phot3.pcx>;
bmap Photo4 = <Phot4.pcx>;
bmap Photo5 = <Phot5.pcx>;
bmap Photo6 = <Phot6.pcx>;

bmap bV1a = <bVIL1A.pcx>;
bmap bV1b = <bVIL1B.pcx>;
bmap bV2a = <bVIL2A.pcx>;
bmap bV2b = <bVIL2B.pcx>;
bmap bV3a = <bVIL3A.pcx>;
bmap bV3b = <bVIL3B.pcx>;
bmap Vilon = <VILON.pcx>;
bmap A1a = <bARR1A.pcx>;
bmap A1b = <bARR1B.pcx>;
bmap A2a = <bARR2A.pcx>;
bmap A2b = <bARR2B.pcx>;

bmap Loc1 = <location01.pcx>;
bmap Loc2 = <location02.pcx>;
bmap Loc3 = <location03.pcx>;
bmap Loc4 = <location04.pcx>;
bmap Loc5 = <location05.pcx>;
bmap Loc6 = <location06.pcx>;
bmap Loc7 = <location07.pcx>;
bmap Loc8 = <location08.pcx>;
bmap Loc9 = <location09.pcx>;
bmap Loc10 = <location10.pcx>;
bmap Loc11 = <location11.pcx>;

bmap Info01 = <Info01.pcx>;
bmap Info02 = <Info02.pcx>;
bmap Info03 = <Info03.pcx>;
bmap Info04 = <Info04.pcx>;
bmap Info05 = <Info05.pcx>;
bmap Info06 = <Info06.pcx>;
bmap Info07 = <Info07.pcx>;
bmap Info08 = <Info08.pcx>;
bmap Info09 = <Info09.pcx>;
bmap Info10 = <Info10.pcx>;
bmap Info11 = <Info11.pcx>;
bmap Info12 = <Info12.pcx>;
bmap Info13 = <Info13.pcx>;
bmap Info14 = <Info14.pcx>;
bmap Info15 = <Info15.pcx>;
bmap Info16 = <Info16.pcx>;
bmap Info17 = <Info17.pcx>;
bmap Info18 = <Info18.pcx>;
bmap Info19 = <Info19.pcx>;
bmap Info20 = <Info20.pcx>;
bmap Info21 = <Info21.pcx>;
bmap Info22 = <Info22.pcx>;
bmap Info23 = <Info23.pcx>;
bmap Info24 = <Info24.pcx>;
bmap Info25 = <Info25.pcx>;
bmap Info26 = <Info26.pcx>;
bmap Info27 = <Info27.pcx>;
bmap Info28 = <Info28.pcx>;
bmap Info29 = <Info29.pcx>;
bmap Info30 = <Info30.pcx>;
bmap Info31 = <Info31.pcx>;
bmap Info32 = <Info32.pcx>;
bmap Info33 = <Info33.pcx>;

bmap Close1 = <Close1.pcx>;
bmap Close2 = <Close2.pcx>;
bmap Cheater = <Cheater.pcx>;

var BellRinging = 0;

text txtAFG
{
	string = "                             ";
	font = standard_font;
	pos_x = 500;
	flags = visible;
}

entity ID_Show
{
	type = <Phot.mdl>;
	layer = 20;
	view = camera;
	x = 150;
	y = 28;
	z = 36;
	pan = 180;
	ambient = 100;
}

panel Location
{
	bmap = Loc1;
	pos_x = 230;
	pos_y = 150;
	layer = 3;
	flags = refresh,d3d,overlay;
}

panel ChooseCheat
{
	bmap = Vilon;
	pos_x = 200;
	pos_y = 100;
	layer = 2;
	flags = refresh,d3d,overlay;

	button = 30, 15, a1b, a1a, a1b, SwitchLeft, null, null;
	button = 100, 15, a2b, a2a, a2b, SwitchRight, null, null;

	button = 25, 85, bv1b, bv1a, bv1b, C1, null, null;
	button = 100, 85, bv2b, bv2a, bv2b, C2, null, null;
	button = 170, 85, bv3b, bv3a, bv3b, C3, null, null;
}

panel pPhoto
{
	bmap = Photo1;
	pos_x = 100;
	pos_y = 15;
	layer = 2;
	flags = refresh,d3d,overlay;

	button = 160, 165, Photo2, Photo2, Photo2, PP1, null, null;
	button = 160, 251, Photo3, Photo3, Photo3, PP2, null, null;
	button = 160, 337, Photo4, Photo4, Photo4, PP3, null, null;
	button = 032, 251, Photo5, Photo5, Photo5, PP4, null, null;
	button = 288, 251, Photo6, Photo6, Photo6, PP5, null, null;
}

function PP1 { varPhotoID = 5; WriteGameData(0); pPhoto.visible = off; }
function PP2 { varPhotoID = 4; WriteGameData(0); pPhoto.visible = off; }
function PP3 { varPhotoID = 2; WriteGameData(0); pPhoto.visible = off; }
function PP4 { varPhotoID = 3; WriteGameData(0); pPhoto.visible = off; }
function PP5 { varPhotoID = 1; WriteGameData(0); pPhoto.visible = off; }

panel CheatPanel
{
	bmap = Cheater;
	pos_x = 200;
	pos_y = 100;
	layer = 2;
	flags = refresh,d3d,overlay;
}

panel Info
{
	bmap = Info01;
	pos_x = 200;
	pos_y = 100;
	layer = 3;

	button = 80, 190, Close2, Close1, Close2, Close, null, null;

	flags = refresh,d3d,overlay;
}

sound Honk1 = <SFX007.wav>;
sound Honk2 = <SFX008.wav>;
sound Honk3 = <SFX009.wav>;

var Dancing = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	mouse_range = 8000;

	load_level(<Inn.WMB>);

	VoiceInit();
	Initialize();
	varPhotoID = 0;
	sPlay ("SFX040.WAV");
	SetPosition (Voice,10000000);
}

function SwitchLeft { Loc = Loc + 1; if (Loc > 11) { Loc = 1; } ShowLocation(); }
function SwitchRight { Loc = Loc - 1; if (Loc < 1) { Loc = 11; } ShowLocation(); }

function ShowLocation
{
	if (Loc == 1)  { Location.bmap = Loc1; }
	if (Loc == 2)  { Location.bmap = Loc2; }
	if (Loc == 3)  { Location.bmap = Loc3; }
	if (Loc == 4)  { Location.bmap = Loc4; }
	if (Loc == 5)  { Location.bmap = Loc5; }
	if (Loc == 6)  { Location.bmap = Loc6; }
	if (Loc == 7)  { Location.bmap = Loc7; }
	if (Loc == 8)  { Location.bmap = Loc8; }
	if (Loc == 9)  { Location.bmap = Loc9; }
	if (Loc == 10) { Location.bmap = Loc10;}
	if (Loc == 11) { Location.bmap = Loc11;}
}

function C1 { GetCheat(1); }
function C2 { GetCheat(2); }
function C3 { GetCheat(3); }
function Close { cheatpanel.visible = off; info.visible = off; Dancing = 0; }

function GetCheat(X)
{
	location.visible = off;
	choosecheat.visible = off;
	cheatpanel.visible = on;
	info.visible = on;

	if (Loc == 1)
	{
		if (X == 1) { info.bmap = Info07; }
		if (X == 2) { info.bmap = Info08; }
		if (X == 3) { info.bmap = Info09; }
	}

	if (Loc == 2)
	{
		if (X == 1) { info.bmap = Info01; }
		if (X == 2) { info.bmap = Info02; }
		if (X == 3) { info.bmap = Info03; }
	}

	if (Loc == 3)
	{
		if (X == 1) { info.bmap = Info10; }
		if (X == 2) { info.bmap = Info11; }
		if (X == 3) { info.bmap = Info12; }
	}

	if (Loc == 4)
	{
		if (X == 1) { info.bmap = Info13; }
		if (X == 2) { info.bmap = Info14; }
		if (X == 3) { info.bmap = Info15; }
	}

	if (Loc == 5)
	{
		if (X == 1) { info.bmap = Info04; }
		if (X == 2) { info.bmap = Info05; }
		if (X == 3) { info.bmap = Info06; }
	}

	if (Loc == 6)
	{
		if (X == 1) { info.bmap = Info16; }
		if (X == 2) { info.bmap = Info17; }
		if (X == 3) { info.bmap = Info18; }
	}

	if (Loc == 7)
	{
		if (X == 1) { info.bmap = Info25; }
		if (X == 2) { info.bmap = Info26; }
		if (X == 3) { info.bmap = Info27; }
	}

	if (Loc == 8)
	{
		if (X == 1) { info.bmap = Info28; }
		if (X == 2) { info.bmap = Info29; }
		if (X == 3) { info.bmap = Info30; }
	}

	if (Loc == 9)
	{
		if (X == 1) { info.bmap = Info31; }
		if (X == 2) { info.bmap = Info32; }
		if (X == 3) { info.bmap = Info33; }
	}


	if (Loc == 10)
	{
		if (X == 1) { info.bmap = Info19; }
		if (X == 2) { info.bmap = Info20; }
		if (X == 3) { info.bmap = Info21; }
	}

	if (Loc == 11)
	{
		if (X == 1) { info.bmap = Info22; }
		if (X == 2) { info.bmap = Info23; }
		if (X == 3) { info.bmap = Info24; }
	}
}

action PIP
{
	while(1)
	{
		ent_cycle ("Talk",my.skill1);
		if (my.skill2 < 100) { ent_blend ("Talk",my.skill1 + 5,my.skill2); my.skill2 = my.skill2 + 5 * time; }
		else
		{
			my.skill1 = my.skill1 + 5 * time;
			my.skill2 = 0;
		}
		wait(1);
	}
}

function AFGCounter
{
	var n;

	AFGCount = 0;
	n = 0;

	while (n < 31)
	{
		AFGcount = AFGcount + AFG[n];
		n = n + 1;
	}

	str_for_num (txtAFG.string,AFGcount);
	str_cat (txtAFG.string,"/31 :XJJNCQA XJQLS");
}

ACTION player_moveInn
{
//	flare_init(my);
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
		if (FlashIt == -300)
		{
			vec_set(temp,A.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			my.tilt = 0; my.roll = 0;
		}

		if (Talking == 1) 
		{ 
			vec_set(temp,camera.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			my.tilt = 0; my.roll = 0;

			Talk(); 
		} 
		else 
		{ 
			if (MoviePlaying == 0) { Blink2(); } else { Blink(); }
		}

		if ((Scene <= 0) && (Dialog.visible == off))
		{

		my.invisible = off; my.shadow = on;

		// if we are not in 'still' mode
		if((MY._MOVEMODE != _MODE_STILL) && (MoviePlaying == 0))
		{
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
		if (MoviePlaying == 0) { actor_anim(); }

		move_view_3rd();

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		if (my.skill30 > 0)
		{
			ent_frame ("Take",100);
			my.skill30 = my.skill30 - 1 * time;
		}

		}
		else { my.invisible = on; my.shadow = off; }

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION Metal_Material
{
	MY.Metal = on;
}

action Dummy
{
	if (my.skill1 == 1) { DummyY = my.y; }
	if (my.skill1 == 2) { DummyX = my.x; }
}

action Shd
{
	while(1)
	{
		my.scale_x = abs(player.x - my.x) / 100;

		if (my.scale_x < 1) { my.scale_x = 1; }

		if (my.scale_x > 5) { my.invisible = on; } else { my.invisible = off; }

		my.scale_y = my.scale_x;
		my.scale_z = my.scale_x;

		actor_anim();
		my.pan = player.pan;
		my.y = player.y;
		wait(1);
	}
}

action UpCam
{
	while(1)
	{
		if (player.y > DummyY)
		{
			if (player.x > DummyX)
			{
				if (my.skill1 == 2)
				{
					move_view_3rd();
					vec_set(temp,player.x);
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);

					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;

					camera.pan = my.pan;
					camera.tilt = my.tilt;
					camera.roll = my.roll;
				}
			}

			else
			{
				if (my.skill1 == 1)
				{
					move_view_3rd();
					vec_set(temp,player.x);
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);

					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;

					camera.pan = my.pan;
					camera.tilt = my.tilt;
					camera.roll = my.roll;
				}
			}
		}

		wait(1);
	}
}

ACTION player_walkInn
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_moveInn();
}

action Watch
{
	while(1)
	{
		camera.pan = my.pan;
		camera.tilt = my.tilt;
		camera.roll = my.roll;
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		wait(1);
	}
}

action Watch2
{
	while(1)
	{
		if (player.x > my.x)
		{
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
		}
		wait(1);
	}
}


action Car1
{
	V1 = my.y;
	while (1)
	{
		if ((int(random(100)) == 50) && (player.invisible == off))
		{
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,honk1,200); }
			if (my.skill40 == 2) { play_entsound (my,honk2,200); }
			if (my.skill40 == 3) { play_entsound (my,honk3,200); }
		}

		my.y = my.y - 20;
		if (my.y == V1 - 2000) { my.y = V1; NewCar(); }
		wait(1);
	}
}

action Car2
{
	V2 = my.y;
	while (1)
	{
		if ((int(random(100)) == 50) && (player.invisible == off))
		{
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,honk1,200); }
			if (my.skill40 == 2) { play_entsound (my,honk2,200); }
			if (my.skill40 == 3) { play_entsound (my,honk3,200); }
		}

		my.y = my.y + 20;
		if (my.y == V2 + 2000) { my.y = V2; NewCar(); }
		wait(1);
	}
}

function NewCar
{
	Dim = int(random(3)) + 1;
	if (Dim == 1)
	{
		morph (<Sportcar.mdl>,my); 
		my.scale_x = 1.5; 
		my.scale_y = 1.5; 
		my.scale_z = 1.5;
	}
	
	if (Dim == 2)
	{
		morph (<Taxi.mdl>,my); 
		my.scale_x = 1.5; 
		my.scale_y = 1.5; 
		my.scale_z = 1.5;
	}

	if (Dim == 3)
	{
		morph (<Bus.mdl>,my); 
		my.scale_x = 3; 
		my.scale_y = 3; 
		my.scale_z = 3;
	}
}

action BellClick
{
	if (GayCall == 1) { return; }

	if ((abs(player.x - my.x) < 50) && (abs(player.y - my.y) < 50))
	{
		my.skill1 = int(random(6)) + 1;

		if (my.skill1 == 1) { sPlay ("SFX034.WAV"); }
		if (my.skill1 == 2) { sPlay ("SFX035.WAV"); }
		if (my.skill1 == 3) { sPlay ("SFX036.WAV"); }
		if (my.skill1 == 4) { sPlay ("SFX037.WAV"); }
		if (my.skill1 == 5) { sPlay ("SFX038.WAV"); }
		if (my.skill1 == 6) { sPlay ("SFX039.WAV"); }

		BellRinging = 1;

		GayCall = 1;
		player.skill30 = 3;

		while (GetPosition(Voice) < 1000000) { wait(1); }

		BellRinging = 0;
	}
}

action Bell
{
	my.event = BellClick;
	my.enable_click = on;
}

action Gay
{
	my.skill1 = my.z;
	my.z = my.z - 100;
	my.skill2 = my.z;
	GayCall = 0; 
	my.skill10 = 0;

	while(1)
	{
		AFGCounter();

		if ((AFGCount == 31) && (my.skill40 == 0)) { my.skill40 = 1; morph (<DLL25.mdl>,my); }

		if (Talking == 2) { Talk(); } else { Blink(); }
		if (Scene > 0) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }

		if (DialogIndex == 54) 
		{
			if (DialogChoice == 1) { Scene = 1; DialogStage = 2; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 2) { Scene = 1; DialogStage = 3; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 3) { Scene = 1; DialogStage = 4; DialogIndex = 0; SetVoice(); }
		}

		if (DialogIndex == 55) 
		{
			if (DialogChoice == 1) { Scene = 1; DialogStage = 5; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 2) { Scene = 1; DialogStage = 6; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 3) { Scene = 1; DialogStage = 7; DialogIndex = 0; SetVoice(); }
		}

		if (DialogIndex == 56) 
		{
			if (DialogChoice == 1) { Scene = 1; DialogStage = 10; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 2) { Scene = 1; DialogStage = 11; DialogIndex = 0; SetVoice(); }
			if (DialogChoice == 3) { Scene = 1; DialogStage = 12; DialogIndex = 0; SetVoice(); }
		}

		if (GayCall == 1)
		{
			while (BellRinging == 1) { wait(1); }

			if (my.z < my.skill1) { my.z = my.z + 10 * time; } 
			else 
			{ 
				if (TalkedOnce == 0) { TalkedOnce = 1; WriteGameData(0); my.skill10 = 1; Scene = 1; DialogStage = 1; SetVoice(); } }
				if (TalkedOnce == 1) { if (my.skill10 == 0) { my.skill10 = 1; sPlay ("GAY012.WAV"); }
				if ((TalkedOnce == 1) && (abs(my.x - player.x) > 50) && (abs(my.y - player.y) > 50)) { GayCall = 0; my.skill10 = 0; }

			}
		}
		else
		{
			if (my.z > my.skill2) { my.z = my.z - 10 * time; } else { my.skill10 = 0; }
		}

		if (Dancing == 1) { ent_cycle ("Dance",my.skill30); my.skill30 = my.skill30 + 8 * time; }

		wait(1);
	}
}

function SetVoice
{
	if (DialogStage == 1)
	{
		if (Scene == 1) { sPlay ("GAY012.WAV"); Talking = 2; }
		if (Scene == 2) { sPlay ("PIP413.WAV"); Talking = 1; }
		if (Scene == 3) { sPlay ("GAY001.WAV"); Talking = 2; }
		if (Scene == 4) { Talking = 0; Scene = 0; DialogIndex = 54; ShowDialog(); }
	}

	if (DialogStage == 2)
	{
		if (Scene == 1) { sPlay ("PIP414.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY002.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP415.WAV"); Talking = 1; }
		if (Scene == 4) { sPlay ("GAY003.WAV"); Talking = 2; }
		if (Scene == 5) { sPlay ("PIP416.WAV"); Talking = 1; }
		if (Scene == 6) { Talking = 0; Scene = 0; DialogIndex = 54; ShowDialog(); }
	}

	if (DialogStage == 3)
	{
		if (Scene == 1) { sPlay ("PIP417.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY004.WAV"); Talking = 2; }
		if (Scene == 3) { Talking = 0; Scene = 0; DialogIndex = 55; ShowDialog(); }
	}

	if (DialogStage == 4)
	{
		if (Scene == 1) { sPlay ("PIP425.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY010.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP426.WAV"); Talking = 1; }
		if (Scene == 4) { Talking = 0; Scene = 0; DialogIndex = 54; ShowDialog(); }
	}

	if (DialogStage == 5)
	{
		if (Scene == 1) { sPlay ("PIP418.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY005.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP419.WAV"); Talking = 1; }
		if (Scene == 4) { Talking = 0; Scene = 0; DialogIndex = 55; ShowDialog(); }
	}

	if (DialogStage == 6)
	{
		if (Scene == 1) { sPlay ("PIP420.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY006.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP421.WAV"); Talking = 1; }
		if (Scene == 4) { sPlay ("GAY007.WAV"); Talking = 2; }
		if (Scene == 5) { sPlay ("PIP422.WAV"); Talking = 1; }
		if (Scene == 6) { Talking = 0; Joke1A = 1; if (Joke1B == 1) { EndDialog(); } else { Scene = 0; DialogIndex = 55; ShowDialog(); } }
	}

	if (DialogStage == 7)
	{
		if (Scene == 1) { sPlay ("PIP423.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY008.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP424.WAV"); Talking = 1; }
		if (Scene == 4) { sPlay ("GAY009.WAV"); Talking = 2; }
		if (Scene == 5) { Talking = 0; Joke1B = 1; if (Joke1A == 1) { EndDialog(); } else { Scene = 0; DialogIndex = 55; ShowDialog(); } }
	}

	if (DialogStage == 8)
	{
		if (Scene == 1) { sPlay ("GAY011.WAV"); Talking = 2; }
		if (Scene == 2) { Scene = 0; GayCall = 0; Talking = 0; }
	}

	if (DialogStage == 9)
	{
		if (Scene == 2) { sPlay ("GAY013.WAV"); Talking = 2; }
		if (Scene == 3) { sPlay ("PIP427.WAV"); Talking = 1; }
		if (Scene == 4) { DoExit(); }
	}

	if (DialogStage == 10)
	{
		if (Scene == 1) { sPlay ("PIP428.WAV"); Talking = 1; }
		if (Scene == 2) { ArabKilled = 0; SetArab = 2; ArabCall = 1; Talking = 0; }
	}

	if (DialogStage == 11)
	{
		if (Scene == 1) { sPlay ("PIP429.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY014.WAV"); Talking = 2; }
		if (Scene == 3) { Run ("Town.exe"); }
	}

	if (DialogStage == 12)
	{
		if (Scene == 1) { sPlay ("PIP430.WAV"); Talking = 1; }
		if (Scene == 2) { sPlay ("GAY014.WAV"); Talking = 2; }
		if (Scene == 3) { Run ("Town.exe"); }
	}

	if (DialogStage == 13)
	{
		if (Scene == 1) { sPlay ("GAY020.WAV"); Talking = 2; }
		if (Scene == 2) { sPlay ("PIP494.WAV"); Talking = 1; }
		if (Scene == 3) { CheatEnabled = 0; GayCall = 0; Talking = 0; Scene = 0; }
	}

	if (DialogStage == 14)
	{
		if (Scene == 1) { sPlay ("GAY017.WAV"); Talking = 2; }
		if (Scene == 2) { sPlay ("PIP539.WAV"); Talking = 1; }
		if (Scene == 3) { CheatEnabled = 0; GayCall = 0; Talking = 0; Scene = 0; }
	}

	if (DialogStage == 15)
	{
		if (Scene == 1) { sPlay ("GAY018.WAV"); Talking = 2; }
		if (Scene == 2) { sPlay ("PIP495.WAV"); Talking = 1; }
		if (Scene == 3) { CheatEnabled = 0; GayCall = 0; Talking = 0; Scene = 0; }
	}

	if (DialogStage == 16)
	{
		if (Scene == 1) { sPlay ("GAY019.WAV"); Talking = 2; }
		if (Scene == 2) { sPlay ("PIP496.WAV"); Talking = 1; }
		if (Scene == 3) { CheatEnabled = 0; GayCall = 0; Talking = 0; Scene = 0; }
	}

	if (DialogStage == 17)
	{
		if (Scene == 2) { run ("Town.exe"); }
	}
}

function EndDialog
{
	Scene = 1; DialogStage = 8; DialogIndex = 0; SetVoice();
}

action CardShow
{
	while(1)
	{
		if (GetPosition(Voice) < 1000000) { my.invisible = on; } else { my.invisible = off; }
		if (AFG[AFG_Select] == 1) { my.skin = AFG_Select; } else { my.skin = 32; }
		wait(1);
	}
}

action QuitNow
{
	my.passable = on;
	sPlay ("GAY021.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	run ("Town.exe");
}

action Quit
{
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = QuitNow;
}

action LeftEyeClick
{
	if ((TalkedOnce == 1) && (GayCall == 1) && (CheatEnabled == 0))
	{
		CheatEnabled = 1;
		Scene = 0; 
		DialogIndex = 56; 
		ShowDialog();
	}
}

action LeftEye
{
	my.invisible = off;
	my.transparent = on;
	my.enable_click = on;
	my.event = LeftEyeClick;
}

action RightEyeClick
{
	if ((TalkedOnce == 1) && (GayCall == 1) && (CheatEnabled == 0))
	{
		CheatEnabled = 1;
		DialogStage = 9;
		Scene = 1;
	}
}

action RightEye
{
	my.invisible = off;
	my.transparent = on;
	my.enable_click = on;
	my.event = RightEyeClick;
}

action KillArab
{
	if ((ArabCall == 1) && (my.skin == 0))
	{
		PLAY_SOUND gun_wham,50;
		my.skin = 3;
		ArabKilled = ArabKilled + 1;
	}
}

action Beam
{
	while(1)
	{
		if (GetPosition(Voice) < 1000000) { my.invisible = on; } else { my.invisible = off; }
		wait(1);
	}
}

action Arab
{
	my.skill1 = my.z;
	my.z = my.z - 100;
	my.skill2 = my.z;

	my.enable_click = on;
	my.event = KillArab;

	while(1)
	{
		if ((ArabCall == 1) && (ArabKilled == 2)) { ArabCall = 0; ShowCheat(); }

		if (SetArab > 0) { SetArab = SetArab - 1; my.skin = 0; }

		if ((ArabCall == 1) && (my.skin == 0))
		{
			if (my.z < my.skill1) { my.z = my.z + 10 * time; } 
		}

		if (my.skin == 3)
		{
			if (my.z > my.skill2) { my.z = my.z - 10 * time; } 
		}

		wait(1);
	}
}

action Cur
{
	my.skill1 = my.z;
	my.z = my.z + 50;
	my.skill2 = my.z;

	while(1)
	{
		if (FlashIt == -300)
		{
			my.z = my.z - 5 * time;
			if (my.z <= my.skill1) { FlashIt = 300;	sPlay ("SFX040.WAV"); }
		}
		else
		{
			if (FlashIt <= 0) { if (my.z < my.skill2) { my.z = my.z + 5 * time; } }
		}

		wait(1);
	}
}

function ShowCheat
{
	sPlay ("SFX126.WAV");
	my.skill38 = 0;
	Dancing = 0;

	ChooseCheat.visible = on; location.visible = on;

	while ((ChooseCheat.visible == on) || (Info.visible == on)) 
	{ 
		if (GetPosition (Voice) >= 1000000) 
		{
			if (my.skill38 == 2) { Dancing = 0; }
			if (my.skill38 == 1) { Dancing = 0; waitt (64); my.skill38 = 2; Dancing = 1; sPlay ("SFX128.WAV"); }
			if (my.skill38 == 0) { my.skill38 = 1; Dancing = 1; sPlay ("SFX127.WAV"); }
		}

		wait(1); 
	}

	my.skill31 = int(random(4)) + 1;
	if (my.skill31 == 1) { Scene = 1; DialogStage = 13; DialogIndex = 0; SetVoice(); }
	if (my.skill31 == 2) { Scene = 1; DialogStage = 14; DialogIndex = 0; SetVoice(); }
	if (my.skill31 == 3) { Scene = 1; DialogStage = 15; DialogIndex = 0; SetVoice(); }
	if (my.skill31 == 4) { Scene = 1; DialogStage = 16; DialogIndex = 0; SetVoice(); }
}

action TakePhoto
{
	if ((player.x < LimitX) || (varPhotoID != 0)) { return; }

	MoviePlaying = 1;

	pPhoto.visible = on;
	while (pPhoto.visible == on) { wait(1); }

	sPlay ("PIP348.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("AMI012.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("PIP349.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("SFX041.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }

	FlashIt = -300; Talking = 0;
	sPlay ("SFX042.WAV");

	while ((FlashIt > 0) || (FlashIt == -300)) { wait(1); }

	MoviePlaying = 0;

	ID_Show.skin = varPhotoID;
	ID_Show.visible = on;
	waitt(60);
	ID_Show.visible = off;
}

action PhotoMachine
{
	my.enable_click = on;
	my.event = TakePhoto;
}

action TalkingX
{
	while(1)
	{
		if ((Scene > 0) || (Dialog.visible == on))
		{
			my.invisible = off;
			my.shadow = on;

			if (Talking == 1) { Talk(); } else { Blink(); }
		}
		else
		{
			my.invisible = on;
			my.shadow = off;
		}

		if (Dancing == 1) { ent_cycle ("Wow",my.skill30); my.skill30 = my.skill30 + 8 * time; }

		wait(1);
	}
}

action LimitIt { LimitX = my.x; }

action Flash
{
	my.lightred = 255;
	my.lightgreen = 255;
	my.lightblue = 255;
	my.lightrange = 0;

	a.x = my.x;
	a.y = my.y;
	a.z = my.z;

	while(1)
	{
		if (FlashIt > 0)
		{
			my.lightrange = FlashIt;
			if (FlashIt > 0) { FlashIt = FlashIt - 20 * time; }
		}

		wait(1);
	}
}

action Bt2 { sPlay ("SFX040.WAV"); AFG_Select = AFG_Select + 1; if (AFG_Select > 31) { AFG_Select = 1; } }
action Bt1 { sPlay ("SFX040.WAV"); AFG_Select = AFG_Select - 1; if (AFG_Select < 1) { AFG_Select = 31; } }

action Button1 { my.event = Bt1; my.enable_click = on; }
action Button2 { my.event = Bt2; my.enable_click = on; }

action PlayZiggy { Run ("Ziggy.exe"); }

action Arcade
{
	my.event = PlayZiggy;
	my.enable_click = on;

	while(1)
	{
		my.skin = my.skin + 1;
		if (my.skin > 5) { my.skin = 1; }
		waitt(3);
	}

}

function Talk()
{
	my.skill11 = my.skill11 + 1 * time;
	if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }

	if (int(random(40)) == 20) 
	{ 
		ent_frame ("Talk",int(random(8)) * 14.2);
	}
}

function Blink()
{
	ent_frame ("Stand",0);
	if (my.skill42 > 0) { my.skill42 = my.skill42 - 1 * time; }
	if (my.skill42 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill42 = 5; }
	}
}

function Blink2()
{
	if (my.skill42 > 0) { my.skill42 = my.skill42 - 1 * time; }
	if (my.skill42 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill42 = 5; }
	}
}
		