include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var V1;
var V2;
var Dim;
var CamShow = 2;
var A[3] = 0,0,0;
var Talking = 0;
var MoviePlaying = 0;

sound Ambient = <SFX108.WAV>;
synonym TempSyn { type entity; }

bmap Bk = <Zimimbk.pcx>;

panel pZimim
{
	bmap = Bk;
	layer = 2;
	flags = refresh,d3d;
}

entity Zimim
{
	type = <Zimim.mdl>;
	layer = 3;
	view = camera;
	x = 1000;
	y = -380;
	z = -125;
	pan = 180;
	ambient = 100;
}

entity Zim
{
	type = <ZimPhoto.mdl>;
	layer = 4;
	view = camera;
	x = 250;
	y = -450;
	z = 5;
	pan = -90;
	ambient = 100;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	mouse_range = 8000;

	load_level(<Taxi.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
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
		if (Talking == 1) { Talk(); } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } }

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

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION player_walkInn
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 1;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_moveInn();
}

action Talkwithme
{
	vec_set(temp,A.x);
	vec_sub(temp,player.x);
	vec_to_angle(player.pan,temp);
	player.tilt = 0; player.roll = 0;

	MoviePlaying = 1;

	sPlay ("PIP068.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("DRV001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }

	DoDialog (9);	

	while (Dialog.visible == on) { wait(1); }

	while (DialogIndex == 9)
	{
		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP069.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }

			Zim.skin = 1;
			Zim.y = -450;
			Zim.tilt = 0;
			Zim.visible = on;
			TempSyn = my;

			my = Zimim;

			my.skill39 = 0;
			my.visible = on;
			my.skill1 = 0;

			pZimim.visible = on;

			sPlay ("SNG005.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) 
			{ 
				ent_cycle ("Dance",my.skill1);
				my.skill1 = my.skill1 + 0.5 * time;
				
				if (my.skill39 == 0) { if (Zim.y < 250)  { Zim.y = Zim.y + 3 * time; Zim.tilt = Zim.tilt + 0.15 * time; } else { my.skill39 = 1; Zim.tilt = 0; Zim.skin = 2; } }
				if (my.skill39 == 1) { if (Zim.y > -250) { Zim.y = Zim.y - 3 * time; Zim.tilt = Zim.tilt - 0.15 * time; } else { my.skill39 = 2; Zim.tilt = 0; Zim.skin = 3; } }
				if (my.skill39 == 2) { if (Zim.y < 250)  { Zim.y = Zim.y + 3 * time; Zim.tilt = Zim.tilt + 0.15 * time; } else { my.skill39 = 3; Zim.tilt = 0; Zim.skin = 4; } }
				if (my.skill39 == 3) { if (Zim.y > -250) { Zim.y = Zim.y - 3 * time; Zim.tilt = Zim.tilt - 0.15 * time; } else { my.skill39 = 4; Zim.tilt = 0; Zim.skin = 5; } }
				if (my.skill39 == 4) { if (Zim.y < 250)  { Zim.y = Zim.y + 3 * time; Zim.tilt = Zim.tilt + 0.15 * time; } else { Zim.visible = off; } }
				wait(1); 
			}

			pZimim.visible = off;
			DialogIndex = 0;
			Zim.visible = off;
			Zimim.visible = off;
			my = TempSyn;
		}
	
		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP070.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("DRV002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("PIP071.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("DRV003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("PIP072.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			DialogIndex = 0;
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP073.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			DialogIndex = 0;
		}

		wait(1);
	}

	Talking = 0;
	MoviePlaying = 0;
}

action Driver
{
	my.enable_click = on;
	my.event = talkwithme;

	a.x = my.x;
	a.y = my.y;
	a.z = my.z;

	while(1)
	{
		if ((snd_playing (my.skill40) == 0) && (Zim.visible == off)) { play_sound (ambient,10); my.skill40 = result; }

		vec_set(temp,player.x);
		vec_sub(temp,my.x);
		vec_to_angle(my.pan,temp);
		my.tilt = 0; my.roll = 0; my.pan = my.pan + 90;

		if (Talking == 2) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action Cam
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt=  my.tilt;
		}

		my.skill2 = my.skill2 - 3 * time;
		if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; }		

		
		wait(1);
	}
}

action GetOut { Run ("Town.exe"); }

action Vespa
{
	my.enable_click = on;
	my.event = getout;
}

function Talk()
{
	my.skill11 = my.skill11 + 1 * time;
	if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
	if (int(random(40)) == 20) { ent_frame ("Talk",int(random(8)) * 14.2); }
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

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}