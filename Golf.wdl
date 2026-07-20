include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Death = 0;
var angle[3];

var Strikes;
var Hit = 0;
var Winning = 0;

var tempWind;

var See = -200;

var Hitting = 0;
var Power = 0;
var Hit = 0;

var Cheat1;

var Club;

var Prev[3];
var ForceBKP[3];

string cheatstring = "                                                                          ";
string stringtemp = "                          ";

var Pitch = 0;

var Wind;
var AbsWind;

var ArrowEnabled = 0;
var GoalEnabled = 0;

var BallForce = 0;

var Counter = 0;
var Talking = 0;

var Bumped = 0;

var LockPan;
var LockHit = 0;

var Peak = 0;
var Swing = 0;
var Swg = 0;
var CurrentPower = 0;

var GolfFirst = 0;

sound CheatSound = <SFX035.WAV>;

bmap Golf1 = <Golf1.pcx>;
bmap Golf2 = <Golf2.bmp>;
bmap Golf3 = <Golf3.bmp>;
bmap Golf4 = <Golf4.bmp>;
bmap bGlf1 = <Glf1.pcx>;
bmap bGlf2 = <Glf2.pcx>;
bmap bGlf3 = <Glf3.pcx>;
bmap Border = <Karian.bmp>;
bmap clouds = <GolfCLD.pcx>;
bmap Wind1 = <GolfWnd1.pcx>;
bmap Wind2 = <GolfWnd2.pcx>;

view Booth
{
	layer = 3;
	size_x = 200;
	size_y = 200;
	flags = visible;
}

view BallCam
{
	layer = 3;
	size_x = 100;
	size_y = 100;
	Pos_x = 4;
	pos_y = 4;
	flags = visible;
}

synonym GolfBall { type entity; }
synonym GolfFlag { type entity; }

panel GUI 
{
	bmap = Golf1;
	pos_x = 0;
	pos_y = 0;
	layer = 1;
	flags = refresh,d3d,visible,overlay;

	digits 128,95,4,standard_font,1,AbsWind;
	digits 120,30,4,standard_font,1,Strikes;
}

panel pInst
{
	bmap = bGlf1;
	pos_x = 209;
	pos_y = 430;
	flags = refresh,d3d,visible,transparent;
}

panel pWind
{
	pos_x = 117;
	pos_y = 75;
	layer = 2;
	flags = refresh,d3d,visible;
}

panel OnAir
{
	bmap = Border;
	pos_y = 0;
	layer = 1;
	flags = refresh,d3d,visible,overlay;
}

panel Putt
{
	bmap = Golf4;
	pos_x = 18;
	pos_y = 130;
	layer = 2;
	flags = refresh,d3d,visible,overlay;
}

sound Four = <SFX027.WAV>;
sound Hit1 = <SFX030.WAV>;
sound Hit2 = <SFX031.wAV>;
sound WindChange = <SFX032.WAV>;

sound KIV01 = <KIV015.WAV>;
sound KIV02 = <KIV016.WAV>;
sound KIV03 = <KIV017.WAV>;
sound KIV04 = <KIV018.WAV>;
sound KIV05 = <KIV019.WAV>;
sound KIV06 = <KIV020.WAV>;

var KIV = 0;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _OLYMPIC;

	warn_level = 0;	// announce bad texture sizes and bad wdl code
	tex_share = on;	// map entities share their textures
	camera_dist = 40;

	level_load("Golf.wmb");

	lensflare_start();

	Club = 2;
	pInst.bmap = bGlf1;
	Putt.bmap = Golf4;
	Strikes = 12;
	Power = 0;
	Hit = 0;
	Hitting = 0;
	Cheat1 = 0;
	GoalEnabled = 0;
	See = -200;

	VoiceInit();
	Initialize();

	if (GolfFirst == 0)
	{
		sPlay ("wait.wav");
		while (GetPosition (Voice) < 1000000) { wait(1); }
		sPlay ("OLY006.WAV");
		Talking = 10;
		GolfFirst = 1;
		while (GetPosition (Voice) < 1000000) { wait(1); }
		Talking = 0;
	}
}

function SetSee { See = -See; }

