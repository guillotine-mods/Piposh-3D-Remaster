include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var cameraX[3] = -608,1051,34;
var cameraY[3] = -903,102,-250;
var cameraZ[3] = 350,232,-185;
var n = 1;
var closest = 0;
var cameratemp[3] = 0,0,0;
var OpenDoor = 0;
var MoviePlaying = 0;
var Talking = 0;
var Delay;
var VView = 1;
var ShowHand = 0;

synonym FirstDoor { type entity; }

sound Ambient = <SFX061.WAV>;
sound Fingers = <SFX088.WAV>;
sound SFX013WAV = <SFX013.WAV>;
sound SFX014WAV = <SFX014.WAV>;

bmap bDoc1 = <Doc1.pcx>;
bmap bDoc2 = <Doc2.pcx>;
bmap bClips = <clips.pcx>;

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

panel pClips
{
	bmap = bClips;
	layer = 21;
	pos_x = 200;
	pos_y = 10;
	flags = refresh,d3d,overlay;
}

panel pStamp
{
	bmap = bDoc1;
	layer = 19;
	pos_x = 130;
	pos_y = 10;
	flags = refresh,d3d,overlay;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	mouse_range = 8000;

	load_level(<MOI.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	play_loop (Ambient,30);
}

ACTION player_move2
{
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
		if (Talking == 1) { Talk(); } else { Blink(); }
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
		if (MoviePlaying == 0) 
		{
			actor_anim();
			if (VView == 2) { move_view(); }
		}

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function ToggleView
{
	if (VView == 1) { VView = 2; } else { VView = 1; }
}

on_f1 = ToggleView();

ACTION player_walkTravel
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 1;
	MY._BANKING = 0;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_move2();
}

action Cam
{
	while(1)
	{
		if ((my.flag1 == on) && (abs(my.x - player.x) < 200) && (abs(my.y - player.y) < 200))
		{
			ShowHand = 1;

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);

			camera.roll = 0;
			camera.tilt = 0;
		}

		else
		{
			ShowHand = 0;

			if (my.flag1 == off)
			{
				if (VView == 1)
				{
					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;
					vec_set(temp,player.x);
					vec_sub(temp,camera.x);
					vec_to_angle(camera.pan,temp);
				}

			}
		}

		wait(1);
	}
}

action Dummy
{
	FirstDoor = my;	
}

action SecDoor
{
	my.skill1 = my.y; 

	if (FirstDoor == null) { wait(1); }

	while(1)
	{

		if ((abs(FirstDoor.x - player.x) < 250) && (abs(FirstDoor.y - player.y) < 250))
		{
			if (my.skill8 == 1) { if (my.y < my.skill1 + 100) { my.y = my.y + 6 * time; } }
			if (my.skill8 == 2) { if (my.y > my.skill1 - 100) { my.y = my.y - 6 * time; } }

			if (OpenDoor != 1) { play_entsound (my,SFX013WAV,500); }
			OpenDoor = 1;
		}
		else
		{
			if (my.skill8 == 1) { if (my.y > my.skill1) { my.y = my.y - 6 * time; } }
			if (my.skill8 == 2) { if (my.y < my.skill1) { my.y = my.y + 6 * time; } }
			if (OpenDoor != 0) { play_entsound (my,SFX014WAV,500); }
			OpenDoor = 0;
		}

	wait(1);
	}
}

action SecGlass
{
	my.skill1 = my.y;

	while(1)
	{
		if (my.skill8 == 1) 
		{ 
			if (OpenDoor == 1) { if (my.y < my.skill1 + 100) { my.y = my.y + 6 * time; } }
			else { if (my.y > my.skill1) { my.y = my.y - 6 * time; } }
		}

		if (my.skill8 == 2) 
		{ 
			if (OpenDoor == 1) { if (my.y > my.skill1 - 100) { my.y = my.y - 6 * time; } }
			else { if (my.y < my.skill1) { my.y = my.y + 6 * time; } }
		}

		wait(1);
	}
}

