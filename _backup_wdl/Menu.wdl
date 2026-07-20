include <IO.wdl>;

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var SND;
var PrevZ;
var SelectStar;
var NoMovie = 0;

synonym PathDummy { type entity; }
synonym MainPlatform { type entity; }

bmap star1 = <Star1.pcx>;
bmap star2 = <Star2.pcx>;
bmap star3 = <Star3.pcx>;

bmap bShow1 = <ShowMov1.pcx>;
bmap bShow2 = <ShowMov2.pcx>;
bmap bShow3 = <ShowMov3.pcx>;

bmap bMenu = <mainmsg.pcx>;
bmap bBt1A = <msgbtn1a.pcx>;
bmap bBt1B = <msgbtn1b.pcx>;
bmap bBt2A = <msgbtn2a.pcx>;
bmap bBt2B = <msgbtn2b.pcx>;

panel pMenu
{
	bmap = bMenu;
	pos_x = 170;
	pos_y = 100;
	layer = 2;
	flags = refresh,d3d,overlay;

	button = 70, 200, bBt1A, bBt1B, bBt1A, EndThis, null, null;
	button = 193, 192, bBt2A, bBt2B, bBt2A, TryAgain, null, null;
}

panel pShow
{
	bmap = bShow1;
	pos_x = 460;
	pos_y = 450;

	flags = visible,d3d,refresh,overlay;

	button 0, 0, bShow3, bShow1, bShow3, MovClick, null, null;
}

function MovClick
{
	if (pShow.bmap == bShow1)
	{
		pShow.Bmap = bShow2;
		NoMovie = 1;

		filehandle = file_open_write ("Movie.dat");
			file_var_write (filehandle,NoMovie);
		file_close (filehandle);
	}
	else
	{
		pShow.Bmap = bShow1;
		NoMovie = 0;

		filehandle = file_open_write ("Movie.dat");
			file_var_write (filehandle,NoMovie);
		file_close (filehandle);
	}
}

function EndThis { DoExit(); }
function TryAGain { main(); }

sound BGMusic = <SNG032.WAV>;

function main()
{
	wait(3);

	fog_color = 1;
	camera.fog = 30;

	vNoMap = 1;

	warn_level = 0;
	tex_share = on;

	load_level(<Menu.WMB>);

	VoiceInit();
	Initialize();

	play_loop (BGMusic,50);
	SND = result;

	Starfield();
}

action Platform
{
	MainPlatform = my;

	my.skill2 = 0.07;
	my.skill3 = 0.07;

	while (player == null) { wait(1); }

	while(1)
	{
		my.pan = my.pan + 0.5 * time;
		player.pan = player.pan + 0.5 * time;
		my.roll = my.roll + my.skill2 * time;
		my.tilt = my.tilt + my.skill3 * time;

		if (int(random(100)) == 50) { my.skill2 = -my.skill2; }
		if (int(random(100)) == 50) { my.skill3 = -my.skill3; }

		wait(1);
	}
}