action Cam
{
	wait(1);

	SetWind();

	if (GolfBall == null) { wait(1); }

	while(1)
	{
		if (Cheat1 == 0)
		{
			if (int(random(200)) == 100) { play_sound (windchange,30); SetWind(); }
		}

		AbsWind = abs(wind);

		if (BallForce == 0)
		{
			my.x = GolfBall.x;
			my.y = GolfBall.y + See;
			my.z = GolfBall.z + 100;
		}

		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;

		if (Hitting == 2)
		{
			vec_set(temp,GolfBall.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
		}

		else { camera.roll = my.roll; }

		wait(1);

		while (Talking == 1) { if (GetPosition(Voice) >= 1000000) { Talking = 0; } wait(1); }
	}
}

function SetWind
{
	Wind = int(random(11)) - 5;

	pWind.visible = on;
	if (Wind < 0) { pWind.bmap = Wind2; }
	if (Wind > 0) { pWind.bmap = Wind1; }
	if (Wind == 0) { pWind.visible = off; }
}


action bounce_event
{
	to_angle angle,bounce;
	my.pan = angle.pan;
	my.tilt = angle.tilt;
}

action Ball
{
	if (player == null) { wait(1); }

	GolfBall = my;

	my.__slopes = on;
//	my.event = bounce_event;
//	my.enable_block = on;
//	my.enable_entity = on;
	BallForce = 0;

	while(1)
	{
		BallCam.x = my.x;
		BallCam.y = my.y - 50;
		BallCam.z = my.z + 20;
		BallCam.pan = 90;

		if (BallForce == 0)
		{
			my.pan = player.pan + 90;
			my.tilt = 0;
			my.roll = 0;
		}

		if (BallForce > 0) { GolfBallMove(); }

		wait(1);
	}
}

function ToggleLock { if (LockHit == 1) { LockHit = 0; } else { LockHit = 1; LockPan = player.pan; } }

action Piposh
{
	player = my;
	Death = 0;

	if (GolfBall == null) { wait(1); }

	while (Talking == 10) { wait(1); }

	while(1)
	{
		if (BallForce == 0)
		{
			if ((Strikes <= 0) && (Winning == 0)) 
			{ 
				if (Death == 0)	// Game Over
				{
					Death = 1;
					ShowRIP(); 
				}
			}	
			my.x = GolfBall.x;
			my.y = GolfBall.y;
			my.z = GolfBall.z + 55;
		}

		if (Hitting == 0)
		{
			ent_frame ("Stand",0);
			camera.pan = camera.pan - mickey.x / 3;
			camera.tilt = camera.tilt - mickey.y / 3;
		}

		if (Hitting == 1)
		{
			my.pan = my.pan - mickey.x;

			if (mouse_force.y == 0)
			{ 
				Counter = Counter + 1; 
				
				if (Counter > 20) 
				{
					Counter = 0;
					Peak = 0;
					Swing = 0;
					Swg = 0; 
				} 
			} 
			else { COunter = 0; }

			if ((mouse_force.y > 0) && (LockHit == 1))
			{ 
				if (CurrentPower < 100) 
				{ 
					CurrentPower = CurrentPower + 5; 
					Peak = CurrentPower;
					Swing = 0;
					Swg = 0;
				} 
			}

			if ((mouse_force.y < 0) && (LockHit == 1))
			{
				if (CurrentPower > 10)
				{
					CurrentPower = CurrentPower - 10;
					Swg = Swg - 10;
					Swing = abs(Swg);
				}

				else
				{
					if ((Peak > 0) && (Swing > 0))
					{
						play_entsound (my,Four,1000);
						Bumped = 0;

						Strikes = Strikes - 1;

						BallForce = ((Peak * Swing) * (Club + 1)) / 10;

						Pitch = ((Peak * Swing) * Club) * 50;

						force.x = BallForce;
						tempWind = Wind;
						force.Z = Pitch;

						Hitting = 2;
					}
				}

			}

			ent_frame ("Power",CurrentPower);
		}

		if (Hitting == 2) { ent_frame ("Hit",(BallForce/20)); }

		if (LockHit == 1) { my.pan = LockPan; }
	
		wait(1);
	}
}

function SetHitting
{
	if (Talking == 10) { return; }

	if (Hitting == 0) { Hitting = 1; LockHit = 0; pInst.bmap = bGlf2; return; }
	if ((Hitting == 1) && (LockHit == 0)) { LockHit = 1; LockPan = player.pan; pInst.bmap = bGlf3; return; }
	if ((Hitting == 1) && (LockHit == 1)) { Hitting = 0; pInst.bmap = bGlf1; return; }
}

function GolfBallMove()
{
	my._movemode = _mode_driving;

	// find ground below
	scan_floor();
	BallGravity();
	actor_anim();
}

function BallGravity()
{
	// Filter the forces and frictions dependent on the state of the actor,
	// and then apply them, and move him

	// First, decide whether the actor is standing on the floor or not
	if(my_height < 5)
	{
		friction = gnd_fric;
		if(MY._MOVEMODE == _MODE_DRIVING)
		{
			// Driving - less friction, less force
			friction *= 0.3;
			force.X *= 0.3;
		}

		force.Y = tempWind;

		if (tempWind < 0) { tempWind = tempWind + 1; }
		if (tempWind > 0) { tempWind = tempWind - 1; }

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
			MY._JUMPTARGET = jump_height - my_height;	// calculate jump delta

			// ...switch to jumping mode
			MY._MOVEMODE = _MODE_JUMPING;
			MY._ANIMDIST = 0;
		}

		// If the actor is standing on a moving platform, add it's horizontal displacement
		absdist.X += my_floorspeed.X;
		absdist.Y += my_floorspeed.Y;
	}

	// if we are still 'jumping'
	if(MY._JUMPTARGET > 0)
	{
		// calculate velocity

		// predict the current speed required to reach the jump height
 		MY._SPEED_Z = sqrt((MY._JUMPTARGET)*2*gravity);

		// scale distance from jump (absdist.z) by movement_scale
		absdist.z = MY._SPEED_Z * TIME * movement_scale;
		MY._JUMPTARGET -= absdist.z;
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
	move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
	result = ent_move(dist,absdist);
	if(result > 0)
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
}

action ArrowX
{
	my.invisible = on;
	my.passable = on;

	while(1)
	{
		if (ArrowEnabled == 1) { my.invisible = off; } else { my.invisible = on; }

		if (BallForce > 0)
		{
			if ((my.x == Prev.x) && (my.y == Prev.y)) 
			{ 
				Counter = Counter + 1;
				
				if (Counter > 10)
				{
					BallForce = 0; 
					Swing = 0;
					Swg = 0; 
					Peak = 0; 
					CurrentPower = 0; 
					Hitting = 0;
					pInst.bmap = bGlf1;
				}
			}
			else { Counter = 0; }

			Prev.x = my.x;
			Prev.y = my.y;
			Prev.Z = my.z;

			my.x = GolfBall.x;
			my.y = GolfBall.y;
			my.z = GolfBall.z + 50;
			ent_cycle ("Frame",my.skill1);
			my.skill1 = my.skill1 + 3;
			my.pan = my.pan + 10;

		}

		wait(1);
	}
}

action Fan
{
	while(1) { my.tilt = my.tilt + (5 * wind) * time; wait(1); }
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

		ForceBKP.x = force.x;
		ForceBKP.y = force.y;
		ForceBKP.z = force.z;

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		force = 1;
		actor_turnto(my_angle.PAN);

		force = 3;
		actor_move();

		force.x = ForceBKP.x;
		force.y = ForceBKP.y;
		force.z = ForceBKP.z;

		my.z = my.skill20;

		ent_cycle ("Walk",my.skill30);
		my.skill30 = my.skill30 + 20;

		wait(1);
	}
}

