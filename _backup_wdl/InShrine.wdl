include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
synonym Pole1 		{ type entity; }
synonym Pole2 		{ type entity; }
synonym Pole3 		{ type entity; }
synonym TheBridge 	{ type entity; }
synonym TheGate 	{ type entity; }
synonym TheLava 	{ type entity; }
synonym Knob1x		{ type entity; }
synonym Knob2x		{ type entity; }

var Rtc = 0;
var Chk1;
var Chk2;
var PrevZ = 0;
var FinMov = 0;
var Cutdie = 0;
var video_mode = 6;
var video_depth = 16;
var LavaHeight = 0;
var Chkpt[3] = 0,0,0;
var Checked = 0;
var OriginalZ = 0;
var PlayerOrig[3] = 0,0,0;
var Restore = 0;
var Talking = 0;
var ElevatorOn = 0;

sound CheatSound = <SFX035.WAV>;
sound Growl = <SFX144.WAV>;

sound Scream = <SFX136.WAV>;
var SCRM = 0;

var ShakeFlag = 0;

sound BGMusic = <SNG019.WAV>;

var cheat1 = 0;
var cheat2 = 0;
var cheat3 = 0;
string cheatstring = "                                     ";

var SND = 0;

sound Ambient = <SFX077.WAV>;
sound Wood = <SFX078.WAV>;
sound GiantAxe = <SFX079.wAV>;
sound GiantHammer = <SFX080.WAV>;
sound GiantClub = <SFX081.WAV>;
sound SwitchClick = <SFX082.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _VOLCANO;

	warn_level = 0;
	tex_share = on;

	fog_color = 1;
	camera.fog = 30;

	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	load_level(<InShrine.WMB>);

	VoiceInit();
	Initialize();
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
		// if we are not in 'still' mode
		if((MY._MOVEMODE != _MODE_STILL)&&(CutDie <= 0))
		{
			if (Talking == 1) { Talk(); if (GetPosition(Voice) >= 1000000) { Talking = 0; } } else { Blink(); }

			if ((int(random(1200)) == 600) && (Talking == 0) && (FinMov == 0))
			{
				my.skill40 = int(random(12)) + 1;

				if (my.skill40 == 1)  { sPlay ("PIP181.WAV"); }
				if (my.skill40 == 2)  { sPlay ("PIP182.WAV"); }
				if (my.skill40 == 3)  { sPlay ("PIP183.WAV"); }
				if (my.skill40 == 4)  { sPlay ("PIP184.WAV"); }
				if (my.skill40 == 5)  { sPlay ("PIP185.WAV"); }
				if (my.skill40 == 6)  { sPlay ("PIP186.WAV"); }
				if (my.skill40 == 7)  { sPlay ("PIP187.WAV"); }
				if (my.skill40 == 8)  { sPlay ("PIP188.WAV"); }
				if (my.skill40 == 9)  { sPlay ("PIP189.WAV"); }
				if (my.skill40 == 10) { sPlay ("PIP190.WAV"); }
				if (my.skill40 == 11) { sPlay ("PIP191.WAV"); }
				if (my.skill40 == 12) { sPlay ("PIP192.WAV"); }
				Talking = 1;
			}

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
		if (FinMov == 0) 
		{ 
			move_view(); 
			PrevZ = Camera.z;
			Camera.z = PrevZ; 
			if (ShakeFlag > 0) { camera.z = my.z + (int(random(3)) - 1) * 3; ShakeFlag = ShakeFlag - 1 * time;  }

			if (int(random(1000)) == 500) { ShakeFlag = 10; }
		}

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat

		fog_color = 1;
		camera.fog = 30;

		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION player_walk2
{
	play_loop (BGMusic,50);

	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = ON;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;
	my.trigger_range = 0.1;
	jump_height = 150;
	anim_jump_ticks = 12;

	PlayerOrig.x = my.x;
	PlayerOrig.y = my.y;
	PlayerOrig.z = my.z;

	player_move2();
}

function LavaBurn
{
	my = player;
	my.skill42 = 20;

	if (cheat2 != 1) 
	{
		while (my.skill42 > 0)
		{
			if (my.skill42 < 10) { if (snd_playing (SCRM) == 0) { play_sound (Scream,100); SCRM = result; } }
			emit(50,MY.POS,Lavaflow);
			my.z = my.z - 1 * time;
			my.skill42 = my.skill42 - 1 * time;
			ent_cycle ("Lava",my.skill43);
			my.skill43 = my.skill43 + 10 * time;
			wait(1);
		}

		Die(); 
	}
}

action lava
{
	OriginalZ = my.z;
	TheLava = my;

	while (1)
	{
		if (snd_playing (SND) == 0) { play_entsound (my,ambient,1000); sND = result; }

		if (cheat1 != 1) { my.z = my.z + 0.05 * time; LavaHeight = my.z; }
		SET MY.LIGHTRED,255;
		SET MY.LIGHTGREEN,0;
		SET MY.LIGHTBLUE,0;
		my.skill2 = my.skill2 + 1;
		MY.LIGHTRANGE = 1000 + ((int(random(3)) - 2) * 20);

		if (abs(my.z - player.z) < 95) { LavaBurn(); }

		wait (1);
	}
}

function Ouch
{
	if (you == player)
	{
		if (pole1 == null)  { wait (1); }
		if (pole2 == null)  { wait (1); }
		if (pole3 == null)  { wait (1); }
		if (my.skill8 == 1) { Die();    }
		if (my.skill8 == 2) { Die();    }
		if (my.skill8 == 3) { Die();    }
		if (my.skill8 == 4) { Die();    }
	}
}

action Collis
{
	if (pole1 == null) { wait (1); }
	if (pole2 == null) { wait (1); }
	if (pole3 == null) { wait (1); }
	my.pan = 90;
	my.push = -2;

	while (1)
	{
		if (my.skill8 == 1) 
		{ 
			my.tilt = pole1.tilt; 
			if ((abs(my.x - player.x) < 50) && (abs(my.y - player.y) < 50) && (my.tilt > -10) && (my.tilt < 10) ) 
			{ 
				my = player;
				CutDie = 20;
				while (CutDie > 0)
				{
					CutDie = CutDie - 1 * time;
					ent_frame ("Sliced",0);
					emit(50,MY.POS,Lavaflow2);
					wait(1);
				}

				Die();
			}
		}

		if (my.skill8 == 2) 
		{ 
			my.tilt = pole2.tilt; 
			if ((abs(my.x - player.x) < 50) && (abs(my.y - player.y) < 50) && (my.tilt > -10) && (my.tilt < 10) ) 
			{ 
				my = player;
				CutDie = 20;
				while (CutDie > 0)
				{
					CutDie = CutDie - 1 * time;
					ent_frame ("Sliced",0);
					emit(50,MY.POS,Lavaflow2);
					wait(1);
				}

				Die();
			}

		}

		if (my.skill8 == 3) 
		{ 
			my.tilt = pole3.tilt; 
			if ((abs(my.x - player.x) < 50) && (abs(my.y - player.y) < 50) && (my.tilt > -10) && (my.tilt < 10) )
			{ 
				my = player;
				CutDie = 20;
				while (CutDie > 0)
				{
					CutDie = CutDie - 1 * time;
					ent_frame ("Sliced",0);
					emit(50,MY.POS,Lavaflow2);
					wait(1);
				}

				Die();
			}

		}

		wait (1);
	}
}

action KillYou
{
	if (you == player) { Die(); }
}

action AxeHammer
{
	my.event = Killyou;
	my.enable_entity = on;
	my.enable_impact = on;
	my.enable_push = on;

	if (my.skill8 == 1) { pole1 = my; my.skill2 = -1; }
	if (my.skill8 == 2) { pole2 = my; my.skill2 = 1; }
	if (my.skill8 == 3) { pole3 = my; my.skill2 = -1; }

	if (random(2) == 1) { my.skill2 = -1; }
	my.skill30 = random(60) + 60;
	my.skill1 = my.skill30 / 2;
	my.skill3 = 1;
	my.push = -2;

	while(1)
	{
		my.skill1 = my.skill1 + 2 * time;
		if (my.skill1 > my.skill30) { my.skill3 = my.skill3 - 0.3 * time; }
		if (my.skill1 < my.skill30) { if (my.skill3 < 1) { my.skill3 = my.skill3 + 0.3 * time; } }
		if (my.skill3 <= 0)
		{ 
			my.skill2 = my.skill2 * -1; my.skill1 = 0; my.skill3 = 1;
			if (my.flag1 == on) { play_entsound (my,GiantAxe,1000); }
			if (my.flag2 == on) { play_entsound (my,GiantHammer,1000); }
			if (my.flag3 == on) { play_entsound (my,GiantClub,1000); }
		}

		if (abs(my.skill1 - (my.skill30 / 2)) < 0.1) { my.tilt = 0; }

		my.tilt = my.tilt + (my.skill3 * my.skill2) * time; 
		wait (1);
	}
}

action Falling
{
	while (Restore == 0)
	{
		if (cheat3 != 1)
		{
			if (my.skill40 == 0) { play_entsound (my,wood,300); my.skill40 = 1; } 
			my.skill1 = my.skill1 - 3 * time;
			if (my.skill1 < 0) { my.z = my.z - 1.5 * time; }
		}
		wait(1);
	}

	my.skill1 = 1000;
	my.z = my.skill2;
	my.skill40 = 0;
}

action Bridge
{
	my.skill2 = my.z;
	my.trigger_range = 0.1;
	my.skill1 = 1000;
	my.enable_trigger = on;
	my.event = Falling;

	while(1) { if (Restore == 1) { my.z = my.skill2; wait(5); Restore = 0; } wait(1); }
}

action Shooter
{
	my.skill1 = random(200)+100;

	while (1)
	{
		my.skill1 = my.skill1 - 1;
		if (my.skill1 < 0) 
		{ 
			my.skill1 = random(200)+100;;
			CreateSpark();
		}
	wait(1);
	}
}

ACTION actor_explodeNONEAR
{
	MY.FLARE = ON;
	MY.PASSABLE = ON;	// don't push the player through walls
	MY.FRAME = 1;
	wait(1);

	PLAY_ENTSOUND ME,explo_wham,1000;
	MY.LIGHTRED = light_explo.RED;
	MY.LIGHTGREEN = light_explo.GREEN;
	MY.LIGHTBLUE = light_explo.BLUE;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 50;

	// use the new sprite animation
	while(MY.FRAME < MY._DIEFRAMES)
	{
		wait(1);
		MY.LIGHTRANGE += 15;
		MY.LIGHTRED += 20 * TIME;	// fade to red
		MY.LIGHTBLUE -= 20 * TIME;
		MY.FRAME += TIME;
	}
	wait(1);
	remove(ME);
}

action SparkHit
{
	MY.FLARE = ON;
	MY.PASSABLE = ON;	// don't push the player through walls
	MY.FRAME = 1;

	PLAY_ENTSOUND ME,explo_wham,1000;
	MY.LIGHTRED = light_explo.RED;
	MY.LIGHTGREEN = light_explo.GREEN;
	MY.LIGHTBLUE = light_explo.BLUE;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 50;

	// use the new sprite animation
	while(MY.FRAME < MY._DIEFRAMES)
	{
		wait(1);
		MY.LIGHTRANGE += 15;
		MY.LIGHTRED += 20 * TIME;	// fade to red
		MY.LIGHTBLUE -= 20 * TIME;
		MY.FRAME += TIME;
	}

	if (event_type == event_entity) 
	{ 
		if ((you == player) && (CutDie <= 0))
		{
			you = my;
			my = player;
			CutDie = 20;
			while (CutDie > 0)
			{
				CutDie = CutDie - 1 * time;
				ent_frame ("Sliced",0);
				emit(50,MY.POS,Lavaflow2);
				wait(1);
			}

			my.skill8 = 4; Die(); 

			my = you;
		}
	}
	_gib(10);
	actor_explodeNONEAR();
	}
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

	//MY.FACING = ON;	// in case of fireball

	MY.LIGHTRED = 255;
	MY.LIGHTGREEN = 0;
	MY.LIGHTBLUE = 0;
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

		my.pan = my.pan + random(3) - 1;
		my.tilt = my.tilt + random(3) - 1;
		my.roll = my.roll + random(3) - 1;

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		move(ME,nullskill,fireball_speed);
	}
}

