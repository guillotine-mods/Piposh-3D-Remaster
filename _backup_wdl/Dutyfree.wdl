include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var OpenDoor = 0;
var DoorAbuse = 0;
var MoviePlaying = 0;
var SND1;
var SND2;
var VView = 0;

sound Engine = <SFX064.WAV>;
sound Alarm1 = <SFX129.WAV>;
sound SFX017 = <SFX017.WAV>;

bmap bMeanwhile = <mod2.pcx>;

panel pMeanwhile
{
	bmap = bMeanwhile;
	layer = 20;
	flags = d3d,refresh;
}


synonym FirstDoor { type entity; }
synonym entClerk  { type entity; }

sound SFX013WAV = <SFX013.WAV>;
sound SFX014WAV = <SFX014.WAV>;
sound DUT001WAV = <DUT001.WAV>;
sound DUT002WAV = <DUT002.WAV>;
sound DUT003WAV = <DUT003.WAV>;
sound DUT004WAV = <DUT004.WAV>;
sound DUT005WAV = <DUT005.WAV>;
sound DUT006WAV = <DUT006.WAV>;
sound DUT007WAV = <DUT007.WAV>;
sound DUT008WAV = <DUT008.WAV>;
sound DUT009WAV = <DUT009.WAV>;
sound DUT010WAV = <DUT010.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _VOLCANO;

	warn_level = 0;
	tex_share = on;
	mouse_range = 8000;

	load_level(<Dutyfree.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
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
		if (Talking == 1) { Talk(); } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } }

		// if we are not in 'still' mode
		if((MY._MOVEMODE != _MODE_STILL) && (MoviePlaying == 0))
		{
			// Get the angular and translation forces (set aforce & force values)
			_player_force();

			// find ground below (set my_height, my_floornormal, & my_floorspeed)
			scan_floor();

			// if they are on or in a passable block...
			if( ((ON_PASSABLE != 0) && (my_height_passable < (-MY.MIN_Z + 19)))    // upped from 16 to 19 (3q 'buffer')
				|| (IN_PASSABLE != 0) )
			{

				// if not already swimming or wading...
				if((MY._MOVEMODE != _MODE_SWIMMING) && (MY._MOVEMODE != _MODE_WADING))
				{
  					play_sound(splash,50);
  					MY._MOVEMODE = _MODE_SWIMMING;
//---					actor_anim_transition(anim_swim_str);	//!!!!!

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
    		  			temp.Z = MY.Z + MY.MIN_Z - my_height_passable;	// can my feet touch? (mod: 080801)
						trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
						trace(MY.POS,temp);

						if(RESULT > 0)
						{
							// switch to wading
							MY._MOVEMODE = _MODE_WADING;
 				 			MY.TILT = 0;       // stop tilting
							my_height = RESULT + MY.MIN_Z;	// calculate wading height
//---							actor_anim_transition(anim_wade_str);	//!!!!!
						}

 					}

				}// END swimming on/in a passable block
				else
				{	// not swimming

					// if wading...
 					if(MY._MOVEMODE == _MODE_WADING) // wading on/in a passable block
					{
 	/*
  						// check for swimming
						temp.X = MY.X;
    					temp.Y = MY.Y;
    					temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?

    					//SHOOT MY.POS,temp;  // NOTE: ignore passable blocks
						trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
						trace(MY.POS,temp);
 	*/
						// NEW if model center is in the water switch to swimming mode
						result = content(MY.POS);
						if (result == content_passable)
	 	//				if(RESULT == 0)
						{
							// switch to swimming
							MY._MOVEMODE = _MODE_SWIMMING;
						}
						else	// use SOLID surface for height (can't walk on water)
						{
  							// get height to solid underwater surface
							temp.X = MY.X;
    						temp.Y = MY.Y;
    						temp.Z = MY.Z - 1000;//-- + MY.MIN_Z;	// can my feet touch?

							trace_mode = IGNORE_SPRITES + IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
							result = trace(MY.POS,temp);
  							my_height = RESULT + MY.MIN_Z;    // calculate wading height
						}
					} // END wading on/in a passable block
				}



	 		} // END if they are on or in a passable block...
			else  // not in or on a passable block
			{
				// if wading or swimming while *not* on/in a passable block...
				if(   (MY._MOVEMODE == _MODE_SWIMMING)
					|| ( (ON_PASSABLE == 0) && (MY._MOVEMODE == _MODE_WADING) )
				  )
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
					if (MoviePlaying == 0) { move_gravity(); }
				}  // END (not in water)
			}// END not swimming

		} // END not in 'still' mode

		if(MY._MOVEMODE != _MODE_TRANSITION)
		{
			// animate the actor
			if (MoviePlaying == 0) { actor_anim(); }
		}

		// If I'm the only player, draw the camera and weapon with ME
		if(client_moving == 0) { move_view(); }

		carry();		// action pointer used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION player_walk2
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
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
	if (player == null) { wait(1); }

	while(1)
	{
		if (VView == 0)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
		}

		wait(1);
	}
}

