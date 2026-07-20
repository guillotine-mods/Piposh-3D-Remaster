// Template file v5.115 (07/27/01)
////////////////////////////////////////////////////////////////////////
// File: war2.wdl
//		WDL prefabs for 'Advanced' hostile entities
////////////////////////////////////////////////////////////////////////
// Use:
//		Include AFTER "war.wdl"
//
// Created: 06/11/01 DCP
//
//



// Desc: example on how to use the w2_patrol_bot()
ACTION	w2_demo_pbot
{
	// moves faster than normal
	MY._FORCE = 1.2;

	// shoots 'fireballs'
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.20;

	// 'normal' death
	MY._HITMODE = 0;

	// 'normal' walking sound
	MY._WALKSOUND = _SOUND_WALKER;


	// attach shadow
	drop_shadow();

	// start patrol bot behavior
	w2_patrol_bot();
}


// Desc: Stand and guard the location stored in ????
function _w2_state_guard_pos()
{
	wait(1);
}

// Desc: 'bot' state, patrol an A5 path
function	_w2_state_patrol_path()
{
   // scan for path
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	// find first waypoint
	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE == _MODE_WALKING)
	{
		// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		force = MY._FORCE;

		// near target? Find next waypoint
		// compare radius must exceed the turning cycle!
		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		// turn and walk towards target
		actor_turnto(my_angle.PAN);
		actor_move();

		// Wait one tick, then repeat
		wait(1);
	}
}

// Desc: follows a path and attacks enemy if spotted
function	w2_patrol_bot()
{
	// set defaults
	if(MY._HEALTH == 0) { MY._HEALTH = 100; }	// default health
	if(MY._FORCE == 0) { MY._FORCE = 1; }       // default force
 	if(MY._FORCE == 0) {  MY._FORCE = 1; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }


	actor_init();

	_w2_state_patrol_path();     // patrol a path

	// Allow player to pass thru actor if frozen
	if(freeze_actors > 1) { MY.PASSABLE = ON; }

	MY._SIGNAL = 0;
	MY.ENABLE_SCAN = ON;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_DETECT = ON;
	MY.EVENT = fight_event;

	state_wait();
}