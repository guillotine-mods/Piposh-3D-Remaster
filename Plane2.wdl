include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var PlaneCounter = 0;
var CartTemp = 0;
var HitHim = 0;
var Scene;
var Talking;
var MoviePlaying = 0;
var CameraEnabled;
var n;
var cameraX[3] = 35,-73,-40;
var cameraY[3] = 533,282,-475;
var cameraZ[3] = 90,240,240;
var posS1[3] = 0,0,0;
var posS2[3] = 0,0,0;
var cameratemp[3] = 0,0,0;
var Closest;
var Vview = 1;
var SND = 0;
var TempZ = 0;

var B[3] = 0,0,0;

var Goal_HeadPhones = 0;
var Goal_TV = 0;
var Goal_Passanger = 0;
var Goal_Sikot = 0;

sound Cockpit = <SFX089.WAV>;
sound sHammer = <SFX090.WAV>;
sound TVS = <SFX096.WAV>;
sound Jet = <SFX143.WAV>;
var JETSND = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	fog_color = 1;
	camera.fog = 30;

	vNoMap = 1;

	load_level(<Plane2.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack1;
}

action Dummy
{
	while(1)
	{
		if (snd_playing(SND) == 0) { play_entsound (my,cockpit,300); SND = result; }
		wait(1);
	}
}

action HP
{
	Scene = 1;

	MoviePlaying = 1;

	sPlay ("SHK019.WAV"); Talking = 0;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("PIP039.WAV"); Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("SHK020.WAV"); Talking = 0;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("PIP040.WAV"); Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("SHK021.WAV"); Talking = 0;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Talking = 0;
	MoviePlaying = 0;
	Scene = 0;
	Goal_Headphones = 1;
}

