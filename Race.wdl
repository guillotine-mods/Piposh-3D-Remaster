include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var filehandle;
var n;
var cameratemp[3] = 0,0,0;
var closest;
var winner = "                ";
string cheatstring = "                                                                          ";
string stringtemp = "                          ";
var cheat1 = 0;
var cheat2 = 0;
var Position;
var Delay = 0;
var Talking = 0;
var cRANGE = 5000;
var SPD = 0.8;
var KIV = 0;
var WatchIntro = 1;

var Positions[9] = 0,0,0,0,0,0,0,0,0;

var cameraX[15] = 3563,1107,-1955,-5249,-8539,-10891,-12225,-12265,-11139,-8448,-5397,-2139,1123,3626,5188;
var cameraY[15] = 4427,5847,6579,6640,5778,4336,2778,883,-755,-2463,-3045,-2867,-2383,-941,774;

define Lap,skill30;
define CheckPoint,skill25;
define Speed,skill26;
define Accel,skill12;
define Pos,skill23;

sound Crowd = <CRWD1.WAV>;
sound RaceS = <SFX094.WAV>;
sound WMill = <SFX095.WAV>;
sound Moo = <SFX099.wAV>;

sound CheatSound = <SFX035.WAV>;

bmap bRace = <Racel.pcx>;

sound KVC1 = <KVC028.WAV>;
sound KVC2 = <KVC029.WAV>;

sound OldS1 = <OLD007.WAV>;
sound OldS2 = <OLD008.WAV>;
sound OldS3 = <OLD009.WAV>;
sound OldS4 = <OLD010.WAV>;
sound OldS5 = <OLD011.WAV>;
sound OldS6 = <OLD012.WAV>;
sound OldS7 = <OLD013.WAV>;
sound OldS8 = <OLD014.WAV>;
sound OldS9 = <OLD015.WAV>;

synonym Old1   { type entity; }
synonym Old2   { type entity; }
synonym Old3   { type entity; }
synonym Old4   { type entity; }
synonym Old5   { type entity; }
synonym Old6   { type entity; }
synonym Old7   { type entity; }
synonym Piposh { type entity; }

var MoviePlaying = 1;
var Death = 0;

//view Booth
//{
//	layer = 3;
//	size_x = 200;
//	size_y = 200;
//	pos_y = 10;
//}

panel GUI 
{
	bmap = bRace;
	pos_x = 0;
	pos_y = 353;
	layer = 4;
	flags = refresh,d3d,visible,overlay;

 	digits 250,60,1,standard_font,1,player.lap;
	digits 287,60,1,standard_font,1,player.checkpoint;

	digits 250,110,1,standard_font,1,old1.lap;
	digits 287,110,1,standard_font,1,old1.checkpoint;

	digits 175,60,1,standard_font,1,old7.lap;
	digits 214,60,1,standard_font,1,old7.checkpoint;

	digits 175,110,1,standard_font,1,old2.lap;
	digits 214,110,1,standard_font,1,old2.checkpoint;

	digits 100,60,1,standard_font,1,old6.lap;
	digits 138,60,1,standard_font,1,old6.checkpoint;

	digits 100,110,1,standard_font,1,old3.lap;
	digits 138,110,1,standard_font,1,old3.checkpoint;

	digits 25,60,1,standard_font,1,old4.lap;
	digits 65,60,1,standard_font,1,old4.checkpoint;

	digits 25,110,1,standard_font,1,old5.lap;
	digits 65,110,1,standard_font,1,old5.checkpoint;

	digits 370,104,1,standard_font,1,Position;
}

entity Meter
{
	type = <Mad.mdl>;
	layer = 5;
	view = camera;
	x = 105;
	y = -10;
	z = -33;
}

sound Name1 = <Name1.wav>;
sound Name2 = <Name2.wav>;
sound Name3 = <Name3.wav>;
sound Name4 = <Name4.wav>;
sound Name5 = <Name5.wav>;
sound Name6 = <Name6.wav>;
sound Name7 = <Name7.wav>;
sound Name8 = <Name8.wav>;

