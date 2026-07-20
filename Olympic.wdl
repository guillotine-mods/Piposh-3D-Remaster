include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Data = 0;
var S1 = -1;
var S2 = -1;
var S3 = -1;
var S4 = -1;
var S5 = -1;
var S6 = -1;
var WaterOrigion = 0;
var Ignore = 0;
var SNDw1;
var SNDw2;
var SNDw3;
var SNDw4;
var SNDw5;
var SNDw6;
var DustSet = 3;
var Training = 0;
var NutMovie = 0;
var EndMovie = 0;
var HasDust = 0;
var HasNut = 0;
var cameratemp[3] = 0,0,0;
var n = 1;
var MoviePlaying = 0;
var closest = 0;
var cameraX[8] = 345,576,423,-271,912,1810,1833,1257;
var cameraY[8] = -580,-579,86,-448,-462,-967,817,40;
var cameraZ[8] = 0,0,0,0,0,0,0,0;
var Give = 0;
var ThePlace = 0;
var CamShow = 0;
var Flick = 0;
var OldOut = 0;
var GoalDone = 0;
var NutAway = 0;

var VView = 2;

synonym Nut { type entity; }
synonym SW1 { type entity; }
synonym SW2 { type entity; }
synonym SW3 { type entity; }
synonym SW4 { type entity; }
synonym SW5 { type entity; }
synonym SW6 { type entity; }

bmap bdrop = <drop.bmp>;

bmap Dusty = <cursor2.pcx>;
bmap Nutty = <cursor3.pcx>;

sound Whistle1 = <Whistle1.wav>;
sound Whistle2 = <Whistle2.wav>;
sound Say1 = 	 <TRN001.WAV>;
sound Say2 = 	 <TRN012.WAV>;
sound Say3 = 	 <TRN013.WAV>;
sound Say4 = 	 <TRN014.WAV>;
sound Say5 = 	 <TRN015.WAV>;
sound Say6 = 	 <TRN016.WAV>;
sound Say7 = 	 <TRN017.WAV>;
sound Say8 = 	 <TRN018.WAV>;
sound Say9 = 	 <TRN019.WAV>;
sound Say10 = 	 <TRN020.WAV>;
sound Say11 = 	 <TRN021.WAV>;
sound sRun =	 <SFX066.WAV>;
sound Drop1 =	 <SFX069.WAV>;
sound Drop2 = 	 <SFX070.WAV>;
sound Swr   =    <SFX054.WAV>;

sound BGMusic = <SNG022.WAV>;

var Say = 0;
var Whis = 0;

