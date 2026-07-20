include <IO.wdl>;	// include when doing an adventure

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var MoviePlaying = 0;
var Talking = 0;
var Scene = 0;
var ShakeFlag = 0;
var Blah = 0;
var LavaGo = 0;
var SingIt = 0;
var Dial = 0;
var Yurik = 0;
var SND = 0;
var FallNow = 0;
var ShowMe = 0;

synonym PipCell { type entity; }

bmap bdrop = <drop.bmp>;
bmap lava = <lava.bmp>;

sound WindS = <SFX092.WAV>;
sound Engine = <SFX064.WAV>;
sound Fount = <SFX109.wAV>;
sound sBreak = <SFX001.wav>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _VOLCANO;

	warn_level = 0;
	tex_share = on;

	load_level(<Temple.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	fog_color = 1;
	camera.fog = 60;

	Scene = 0;
	SetVoice();
}

action AlasPoorYurik
{
	while(1)
	{
		my.x = player.x;
		my.y = player.y;
		my.z = player.z;
		my.pan = player.pan;
		if (Yurik == 1) { my.invisible = off; } else { my.invisible = on; }
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
		if (Talking != 0) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }
		if (Talking == 1) { Talk(); } else { Blink(); }

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (Scene == 8)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP159.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHO004.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog(20);
			}

			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP160.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHO005.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (20);
			}

			if (DialogChoice == 3) 
			{ 
				sPlay ("PIP161.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("BRL007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP162.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("BRL006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP163.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP500.WAV"); Talking = 6; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHO006.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (21);
				Scene = 9;
			}
		}

		if (Scene == 9)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) { sPlay ("PIP164.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } }
			if (DialogChoice == 2) { sPlay ("PIP166.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } }
			if (DialogChoice == 3) { sPlay ("PIP165.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } }

			Scene = 10;
			SetVoice();
		}

		if (Scene == 15)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP168.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHO009.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog(22);
			}

			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP169.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				Scene = 16; SetVoice();
			}

			if (DialogChoice == 3) 
			{ 
				sPlay ("PIP170.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				Scene = 16; SetVoice();			
			}
		}

		if (Scene == 19)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP172.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog(23);
			}

			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP173.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				ent_frame ("Hamlet",0); wait(1); Yurik = 1;
				sPlay ("PIP174.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk2(); wait(1); }
				ent_frame ("Stand",0); Yurik = 0;
				sPlay ("BRL010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("SHO012.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP175.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

				DoDialog (23);
			}

			if (DialogChoice == 3) 
			{ 
				sPlay ("PIP176.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MSC005.WAV"); ShakeFlag = 1; Talking = 10; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP177.WAV"); Talking = 1; Blah = 180; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHK032.WAV"); Talking = 5; LavaGo = 1; Blah = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP178.WAV"); Talking = 1; Blah = 180; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("SHK033.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP179.WAV"); Talking = 1; Blah = 0; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				showme = 1;
				while (showme == 1) { wait(1); }
				sPlay ("PIP540.WAV"); Talking = 1; FallNow = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				
				Volcano[2] = 1;
				WriteGameData(0);

				Run ("InShrine.exe");
			}
		}

		// if we are not in 'still' mode
		if ((MY._MOVEMODE != _MODE_STILL)&&(MoviePlaying == 0))
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

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}}

ACTION player_walk2
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 1;
	MY._BANKING = -0.1;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;

	player_move2();
}

function stream()
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = scatter_speed.X + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Y = scatter_speed.Y + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Z = scatter_speed.Z + RANDOM(scatter_spread) - (scatter_spread/2);

		if (LavaGo == 0) { MY_SIZE = scatter_size; } else { MY_SIZE = 150; }
		if (LavaGo == 0) { MY_MAP = bdrop; } else { MY_MAP = lava; }
		MY_FLARE = ON;
		my_transparent = on;
		return;
	}
	// Add gravity
	MY_SPEED.Z -= scatter_gravity;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	if(MY_AGE >= scatter_lifetime)
	{
		MY_ACTION = NULL;
	}
}