action LineHit
{
	if (Talking == 0)
	{
		my.skill41 = ((int(random(3)) - 1) * 50);
		if (my.skill41 == 0) { my.skill41 = 50; }
		my.pan = my.pan + my.skill41;
		my.skill40 = int(random (17)) + 1;

		if (my.skill40 == 01) { sPlay ("PIP512.WAV"); }
		if (my.skill40 == 02) { sPlay ("PIP513.WAV"); }
		if (my.skill40 == 03) { sPlay ("PIP514.WAV"); }
		if (my.skill40 == 04) { sPlay ("PIP515.WAV"); }
		if (my.skill40 == 05) { sPlay ("PIP516.WAV"); }
		if (my.skill40 == 06) { sPlay ("PIP517.WAV"); }
		if (my.skill40 == 07) { sPlay ("PIP518.WAV"); }
		if (my.skill40 == 08) { sPlay ("PIP519.WAV"); }
		if (my.skill40 == 09) { sPlay ("PIP520.WAV"); }
		if (my.skill40 == 10) { sPlay ("PIP521.WAV"); }
		if (my.skill40 == 11) { sPlay ("PIP522.WAV"); }
		if (my.skill40 == 12) { sPlay ("PIP523.WAV"); }
		if (my.skill40 == 13) { sPlay ("PIP524.WAV"); }
		if (my.skill40 == 14) { sPlay ("PIP525.WAV"); }
		if (my.skill40 == 15) { sPlay ("PIP526.WAV"); }
		if (my.skill40 == 16) { sPlay ("PIP527.WAV"); }
		if (my.skill40 == 17) { sPlay ("PIP528.WAV"); }

		Talking = 1;

		while (GetPosition (Voice) < 1000000) { wait(1); }
		Talking = 0;
	}
}

action Line
{
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = LineHit;

	my.skin = int(random(4)) + 1;
	ent_frame ("State",(int(random(3)) * 50));
}

action HandHit
{
	if ((MoviePlaying == 1) || (HasID == 1)) { return; }

	MoviePlaying = 1;

	vec_set(temp,camera.x);
	vec_sub(temp,player.x);
	vec_to_angle(player.pan,temp);

	player.tilt = 0;
	player.roll = 0;

	sPlay ("PIP083.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); }

	if (varPhotoID == 0) 
	{ 
		ID_Show.skin = 6;
		ID_Show.visible = on;
		pStamp.visible = on;
		pStamp.bmap = bDoc1;
	}

	sPlay ("INT001.WAV"); Talking = 2; while (GetPosition (Voice) < 1000000) { wait(1); }

	if (varPhotoID == 0) 
	{ 
		ID_Show.visible = off;
		pStamp.visible = off;
		Talking = 0; 
		MoviePlaying = 0; 
		return; 
	}

	sPlay ("PIP084.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("INT002.WAV"); Talking = 2; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("PIP085.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); }
	morph (<PipCell.mdl>,player);
	sPlay ("PIP086.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("SHK025.WAV"); Talking = 0; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("PIP087.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("SHK026.WAV"); Talking = 0; while (GetPosition (Voice) < 1000000) { wait(1); }
	morph (<Piposh.mdl>,player);
	sPlay ("SFX062.WAV"); Talking = 0; while (GetPosition (Voice) < 1000000) { wait(1); }
	sPlay ("INT003.WAV"); Talking = 2; while (GetPosition (Voice) < 1000000) { wait(1); }

	ID_Show.skin = varPhotoID;
	ID_Show.visible = on;
	pStamp.visible = on;
	pStamp.bmap = bDoc1;
	pClips.visible = on;

	Delay = 20; while (Delay > 0) { Delay = Delay - 1 * time; wait(1); }

	pStamp.bmap = bDoc2;
	sPlay ("SFX016.WAV");

	Delay = 250; while (Delay > 0) { Delay = Delay - 1 * time; wait(1); }

	ID_Show.visible = off;
	pStamp.visible = off;
	pClips.visible = off;

	Talking = 0;
	MoviePlaying = 0;

	HasID = 1;
	WriteGameData(0);
}

action Hand
{
	my.event = HandHit;
	my.enable_click = on;

	while(1)
	{
		if (ShowHand == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		if (Talking == 2) { Talk(); }
		else
		{
			if (my.skill1 == 0) { ent_frame ("Still",0); my.skill40 = 0; }
			else
			{
				if (my.skill40 == 0) { play_entsound (my,Fingers,300); my.skill40 = 1; }

				ent_frame ("Play",my.skill1);
				my.skill1 = my.skill1 + 10 * time;
				if (my.skill1 > 100) { my.skill1 = 0; }
			}
		}

		if ((my.skill1 == 0) && (int(random(60)) == 30)) { my.skill1 = 1; }

		wait(1);
	}
}

action ExitNow { Run ("Town.exe"); }

action ExitIt
{
	my.event = ExitNow;
	my.enable_impact = on;
	my.enable_push = on;
	my.enable_entity = on;
}

action PlayUFO { Run ("HitUFO.exe"); }

action Machine
{
	my.event = PlayUFO;
	my.enable_click = on;
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