action KNCam
{
	while(1)
	{
		if (VView == 1)
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


action SecCam
{
	while (1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 1;
		wait(1);
	}
}

action Dummy
{
	FirstDoor = my;	
}

action SecDoor
{
	my.skill1 = my.x; 

	if (FirstDoor == null) { wait(1); }

	while(1)
	{

		if (DoorAbuse > 0) { DoorAbuse = DoorAbuse - 1 * time; }

		if ((abs(FirstDoor.x - player.x) < 250) && (abs(FirstDoor.y - player.y) < 250))
		{
			if (my.skill8 == 1) { if (my.x < my.skill1 + 100) { my.x = my.x + 6 * time; } }
			if (my.skill8 == 2) { if (my.x > my.skill1 - 100) { my.x = my.x - 6 * time; } }

			if (OpenDoor != 1) { play_entsound (my,SFX013WAV,500); }
			OpenDoor = 1;
			DoorAbuse = DoorAbuse + 3 * time;
		}
		else
		{
			if (my.skill8 == 1) { if (my.x > my.skill1) { my.x = my.x - 6 * time; } }
			if (my.skill8 == 2) { if (my.x < my.skill1) { my.x = my.x + 6 * time; } }
			if (OpenDoor != 0) { play_entsound (my,SFX014WAV,500); }
			OpenDoor = 0;
		}

		if (DoorAbuse >= 300)
		{
			DoorAbuse = -300;

			if (Talking == 0)
			{
				play_entsound (entClerk,DUT010WAV,500); SND2 = result;
				Talking = 2;
			}
		}

	wait(1);
	}
}

action SecGlass
{
	my.skill1 = my.x;

	while(1)
	{
		if (my.skill8 == 1) 
		{ 
			if (OpenDoor == 1) { if (my.x < my.skill1 + 100) { my.x = my.x + 6 * time; } }
			else { if (my.x > my.skill1) { my.x = my.x - 6 * time; } }
		}

		if (my.skill8 == 2) 
		{ 
			if (OpenDoor == 1) { if (my.x > my.skill1 - 100) { my.x = my.x - 6 * time; } }
			else { if (my.x < my.skill1) { my.x = my.x + 6 * time; } }
		}


	wait(1);
	}
}

action Talktome
{
	if (MoviePlaying == 0)
	{
		my.y = player.y;
		MoviePlaying = 1;
		sPlay ("KRZ002.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); }
		DoDialog (18);
	}
}

action Clerk
{
	my.event = talktome;
	my.enable_click = on;

	entClerk = my;
	my.skill1 = my.y;
	
	while(1)
	{
		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 18)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP145.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("KRZ003.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP146.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (18);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP147.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("KRZ005.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP148.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("KRZ004.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

				Volcano[0] = 1;
				WriteGameData(0);

				Run ("Intro11.exe");
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP149.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				VView = 1;
				sPlay ("JOK5601.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("JOK5602.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("JOK5603.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("JOK5604.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				VView = 0;
				DoDialog (18);
			}

			wait(1);
		}

		if (MoviePlaying == 1) { my.pan = 0; }

		if (MoviePlaying == 0)
		{
			if (Talking == 2)
			{
				my.pan = 0;
				Talk();
				if (snd_playing (SND2) == 0) { Talking = 0; }
			}
			else
			{
				Blink2();
	
				if ((int(random(100)) == 50) && (my.skill2 == 0))
				{
					my.skill2 = random(500);
					my.skill3 = 0;
		
					while (my.skill3 == 0)
					{
							my.skill3 = int(random(3)) - 1;
					}
		
					my.skill4 = 0;
					my.pan = 90 * my.skill3;
				}
	
				if (my.skill2 > 0)
				{
					my.y = my.y + (my.skill3 * 5) * time;
					ent_cycle ("Walk",my.skill4);
					my.skill4 = my.skill4 + 5;
					my.skill2 = my.skill2 - 1;
				}
				else { ent_cycle ("Stand",0); my.pan = 0; my.skill2 = 0; }
	
				if ((my.skill3 < 0) && (my.y < my.skill1 - 400)) { my.skill2 = 0; }
				if ((my.skill3 > 0) && (my.y > my.skill1 + 400)) { my.skill2 = 0; }

				if (int(random(100)) == 50)
				{
					my.skill40 = int(random(9)) + 1;
					if (my.skill40 == 1) { play_entsound (my,DUT001WAV,500); }
					if (my.skill40 == 2) { play_entsound (my,DUT002WAV,500); }
					if (my.skill40 == 3) { play_entsound (my,DUT003WAV,500); }
					if (my.skill40 == 4) { play_entsound (my,DUT004WAV,500); }
					if (my.skill40 == 5) { play_entsound (my,DUT005WAV,500); }
					if (my.skill40 == 6) { play_entsound (my,DUT006WAV,500); }
					if (my.skill40 == 7) { play_entsound (my,DUT007WAV,500); }
					if (my.skill40 == 8) { play_entsound (my,DUT008WAV,500); }
					if (my.skill40 == 9) { play_entsound (my,DUT009WAV,500); }
					SND2 = result;
					Talking = 2;
					my.skill2 = 0;
				}
			}
		}

		wait(1);
	}
}

action Plane
{
	my.skin = 1;
	
	while(1)
	{
		ent_cycle ("Fly",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action MapNow { ReturnToMap(); }

action GoMap
{
	my.event = MapNow;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
}

action KN
{
	while(1)
	{
		if (VView == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
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

function Blink2()
{
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