function CreateSpark
{
	shot_speed.x = 10;
	shot_speed.y = 0;
	shot_speed.z = 0;
	my_angle.pan = my.pan;
	vec_rotate(shot_speed,my_angle);
	temp.x = my.x;
	temp.y = my.y;
	temp.z = my.z - 17;
	
	create(<Fireball.mdl>,temp.x,Spark);
}

action fan
{
my.pan = 90;
	while (1)
	{
		my.roll = my.roll + 10;
		wait (1);
	}
}

action ElvSwitch
{
	my._switch = 1;
}

action Bridg
{
	TheBridge = my;
	my.z = my.z + 1000;
	my.skill1 = 0;
}

action BigDoor
{
	TheGate = my;
	my.skill1 = 0;
}

action OpenBigDoor
{
	if (TheGate == null) { wait(1); }	
	if (TheGate.skill1 != 1) { play_entsound (my,switchclick,300); TheGate.z = TheGate.z + 1000; }
	TheGate.skill1 = 1;
}

action RaiseBridge
{
	if (TheBridge == null) { wait(1); }	
	if (TheBridge.skill1 != 1) { play_entsound (my,switchclick,300); TheBridge.z = TheBridge.z - 1000; }
	TheBridge.skill1 = 1;
}

action Switch1
{
	my.enable_click = on;
	my.event = RaiseBridge;
}