entity Bracha
{
	type = <Grandma2.mdl>;
	layer = 3;
	view = camera;
	x = 50;
	y = -60;
	z = -30;
	pan = 180;
	roll = 20;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _OLYMPIC;

	warn_level = 0;
	tex_share = on;

	load_level(<Olympic.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	play_loop (BGMusic,50);
}

action KCam
{
	while(1)
	{
		if (VView == 4)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

action PipTalk
{
	while(1)
	{
		if (MoviePlaying == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		if (Give == 1) { ent_frame ("Take",30); Talk2(); } 
		else { if (Talking == 1) { Talk(); } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } } }
		wait(1);
	}
}

action OldTalk
{
	while(1)
	{
		if (MoviePlaying == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		if (Give == 1) { ent_frame ("Take",0); Blink2(); } 
		else
		{
			if (Give == 2) { ent_frame ("Take",0); Talk2(); } 
			else
			{
				if (Give == 3) { ent_frame ("Eat",0); Talk2(); }
				else { if (Talking == 5) { Talk(); } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } } }
			}
		}
		wait(1);
	}
}

action OldyTalk
{
	while(1)
	{
		if (MoviePlaying == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		if (Talking == 7) { Talk(); } else { ent_frame ("Talk",0); Blink2(); }
		wait(1);
	}
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
		Bracha.skill45 = Bracha.skill45 + 1 * time;
		if (Bracha.skill45 > 1.5) { Bracha.skin = int(random(7))+1; Bracha.skill45 = 0; }

		if (Talking == 1) { Talk(); } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } }

		if ((Talking == 1) && (EndMovie == 0)) { if (GetPosition (Voice) >= 1000000) { Talking = 0; } }

		if (my._movemode == _mode_swimming) { my._movemode = _mode_walking; }
		// if we are not in 'still' mode

		if ((MoviePlaying == 1) && (Flick == 1)) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }

		if((MY._MOVEMODE != _MODE_STILL)&&(MoviePlaying == 0))
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
  					//play_sound(splash,50);
  					//MY._MOVEMODE = _MODE_SWIMMING;
  					MY._MOVEMODE = _MODE_WALKING;

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

					if (EndMovie == 0) { move_gravity(); }
					else
					{
						my.x = my.x - 5 * time;
						ent_cycle ("Walk",my.skill40);
						my.skill40 = my.skill40 + 5 * time;
						my.pan = 180;
					}

				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		if ((MoviePlaying == 0) && (EndMovie == 0)) { actor_anim(); }

		if (EndMovie == 0)
		{
			if (VView == 1) { Move_view_1st(); }
			if (VView == 3) { Move_view_3rd(); }
		}

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	while (1)
	{
		if (VView == 2)
		{
			move_view_3rd();
			if(player == NULL) { player = ME; }	
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			if player.skill1 == 1 { vec_to_angle(camera.pan,temp); }
		
			n = 0;		
			temp = 100000;

			if player.Skill1 == 1 
			{
				while (n < cameraX.length) 
				{
					cameratemp.x = cameraX[n];
					cameratemp.y = cameraY[n];
					cameratemp.z = cameraZ[n];
			
					if vec_dist(cameratemp.x,player.x) < temp {
					temp = vec_dist (cameratemp,player.x);
					closest = n;
				}

				n = n + 1;
			}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];
			cameratemp.z = cameraZ[closest];

			vec_set(camera.x, cameratemp);
		}
	}
	wait(1);
	}
}

ACTION player_walk2
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_move2();
}