action HeadPhone
{
	my.ambient = 50;
	my.enable_click = on;
	my.event = HP;
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

action CamPlane
{
	while(1)
	{
		if (Scene == 2)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			vec_set(temp,B.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;

			my.z = my.z - 10 * time;
			my.x = my.x - 5 * time;
			my.y = my.y + 10 * time;
		}

		wait(1);
	}
}

action B747
{
	my.skill1 = 10;

	while(1)
	{
		if (Scene == 2)
		{
			B.x = my.x;
			B.y = my.y;
			B.z = my.z;

			my.y = my.y + my.skill1 * time;
			if (GetPosition(Voice) > 950000) 
			{ 
				if (my.skill39 == 0) { my.skill39 = 1; play_sound (Jet,100); JETSND = result; }
				my.skill1 = my.skill1 + 15 * time; 
				my.z = my.z + (my.skill1 / 5) * time; 
			}
		}

		wait(1);
	}
}

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 3000;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = 128;
		MY_COLOR.GREEN = 128;
		MY_COLOR.BLUE = 128;
	}
	else
	{
		MY_COLOR.GREEN = MY_COLOR.GREEN - 30 * time;
		MY_COLOR.BLUE = MY_COLOR.BLUE - 30 * time;
		MY_COLOR.RED = MY_COLOR.RED - 30 * time;

		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

ACTION player_move2
{
	TempZ = my.z;

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
		if ((Goal_Passanger == 1) && (Goal_TV == 1) && (Goal_Sikot == 1) && (Goal_Headphones == 1))
		{
			camera.fog = 0;
			Scene = 2;
			MoviePlaying = 1;

			sPlay ("KRP009.WAV"); Talking = 3;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			stop_sound (JETSND);

			wait(3);

			Run ("Range.exe");
		}

		if (Talking == 1) { Talk(); } else { Blink(); }

		if (my._movemode == _mode_swimming) { my._movemode = _mode_walking; }
		// if we are not in 'still' mode

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

					// move on land
					move_gravity();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		if (MoviePlaying == 0) { actor_anim(); }

		if (VView == 1) { Move_view_1st(); }
		if (VView == 2) { Move_view_3rd(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function ToggleView
{
	VView = VView + 1;
	if (VView == 2) { VView = 3; }	// Fixed: view not good, can see stuff outside plane
	if (VView > 3) { VView = 1; }
}

on_F1 = toggleView();

action HitMe
{
	HitHim = 1;
}

action Passanger
{
	my.enable_click = on;
	my.event = HitMe;

	while(1)
	{
		if (HitHim == 1)
		{
			MoviePlaying = 1;

			player.z = tempz + 500;

			if (my.skill39 == 0) { sPlay ("SFX026.WAV"); my.skill39 = 1; }

			while (my.skill1 < 100) { ent_frame ("Hit",my.skill1); my.skill1 = my.skill1 + 2 * time; wait(1); }
			if (my.skill1 < 100) { ent_frame ("Hit",my.skill1); }

			ent_frame ("Sit",0);
			sPlay ("SFX119.WAV"); while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			HitHim = 2;
			ent_frame ("Sit",0);
			sPlay ("PIP034.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			HitHim = 0;

			MoviePlaying = 0;

			player.z = tempz;
			my.skill1 = 0;
			Talking = 0;
			Goal_Passanger = 1;
			
		}
		else
		{
			my.skill39 = 0; 
			ent_frame ("Sit",0);
			Blink2();
		}

		wait(1);

	}
}

action STU1Click
{
	vec_set(temp,posS1.x);
	vec_sub(temp,player.x);
	vec_to_angle(player.pan,temp);

	player.tilt = 0;
	player.roll = 0;

	MoviePlaying = 1;
	sPlay ("PIP035.WAV");
	Talking = 1;
	while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
	Talking = 0;
	MoviePlaying = 0;
}

action STU1
{
	posS1.x = my.x;
	posS1.y = my.y;
	posS1.z = my.z;

	my.event = STU1Click;
	my.enable_click = on;

	while(1)
	{
		ent_cycle ("Stand",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		Blink2();

		vec_set(temp,player.x);
		vec_sub(temp,my.x);
		vec_to_angle(my.pan,temp);

		my.tilt = 0;
		my.roll = 0;

		wait(1);
	}
}

action TVClick
{
	MoviePlaying = 1;
	sPlay ("KRP008.WAV"); Talking = 3;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
	MoviePlaying = 0;
	Goal_TV = 1;
}

action TV
{
	my.event = TVClick;
	my.enable_click = on;

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

action A1
{
	my.passable = on;

	while(1)
	{
		if (Scene == 1) { player.invisible = on; player.shadow = off; my.invisible = off; my.shadow = on; } else { player.invisible = off; player.shadow = on; my.invisible = on; my.shadow = off; }

		if (Talking == 1) { Talk2(); } else { Blink(); }
		wait(1);
	}
}

action Krupnik
{
	my.skill2 = my.pan;

	while(1)
	{
		if (Talking == 3)
		{
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			Talk();

			my.pan = my.pan + 90;
			my.tilt = 0;
			my.roll = 0;
		} 
		else 
		{ 
			my.pan = my.skill2; 
			ent_cycle ("Stand",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			Blink();
			if (int(random(40)) == 20) { my.skill10 = 1; }
			if (my.skill10 > 0)
			{
				my.skill10 = my.skill10 + 10 * time;
				ent_frame ("Hammer",my.skill10);
				if ((my.skill10 > 50) && (my.skill10 < 60)) { play_entsound (my,sHammer,300); }
				if (my.skill10 > 100) { my.skill10 = 0; }
			}
		}

		wait(1);
	}
}

action STU2
{
	posS2.x = my.x;
	posS2.y = my.y;
	posS2.z = my.z;

	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		vec_set(temp,player.x);
		vec_sub(temp,my.x);
		vec_to_angle(my.pan,temp);

		my.tilt = 0;
		my.roll = 0;

		wait(1);
	}
}

action Cam3
{
	while (1)
	{
		if (HitHim > 0)
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

action Cam4
{
	while (1)
	{
		if (Scene == 1)
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

action SikotClick
{
	vec_set(temp,posS2.x);
	vec_sub(temp,player.x);
	vec_to_angle(player.pan,temp);

	player.tilt = 0;
	player.roll = 0;

	MoviePlaying = 1;

	sPlay ("PIP036.WAV"); Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("STU001.WAV"); Talking = 2;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("PIP037.WAV"); Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("STU002.WAV"); Talking = 2;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("PIP038.WAV"); Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Talking = 0;
	MoviePlaying = 0;
	Goal_Sikot = 1;
}

action Sikot
{
	my.enable_click = on;
	my.event = SikotClick;
}

action PiposhHit
{
	my.invisible = on;
	my.skill1 = 0;
	my.skin = 4;

	while(1)
	{
		if (HitHim == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		if (HitHim == 1) 
		{ 
			player.invisible = on; player.shadow = off;

			while (my.skill1 < 100) { ent_frame ("Kafa",my.skill1); my.skill1 = my.skill1 + 10 * time; wait(1); } 
	
			player.x = my.x;
			player.y = my.y;
			player.z = my.z;
			player.pan = my.pan;

			my.invisible = on; my.shadow = off;
			player.invisible = off; player.shadow = on;
		} else { my.skill1 = 0; }

		wait(1);
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
		if ((VView == 3) && (HitHim == 0) && (Scene == 0))
		{
			move_view_3rd();
			if(player == NULL) { player = ME; }	
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
		
			n = 0;		
			temp = 100000;

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

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];
			cameratemp.z = cameraZ[closest];

			vec_set(camera.x, cameratemp);
		}
	}
	wait(1);
	}

}

action Hammer
{
	my.skill1 = 2;
}

action Dome { my.skin = 1; while(1) { my.pan = my.pan + 0.2 * time; wait(1); } }

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

function test
{
	Goal_HeadPhones = 1;
	Goal_TV = 1;
	Goal_Passanger = 1;
	Goal_Sikot = 1;
}
//on_t = test();