// Voice engine

dllfunction InitMp3Adv();
dllfunction CloseMp3Adv();
dllfunction LoadSongSlot(x);
dllfunction GetIndexFromFile(x);
dllfunction PlaySong(x,y);
dllfunction StopSong(x);
dllfunction PauseSong(x);
dllfunction SetVolume(x,y);
dllfunction GetVolume(x);
dllfunction GetBalance(x);
dllfunction SetBalance(x, y);
dllfunction SetPosition(x, y);
dllfunction GetPosition(x);

var dllID;
var isPlaying = 0;
var JokeID;

var vTalking;
var vOrder;
var VCount;
var vPlaying;
string sOrder = "  ";
string vFilename = "                                  ";
string vData2 = "                                  ";

string SFXDIR = "SFX\\\\                                          ";

var Voice = 9999;
var Music;
var vTemp = 0;
var vRand = 0;

var vLOOP = 1;
var vNOLOOP = 0;

function vPlay(vData)
{
	GetData(vData);

	while (vPlaying != vOrder) { wait(1); GetData(vData); }

	CloseMP3Adv();
	InitMP3Adv();

	str_cpy (SFXDIR,"SFX\\\\ ");	// Add path to string
	str_trunc (SFXDIR,1);		// Remove space
	str_cat (SFXDIR,VFilename);	// Complete string (path + filename)

	Voice = LoadSongSlot (SFXDIR);
	PlaySong (Voice,vNOLOOP);

	while (GetPosition(Voice) < 1000000) { wait(1); GetData(vData); }

	CloseMP3Adv();
	if (JokeID != 99) { if (Vtalking == 1) { VTalking = 2; } else { VTalking = 1; } }
	if (JokeID == 99) { if (VTalking == 1) { VTalking = 0; } else { VTalking = 2; } }
	if (JokeID == 98) 
	{ 
		vTemp = vTemp + 1;
		if (vTemp == 1) { vTalking = 0; }
		if (vTemp == 2) { vTalking = 2; }
		if (vTemp == 3) { vTalking = 1; }
	}

	if (JokeID == 3) 
	{ 
		vTemp = vTemp + 1;
		if (vTemp == 1) { vTalking = 2; }
		if (vTemp == 2) { vTalking = 1; }
		if (vTemp == 3) { vTalking = 0; }
		if (vTemp == 4) { vTalking = 2; }
	}

	Vplaying = VOrder + 1;
}

function sPlay(filename)
{
	str_cpy (SFXDIR,"SFX\\\\ ");	// Add path to string
	str_trunc (SFXDIR,1);		// Remove space
	str_cat (SFXDIR,filename);	// Complete string (path + filename)

	CloseMP3Adv();
	InitMP3Adv();
	Voice = LoadSongSlot (SFXDIR);
	PlaySong (Voice,vNOLOOP);
}

function mPlay(filename)
{
	CloseMP3Adv();
	InitMP3Adv();
	Music = LoadSongSlot (filename);
	PlaySong (Music,vLOOP);
}

function GetData(vData)
{
	str_cpy (vFilename,vData);
	str_cpy (vData2,vData);

	str_trunc (vData2,2);
	str_cpy (sOrder,vData2);
	vOrder = str_to_num(sOrder);

	str_clip (vFilename,2);
}

function VoiceInit()
{
	dllID = dll_open("Mp3AdvDll.dll");
	InitMP3Adv();
}

function VoiceStop()
{
	CloseMP3Adv();
	dll_Close(dllID);
}