action GiveNut
{
	if (HasNut == 1)
	{
		MoviePlaying = 1; Flick = 1;

		sPlay ("PIP216.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { if (GetPosition(Voice) > 600000) { Give = 1; } wait(1); }
		Give = 2;
		HasNut = 0;
		mouse_map = PozCursor;
		sPlay ("OLD004.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
		Give = 3;
		sPlay ("PIP217.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
		Give = 0;
		sPlay ("TRN006.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
		sPlay ("OLD005.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
		OldOut = 1;
		DoDialog (26);

		while (Dialog.visible == on) { wait(1); }

		while (DialogIndex == 26)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP218.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN007.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("PIP221.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("OLD006.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN008.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DoDialog (27);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP219.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN007.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("PIP221.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("OLD006.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN008.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DoDialog (27);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP220.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN007.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("PIP221.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("OLD006.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN008.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DoDialog (27);
			}

			wait(1);
		}

		while (Dialog.visible == on) { ent_Frame ("stand",0); my.skin = 1; wait(1); }

		while (DialogIndex == 27)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP222.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN009.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0;
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP223.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN009.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0;
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP224.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("TRN009.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0;
			}

			wait(1);

		}
	} 

	Talking = 0;
	MoviePlaying = 0;
	Flick = 0;
}

action RunInCircle
{
	my.skill10 = my.z - 10;
	my.skill20 = 0;
	actor_init();
	drop_shadow();
	my._movemode = 1;
	my.passable = on;
	my.event = givenut;
	my.enable_click = on;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found
	my.skill39 = random(3) + 2;

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (my.flag1 == on)
		{
			if (MoviePlaying == 1) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }
		}

		if (Training == 0)
		{
			// find direction
			temp.x = MY._TARGET_X - MY.X;
			temp.y = MY._TARGET_Y - MY.Y;
			temp.z = 0;
			result = vec_to_angle(my_angle,temp);

			// near target? Find next waypoint
			// compare radius must exceed the turning cycle!
			if (result < 25) { ent_nextpoint(my._TARGET_X); }

			// turn and walk towards target
			force = 6;
			actor_turnto(my_angle.PAN);
			force = 6;
			actor_move();

			my.skill40 = my.skill40 + 1 * time;
			if (my.skill40 > my.skill39) { play_entsound (my,sRun,300); my.skill40 = 0; }

			my.z = my.skill10;
			ent_cycle ("Run",my.skill21);
		}

		if (Training == 1)
		{
			ent_cycle ("Work",my.skill21);
		}

		my.skill21 = my.skill21 + 6 * time;

		wait(1);
	}
}

function CheckState (Data)
{
	if (Data == 1) { return (S1); }
	if (Data == 2) { return (S2); }
	if (Data == 3) { return (S3); }
	if (Data == 4) { return (S4); }
	if (Data == 5) { return (S5); }
	if (Data == 6) { return (S6); }
}

action ShowerHead
{
	if (my.skill1 == 1) { SW1 = my; }
	if (my.skill1 == 2) { SW2 = my; }
	if (my.skill1 == 3) { SW3 = my; }
	if (my.skill1 == 4) { SW4 = my; }
	if (my.skill1 == 5) { SW5 = my; }
	if (my.skill1 == 6) { SW6 = my; }

	while(1)
	{
		if (CheckState(my.skill1) == 1)
		{
			WaterOrigion = my.skill1;
			temp.x = my.x;
			temp.y = my.y;
			temp.z = my.z + 20;
			emit 1,temp.x,stream2;
			emit 1,temp.x,stream2;
			emit 1,temp.x,stream2;
		}

		else
		{
			WaterOrigion = my.skill1;
			if (my.skill5 > 50)
			{
				emit 1,my.x,stream;
				my.skill5 = 0;
			}
			my.skill5 = my.skill5 + 3 * time;
		}

		wait(1);
	}
}

function stream()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(80) + 50;
		my_map = bdrop;
		MY_SPEED.X = (RANDOM(3)-1) * 2;
		MY_SPEED.Y = (RANDOM(3)-1) * 2;
		MY_SPEED.Z = random(10)-30;
	}
	else
	{
		if((MY_AGE > 6.5) && (MY_AGE < 7.5)) 
		{ 
			if (int(random(2)) == 1) 
			{
				if (int(random(30)) == 1) 
				{ 
					if (WaterOrigion == 1) { play_entsound (SW1,drop1,250); }
					if (WaterOrigion == 2) { play_entsound (SW2,drop1,250); }
					if (WaterOrigion == 3) { play_entsound (SW3,drop1,250); }
					if (WaterOrigion == 4) { play_entsound (SW4,drop1,250); }
					if (WaterOrigion == 5) { play_entsound (SW5,drop1,250); }
					if (WaterOrigion == 6) { play_entsound (SW6,drop1,250); }
				}
			} 
			else 
			{ 
				if (int(random(30)) == 1) 
				{ 
					if (WaterOrigion == 1) { play_entsound (SW1,drop2,250); }
					if (WaterOrigion == 2) { play_entsound (SW2,drop2,250); }
					if (WaterOrigion == 3) { play_entsound (SW3,drop2,250); }
					if (WaterOrigion == 4) { play_entsound (SW4,drop2,250); }
					if (WaterOrigion == 5) { play_entsound (SW5,drop2,250); }
					if (WaterOrigion == 6) { play_entsound (SW6,drop2,250); }
				}
			} 
			
			my_speed.z = 5; 
		}

		if(MY_AGE > 7.5) { my_speed.z = my_speed.z - 0.5; }
		if(MY_AGE > 20) { MY_ACTION = NULL; }
	}
}

function stream2()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(80) + 50;
		my_map = bdrop;
		MY_SPEED.X = (RANDOM(3)-1) * 2;
		MY_SPEED.Y = (RANDOM(3)-1) * 2;
		MY_SPEED.Z = random(10)-30;
	}
	else
	{
		if((MY_AGE > 6.5) && (MY_AGE < 7.5)) 
		{ 
			if (WaterOrigion == 1) { if (snd_playing (SNDW1) == 0) { play_entsound (SW1,swr,250); SNDW1 = result; } }
			if (WaterOrigion == 2) { if (snd_playing (SNDW2) == 0) { play_entsound (SW1,swr,250); SNDW2 = result; } }
			if (WaterOrigion == 3) { if (snd_playing (SNDW3) == 0) { play_entsound (SW1,swr,250); SNDW3 = result; } }
			if (WaterOrigion == 4) { if (snd_playing (SNDW4) == 0) { play_entsound (SW1,swr,250); SNDW4 = result; } }
			if (WaterOrigion == 5) { if (snd_playing (SNDW5) == 0) { play_entsound (SW1,swr,250); SNDW5 = result; } }
			if (WaterOrigion == 6) { if (snd_playing (SNDW6) == 0) { play_entsound (SW1,swr,250); SNDW6 = result; } }
			
			my_speed.z = 5; 
		}

		if(MY_AGE > 7.5) { my_speed.z = my_speed.z - 0.5; }
		if(MY_AGE > 20) { MY_ACTION = NULL; }
	}
}


