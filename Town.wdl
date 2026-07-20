include <IO.wdl>;

sound Laugh = <Laugh.wav>;

var JokeID = 0;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Building = 0;
var TheY;
var VView = 1;
var Opening = 0;
var C;
var Zoom;
var Jump = 0;
var KorN;
var Zoom2;
var RANGE = 150;

var Seen1 = 0;
var Seen2 = 0;

bmap BIO = <BIO.pcx>;

define LightState,skill20;
define LightDelay,skill21;

synonym Boat { type entity; }
synonym Arow { type entity; }
synonym Mutilate { type entity; }
synonym Beam { type entity; }

panel GUI 
{
	bmap = BIO;
	pos_x = 0;
	pos_y = 0;
	layer = -1;
	flags = refresh,d3d,visible,overlay;

 	digits 60,455,2,digit_font,1,Zoom;
}

sound Honk1 = <SFX007.wav>;
sound Honk2 = <SFX008.wav>;
sound Honk3 = <SFX009.wav>;
sound Moo = <SFX099.WAV>;
sound Piza = <SFX110.WAV>;
sound FogHorn = <SFX049.WAV>;
sound sBeam = <SFX111.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _TOWN;

	warn_level = 0;
	tex_share = on;
	camera.arc = 60;
	mouse_range = 8000;

	load_level(<Town.WMB>);
	lensflare_start();

	VoiceInit();
	Initialize();

	gfx_init();
	_fitp = GUI; fit();

	scene_map = bmapBack1;
}

action RandomBuilding
{
	Building = int(random(10)) + 1;
	if (Building == 1) { morph (<House1.mdl>,my); }
	if (Building == 2) { morph (<House2.mdl>,my); }
	if (Building == 3) { morph (<House3.mdl>,my); }
	if (Building == 4) { morph (<House4.mdl>,my); }
	if (Building == 5) { morph (<House5.mdl>,my); }
	if (Building == 6) { morph (<House6.mdl>,my); }
	if (Building == 7) { morph (<House7.mdl>,my); }
	if (Building == 8) { morph (<House8.mdl>,my); }
	if (Building == 9) { morph (<House9.mdl>,my); }
	if (Building == 10) { morph (<House10.mdl>,my); }

	Building = int(random(4)) + 1;
	if (Building == 1) { my.pan = 0; } 
	if (Building == 2) { my.pan = 90; }
	if (Building == 3) { my.pan = 180; }
	if (Building == 4) { my.pan = 270; }

	wait(1);
}

action Intersection
{
	my.lightrange = 30;
	my.lightstate = 0;
	my.skill8 = random(5) + 1;

	my.lightstate = int(random(5)) + 1;

	my.lightdelay = -1;

	while (0)
	{
		my.lightdelay = my.lightdelay - 1;
		if (my.lightdelay < 0) { my.lightdelay = 100 * my.skill8; my.lightstate = my.lightstate + 1; if ((my.lightstate > 5) || (my.lightstate == 3)) { 		my.lightdelay = 300 * my.skill8; } }
		if (my.lightstate > 5) { my.lightstate = 1; }

		if (my.lightstate == 1)	// red light
		{
			my.lightred = 255;
			my.lightgreen = 0;
			my.lightblue = 0;
		}

		if ((my.lightstate == 2) || (my.lightstate == 5)) // yellow light
		{
			my.lightred = 255;
			my.lightgreen = 255;
			my.lightblue = 0;
		}

		if (my.lightstate == 3)	// green light
		{
			my.lightred = 0;
			my.lightgreen = 255;
			my.lightblue = 0;
		}
		
		if (my.lightstate == 4)	// flashing green light
		{
			my.lightred = 0;
			my.lightgreen = 255;
			my.lightblue = 0;
			if (my.skill23 == 0) { my.lightgreen = 0; } else { my.lightgreen = 255; }
			my.skill24 = my.skill24 + 1;
			if (my.skill24 > 10)
			{
				my.skill24 = 0;
				if (my.skill23 == 0) { my.skill23 = 1; } else { my.skill23 = 0; }
			}
		}
	wait(1);
	}
		
}

