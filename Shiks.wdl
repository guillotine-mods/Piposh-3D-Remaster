include <IO.wdl>;

synonym Shik { type entity; }
synonym Piposh { type entity; }
synonym piposh2x { type entity; }

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Ztemp = 0;
var Scene = 1;
var CamShow = 1;
var A[3] = 0,0,0;
var B[3] = 0,0,0;
var XX = 0;
var Photo = 0;

synonym synVase { type entity; }

sound Lake = <SFX100.WAV>;
sound BusS = <SFX101.WAV>;
sound Mapal = <SFX140.WAV>;
var MPL;
var StandHerePoint;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	load_level(<Shiks.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack3;
}

action Watrfall
{
	while(1)
	{
		if (snd_playing(MPL) == 0) { play_entsound (my,Mapal,100); MPL = result; }

		my.v = my.v - 10 * time;
		wait(1);
	}
}

action WaterWheel
{
	while(1)
	{
		if (snd_playing (my.skill40) == 0) { play_sound (Lake,50); my.skill40 = result; }

		my.roll = my.roll + 5;
		wait(1);
	}
}

action Vase
{
	synVase = my;
}

action Dummy { XX = my.x; }

action Dome { my.skin = 1; while (1) { my.pan = my.pan + 0.2 * time; wait(1); } }

action MyCamera
{
	my.skill1 = 0;
	
	while(1)
	{
		if (CamShow == 1)
		{
			if (Piposh.skill2 == 1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.pan = my.pan;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
			}
		
			if (Piposh.skill2 == 2) 
			{
				my._movemode = 1;
				temp.pan = 360;
				temp.tilt = 180;
				temp.z = 1000;
				result = scan_path(my.x,temp);
				if (result == 0) { my._MOVEMODE = 0; }	// no path found

				// find first waypoint
				ent_waypoint(my._TARGET_X,1);

				while ((my._MOVEMODE > 0) && (my.skill1 < 7))
				{
					HideText();	// Fixed: Hide while flying through
					Dialog.visible = off;

					temp.x = MY._TARGET_X - MY.X;
					temp.y = MY._TARGET_Y - MY.Y;
					temp.z = 0;
					result = vec_to_angle(my_angle,temp);

					if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill1 = my.skill1 + 1; }

					force = 2;
					actor_turnto(my_angle.PAN);
					force = 2;	// Fixed: too fast in weak mode
					actor_move(); 

					my.z = Ztemp;
					my.tilt = 0;

					camera.x = my.x;
					camera.y = my.y;
					camera.z = my.z;
					camera.pan = my.pan;
					camera.tilt = my.tilt;
					camera.roll = my.roll;
			
					wait(1);

				}
			
				if (my.skill1 >= 7) { Piposh.skill2 = 4; DialogIndex = 2; ShowDialog(); }
			}
		}

		wait(1);
	}
}