action Shower
{
	my.tilt = my.tilt + 45;
	if (Talking != 1) 
	{ 
		my.skill18 = int(random(4)) + 1;
		if (my.skill18 == 1) { sPlay ("PIP209.WAV"); Talking = 1; }
		if (my.skill18 == 2) { sPlay ("PIP210.WAV"); Talking = 1; }
		if (my.skill18 == 3) { sPlay ("PIP211.WAV"); Talking = 1; }
	}

	if (my.skill1 == 1) { S1 = S1 * -1; }
	if (my.skill1 == 2) { S2 = S2 * -1; }
	if (my.skill1 == 3) { S3 = S3 * -1; }
	if (my.skill1 == 4) { S4 = S4 * -1; }
	if (my.skill1 == 5) { S5 = S5 * -1; }
	if (my.skill1 == 6) { S6 = S6 * -1; }
}

action Handle
{
	my.event = Shower;
	my.enable_click = on;
}

action Dummy
{
	ThePlace = my.z;
}

action OpenClose
{
	if (DustSet <= 0)
	{
		if (my.skill1 == 1) 
		{ 
			my.skill1 = 0;
			ent_frame ("Open",0);
			if (my.flag2 == on) { sPlay ("SFX042.WAV"); } else { sPlay ("SFX067.WAV"); }
		}
		else
		{
			my.skill1 = 1;
			ent_frame ("Close",0);
			if (my.flag2 == on) { sPlay ("SFX042.WAV"); } else { sPlay ("SFX068.WAV"); }
		}
	}
}

action Locker
{
	my.skill1 = 1;
	my.event = OpenClose;
	my.enable_click = on;
}

action IntroCam
{
	while(1)
	{
		if ((MoviePlaying == 1) && (Flick == 1))
		{
			if (CamShow == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
				camera.pan = my.pan;
			}

			my.skill2 = my.skill2 - 1 * time;
			if (my.skill2 < 0) { CamShow = int(random(3)) + 1; my.skill2 = random(200) + 150; }
		}

		wait(1);
	}
}

