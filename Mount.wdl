include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode

var CONSTRANGE = 150;
var CONSTGUNHIT = 2000;
var CONSTGUNFIRE = 300;

var DMG = 0.5;
var PLAYERDMG = 30;
var SEN = 3;

var BombTimer = 0;
var BX = 0;
var BY = 0;
var pDelay;

var MisViewEnabled = 1;

var Launch = 0;

var GeniaX;
var GeniaY;
var GeniaZ;

var PlanesLeft;
var Base = 0;
var Cheat1 = 0;
var Cheat2 = 0;
var VView = 1;
string cheatstring = "                                                               ";
var Alt;
var PlayerHealth;
var BBomb = 0;

var Fire_delay;

sound BGMUsic = <SNG020.WAV>;
sound CheatSound = <SFX035.WAV>;
var MUS = 0;

string PlaneName = "                        ";
var PlaneHealth;
var Death = 0;

synonym xTarget    { TYPE ENTITY; }
synonym TheMount   { TYPE ENTITY; }
synonym TempSyn    { TYPE ENTITY; }
SYNONYM test_actor { TYPE ENTITY; }
SYNONYM ent_marker { TYPE ENTITY; }
synonym Border     { TYPE ENTITY; }
synonym plane01    { TYPE ENTITY; }
synonym plane02    { TYPE ENTITY; }
synonym plane03    { TYPE ENTITY; }
synonym plane04    { TYPE ENTITY; }
synonym plane05    { TYPE ENTITY; }
synonym plane06    { TYPE ENTITY; }
synonym plane07    { TYPE ENTITY; }
synonym plane08    { TYPE ENTITY; }
synonym plane09    { TYPE ENTITY; }

define Health,skill10;
define myage,skill11;
define speed,skill20;

bmap bmpRadar = <Radar.pcx>;
bmap bmpCover = <Radar2.pcx>;
bmap Grad =     <Grad.bmp>;
bmap bMisView = <Missle.pcx>;
bmap bToTemple = <temple.pcx>;

panel pToTemple
{
	layer = 20;
	bmap = bToTemple;
	flags = refresh,d3d;
	pos_x = 200;
	pos_y = 230;
}

view MissileCam
{
	pos_x = 440;
	pos_y = 10;
	layer = 6;
	size_x = 200;
	size_y = 200;
}

view TargetCam
{
	pos_x = 440;
	pos_y = 230;
	layer = 6;
	size_x = 200;
	size_y = 200;
}


view Minimap
{
	pos_x = 0;
	pos_y = 0;
	layer = 3;
	size_x = 640;
	size_y = 480;
}

view Radar
{
	layer = 3;
	size_x = 200;
	size_y = 200;
	pos_x = 19;
	pos_y = 20;
	flags = visible;
}

panel MisView
{
	bmap = bMisView;
	flags = refresh,d3d,overlay;
	pos_x = 430;
	pos_y = 0;
}

panel guiCover
{
	bmap = bmpCover;
	pos_x = 16;
	pos_y = 16;
	layer = 6;
	flags = refresh,d3d,visible,transparent,overlay;
}

Text guiPlaneName
{
	layer = 8;
	pos_x = 260;
	pos_y = 40;
	string = "                            ";
	font = standard_font;
	flags = visible;
}

panel guiPlaneHealth 
{
	bmap = bmpRadar;
	pos_x = 0;
	pos_y = 0;
	layer = 5;
	flags = refresh,d3d,visible,overlay;
	digits 245,63,6,standard_font,1,Alt;
	digits 323,63,1,standard_font,1,PlanesLeft;
}

panel guiMeter
{
	layer = 6;
	window 250,10,100,15,Grad,PlayerHealth,0;
	window 250,34,100,15,Grad,PlaneHealth,0;
	flags = refresh,d3d,visible,overlay;
}

bmap bdrop = <drop.bmp>;

sound Dying = <SFX063.WAV>;
sound Engine = <SFX064.WAV>;
sound sFire = <SFX026.WAV>;
sound MLaunch = <SFX073.WAV>;
sound GunHit = <SFX130.wAV>;
sound Explos = <SFX055.WAV>;
sound Bonus = <SFX103.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _VOLCANO;

	warn_level = 0;
	tex_share = on;

	Launch = 0;
	BBomb = 0;

	cheat1 = 0;
	cheat2 = 0;

	fog_color = 1;
	camera.fog = 30;
	minimap.fog = 30;
	MissileCam.fog = 30;
	TargetCam.fog = 30;

	load_level(<Mount.WMB>);

	VoiceInit();
	Initialize();

	let_it_snow();
}