action Switch2
{
	my.enable_click = on;
	my.event = OpenBigDoor;
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"lava plug") == 1) { msg.string = "cheat enabled"; show_message(); cheat1 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"stone skin") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"fix bridge") == 1) { msg.string = "cheat enabled"; show_message(); cheat3 = 1; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

on_tab = cheat;

function Lavaflow()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(600) + 300;
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

function Lavaflow2()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(100) + 50;
		MY_SPEED.X = (RANDOM(3)-1) * random(3);
		MY_SPEED.Y = (RANDOM(3)-1) * random(3);
		MY_SPEED.Z = random(60)+30;

			MY_COLOR.RED = 255;
			MY_COLOR.GREEN = 0;
			MY_COLOR.BLUE = 0;
			MY_TRANSPARENT = ON;
			MY_ALPHA = random(100);
	}
	else
	{
		my_speed.z = my_speed.z - 5;
		if(MY_AGE > 100) { MY_ACTION = NULL; }
	}
}

action Fireball2
{
	my.skill1 = (int(random(3)) - 1) * random(5);
	my.skill2 = (int(random(3)) - 1) * random(5);
	my.skill3 = random(30) + 10;

	my.event = SparkHit;
	my.enable_block = on;
	my.enable_entity = on;

	while (1)
	{
		my.pan = my.pan + random(3) - 1;
		my.tilt = my.tilt + random(3) - 1;
		my.roll = my.roll + random(3) - 1;

		force.x = my.skill1;
		force.y = my.skill2;
		//my.x = my.x + my.skill1;
		//my.y = my.y + my.skill2;

		my.skill3 = my.skill3 - 0.5;
		my.skill4 = my.z;

		actor_move();

		my.z = my.skill4 + my.skill3;

		wait(1);
	}
}