action SportCar
{

	my.scale_x = 0.25;
	my.scale_y = 0.25;
	my.scale_z = 0.25;

	my.lightred = random(255);
	my.lightblue = random(255);
	my.lightgreen = random(255);

	my.passable = on;
	actor_init();

	my.skill1 = random(3) + 1;

	TheY = int(random(4)) + 1;
	if (TheY == 1) { ent_path ("path_001"); }
	if (TheY == 2) { ent_path ("path_002"); }
	if (TheY == 3) { ent_path ("path_003"); }
	if (TheY == 4) { ent_path ("path_004"); }

//	my.invisible = on;

// attach next path
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

// find first waypoint
	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (int(random(100)) == 50)
		{
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,honk1,RANGE); }
			if (my.skill40 == 2) { play_entsound (my,honk2,RANGE); }
			if (my.skill40 == 3) { play_entsound (my,honk3,RANGE); }
		}

	// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		force = my.skill1;

// near target? Find next waypoint
// compare radius must exceed the turning cycle!
		if (result < 25) { ent_nextpoint(my._TARGET_X); }

// turn and walk towards target
		actor_turnto(my_angle.PAN);
		actor_move2();

// Wait one tick, then repeat
		wait(1);
	}
}

action GoToTaxi
{
	Run ("Taxi.exe");
}

action Taxi
{
	my.enable_click = on;
	my.event = GoToTaxi;
}

action ShipHit
{
	Opening = my.skill1;
}

action PatrolCity
{
	wait(1);

	if (my.skill20 == 1)
	{
		my.event = GoToTaxi;
		my.enable_click = on;
	}

	my.passable = on;
	actor_init();

	if (my.skill7 == 1) { Boat = my; }

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (my.flag8 == on) { if (int(random(200)) == 100) { play_entsound (my,foghorn,RANGE); } }

		if (int(random(100)) == 50)
		{
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,honk1,RANGE); }
			if (my.skill40 == 2) { play_entsound (my,honk2,RANGE); }
			if (my.skill40 == 3) { play_entsound (my,honk3,RANGE); }
		}


	if (my.skill20 == 1) { arow.x = my.x; arow.y = my.y; }

	if (my == boat) { ent_cycle ("Frame",my.skill30); my.skill30 = my.skill30 + 10 * time; }

		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); my.invisible = off; if (my == boat) { C = C + 1; } }

		if (my == boat) { if (C > 31) { C = 0; } }
		
		if (C == 17) { Opening = 1; } else { Opening = 0; }

		if (my == boat) { force = 0.8; } else { force = my.skill1; }

		actor_turnto(my_angle.PAN);
		actor_move2();

		wait(1);
	}
}

function actor_move2()
{
	force.Y = 0;
	force.Z = 0;

	// find ground below
	move_gravity2();
	actor_anim();
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

	}

	// accelerate the entity relative speed by the force
	// -old method- ACCEL	speed,force,friction;
 	// replaced min with max (to eliminate 'creep')
	temp = max((1-TIME*friction),0);
	MY._SPEED_X = (TIME * force.x) + (temp * MY._SPEED_X);    // vx = ax*dt + max(1-f*dt,0) * vx
	MY._SPEED_Y = (TIME * force.y) + (temp * MY._SPEED_Y);    // vy = ay*dt + max(1-f*dt,0) * vy
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

