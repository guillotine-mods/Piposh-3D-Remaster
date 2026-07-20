include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var MoviePlaying = 0;
var Scene;
var PIP = 1;
var Delay = 100;
var CameraEnabled;
var n;
var cameraX[13] = 479,325,-741,1305,-2045,-178,-163,1442,-1503,-206,-796,-288,-32;
var cameraY[13] = -971,-338,790,1185,955,1635,3376,3587,3349,1610,3512,2656,2485;
var cameraZ[13] = 300,300,300,-1,-6,89,300,71,70,849,849,783,849;
var cameratemp[3] = 0,0,0;
var Closest;
var Vview = 0;
var ShikFlick = 0;
var Must1 = 0;
var Must2 = 0;
var ZTemp = 0;
var B[3] = 0,0,0;
var C[3] = 0,0,0;
var RunOrder = -1;
var Genia = 0;
var Her = 0;
var KAN = 0;
var Pluck = 0;
var FlagZ;
var Pics[17];

bmap bdrop = <drop.pcx>;
var DropY = 1;
var DropX;

sound Speech = <YCH017.WAV>;
sound BGMusic = <SNG029.WAV>;
sound Ambient = <SFX061.WAV>;
var SND = 0;
var SND1 = 0;
var SND2 = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _MANSION;

	warn_level = 0;
	tex_share = on;
	mouse_range = 8000;

	load_level(<Mansion.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack2;

	sPlay ("Wait.wav"); while (GetPosition (Voice) < 1000000) { wait(1); }

	if (Flag_First_Mansion == 0) { Scene = 1; } else { Scene = 18; }

	SetVoice();
}

function stream1
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = 0; 
		MY_SPEED.Y = 5 + (random(2) - 1) / 3;  
		MY_SPEED.Z = 10 + (random(2) - 1) / 10; 

		MY_SIZE = 300;
		MY_MAP = bdrop;
		MY_FLARE = ON;
		my_transparent = on;
		return;
	}
	// Add gravity
	MY_SPEED.Z -= scatter_gravity;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	if(MY_AGE >= 2000)
	{
		MY_ACTION = NULL;
	}
}

function stream2
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = 0; 
		MY_SPEED.Y = -5 + (random(2) - 1) / 3;  
		MY_SPEED.Z = 10 + (random(2) - 1) / 10; 

		MY_SIZE = 300;
		MY_MAP = bdrop;
		MY_FLARE = ON;
		my_transparent = on;
		return;
	}
	// Add gravity
	MY_SPEED.Z -= scatter_gravity;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	if(MY_AGE >= 2000)
	{
		MY_ACTION = NULL;
	}
}

action Fountain
{
	my.invisible = on;

	while(1)
	{
		if (my.skill1 == 1) { emit 1,my.x,stream1; } else { emit 1,my.x,stream2; }
		wait(1);
	}
}

action Picnic
{
	wait(10);
	while (MoviePlaying == 1) { wait(1); }
	remove (my);
}

