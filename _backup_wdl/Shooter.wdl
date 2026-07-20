include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

sound PAR1  = <PAR001.WAV>;
sound PAR2  = <PAR002.WAV>;
sound PAR3  = <PAR003.WAV>;
sound PAR4  = <PAR004.WAV>;
sound PAR5  = <PAR005.WAV>;
sound PAR6  = <PAR006.WAV>;
sound PAR7  = <PAR007.WAV>;
sound PAR8  = <PAR008.WAV>;
sound PAR9  = <PAR009.WAV>;
sound PAR10 = <PAR010.WAV>;
sound PAR11 = <PAR011.WAV>;
sound PAR12 = <PAR012.WAV>;
sound Scream = <Scream.WAV>;

sound Crowd = <CRWD2.WAV>;
sound CheatSound = <SFX035.WAV>;

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Choose = 0;
var SMS;

var plane1_x;
var plane1_y;
var plane2_x;
var plane2_y;
var Death = 0;

var Talking = 0;

var PwrTmp;
string cheatstring = "                                                               ";
var Cheat1 = 0;
var Cheat2 = 0;
var Cheat3 = 0;

var Hits = 0;
var Health = 6;

view Booth
{
	layer = 0;
	size_x = 200;
	size_y = 200;
	pos_x = 15;
	pos_y = 10;
}

synonym plane1x { type entity; }
synonym plane2x { type entity; }

bmap Hit1 = <GIR1.PCX>;
bmap Hit2 = <GIR2.PCX>;
bmap Hit3 = <GIR3.PCX>;
bmap Hit4 = <GIR4.PCX>;
bmap Hit5 = <GIR5.PCX>;
bmap Cube = <Cube.bmp>;
bmap Panel = <ShtrPnl.pcx>;

string Debug = 	    "                                                ";
string StringTemp = "                                                ";
define delay,skill10;
define zoom,skill21;
define speed,skill22;
define haspara,skill23;
define airborn,skill24;
define active,skill26;
define fall,skill30;
synonym tempsyn { type entity; }
synonym border1 { type entity; }
synonym border2 { type entity; }

sound Jet = <SFX091.WAV>;
sound ShootBow = <SFX002.wAV>;
sound OldHit = <SFX102.WAV>;
sound Bonus = <SFX103.wAV>;
sound GlassBreak = <SFX098.WAV>;

var KIV = 0;

view Overmap
{
	layer = -1;
	size_x = 100;
	size_y = 100;
	flags = visible;
}

panel Pwr1 { bmap = Cube; pos_x = 45; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }
panel Pwr2 { bmap = Cube; pos_x = 70; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }
panel Pwr3 { bmap = Cube; pos_x = 95; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }
panel Pwr4 { bmap = Cube; pos_x = 120; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }
panel Pwr5 { bmap = Cube; pos_x = 145; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }
panel Pwr6 { bmap = Cube; pos_x = 170; pos_y = 223; flags = visible,d3d,refresh; layer = -1; }

panel bHit1 { bmap = Hit1; pos_x = 45; pos_y = 248; flags = d3d,refresh; layer = -1; }
panel bHit2 { bmap = Hit1; pos_x = 84; pos_y = 248; flags = d3d,refresh; layer = -1; }
panel bHit3 { bmap = Hit1; pos_x = 125; pos_y = 248; flags = d3d,refresh; layer = -1; }
panel bHit4 { bmap = Hit1; pos_x = 165; pos_y = 248; flags = d3d,refresh; layer = -1; }

panel GUI
{
	bmap = Panel;
	layer = -1;
	pos_x = 0;
	pos_y = 0;
	flags = refresh,d3d,visible,overlay;
}

entity Crossbow
{
	type = <Crossbow.mdl>;
	layer = -1;
	view = camera;
	x = 150;
	y = 0;
	z = -50;
	pan = 270;
}

