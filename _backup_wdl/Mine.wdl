include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var VView = 1;
var CamView = 0;
var WheelGo = 0;
var ElevatorEnabled = 0;

var Telep[3] = 0,0,0;
var Faggy = 0;

var Cheat1 = 0;
var Cheat2 = 0;
var Cheat3 = 0;
var NoMore = 0;

var SND1;
var SND2;
var SND3;
var SND4;
var MUS;

sound CheatSound = <SFX035.WAV>;

var Death;

var FirstTime = 0;

var FAL = 0;

sound Gezer1 = <SNG003.WAV>;
sound Gezer2 = <SNG003.WAV>;
sound Falafel = <FAL001.WAV>;

sound Work = <SFX059.WAV>;
sound Drive = <SFX060.WAV>;

define health,skill22;

sound BGMusic = <SNG021.WAV>;

bmap bMine01 = <mine1.pcx>;
bmap bMine02 = <mine2.pcx>;
bmap bMine03 = <mine3.pcx>;
bmap bMine04 = <mine4.pcx>;
bmap bMine05 = <mine5.pcx>;
bmap bMine06 = <mine6.pcx>;
bmap bMine07 = <mine7.pcx>;
bmap bMine08 = <mine8.pcx>;
bmap bMine09 = <mine9.pcx>;
bmap bMine10 = <mine10.pcx>;
bmap bMine11 = <mine11.pcx>;

panel GUI 
{
	bmap = bMine01;
	pos_x = 0;
	pos_y = 0;
	layer = 4;
	flags = refresh,d3d,overlay,visible;
}

bmap bCongrat = <afri2.pcx>;

panel pCongrat
{
	bmap = bCongrat;
	pos_x = 200;
	pos_y = 70;
	layer = 4;
	flags = refresh,d3d;

	button = 0, 0, bCongrat, bCongrat, bCongrat, C1, null, null;
}

string cheatstring = "                                    ";

function C1 { pCongrat.visible = off; }

function UpdatePanel
{
	if (player.health == 100) { GUI.bmap = bMine01; }
	if (player.health == 90) { GUI.bmap = bMine02; }
	if (player.health == 80) { GUI.bmap = bMine03; }
	if (player.health == 70) { GUI.bmap = bMine04; }
	if (player.health == 60) { GUI.bmap = bMine05; }
	if (player.health == 50) { GUI.bmap = bMine06; }
	if (player.health == 40) { GUI.bmap = bMine07; }
	if (player.health == 30) { GUI.bmap = bMine08; }
	if (player.health == 20) { GUI.bmap = bMine09; }
	if (player.health == 10) { GUI.bmap = bMine10; }
	if (player.health == 0)  { GUI.bmap = bMine11; }
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	CamView = 0;
	warn_level = 0;
	tex_share = on;
	PrevDist = camera_dist;
	camera_dist = 50;
	camera.arc = 220;
	clip_range = 10000;

	WheelGo = 0;

	Cheat1 = 0;
	Cheat2 = 0;
	Cheat3 = 0;

	fog_color = 1;
	camera.fog = 10;

	load_level(<Mine.WMB>);

	VoiceInit();
	initialize();

	stop_sound (MUS);
	play_loop (BGMusic,100);
	MUS = result;
}