action Gayser
{
	my.invisible = on;

	while(1)
	{
		my.z = LavaHeight;

		if (int(random(100)) == 50)
		{
			if (int(random(20)) == 10)
			{
				create(<Fireball.mdl>,my.x,Fireball2);
			}
			else
			{
				emit(50,MY.POS,Lavaflow);
			}
		}
		wait(1);
	}
}

action GoToMine
{
	my.invisible = on;
	FinMov = 1;
}

action ClickMe
{
	my.enable_click = on;
	my.event = GoToMine;
	my.skill1 = 10;

	while(1)
	{
		my.ambient = my.ambient + my.skill1 * time;
		if (my.ambient > 50) { my.skill1 = -10; }
		if (my.ambient < -50) { my.skill1 = 10; }
		wait(1);
	}
}

action Miner
{
	my.skill30 = 10;

	while(1)
	{
		if (FinMov > 0)
		{
			ent_frame ("GotIt",0);
			player.invisible = on; player.shadow = off;
			my.invisible = off;

			if (my.flag2 == on) { my.invisible = on; }

			if ((my.flag1 == on) && (FinMov == 1))
			{ 
				my.invisible = off;
				sPlay ("SFX103.WAV"); 
				while (GetPosition (Voice) < 1000000) { wait(1); }
				FinMov = 2;
				my.invisible = on;
				ShakeFlag = 10;
			}

			if (FinMov == 2)
			{
				if (my.flag1 == on)
				{
					if (my.skill40 == 0) { sPlay ("PIP564.WAV"); my.skill40 = 1; }
				}

				my.skin = 2;

				if (GetPosition (Voice) >= 1000000) { my.skin = 1; }

				if (my.flag1 == on) { my.invisible = on; }
				if (my.flag2 == on) { my.invisible = off; }
				ent_frame ("LookUp",0);
				my.x = my.x - my.skill30 * time;
				my.skill30 = my.skill30 + 1 * time;
				my.skill1 = my.skill1 + 1 * time;
				if (my.skill1 > 70) 
				{ 
					Volcano[3] = 1;
					WriteGameData (0);
					Run ("Mine.exe"); 
				}
			}
		}

		wait(1);
	}
}