action Chand
{
	while(1)
	{
		if (snd_playing (SND1) == 0) { play_entsound (my,BGMusic,600); SND1 = result; }
		if (snd_playing (SND2) == 0) { play_entsound (my,Ambient,600); SND2 = result; }
		if (MoviePlaying == 1) { snd_tune (SND1 , 10, 0, 0); snd_tune (SND2, 10, 0, 0); }
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
		if ((VView == 3) && (KAN == 0))
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

action Picture
{
	my.invisible = on;
	my.ambient = 50;
	my.skill1 = 1;

	while (my.skill1 == 1)
	{
		my.skin = int(random(16)) + 1;
		if (Pics[my.skin] == 0) { Pics[my.skin] = 1; my.skill1 = 0; }
		wait(1);
	}

	my.invisible = off;
}

action DefineDeck
{
	my.ambient = 100;
}

action DefineCard
{
	my.ambient = 100;
}

action ShikCam
{
	Ztemp = my.z;

	while(1)
	{
		if (ShikFlick == 1)
		{
			my._movemode = 1;
			temp.pan = 360;
			temp.tilt = 180;
			temp.z = 1000;
			result = scan_path(my.x,temp);
			if (result == 0) { my._MOVEMODE = 0; }

			ent_waypoint(my._TARGET_X,1);

			while (my._MOVEMODE > 0)
			{
				if (RunOrder > -1)
				{
					RunOrder = RunOrder + 1 * time;
					temp.x = MY._TARGET_X - MY.X;
					temp.y = MY._TARGET_Y - MY.Y;
					temp.z = 0;
					result = vec_to_angle(my_angle,temp);

					if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill40 = my.skill40 + 1; }

					if (my.skill40 < 14) 
					{
						force = 3;
						actor_turnto(my_angle.PAN);
						force = 3;
						actor_move(); 
	
						my.z = Ztemp;
						//my.tilt = 0;
					}

					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;
					camera.roll = my.roll;
					camera.tilt = my.tilt;
					camera.pan = my.pan;
	
					vec_set(temp,B.x);
					vec_sub(temp,camera.x);
					vec_to_angle(camera.pan,temp);
				}
				else
				{
					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;
					camera.roll = my.roll;
					camera.tilt = my.tilt;
					camera.pan = my.pan;

					C.x = my.x;
					C.y = my.y;
					C.z = my.z;

					if (RunOrder == -2)
					{
						vec_set(temp,B.x);
						vec_sub(temp,camera.x);
						vec_to_angle(camera.pan,temp);
					}
				}

				wait(1);
			}

		}

		wait(1);
	}
}

action PipIntro3
{
	while(1)
	{
		my._movemode = 1;
		temp.pan = 360;
		temp.tilt = 180;
		temp.z = 1000;
		result = scan_path(my.x,temp);
		if (result == 0) { my._MOVEMODE = 0; }

		ent_waypoint(my._TARGET_X,1);

		while (my._MOVEMODE > 0)
		{
			if (ShikFlick == 1) { my.invisible = off; my.shadow = on; player.invisible = on; player.shadow = off; } else { my.invisible = on; my.shadow = off; player.invisible = off; player.shadow = on; }

			if (RunOrder > 0)
			{
				temp.x = MY._TARGET_X - MY.X;
				temp.y = MY._TARGET_Y - MY.Y;
				temp.z = 0;
				result = vec_to_angle(my_angle,temp);

				if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill40 = my.skill40 + 1; }

				if (my.skill40 >= 13) { RunOrder = -2; }

				if (RunOrder > 20)
				{
					force = 5;
					actor_turnto(my_angle.PAN);
					force = 5;
					actor_move(); 

					ent_cycle ("Run",my.skill33);
					my.skill33 = my.skill33 + 20 * time;
				}

				my.skin = 5;

				B.x = my.x;
				B.y = my.y;
				B.z = my.z;
			}
			else 
			{ 
				if (Talking == 1) 
				{ 
					if (Genia == 0) { Talk(); }
					if (Genia == 1) { ent_frame ("Foo",0); Talk2(); }
				} else { Blink(); } 

				if (RunOrder == -2)
				{
					vec_set(temp,C.x);
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);

					my.tilt = 0;
					my.roll = 0;
				}
			}

			wait(1);
		}


		wait(1);
	}
}

action BlockHim
{
	while(RunOrder == -1) { wait(1); }
	Remove (my);	
}

action Door2
{
	while(1)
	{
		if (RunOrder > -1) { my.pan = -90; }
		wait(1);
	}
}

action Nanny
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }

		if (RunOrder == -2)
		{
			B.x = my.x;
			B.y = my.y;
			B.z = my.z;
		}

		wait(1);
	}
}