function _player_intentions()
{
// Set the angular forces according to the player intentions
	aforce.PAN = -astrength.PAN*(KEY_FORCE.X+JOY_FORCE.X) / 2;
	aforce.TILT = astrength.TILT*(KEY_PGUP-KEY_PGDN);
	aforce.ROLL = 0;
// Set ROLL force if ALT was pressed
	if(KEY_ALT != 0)
	{
		aforce.ROLL = aforce.PAN;
		aforce.PAN = 0;
	}

// Limit the forces in case the player
// pressed buttons, mouse and joystick simultaneously
	limit.PAN = 2*astrength.PAN;
	limit.TILT = 2*astrength.TILT;
	limit.ROLL = 2*astrength.ROLL;

	if(aforce.PAN > limit.PAN) {  aforce.PAN = limit.PAN; }
	if(aforce.PAN < -limit.PAN) {  aforce.PAN = -limit.PAN; }
	if(aforce.TILT > limit.TILT) {  aforce.TILT = limit.TILT; }
	if(aforce.TILT < -limit.TILT) {  aforce.TILT = -limit.TILT; }
	if(aforce.ROLL > limit.ROLL) {  aforce.ROLL = limit.ROLL; }
	if(aforce.ROLL < -limit.ROLL) {  aforce.ROLL = -limit.ROLL; }

// Set the cartesian forces according to the player intentions
	force.X = strength.X*(KEY_FORCE.Y+JOY_FORCE.Y);  // forward/back
	force.Y = strength.Y*(KEY_FORCE.X);     // side to side
	force.Z = strength.Z*(KEY_HOME-KEY_END);         // up and down
	if(MOUSE_MODE == 0)
	{	// Mouse switched off?
		force.X += strength.X*MOUSE_RIGHT*mouseview;
	}

// Limit the forces in case the player tried to cheat by
// operating buttons, mouse and joystick simultaneously
	limit.X = strength.X / 2;
	limit.Y = strength.Y / 2;
	limit.Z = strength.Z / 2;

	if(force.X > limit.X) {  force.X = limit.X; }
	if(force.X < -limit.X) { force.X = -limit.X; }
	if(force.Y > limit.Y) {  force.Y = limit.Y; }
	if(force.Y < -limit.Y) { force.Y = -limit.Y; }
	if(force.Z > limit.Z) {  force.Z = limit.Z; }
	if(force.Z < -limit.Z) { force.Z = -limit.Z; }
}

ACTION miner_drive
{
	my.health = 100;

	MY._MOVEMODE = _MODE_DRIVING;
	MY._FORCE = 1;
	MY._BANKING = 0.5;
	MY.__SLOPES = ON;
	MY.__TRIGGER = ON;
	my.push = -10;

	if (FirstTime == 0) { sPlay ("PIP195.WAV"); FirstTime = 1; }

	miner_move();
}

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 200;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		//MY_COLOR.RED = fade_color.RED;
		//MY_COLOR.GREEN = fade_color.GREEN;
		//MY_COLOR.BLUE = fade_color.BLUE;

		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 255;
		MY_COLOR.BLUE = 255;

	}
	else
	{
		MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		if(MY_AGE > 50) { MY_ACTION = NULL; }
	}
}