action MinCam
{
	while(1)
	{
		if (FinMov > 0)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;

			if (ShakeFlag > 0) { camera.z = my.z + (int(random(3)) - 1) * 6; ShakeFlag = ShakeFlag - 1 * time;  }

			if ((FinMov == 2) && (my.skill1 < 40)) { my.x = my.x - 30 * time; my.skill1 = my.skill1 + 1 * time; }
		}

		wait(1);
	}
}

action Mummy
{
	while(1)
	{
		if (int(random(100)) == 50)
		{
			if (int(random(2)) == 1) { ent_frame ("Open",0); play_entsound (my,Growl,1000); } else { ent_frame ("Close",0); }
		}

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
		my.lightrange = my.lightrange + (int(random(3)) - 1) * 3;
		if (my.lightrange > 200) { my.lightrange = 200; }
		if (my.lightrange < 100) { my.lightrange = 100; }
		wait(1);
	}
}

action TakeCheck
{
	if (you == player) { Checked = 1; }
}

action Checkpoint
{
	Chkpt.x = my.x;
	Chkpt.y = my.y;
	Chkpt.z = my.z;

	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = TakeCheck;

	while(1)
	{
		if (Checked == 0)
		{
			my.shadow = on;
			my.passable = off;
			my.invisible = off;
			my.pan = my.pan + 25 * time;
			my.lightrange = 500 + (random(3) - 1);
			my.lightblue = 255;
			my.lightred = 0;
			my.lightgreen = 0;
			wait(1);
		}
		else
		{
			my.shadow = off;
			my.passable = on;
			my.invisible = on;
			my.lightrange = 0;
		}

		wait(1);
	}
}