sound KIV01 = <KIV001.WAV>;
sound KIV02 = <KIV002.WAV>;
sound KIV03 = <KIV003.WAV>;
sound KIV04 = <KIV004.WAV>;
sound KIV05 = <KIV005.WAV>;
sound KIV06 = <KIV006.WAV>;
sound KIV07 = <KIV007.WAV>;
sound KIV08 = <KIV008.WAV>;

sound BGMusic = <SNG025.WAV>;
var MUS;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main() 
{ 
	wait(3);

	varLevelID = _OLYMPIC;

	warn_level = 0;
	tex_share = on;

	Cheat1 = 0;
	Cheat2 = 0;

	load_level(<Race.WMB>); 

	VoiceInit();
	initialize();

	sPlay ("wait.wav");
	while (GetPosition (Voice) < 1000000) { wait(1); }

	if (WatchIntro == 1)
	{
		gui.visible = off;
		//Booth.visible = off;

		sPlay ("OLY008.WAV");
		Talking = 10;

		while (GetPosition (Voice) < 1000000) { wait(1); }

		sPlay ("YCH007.WAV");
		Talking = 1;

		while (GetPosition (Voice) < 1000000) { wait(1); }
	
		MoviePlaying = 0;
		sPlay ("OLY004.WAV");

		WatchIntro = 0;
	}

	gui.visible = on;
	//Booth.visible = on;
	meter.visible = on;

	stop_sound (MUS);
	play_loop (BGMusic,75);
	MUS = result;
}

action Cow
{
	drop_Shadow();

	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 5 * time;

		if (int(random(100)) == 50) { play_entsound (my,moo,1000); }
		wait(1);
	}
}

ACTION miner_drive
{
	MY._MOVEMODE = _MODE_DRIVING;
	MY._FORCE = 1;
	MY._BANKING = 0;
	MY.__SLOPES = ON;
	MY.__TRIGGER = ON;
	my.push = -10;
	player = my;

	my.lap = 0;
	my.checkpoint = 0;

	miner_move();
}