function _player_intentions()
{
// Set the angular forces according to the player intentions
	aforce.PAN = -astrength.PAN*((KEY_FORCE.X+JOY_FORCE.X) / 2);
	aforce.TILT = astrength.TILT*((-KEY_FORCE.Y) / 2);
	if(MOUSE_MODE == 0)
	{	// Mouse switched off?
		 aforce.PAN += -astrength.PAN*MOUSE_FORCE.X*mouseview*(1+KEY_SHIFT);
		 aforce.TILT += astrength.TILT*MOUSE_FORCE.Y*mouseview*(1+KEY_SHIFT);
	}
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
	limit.X = strength.X;
	limit.Y = strength.Y;
	limit.Z = strength.Z;

	if(force.X > limit.X ) { force.X = limit.X;  }
	if(force.X < -limit.X) { force.X = -limit.X; }
	if(force.Y > limit.Y ) { force.Y = limit.Y;  }
	if(force.Y < -limit.Y) { force.Y = -limit.Y; }
	if(force.Z > limit.Z ) { force.Z = limit.Z;  }
	if(force.Z < -limit.Z) { force.Z = -limit.Z; }
}

function stream()
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = scatter_speed.X + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Y = scatter_speed.Y + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Z = scatter_speed.Z + RANDOM(scatter_spread) - (scatter_spread/2);

		MY_SIZE = scatter_size;
		MY_MAP = bdrop;
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

action Mountain
{
	TheMount = my;

	particle_pos.x = my.x;
	particle_pos.y = my.y;
	particle_pos.z = my.z + 120;

	while(1)
	{
		if (player == null) { return; }
		if (BBomb == 2) 
		{ 
			BombTimer = BombTimer - 1; 
			if (BombTimer < 0) { BBomb = 0; }
		}

		PlayerHealth = 100 - player.health;
		Alt = player.z - TheMount.z - 41;
		emit 50,particle_pos,stream;
		guiPlaneName.string = PlaneName;
		wait(1);
	}

}

action Blow
{
	_gib(1);
	remove (me);
}

action Collide
{
	play_entsound (my,Explos,CONSTRANGE);

	if ((you != Border) && (you.skill41 != 1))
	{
		you.skill38 = 30; my.skill38 = 30;
		my.health = my.health - 2;
		you.health = you.health - 2;

		create (<PSpark.mdl>,my.x,Blow);
	}
}

action Collide2
{
	play_entsound (my,Explos,CONSTRANGE);

	if (you.skill41 == 20)
	{
		my.health = my.health - 25;
		create (<PSpark.mdl>,my.x,Blow);
	}
}

ACTION player_fly
{
	stop_sound (MUS);
	play_loop (BGMusic,100);
	MUS = result;

	my.skin = 2;

	my.event = collide;

	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;

	MY._MOVEMODE = _MODE_DRIVING;
	MY._FORCE = 2;
	MY._BANKING = 2;
	MY.__JUMP = ON;
	MY.__DUCK = ON;
	MY.__STRAFE = OFF;
	MY.__BOB = ON;
	my.ambient = 50;
	my.speed = 10;
	drop_shadow();

	my.health = 100;

	player_move2();
}

function ToggleView
{
	VView = VView + 1;
	if (VView > 2) { VView = 1; }
}

function TogglePanel
{
	Radar.visible = (Radar.visible == off);
	guiPlaneName.visible = (guiPlaneName.visible == off);
	guiPlaneHealth.visible = (guiPlaneHealth.visible == off);
	guiMeter.visible = (guiMeter.visible == off);
	guiCover.visible = (guiCover.visible == off);
}