function Joke(x)
{
	vPlaying = 1;
	JokeID = 0;

	if (x == 0)  { x = int(random(77)) + 1; }	// Random joke

	if (x == 1)  { vTalking = 2; vPlay("01JOK0101.WAV"); vPlay("02JOK0102.WAV"); vPlay("03JOK0103.WAV"); }
	if (x == 2)  { vTalking = 2; vPlay("01JOK0201.WAV"); vPlay("02JOK0202.WAV"); vPlay("03JOK0203.WAV"); }
	if (x == 3)  { vTalking = 1; vPlay("01JOK0301.WAV"); vPlay("02JOK0302.WAV"); vPlay("03JOK0303.WAV"); }
	if (x == 4)  { JokeID = 1; vTalking = 2; vPlay("01JOK0401.WAV"); vPlay("02JOK0402.WAV"); vPlay("03JOK0403.WAV"); 
		                                 vPlay("04JOK0404.WAV"); vPlay("05JOK0405.WAV"); vPlay("06JOK0406.WAV");
			                         vPlay("07JOK0407.WAV"); vPlay("08JOK0408.WAV"); vPlay("09JOK0409.WAV");
			                         vPlay("10JOK0410.WAV"); vPlay("11JOK0411.WAV"); vPlay("12JOK0412.WAV");
			                         vPlay("13JOK0413.WAV"); vPlay("14JOK0414.WAV"); vPlay("15JOK0415.WAV");
			                         vPlay("16JOK0416.WAV"); vPlay("17JOK0417.WAV"); vPlay("18JOK0418.WAV");
			                         vPlay("19JOK0419.WAV"); vPlay("20JOK0421.WAV"); vPlay("21JOK0422.WAV"); 
						 vPlay("22JOK0423.WAV"); }
	if (x == 5)  { vTalking = 1; vPlay("01JOK0501.WAV"); vPlay("02JOK0502.WAV"); vPlay("03JOK0503.WAV"); }
	if (x == 6)  { vTalking = 1; vPlay("01JOK0601.WAV"); vPlay("02JOK0602.WAV"); vPlay("03JOK0603.WAV"); }
	if (x == 7)  { vTalking = 2; vPlay("01JOK0701.WAV"); vPlay("02JOK0702.WAV"); vPlay("03JOK0703.WAV"); }
	if (x == 8)  { vTalking = 2; vPlay("01JOK0801.WAV"); vPlay("02JOK0802.WAV"); vPlay("03JOK0803.WAV"); }
	if (x == 9)  { vTalking = 2; vPlay("01JOK0901.WAV"); vPlay("02JOK0902.WAV"); vPlay("03JOK0903.WAV"); }
	if (x == 10) { vTalking = 2; vPlay("01JOK1001.WAV"); vPlay("02JOK1002.WAV"); vPlay("03JOK1003.WAV"); }
	if (x == 11) { vTalking = 2; vPlay("01JOK1101.WAV"); vPlay("02JOK1102.WAV"); vPlay("03JOK1103.WAV"); }
	if (x == 12) { vTalking = 1; vPlay("01JOK1201.WAV"); vPlay("02JOK1202.WAV"); vPlay("03JOK1203.WAV"); }
	if (x == 13) { vTalking = 2; vPlay("01JOK1301.WAV"); vPlay("02JOK1302.WAV"); vPlay("03JOK1303.WAV"); }
	if (x == 14) { vTalking = 1; vPlay("01JOK1401.WAV"); vPlay("02JOK1402.WAV"); vPlay("03JOK1403.WAV"); }
	if (x == 15) { vTalking = 1; vPlay("01JOK1501.WAV"); vPlay("02JOK1502.WAV"); vPlay("03JOK1503.WAV"); }
	if (x == 16) { vTalking = 1; vPlay("01JOK1601.WAV"); vPlay("02JOK1602.WAV"); vPlay("03JOK1603.WAV"); }
	if (x == 17) { vTalking = 2; vPlay("01JOK1701.WAV"); vPlay("02JOK1702.WAV"); vPlay("03JOK1703.WAV"); }
	if (x == 18) { vTalking = 1; vPlay("01JOK1801.WAV"); vPlay("02JOK1802.WAV"); vPlay("03JOK1803.WAV"); }
	if (x == 19) { vTalking = 2; vPlay("01JOK1901.WAV"); vPlay("02JOK1902.WAV"); vPlay("03JOK1903.WAV"); }
	if (x == 20) { vTalking = 2; vPlay("01JOK2001.WAV"); vPlay("02JOK2002.WAV"); vPlay("03JOK2003.WAV"); }
	if (x == 21) { vTalking = 1; vPlay("01JOK2101.WAV"); vPlay("02JOK2102.WAV"); vPlay("03JOK2103.WAV"); }
	if (x == 22) { vTalking = 1; vPlay("01JOK2201.WAV"); vPlay("02JOK2202.WAV"); vPlay("03JOK2203.WAV"); }
	if (x == 23) { vTalking = 2; vPlay("01JOK2301.WAV"); vPlay("02JOK2302.WAV"); vPlay("03JOK2303.WAV"); }
	if (x == 24) { vTalking = 1; vPlay("01JOK2401.WAV"); vPlay("02JOK2402.WAV"); vPlay("03JOK2403.WAV"); }
	if (x == 25) { vTalking = 1; vPlay("01JOK2501.WAV"); vPlay("02JOK2502.WAV"); vPlay("03JOK2503.WAV"); }
	if (x == 26) { vTalking = 1; vPlay("01JOK2601.WAV"); vPlay("02JOK2602.WAV"); vPlay("03JOK2603.WAV"); }
	if (x == 27) { vTalking = 1; vPlay("01JOK2701.WAV"); vPlay("02JOK2702.WAV"); vPlay("03JOK2703.WAV"); }
	if (x == 28) { vTalking = 2; vPlay("01JOK2801.WAV"); vPlay("02JOK2802.WAV"); vPlay("03JOK2803.WAV"); }
	if (x == 29) { vTalking = 2; vPlay("01JOK2901.WAV"); vPlay("02JOK2902.WAV"); vPlay("03JOK2903.WAV"); }
	if (x == 30) { vTalking = 2; vPlay("01JOK3001.WAV"); vPlay("02JOK3002.WAV"); vPlay("03JOK3003.WAV"); }
	if (x == 31) { x = 32; }
	if (x == 32) { VTalking = 1; vPlay("01JOK3201.WAV"); vPlay("02JOK3202.WAV"); vPlay("03JOK3203.WAV"); }
	if (x == 33) { VTalking = 1; vPlay("01JOK3301.WAV"); vPlay("02JOK3302.WAV"); vPlay("03JOK3303.WAV"); }
	if (x == 34) { VTalking = 2; vPlay("01JOK3401.WAV"); vPlay("02JOK3402.WAV"); vPlay("03JOK3403.WAV"); }
	if (x == 35) { VTalking = 1; vPlay("01JOK3501.WAV"); vPlay("02JOK3502.WAV"); vPlay("03JOK3503.WAV"); }
	if (x == 36) { VTalking = 1; vPlay("01JOK3601.WAV"); vPlay("02JOK3602.WAV"); vPlay("03JOK3603.WAV"); }
	if (x == 37) { VTalking = 2; vPlay("01JOK3701.WAV"); vPlay("02JOK3702.WAV"); vPlay("03JOK3703.WAV"); }
	if (x == 38) { VTalking = 1; vPlay("01JOK3801.WAV"); vPlay("02JOK3802.WAV"); vPlay("03JOK3803.WAV"); }
	if (x == 39) { VTalking = 1; vPlay("01JOK3901.WAV"); vPlay("02JOK3902.WAV"); vPlay("03JOK3903.WAV"); }
	if (x == 40) { VTalking = 1; vPlay("01JOK4001.WAV"); vPlay("02JOK4002.WAV"); vPlay("03JOK4003.WAV"); }
	if (x == 41) { VTalking = 1; vPlay("01JOK4101.WAV"); vPlay("02JOK4102.WAV"); vPlay("03JOK4103.WAV"); }
	if (x == 42) { VTalking = 1; vPlay("01JOK4201.WAV"); vPlay("02JOK4202.WAV"); vPlay("03JOK4203.WAV"); }
	if (x == 43) { VTalking = 2; vPlay("01JOK4301.WAV"); vPlay("02JOK4302.WAV"); vPlay("03JOK4303.WAV"); }
	if (x == 44) { VTalking = 1; vPlay("01JOK4401.WAV"); vPlay("02JOK4402.WAV"); vPlay("03JOK4403.WAV"); }
	if (x == 45) { VTalking = 1; vPlay("01JOK4501.WAV"); vPlay("02JOK4502.WAV"); vPlay("03JOK4503.WAV"); }
	if (x == 46) { VTalking = 1; vPlay("01JOK4601.WAV"); vPlay("02JOK4602.WAV"); vPlay("03JOK4603.WAV"); }
	if (x == 47) { VTalking = 1; vPlay("01JOK4701.WAV"); vPlay("02JOK4702.WAV"); vPlay("03JOK4703.WAV"); }
	if (x == 48) { VTalking = 1; vPlay("01JOK4801.WAV"); vPlay("02JOK4802.WAV"); vPlay("03JOK4803.WAV"); }
	if (x == 49) { VTalking = 1; vPlay("01JOK4901.WAV"); vPlay("02JOK4902.WAV"); vPlay("03JOK4903.WAV"); }
	if (x == 50) { JokeID = 99; VTalking = 1; vPlay("01JOK5001.WAV"); vPlay("02JOK5002.WAV"); vPlay("03JOK5003.WAV"); }
	if (x == 51) { JokeID = 2;  VTalking = 1; vPlay("01JOK5101.WAV"); vPlay("02JOK5102.WAV"); vPlay("03JOK5103.WAV"); vPlay("04JOK5104.WAV"); }
	if (x == 52) { VTalking = 1; vPlay("01JOK5201.WAV"); vPlay("02JOK5202.WAV"); vPlay("03JOK5203.WAV"); }
	if (x == 53) { VTalking = 1; vPlay("01JOK5301.WAV"); vPlay("02JOK5302.WAV"); vPlay("03JOK5303.WAV"); }
	if (x == 54) { VTalking = 1; vPlay("01JOK5401.WAV"); vPlay("02JOK5402.WAV"); vPlay("03JOK5403.WAV"); }
	if (x == 55) { VTalking = 1; vPlay("01JOK5501.WAV"); vPlay("02JOK5502.WAV"); vPlay("03JOK5503.WAV"); }
	if (x == 56) { vTemp = 0; VTalking = 2; JokeID = 98; vPlay("01JOK5601.WAV"); vPlay("02JOK5602.WAV"); vPlay("03JOK5603.WAV"); vPlay("04JOK5604.WAV"); }
	if (x == 57) { VTalking = 1; vPlay("01JOK5701.WAV"); vPlay("02JOK5702.WAV"); vPlay("03JOK5703.WAV"); }
	if (x == 58) { VTalking = 2; vPlay("01JOK5801.WAV"); vPlay("02JOK5802.WAV"); vPlay("03JOK5803.WAV"); }
	if (x == 59) { VTalking = 1; vPlay("01JOK5901.WAV"); vPlay("02JOK5902.WAV"); vPlay("03JOK5903.WAV"); }
	if (x == 60) { VTalking = 1; vPlay("01JOK6001.WAV"); vPlay("02JOK6002.WAV"); vPlay("03JOK6003.WAV"); }
	if (x == 61) { JokeID = 2; VTalking = 1; vPlay("01JOK6101.WAV"); vPlay("02JOK6102.WAV"); vPlay("03JOK6103.WAV"); vPlay ("04JOK6104.WAV"); }
	if (x == 62) { JokeID = 3; VTalking = 1; vPlay("01JOK6201.WAV"); vPlay("02JOK6202.WAV"); vPlay("03JOK6203.WAV"); vPlay ("04JOK6204.WAV"); vPlay ("05JOK6205.WAV"); }
	if (x == 63) { VTalking = 2; vPlay("01JOK6301.WAV"); vPlay("02JOK6302.WAV"); vPlay("03JOK6303.WAV"); }
	if (x == 64) { VTalking = 1; vPlay("01JOK6401.WAV"); vPlay("02JOK6402.WAV"); vPlay("03JOK6403.WAV"); }
	if (x == 65) { VTalking = 1; vPlay("01JOK6501.WAV"); vPlay("02JOK6502.WAV"); vPlay("03JOK6503.WAV"); }
	if (x == 66) { VTalking = 1; vPlay("01JOK6601.WAV"); vPlay("02JOK6602.WAV"); vPlay("03JOK6603.WAV"); }
	if (x == 67) { VTalking = 1; vPlay("01JOK6701.WAV"); vPlay("02JOK6702.WAV"); vPlay("03JOK6703.WAV"); }
	if (x == 68) { VTalking = 1; vPlay("01JOK6801.WAV"); vPlay("02JOK6802.WAV"); vPlay("03JOK6803.WAV"); }
	if (x == 69) { VTalking = 1; vPlay("01JOK6901.WAV"); RandomJoke(1); RandomJoke(2); }
	if (x == 70) { VTalking = 1; vPlay("01JOK7001.WAV"); vPlay("02JOK7002.WAV"); vPlay("03JOK7003.WAV"); }
	if (x == 71) { VTalking = 2; vPlay("01JOK7101.WAV"); vPlay("02JOK7102.WAV"); vPlay("03JOK7103.WAV"); }
	if (x == 72) { VTalking = 1; vPlay("01JOK7201.WAV"); vPlay("02JOK7202.WAV"); vPlay("03JOK7203.WAV"); }
	if (x == 73) { VTalking = 1; vPlay("01JOK7301.WAV"); vPlay("02JOK7302.WAV"); vPlay("03JOK7303.WAV"); }
	if (x == 74) { VTalking = 2; vPlay("01JOK7401.WAV"); vPlay("02JOK7402.WAV"); vPlay("03JOK7403.WAV"); }
	if (x == 75) { VTalking = 1; vPlay("01JOK7501.WAV"); vPlay("02JOK7502.WAV"); vPlay("03JOK7503.WAV"); }
	if (x == 76) { VTalking = 1; vPlay("01JOK7601.WAV"); vPlay("02JOK7602.WAV"); vPlay("03JOK7603.WAV"); }
	if (x == 77) { VTalking = 1; vPlay("01JOK7701.WAV"); vPlay("02JOK7702.WAV"); vPlay("03JOK7703.WAV"); }
}