function Lavaflow()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(600) + 200;
		MY_SPEED.X = (RANDOM(3)-1) * random(3);
		MY_SPEED.Y = (RANDOM(3)-1) * random(3);
		MY_SPEED.Z = random(60)+30;

			MY_COLOR.RED = random(255);
			MY_COLOR.GREEN = 0;
			MY_COLOR.BLUE = 0;
	}
	else
	{
		my_speed.z = my_speed.z - 5;
		if(MY_AGE > 100) { MY_ACTION = NULL; }
	}
}

action Fountain
{
	particle_pos.x = my.x;
	particle_pos.y = my.y;
	particle_pos.z = my.z + 120;

	while(1)
	{
		if (snd_playing(my.skill40) == 0) { play_entsound (my,fount,600); my.skill40 = result; }
		if (LavaGo == 1) { if (int(random(50)) == 25) { emit(50,MY.POS,Lavaflow); } }
		emit 50,particle_pos,stream;
		wait(1);
	}
}

action Plane
{
	my.skin = 5;

	while(1)
	{
		if (snd_playing(my.skill40) == 0) { play_entsound (my,engine,300); my.skill40 = result; }
		ent_cycle ("Fly",my.skill1);
		my.skill1 = my.skill1 + 5 * time;
		wait(1);
	}
}

action Light
{
	my.lightred = 100;
	my.lightgreen = 100;
	my.lightblue = 0;
	my.ambient = 100;
	my.lightrange = 150;

	while(1)
	{
		my.lightrange = my.lightrange + (int(random(3)) - 1) * 2;
		if (my.lightrange > 200) { my.lightrange = 200; }
		if (my.lightrange < 100) { my.lightrange = 100; }
		wait(1);
	}
}

action StartDialog
{
	MoviePlaying = 1;
	Scene = 1;
	SetVoice();
}