ACTION miner_move
{
	if(MY.CLIENT == 0) { player = ME; } // created on the server?
	Death = 0;
	WheelGo = 0;
	UpdatePanel();

	MY._TYPE = _TYPE_PLAYER;
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

	// while we are in a valid movemode
	while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		updatepanel();
		if (snd_playing (SND3) == 0) { play_sound (Work,20); SND3 = result; }
		if (snd_playing (SND4) == 0) { play_sound (Drive,50); SND4 = result; }

		if ((GetPosition(Voice) >= 1000000) && (int(random(1000)) == 500))
		{
			temp = int(random(4)) + 1;
			if (temp == 1) { sPlay ("PIP196.WAV"); }
			if (temp == 2) { sPlay ("PIP197.WAV"); }
			if (temp == 3) { sPlay ("PIP198.WAV"); }
			if (temp == 4) { sPlay ("PIP199.WAV"); }
		}

		my.lightred = 0;
		my.lightgreen = 0;
		my.lightblue = 0;
		my.lightrange = 0; 

		if (cheat2 == 1) 
		{ 
			my.lightred = 0;
			my.lightgreen = 0;
			my.lightblue = 255;
			my.lightrange = 100; 
		} 

		if (cheat1 > 0) 
		{ 
			my.lightred = 255;
			my.lightgreen = 255;
			my.lightblue = 0;
			my.lightrange = 100; 
			cheat1 = cheat1 - 1 * time; 
		} 

		if (entSaveLoadMenu.visible == off) { if (Camera.arc > 120) { Camera.arc = Camera.arc - 2 * time; } else { camera.arc = 120; } }

		// if we are not in 'still' mode
		if(MY._MOVEMODE != _MODE_STILL)
		{
			ent_cycle ("Frame",my.skill41);
			my.skill41 = my.skill41 + 5 * time;

			// Get the angular and translation forces (set aforce & force values)
			if (entSaveLoadMenu.visible == off) { _player_intentions(); }

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
					if (entSaveLoadMenu.visible == off) { move_gravity2(); }
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		// If I'm the only player, draw the camera and weapon with ME
		if (entSaveLoadMenu.visible == off) { miner_view(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function miner_view()
{
	if ((_camera == 0) && (player != NULL))
	{

 		CAMERA.DIAMETER = 0;		// make the camera passable
		CAMERA.genius = player;
		CAMERA.pan += 0.2 * ang(player.pan-CAMERA.pan);
		//camera.tilt = player.tilt;

		// tilt the camera differently if we are using a vehicle
 		if ( (player._MOVEMODE == _MODE_PLANE)
 			||(player._MOVEMODE == _MODE_CHOPPER))
 		{
 			CAMERA.tilt += 0.2 * ang(player.tilt-CAMERA.tilt);
 		}
		else
		{
			// walking, swimming etc.
			CAMERA.TILT = head_angle.TILT;

				camera_dist.Z = -(player.MAX_Z-player.MIN_Z)*eye_height_up;//- player.MAX_Z;


		}

		vec_set(temp,temp_cdist);      // temp = temp_cdist
		// don't tilt camera if swimming
		if(player._MOVEMODE == _MODE_SWIMMING)
		{
			temp2 = player.TILT;
			player.TILT = 0;
			vec_rotate(temp,player.PAN);
			player.TILT = temp2;
		}
		else
		{
			vec_rotate(temp,player.PAN);
		}
      CAMERA.X += 0.3*(player.X - temp.X - CAMERA.X);
      CAMERA.Y += 0.3*(player.Y - temp.Y - CAMERA.Y);
      CAMERA.Z += 0.3*(player.Z - temp.Z - CAMERA.Z);

	if (VView == -1)
	{
		camera.z = player.z;
		camera.y = player.y;
		camera.x = player.x;
		camera.tilt = player.tilt;
		camera.roll = player.roll;
		camera.pan = player.pan;
	}

//		vec_set(temp,player.x);
//		vec_sub(temp,camera.x);
//		vec_to_angle(camera.pan,temp);


 		// test if camera is IN_PASSABLE or IN_SOLID
		temp = ent_content(NULL,CAMERA.X);

		// if camera moved into a wall...
		if (temp == CONTENT_SOLID)
		{
			temp_cdist.X *= 0.7;	// place it closer to the player
			temp_cdist.Y *= 0.7;
			temp_cdist.Z *= 0.7;
		}
		else
		{
			temp_cdist.X += 0.2*(player.MAX_X + camera_dist.X - temp_cdist.X);
			temp_cdist.Y += 0.2*(player.MAX_Y + camera_dist.Y - temp_cdist.Y);
			temp_cdist.Z += 0.2*(player.MAX_Z + camera_dist.Z - temp_cdist.Z);
		}

		// check to see if camera is located in a passable block and set fog color index
		if (temp == CONTENT_PASSABLE)
		{
			if (FOG_COLOR != _FOG_UNDERWATER)
			{
				current_fog_index = FOG_COLOR;	// save old fog
				FOG_COLOR = _FOG_UNDERWATER; 		// set fog color to underwater fog
			}
		}
		else
		{
			if (FOG_COLOR == _FOG_UNDERWATER)
			{
				// else restore current_fog_index
				FOG_COLOR = current_fog_index;
			}
		}
		person_3rd = 1;
	}

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
	my._speed_x = 50;
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

action Collision
{
	player.lightrange = 1000;

	if (Cheat1 <= 0)
	{
		if (Cheat2 == 1) { you.health = you.health - 5; } else { you.health = you.health - 10; }
	}

	my.passable = on;
	actor_explode();

	if (you.health <= 0) { CamView = 1; }
}

action Collision2
{
	player.lightrange = 1000;

	if (Cheat1 <= 0)
	{
		if (Cheat2 == 1) { you.health = you.health - 5; } else { you.health = you.health - 10; }
	}

	my.passable = on;
	actor_explode();

	if (you.health <= 0) { CamView = 1; }
}

action Danger
{
	my.event = Collision;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_block = on;
	my.enable_impact = on;
}

action Rock
{
	if (player == null) { wait(1); }
	my.event = Collision2;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_block = on;
	my.enable_impact = on;
	my.skill2 = 1;
	my.skill40 = my.z;

	while (1)
	{
		if ((abs(my.x - player.x) < 500) && (abs(my.y - player.y) < 500)) { my.skill1 = 100; }
		if (my.skill1 == 100) {	my.z = my.z - 30 * time; }

		wait(1);
	}
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.pos_y = 460;
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);

	if (str_cmpi (cheatstring,"gold nugget shield") == 1) { if (NoMore == 0) { msg.string = "cheat enabled"; show_message(); cheat1 = 200; play_sound (CheatSound,100); } }
	if (str_cmpi (cheatstring,"plated trolly") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"hidden elevator") == 1) { msg.string = "cheat enabled"; show_message(); cheat3 = 1; play_sound (CheatSound,100); }

	str_cpy (cheatstring,"");
}

action Piposh
{
	if (player == null) { wait(1); }
	my.passable = on;

	while(1)
	{
		if (VView == 1)
		{
			if (int(random(20)) == 10) { ent_cycle ("Stand",int(random(4)) * 33); }
			my.skill1 = my.skill1 + 50 * time;
			my.x = player.x;
			my.y = player.y;
			my.z = player.z + 5;
			my.pan = player.pan;
			my.tilt = player.tilt;
			my.roll = player.roll * 1.5;
			my.invisible = off;
		}
		else { my.invisible = on; }

		wait(1);
	}
}

function ToggleView
{
	VView = -VView;
}

action Disco
{
	SET MY.INVISIBLE,ON;

	my.skill11 = my.skill1;

	my.skill1 = random(255);
	my.skill2 = random(255);
	my.skill3 = random(255);

	my.skill4 = random(255);
	my.skill5 = random(255);
	my.skill6 = random(255);

	my.skill7 = random(255);
	my.skill8 = random(255);
	my.skill9 = random(255);

	MY.LIGHTRED = random(255);
	MY.LIGHTGREEN = random(255);
	MY.LIGHTBLUE = random(255);

		WHILE (1) {
			if (my.skill11 == 1) { if (snd_playing (SND1) == 0) { play_entsound(my,Gezer1,1000); SND1 = result; } }
			if (my.skill11 == 2) { if (snd_playing (SND2) == 0) { play_entsound(my,Gezer2,1000); SND2 = result; } }
		
			my.skill10 = int(random(3));
			if (my.skill10 == 0) { my.lightred = my.skill1; my.lightgreen = my.skill2; my.lightblue = my.skill3; }
			if (my.skill10 == 1) { my.lightred = my.skill4; my.lightgreen = my.skill5; my.lightblue = my.skill6; }
			if (my.skill10 == 2) { my.lightred = my.skill7; my.lightgreen = my.skill8; my.lightblue = my.skill9; }
			MY.LIGHTRANGE = RANDOM (2000) + 300;
		WAIT (1);

	}
} 

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

action Gayser
{
	my.invisible = on;

	while(1)
	{
		if (int(random(100)) == 50) { emit(50,MY.POS,Lavaflow); }
		wait(1);
	}
}

action HitCam
{
	my.skill40 = 0;

	while(1)
	{
		if (CamView == my.skill8)
		{
			if ((my.skill40 == 0) && (CamView ==1)) { sPlay ("SFX058.WAV"); my.skill40 = 1; }
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

action HitCart
{
	my.skill1 = my.y;

	while(1)
	{
		if (CamView == 1)
		{
			ent_cycle ("Frame",my.skill41);
			my.skill41 = my.skill41 + 5 * time;

			my.y = my.y + 70 * time;

			if ((my.y > (my.skill1 + 3000)) && (my.y < (my.skill1 + 4000))) { camera.z = camera.z + random(5); }

			if (my.y > (my.skill1 + 4000)) { WheelGo = 1; }
		}

		wait(1);
	}
}

action PipFly
{
	while(1)
	{
		ent_frame ("Crawl",0);
		my.roll = my.roll + 20 * time;
		if (WheelGo == 1) { my.y = my.y - 100 * time; my.skill10 = my.skill10 + 1 * time; if (my.skill10 > 50) { if (Death == 0) { restart(); } } }
		wait(1);
	}
}

action Wheely
{
	while(1)
	{
		if (WheelGo == 1)
		{
			ent_frame ("Frame",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}

		wait(1);
	}
}

action LavaCart
{
	while (1)
	{
		if (CamView == 2)
		{
			my.x = my.x - 20 * time; 
			my.y = my.y - 10 * time; 
			my.roll = my.roll - 5 * time;
			my.skill1 = my.skill1 + 1 * time;
			my.z = my.z - 3 * time;

			if (my.skill1 > 10) { my.z = my.z - 50 * time; }

			if (my.skill1 > 50) { if (Death == 0) { restart(); } }
		}

		wait(1);
	}
}

action LavaBlow
{
	while(1)
	{
		if ((CamView == 2) && (my.skill2 != 1))
		{
			my.skill1 = my.skill1 + 1 * time;
			my.skill3 = random(100)+100;
			if (my.skill1 > 13) { emit(my.skill3,MY.POS,Lavaflow); my.skill2 = 1; }
		}

		wait(1);
	}
}

action LavaBurn
{
	CamView = 1;
}

action ElvHit { ElevatorEnabled = 1; }

action Elvator
{
	my.event = ElvHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_block = on;
	my.enable_impact = on;

	my.skill1 = 0;

	while(1)
	{
		if (cheat3 == 1)
		{
			my.passable = off;
			my.invisible = off;
		}

		if (ElevatorEnabled == 1)
		{
			my.passable = off;
			my.invisible = off;
			my.skill1 = my.skill1 + 1 * time;
			if (my.skill1 < 50) { my.z = my.z + 5 * time; }
		}

		wait(1);
	}
}

action Fence
{
	while(1)
	{
		if (cheat3 == 1)
		{
			my.passable = off;
			my.invisible = off;
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
	my.lightrange = 600;

	while(1)
	{
		my.lightrange = my.lightrange + (int(random(3)) - 1) * 3;
		if (my.lightrange > 700) { my.lightrange = 700; }
		if (my.lightrange < 400) { my.lightrange = 400; }
		wait(1);
	}
}

action Lava
{
	if (player == null) { wait(1); }
	SET MY.LIGHTRED,255;
	SET MY.LIGHTGREEN,0;
	SET MY.LIGHTBLUE,0;
	MY.LIGHTRANGE = 1500;

	while(1)
	{
		if (abs(player.z - my.z) < 700)
		{
			CamView = 2;
		}

		my.lightrange = 1500 + ((random(3) - 1) * 20) ;

		wait(1);
	}
}

action FalMan
{
	while (1)
	{
		if (snd_playing (FAL) == 0) { play_entsound(my,Falafel,1000); FAL = result; }
		wait(1);
	}
}

action EndIt
{
	if (player.Health == 100)
	{
		pCongrat.visible = on;
	}

	while (pCongrat.visible == on) { wait(1); }

	Piece[2] = 1;
	Volcano[4] = 1;
	WriteGameData(0);

	run ("AfterMin.exe");
}

action EndLevel
{
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = EndIt;
}

function Restart
{
	if (Death == 0)
	{
		Death = 1;
		player.health = 100;
		stop_sound (MUS);
		ShowRIP();
	}
}

on_F1 = ToggleView();
on_tab = cheat;