ACTION player_move2
{
	Death = 0;
	my.skill40 = my.z + 500;
	my.skill41 = my.z + 1500;

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

	//if (snd_playing (MUS) == 0) { play_sound (BGMusic,75); MUS = result; }

	if (VView == 1) 
	{ 
		minimap.visible = off; 
		camera.visible = on; 
	} 

	if (VView == 2)
	{
		minimap.visible = on; 
		camera.visible = off; 
	}

	minimap.z = my.skill40;
	minimap.x = my.x;
	minimap.y = my.y;

	vec_set(temp,player.x);
	vec_sub(temp,minimap.x);
	vec_to_angle(minimap.pan,temp);

	radar.z = my.skill41;
	radar.x = my.x;
	radar.y = my.y;
	radar.pan = my.pan;
	radar.tilt = 270;

	if ((plane01 == null) || (plane02 == null) || (plane03 == null) || (plane04 == null) || (plane05 == null) || (plane06 == null) || (plane07 == null)
	|| (plane08 == null) || (plane09 == null)) { wait(1); }

		CheckPlanes();

		SetSkin();
		Smoke();

		ent_cycle ("Fly",my.skill45);
		my.skill45 = my.skill45 + 30 * time;

		my.pan = camera.pan;
		my.tilt = camera.tilt;
		my.roll = camera.roll;

		// if we are not in 'still' mode
		if(MY._MOVEMODE != _MODE_STILL)
		{
			if (snd_playing(my.skill40) == 0) { if (my.health > 50) { play_sound (Engine,3); } else { play_sound (Dying,3); } }

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

		if((key_space == 1) || (mouse_left == 1)) { mefire(); }

		move_view_3rd();

		if (player.health <= 0) { if (Death == 0) { _gib(100); player.health = 0; actor_explode(); wait(1); stop_sound (MUS); ShowRIP(); Death = 1; } }

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}


function move_gravity2()
{
	temp = max((1-TIME*friction),0);
	MY._SPEED_X = my.speed;
	MY._SPEED_Y = (TIME * force.y) + (temp * MY._SPEED_Y);    // vy = ay*dt + max(1-f*dt,0) * vy
	MY._SPEED_Z = (TIME * absforce.z) + (temp * MY._SPEED_Z);

	dist.x = MY._SPEED_X * TIME;  	// dx = vx * dt
	dist.y = MY._SPEED_Y * TIME;     // dy = vy * dt
	dist.z = MY._SPEED_Z * TIME;                      // dz = 0  (only gravity and jumping)

	absdist.x = absforce.x * TIME * TIME;   // dx = ax*dt^2
	absdist.y = absforce.y * TIME * TIME;   // dy = ay*dt^2
	absdist.z = MY._SPEED_Z * TIME;         // dz = vz*dt

	YOU = NULL;	// YOU entity is considered passable by MOVE

	vec_scale(dist,movement_scale);	// scale distance by movement_scale

 	move(ME,dist,absdist);
	if(RESULT > 0)
	{
		my_dist = vec_length(dist);
	}
	else
	{
		my_dist = 0;
	}
}

function enemygravity()
{
	// Filter the forces and frictions dependent on the state of the actor,
	// and then apply them, and move him

	// accelerate the entity relative speed by the force
	// -old method- ACCEL	speed,force,friction;
 	// replaced min with max (to eliminate 'creep')
	temp = max((1-TIME*friction),0);
	MY._SPEED_X = (TIME * force.x) + (temp * MY._SPEED_X);    // vx = ax*dt + max(1-f*dt,0) * vx
	MY._SPEED_Y = (TIME * force.y) + (temp * MY._SPEED_Y);    // vy = ay*dt + max(1-f*dt,0) * vy
	MY._SPEED_Z = (TIME * absforce.z) + (temp * MY._SPEED_Z);

	if (my.z < player.z) { my._speed_z = 10; }
	if (my.z > player.z) { my._speed_z = -10; }

//	if (my.z < player.z) { my.tilt = 10; }
//	if (my.z > player.z) { my.tilt = -10; }

	// calculate relative distances to move
	dist.x = MY._SPEED_X * TIME;  	// dx = vx * dt
	dist.y = MY._SPEED_Y * TIME;     // dy = vy * dt
	dist.z = MY._SPEED_Z;                      // dz = 0  (only gravity and jumping)

	// calculate absolute distance to move
	absdist.x = absforce.x * TIME * TIME;   // dx = ax*dt^2
	absdist.y = absforce.y * TIME * TIME;   // dy = ay*dt^2
	absdist.z = MY._SPEED_Z * TIME;         // dz = vz*dt

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

function kill()
{
	if((EVENT_TYPE == EVENT_SCAN && indicator == _EXPLODE)
		|| (EVENT_TYPE == EVENT_SHOOT && indicator == _GUNFIRE))
	{
		MY._SIGNAL = _DETECTED;	// by shooting, player gives away his position

		if (indicator == _EXPLODE)
		{	// reduce damage according to distance
			damage *= ABS(range - RESULT)/range;
		}

		if(MY._ARMOR <= 0)
		{
			MY._HEALTH -= damage;
		}
		else
		{
			MY._ARMOR -= damage;
		}
		return;
	}

	if(EVENT_TYPE == EVENT_DETECT && YOU == player)
	{
		wait(1);	//fix for dangerous instruction
		indicator = _WATCH;
//---		SHOOT MY.POS,YOUR.POS;	// can player be seen from here?
		trace_mode = IGNORE_ME + IGNORE_PASSABLE + ACTIVATE_SHOOT;
		RESULT = trace(MY.POS,YOUR.POS); // if entity YOU was visible from MY position, its SHOOT event was triggered
		if((RESULT > 0) && (YOU == player)) // yes
		{
			MY._SIGNAL = _DETECTED;
		}
		return;
	}
}

ACTION EnemyFighter
{
	my.skin = 1;
	MY._FORCE = 1.7;
	my.ambient = 50;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.05;
	MY._HITMODE = HIT_GIB;//HIT_EXPLO;
	anim_init();
	fight();
}

function fight()
{
//	if(MY._ARMOR == 0) { MY._ARMOR = 100; }
	if(MY._HEALTH == 0) { MY._HEALTH = 100; }	// default health
	if(MY._FORCE == 0) { MY._FORCE = 1; }       // default force

	// Allow player to pass thru actor if frozen
	if(freeze_actors > 1) { MY.PASSABLE = ON; }

	MY._SIGNAL = 0;
	MY.ENABLE_SCAN = ON;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_DETECT = ON;
	MY.EVENT = kill;

	BRANCH statewait;
}

function actormove()
{
	force.x = 10;

	// find ground below
	scan_floor();
	enemygravity();
	actor_anim();
}

function stateattack()
{
	MY._STATE = _STATE_ATTACK;

	MY._MOVEMODE = _MODE_ATTACK;	// stop patrolling etc.
	attack_transitions();      // branch to other states depending on values

	// fire and close distance
	while(MY._STATE == _STATE_ATTACK)
	{

		// fire two or three times
		MY._COUNTER = 1.5 + RANDOM(1);

 		// check to see if player is shootable,
 		if((attack_fire()) == -1)
 		{
 			// cannot see player
 			EXCLUSIVE_ENTITY; wait(1); BRANCH state_hunt;
 		}
		while(MY._COUNTER > 0) { wait(1); }	// don't continue until attack_fire is finished


		// walk towards player for one to three seconds
		MY._COUNTER = 16 + RANDOM(32);
		attackapproach();
		while(MY._COUNTER > 0) { wait(1); } // don't continue until attack_approach is finished
	}
}

function attackapproach()
{
	// calculate a direction to walk into
	temp.X = player.X - MY.X;
	temp.Y = player.Y - MY.Y;
	temp.Z = player.z - my.z;
	TO_ANGLE MY_ANGLE,temp;
	// ADD random deviation angle
	MY._TARGET_PAN = MY_ANGLE.PAN - 15 + RANDOM(30);

	while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{

	// turn towards player
		MY_ANGLE.PAN = MY._TARGET_PAN;
		MY_ANGLE.TILT = MY._TARGET_TILT;
		MY_ANGLE.ROLL = MY._TARGET_ROLL;
		force = MY._FORCE * 2;
		actor_turn();

		// walk towards him if not too close
//		temp = (player.X - MY.X)*(player.X - MY.X)+(player.Y - MY.Y)*(player.Y - MY.Y);
//		if(temp > 10000)  // 100^2
//		{
			force = 10;
			MY._MOVEMODE = _MODE_SWIMMING;
			actormove();
//		}

		wait(1);
		MY._COUNTER -= TIME;
	}
}




function statewait()
{
	MY._STATE = _STATE_WAIT;
	while(MY._STATE == _STATE_WAIT)
	{

		if(MY._HEALTH <= 0) { EXCLUSIVE_ENTITY; wait(1); BRANCH state_die; }        // no health? Die
		if(MY._HEALTH <= 30) { EXCLUSIVE_ENTITY; wait(1); BRANCH state_escape; }    // low health? Escape


			MY._SIGNAL = 0;
			BRANCH stateattack;	// ATTACK!

	}
}

function gunfire()
{
	if (int(random(2)) == 1)
	{
		shot_speed.x = 30;
		shot_speed.y = 0;
		shot_speed.z = 0;
		my_angle.pan = my.pan;
		my_angle.tilt = my.tilt;
		my_angle.roll = my.roll;
		vec_rotate(shot_speed,my_angle);

		create(<PSpark.mdl>,my.x,Spark);
	}
}

function mefire()
{
	if (Fire_delay <= 0)
	{
		shot_speed.x = 50;
		shot_speed.y = 0;
		shot_speed.z = 0;
		my_angle.pan = player.pan;
		my_angle.tilt = player.tilt;
		my_angle.roll = player.roll;
		vec_rotate(shot_speed,my_angle);
	
		create(<ESpark.mdl>,player.x,MeSpark);

		Fire_delay = 1.5;
	}
	else { Fire_delay = Fire_delay - 1 * time; }
}

ACTION SparkHit
{
	play_entsound (my,GunHit,CONSTGUNHIT);

	if (you == player)	// if player is hit, unless total war cheat has been enabled, in that case, everyone can be hit.
	{
		player.health =	player.health - DMG;
	}

	remove (my);
}

action MeHit
{
	play_entsound (my,GunHit,CONSTGUNHIT);

	if (you != null)
	{
		if (you != player)
		{
			ShowName();
			if (cheat2 == 0) { you.health = you.health - PLAYERDMG; }
			else { you.health = you.health - PLAYERDMG * 3; }

			create (<PSpark.mdl>,my.x,Blow);
			remove (my);
		}
	}
}

function ShowName
{
	if (you.skill30 == 1) { str_cpy(PlaneName,"EUM");    }
	if (you.skill30 == 2) { str_cpy(PlaneName,"XJJH");   }
	if (you.skill30 == 3) { str_cpy(PlaneName,"SJLFMU"); }
	if (you.skill30 == 4) { str_cpy(PlaneName,"JSJM");   }
	if (you.skill30 == 5) { str_cpy(PlaneName,"JSFU");   }
	if (you.skill30 == 6) { str_cpy(PlaneName,"TQOFTQ"); }
	if (you.skill30 == 7) { str_cpy(PlaneName,"EJNC");   }
	if (you.skill30 == 8) { str_cpy(PlaneName,"TSAS");   }
	if (you.skill30 == 9) { str_cpy(PlaneName,"UFU");    }

	PlaneHealth = 100 - you.health;

	if (PlaneHealth >= 100) { str_cpy (PlaneName,""); }
}

ACTION Spark
{
	if (my == null) { wait (1); }

	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale
	my.myage = 0;
	my.skill41 = 2;

	MY.ENABLE_BLOCK = ON;
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_STUCK = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = SparkHit;

	play_entsound (my,sFire,CONSTGUNFIRE);

	MY.FACING = ON;	// in case of fireball

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

  	// my.near is set by the explosion
	while(MY.NEAR != ON && my != null)
	{
		wait(1); // wait at the loop beginning, to let it appear at the start position

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale

 		move(ME,nullskill,fireball_speed);

		my.myage = my.myage + 1;
	
		if (my.myage > 100) { ShotDie(); }
	}

	}


}

ACTION MeSpark
{

	if (my == null) { wait(1); }

	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale
	my.myage = 0;

	my.skill41 = 1;
	MY.ENABLE_BLOCK = ON;
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_STUCK = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = MeHit;

	play_entsound (my,sFire,CONSTGUNFIRE);

	MY.FACING = ON;	// in case of fireball

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;

	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

  	// my.near is set by the explosion
	while(MY.NEAR != ON && my != null)
	{

		wait(1); // wait at the loop beginning, to let it appear at the start position

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale

		move(ME,nullskill,fireball_speed);

		my.myage = my.myage + 1;
	
		if (my.myage > 100) { ShotDie(); }
	
	}
}

function ShotDie
{
	remove(my);
}

function fire()
{

//	while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
//	{
		// turn towards player
		temp.X = player.X - MY.X;
		temp.Y = player.Y - MY.Y;
		temp.Z = player.Z - MY.Z;
		vec_to_angle(MY_ANGLE,temp);
		force = MY._FORCE * 2;
		actor_turn();

		// watch out if player visible. If yes, then shoot at him
		indicator = _WATCH;
		//SHOOT MY.POS,player.POS;
		trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
		trace(MY.POS,player.POS);

		if((RESULT > 0) && (YOU == player))	// spotted him!
		{
			// fire at player
			// 1) PLAY ATTACK ANIMATION
			// check for new animation format

			if(frc(MY._WALKFRAMES) == 0)
			{
				// reset entity's animation time to zero
				MY._ANIMDIST = 0;

				while(MY._ANIMDIST < 50)
				{
					wait(1);
 					// calculate a percentage out of the animation time
					MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
					// set the frame from the percentage
	  				// -old- SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
					ent_frame(robot_attack_str,MY._ANIMDIST);
				}
			}// END NEW STYLE ATTACK ANIMATION
			//if(FRC(MY._WALKFRAMES) != 0)
			else  // OLD STYLE ATTACK ANIMATION
			{
				// play attack animation
				MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;   // set frame to start
				MY.NEXT_FRAME = 0;	// inbetween to the real next frame
				while(MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES)
				{
 			 		MY.FRAME += 0.4 * TIME;
				}
  				MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;  // end at start frame
			}// END OLD STYLE ATTACK ANIMATION

			// 2) fire shot
			damage = frc(MY._FIREMODE) * 100;
			fire_mode = MY._FIREMODE;
			if((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
			{
				shot_speed.X = 500;
			}
			else
			{
				shot_speed.X = 100;
			}
			shot_speed.Y = 0;
			shot_speed.Z = 0;
			MY_ANGLE.PAN = MY.PAN;	// TILT is already set from TO_ANGLE
			vec_rotate(shot_speed,MY_ANGLE);
			// now shot_speed points ahead

			// check to see if the model is using a muzzle vertice
			if(MY._MUZZLE_VERT == 0)
			{
				// default gun muzzle
				vec_set(gun_muzzle.X,MY.X);
 //				gun_muzzle.X = MY.X;
	//			gun_muzzle.Y = MY.Y;
	  //			gun_muzzle.Z = MY.Z;
			}
			else
			{
				ent_vertex(gun_muzzle.X,MY._MUZZLE_VERT);
			}

			//play_entsound(ME,gun_wham,150);
			gunfire();
			MY._COUNTER -= 1;
			if(frc(MY._WALKFRAMES) == 0)
			{
				// play the second half of the animation
 				while(MY._ANIMDIST < 100)
				{
					wait(1);
 					// calculate a percentage out of the animation time
					MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
					// set the frame from the percentage
	  				// -old- SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
					ent_frame(robot_attack_str,MY._ANIMDIST);
				}
			}// END NEW STYLE ATTACK ANIMATION
		}// END if((RESULT > 0) && (YOU == player))
		else
		{
			MY._COUNTER = 0;
			return(-1);	// can not see player
		}
		waitt(4);	// space shots appart (so they don't hit each other!
//	}// END  while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
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

function particlefade2()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 100;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;

		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 255;
		MY_COLOR.BLUE = 0;

	}
	else
	{
		MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		if(MY_AGE > 50) { MY_ACTION = NULL; }
	}
}


ACTION Airplane
{
	my.event = collide2;

	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;

	my.ambient = 50;
	my.flag1 = on;

	if (my.skill1 == 1) { plane01 = my; }
	if (my.skill1 == 2) { plane02 = my; }
	if (my.skill1 == 3) { plane03 = my; }
	if (my.skill1 == 4) { plane04 = my; }
	if (my.skill1 == 5) { plane05 = my; }
	if (my.skill1 == 6) { plane06 = my; }
	if (my.skill1 == 7) { plane07 = my; }
	if (my.skill1 == 8) { plane08 = my; }
	if (my.skill1 == 9) { plane09 = my; }

	my.skill30 = my.skill1;

	my.speed = random(20)+10;
	
	my.health = 100;

	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	anim_init();
	drop_shadow();

	while(1)
	{
	if (player == null) { return; }

	if (my.skill38 > 0) { my.passable = on; my.skill38 = my.skill38 - 1 * time; } else { my.passable = off; }

	if (snd_playing(my.skill40) == 0) { if (my.health > 50) { play_entsound (my,Engine,CONSTRANGE); } else { play_entsound (my,Dying,CONSTRANGE); } }


	if (my.health > 0)
	{
		SetSkin();

		ent_cycle ("Fly",my.skill41);
		my.skill41 = my.skill41 + 10 * time;

		// calculate a direction to walk into
		temp.X = player.X - MY.X;
		temp.Y = player.Y - MY.Y;
		temp.Z = player.z - my.z;

		vec_to_angle(MY_ANGLE,temp);  // 10/31/00 replace TO_ANGLE

		// turn towards player
		if (my.z > player.z) { my_angle.tilt = 10; }
		if (my.z < player.z) { my_angle.tilt = -10; }

		if (my.y > player.y) { my_angle.roll = 10; }
		if (my.y < player.y) { my_angle.roll = -10; }

		force = 1;
		actor_turn();

		// walk towards him
		force = my.speed;
		MY._MOVEMODE = _MODE_WALKING;
		move_gravity2();

		fire();

		Smoke();
	}
	else { if (my.invisible == off) { Smoke(); } }

	if (my.health <= 0)
	{
			my.tilt = 270;
			my.pan += 10;
			if (my.z > 0) { my.z = my.z - 10; }

			wait (1);
	}
	wait(1);

	}
}

action zepplin
{
	drop_shadow();

	while(1)
	{
		my.x = my.x - 1;
		ent_cycle ("Fly",my.skill1);
		my.skill1 = my.skill1 + 5;
		if (my.skill1 > 1000) { my.skill1 = 0; }
		wait(1);
	}
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.pos_y = 400;
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);
	if (str_cmpi (cheatstring,"sudden death") == 1)
	{ 
		msg.string = "cheat enabled"; 
		show_message(); cheat1 = 1; 
		if (plane01.health > 10) { plane01.health = 10; }
		if (plane02.health > 10) { plane02.health = 10; }
		if (plane03.health > 10) { plane03.health = 10; }
		if (plane04.health > 10) { plane04.health = 10; }
		if (plane05.health > 10) { plane05.health = 10; }
		if (plane06.health > 10) { plane06.health = 10; }
		if (plane07.health > 10) { plane07.health = 10; }
		if (plane08.health > 10) { plane08.health = 10; }
		if (plane09.health > 10) { plane09.health = 10; }
		if (player.health > 10) { player.health = 10; }

		play_sound (CheatSound,100);
	}

	if (str_cmpi (cheatstring,"red baron") == 1) { msg.string = "cheat enabled"; show_message(); cheat2 = 1; play_sound (CheatSound,100); }	
	if (str_cmpi (cheatstring,"i love the smell of grandma in the morning") == 1) { msg.string = "cheat enabled"; show_message(); CreateGenia(); play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

function CreateGenia
{
	if (BBomb != 0)
	{
		BBomb = 0;
		Launch = 0;
		create (<GranFly.mdl>,player.x,Piposh);
		you.scale_x = 0.2;
		you.scale_y = 0.2;
		you.scale_z = 0.2;
		you.flag1 = on;
	}
	else
	{
		msg.string = "Use your existing grandma before asking for another";
		show_message();
	}

}

action Piposh
{
	my.passable = on;
	my.skill21 = 10;
	my.skill22 = 0;

	if (my.flag1 == on) { GeniaX = my.x; GeniaY = my.y; GeniaZ = my.z; }

	while(1)
	{
		if (player == null) { return; }

		if ((my.flag1 == on) && (BBomb == 1)) { BombAway(); }
		else
		{
			if (my.flag1 == on)
			{
				ent_cycle ("Stand",my.skill1);
				my.skill1 = my.skill1 + 20;
			}
			else
			{
				if (int(random(10)) == 5) { ent_cycle ("Stand",int(random(4)) * 33); }
			}

			my.x = player.x;
			my.y = player.y;
			my.z = player.z;
			my.pan = player.pan;
			my.tilt = player.tilt;
			my.roll = player.roll;
		}

		wait(1);
	}
}

action MissileHit
{
	msg.string = "HIT!";
	show_message();
	you.health = 0;
	actor_explode();
}

function BombAway
{
	if (Launch == 0)
	{
		my.z = my.z - 10 * time; 
		my.x = my.x + my.skill21 * time;
		my.skill21 = my.skill21 - 0.3 * time;
		if (my.skill21 < 0) { my.skill21 = 0; }
		my.skill22 = my.skill22 + 1 * time;

		if (my.skill22 > 30) 
		{
			morph (<GranMis.mdl>,my);
			Launch = 1;
			PickTarget();
		}
	}
	else
	{
		MY.ENABLE_ENTITY = ON;
		MY.ENABLE_IMPACT = ON;
		MY.ENABLE_PUSH = ON;
		MY.EVENT = MissileHit;

		my.speed = 0.1;

		while (xtarget.invisible == off)
		{
			if (MisViewEnabled == 1)
			{
				MissileCam.visible = on;
				MissileCam.x = my.x;
				MissileCam.y = my.y;
				MissileCam.z = my.z;
				MissileCam.pan = my.pan;
				MissileCam.tilt = my.tilt;
				MissileCam.roll = my.roll;

				TargetCam.visible = on;
				TargetCam.x = xtarget.x;
				TargetCam.y = xtarget.y;
				TargetCam.z = xtarget.z;
				targetcam.genius = xtarget;

				MisView.visible = on;
			}
			else
			{
				MissileCam.visible = off;
				TargetCam.visible = off;
				MisView.visible = off;
			}

			vec_set(temp,my.x);
			vec_sub(temp,TargetCam.x);
			vec_to_angle(TargetCam.pan,temp);

			vec_set(temp,xtarget.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			force = 1;
			actor_turn();

			force = my.speed;
			MY._MOVEMODE = _MODE_WALKING;
			move_gravity2();

			if (my.skill40 == 0) { play_sound (MLaunch,20); my.skill40 = 1; }

			emit(1,MY.POS,particlefade2); my.skill25 = 0;

			if ((abs(my.x - xtarget.x) < 10) && (abs(my.y - xtarget.y) < 10) && (abs(my.z - xtarget.z) < 10))
			{
				xtarget.health = 0;
				xtarget.invisible = on;
				_gib(100);
				actor_explode();
				TargetCam.visible = off;
				MissileCam.visible = off;
				MisView.visible = off;
			}

			if (xtarget.health == 0) { _gib(20); actor_explode(); }	// Target is lost, explode missile

			WAIT(1);
		}

	}
}

function PickTarget
{

	temp.y = 1;

	while (temp.y == 1)
	{
		temp.x = int(random(9)) + 1;

		if ((temp.x == 1) && (plane01.health > 0)) { xTarget = Plane01; temp.y = 2; }
		if ((temp.x == 2) && (plane02.health > 0)) { xTarget = Plane02; temp.y = 2; }
		if ((temp.x == 3) && (plane03.health > 0)) { xTarget = Plane03; temp.y = 2; }
		if ((temp.x == 4) && (plane04.health > 0)) { xTarget = Plane04; temp.y = 2; }
		if ((temp.x == 5) && (plane05.health > 0)) { xTarget = Plane05; temp.y = 2; }
		if ((temp.x == 6) && (plane06.health > 0)) { xTarget = Plane06; temp.y = 2; }
		if ((temp.x == 7) && (plane07.health > 0)) { xTarget = Plane07; temp.y = 2; }
		if ((temp.x == 8) && (plane08.health > 0)) { xTarget = Plane08; temp.y = 2; }
		if ((temp.x == 9) && (plane09.health > 0)) { xTarget = Plane09; temp.y = 2; }
	}
}

	

function BrachaBomb
{
	BBomb = 0;

	BBomb = plane01.health + plane02.health + plane03.health + plane04.health + plane05.health + plane06.health + plane07.health + plane08.health + plane09.health;
	if (BBomb != 0) { BBomb = 1; } else { BBomb = 0; }
}

function SetSkin
{
	if (my == player) { Base = 5; } else { Base = 1; }
	my.skin = Base;
	if (my.health < 60) { my.skin = Base + 1; }
	if (my.health < 40) { my.skin = Base + 2; }
	if (my.health < 20) { my.skin = Base + 3; }
}

function Smoke
{
	if ((my.health < 50) && (my.z > 0))
	{
		temp = 3 * TIME;
		if(temp > 5) { temp = 5; }
		emit(temp,MY.POS,particlefade); 	// smoke trail
	}
}

function CheckPlanes
{
	PlanesLeft = 9;

	if (plane01.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane02.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane03.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane04.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane05.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane06.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane07.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane08.health <= 0) { PlanesLeft = PlanesLeft - 1; }
	if (plane09.health <= 0) { PlanesLeft = PlanesLeft - 1; }

	if (PlanesLeft <= 0)	
	{
		pDelay = pDelay - 1 * time;
		if (pDelay < 0)
		{
			if (pToTemple.visible == on) { pToTemple.visible = off; } else { pToTemple.visible = on; }
			pDelay = 10;
		}
	}
}

action KipaHit
{
	if ((PlanesLeft <= 0) && (you == player))
	{
		Volcano[1] = 1;
		WriteGameData(0);

		Run ("Temple.exe");
	}
}

action Kipa
{
	my.passable = on;
	my.invisible = on;
	my.event = KipaHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	wait(10);

	while(1)
	{
		if (PlanesLeft <= 0) { my.passable = off; }
		wait(1);
	}
}

action BallHit
{
	if (you == player)
	{
		play_sound (Bonus,100);

		player.health = player.health + 30;
		if (player.health > 100) { player.health = 100; }
		my.skill1 = 0;
	}
	else { you.skill38 = 30; }
}

action Ball
{
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = BallHit;

	my.skill1 = 0;

	while(1)
	{
		my.skill1 = my.skill1 - 1;
		if (my.skill1 < 0)
		{
			my.skill2 = int(random(9)) + 1;

			if (my.skill2 == 1) { my.x = plane01.x; my.y = plane01.y; my.z = plane01.z; }
			if (my.skill2 == 2) { my.x = plane02.x; my.y = plane02.y; my.z = plane02.z; }
			if (my.skill2 == 3) { my.x = plane03.x; my.y = plane03.y; my.z = plane03.z; }
			if (my.skill2 == 4) { my.x = plane04.x; my.y = plane04.y; my.z = plane04.z; }
			if (my.skill2 == 5) { my.x = plane05.x; my.y = plane05.y; my.z = plane05.z; }
			if (my.skill2 == 6) { my.x = plane06.x; my.y = plane06.y; my.z = plane06.z; }
			if (my.skill2 == 7) { my.x = plane07.x; my.y = plane07.y; my.z = plane07.z; }
			if (my.skill2 == 8) { my.x = plane08.x; my.y = plane08.y; my.z = plane08.z; }
			if (my.skill2 == 9) { my.x = plane09.x; my.y = plane09.y; my.z = plane09.z; }

			my.skill1 = 1000;
		}
		
		wait(1);
	}
}

action TheBorder
{
	Border = my;
}

function ToggleMisView
{
	MisViewEnabled = -MisViewEnabled;
}

// Keys
on_F1 = toggleview();
on_F2 = togglepanel();
on_space = null();
on_tab = cheat;
on_v = ToggleMisView();
on_b = BrachaBomb();