action InstCam
{
	while(1)
	{
		if (CamShow == 2)
		{
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

action PipiCam
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
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

action Inst
{
	ent_frame ("Stand",0);

	while(1)
	{
		if (Talking == 3) { Talk(); } else { if (CamShow == 2) { ent_frame ("Arrive",0); } }
		wait(1);
	}
}

action Leaf
{
	while(1)
	{
		my.x = my.x + int(random(3)) - 1;
		my.y = my.y + int(random(3)) - 1;
		my.pan = my.pan + (int(random(3)) - 1) * 5 * time;
		wait(1);
	}
}

action Bumped
{
	on_space = FF;
	Piposh.skill2 = 2;
}

action StandHere
{
	StandHerePoint = my.x;
}

action Piposh2
{
	Piposh = my;
	my.skill2 = 1;
	my.skill3 = 0;

	sPlay ("SHK003.WAV");

	while(1)
	{
		if (Scene == 1)
		{
			HideText();
			Dialog.visible = off;
			force = 2;
			my.skill1 = my.skill1 + 5 * time;
			ent_cycle ("Walk",my.skill1);
			actor_move();
			if (my.x > StandHerePoint) { ent_frame ("Stand",0); Scene = 2; DialogIndex = 1; ShowDialog(); }
		}

		if (Scene == 2)
		{
			while (Dialog.visible == on) { Talking = 0; Blink(); wait(1); }

			if (DialogIndex == 1)
			{
				if (DialogChoice == 1) { sPlay ("PIP012.WAV"); }
				if (DialogChoice == 2) { sPlay ("PIP013.WAV"); }
				if (DialogChoice == 3) { sPlay ("PIP016.WAV"); }
			}

			if (DialogIndex == 2)
			{
				Talking = 1;

				if (DialogChoice == 1) { sPlay ("PIP017.WAV"); }
				if (DialogChoice == 2) { sPlay ("PIP019.WAV"); }
				if (DialogChoice == 3) { sPlay ("PIP021.WAV"); }
			}

			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

			if (DialogIndex == 1)
			{
				if (DialogChoice == 1) { sPlay ("SHK004.WAV"); }
				if (DialogChoice == 2) 
				{ 
					sPlay ("SHK005.WAV");
					while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
					sPlay ("PIP014.WAV"); 
					while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } 
					sPlay ("SHK006.WAV"); 
					while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
					sPlay ("PIP015.WAV"); 
					while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } 
				}

				if (DialogChoice == 3) { on_space = null; sPlay ("SHK007.WAV"); my.skill20 = 1; }
			}

			if (DialogIndex == 2)
			{
				if (DialogChoice == 1) 
				{ 
					Talking = 2; sPlay ("SHK010.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
					Talking = 1; sPlay ("PIP018.WAV"); while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } 
					Talking = 2; sPlay ("SHK011.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
				}

				if (DialogChoice == 2) 
				{ 
					synVase.invisible = on;

					Talking = 2; sPlay ("SHK012.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
					Talking = 1; sPlay ("PIP020.WAV"); 

					while (GetPosition(Voice) < 1000000) { if (GetPosition(Voice) > 700000) { if (Photo == 0) { Photo = 1; } if (GetPosition(Voice) > 900000) { Photo = 3; } } wait(1); }

					Talking = 2;  sPlay ("SHK015.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } 						
					Talking = 12; sPlay ("PIP024.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // Going away
					CamShow = 3;
					Talking = 13; sPlay ("SHK016.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // From the window
					CamShow = 4;
					Talking = 14; sPlay ("PIP025.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // From the window
					CamShow = 5;
					Talking = 15; sPlay ("SHK017.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // On the phone
					CamShow = 6;
					Talking = 16; sPlay ("PIP026.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // Weasel
					CamShow = 7;
					Talking = 17; sPlay ("SHK018.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // Piegon						
					CamShow = 8;
					Talking = 18; sPlay ("PIP027.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } // Driving away
					Run ("Plane.exe");
				}

				if (DialogChoice == 3) 
				{ 
					synVase.invisible = on;

					Talking = 11; sPlay ("PIP022.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } 
					Talking = 2; sPlay ("SHK013.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
					Talking = 1; sPlay ("PIP023.WAV"); while (GetPosition(Voice) < 1000000) { Talk(); wait(1); } 
					Talking = 22; sPlay ("SHK014.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("stand",0); Blink(); wait(1); } 
				}

			}

			while (GetPosition(Voice) < 1000000) 
			{
				Blink();
				//DialogIndex = 0;
				if (my.skill20 == 1) { force = 3; my.skill1 = my.skill1 + 5 * time; ent_cycle ("Walk",my.skill1); actor_move(); my.skill3 = my.skill3 + 3 * time; }
				if ((Talking == 1) && (my.skill2 == 3)) { Talking = 2; DialogCounter = 0; }
				wait(1); 
			}

			ShowDialog();

		}
	
		wait(1);
	}
}

action TurnVase
{
	while(1)
	{
		my.tilt = my.tilt + 20 * time;
		my.roll = my.roll + 20 * time;
		if (Talking == 11) { my.invisible = off; } else { my.invisible = on; }
		wait(1);
	}
}

action Bus
{
	while(1)
	{
		if (snd_playing(my.skill40) == 0) { play_entsound (my,BusS,3000); my.skill40 = result; }

		if (CamShow == 8)
		{
			my.y = my.y + 100 * time;
		}

		wait(1);
	}
}

action FCloud
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		if (Talking == 5) { my.invisible = off; } else { my.invisible = on; }
		wait(1);
	}
}

action Bumpin
{
	my.event = Bumped;
	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
}

action Shik1
{
	Ztemp = my.z;
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { ent_frame ("Talk",int(random(5)) * 25); }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
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

action Pipi
{
	my.skill1 = my.pan;
	my.invisible = on;
	my.shadow = off;

	while(1)
	{
		if (CamShow == 7) { if (snd_playing(my.skill40) == 0) { play_entsound (my,BusS,3000); my.skill40 = result; } }
		if (CamShow == 3) { my.invisible = off; my.shadow = on; }

		if ((Talking == 13) && (my.flag1 == off))
		{
			ent_cycle ("Walk",my.skill30);
			my.skill30 = my.skill30 + 9 * time;
			my.x = my.x - 7 * time;
		}

		if ((Talking == 14) && (my.flag1 == off))
		{
			my.x = XX;
			ent_cycle ("Lava",my.skill30);
			my.skill30 = my.skill30 + 9 * time;
			my.pan = my.skill1 + 180;
			Talk2();
		}

		if (Talking == 15) { Blink(); }

		if (CamShow == 8) { my.invisible = on; }

		wait(1);
	}
}

action Weasel
{
	while(1)
	{
		if (CamShow == 6)
		{
			ent_cycle ("Frame",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
			my.invisible = off;
			my.shadow = on;
		}

		wait(1);
	}
}

action Piposh3
{
	piposh2x = my;

	while (1)
	{	
		if (Talking == 1) 
		{ 
			if (Photo == 1) { morph(<PipPhoto.mdl>,my); create(<Photos.mdl>,my.x,Photos); Photo = 2; my.skill30 = 0; }
			if (Photo == 2)
			{
				talk2();
			}

			if (Photo == 3) { morph(<Piposh.mdl>,my); Photo = 0; }
			if (Photo == 0) { Talk(); } 
		}
		else { if (piposh.skill40 == 0) { ent_frame ("stand",0); Blink(); } else { ent_frame ("Take",100); } }

		if (Talking == 11) { Talk2(); ent_cycle ("Dumb",my.skill30); my.skill30 = my.skill30 + 10 * time; }
		if (Talking == 12)
		{
			Talk2();
			ent_cycle ("Walk",my.skill30); my.skill30 = my.skill30 + 10 * time;
			my.x = my.x - 10 * time;
			my.y = my.y + 10 * time;
		}

		if (Talking == 13) { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action Photos
{
	my.x = you.x;
	my.y = you.y;
	my.z = you.z;
	my.pan = you.pan;
	my.roll = 0;
	my.tilt = 0;
	my.scale_x = you.scale_x;
	my.scale_y = you.scale_y;
	my.scale_z = you.scale_z;

	while (Photo ! = 3)
	{
		ent_frame ("Photo",my.skill1);
		my.skill1 = my.skill1 + 5 * time;
		wait(1);
	}

	remove (my);
}

action ShikX
{
	wait(1);

	while (1)
	{	
		if (Talking == 2) { Talk(); } else { ent_frame ("stand",0); Blink(); }
		if (Talking == 22) { Talk2(); ent_frame ("Scream",0); }
		if (Talking == 12)
		{
			vec_set(temp,piposh2x.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			my.tilt = 0; my.roll = 0;
		}

		wait(1);
	}
}


action Shtomba
{
	while(piposh.skill2 < 4)
	{
		my.x = piposh.x - 5;
		my.y = piposh.y;
		my.z = piposh.z + 20;
		wait(1);
	}
}