function ToggleClub
{
	if (Talking == 10) { return; }

	Club = Club - 1;
	if (Club < 0) { Club = 2; }

	if (Club == 0) { Putt.bmap = Golf2; }
	if (Club == 1) { Putt.bmap = Golf3; }
	if (Club == 2) { Putt.bmap = Golf4; }

}

function ToggleArrow
{
	if (ArrowEnabled == 0) { ArrowEnabled = 1; } else { ArrowEnabled = 0; }
}

function ToggleGoal
{
	if (GoalEnabled == 0) { GoalEnabled = 1; } else { GoalEnabled = 0; }
}

on_mouse_left = SetHitting();
on_F1 = SetSee;
on_F2 = toggleArrow();
on_F3 = ToggleClub();

action SinkHole
{
	Winning = 1;

	if (my.skill40 == 0) { sPlay ("SFX029.WAV"); my.skill40 = 1; }
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Olympic[3] = 1;
	Piece[3] = 1;	// Got a vase piece!
	WriteGameData(0);

	Run ("Intro10.exe");
}

action Hole
{
	my.event = SinkHole;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
}

action Flag
{
	GolfFlag = my;
	my.skill4 = my.pan;

	while(1)
	{
		if (Wind > 0) { my.pan = 90; }
		if (Wind < 0) { my.pan = -90; }

		ent_cycle ("Wind",my.skill1);
		my.skill1 = my.skill1 + abs(5 * wind) * time;

		if (Wind == 0) { ent_frame ("NoWind",0); }

		wait(1);
	}
}