action GoToDoor
{
	if ((you == player) && (player.transparent == off))
	{
		stop_sound (SND);
		if (my.skill1 == 1) { sPlay ("MenuNew.wav"); }
		if (my.skill1 == 2) { sPlay ("MenuLoad.wav"); }
		if (my.skill1 == 3) { sPlay ("MenuExit.wav"); }
		if (my.skill1 == 4) { sPlay ("MenuCred.wav"); }

		player.__slopes = off;
		player.tilt = 0;
		player.roll = 0;
		player.transparent = on;
		player.alpha = 100;
		while (player.alpha > 0) { player.alpha = player.alpha - 10 * time; wait(1); }

		while (player.skill40 < 100)
		{
			mainplatform.z = mainplatform.z - 60 * time;
			mainplatform.pan = mainplatform.pan + 20 * time;
			player.z = player.z - 60 * time;
			player.skill40 = player.skill40 + 2 * time;
			wait(1);
		}

		if (my.skill1 == 1) 
		{ 
			// Initialize 
			var n;

			n = 0; while (n <= 4) { Piece[n] = 0; n = n + 1; }
			n = 0; while (n <= 4) { Village[n] = 0; n = n + 1; }
			n = 0; while (n <= 4) { Volcano[n] = 0; n = n + 1; }
			n = 0; while (n <= 3) { Olympic[n] = 0; n = n + 1; }
			n = 0; while (n <= 2) { Mansion[n] = 0; n = n + 1; }
			n = 0; while (n <= 2) { Asylum[n] = 0; n = n + 1; }

			flag_first_Village = 0;
			flag_first_Volcano = 0;
			flag_first_Olympic = 0;
			flag_first_Mansion = 0;
			flag_first_Asylum = 0;

			varPhotoID = 0;
			HasID = 0;
			varNewMap = 0;

			n = 0; while (n <= 31) { AFG[n] = 0; n = n + 1; }

			WriteGameData(0);

			Run ("Studio.exe"); 
		}

		if (my.skill1 == 2) 
		{
			CreateScreenshots();
			while (ScreenShotsLoaded == 0) { wait(1); }

			entSaveLoadMenu.visible = off;
			pConsole.visible = off;

			entVaseMenu1.visible = off;
			entVaseMenu2.visible = off;
			entVaseMenu3.visible = off;
			entVaseMenu4.visible = off;
			entVaseMenu5.visible = off;

			entMillMenu.visible = off;
			entPiposhMenu.visible = off;

			ShowSaveText();
			SaveOrLoad = 2;
			SavePanel.visible = on;

			while (savepanel.visible == on) { wait(1); } 

			main();
		}

		if (my.skill1 == 3) { DoExit(); }

		if (my.skill1 == 4) { Run ("Credits.exe"); }
	}
}

action MenuDoor
{
	my.skill2 = 3;
	my.transparent = on;
	my.alpha = 0;
	my.invisible = off;

	my.event = GoToDoor;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	while (MainPlatform == null) { wait(1); }

	while(1)
	{
		my.tilt = MainPlatform.tilt;
		my.roll = MainPlatform.roll;
		my.pan = MainPlatform.pan;
		my.z = MainPlatform.z;

		my.alpha = my.alpha + my.skill2 * time;
		if ((my.alpha >= 60) || (my.alpha < -100)) { my.skill2 = -my.skill2; }

		wait(1);
	}
}

action Cam
{
	while(1)
	{
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;

		vec_set(temp,player.x);
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);

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
	while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL) && (my.transparent == off))
	{
		Blink();

		if (my._movemode == _mode_swimming) { my._movemode = _mode_walking; }
		// if we are not in 'still' mode

		if (MY._MOVEMODE != _MODE_STILL)
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

		actor_anim();

		if (my.z < (PrevZ - 50)) 
		{
			if (my.skill39 == 0) { sPlay ("PIP564.WAV"); my.skill39 = 1; }
			ent_frame ("Fetch",80);
			my.pan = my.pan + 10 * time;
		}
		else
		{
			while (pMenu.visible == on) { pMenu.visible = off; }
		}

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

action FreeMe
{
	if (event_type == event_entity)
	{
		if ((you.flag1 == on) && (pMenu.visible == off)) { pMenu.visible = on; }
	}
}

ACTION player_walk2
{
	player = my;

	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
//	my.__slopes = on;

	my.enable_entity = on;
	my.enable_stuck = on;
	my.event = FreeMe;

	PrevZ = my.z;

	player_move2();
}

function Blink()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

function Starfield()
{
	weather = weather_rain;
	weather_mem = result;
	weather_strength = 70;
	rain_akt ();
	if (night == 0)
	{
		fog_color = 1; 
		sky_color.red = sky_color_rain;
		sky_color.green= sky_color_rain;
		sky_color.blue = sky_color_rain;
		camera.fog = rain_fog;
	}
}

function rain_eff ()
{
	SelectStar = int(random(3));

	if (SelectStar == 0) { my.bmap = Star1; }
	if (SelectStar == 1) { my.bmap = Star2; }
	if (SelectStar == 2) { my.bmap = Star3; }

	my.lifespan = 20;
	my.x += random(1000)-500;
	my.y += random(1000)-500;
	my.z = random(480);
	my.move = on;
	my.flare = on;
	my.vel_x = -40;
	my.vel_y = 0;
	my.vel_z = 0;
	my.size = 3;
	my.function = null;
}

on_esc = null;