ACTION TRNClick
{
	if (OldOut == 1) { return; }
	if (MoviePlaying == 1) { return; }
	if (Ignore == 1) { return; }

	MoviePlaying = 1; Flick = 1;

	sPlay ("TRN002.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
	sPlay ("OLD001.WAV"); Talking = 7; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
	sPlay ("OLD002.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
	sPlay ("TRN003.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
	sPlay ("OLD003.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
	sPlay ("TRN004.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

	DoDialog (25);

	while (Dialog.visible == on) { ent_Frame ("stand",0); my.skin = 1; wait(1); }

	while (DialogIndex == 25)
	{
		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP212.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
			play_moviefile ("MOV\\Movie1.avi");
			DoDialog (25);
		}
	
		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP213.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
			sPlay ("TRN010.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP214.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
			DoDialog (25);
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP215.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { ent_Frame ("stand",0); my.skin = 1; wait(1); }
			sPlay ("TRN005.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			DialogIndex = 0; Talking = 0; MoviePlaying = 0; Ignore = 1;
		}

		wait(1);
	}

	Talking = 0;
	MoviePlaying = 0;
	Flick = 0;
}

action Coach
{
	my.event = TRNClick;
	my.enable_click = on;

	SaySomething();

	while(1)
	{
		if (MoviePlaying == 0)
		{
			my.skill22 = my.skill22 + 3 * time;

			if ((snd_playing(Say) == 0) && (my.skill30 == 0)) { my.skill1 = 2; my.skill2 = 0; my.skill22 = 0; if (Training == 0) { Training = 1; play_entsound (my,whistle1,1000); Whis = result; my.skill30 = 1; } else { Training = 0; play_entsound (my,whistle2,1000); Whis = result; my.skill30 = 1; } }

			if (my.skill30 == 1)
			{
				if (snd_playing(Whis) == 0) { SaySomething(); my.skill30 = 0; }
			}

			if (my.skill1 == 0) { ent_frame ("Stand",0); } 
			if (my.skill1 == 1) { ent_cycle ("Smack",my.skill2); my.skill2 = my.skill2 + 9 * time; }
			if (my.skill1 == 2) { ent_cycle ("Whistle",0); my.skill2 = my.skill2 + 9 * time; my.skin = 4; }

			if (my.skill2 > 100) { my.skill2 = 0; my.skill1 = 0; }
			if ((int(random(40)) == 20) && (my.skill1 == 0)) { my.skill1 = 1; }

			if (my.skill1 != 2) { Talk2(); }

			my.skill3 = my.skill3 + 3 * time;
		}
//		else
//		{
//			if (Talking == 4) { Talk2(); } else { ent_Frame ("stand",0); }
//		}

		if (Talking == 4) { talk(); } else { if (MoviePlaying == 1) { blink(); } else { blink2(); } }

		wait(1);
	}
}

function SaySomething
{
	my.skill10 = int(random(11)) + 1;

	if (my.skill10 == 1)  { play_entsound (my,say1,1000); Say = result; }
	if (my.skill10 == 2)  { play_entsound (my,say2,1000); Say = result; }
	if (my.skill10 == 3)  { play_entsound (my,say3,1000); Say = result; }
	if (my.skill10 == 4)  { play_entsound (my,say4,1000); Say = result; }
	if (my.skill10 == 5)  { play_entsound (my,say5,1000); Say = result; }
	if (my.skill10 == 6)  { play_entsound (my,say6,1000); Say = result; }
	if (my.skill10 == 7)  { play_entsound (my,say7,1000); Say = result; }
	if (my.skill10 == 8)  { play_entsound (my,say8,1000); Say = result; }
	if (my.skill10 == 9)  { play_entsound (my,say9,1000); Say = result; }
	if (my.skill10 == 10) { play_entsound (my,say10,1000); Say = result; }
	if (my.skill10 == 11) { play_entsound (my,say11,1000); Say = result; }
}

action TakeDust
{
	if (my.flag1 == on)
	{
		sPlay ("SFX104.WAV");
		HasDust = 1;
		mouse_map = Dusty;
	}
}

action Stuff
{
	my.event = TakeDust;
	my.enable_click = on;

	while (DustSet > 0)
	{
		if (int(random(100)) == 50) 
		{ 
			if (my.flag1 != on)
			{
				my.flag1 = on;
				DustSet = DustSet - 1; 
			}
		}

		wait(1);
	}
}

action Flood
{
	my.skill1 = my.z;
	my.passable = on;

	while(1)
	{
		if ((S1 == 1) && (S2 == 1) && (S3 == 1) && (S4 == 1) && (S5 == 1) && (S6 == 1))
		{
			if (my.z < my.skill1 + 10) { my.z = my.z + 0.01; }
		}
		else
		{
			if (my.z > my.skill1) { my.z = my.z - 0.01; }
		}
		wait(1);
	}
}

action NutTake
{
	sPlay ("PIP208.WAV"); Talking = 1;
	mouse_map = Nutty;
	HasNut = 1;
	my.invisible = on;
	my.shadow = off;
	NutAway = 0;

	S1 = -1;
	S2 = -1;
	S3 = -1;
	S4 = -1;
	S5 = -1;
	S6 = -1;
}

action Flood2
{
	my.skill1 = my.z;
	my.passable = on;

	my.event = NutTake;
	my.enable_click = on;

	while(1)
	{
		if (NutMovie == 101)
		{
			my.invisible = off;
			my.shadow = on;
			my.z = my.skill1;

			S1 = -1;
			S2 = -1;
			S3 = -1;
			S4 = -1;
			S5 = -1;
			S6 = -1;

			NutMovie = 0;
		}

		if (NutAway == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		if (my.skill3 > 10) 
		{
			my.pan = my.pan + (int(random(3)) - 1) * 10;
			my.tilt = my.tilt + (int(random(3)) - 1) * 10;
			my.roll = my.roll + (int(random(3)) - 1) * 10;
			my.skill3 = 0;
		}
		
		my.skill3 = my.skill3 + 1;


		if ((S1 == 1) && (S2 == 1) && (S3 == 1) && (S4 == 1) && (S5 == 1) && (S6 == 1))
		{
			if (NutAway == 1)
			{
				if (my.z < my.skill1 + 10) { my.z = my.z + 0.03 * time; }
			}
		}
		else
		{
			if (my.z > my.skill1) { my.z = my.z - 0.03 * time; }
		}
		wait(1);
	}
}

ACTION DigClick
{
	if (MoviePlaying == 1) { return; }
	MoviePlaying = 1;

	if (HasNut == 1)
	{
		sPlay ("DIG001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		sPlay ("PIP225.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("DIG002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		HasNut = 0;
		mouse_map = PozCursor;
		MoviePlaying = 0;
		NutMovie = 100;
		while (NutMovie != 0) { wait(1); }
		NutMovie = 101;
		while (NutMovie != 0) { wait(1); }
		return;
	}

	if (HasDust == 1)
	{
		sPlay ("SFX139.WAV");
		my.skill1 = 0;
		mouse_map = PozCursor;
		HasDust = 0;

		while(my.skill1 < 100)
		{
			ent_cycle ("Sneeze",my.skill1);
			if (my.skill1 < 50) { my.skill1 = my.skill1 + 3 * time; } else { my.skill1 = my.skill1 + 9 * time; }
			if (my.skill1 > 99) { NutMovie = 1; }
			wait(1);
		}
	}

	else
	{
		sPlay ("DIG003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (28);

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 28)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP226.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP227.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP228.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP229.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP230.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (28);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP233.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP234.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP235.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG011.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (29);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP231.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP232.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (28);
			}

			wait(1);
		}

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 29)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP236.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG011.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (29);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP238.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG011.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (29);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP237.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

				VView = 4;
				sPlay ("JOK0401.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0402.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0403.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0404.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0405.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0406.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0407.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0408.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0409.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0410.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0411.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0412.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0413.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0414.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0415.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0416.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0417.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0418.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0419.WAV"); Talking = 0 ; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0421.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0422.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0423.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				VView = 2;

				sPlay ("DIG012.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

				if (OldOut == 0)
				{
					sPlay ("DIG013.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					DialogIndex = 0; MoviePlaying = 0; Talking = 0;
				}
				else
				{
					sPlay ("DIG014.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					DoDialog (30);
				}
			}

			wait(1);
		}

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 30)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP239.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (30);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP240.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG015.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP241.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG017.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP243.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				Bracha.visible = on;
				sPlay ("BRA015.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				Bracha.visible = off;
				sPlay ("PIP244.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialogIndex = 0; 
				MoviePlaying = 0; 
				Talking = 5;
				EndMovie = 1;
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP242.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("DIG016.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("DIG017.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP243.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				Bracha.visible = on;
				sPlay ("BRA015.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				Bracha.visible = off;
				sPlay ("PIP244.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialogIndex = 0; 
				MoviePlaying = 0; 
				Talking = 5;
				EndMovie = 1;

			}

			wait(1);
		}
	}

	MoviePlaying = 0;
}

action Rec
{
	my.event = DigClick;
	my.enable_click = on;

	while(1)
	{
		if (EndMovie == 1)
		{
			if (Talking == 6) 
			{ 
				sPlay ("DIG018.WAV"); 
				while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } 

				Olympic[0] = 1;
				WriteGameData(0);

				Run ("Race.exe");
			}
			else { Blink(); }
		}

		wait(1);
	}
}

action ExitNow 
{ 
	ReturnToMap();
}

action ExitIt
{
	my.event = ExitNow;
	my.enable_push = on;
	my.enable_impact = on;
	my.enable_entity = on;
}

action NutX
{
	Nut = my;
	my.skill1 = 0;
	my.skill2 = 10;

	my.skill10 = my.scale_x;
	my.skill11 = my.scale_y;
	my.skill12 = my.scale_z;

	my.skill13 = my.x;
	my.skill14 = my.y;
	my.skill15 = my.z;

	while(1)
	{
		if (NutMovie == 1)
		{
			NutAway = 1;
			my.scale_x = 1;
			my.scale_y = 1;
			my.scale_z = 1;

			my.x = my.x + 25 * time;
			my.y = my.y - 37 * time;
			my.z = my.z + my.skill2 * time;

			my.pan = my.pan + 30 * time;
			my.roll = my.roll + 30 * time;
			my.tilt = my.tilt + 30 * time;

			my.skill2 = my.skill2 - 0.75 * time;
			my.skill1 = my.skill1 + 3 * time;
			if (my.skill1 > 100) { NutMovie = 2; }
		}

		if (NutMovie == 100)
		{
			my.scale_x = my.skill10;
			my.scale_y = my.skill11;
			my.scale_z = my.skill12;

			my.x = my.skill13;
			my.y = my.skill14;
			my.z = my.skill15;

			my.skill1 = 0;
			my.skill2 = 10;

			NutMovie = 0;
			NutAway = 0;
		}

		wait(1);
	}
}

action NutCam
{
	if (Nut == null) { wait(1); }

	while(1)
	{
		if (NutMovie == 1)
		{
			vec_set(temp,Nut.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

action EndCam
{
	while(1)
	{
		if (EndMovie == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);
	}
}


action Tread
{
	while(1)
	{
		my.u = my.u + 10 * time;
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
}

function Talk2()
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

function SwitchView { if (VView !=4 ) { VView = VView + 1; if (VView > 3) { VView = 1; } } }

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

action KN
{
	while(1)
	{
		if (VView == 4) { my.invisible = off; } else { my.invisible = on; }
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action Dude
{
	my.skill2 = my.x;
	my.x = my.x + 400;

	while(1)
	{
		if (EndMovie == 1) 
		{ 
			my.invisible = off; my.shadow = on;
			if (Talking == 5) { my.x = my.x - 5 * time; ent_cycle("Walk",my.skill3); my.skill3 = my.skill3 + 10 * time; }
			if (Talking == 6) { my.x = my.x - 5 * time; ent_cycle("Walk",my.skill3); my.skill3 = my.skill3 + 10 * time; }
			if ((Talking == 5) && (my.x <= my.skill2)) { Talking = 0; }
	
			if (Talking == 0)
			{
				if (my.skill1 == 1)
				{
					my.pan = my.pan + 180;
					sPlay ("MAR027.WAV"); while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					my.pan = my.pan + 180;
					Talking = 6;
				}
			}
				
		}

		wait(1);
	}
}

on_F1 = SwitchView();