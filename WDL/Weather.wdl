///////////////////////////////////////////////////////////////////////////////////
// weather.wdl
////////////////////////////////////////////////////////////////////////////

DEFINE weather_rain 	= 1;				//Regen
DEFINE weather_storm 	= 2;				//Gewitter
DEFINE weather_snow 	= 3;				//Schnee

define rain_fog = 50;
define sky_color_rain = 80;
define snow_fog = 40;

var weather;
var weather_strength;
var weather_timer;
var weather_mem;
var distance;
var mypos;
var myangle;
var night;
var act_weather = 9;

bmap slider = <slider.pcx>;
bmap slider_background = <slider_b.pcx>;
bmap akt_w = <akt_w.pcx>;

string empty_str = "                          ";
string fog_str = "CAMERA.FOG =";
string rain_str = "RAIN PARTICLE =";
string snow_str = "SNOW PARTICLE =";

TEXT panel_txt {
	POS_X = 0;
	POS_Y = 60;
	FONT = standard_font;
	STRING = empty_str;
}

PANEL fog_panel {
	POS_X = 10;
	POS_Y = 35;
	BMAP slider_background;
	DIGITS 065,25,3,standard_font,1,camera.fog;
	HSLIDER 0,0,100,slider,0,100,camera.fog;
	FLAGS  = refresh,overlay;
}

PANEL weather_particel_panel {
	POS_X = 10;
	POS_Y = 35;
	BMAP slider_background;
	DIGITS 80,25,3,standard_font,1,weather_strength;
	HSLIDER 0,0,100,slider,0,100,weather_strength;
	FLAGS  = refresh,overlay;
}

BMAP	sky = <sky.pcx>;
BMAP	sky_light = <sky_light.pcx>;
BMAP	sky_light2 = <sky_light2.pcx>;
BMAP	cloud =<cloud.pcx>;
BMAP	sky_day = <sky_day.pcx>;
BMAP	cloud_day =<cloud_d.pcx>;
BMAP	drop = <drop.pcx>;
BMAP	snow = <snow.pcx>;

BMAP	raining = <rain.pcx>;
BMAP	snowing = <snowfall.pcx>;
BMAP	day = <day.pcx>;
BMAP	night_p = <night.pcx>;
BMAP	th_storm= <thstorm.pcx>;
BMAP	fog_p = <fog.pcx>;
BMAP	lightn = <lightn.pcx>;
BMAP	tornado = <tor_ic.pcx>;
BMAP	fog_sky = <fog_sky.pcx>;

PANEL weather_panel {
	POS_X = 30;
	POS_Y = 440;
	BUTTON 0,0,snowing,snowing,snowing,start_snow,null,null;
	BUTTON 40,0,raining,raining,raining,start_rain,null,null;
	BUTTON 80,0,th_storm,th_storm,th_storm,start_storm,null,null;
	BUTTON 120,0,fog_p,fog_p,fog_p,start_fog,null,null;
	BUTTON 160,0,lightn,lightn,lightn,lightning,null,null;
	BUTTON 200,0,day,day,day,set_day,null,null;
	BUTTON 240,0,night_p,night_p,night_p,set_night,null,null;
	BUTTON 280,0,tornado,tornado,tornado,null,null,null;
	flags = refresh;
}

PANEL act_weather_panel {
	POS_X = 26;
	POS_Y = 436;
	hbar 0,0,320,akt_w,40,act_weather;
	flags = refresh,transparent;
}

SOUND thunder = <thunder.wav>;
SOUND rain = <rain.wav>;

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	Schnee
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function stop_snow;

function start_snow ()
{
	if (weather == weather_snow) 
	{
		weather_particel_panel.visible = off;
		fog_panel.visible = off;
		panel_txt.string = empty_str;
		act_weather = 9;
		stop_snow ();
	 	return;
	}
	if (weather == weather_rain || weather == weather_storm) {return;}
	act_weather = 0;
	weather_particel_panel.visible = on;
	fog_panel.visible = off;
	panel_txt.string = snow_str;
	let_it_snow ();
}

function let_it_snow ()
{
	if (weather == weather_snow) {stop_snow (); return;}
	if (weather == weather_rain || weather == weather_storm) {return;}
	weather = weather_snow;
	weather_strength = 40;
	snow_akt ();
	if (night == 0)
	{
		fog_color = 1;
		camera.fog = snow_fog;
	}
}

function stop_snow ()
{
	if (night == 0)
	{
		camera.fog = 0;
		fog_color = 0; 
	}
	weather = 0;
}