sound KIV01 = <KIV009.WAV>;
sound KIV02 = <KIV010.WAV>;
sound KIV03 = <KIV011.WAV>;
sound KIV04 = <KIV012.WAV>;
sound KIV05 = <KIV013.WAV>;
sound KIV06 = <KIV014.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _OLYMPIC;

	cross_pos.x = -7;
	cross_pos.y = -7;

	pan_cross_show();

	Hits = 0;
	Health = 6;

	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	warn_level = 0;	// announce bad texture sizes and bad wdl code
	tex_share = on;	// map entities share their textures

	load_level(<Shooter.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

ACTION player_move2
{
	Death = 0;

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
		if(MY._MOVEMODE != _MODE_STILL)
		{
			DrawPower();
			DrawHits();

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
					//move_gravity();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		// If I'm the only player, draw the camera and weapon with ME
		if (Talking == 0) { move_view(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

action Ouch
{
	if (you.skill40 != 1)
	{
		play_sound (OldHit,100);
		Health = Health - 0.5;
		my = you;
		actor_explode();
	}
}

ACTION player_stand
{
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = ON;
	MY.__DUCK = ON;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;
	my.invisible = on;
	my.enable_entity = on;
	my.enable_impact = on;
	my.enable_push = on;
	my.event = Ouch;

	player_move2();

	overmap.visible = on;
	overmap.x = player.x;
	overmap.y = player.y;
	overmap.z = player.z - 200;
	overmap.tilt = 270;
	Overmap.pos_x = 0;

	while (Talking == 1) { if (GetPosition(Voice) >= 1000000) { Talking = 0; } wait(1); }

	while(1)
	{
		if (Talking == 0) { Crossbow.visible = on; }

		if (int(random(300)+1) == 150)	// Send in an airplane
		{
			if (int(random(2)+1) > 1) { plane1x.active = 1; } else { plane2x.active = 1; }
		}

		Overmap.pos_y = screen_size.y - 100;

		overmap.pos_x = 10;
		overmap.pos_y = 10;

		overmap.size_x = 100;
		overmap.size_y = 100;

		if (crossbow.delay > 0)
		{
			crossbow.delay = crossbow.delay - 2 * time;
			if (crossbow.delay <= 0)
			{
				tempsyn = my;
				my = crossbow;
				ent_frame ("Loaded",0);
				my = tempsyn;
			}
		}

		wait(1);
	}
}

function killplunger
{
	remove (my);
}

ACTION Spark
{
	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale
	my.skill25 = 30;
	my.skill40 = 1;

	my.push = 10;

	MY.FACING = ON;	// in case of fireball

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

	if (my.skill10 == 0)
	{
		my.pan = camera.pan;
		my.tilt = camera.tilt;
		my.roll = camera.roll;
		my.skill10 = 1;
	}

  	// my.near is set by the explosion
	while(MY.NEAR != ON)
	{
		
		wait(1); // wait at the loop beginning, to let it appear at the start position

		my.skill25 = my.skill25 - 1;

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
		// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		if((MY._FIREMODE & BULLET_SMOKETRAIL) == BULLET_SMOKETRAIL)
		{
			temp = 3 * TIME;
			if(temp > 6) { temp = 6; }	// generate max 6 particels
			emit(temp,MY.POS,particle_fade); 	// smoke trail
		}

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		move(ME,nullskill,fireball_speed);

	}
}


function CreateSpark
{
	if (crossbow.delay <= 0)
	{
		play_sound (ShootBow,50);
		shot_speed.x = 100;
		shot_speed.y = 0;
		shot_speed.z = 0;
		my_angle.pan = camera.pan;
		my_angle.tilt = camera.tilt;
		my_angle.roll = camera.roll;
		vec_rotate(shot_speed,my_angle);
	
		create(<Plunger.mdl>,player.x,Spark);

		my = crossbow;
		ent_frame ("Shot",0);
		crossbow.delay = 10;
	}
}

on_mouse_left = createspark;

function Kill
{
	remove(you);
}

action TargetHit
{
	if ((my.airborn == 1) && (my.haspara == 0))
	{
		my.skill45 = 1;
		if (Health < 6) { Health = Health + 0.25; }
	}

	if (my.airborn == 0)	// if not in the air.
	{
		while(you.skill25 > 0)
		{
			my.x = you.x;
			my.y = you.y;	
			wait(1);
		}
	}
}

action Heart
{
	my.skill1 = 100;
	play_entsound (my,bonus,3000);

	while(my.skill1 > 0)
	{
		my.pan = my.pan + 10 * time;
		my.z = my.z + 5 * time;
		my.y = my.y + (int(random(3)) - 1) * time;
		my.x = my.x + (int(random(3)) - 1) * time;
		my.skill1 = my.skill1 - 1 * time;
		wait(1);
	}
	
	remove (my);
}

function killpara
{
	you.skill40 = 1;
	if (my.haspara == 0) { play_entsound (my,Scream,3000); }
	remove (my);
}

action losepara
{
	my.haspara = 0;
}

action Parashot
{
	my.skill3 = 1;
	my.haspara = 1;
	my.event = losepara;
	my.enable_impact = on;
	my.enable_entity = on;
	my.enable_push = on;

	if ((Cheat1 == 1) && (int(random(6)) == 3)) { play_entsound (my,Scream,1000); killpara(); }

	while(you.haspara == 1)
	{
		my.roll = my.skill2;
		my.skill2 = my.skill2 + my.skill3;
		if (my.skill2 > 20) { my.skill2 = 20; my.skill3 = -1; }
		if (my.skill2 < -20) { my.skill2 = -20; my.skill3 = 1; }
		you.haspara = my.haspara;
		my.x = you.x;
		my.y = you.y;
		my.z = you.z;
		you.roll = my.roll;
		wait(1);
		if (my.haspara == 0 || you.airborn == 0) { killpara(); }

		wait(1);
	}

	killpara();
}

action Plane1
{
	wait(1);
	plane1x = my;
	plane1_x = my.x;
	plane1_y = my.y;
	my.active = 0;
	my.invisible = on;

	while (Talking == 1) { wait(1); }

	while(1)
	{
		if (my.active == 1)
		{
			if (snd_playing (my.skill40) == 0) { play_entsound (my,jet,5000); my.skill40 = result; }
			my.invisible = off;
			my.x = my.x - 50;
			my.y = my.y + int(random(2)-1);

			if (int(random(50)) == 25) { create (<oldguy1.mdl>,my.x,oldguy); }

			if (my.x <= plane2_x)
			{
				stop_sound (my.skill40);
				my.x = plane1_x;
				my.y = plane1_y;
				my.invisible = on;
				my.active = 0;
			}

		}
		wait(1);
	}
}

action Plane2
{
	wait(1);
	plane2x = my;
	plane2_x = my.x;
	plane2_y = my.y;
	my.active = 0;
	my.invisible = ON;

	while (Talking == 1) { wait(1); }

	while(1)
	{
		if (my.active == 1)
		{
			if (snd_playing (my.skill40) == 0) { play_entsound (my,jet,5000); my.skill40 = result; }

			my.invisible = off;
			my.x = my.x + 50;
			my.y = my.y + int(random(2)-1);

			if (int(random(50)+1) == 25) { create (<oldguy1.mdl>,my.x,oldguy); }

			if (my.x >= plane1_x)
			{
				stop_sound (my.skill40);
				my.x = plane2_x;
				my.y = plane2_y;
				my.invisible = on;
				my.active = 0;
			}

		}
		wait(1);
	}
}	

function smashplayer
{
	if (snd_playing (SMS) == 0) { play_sound (Crowd,75); SMS = result; }
	Hits = Hits + 0.5;
  	_gib(50);
	actor_explode();
}

action Oldguy
{
	my.event = TargetHit;
	my.enable_push = ON;
	my.haspara = 1;
	my.airborn = 1;
	my.fall = 10;

	Choose = int(random(7)) + 1;

	if (Choose == 1) { morph (<oldguy1.mdl>,my); }
	if (Choose == 2) { morph (<oldguy2.mdl>,my); }
	if (Choose == 3) { morph (<oldguy3.mdl>,my); }
	if (Choose == 4) { morph (<oldguy3.mdl>,my); }
	if (Choose == 5) { morph (<oldguy5.mdl>,my); }
	if (Choose == 6) { morph (<oldguy6.mdl>,my); }
	if (Choose == 7) { morph (<oldguy7.mdl>,my); }

	drop_shadow();

	my.speed = int(random(20)+10);

	create (<para.mdl>,my.x,Parashot);

	while (1)
	{
		if (int(random(300)) == 150)
		{
			my.skill40 = int(random(12)) + 1;
			if (my.skill40 == 1)  { play_entsound (my,PAR1,1000); }
			if (my.skill40 == 2)  { play_entsound (my,PAR2,1000); }
			if (my.skill40 == 3)  { play_entsound (my,PAR3,1000); }
			if (my.skill40 == 4)  { play_entsound (my,PAR4,1000); }
			if (my.skill40 == 5)  { play_entsound (my,PAR5,1000); }
			if (my.skill40 == 6)  { play_entsound (my,PAR6,1000); }
			if (my.skill40 == 7)  { play_entsound (my,PAR7,1000); }
			if (my.skill40 == 8)  { play_entsound (my,PAR8,1000); }
			if (my.skill40 == 9)  { play_entsound (my,PAR9,1000); }
			if (my.skill40 == 10) { play_entsound (my,PAR10,1000); }
			if (my.skill40 == 11) { play_entsound (my,PAR11,1000); }
			if (my.skill40 == 12) { play_entsound (my,PAR12,1000); }
		}

		if (my.airborn == 0)
		{
			my.tilt = 0;
			my.roll = 0;
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			my.skill1 = my.skill1 + my.speed;
			ent_cycle ("Run",my.skill1);
			if (my.skill1 > 1000) { my.skill1 = 0; }
			force = my.speed / 3;
			if (Cheat3 == 1) { force = my.speed / 9; }
			MY._MOVEMODE = _MODE_WALKING;
			actor_move();
		}

		if (my.airborn == 1)
		{
			if (my.haspara == 1) 
			{ 
				if (Cheat2 == 0) { my.z = my.z - 16 * time; } else { my.z = my.z - 8 * time; }
			}	// Has parashout

			if (my.haspara == 0) 				// Lost parashout, falling
			{ 
				my.z = my.z - my.fall; 
				my.fall = my.fall + 3 * time; 
				ent_cycle ("Fall",my.skill1); 
				my.skill1 = my.skill1 + 10 * time;; 
			}

			my.x = my.x + (random(2)-1);
			my.y = my.y + (random(2)-1);
	
			if (my.z <= player.z)
			{ 
				if (my.haspara == 0)
				{
					if (my.skill45 == 1) { create (<Heart.mdl>,my.x,Heart); my.skill40 = 0; }
					smashplayer();
				}

				if (my.haspara == 1)
				{
					my.airborn = 0; 
					my.haspara = 0; 
				}
			}
		}

		wait(1);
	}
}

action Kiviti
{
	Booth.x = my.x - 40;
	Booth.y = my.y + 130;
	Booth.z = my.z + 100;
	Booth.pan = 270;
	Booth.tilt = -20;
	Booth.visible = on;

	while(1)
	{
		if ((int(random(300)) == 150) && (snd_playing (KIV) == 0))
		{
			my.skill40 = int(random(6)) + 1;

			if (my.skill40 == 1) { play_sound (KIV01,100); KIV = result; }
			if (my.skill40 == 2) { play_sound (KIV02,100); KIV = result; }
			if (my.skill40 == 3) { play_sound (KIV03,100); KIV = result; }
			if (my.skill40 == 4) { play_sound (KIV04,100); KIV = result; }
			if (my.skill40 == 5) { play_sound (KIV05,100); KIV = result; }
			if (my.skill40 == 6) { play_sound (KIV06,100); KIV = result; }

			while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
		}

		if (Talking == 10) { Talk(); } else { Blink(); }
		wait(1);
	}
}

function glass_gib(numberOfParts)
{
	temp = 0;
	while(temp < numberOfParts)
	{
		create(<Shard.mdl>, my.pos, _gib_action);
		temp += 1;
	}
}

action Gidi
{
	while(1)
	{
		if (Talking == 2) { ent_frame ("Drum",60); } else { if (int(random(40)) == 20) { ent_frame ("Stand",int(random(4)) * 33.3); } }
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
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

action GlassHit
{
	play_sound (glassbreak,100);
	glass_gib(20);
	remove(my);
}

action Glass
{
	my.event = GlassHit;
	my.enable_entity = ON;
	my.enable_push = ON;
	my.enable_impact = ON;
}

action Ad
{
	my.skin = int(random(7)) + 1;
}

function DrawPower
{
	if (Health > 0) { Pwr1.visible = ON; } else { Pwr1.visible = OFF; }
	if (Health > 1) { Pwr2.visible = ON; } else { Pwr2.visible = OFF; }
	if (Health > 2) { Pwr3.visible = ON; } else { Pwr3.visible = OFF; }
	if (Health > 3) { Pwr4.visible = ON; } else { Pwr4.visible = OFF; }
	if (Health > 4) { Pwr5.visible = ON; } else { Pwr5.visible = OFF; }
	if (Health > 5) { Pwr6.visible = ON; } else { Pwr6.visible = OFF; }

	if (Health <= 0)
	{
		if (Death == 0)
		{
			Death = 1;
			wait(1);
			ShowRIP();
		}
	}
}

function DrawHits
{
	if (Hits < 01) { bHit1.visible = OFF; } else { bHit1.visible = ON; }
	if (Hits < 06) { bHit2.visible = OFF; } else { bHit2.visible = ON; }
	if (Hits < 11) { bHit3.visible = OFF; } else { bHit3.visible = ON; }
	if (Hits < 16) { bHit4.visible = OFF; } else { bHit4.visible = ON; }

	if (Hits > 00) { bHit1.bmap = Hit1; }
	if (Hits > 01) { bHit1.bmap = Hit2; }
	if (Hits > 02) { bHit1.bmap = Hit3; }
	if (Hits > 03) { bHit1.bmap = Hit4; }
	if (Hits > 04) { bHit1.bmap = Hit5; }

	if (Hits > 05) { bHit2.bmap = Hit1; }
	if (Hits > 06) { bHit2.bmap = Hit2; }
	if (Hits > 07) { bHit2.bmap = Hit3; }
	if (Hits > 08) { bHit2.bmap = Hit4; }
	if (Hits > 09) { bHit2.bmap = Hit5; }

	if (Hits > 10) { bHit3.bmap = Hit1; }
	if (Hits > 11) { bHit3.bmap = Hit2; }
	if (Hits > 12) { bHit3.bmap = Hit3; }
	if (Hits > 13) { bHit3.bmap = Hit4; }
//	if (Hits > 14) { bHit3.bmap = Hit5; }
	if (Hits > 14) 
	{ 
		bHit3.bmap = Hit5; 

		Olympic[2] = 1;
		WriteGameData(0);

		Run ("Golf.exe"); 
	}

/*	if (Hits > 15) { bHit4.bmap = Hit1; }
	if (Hits > 16) { bHit4.bmap = Hit2; }
	if (Hits > 17) { bHit4.bmap = Hit3; }
	if (Hits > 18) { bHit4.bmap = Hit4; }
	if (Hits > 19) 
	{ 
		bHit4.bmap = Hit5; 

		Olympic[2] = 1;
		WriteGameData(0);

		Run ("Golf.exe"); 
	}
*/
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	msg.POS_Y = SCREEN_SIZE.Y - 60;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"malfunction") == 1)  { msg.string = "cheat enabled"; show_message(); Cheat1 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"air pressure") == 1) { msg.string = "cheat enabled"; show_message(); Cheat2 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"heavy boots") == 1)  { msg.string = "cheat enabled"; show_message(); Cheat3 = 1; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

action CamIntro
{
	while(Talking == 1)
	{
		my.x = my.x + 40 * time;
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.roll = my.roll;
		camera.tilt = my.tilt;
		wait(1);
	}
}


on_tab = cheat();