action Goal
{

	if (GolfFlag == null) { wait(1); }
	if (GolfBall == null) { wait(1); }

	while(1)
	{
		my.x = GolfBall.x;
		my.y = GolfBall.y;
		my.z = GolfBall.z + 150;

		if (GoalEnabled == 1) { my.invisible = off; } else { my.invisible = on; }
		if (Strikes == 12) { my.invisible = off; }

		vec_set(temp,GolfFlag.x);
		vec_sub(temp,my.x);
		vec_to_angle(my.pan,temp);
		
		wait(1);
	}
}

action Obstacle
{
	Force = 0;

	if (Bumped == 0) { if (int(random(2)) == 1) { play_entsound (my,hit1,1000); } else { play_entsound (my,hit2,1000); } Bumped = 1; }
}

action Wall
{
	my.event = Obstacle;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
}

action Tree
{
	my.event = Obstacle;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;

	my.pan = random(360);
	my.z = my.z - 10;
}

action Kiviti
{
	Booth.pos_x = screen_size.x - 210;
	booth.pos_y = 10;
	OnAir.pos_x = screen_size.x - 220;

	while(1)
	{
		if ((int(random(300)) == 150) && (snd_playing (KIV) == 0) && (Talking != 10))
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

		if (Talking == 10)
		{
			Booth.x = my.x - 40;
			Booth.y = my.y + 130;
			Booth.z = my.z + 100;
			Booth.pan = 270;
			Booth.tilt = -20;
			Talk();
		}

		wait(1);
	}
}

action Cam2
{
	while(1)
	{
		if (Talking != 10)
		{
			booth.x = my.x;
			booth.y = my.y;
			booth.z = my.z;
			booth.pan = my.pan;
			booth.tilt = my.tilt;
			booth.roll = my.roll;
		}

		wait(1);
	}
}

action Gidi
{
	my.skill1 = 60;

	while(1)
	{
		if (Talking == 2) { ent_frame ("Drum",60); } else { if (int(random(40)) == 20) { ent_frame ("Stand",int(random(4)) * 33.3); } }
		my.skill1 = my.skill1 - 1 * time;
		if ((my.skill1 < 0) && (my.skill1 > -200)) { my.x = my.x - 20 * time; }
		wait(1);
	}
}

action Staff
{
	my.skill1 = my.x;
	my.skill2 = my.y;
	my.x = my.x - 100;
	my.skill3 = my.x;
	my.y = my.y - 20;

	while(my.x < my.skill1) { my.x = my.x + 2 * time; wait(1); }
	while(my.y < my.skill2) { my.y = my.y + 2 * time; wait(1); }
	while(my.x > my.skill3) { my.x = my.x - 20 * time; wait(1); }
}

action Ad
{
	my.skin = int(random(7)) + 1;
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
	while (Talking == 10)
	{
		my.x = my.x + 90 * time;
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.roll = my.roll;
		camera.tilt = my.tilt;
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
	if (str_cmpi (cheatstring,"show me the hole") == 1) { msg.string = "cheat enabled"; show_message(); toggleGoal(); play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"wind shield") == 1) { msg.string = "cheat enabled"; show_message(); Cheat1 = 1; Wind = 0; play_sound (CheatSound,100); }
	if (str_cmpi (cheatstring,"one more chance") == 1) { msg.string = "cheat enabled"; show_message(); Strikes = Strikes + 1; play_sound (CheatSound,100); }
	str_cpy (cheatstring,"");
}

on_tab = cheat();