function snow_eff ()
{
	my.bmap = snow;
	my.lifespan = 40;
	my.x += random(1000)-500;
	my.y += random(1000)-500;
	my.z += random(100)-50;
	my.move = on;
	my.flare = on;
	my.vel_x = random(16)-8;
	my.vel_y = random(16)-8;
	my.vel_z = -6;
	my.function = null;
}

function snow_akt ()
{
	WHILE	(weather == weather_snow)
	{
		set_cam_pos ();
		distance = 200;
		set_pos ();
		MyPos.Z = CAMERA.Z + 150;
		effect (snow_eff,weather_strength,MyPos,nullskill);
		WAITT	(3);
	}
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	Regen
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function stop_rain;

function start_rain ()
{
	if (weather == weather_rain) 
	{
		stop_rain ();
		weather_particel_panel.visible = off;
		fog_panel.visible = off;
		panel_txt.string = empty_str;
		act_weather = 9;
		return;
	}
	if (weather == weather_snow || weather == weather_storm) {return;}
	act_weather = 1;
	weather_particel_panel.visible = on;
	fog_panel.visible = off;
	panel_txt.string = rain_str;
	let_it_rain ();
}

function  let_it_rain ()
{
	if (weather == weather_rain) {stop_rain (); return;}
	if (weather == weather_snow || weather == weather_storm) {return;}
	weather = weather_rain;
	play_loop (rain,15);
	weather_mem = result;
	weather_strength = 70;
	rain_akt ();
	if (night == 0)
	{
		fog_color = 1; 
		sky_color.red = sky_color_rain;
		sky_color.green= sky_color_rain;
		sky_color.blue = sky_color_rain;
		camera.fog = rain_fog;
	}
}

function stop_rain ()
{
	stop_sound (weather_mem);
	if (night == 0)
	{
		sky_color.red = 250;
		sky_color.green= 250;
		sky_color.blue = 250;
		camera.fog = 0;
		fog_color = 0; 
	}
	weather = 0;
}

function rain_eff ()
{
	my.bmap = drop;
	my.lifespan = 20;
	my.x += random(1000)-500;
	my.y += random(1000)-500;
	my.z += random(100)-50;
	my.move = on;
	my.flare = on;
	my.vel_x = 0;
	my.vel_y = 0;
	my.vel_z = -40;
	my.size = 8;
	my.function = null;
}

function rain_akt ()
{
	WHILE	(weather == weather_storm || weather == weather_rain)
	{
		set_cam_pos ();
		distance = 200;
		set_pos ();
		MyPos.Z = CAMERA.Z + 200;
		effect (rain_eff,weather_strength,MyPos,nullskill);
		WAITT	(3);
	}
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	Gewitter
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function start_storm ()
{
	if (weather == weather_snow || weather == weather_rain) {return;}
	if (weather == weather_storm) 
	{
		stop_rain ();
		weather_particel_panel.visible = off;
		fog_panel.visible = off;
		panel_txt.string = empty_str;
		act_weather = 9;
		return;
	}
	storm  ();
	wait (1);
	act_weather = 2;
	weather_particel_panel.visible = on;
	fog_panel.visible = off;
	panel_txt.string = rain_str;
}

function storm ()
{
	if (weather == weather_snow || weather == weather_rain) {return;}
	if (weather == weather_storm) {stop_rain (); return;}
	let_it_rain ();
	weather = weather_storm;
anfang:
	weather_timer = RANDOM(100)+150;
	WHILE	 (weather_timer > 0)
	{
		weather_timer -= 1*time;
		WAIT (1);
	}
	IF (weather == weather_storm)
	{
		lightning ();
		GOTO	anfang;
	}
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	Blitze
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function lightning ()
{
	temp = RANDOM(20);
	IF (temp <=10 ) {lightning1 ();}
	ELSE {lightning2 ();}
}

function lightning1 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	if (night) {CAMERA.FOG -= 80;}
	WAITT	1;
	SKY_MAP = sky_light2;
	if (night) {CAMERA.FOG += 30;}
	WAITT	2;
	if (night) {CAMERA.FOG += 20;}
	WAITT	1;
	SKY_MAP = sky_light;
	if (night) {CAMERA.FOG -= 40;}
	WAITT	3;
	SKY_MAP = sky_light2;
	if (night) {CAMERA.FOG += 30;}
	WAITT	1;
	SKY_MAP = sky;
	if (night) {CAMERA.FOG += 40;}
	WAITT	2;
	SKY_MAP = sky_light2;
	if (night) {CAMERA.FOG -= 30;}
	WAITT	1;
	if (night == 1) {SKY_MAP = sky;}
	else {SKY_MAP = sky_day;}
	if (night) {CAMERA.FOG += 30;}
}

function lightning2 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	if (night) {CAMERA.FOG -= 80;}
	WAITT	4;
	SKY_MAP = sky_light2;
	if (night) {CAMERA.FOG += 50;}
	WAITT	3;
	SKY_MAP = sky_light;
	if (night) {CAMERA.FOG -= 40;}
	WAITT	2;
	if (night == 1) {SKY_MAP = sky;}
	else {SKY_MAP = sky_day;}
	if (night) {CAMERA.FOG += 70;}
}

function lightning_ent ()
{
	temp = ent_path ("lightning_path");
	if (temp == 0) {goto blitz_end;}
	temp.z = int(random(temp)+1);
	ent_waypoint (temp,temp.z);
	vec_set (my.pos,temp);
	my.flare = on;
	my.blend = on;
	my.scale_x = 2;
	my.scale_y = 5;
	waitt (10);
blitz_end:
	remove me;
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	NEBEL
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function start_fog ()
{
	if (weather != 0 || night) {return;}
	if (fog_color != 3) 
	{
		act_weather = 3;
		weather_particel_panel.visible = off;
		fog_panel.visible = on;
		panel_txt.string = fog_str;
	}
	else
	{
		act_weather = 9;
		weather_particel_panel.visible = off;
		fog_panel.visible = off;
		panel_txt.string = empty_str;
	}
	set_fog ();
}

function set_fog ()
{
	if (weather != 0 || night) {return;}
	if (fog_color != 3) 
	{
		fog_color = 3;
		camera.fog = 50;
		sky_map = fog_sky;
		cloud_map = fog_sky;
	}
	else 
	{
		fog_color = 0;
		sky_map = sky_day;
		cloud_map = cloud_day;
	}
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#	TAG / NACHT
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function set_day ()
{
	if (night == 0) {return;}
	SKY_MAP = sky_day;
	CLOUD_MAP = cloud_day;
	sky_color.red = 25;
	sky_color.green= 25;
	sky_color.blue = 25;
	night = 0;
	while (1)
	{
		sky_color.red += 25*time;
		sky_color.green += 25*time;
		sky_color.blue += 25*time;
		camera.fog -= 5 * time;
		if (weather == 0)
		{
			if (sky_color.red >= 250 && sky_color.green >= 250 && sky_color.blue >= 250)
			{
				fog_color = 0;
				sky_color.red = 250;
				sky_color.green = 250;
				sky_color.blue = 250;
				break;
			}
		}
		if (weather == weather_snow) 
		{
			if (sky_color.red >= 250 && sky_color.green >= 250 && sky_color.blue >= 250)
			{
				fog_color = 1; 
				camera.fog = snow_fog;
				break;
			}
		}
		if (weather == weather_rain || weather == weather_storm)
		{
			if (sky_color.red >= sky_color_rain && sky_color.green >= sky_color_rain && sky_color.blue >= sky_color_rain)
			{
				fog_color = 1; 
				camera.fog = rain_fog;
				sky_color.red = sky_color_rain;
				sky_color.green= sky_color_rain;
				sky_color.blue = sky_color_rain;
				break;
			}
		}
		wait (1);
	}
}

function set_night ()
{
	if (night) {return;}
	night = 1;
	fog_color = 1;
	while (1)
	{
		sky_color.red -= 25*time;
		sky_color.green -= 25*time;
		sky_color.blue -= 25*time;
		camera.fog += 5 * time;
		if (camera.fog > 80) {camera.fog = 80;}
		if (sky_color.red <= 25) {break;}
		wait (1);
	}
	SKY_MAP = sky;
	CLOUD_MAP = cloud;
	camera.fog = 80;
	sky_color.red = 250;
	sky_color.green= 250;
	sky_color.blue = 250;
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function  set_pos ()
{
	temp.X = COS(MyAngle.PAN);
	temp.Y = SIN(MyAngle.PAN);
	temp.Z = distance*COS(MyAngle.TILT);
	MyPos.X = MyPos.X + temp.Z*temp.X;
	MyPos.Y = MyPos.Y + temp.Z*temp.Y;
	MyPos.Z = MyPos.Z + distance*SIN(MyAngle.TILT);
}

function set_cam_pos ()
{
	vec_set (MyPos,camera.pos);
	MyAngle.PAN = CAMERA.PAN;
}

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

on_1 = let_it_snow;
on_2 = let_it_rain;
on_3 = storm;
on_4 = set_fog;
on_5 = lightning;
on_6 = set_day;
on_7 = set_night;