ACTION miner_move
{
	my.pos = 0;
	Death = 0;
	my.ambient = 50;
	my.shadow = on;

	my.skill38 = my.x;
	my.skill39 = my.y;
	while (MoviePlaying == 1) { actor_move(); my.x = my.skill38; my.y = my.skill39; wait(1); }

	if(MY.CLIENT == 0) { player = ME; } // created on the server?

	MY._TYPE = _TYPE_PLAYER;
	player.skill20 = 1;
	player.lap = 0;
	player.checkpoint = 0;
	MY.ENABLE_SCAN = ON;	// so that enemies can detect me
	if((MY.TRIGGER_RANGE == 0) && (MY.__TRIGGER == ON)) { MY.TRIGGER_RANGE = 32; }

	if(MY._FORCE == 0) {  MY._FORCE = 1.5; }
	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	my._walksound = 0;

	my._movemode = _mode_walking;

	anim_init();      // init old style animation
	perform_handle();	// react on pressing the handle key

	while (Talking > 0) 
	{ 
		if (GetPosition(Voice) >= 1000000) { if (Talking == 1) { Talking = 2; sPlay ("OLY005.WAV"); } else { Talking = 0; } } 
		wait(1); 
	}

	// while we are in a valid movemode
	while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		if ((Talking == 2) && (GetPosition(Voice) >= 1000000)) { Talking = 0; }

		meter.roll = my.speed;
		CheckPosition();
		if (Delay > 0) { Delay = Delay - 1 * time; }

		my.skill45 = my.speed / 2;
		if (snd_playing(my.skill40) == 0) { play_sound (RaceS,my.skill45); my.skill40 = result; }

		// if we are not in 'still' mode
		if(MY._MOVEMODE != _MODE_STILL)
		{
			if ((int(random(100)) == 50) && (GetPosition(Voice) >= 1000000))
			{
				my.skill18 = int(random(14)) + 1;

				if (my.skill18 == 1)  { sPlay ("PIP249.WAV"); Talking = 1; }
				if (my.skill18 == 2)  { sPlay ("PIP250.WAV"); Talking = 1; }
				if (my.skill18 == 3)  { sPlay ("PIP245.WAV"); Talking = 1; }
				if (my.skill18 == 4)  { sPlay ("BRA016.WAV"); Talking = 2; }
				if (my.skill18 == 5)  { sPlay ("BRA017.WAV"); Talking = 2; }
				if (my.skill18 == 6)  { sPlay ("BRA018.WAV"); Talking = 2; }
				if (my.skill18 == 7)  { sPlay ("BRA019.WAV"); Talking = 2; }
				if (my.skill18 == 8)  { sPlay ("BRA020.WAV"); Talking = 2; }
				if (my.skill18 == 9)  { sPlay ("BRA021.WAV"); Talking = 2; }
				if (my.skill18 == 10) { sPlay ("PIP506.WAV"); Talking = 1; }
				if (my.skill18 == 11) { sPlay ("PIP507.WAV"); Talking = 1; }
				if (my.skill18 == 12) { sPlay ("PIP508.WAV"); Talking = 1; }
				if (my.skill18 == 13) { sPlay ("PIP509.WAV"); Talking = 1; }
				if (my.skill18 == 14) { sPlay ("PIP510.WAV"); Talking = 1; }


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
					move_gravity2();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		// If I'm the only player, draw the camera and weapon with ME
		if (player.skill20 != 3) { move_view2(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function move_gravity2()
{
	// Filter the forces and frictions dependent on the state of the actor,
	// and then apply them, and move him

	// First, decide whether the actor is standing on the floor or not
	if(my_height < 5)
	{

		// Calculate falling damage
 		if((MY.__FALL == ON) && (MY._FALLTIME > fall_time))
  		{
			MY._HEALTH -= fall_damage();		// take damage depending on fall_time
 		}
		MY._FALLTIME = 0; 	// reset falltime

		friction = gnd_fric;
		if(MY._MOVEMODE == _MODE_DRIVING)
		{
			// Driving - less friction, less force
			friction *= 0.3;
			force.X *= 0.3;
		}

		// reset absolute forces
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = 0;

		// If on a slope, apply gravity to draw him downwards:
		if(my_floornormal.Z < 0.9)
		{
			// reduce ahead force because player force it is now deflected upwards
			force.x *= my_floornormal.z;
			force.y *= my_floornormal.z;
			// gravity draws him down the slope
			absforce.X = my_floornormal.x * gravity * slopefac;
			absforce.Y = my_floornormal.y * gravity * slopefac;
		}
	}
	else	// (my_height >= 5)
	{
		// airborne - reduce all relative forces
		// to prevent him from jumping or further moving in the air
		friction = air_fric;
		//jcl 10-08-00
		force.X *= 0.2; // don't set the force completely to zero, otherwise
		force.Y *= 0.2; // player could be stuck on top of a non-wmb entity
		force.Z = 0;

		absforce.X = 0;
		absforce.Y = 0;
		// Add the world gravity force
		absforce.Z = -gravity;

		// only falling if moving downward
		if(MY._SPEED_Z <= 0)
		{
			MY._FALLTIME += TIME;   // add falling time
		}
	}

	// accelerate the entity relative speed by the force
	// -old method- ACCEL	speed,force,friction;
 	// replaced min with max (to eliminate 'creep')
	temp = max((1-TIME*friction),0);
	MY._SPEED_X = (TIME * force.x) + (temp * MY._SPEED_X);    // vx = ax*dt + max(1-f*dt,0) * vx
//	MY._SPEED_Y = (TIME * force.y) + (temp * MY._SPEED_Y);    // vy = ay*dt + max(1-f*dt,0) * vy

	PlayerSpeed();

	my._speed_x = player.speed;
	MY._SPEED_Z = (TIME * absforce.z) + (temp * MY._SPEED_Z);

	// calculate relative distances to move
	dist.x = MY._SPEED_X * TIME;  	// dx = vx * dt
	dist.y = MY._SPEED_Y * TIME;     // dy = vy * dt
	dist.z = 0;                      // dz = 0  (only gravity and jumping)

	// calculate absolute distance to move
	absdist.x = absforce.x * TIME * TIME;   // dx = ax*dt^2
	absdist.y = absforce.y * TIME * TIME;   // dy = ay*dt^2
	absdist.z = MY._SPEED_Z * TIME;         // dz = vz*dt

//jcl 07-22-00
	// Add the speed given by the ground elasticity and the jumping force
	if(my_height < 5)
	{
		// bring to ground level - only if slope not too steep
		//jcl 10-08-00
  		if(my_floornormal.Z > slopefac/4)
		{
			absdist.z = -max(my_height,-10);
		}

		// if we have a jumping force...
		if(force.Z > 0)
		{
			// predict the initial speed required to reach the jump height
			// v = a*t; s = a/2*t*t; -> v = sqrt(2*a*s)
			MY._SPEED_Z = sqrt((jump_height-my_height)*2*gravity);
			// scale distance from jump (absdist.z) by movement_scale
			absdist.z = MY._SPEED_Z * TIME * movement_scale;

			// ...switch to jumping mode
			MY._MOVEMODE = _MODE_JUMPING;
			MY._ANIMDIST = 0;
		}

		// If the actor is standing on a moving platform, add it's horizontal displacement
		absdist.X += my_floorspeed.X;
		absdist.Y += my_floorspeed.Y;
	}


	// Restrict the vertical distance to the maximum jumping height
	// (scale jump_height by movement_scale)
	if((MY.__JUMP == ON) && (absdist.z > 0) && (absdist.z + my_height > (jump_height * movement_scale)))
	{
		absdist.z = max((jump_height * movement_scale)- my_height,0);
	}

	// Now move ME by the relative and the absolute speed
	YOU = NULL;	// YOU entity is considered passable by MOVE

	vec_scale(dist,movement_scale);	// scale distance by movement_scale
	// jcl: removed absdist scaling because absdist is calculated from external forces
	//--- vec_scale(absdist,movement_scale);	// scale absolute distance by movement_scale


	// Replaced the double MOVE with a single MOVE and a distance check
//-old-	move(ME,dist,NULLVECTOR);
// Store the distance covered, for animation
//-old-	my_dist = RESULT;
//-	move(ME,NULLVECTOR,absdist);
 	move(ME,dist,absdist);
	if(RESULT > 0)
	{
		// only use the relative distance traveled (for animation)
		my_dist = vec_length(dist);
	}
	else
	{
		// player is not moving, do not animate
		my_dist = 0;
	}


	// Store the distance for player 1st person head bobbing
	// (only for single player system)
	if(ME == player)
	{
		player_dist += SQRT(dist.X*dist.X + dist.Y*dist.Y);
	}
//jcl 07-03-00 end of patch
}

action OldGuy
{
	my.skill38 = my.x;
	my.skill39 = my.y;

	my.lap = 0;
	my.checkpoint = 0;
	my.pos = 0;

	while (MoviePlaying == 1) { actor_move(); my.x = my.skill38; my.y = my.skill39; wait(1); }

	actor_init();
	my.ambient = 50;
	my.shadow = on;

	if (my.skill3 == 1) { Old1 = my; }
	if (my.skill3 == 2) { Old2 = my; }
	if (my.skill3 == 3) { Old3 = my; }
	if (my.skill3 == 4) { Old4 = my; }
	if (my.skill3 == 5) { Old5 = my; }
	if (my.skill3 == 6) { Old6 = my; }
	if (my.skill3 == 7) { Old7 = my; }

	while (Talking > 0) { actor_move(); my.x = my.skill38; my.y = my.skill39; wait(1); }

	my.skill1 = int(random(35)+20);

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 100;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }

	my._movemode = 1;

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (Cheat1 > 0) { Cheat1 = Cheat1 - 1 * time; }

		if (cheat1 <= 0)
		{

		if (snd_playing(my.skill40) == 0) { play_entsound (my,RaceS,600); my.skill40 = result; }

		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		force = 2;

		if (result < 225) { ent_nextpoint(my._TARGET_X); }


		actor_turnto(my_angle.PAN);

		force = my.skill1;
		actor_move();

		if (my.skill8 == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z+20;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		ent_cycle("Run",my.skill2);
		my.skill2 = my.skill2 + my.skill1 * time;
		if (my.skill2 > 1000) { my.skill2 = 0; }

// Wait one tick, then repeat
		}

		wait(1);
	}
}

action Rider1
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{

	if (Old1 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			plaY_entsound (my,OldS1,cRANGE);
		}

		my.x = old1.x;
		my.y = old1.y;
		my.z = old1.z + 90;
		my.pan = old1.pan;
		my.roll = old1.roll;
		my.tilt = old1.tilt;
		wait(1);
	}
}

action Rider2
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{
		if (Old7 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			my.skill18 = int(random(2)) + 1; 
			if (my.skill18 == 1) { plaY_entsound (my,KVC1,cRANGE); }
			if (my.skill18 == 2) { plaY_entsound (my,KVC2,cRANGE); }
		}

		my.x = old7.x;
		my.y = old7.y;
		my.z = old7.z + 20;
		my.pan = old7.pan;
		my.roll = old7.roll;
		my.tilt = old7.tilt;
		wait(1);
	}
}

action Rider3
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{
	if (Old2 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			my.skill18 = int(random(2)) + 1; 
			if (my.skill18 == 1) { plaY_entsound (my,OldS2,cRANGE); }
			if (my.skill18 == 2) { plaY_entsound (my,OldS3,cRANGE); }
		}

		my.x = old2.x;
		my.y = old2.y;
		my.z = old2.z + 50;
		my.pan = old2.pan;
		my.roll = old2.roll;
		my.tilt = old2.tilt;
		wait(1);
	}
}

action Rider4
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{
	if (Old5 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			my.skill18 = int(random(2)) + 1; 
			if (my.skill18 == 1) { plaY_entsound (my,OldS4,cRANGE); }
			if (my.skill18 == 2) { plaY_entsound (my,OldS9,cRANGE); }
		}

		my.x = old5.x;
		my.y = old5.y;
		my.z = old5.z + 70;
		my.pan = old5.pan;
		my.roll = old5.roll;
		my.tilt = old5.tilt;
		wait(1);
	}
}

