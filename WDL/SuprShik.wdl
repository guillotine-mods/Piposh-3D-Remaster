var CamLook = 1;

synonym plr { type entity; }

sound Radar = <SFX107.WAV>;

action Rug
{
	while (Stage == 0) { wait(1); }

	while(1)
	{
		if (Stage == 2)
		{
			my.z = my.z + 6 * time;
			my.skill1 = my.skill1 + 1 * time;
			if (my.skill1 > 20) { Stage = 3; }
		}

		wait(1);
	}
}

action Watrfall
{
	while(1)
	{
		my.v = my.v - 10 * time;
		wait(1);
	}
}

action SCam
{
	while (Stage == 0) { wait(1); }

	my.skill8 = my.skill1;
	my.skill1 = 0;

	sPlay ("MSC002.WAV");

	while(Stage != 0)
	{
		if (CamLook == my.skill8)
		{
			if (Stage == 1)
			{
				my.x = my.x + 5 * time;
				my.y = my.y + 0.4 * time;
				my.z = my.z + 3.8 * time;
				my.skill1 = my.skill1 + 1 * time;
				if (my.skill1 > 120) { Stage = 2; }
			}
	
			if (Stage == 3)
			{
				my.x = my.x + 5.5 * time;
				my.y = my.y + 1 * time;
				my.skill1 = my.skill1 + 1 * time;
				if (my.skill1 > 210) { Stage = 4; }
			}
	
			if (Stage == 4)
			{
				my.z = my.z - 10 * time;
				my.x = my.x - 5 * time;
	
				my.skill1 = my.skill1 + 1 * time;
				if (my.skill1 > 247) { Stage = 5; sPlay ("SHK043.WAV"); }
	
			}
	
			if (Stage == 5)
			{
				my.skill1 = my.skill1 + 1 * time;
				if (GetPosition(Voice) >= 1000000) { Stage = 6; CamLook = 2; }
	
			}
			
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			if (CamLook == 2)
			{
				vec_set(temp,plr.x);
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);
			}
		}

		wait(1);
	}
}

action WaterWheel
{
	while (Stage == 0) { wait(1); }

	while(1)
	{
		my.roll = my.roll + 5;
		wait(1);
	}
}

action Shik
{
	while (Stage == 0) { wait(1); }

	while(1)
	{
		ent_cycle ("Stand",my.skill1);
		my.skill1 = my.skill1 + 5 * time;
		wait(1);
	}
}

action Needle
{
	while (Stage == 0) { wait(1); }

	while(Stage != 0)
	{
		if (snd_playing (my.skill40) == 0) { play_entsound (my,Radar,1000); my.skill40 = result; }

		my.roll = my.roll + 10 * time;
		wait(1);
	}

	stop_sound (my.skill40);
}

action ShikFly
{
	while (Stage == 0) { wait(1); }

	plr = my;

	while(1)
	{
		if (Stage == 6)
		{
			if (my.skill40 == 0) { sPlay("SFX106.WAV"); my.skill40 = 1; }
			my.invisible = off;
			my.shadow = on;

			my.x = my.x - 20 * time;
			ent_cycle ("Fly",my.skill7);
			my.skill7 = my.skill7 + 10 * time;

			my.skill10 = my.skill10 + 1 * time;
			if (my.skill10 > 80) { Stage = 0; } 
		}
		else
		{
			my.invisible = on;
			my.shadow = off;
		}

		wait(1);
	}
}