function Die
{
	Restore = 1;

	if (Checked == 0) 
	{ 
		player.x = playerOrig.x; player.y = playerorig.y; player.z = playerorig.z; TheLava.z = OriginalZ; 

		if (TheGate.skill1 == 1) { TheGate.z = TheGate.z - 1000; }
		TheGate.skill1 = 0;
		if (TheBridge.skill1 == 1) { TheBridge.z = TheBridge.z + 1000; }
		TheBridge.skill1 = 0;
	}

	if (Checked == 1) { player.x = Chkpt.x; player.y = Chkpt.y; player.z = Chkpt.z; TheLava.z = OriginalZ; player.pan = 180; }
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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

function IsOK (vTilt)
{
	Rtc = 0;
	if ((vTilt > -5) && (vTilt < 5)) { Rtc = 1; }
}

action Device
{
	while (1)
	{
		if ((knob1x == null) || (knob2x == null)) { wait(1); }

		IsOK (Knob1x.tilt);
		Chk1 = Rtc;

		IsOK (Knob2x.tilt);
		Chk2 = Rtc;

		if ((Chk1 == 1) && (Chk2 == 1)) { my.skin = 4; knob1x.tilt = 0; knob2x.tilt = 0; ElevatorOn = 1; }
		if ((Chk1 == 1) && (Chk2 == 0)) { my.skin = 3; }
		if ((Chk1 == 0) && (Chk2 == 1)) { my.skin = 2; }
		if ((Chk1 == 0) && (Chk2 == 0)) { my.skin = 1; }

		wait(1);
	}
}

action TurnMe1
{
	if (((knob1x.tilt == 0) || (knob1x.tilt == -1)) && ((knob2x.tilt == 0) || (knob2x.tilt == -1))) { return; }

	my.tilt = my.tilt + 10;
	knob2x.tilt = knob2x.tilt - 5;
}

action TurnMe2
{
	if (Knob1x == null) { wait(1); }

	if (((knob1x.tilt == 0) || (knob1x.tilt == -1)) && ((knob2x.tilt == 0) || (knob2x.tilt == -1))) { return; }

	my.tilt = my.tilt + 10;
	knob1x.tilt = knob1x.tilt + 5;
}

action Knob1
{
	Knob1x = my;
	my.event = TurnMe1;
	my.enable_click = on;

	my.tilt = (int(random(37)) + 1) * 10;

	while (1) { my.tilt = ang(my.tilt); wait(1); }
}

action Knob2
{
	Knob2x = my;
	my.event = TurnMe2;
	my.enable_click = on;

	my.tilt = (int(random(37)) + 1) * 10;

	while (1) { my.tilt = ang(my.tilt); wait(1); }
}

function elevator_move()
{
again:
	// start moving the elevator
	MY.__MOVING = ON;
	if(MY.__SILENT == OFF) { play_entsound(ME,gate_snd,66); }


	// DCP - if we're using a remote trigger
	if((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		temp_elevator = MY.ENTITY1;   			// the ranged target
  		temp_elevator.ENABLE_SCAN = OFF;     // disable scan on this trigger
		temp_elevator.ENABLE_TRIGGER = OFF;  // disable range on this trigger
	}


	while((MY.__MOVING == ON) && (ElevatorOn == 1))
	{
		wait(1);			// DcP - moved wait to the start of this block, before the __MOVING flag is set to OFF

		// calculate the 3D direction to move to
		MY._SPEED_X = MY._TARGET_X - MY.X;
		MY._SPEED_Y = MY._TARGET_Y - MY.Y;
		MY._SPEED_Z = MY._TARGET_Z - MY.Z;



 		temp = MY._FORCE * TIME;  // use force for elevator speed

		// check the length to the target position to the normal speed
		if(vec_length(my._speed) > temp)
		{
			// if we still have room to move, move
			vec_normalize(MY._SPEED,temp);
		}
		else
		{
			// else, move to target position and stop
			MY.__MOVING = OFF;
		}


/*---- OLD CODE !!REMOVE!!
		// check the distance to the target position, using pythagoras
		temp = MY._SPEED_X*MY._SPEED_X + MY._SPEED_Y*MY._SPEED_Y + MY._SPEED_Z*MY._SPEED_Z;

		// we have now the square of the distance to the target,
		// and must compare it with the square of the distance to move
		if(temp > MY._FORCE * TIME * MY._FORCE * TIME)
		{
			// if far, move with normal speed
			temp = MY._FORCE * TIME;
			vec_normalize(MY._SPEED,temp);	// adjust the speed vector's length
		}
		else
		{	// if near, stop after moving the rest distance
			MY.__MOVING = OFF;
		}
*/

		// move into that direction
  		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
		result = ent_move(NULLSKILL,MY._SPEED);


		MY._SPEED_X = MY_SPEED.X;	// set the speed to the real distance covered
		MY._SPEED_Y = MY_SPEED.Y;	// for moving the player with the platform
		MY._SPEED_Z = MY_SPEED.Z;

	}

	MY._SPEED_X = 0;
	MY._SPEED_Y = 0;
	MY._SPEED_Z = 0;

	// at end position, reverse the direction
	if(MY._TARGET_X == MY._ENDPOS_X
		&& MY._TARGET_Y == MY._ENDPOS_Y
		&& MY._TARGET_Z == MY._ENDPOS_Z )
	{
		MY._TARGET_X = MY._STARTPOS_X;
		MY._TARGET_Y = MY._STARTPOS_Y;
		MY._TARGET_Z = MY._STARTPOS_Z;
	}
	else
	{
		MY._TARGET_X = MY._ENDPOS_X;
		MY._TARGET_Y = MY._ENDPOS_Y;
		MY._TARGET_Z = MY._ENDPOS_Z;
	}


	// DCP - if a ranged trigger is used,
   if((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		temp_elevator = MY.ENTITY1;   // the ranged target

		temp_elevator.X = MY._TARGET_X; // move the ranged target to the elevator's target point
	  	temp_elevator.Y = MY._TARGET_Y;
	  	temp_elevator.Z = MY._TARGET_Z;

  		if(MY.__REMOTE == ON)
		{
			temp_elevator.ENABLE_SCAN = ON; 		// re-activate the scan event
		}

		// ranged trigger is set here
		if(MY._TRIGGER_RANGE > 1)
		{
	  		temp_elevator.ENABLE_TRIGGER = ON;	// re-activate the trigger event
 		}
  	}


   // DcP - reset the elevator's _TRIGGERFRAME to the current TOTAL_FRAMES    (4/7/00)
	//
	//      _TRIGGERFRAME is used in _doorevent_check to allow the user time
	//      to step off the lift before accepting new SONAR events
	MY._TRIGGERFRAME = TOTAL_FRAMES;


	// if a gate or paternoster, close it or restart
	if(((MY.__GATE == ON) && (MY._PAUSE > 0) && (MY.Z > MY._STARTPOS_Z))
		// close gate again
		|| ((MY.__GATE == OFF) && (MY._PAUSE > 0)))
	{
		// start paternoster in reverse direction
		waitt(MY._PAUSE);
		goto(again);
	}
}

on_F1 = cycle_person_view;