action Rider5
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{
	if (Old3 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			my.skill18 = int(random(2)) + 1; 
			if (my.skill18 == 1) { plaY_entsound (my,OldS5,cRANGE); }
			if (my.skill18 == 2) { plaY_entsound (my,OldS6,cRANGE); }
		}

		my.x = old3.x;
		my.y = old3.y;
		my.z = old3.z + 30;
		my.pan = old3.pan;
		my.roll = old3.roll;
		my.tilt = old3.tilt;
		wait(1);
	}
}

action Rider6
{
	my.ambient = 50;
	my.shadow = on;

	while (MoviePlaying == 1) { wait(1); }
	my.passable = on;
	my.push = -30;

	while(1)
	{
	if (Old6 == null) { wait(1); }

		if (int(random(100)) == 50)
		{
			my.skill18 = int(random(2)) + 1; 
			if (my.skill18 == 1) { plaY_entsound (my,OldS7,cRANGE); }
			if (my.skill18 == 2) { plaY_entsound (my,OldS8,cRANGE); }
		}

		my.x = old6.x;
		my.y = old6.y;
		my.z = old6.z + 90;
		my.pan = old6.pan;
		my.roll = old6.roll;
		my.tilt = old6.tilt;
		wait(1);
	}
}

action Rider7
{
	wait(1);

	my.ambient = 50;
	my.shadow = on;

	my.passable = on;
	my.push = -30;
	Piposh = my;

	while(1)
	{
		if ((Talking == 1) && (GetPosition(Voice) >= 1000000)) { Talking = 0; }


		if (Talking == 1) { Talk(); } else { Blink(); }

		if (player == null) { wait(1); }
		my.x = player.x;
		my.y = player.y;
		my.z = player.z + 20;
		my.pan = player.pan;
		my.roll = player.roll;
		my.tilt = player.tilt;
		wait(1);
	}
}