function RandomJoke(y)
{
	vRand = int(random(46)) + 1;

	if (vRand == 1 ) { if (y == 1) { vPlay("02JOK0302.WAV"); } else { vPlay("03JOK0303.WAV"); } }
	if (vRand == 2 ) { if (y == 1) { vPlay("02JOK0502.WAV"); } else { vPlay("03JOK0503.WAV"); } }
	if (vRand == 3 ) { if (y == 1) { vPlay("02JOK0602.WAV"); } else { vPlay("03JOK0603.WAV"); } }
	if (vRand == 4 ) { if (y == 1) { vPlay("02JOK1202.WAV"); } else { vPlay("03JOK1203.WAV"); } }
	if (vRand == 5 ) { if (y == 1) { vPlay("02JOK1402.WAV"); } else { vPlay("03JOK1403.WAV"); } }
	if (vRand == 6 ) { if (y == 1) { vPlay("02JOK1502.WAV"); } else { vPlay("03JOK1503.WAV"); } }
	if (vRand == 7 ) { if (y == 1) { vPlay("02JOK1602.WAV"); } else { vPlay("03JOK1603.WAV"); } }
	if (vRand == 8 ) { if (y == 1) { vPlay("02JOK1802.WAV"); } else { vPlay("03JOK1803.WAV"); } }
	if (vRand == 9 ) { if (y == 1) { vPlay("02JOK2102.WAV"); } else { vPlay("03JOK2103.WAV"); } }
	if (vRand == 10) { if (y == 1) { vPlay("02JOK2202.WAV"); } else { vPlay("03JOK2203.WAV"); } }
	if (vRand == 11) { if (y == 1) { vPlay("02JOK2402.WAV"); } else { vPlay("03JOK2403.WAV"); } }
	if (vRand == 12) { if (y == 1) { vPlay("02JOK2502.WAV"); } else { vPlay("03JOK2503.WAV"); } }
	if (vRand == 13) { if (y == 1) { vPlay("02JOK2602.WAV"); } else { vPlay("03JOK2603.WAV"); } }
	if (vRand == 14) { if (y == 1) { vPlay("02JOK2702.WAV"); } else { vPlay("03JOK2703.WAV"); } }
	if (vRand == 15) { if (y == 1) { vPlay("02JOK3202.WAV"); } else { vPlay("03JOK3203.WAV"); } }
	if (vRand == 16) { if (y == 1) { vPlay("02JOK3302.WAV"); } else { vPlay("03JOK3303.WAV"); } }
	if (vRand == 17) { if (y == 1) { vPlay("02JOK3502.WAV"); } else { vPlay("03JOK3503.WAV"); } }
	if (vRand == 18) { if (y == 1) { vPlay("02JOK3602.WAV"); } else { vPlay("03JOK3603.WAV"); } }
	if (vRand == 19) { if (y == 1) { vPlay("02JOK3802.WAV"); } else { vPlay("03JOK3803.WAV"); } }
	if (vRand == 20) { if (y == 1) { vPlay("02JOK3902.WAV"); } else { vPlay("03JOK3903.WAV"); } }
	if (vRand == 21) { if (y == 1) { vPlay("02JOK4002.WAV"); } else { vPlay("03JOK4003.WAV"); } }
	if (vRand == 22) { if (y == 1) { vPlay("02JOK4102.WAV"); } else { vPlay("03JOK4103.WAV"); } }
	if (vRand == 23) { if (y == 1) { vPlay("02JOK4202.WAV"); } else { vPlay("03JOK4203.WAV"); } }
	if (vRand == 24) { if (y == 1) { vPlay("02JOK4402.WAV"); } else { vPlay("03JOK4403.WAV"); } }
	if (vRand == 25) { if (y == 1) { vPlay("02JOK4502.WAV"); } else { vPlay("03JOK4503.WAV"); } }
	if (vRand == 26) { if (y == 1) { vPlay("02JOK4602.WAV"); } else { vPlay("03JOK4603.WAV"); } }
	if (vRand == 27) { if (y == 1) { vPlay("02JOK4702.WAV"); } else { vPlay("03JOK4703.WAV"); } }
	if (vRand == 28) { if (y == 1) { vPlay("02JOK4802.WAV"); } else { vPlay("03JOK4803.WAV"); } }
	if (vRand == 29) { if (y == 1) { vPlay("02JOK4902.WAV"); } else { vPlay("03JOK4903.WAV"); } }
	if (vRand == 30) { if (y == 1) { vPlay("02JOK5202.WAV"); } else { vPlay("03JOK5203.WAV"); } }
	if (vRand == 31) { if (y == 1) { vPlay("02JOK5302.WAV"); } else { vPlay("03JOK5303.WAV"); } }
	if (vRand == 32) { if (y == 1) { vPlay("02JOK5402.WAV"); } else { vPlay("03JOK5403.WAV"); } }
	if (vRand == 33) { if (y == 1) { vPlay("02JOK5502.WAV"); } else { vPlay("03JOK5503.WAV"); } }
	if (vRand == 34) { if (y == 1) { vPlay("02JOK5702.WAV"); } else { vPlay("03JOK5703.WAV"); } }
	if (vRand == 35) { if (y == 1) { vPlay("02JOK5902.WAV"); } else { vPlay("03JOK5903.WAV"); } }
	if (vRand == 36) { if (y == 1) { vPlay("02JOK6002.WAV"); } else { vPlay("03JOK6003.WAV"); } }
	if (vRand == 37) { if (y == 1) { vPlay("02JOK6402.WAV"); } else { vPlay("03JOK6403.WAV"); } }
	if (vRand == 38) { if (y == 1) { vPlay("02JOK6502.WAV"); } else { vPlay("03JOK6503.WAV"); } }
	if (vRand == 39) { if (y == 1) { vPlay("02JOK6602.WAV"); } else { vPlay("03JOK6603.WAV"); } }
	if (vRand == 40) { if (y == 1) { vPlay("02JOK6702.WAV"); } else { vPlay("03JOK6703.WAV"); } }
	if (vRand == 41) { if (y == 1) { vPlay("02JOK6802.WAV"); } else { vPlay("03JOK6803.WAV"); } }
	if (vRand == 42) { if (y == 1) { vPlay("02JOK7002.WAV"); } else { vPlay("03JOK7003.WAV"); } }
	if (vRand == 43) { if (y == 1) { vPlay("02JOK7202.WAV"); } else { vPlay("03JOK7203.WAV"); } }
	if (vRand == 44) { if (y == 1) { vPlay("02JOK7302.WAV"); } else { vPlay("03JOK7303.WAV"); } }
	if (vRand == 45) { if (y == 1) { vPlay("02JOK7502.WAV"); } else { vPlay("03JOK7503.WAV"); } }
	if (vRand == 46) { if (y == 1) { vPlay("02JOK7602.WAV"); } else { vPlay("03JOK7603.WAV"); } }
}

function FF
{
	if (Voice == 9999) { return; }
	SetPosition (Voice,1000000);
}

on_space = FF();