action MakeCars
{
	my.skill1 = 300;
	my.skill2 = 20;
	while (my.skill2 > 0)
	{
		my.skill1 = my.skill1 - 1;
		if (my.skill1 < 0)
		{ 
			my.skill1 = 300;
			my.skill2 = my.skill2 - 1;

			temp = int(random(30));

			if (temp < 10) { create (<TownCar.mdl>,my.x,SportCar); }
			if ((temp >= 10) && (temp < 13)) { create (<CityOil.mdl>,my.x,SportCar); }
			if ((temp >= 13) && (temp < 16)) { create (<CityJeep.mdl>,my.x,SportCar); }
			if ((temp >= 16) && (temp < 20)) { create (<Bus3.mdl>,my.x,SportCar); }
			if ((temp > 20) && (temp <= 25)) { create (<BusiCar.mdl>,my.x,SportCar); }
			if (temp > 25) { create (<TownVesp.mdl>,my.x,SportCar); }
		}
	wait(1);
	}
}

action DrawBridge
{

	if (Boat == null) { wait(1); }
	my.skill1 = 0;

	wait(1);

	while(1)
	{
		if (Opening == 1)
		{
			ent_frame ("Opened",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
			if (my.skill1 > 100) { my.skill1 = 100; }
		}
		else
		{
			if (my.skill1 > 0) { ent_frame ("Opened",my.skill1); my.skill1 = my.skill1 - 5 * time; } else { ent_frame ("Closed",0); }
		}

	wait(1);

	}
}

action Ship
{
	my.event = ShipHit;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
}

action GoToInn
{
	Run ("Inn.exe");
}

action Inn
{
	my.event = GoToInn;
	my.enable_click = on;
}

action GoToMOI
{
	Run ("MOI.exe");
}

action MOI
{
	my.event = GoToMOI;
	my.enable_click = on;
}

action GoToTravel
{
	Run ("Travel.exe");
}

action Travel
{
	my.event = GoToTravel;
	my.enable_click = on;
}

action GoToDesert
{
	ReturnToMap();
}

action Cam
{
	while (1)
	{
		Zoom = ((60 - camera.arc) / 4) + 1;
		if (Zoom > 14) { Zoom = 14; }

		_player_intentions();

		if (key_force.y > 0) { zoomin(); }
		if (key_force.y < 0) { zoomout(); }

		if ((Vview == my.skill1) && (mouse_mode == 0))
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			my.pan = my.pan - mickey.x / 5;
			my.tilt = my.tilt - mickey.y / 5;

			if (my.tilt > 45) { my.tilt = 45; }
			if (my.tilt < -45) { my.tilt = -45; }

			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}

		wait(1);

	}		
}

function ToggleView
{
	if (Vview == 1) { VView = 2; } else { VView = 1; }
}

function ZoomIn
{
	if (camera.arc > 0) { camera.arc = camera.arc - 1; }
}

function ZoomOut
{
	if (camera.arc < 60) { camera.arc = camera.arc + 1; }
}

on_v = toggleview();

action Water
{
	my.skill1 = 0;
	my.skill2 = 1;

	while (1)
	{
		my.skill1 = my.skill1 + 1 * time;

		if (my.skill2 == 1) { my.z = my.z + 1 * time; }
		if (my.skill2 == 2) { my.z = my.z - 1 * time; }

		if (my.skill1 > 20) { my.skill2 = my.skill2 + 1; my.skill1 = 0; }

		if (my.skill2 == 3) { my.skill2 = 1; }

		wait(1);
	}
}

action tArrow
{
	arow = my;
}

action Fall
{
	Jump = 1;
}

action Tall
{
	my.event = Fall;
	my.enable_click = on;
}

action Arrow1
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 5 * time;

		if (Seen1 == 1) { my.invisible = on; }
		wait(1);
	}
}

action Arrow2
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 5 * time;

		if (Seen2 == 1) { my.invisible = on; }
		wait(1);
	}
}

action Falling
{
	my.invisible = on;
	my.skill1 = 0;
	
	while(1)
	{
		if (Jump == 1)
		{
			Seen1 = 1;
			if (my.skill20 == 0) { sPlay ("MSC008.WAV"); my.skill20 = 1; }

			if (my.skill1 < 87)
			{
				my.invisible = off;
				my.z = my.z - 10 * time;
				my.skill1 = my.skill1 + 1 * time;
				ent_cycle ("Frame",my.z);
			}
			else { ent_frame ("Dead",0); }
		}

		wait(1);
	}
}