function SayStam
{
	if (Talking == 0)
	{
		sPlay ("PIP511.WAV");
		Talking = 1;
	}
}

on_t = saystam();

action TheCamera
{
	while (MoviePlaying == 1) { wait(1); }

	my.visible = off;
	my.passable = on;

	while(1)
	{
		if (player.skill20 == 1)
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

function ChangeCamera
{
	while (MoviePlaying == 1) { wait(1); }

	player.skill20 = player.skill20 + 1;
	if (player.skill20 > 4) { player.skill20 = 1; }
}

function move_view2()
{
	while (MoviePlaying == 1) { wait(1); }

	if(player == NULL) { player = ME; }	// this action needs the player synonym
	if(player == NULL) { return; }			// still no player -> can't work
	if(Piposh == null) { wait(1); }
	if(player.skill20 == 1)
	{
		Piposh.invisible = off;
		move_view_3rd();
	}
	if(player.skill20 == 2)
	{
		Piposh.invisible = on;
		move_view_1st();
	}
}

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	wait(1);

	while (1)
	{

	while (piposh == null) { wait(1); }

	//Booth.pos_x = screen_size.x - 200;

	if (player.skill20 == 4)
	{
		camera.z = player.z + 3000;
		camera.tilt = 270;
		camera.x = player.x;
		camera.y = player.y;
		camera.pan = player.pan;
	}

	if (player.skill20 == 3)
	{
		if (piposh != null) { Piposh.invisible = off; }
		vec_set(temp,player.x);
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);
		
		n = 0;		
		temp = 100000;

		while (n < cameraX.length) {

			cameratemp.x = cameraX[n];
			cameratemp.y = cameraY[n];
		
			if vec_dist(cameratemp.x,player.x) < temp {
				temp = vec_dist (cameratemp,player.x);
				closest = n;
			}
		n = n + 1;
		}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];
			cameratemp.z = 1700; 

			vec_set(camera.x, cameratemp);
	}
	wait(1);
	}

}

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"flat tire") == 1) { msg.string = "cheat enabled"; show_message(); cheat1 = 5000; play_sound (CheatSound,100); }	
	if (str_cmpi (cheatstring,"bumper cars") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }	
	if (str_cmpi (cheatstring,"final lap") == 1) { msg.string = "cheat enabled"; show_message(); player.lap = 2; play_sound (CheatSound,100); }	
	str_cpy (cheatstring,"");
}