action Rogale
{
	while(1)
	{
		if (Talking == 3) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action Shik
{
	my.skill1 = my.y;
	my.y = my.y - 300;
	my.skill2 = 0;

	while(1)
	{
		my._movemode = 1;
		temp.pan = 360;
		temp.tilt = 180;
		temp.z = 1000;
		result = scan_path(my.x,temp);
		if (result == 0) { my._MOVEMODE = 0; }

		ent_waypoint(my._TARGET_X,1);

		while (my._MOVEMODE > 0)
		{
			if (ShikFlick == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

			if (RunOrder > -1)
			{
				temp.x = MY._TARGET_X - MY.X;
				temp.y = MY._TARGET_Y - MY.Y;
				temp.z = 0;
				result = vec_to_angle(my_angle,temp);

				if (result < 25) { ent_nextpoint(my._TARGET_X); }

				if (RunOrder > 50)
				{
					force = 5;
					actor_turnto(my_angle.PAN);
					force = 5;
					actor_move(); 

					ent_cycle ("Run",my.skill33);
					my.skill33 = my.skill33 + 20 * time;
				}

				if (Talking == 6) { Talk2(); } else { Blink2(); }
			}
			else
			{
				if (RunOrder != -2) { if (ShikFlick == 1) { if (my.y < my.skill1) { my.y = my.y + 5 * time; } } }

				if (Talking == 6) 
				{ 
					if (my.skill2 == 0)
					{
						if (GetPosition(Voice) >   200000) { ent_frame ("Zvat",0); }
						if (GetPosition(Voice) >   300000) { ent_frame ("Box",0); }
						if (GetPosition(Voice) >   600000) { ent_frame ("Yoyo",0); }
						if (GetPosition(Voice) >   700000) { ent_frame ("Box",0); }
						if (GetPosition(Voice) >   800000) { ent_frame ("Stand",0); }
						if (GetPosition(Voice) >= 1000000) { my.skill2 = 1; }
						Talk2();
					}
					else 
					{ 
						if (Pluck == 1) { ent_frame ("Zvat",0); talk2(); }
						else
						{
							if (Genia == 0) { Talk(); }
							if (Genia == 1) { ent_frame ("Foo",0); Talk2(); }
						}
					}
				} 
				else { Blink(); }

				if (RunOrder == -2)
				{
					vec_set(temp,C.x);
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);

					my.tilt = 0;
					my.roll = 0;
				}

			}

			wait(1);
		}

	}
}

action VaseMov
{
	if (MoviePlaying == 1) { return; }

	snd_tune (SND , 10, 0, 0);
	snd_tune (SND1, 10, 0, 0);
	snd_tune (SND2, 10, 0, 0);

	MoviePlaying = 1;
	ShikFlick = 1;

	sPlay ("PIP404.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) 
	{ 
		if (GetPosition(Voice) > 700000) { Genia = 1; } wait(1); 
	}
	Genia = 0;
	sPlay ("SHK046.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
	DoDialog (50);

	while (Dialog.visible == on) { wait(1); }

	while (Must1 + Must2 != 2)
	{
		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP405.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			Genia = 1;
			sPlay ("PIP406.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("SHK047.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			Genia = 0;
			sPlay ("SHK048.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("PIP407.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("SHK049.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			DoDialog (50); Must1 = 1;
		}
	
		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP408.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("SHK050.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("PIP409.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("SHK051.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			DoDialog (50); Must2 = 1;
		}

		if (DialogChoice == 3) 
		{ 
			sPlay ("PIP410.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("SHK052.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
			DoDialog (50);		
		}

		wait(1);
	}

	Dialog.visible = off;
	HideText();

	sPlay ("SHK070.WAV"); Pluck = 1; Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("PIP411.WAV"); Pluck = 0; Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }

	KAN = 1;
	sPlay ("JOK1401.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK1402.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK1403.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
	KAN = 0;

	sPlay ("SHK053.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("PIP412.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }

	KAN = 1;
	sPlay ("JOK2901.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK2902.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK2903.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
	KAN = 0;

	KAN = 1;
	sPlay ("JOK3001.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK3002.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("JOK3003.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
	KAN = 0;

	RunOrder = 0;
	Talking = 0;

	while (RunOrder != -2) { wait(1); }

	sPlay ("NAN031.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }	

	DoDialog (51);

	while (Dialog.visible == on) { wait(1); }

	while (DialogIndex == 51)
	{
		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP431.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			DialogIndex = 0; Talking = 0;
		}
	
		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP432.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			DialogIndex = 0; Talking = 0;
		}

		if (DialogChoice == 3) 
		{ 
			sPlay ("PIP433.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
			DialogIndex = 0; Talking = 0;
		}

		wait(1);
	}

	sPlay ("SHK054.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("ROG019.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { wait(1); }

	Mansion[0] = 1;
	WriteGameData(0);

	Run ("Cardgame.exe");
}

action Vase
{
	my.event = VaseMov;
	my.enable_click = on;

	while(1)
	{
		my.skin = 2;
		wait(1);
	}
}

action Cow
{
	while(1)
	{
		my.pan = my.pan + 3 * time;
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 3 * time;
		wait(1);
	}
}

ACTION player_move2
{
	FlagZ = my.z;
	my.z = my.z - 200;

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
		if (VView == 0) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }

		if (Talking == 1) { Talk(); } else { Blink(); }

		// if we are not in 'still' mode
		if ((MY._MOVEMODE != _MODE_STILL) && (MoviePlaying == 0))
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

		if (KAN == 0)
		{
			if (VView == 1) { move_view_1st(); }
			if (VView == 2) { move_view_3rd(); }
		}

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION player_walk2
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

function ToggleView
{
	VView = VView + 1;
	if (VView > 3) { VView = 1; }
}

on_F1 = ToggleView();

action PipIntro
{
	my.skill1 = my.x;
	my.skill3 = my.pan + 90;
	my.x = my.x + 300;

	while ((MoviePlaying == 1) && (Scene < 4) && (VView == 0))
	{
		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 48)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP394.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 4; SetVoice();
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP395.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

				KAN = 1;
				sPlay ("JOK0701.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0702.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0703.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				KAN = 0;

				DialogIndex = 0; Talking = 0; Scene = 4; SetVoice();
			}

			if (DialogChoice == 3) 
			{ 
				sPlay ("PIP396.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHK045.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 4; SetVoice();
			}
	
			wait(1);
		}

		if (Scene == 1)
		{
			if (my.x > my.skill1)
			{
				Talk2();
				my.x = my.x - 5 * time;
				ent_cycle ("Walk",my.skill2);
				my.skill2 = my.skill2 + 10 * time;
			}
			else { my.pan = my.skill3; Talk(); }
		}

		if (Scene == 2) 
		{
			my.x = my.skill1;
			my.pan = my.skill3;

			if(my.skill10 == 0) 
			{ 
				Morph (<Pipcell.mdl>,my); my.skill10 = 1; 
			}

			Blink();
		}

		wait(1);
	}

	remove (my);
}

action PipIntro2
{
	my.invisible = on;
	my.shadow = off;

	while (MoviePlaying == 1)
	{	
		if (my.skill1 != PIP) { my.invisible = on; my.shadow = off; } else { if (Scene > 3) { my.invisible = off; my.shadow = on; } }
		Delay = Delay - 0.2 * time;
		if (Delay < 0) { PIP = int(random(5)) + 1; Delay = 100; } 
		Blink();
		wait(1);
	}

	Remove (my);
}

action KrupTalk
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	snd_tune (SND , 10, 0, 0);
	snd_tune (SND1, 10, 0, 0);
	snd_tune (SND2, 10, 0, 0);

	sPlay ("KRP017.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
	DoDialog (49);

	while (Dialog.visible == on) { Blink(); wait(1); }

	while (DialogIndex == 49)
	{
		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP397.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRP018.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP398.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRP019.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("KRP020.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP399.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRP021.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

			DialogIndex = 0; Talking = 0;
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP400.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRP022.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP401.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

			DialogIndex = 0; Talking = 0;
		}

		if (DialogChoice == 3) 
		{ 
			sPlay ("PIP402.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRP023.WAV"); Talking = 2; 
			
			while (GetPosition(Voice) < 1000000) 
			{ 
				Talk2();

				if (GetPosition(Voice) < 300000) { ent_cycle ("Circle",my.skill20); my.skill20 = my.skill20 + 10 * time;}
				else 
				{ 
					if (GetPosition(Voice) < 800000) { ent_cycle ("Jump",my.skill20); my.skill20 = my.skill20 + 20 * time; } 
					else { ent_cycle ("Dance",my.skill20); my.skill20 = my.skill20 + 3 * time; }
				}

				wait(1);
			}
			sPlay ("PIP403.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

			KAN = 1;
			sPlay ("JOK2301.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("JOK2302.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("JOK2303.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
			KAN = 0;

			DialogIndex = 0; Talking = 0;
		}

		wait(1);
	}

	snd_tune (SND , 100, 0, 0);
	snd_tune (SND1, 100, 0, 0);
	snd_tune (SND2, 100, 0, 0);

	MoviePlaying = 0;
}

action Krupnik
{
	my.event = KrupTalk;
	my.enable_click = on;

	while(1)
	{
		if (Talking != 2) { Blink(); }
		wait(1);
	}
}

action Dude
{
	while(MoviePlaying == 1)
	{
		if (my.skill1 != 5) { if (Talking == my.skill1) { Talk(); } else { Blink(); } }
		else
		{
			if (Talking == 5) { Talk(); }
			else
			{
				if (Scene < 17)
				{
					if (my.skill8 > 0) { ent_frame ("Drink",0); my.skill8 = my.skill8 - 1 * time; } 
					else 
					{ 
						if (Scene > 10) { ent_cycle ("Fall",my.skill9); my.skill9 = my.skill9 + 1 * time; Blink2(); } else { Blink(); }
					}

					if (my.skill8 <= 0) { if (int(random(60)) == 30) { my.skill8 = 5; } }
				}

				if (Scene == 17) { ent_frame ("Faint",my.skill11); my.skill11 = my.skill11 + 5 * time; }
			}
		}

		wait(1);
	}

	remove (my);
}

action Cam
{
	while (MoviePlaying == 1)
	{
		if (Scene < 4)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
		}

		wait(1);
	}
}

action Glass
{	
	while (MoviePlaying == 1)
	{
		wait(1);
	}

	remove (my);
}

action Dome { my.skin = 1; while(1) { my.pan = my.pan + 0.2 * time; if (MoviePlaying == 1) { if ((GetPosition(Voice) >= 1000000) && (Scene !=3)) { Scene = Scene + 1; SetVoice(); } } wait(1); } }

action Cam2
{
	while (MoviePlaying == 1)
	{
		if (Scene >= 4)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
		}

		wait(1);
	}
}

action Flat
{
	my.skill1 = int(random(3));

	if (my.skill1 == 0) { my.skin = 10; }
	if (my.skill1 == 1) { my.skin = 13; }
	if (my.skill1 == 2) { my.skin = 16; }
}

action ExitNow
{
	if (you == player) { ReturnToMap(); }
}

action Exiter
{
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = ExitNow;
}

action KCam
{
	while(1)
	{
		if (KAN == 1)
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

action KN
{
	while(1)
	{
		if (KAN == 1) { my.invisible = off; } else { my.invisible = on; }
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action Yachdal
{
	while(1)
	{
		if (snd_Playing (SND) == 1)
		{
			if (int(random(40)) == 20) { ent_frame ("Speech",int(random(23)) * 4.54); }
			if (MoviePlaying == 1) { snd_tune (SND , 10, 0, 0); }
			Talk2();
		}
		else
		{
			Blink();
			if (int(random(200)) == 100) { play_entsound (my,Speech,1000); SND = result; }
		}

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

//on_c = camerapositionwrite();

function SetVoice
{
	if (Scene == 1) { MoviePlaying = 1; sPlay ("PIP393.WAV"); Talking = 1; }
	if (Scene == 2) { sPlay ("SHK044.WAV"); Talking = 6; }
	if (Scene == 3) { DoDialog (48); }
	if (Scene == 4) { sPlay ("NAN024.WAV"); Talking = 2; }
	if (Scene == 5) { sPlay ("ROG016.WAV"); Talking = 3; }
	if (Scene == 6) { sPlay ("NAN025.WAV"); Talking = 2; }
	if (Scene == 7) { sPlay ("MAR028.WAV"); Talking = 4; }
	if (Scene == 8) { sPlay ("NAN026.WAV"); Talking = 2; }
	if (Scene == 9) { sPlay ("KVC030.WAV"); Talking = 5; }
	if (Scene ==10) { sPlay ("NAN027.WAV"); Talking = 2; }
	if (Scene ==11) { sPlay ("KVC031.WAV"); Talking = 5; }
	if (Scene ==12) { sPlay ("NAN028.WAV"); Talking = 2; }
	if (Scene ==13) { sPlay ("KVC032.WAV"); Talking = 5; }
	if (Scene ==14) { sPlay ("ROG017.WAV"); Talking = 3; }
	if (Scene ==15) { sPlay ("NAN029.WAV"); Talking = 2; }
	if (Scene ==16) { sPlay ("KVC033.WAV"); Talking = 5; }
	if (Scene ==17) { Flag_First_Mansion = 1; WriteGameData(0); sPlay ("ROG018.WAV"); Talking = 3; }
	if (Scene ==18) { wait(1); VView = 3; player.z = FlagZ; MoviePlaying = 0; }
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}