action UFO
{
	wait(1);

	Beam.invisible = on;

	waitt(1000);

	while(1)
	{
		my.pan = my.pan + 10 * time;

		if (my.x < Beam.x)
		{
			Beam.invisible = on;
			my.x = my.x + 20 * time;
		}

		else
		{
			if (my.skill40 == 0) { play_entsound (my,sbeam,range); my.skill40 = 1; }
			Beam.invisible = off;
			Mutilate.z = Mutilate.z + 5 * time;
		}

		if (Mutilate.z > my.z)
		{
			Mutilate.invisible = on;
			Beam.invisible = on;
			my.x = my.x + 20 * time;
		}

		wait(1);
	}
}

action Cow
{
	Mutilate = my;
	my.skill1 = my.z;

	while(1)
	{
		if (my.z == my.skill1) { ent_cycle ("Frame",my.skill2); my.skill2 = my.skill2 + 5 * time; } else { ent_cycle ("Beam",my.skill2); my.skill2 = my.skill2 + 20 * time; }
		wait(1);
	}
}

action Cow2
{
	my.skill10 = random (10);
	while(1)
	{
		if (int(random(100)) == 50) { play_entsound (my,moo,RANGE); }
		ent_cycle ("Frame",my.skill2); my.skill2 = my.skill2 + my.skill10 * time;
		wait(1);
	}
}

action TheBeam
{
	Beam = my;
}

action Sub
{
	my.skill1 = my.z;
	my.z = my.z - 200;
	my.skill2 = my.z;

	while(1)
	{
		if (my.skill3 == 0) { my.z = my.z + 1 * time; }
		if (my.z >= my.skill1) { my.skill3 = my.skill3 + 1 * time; }
		if (my.skill3 > 50) { my.z = my.z - 1 * time; }
		if (my.z <= my.skill2) { my.skill3 = 0; }

		wait(1);
	}
}

action PisaFall
{
	my.shadow = off;
	Seen2 = 1;
	play_entsound (my,piza,2000);
	if (my.skill1 == 0) { while (my.skill1 < 100) { ent_frame ("Frame",my.skill1); my.skill1 = my.skill1 + 2 * time; wait(1); } }
}

action Pisa
{
	my.enable_click = on;
	my.event = PisaFall;
}

action MakeJoke
{
	if (Vplaying == 0) { Joke(0); }
}

action Kazale
{
	my.event = MakeJoke;
	my.enable_click = on;

	while(1)
	{
		if ((vTalking == 0) || ((JokeID == 1) && (Vplaying == 19)))
		{ 
			ent_cycle ("Stand",my.skill1); 
		}
		else
		{
			if (vTalking == 1) { ent_cycle ("Ntalk",my.skill1); }
			if (vTalking == 2) { ent_cycle ("Ktalk",my.skill1); }
		}

		Zoom2 = Zoom * 3;

		if (JokeID == 1)  { if (VPlaying > 22) { VTalking = 0; play_sound (Laugh,100); JokeID = -1; Vplaying = 0; } }
		if (JokeID == 2)  { if (VPlaying > 4) { VTalking = 0; play_sound (Laugh,100); JokeID = -1; Vplaying = 0; } }
		if (JokeID == 3)  { if (vPlaying > 5) { VTalking = 0; play_sound (Laugh,100); JokeID = -1; Vplaying = 0; } }
		if (JokeID == 0)  { if (VPlaying > 3) { Vtalking = 0; play_sound (Laugh,100); JokeID = -1; Vplaying = 0; } }
		if (JokeID == 99) { if (VPlaying > 3) { Vtalking = 0; JokeID = -1; Vplaying = 0; } }
		if (JokeID == 98) { if (VPlaying > 4) { VTalking = 0; play_sound (Laugh,100); JokeID = -1; Vplaying = 0; } }

		my.skill1 = my.skill1 + 30 * time;

		wait(1);
	}
}