action CrossedLine1
{

	if ((you.checkpoint == 5) && (my.skill1 == 1))
	{
		you.lap = you.lap + 1;
		you.pos = you.pos + 1;
		you.checkpoint = 1;

		if (you == player)
		{
			plaY_entsound (my,Crowd,100000);
			if (player.lap == 0) { sPlay ("PIP246.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
			if (player.lap == 1) { sPlay ("PIP247.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
			if (player.lap == 2) { sPlay ("PIP248.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
		}
	}

	if (you.checkpoint == (my.skill1 - 1)) 
	{
		you.pos = you.pos + 1;
		you.checkpoint = my.skill1;

		if (you == player)
		{
			plaY_entsound (my,Crowd,100000);
			if (player.lap == 0) { sPlay ("PIP246.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
			if (player.lap == 1) { sPlay ("PIP247.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
			if (player.lap == 2) { sPlay ("PIP248.WAV"); Talking = 1; while (GetPosition (Voice) < 1000000) { wait(1); } Talking = 0; }
		}
	}

	if (you.lap == 3)
	{
		if (you == player)
		{
			Olympic[1] = 1;
			WriteGameData(0);

			Run ("Intro12.exe");
		}
		else
		{
			if (Death == 0)
			{
				stop_sound (MUS);
				Death = 1;
				ShowRIP();
			}
		}
	}

}

action CrossedLine2
{
	SayIt();

	if (you.checkpoint == (my.skill1 - 1))
	{
		if (you == player) { plaY_entsound (my,Crowd,100000); }
		you.pos = you.pos + 1;
		you.checkpoint = my.skill1;
	}
}

action CrossedLine3
{
	SayIt();

	if (you.checkpoint == (my.skill1 - 1))
	{
		if (you == player) { plaY_entsound (my,Crowd,100000); }
		you.pos = you.pos + 1;
		you.checkpoint = my.skill1;
	}
}

action CrossedLine4
{
	SayIt();

	if (you.checkpoint == (my.skill1 - 1))
	{
		if (you == player) { plaY_entsound (my,Crowd,100000); }
		you.pos = you.pos + 1;
		you.checkpoint = my.skill1;
	}
}

action CrossedLine5
{
	SayIt();

	if (you.checkpoint == (my.skill1 - 1))
	{
		if (you == player) { plaY_entsound (my,Crowd,100000); }
		you.pos = you.pos + 1;
		you.checkpoint = my.skill1;
	}
}

function SayIt
{
	if ((you == player) && (Delay <= 0))
	{
		Delay = 100;
		if (player.checkpoint == (my.skill1 - 1)) { sPlay ("OLY002.WAV"); }
	}
}

action FinishLine1
{
	my.push = -20;
	my.enable_push = on;
	my.event = CrossedLine1;
	my.skin = 1;
}

action FinishLine2
{
	my.push = -20;
	my.enable_push = on;
	my.event = CrossedLine2;
	my.skin = 2;
}

action FinishLine3
{
	my.push = -20;
	my.enable_push = on;
	my.event = CrossedLine3;
	my.skin = 3;
}

action FinishLine4
{
	my.push = -20;
	my.enable_push = on;
	my.event = CrossedLine4;
	my.skin = 4;
}

action FinishLine5
{
	my.push = -20;
	my.enable_push = on;
	my.event = CrossedLine5;
	my.skin = 5;
}

action Bump
{
	my.pan = random(360);
	if ((you == player) && (cheat2 != 1)) 
	{ 
		if (player.speed > 10) { player.speed = player.speed - 5; } 
	}
}

action Wheel
{
	my.ambient = 50;
	my.shadow = on;

	my.pan = random(360);
	my.enable_impact = on;
	my.event = Bump;
}

function Accelerate
{
	player.accel = 1;
}

function Brake
{
	player.accel = 2;
}

function togglegui
{
	if (gui.visible == off)
	{
		gui.visible = on;
		//Booth.visible = on;
		meter.visible = on;
	}
	else
	{	
		gui.visible = off;
		//Booth.visible = off;
		meter.visible = off;
	}
}

action my_fan
{
	while(1)
	{
		if (snd_playing (my.skill40) == 0) { play_entsound (my,WMill,2000); my.skill40 = result; }

		_player_intentions();

		if (key_force.y == 0) { player.accel = 0; }

		my.tilt = my.tilt + 15 * time;
		wait(1);
	}
}

function PlayerSpeed
{
	if (player.accel == 1)
	{
		if (player.speed < 200) { player.speed = player.speed + SPD * time; }
	}

	else
	{
		if (player.accel == 2)
		{
			if (player.speed > -10) { player.speed = player.speed - SPD * time; }
		}
		else
		{	
			SlowDown();
		}
	}

}

function SlowDown
{
	if (player.speed > 0) { player.speed = player.speed - SPD * time; } 
	if (player.speed < 0) { player.speed = player.speed + SPD * time; }
}

action Kiviti
{
	/*
		Booth.x = my.x - 40;
		Booth.y = my.y + 130;
		Booth.z = my.z + 100;
		Booth.pan = 270;
		Booth.tilt = -20;
		Booth.visible = on;
	*/

	while(1)
	{
		if (MoviePlaying == 0)
		{
			if ((int(random(300)) == 150) && (snd_playing (KIV) == 0))
			{
				my.skill40 = int(random(6)) + 1;

				if (my.skill40 == 1)
				{
					LeadRacer();
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					play_sound (KIV01,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}

				if (my.skill40 == 2)
				{
					play_sound (KIV02,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					RandomRacer();
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					play_sound (KIV03,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}

				if (my.skill40 == 3)
				{
					play_sound (KIV04,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}

				if (my.skill40 == 4)
				{
					play_sound (KIV05,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					RandomRacer();
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}

				if (my.skill40 == 5)
				{
					play_sound (KIV06,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					RandomRacer();
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
					play_sound (KIV07,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}

				if (my.skill40 == 6)
				{
					play_sound (KIV08,100); KIV = result;
					while (snd_playing (KIV) == 1) { Talk(); Wait(1); }
				}
			}
		}

		if (Talking == 10) { Talk(); } else { Blink(); }
		wait(1);
	}
}

function LeadRacer
{
	Positions[1] = old1.pos;
	Positions[2] = old2.pos;
	Positions[3] = old3.pos;
	Positions[4] = old4.pos;
	Positions[5] = old5.pos;
	Positions[6] = old6.pos;
	Positions[7] = old7.pos;
	Positions[8] = player.pos;

	my.skill39 = 0;

	my.skill38 = 1;
	my.skill39 = 1;

	while (my.skill38 < 8)
	{
		if (Positions [my.skill38] >= Positions [my.skill39]) { my.skill39 = my.skill38; my.skill39 = my.skill38; }
		my.skill38 = my.skill38 + 1;
	}

	if (Position == 1) { my.skill39 = 8; }

	if (my.skill39 == 1) { play_sound (Name2,100); }
	if (my.skill39 == 2) { play_sound (Name8,100); }
	if (my.skill39 == 3) { play_sound (Name5,100); }
	if (my.skill39 == 4) { play_sound (Name7,100); }
	if (my.skill39 == 5) { play_sound (Name6,100); }
	if (my.skill39 == 6) { play_sound (Name4,100); }
	if (my.skill39 == 7) { play_sound (Name3,100); }
	if (my.skill39 == 8) { play_sound (Name1,100); }

	KIV = result;
}

function RandomRacer
{
	my.skill39 = int(random(8)) + 1;

	if (my.skill39 == 1) { play_sound (Name1,100); }
	if (my.skill39 == 2) { play_sound (Name2,100); }
	if (my.skill39 == 3) { play_sound (Name3,100); }
	if (my.skill39 == 4) { play_sound (Name4,100); }
	if (my.skill39 == 5) { play_sound (Name5,100); }
	if (my.skill39 == 6) { play_sound (Name6,100); }
	if (my.skill39 == 7) { play_sound (Name7,100); }
	if (my.skill39 == 8) { play_sound (Name8,100); }

	KIV = result;
}

action Gidi
{
	while(1)
	{
		if (Talking == 2) { ent_frame ("Drum",60); } else { if (int(random(40)) == 20) { ent_frame ("Stand",int(random(4)) * 33.3); } }
		wait(1);
	}
}

action Ad
{
	my.skin = int(random(7)) + 1;
}

function CheckPosition
{
	while (old1 == null) { wait(1); }

	Position = 8;

	if (player.pos >= old1.pos) { Position = Position - 1; }
	if (player.pos >= old2.pos) { Position = Position - 1; }
	if (player.pos >= old3.pos) { Position = Position - 1; }
	if (player.pos >= old4.pos) { Position = Position - 1; }
	if (player.pos >= old5.pos) { Position = Position - 1; }
	if (player.pos >= old6.pos) { Position = Position - 1; }
	if (player.pos >= old7.pos) { Position = Position - 1; }
}

action Tree
{
	my.pan = random(360);
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

action CamIntro
{
	while (MoviePlaying == 1) { wait(1); }

	my.skill10 = my.y;
	my.y = my.y - 8000;

	while(Talking > 0)
	{
		if (my.y < my.skill10) { my.y = my.y + 55 * time; }

		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.roll = my.roll;
		camera.tilt = my.tilt;

		wait(1);
	}
}

action Yach
{
	while(1)
	{
		if (Talking == 1) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action StartCam
{
	my.skill10 = my.y;
	my.y = my.y + 10000;

	while(MoviePlaying == 1)
	{
		if (my.y > my.skill10) { my.y = my.y - 40 * time; }

		if (my.skill1 < 180) { my.roll = my.roll + 2 * time; my.tilt = my.tilt - 1 * time; my.skill1 = my.skill1 + 1 * time; }

		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.roll = my.roll;
		camera.tilt = my.tilt;

		wait(1);
	}
}

action Zepplin
{
	actor_init();
	drop_shadow();
	my.skill20 = my.z;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;

	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		//ForceBKP.x = force.x;
		//ForceBKP.y = force.y;
		//ForceBKP.z = force.z;

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		force = 1;
		actor_turnto(my_angle.PAN);

		force = 3;
		actor_move();

		//force.x = ForceBKP.x;
		//force.y = ForceBKP.y;
		//force.z = ForceBKP.z;

		my.z = my.skill20;

		ent_cycle ("Walk",my.skill30);
		my.skill30 = my.skill30 + 20;

		wait(1);
	}
}

on_F1 = ChangeCamera;
on_F2 = togglegui;
on_tab = cheat;

on_cuu = Accelerate;
on_cud = Brake;