action Dude
{
	my.event = StartDialog;
	my.enable_click = on;

	while(1)
	{
		if (Talking != 10)
		{
			if (MoviePlaying == 0) { Blink(); }
			if (ShakeFlag == 0) { if (Talking == my.skill1) { Talk(); } else { Blink(); } }
			if (SingIt == 1) { ent_frame ("Sing",0); }
		}
		else { Talk(); }

		if (ShakeFlag == 1) { ent_cycle ( "Stomp",my.skill10); my.skill10 = my.skill10 + 10 * time; }

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
	if (ShakeFlag == 0) { if (int(random(40)) == 20) { ent_frame ("Hamlet",int(random(4)) * 33.3); } }
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

function SetVoice
{
	if (Scene == 1) { sPlay ("BRL001.WAV"); Talking = 2; }
	if (Scene == 2) { sPlay ("SHO001.WAV"); Talking = 3; }
	if (Scene == 3) { sPlay ("BRL002.WAV"); Talking = 2; }
	if (Scene == 4) { sPlay ("SHO002.WAV"); Talking = 3; }
	if (Scene == 5) { sPlay ("PIP158.WAV"); Talking = 1; }
	if (Scene == 6) { sPlay ("BRL004.WAV"); Talking = 2; }
	if (Scene == 7) { sPlay ("SHO003.WAV"); Talking = 3; }
	if (Scene == 8) { DoDialog (20); }
	if (Scene == 10) { sPlay ("BRL008.WAV"); Talking = 2; }
	if (Scene == 11) { sPlay ("SHO007.WAV"); Talking = 3; }
	if (Scene == 12) { sPlay ("PIP167.WAV"); Talking = 1; }
	if (Scene == 13) { sPlay ("BRL009.WAV"); Talking = 2; }
	if (Scene == 14) { sPlay ("SHO008.WAV"); Talking = 3; }
	if (Scene == 15) { DoDialog (22); }
	if (Scene == 16) { sPlay ("SHO010.WAV"); Talking = 3; SingIt = 1; }
	if (Scene == 17) { sPlay ("PIP171.WAV"); Talking = 1; }
	if (Scene == 18) { sPlay ("SHO011.WAV"); Talking = 3; SingIt = 0; }
	if (Scene == 19) { DoDialog (23); }
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

action Cell
{
	PipCell = my;

	while(1)
	{
		if (FallNow == 0)
		{
			my.pan = Blah;

			if (ShakeFlag == 1)
			{
				my.invisible = off;
				my.shadow = on;
				player.invisible = on;
				player.shadow = off;
				if (Dial < 100) { ent_frame ("Dial",Dial); Dial = Dial + 2 * time; } else { if (Talking == 1) { Talk(); } else { Blink(); } }
			}
		}

		if (FallNow == 1)
		{
			if (my.skill40 == 0) { morph (<Piposh.mdl>,my); my.skill40 = 1; }
			ent_cycle ("Fall",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			my.z = my.z - 30 * time;
			Talk2();
		} 

		wait(1);
	}
}

action Cam2
{
	while(1)
	{
		if (MoviePlaying == 0) { if (snd_playing (SND) == 0) { play_sound (WindS,50); SND = result; } } else { stop_sound (SND); }

		if (ShakeFlag == 1) 
		{ 
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;

			if (FallNow == 0) { camera.z = my.z + (int(random(3)) - 1) * 2; }
		}

		wait(1);
	}
}

action breakme
{
	while(1)
	{
		if (FallNow == 1)
		{
			ent_frame ("Break",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}

		wait(1);
	}
}

action Rock
{
	while(1)
	{
		if (FallNow == 1)
		{
			my.pan = my.pan + 5 * time;
			my.tilt = my.tilt + 5 * time;
			my.roll = my.roll + 5 * time;
			my.z = my.z - 30 * time;
		}

		wait(1);
	}
}

action Cam3
{
	while(1)
	{
		if (FallNow == 1)
		{
			if (my.skill40 == 0) { play_sound (sBreak,100); my.skill40 = 1; }

			if (my.x > PipCell.x) { my.x = my.x - 5 * time; }
			vec_set(temp,PipCell.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

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

action TakeCam
{
	while(1)
	{
		if (ShowMe == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;

			if (ShakeFlag == 1) { camera.z = my.z + (int(random(3)) - 1) * 2; }
		}

		wait(1);
	}
}

action Cam
{
	while(ShakeFlag == 0)
	{
		if (Talking == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			if (Talking == 1)
			{
				vec_set(temp,player.x);
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);
			}
			else
			{
				camera.pan = my.pan;
				camera.roll = my.roll;
				camera.tilt = my.tilt;
			}
		}

		if ((Talking == 5) && (my.skill1 == 1))
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
		}

		if ((Dialog.visible == on) && (my.skill1 == 4) && (MOviePlaying == 1))
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

action PipTake
{
	while(1)
	{
		if (ShowMe == 1)
		{
			ShakeFlag = 0;
			my.skill1 = 0;
			while (my.skill1 < 50) { ent_frame ("Hide",my.skill1); my.skill1 = my.skill1 + 3 * time; wait(1); }
			my.skill1 = 0;
			ent_frame ("TakeIt",0);
			ShakeFlag = 1;
			waitt(8);
			ent_frame ("TakeIt",100);
			sPlay ("PIP565.WAV");
			while (GetPosition (VOice) < 1000000) { talk2(); wait(1); }
			my.skin = 1;
			waitt(8);
			ShakeFlag = 0;
			ShowMe = 0;
		}

		wait(1);
	}
}

action Or
{
	while(1)
	{
		if (LavaGo == 1)
		{
			my.ambient = 100;
			my.lightred = 255;
			my.lightrange = 400 + ((int(random(3)) - 1) * 20);
		}

		wait(1);
	}
}

action PieceX
{
	my.skill1 = 10;

	while(1)
	{
		my.ambient = my.ambient + my.skill1 * time;
		if (my.ambient > 50) { my.skill1 = -10; }
		if (my.ambient < -50) { my.skill1 = 10; }
		wait(1);
	}
}