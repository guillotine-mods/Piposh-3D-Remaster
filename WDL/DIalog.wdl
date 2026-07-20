//*****************************************************************
//*                       D I A L O G S                           *
//*****************************************************************

var Talking = 0;	// Indication for the actor who is talking
var DialogCounter = 0;	// The animation counter
var DialogIndex = 0;	// Dialog to display
var DialogChoice = 0;

// Panel images

bmap bOpt1 = <Opt1.pcx>;
bmap bOpt2 = <Opt2.pcx>;
bmap bSteel = <Steel.pcx>;

// Texts

TEXT txt1
{
	layer = -1;
	pos_x = 60;
	pos_y = 340;
	string = "";
	flags = visible;
	font = standard_font;
}

TEXT txt2
{
	layer = -1;
	pos_x = 60;
	pos_y = 395;
	string = "";
	flags = visible;
	font = standard_font;
}

TEXT txt3
{
	layer = -1;
	pos_x = 60;
	pos_y = 450;
	string = "";
	flags = visible;
	font = standard_font;
}

panel Dialog
{
	bmap = bSteel;
	pos_x = 0;
	pos_y = 333;
	flags = d3d,refresh,overlay;
	layer = -2;
	button = 0,-15,bOpt1,bOpt1,bOpt2,Choice1,null,null;
	button = 0,40,bOpt1,bOpt1,bOpt2,Choice2,null,null;
	button = 0,97,bOpt1,bOpt1,bOpt2,Choice3,null,null;
}

panel Option1
{
	pos_x = 50;
	pos_y = 337;
	flags = d3d,refresh,overlay;
	layer = -1;
	on_click = Choice1;
}

panel Option2
{
	pos_x = 50;
	pos_y = 390;
	flags = d3d,refresh,overlay;
	layer = -1;
	on_click = Choice2;
}

panel Option3
{
	pos_x = 50;
	pos_y = 438;
	flags = d3d,refresh,overlay;
	layer = -1;
	on_click = Choice3;
}

function Choice1
{
	Dialog.visible = off;
	HideText();
	DialogCounter = 0;
	DialogChoice = 1;
//	Talking = 1;
//	SetDialog(1);
}

function Choice2
{
	Dialog.visible = off;
	HideText();
	DialogCounter = 0;
	DialogChoice = 2;
//	Talking = 1;
//	SetDialog(2);
}

function Choice3
{
	Dialog.visible = off;
	HideText();
	DialogCounter = 0;
	DialogChoice = 3;
//	Talking = 1;
//	SetDialog(3);
}

function HideText()
{
	txt1.visible = off;
	txt2.visible = off;
	txt3.visible = off;
}

function ShowText()
{
	txt1.visible = on;
	txt2.visible = on;
	txt3.visible = on;
}

function SetDialogOptions
{
	if (DialogIndex == 0)
	{
		txt1.string = "                                                     ?JMP S'RE VA JL XUFT EVA JVML GA";// אז למתי אתה רושם לי את הצ'ק עמי?
		txt2.string = "                                                 ...XFKOE YJJNPB WVJA TBDL JVJRT ,JMP";// עמי, רציתי לדבר איתך בעניין הסכום...
		txt3.string = "                                          ?FGE EBMFIUEM JVFA AJRFEL YKFM FEUJM....JFQ";// פוי....מישהו מוכן להוציא אותי מהשטומבה הזו?
	}

	if (DialogIndex == 1)
	{
		txt1.string = "                                                                EPDFML TUSB JVAB XFLU";// שלום באתי בקשר למודעה
		txt2.string = "               '?FGE EBMFIUEM JGH VA AJRFM JNA WJA' : VDFCAL XFTVL ERFT EVA JLFA XFLU";// שלום אולי אתה רוצה לתרום לאגודת : "איך אני מוציא את חזי מהשטומבה הזו?"
		txt3.string = "                                        ..EKK JVFA EATV AL LLK WTDB ,JNFQE LP JL HLOV";// תסלח לי על הפוני, בדרך כלל לא תראה אותי ככה..
	}

	if (DialogIndex == 2)
	{
		txt1.string = "                            ?EGM LMCJEL ENU JL HSL !XJSQSQ VQJIP FG !JVFA CFTEV UJJFA";// אוייש תהרוג אותי! זו עטיפת פקפקים! לקח לי שנה להיגמל מזה
		txt2.string = "                                       ?XJQJINE VTPMM TJMU LU VFFRS EGB WL ZFOAA JNAU";// שאני אאסוף לך בזה קצוות של שמיר ממערת הנטיפים?
		txt3.string = "                    ..JBR.B TQOE VJBB SOTQAL EJRNJDTFS CFHB JVDMLU SJTI EATV AFB ,JFA";// אוי, בוא תראה טריק שלמדתי בחוג קורדינציה לאפרסק בבית הספר ב.צבי..
	}


	if (DialogIndex == 3)
	{
		txt1.string = "                                                         !?AL YAK DBFP EVA...SJ'RTFHB";// בחורצ'יק...אתה עובד כאן לא?! 
		txt2.string = "                                 ?JVFA BJUFM EVA EQJA !JLU XJLCTE VA HJNEL XFSM JL YV";// תן לי מקום להניח את הרגלים שלי! איפה אתה מושיב אותי?
		txt3.string = "                                 ?WLU UATE LP EGE LITCAE VA XJUA JNAU WL VQKA PIOFBLB";// בלבוסטע אכפת לך שאני אשים את האגרטל הזה על הראש שלך?
	}


	if (DialogIndex == 4)
	{
		txt1.string = "                                               OFIM OJIEL WJA PDFJ AL EVA !PFTQ UFHJN";// ניחוש פרוע! אתה לא יודע איך להטיס מטוס 
		txt2.string = "                                                       WMFSMB CENA JNA TBK JL YV !WFA";// אוך! תן לי כבר אני אנהג במקומך
		txt3.string = "                                  !?EM IJNTBS VKJO LBSL JLJBUB PJQUV JLFA SJNQFTS BCA";// אגב קרופניק אולי תשפיע בשבילי לקבל סיכת קברניט מה?!
	}

	if (DialogIndex == 5)
	{
		txt1.string = "                                (EBFTSE VFNHB H'U XJNFMU VTFMV XKVFUTL DMPFV EJRQFAE)";// (האופציה תועמד לרשותכם תמורת שמונים ש"ח בחנות הקרובה)
		txt2.string = "                                'ENJIS LU TDHB JGH' JLU EUDHE ESQEL YJJFRM IFU EG JFA";// אוי זה שוט מצויין להפקה החדשה שלי "חזי בחדר של קטינה"
		txt3.string = "                                            ....JVNBE JVNBE XJVFTUL WTDE AL FG GA ,EA";// אה, אז זו לא הדרך לשרותים הבנתי הבנתי....
	}

	if (DialogIndex == 6)
	{
		txt1.string = "                             ..VFSD EMK DFPB TUSVV ...XJTBDE FLQJ WJA JFLV DFAM EG...";// ...זה מאוד תלוי איך יפלו הדברים... תתקשר בעוד כמה דקות..
		txt2.string = "                                     ...AJE JLU ENSOMEF ,WLJBUB BFUHL VRS JL ARJ VMAE";// האמת יצא לי קצת לחשוב בשבילך, והמסקנה שלי היא...
		txt3.string = "                                                   ....JL VQKJA EM VFML DMFP JNA ! AE";// הא ! אני עומד למות מה איכפת לי....
	}

	if (DialogIndex == 7)
	{
		txt1.string = "                                                  ...WLPB VA PCTK JVKPM LBA EHJLO ,EA";// אה, סליחה אבל מעכתי כרגע את בעלך...
		txt2.string = "                                              .JLU AFE YAK LQNU EGE OTHE ,AINJ JLU EG";// זה שלי ינטא, החרס הזה שנפל כאן הוא שלי.
		txt3.string = "                                                                 ?EQ VJNS EM EATN AFB";// בוא נראה מה קנית פה?
	}

	if (DialogIndex == 8)
	{
		txt1.string = "                                                          EQM ZFPV ZKJV ETJJI FMK EVA";// אתה כמו טיירה תיכף תעוף מפה
		txt2.string = "                                           1-B FMK TFJR FVFA XP AL LBA ,ETJJI FMK EVA";// אתה כמו טיירה, אבל לא עם אותו ציור כמו ב-1
		txt3.string = "                                                         FRHLV LA EATFNF EMFJA EJRQFA";// אופציה איומה ונוראה אל תלחצו
	}

	if (DialogIndex == 9)
	{
		txt1.string = "                                                                   ...TJUL YMGE AL EG";// זה לא הזמן לשיר...
		txt2.string = "                                                      ?YFLJJA ZLHML YAKM DTFJ JNA WJA";// איך אני יורד מכאן למחלף איילון?
		txt3.string = "                               WLU DNFAOE VA JVNBE ALU FA EL EL EL YACJJMGFQGFQB VTMA";// אמרת בפוזפוזמייגאן לה לה לה או שלא הבנתי את הסאונד שלך
	}

	if (DialogIndex == 10)
	{
		txt1.string = "                                                                ?YFKN VFPJON DTUM EVA";// אתה משרד נסיעות נכון?
		txt2.string = "                                                               ...ESJTMAB XJSOP JL UJ";// יש לי עסקים באמריקה...
		txt3.string = "                                         ....OJITK JL OJQDVF ESJTMAL JVFA SVSVV ELLAJ";// יאללה תתקתק אותי לאמריקה ותדפיס לי כרטיס....
	}

	if (DialogIndex == 11)
	{
		txt1.string = "                                               ...XLFPE LKL DJCEL FG EMB LPM ERFT JNA";// אני רוצה מעל במה זו להגיד לכל העולם...
		txt2.string = "                                                  !LITCA LU XJOTH EG ? EG VA EAFT EVA";// אתה רואה את זה ? זה חרסים של אגרטל!
		txt3.string = "                                                     ...HMS VFAVQFS XJSLHM ,BFLFAU FN";// נו שאולוב, מחלקים קופתאות קמח...
	}

	if (DialogIndex == 12)
	{
		txt1.string = "                                             !LBMAI AJ WMM SGH TVFJ JNA !? JL EUPV EM";// מה תעשה לי ?! אני יותר חזק ממך יא טאמבל!
		txt2.string = "                                                              ...VFLHM AJBM EGU JVPMU";// שמעתי שזה מביא מחלות...
		txt3.string = "                           YFMJL XP ELRS JLFA ,?E'RHN JLB ,ELRS XPIB ST SJIOM UJ ,JFA";// אוי, יש מסטיק רק בטעם קצלה, בלי נחצ'ה?, אולי קצלה עם לימון
	}

	if (DialogIndex == 13)
	{
		txt1.string = "                                                         ....PT SHUL LP XJTBDM TBK XA";// אם כבר מדברים על לשחק רע....
		txt2.string = "                                           !TFUJS VFLJM ATSNU IQUM LKB JNFJH BJKTM UJ";// יש מרכיב חיוני בכל משפט שנקרא מילות קישור!
		txt3.string = "                     ?JLU VJNFLJME EQJA .XKLU XJNFNJCE LK XP JL SJQOE ,EG XP JD JD JD";// די די די עם זה, הספיק לי עם כל הגינונים שלכם. איפה המילונית שלי?
	}

	if (DialogIndex == 14)
	{
		txt1.string = "                                                   OTH DK INFA ELCNJB ELCNJB XFG ? FJ";// יו ? זום בינגלה בינגלה אונט כד חרס
		txt2.string = "                                                             ?OPBFB OPCNFJ ,JRNJG TJF";// ויר זינצי, יונגעס בובעס?
		txt3.string = "                                        XA HFLB YAK JL FBTRU VJK'RB YINIS TJU ENE JFA";// אוי הנה שיר קטנטן בצ'כית שצרבו לי כאן בלוח אם
	}

	if (DialogIndex == 15)
	{
		txt1.string = "                                                                  ?BFU WJA WJA WJA EM";// מה איך איך איך שוב?
		txt2.string = "                         VFTJTM LU EPLBFM EGJA JL VMJJS WTBE VSJQBU UATM TJEGM JNA ST";// רק אני מזהיר מראש שבפיקת הברך קיימת לי איזה מובלעה של מרירות
		txt3.string = "                                                                     .BFLFAU VA FLKAV";// תאכלו את שאולוב.
	}

	if (DialogIndex == 16)
	{
		txt1.string = "                                     ...ELGFEB XJOJITK XKLFKL YVA JNA !?EM XJPDFJ XVA";// אתם יודעים מה?! אני אתן לכולכם כרטיסים בהוזלה...
		txt2.string = "                                                    !!TJEGM JNA STME WFVL XKL STA JNA";// אני ארק לכם לתוך המרק אני מזהיר!!
		txt3.string = "                                            ?FTSJM XPQ XVJAT....LBH ,EQ ZTUA JNA FATV";// תראו אני אשרף פה, חבל....ראיתם פעם מיקרו?
	}

	if (DialogIndex == 17)
	{
		txt1.string = "                                             ...PCTK JLRA UJCT VRS AUFN EG YJHVFT XJM";// מים רותחין זה נושא קצת רגיש אצלי כרגע...
		txt2.string = "                                        (.YAK FRHL .FL OAMN TBKU JML SHUML TJEM XFJO)";// (סיום מהיר למשחק למי שכבר נמאס לו. לחצו כאן.)
		txt3.string = "                                                   YFNMA VA TJKM JNA JVFA YBOM EVA EM";// מה אתה מסבן אותי אני מכיר את אמנון
	}

	if (DialogIndex == 18)
	{
		txt1.string = "                                            ...JLP FPMU TBK XEF JVPCE ST ,EAFT EVA FN";// נו אתה רואה, רק הגעתי והם כבר שמעו עלי...
		txt2.string = "                                                      ...YFTMLFI LU XJNFITS JNU JL YV";// תן לי שני קרטונים של טולמרון...
		txt3.string = "                            ?E'RHNF ELRS LU YFNU CAC XP DFP LU XPIB SJIOM ETSMB WL UJ";// יש לך במקרה מסטיק בטעם של עוד עם גאג שנון של קצלה ונחצ'ה?
	}

	if (DialogIndex == 19)
	{
		txt1.string = "                                                               ?JNNSM VUTM JNN LJTB'C";// ג'בריל נני מרשת מקנני?
		txt2.string = "                                  ...VFONL XKL LBH ,VOQFVB EGK [QO JNA XKL LBH ,OPTBH";// חברעס, חבל לכם אני ספץ כזה בתופסת, חבל לכם לנסות...
		txt3.string = "                              FJUKP DMJM VLVB JNA FNJBV ,DFAM TPIRM JNA JFKJO XKL YJA";// אין לכם סיכוי אני מצטער מאוד, תבינו אני בתלת מימד עכשיו
	}

	if (DialogIndex == 20)
	{
		txt1.string = "                                        ....EKJMU XCF XJLQLQ CJUEL TUQA EQJA PDFJ JNA";// אני יודע איפה אפשר להשיג פלפלים וגם שמיכה....
		txt2.string = "                                                         .JGH UFQJQ ,FUHNVU LBH AL AL";// לא לא חבל שתנחשו, פיפוש חזי,
		txt3.string = "                                            ...XKL JADK FLAUV...EQ JNA EML JVFA FLAUV";// תשאלו אותי למה אני פה...תשאלו כדאי לכם...
	}

	if (DialogIndex == 21)
	{
		txt1.string = "                                                             ? YAK BFUHL UJ TBK EM LP";// על מה כבר יש לחשוב כאן ?
		txt2.string = "                                                                  ... EJPB YJA ?BFUHL";// לחשוב? אין בעיה ...
		txt3.string = "                                                                          ?XJBUFH XVA";// אתם חושבים?
	}

	if (DialogIndex == 22)
	{
		txt1.string = "                                             ...FGK ELHM JL UJ...JLRA JBJISLO DFAM EG";// זה מאוד סלקטיבי אצלי...יש לי מחלה כזו...
		txt2.string = "                                 ..JOFBJE OJSTNL LLE TJU - EG VA [JTV EMJDS FN ,YK YK";// כן כן, נו קדימה תריץ את זה - שיר הלל לנרקיס היבוסי..
		txt3.string = "                               XJJNGFA XP JVFA FTJJR AL DMJM VLVB XC XA YJGAA JNA WJA";// איך אני אאזין אם גם בתלת מימד לא ציירו אותי עם אוזניים
	}

	if (DialogIndex == 23)
	{
		txt1.string = "                                          .FQI.... VFLSB DFAM JL AB ASFFD XKJLP SFTJL";// לירוק עליכם דווקא בא לי מאוד בקלות ....טפו,
		txt2.string = "                                      .EGB XJBFI AL XVA - ENFB VTFSJB VRS XKL YVA JNA";// אני אתן לכם קצת ביקורת בונה - אתם לא טובים בזה.
		txt3.string = "                                   XJVPU LK SJU TML TUSVEL JVBJJHVE !XJJMUM ELBAG WFA";// אוך זאבלה משמיים! התחייבתי להתקשר למר שיק כל שעתים
	}

	if (DialogIndex == 24)
	{
		txt1.string = "                                                                 ....XFLU YFJSJN VFTU";// שרות ניקיון שלום....
		txt2.string = "                                                    ...ESJTMAL WTDB JNA YK YK ?SJU TM";// מר שיק? כן כן אני בדרך לאמריקה...
		txt3.string = "                                                                       ...JL TQOM EVA";// אתה מספר לי...
	}

	if (DialogIndex == 25)
	{
		txt1.string = "                                                 ?AL FA DTQNB XJSRFJ DKE LU VJVHVE VA";// את התחתית של הכד יוצקים בנפרד או לא?
		txt2.string = "                                        PBIE VFTFMU VFUT LU WMOFM OTFS JVTBP !ECAD LA";// אל דאגה! עברתי קורס מוסמך של רשות שמורות הטבע
		txt3.string = "                                                          ?VFTJQ XJLKFA ?XJUFP XVA EM";// מה אתם עושים? אוכלים פירות?
	}


	if (DialogIndex == 26)
	{
		txt1.string = "                                          ....HHHQ...XJLPTFM XJNIFB LFKAL WJUMV XA AL";// לא אם תמשיך לאכול בוטנים מורעלים...פחחח....
		txt2.string = "                                    ...WL FTBP VFJNU JVU TBK ,EALME OFKE JRH LP BFUHV";// תחשוב על חצי הכוס המלאה, כבר שתי שניות עברו לך...
		txt3.string = "                                                   ...XJJHB LKE YJA...PDFJ JM PDFJ JM";// מי יודע מי יודע...אין הכל בחיים...
	}


	if (DialogIndex == 27)
	{
		txt1.string = "                              LAMUL YJMJM..WFQE LKE XJATFS FNHNA VJTBPB LBA 29 YB JNA";// אני בן 29 אבל בעברית אנחנו קוראים הכל הפוך..מימין לשמאל
		txt2.string = "                                                                    ...JHFTB UJUS JNA";// אני קשיש ברוחי...
		txt3.string = "                                                    XJNQ JHFVJN EG LKE JLRA ,JL YJMAV";// תאמין לי, אצלי הכל זה  ניתוחי פנים
	}


	if (DialogIndex == 28)
	{
		txt1.string = "                                 ...OOOO...YFKN YAKM AL JNAU EATNK YK GA ,PCTK JVONKN";// נכנסתי כרגע, אז כן כנראה שאני לא מכאן נכון...סססס...
		txt2.string = "                                                              ETJUJE WTDE VA EONA JNA";// אני אנסה את הדרך הישירה
		txt3.string = "                                                      ?XJQDFP SJIOLQ JBUFM EMK XKL UJ";// יש לכם כמה מושבי פלסטיק עודפים?
	}


	if (DialogIndex == 29)
	{
		txt1.string = "                               JLU CFLFKJOQE XHNM LU TFSJB OJITKE VA WL YVA JNA ,EATV";// תראה, אני אתן לך את הכרטיס ביקור של מנחם הפסיכולוג שלי
		txt2.string = "                                      FBGPJ XJUNA...WL TMFA JNA EGE TBDK PMUN AL ,JMP";// עמי, לא נשמע כדבר הזה אני אומר לך...אנשים יעזבו
		txt3.string = "                    ERHNF ELRS LU EHJDB LU XPIB SJIOM DFP OJKB JL UJ JLFA XJKHMU YMGB";// בזמן שמחכים אולי יש לי בכיס עוד מסטיק בטעם של בדיחה של קצלה ונחצה
	}


	if (DialogIndex == 30)
	{
		txt1.string = "                                                        ZFLAE XP FJUKP TBDM EVA JBFBH";// חבובי אתה מדבר עכשיו עם האלוף
		txt2.string = "                             ...EGE SHUMB VJVJMA ETJHB JL UJU FLJAK ,JVFA XFUTL AL AL";// לא לא לרשום אותי, כאילו שיש לי בחירה אמיתית במשחק הזה...
		txt3.string = "                       .SJTOM TKJK LU XJPTFRME YFDPFMB VFTBHE XP JL UCNVM AL EG XA ST";// רק אם זה לא מתנגש לי עם החברות במועדון המצורעים של כיכר מסריק.
	}

	if (DialogIndex == 31)
	{
		txt1.string = "                                           XGCFM TBK EG LBA...XJRJTPM JL UJU PDFJ JNA";// אני יודע שיש לי מעריצים...אבל זה כבר מוגזם
		txt2.string = "                                                    ...VJMTAB TRS IQUM WL DJCEL JL YV";// תן לי להגיד לך משפט קצר בארמית...
		txt3.string = "                                           ...XFLE DP JNFAJBEU JM LKL VFDFEL ERFT JNA";// אני רוצה להודות לכל מי שהביאוני עד הלום...
	}


	if (DialogIndex == 32)
	{
		txt1.string = "                                                 EGE XFJE XRP DP TUFPF TUFAB XJJH XEF";// והם חיים באושר ועושר עד עצם היום הזה
		txt2.string = "                                                        ...EIJLS YJA ...ATFN EG AL AL";// לא לא זה נורא... אין קליטה...
		txt3.string = "                            !WFMKU SSFLM YFNR WLU XJNFQLIE LK XP ENJTS JL EUFP EVA JD";// די אתה עושה לי קרינה עם כל הטלפונים שלך צנון מלוקק שכמוך!
	}


	if (DialogIndex == 33)
	{
		txt1.string = "                                          ...LLKB EG JM...JL XJATFS WJA JL XJATFS WJA";// איך קוראים לי איך קוראים לי...מי זה בכלל...
		txt2.string = "                                                                !?JNMM ERFT EVA EM EM";// מה מה אתה רוצה ממני?!
		txt3.string = "                                 ..PCFUM EVAU JJHB ,PCFUM EGJA...HHHQ,PCFUM WL XJATFS";// קוראים לך משוגע,פחחח...איזה משוגע, בחיי שאתה משוגע..
	}


	if (DialogIndex == 34)
	{
		txt1.string = "                                                                      .VKLL HTKFM JNA";// אני מוכרח ללכת.
		txt2.string = "                            ...JVFA DJTFV ,JQFJ ....OOOQ ?VMAB ,JD ?VMAB EM ? VMAB EA";// אה באמת ? מה באמת? די, באמת? פססס.... יופי, תוריד אותי...
		txt3.string = "                            ...JLU TMGHML XFJE JVNMAVE AL DFPU JL TJKGM EG IFUQ EHJLO";// סליחה פשוט זה מזכיר לי שעוד לא התאמנתי היום למחזמר שלי...
	}

	if (DialogIndex == 35)
	{
		txt1.string = "                                ...FNVFA XJUQHM JLFA XJDDRL XC LKVOV EBFI JL EUPV ,YK";// כן, תעשה לי טובה תסתכל גם לצדדים אולי מחפשים אותנו...
		txt2.string = "                                             ?JLU UATE LP LITCAE SJQOM AL !ATSFB-LPNJ";// ינעל-בוקרא! לא מספיק האגרטל על הראש שלי? 
		txt3.string = "                                                            !JNMM DTV ENAFB !JNMM DTV";// תרד ממני! בואנה תרד ממני!
	}

	if (DialogIndex == 36)
	{
		txt1.string = "                                                                        JLU AFE JVARM";// מצאתי הוא שלי
		txt2.string = "                                        ?'QATSEGJF' YAK XJDBKM XVA ,FVFA JL TFKMV AFB";// בוא תמכור לי אותו, אתם מכבדים כאן "ויזהקראפ"?
		txt3.string = "                                   ...ELAUE VJJTQO FMK ,TJGHAF FB UMVUA JNA AFB ,BFGP";// עזוב, בוא אני אשתמש בו ואחזיר, כמו ספריית השאלה...
	}


	if (DialogIndex == 37)
	{
		txt1.string = "                                                          LBMI AJ ,ENMGEL EKHM EVA EM";// מה אתה מחכה להזמנה, יא טמבל
		txt2.string = "                                    ...OPVEL JM XP YJA ,DBL CFCHV JL YJMAV ,DBL CFCHV";// תחגוג לבד, תאמין לי תחגוג לבד, אין עם מי להתעס...
		txt3.string = "                                     ?ZFSUME WTD FLJQA ONKN AL EVA XA WVFA FNJMGJ WJA";// איך יזמינו אותך אם אתה לא נכנס אפילו דרך המשקוף?
	}


	if (DialogIndex == 38)
	{
		txt1.string = "                                       .XJGFTHL JPBI YFTUJK UJ EUNM JLU CFLFKJOQL JFA";// אוי לפסיכולוג שלי מנשה יש כישרון טבעי לחרוזים.
		txt2.string = "                          XJGFTH EL AFRML LS TVFJU ELJMB GFQV ELJME VA ZJLHV PDFJ JNA";// אני יודע תחליף את המילה תפוז במילה שיותר קל למצוא לה חרוזים
		txt3.string = "                                                      ?GFT YJLFM ITOE VA VJAT JL DJCV";// תגיד לי ראית את הסרט מולין רוז?
	}


	if (DialogIndex == 39)
	{
		txt1.string = "                                                .XKB ETFJ JVJJE ,EBFT YAK EJEF JAFFLE";// הלוואי והיה כאן רובה, הייתי יורה בכם.
		txt2.string = "                                                      ...XJPCFUME VJBB EUJCQ ...HHHHQ";// פחחחח... פגישה בבית המשוגעים...
		txt3.string = "                                               .JL YJA YFJUT FLJQA VJNFKM WJTR JNA EM";// מה אני צריך מכונית אפילו רשיון אין לי.
	}


	if (DialogIndex == 40)
	{
		txt1.string = "                                                                   !LPFC EGJA JD OKJA";// איכס די איזה גועל!
		txt2.string = "                                                ...ZAB FEUM WL PSVNU BUFH JNA EJNU ST";// רק שניה אני חושב שנתקע לך משהו באף...
		txt3.string = "                                                           !ZA HFVN EUPV ?EM PDFJ EVA";// אתה יודע מה? תעשה נתוח אף!
	}

	if (DialogIndex == 41)
	{
		txt1.string = "                                               .XJBTFP XFU YAK YJA .WVFA FHSJ AL XLUV";// תשלם לא יקחו אותך. אין כאן שום עורבים.
		txt2.string = "                                       ?[FMH YFQQLM XP WDVUEL ERTV JLFA !STJ EVA ,JFA";// אוי, אתה ירק! אולי תרצה להשתדך עם מלפפון חמוץ?
		txt3.string = "                                      ?FGE EJNBCPE XP TBDL WJTR VMAB JNA ,JMP ,PCT ST";// רק רגע, עמי, אני באמת צריך לדבר עם העגבניה הזו?
	}

	if (DialogIndex == 42)
	{
		txt1.string = "                                                    .WVFA OQAJ FEUJMU EG WJTR EVAU EM";// מה שאתה צריך זה שמישהו יאפס אותך.
		txt2.string = "                                           ...VRS EG LP JVBUH ,VFQQFSVEE YJJNPB ,EATV";// תראה, בעניין ההתקופפות, חשבתי על זה קצת...
		txt3.string = "                                ?PBR EGJAB DJCV ST EJPB YJA !LJLHD WL CJUA JNA ?LJLHD";// דחליל? אני אשיג לך דחליל! אין בעיה רק תגיד באיזה צבע?
	}


	if (DialogIndex == 43)
	{
		txt1.string = "                                  .EHJU FNLHVE ,FUJI WJLP JVSTG .LBG HQ EVA ,EATN AFB";// בוא נראה, אתה פח זבל. זרקתי עליך טישו, התחלנו שיחה. 
		txt2.string = "                                                      ?XJNQB OTH DK WL UJ JLFA  ,PMUV";// תשמע,  אולי יש לך כד חרס בפנים?
		txt3.string = "                                                        ...VHQE LA HQE YM XJTMFAU FMK";// כמו שאומרים מן הפח אל הפחת...
	}


	if (DialogIndex == 44)
	{
		txt1.string = "                                                            ?QFTJO JLP VKQU ,VJJHB EM";// מה בחיית, שפכת עלי סירופ?
		txt2.string = "                                  !EGE TDFFOE XP XFJE CJREL DFP WJTR JNA ,ESNV TEM FN";// נו מהר תנקה, אני צריך עוד להציג היום עם הסוודר הזה! 
		txt3.string = "                                                    ...VJVVFQJE ELAU ?YK OTH JDK EATV";// תראה כדי חרס כן? שאלה היפותתית...
	}

	if (DialogIndex == 45)
	{
		txt1.string = "                                                                                  ?AE";// הא?
		txt2.string = "                            JL WFOHV VMAB GA EGE XFSMB VFJLFLVJEEM VHA DFP EG XA EATV";// תראה אם זה עוד אחת מההיתלוליות במקום הזה אז באמת תחסוך לי
		txt3.string = "                                                               ..ILO OQJR JVLKA LFMVA";// אתמול אכלתי ציפס סלט..
	}

	if (DialogIndex == 46)
	{
		txt1.string = "                                                          .JMRPB EDNQ JPBR LU UJA JNA";// אני איש של צבעי פנדה בעצמי.
		txt2.string = "                                                           ?EGK JIOJLFE WJTDM EVA !EA";// אה! אתה מדריך הוליסטי כזה?
		txt3.string = "                                                    !IOJJTS OFGJ'C EVA !IOJJTS OFGJ'C";// גיזוס קרייסט! אתה גיזוס קרייסט!
	}


	if (DialogIndex == 47)
	{
		txt1.string = "                                              DMJM VLVB WVFA JVJEJG JUFSB ?PMUN EM FN";// נו מה נשמע? בקושי זיהיתי אותך בתלת מימד
		txt2.string = "                                              ....YJJNFPM ALE  VA SHUAF XKHVA JNA BFI";// טוב אני אתחכם ואשחק את  הלא מעוניין....
		txt3.string = "                                          VTFUSV JUFBJU XP FIFLE VFARFV LP XDSFM PDJM";// מידע מוקדם על תוצאות הלוטו עם שיבושי תקשורת
	}


	if (DialogIndex == 48)
	{
		txt1.string = "                                             !!!EKK JLA TBDV LA WLU OJSTNE AL JNA SJU";// שיק אני לא הנרקיס שלך אל תדבר אלי ככה!!!
		txt2.string = "                                         ...E'RHNF ELRS LU VFHJDBE TOMLIL XVPCE ,XFLU";// שלום, הגעתם לטלמסר הבדיחות של קצלה ונחצ'ה...
		txt3.string = "                                ...JLRA WLU DKE !AVUSUJS LFKA WMM DHQM AL JNA AFB AFB";// בוא בוא אני לא מפחד ממך אכול קישקשתא! הכד שלך אצלי...
	}


	if (DialogIndex == 49)
	{
		txt1.string = "                                                         WVFA JVOQV SFJDB AL ?EM ,?EM";// מה?, מה? לא בדיוק תפסתי אותך
		txt2.string = "                                                               ...ECREB GP XPQ JVSHJU";// שיחקתי פעם עז בהצגה...
		txt3.string = "                                                       ...JL ERR ELAU XVO ,YMTB IIIOQ";// פסטטט ברמן, סתם שאלה צצה לי...
	}


	if (DialogIndex == 50)
	{
		txt1.string = "                                   .XJJBTP XJTQK LU VFMU YNUM JNA .YMGB VPCE SFJDB FA";// או בדיוק הגעת בזמן. אני משנן שמות של כפרים ערביים. 
		txt2.string = "                                          ?VJNLKL VRLMFME XJME VFMK JEM PDFJ EVA JLFA";// אולי אתה יודע מהי כמות המים המומלצת  לכלנית?
		txt3.string = "                        'DM BLFS' BALSJTINAS LU EKJTBB JLU JFNML DFAM JL JNFJH SJQFQE";// הפופיק חיוני לי מאוד למנוי שלי בבריכה של קאנטריקלאב 'קולב מד'
	}



	if (DialogIndex == 51)
	{
		txt1.string = "                            .SJQFQE VA JL XJARFM DRJK VFQRLF YAK TAUJEL ZJDPM JNA ,AL";// לא, אני מעדיף להישאר כאן ולצפות כיצד מוצאים לי את הפופיק.
		txt2.string = "                                                ...VFJFQJDP JTDO LU YJJNP EG LKE EATV";// תראה הכל זה עניין של סדרי עדיפויות...
		txt3.string = "                             !?AL SJQFQE VARFE LU ENJROB LJQK LP FNTBJD JMP ,PCT EJNU";// שניה רגע, עמי דיברנו על כפיל בסצינה של הוצאת הפופיק לא?!
	}


	if (DialogIndex == 52)
	{
		txt1.string = "                                                                                 1234";// 1234
		txt2.string = "                                                                     ....WVFA PMUN FN";// נו נשמע אותך....
		txt3.string = "                                           ...!LAQN VARMN VUBJ EGJAB JVFA JLAUV ,JBGP";// עזבי, תשאלי אותי באיזה יבשת נמצאת נפאל!...
	}


	if (DialogIndex == 53)
	{
		txt1.string = "                                                             !XJHTQ JTFBRM DJL VTFFKB";// בכוורת ליד מצבורי פרחים!
		txt2.string = "                                   ELPM ELPM YEL VFRQFSF EAFFS EAFFS VFUFP XEF !ERJBB";// בביצה! והם עושות קוואה קוואה וקופצות להן מעלה מעלה
		txt3.string = "                                                                 .VTFFKM [FH XFSM LKB";// בכל מקום חוץ מכוורת.
	}


	if (DialogIndex == 54)
	{
		txt1.string = "                                                                 ?ZJNOM EVA EM ?ZJNOM";// מסניף? מה אתה מסניף?
		txt2.string = "                                                                   ?EQ TKFM EVA EM GA";// אז מה אתה מוכר פה?
		txt3.string = "                                   ...FN JD !?HJLRM VMAB EVA EM !?XJSOPB VHLRE EVA EM";// מה אתה הצלחת בעסקים?! מה אתה באמת מצליח?! די נו...
	}


	if (DialogIndex == 55)
	{
		txt1.string = "                                               !YHLFUL VHVM WLRA EUPNU EM VA JL WFOHV";// תחסוך לי את מה שנעשה אצלך מתחת לשולחן!
		txt2.string = "                                 ...XJBFIE XJMJE TKGL ,EKK EHNE EGJA JL EUPV ENFAB GA";// אז באונה תעשה לי איזה הנחה ככה, לזכר הימים הטובים...
		txt3.string = "                                                          ...ETGP WMM WTIRA JNAU HJNN";// נניח שאני אצטרך ממך עזרה...
	}

	if (DialogIndex == 56)
	{
		txt1.string = "                             ?XJNQB UJ EM FJUKP [JREL TUQA EHFVQ WLU VFNHE YFLME LENM";// מנהל המלון החנות שלך פתוחה אפשר להציץ עכשיו מה יש בפנים?
		txt2.string = "                                                                         !EKLME JVUFF";// וושתי המלכה!
		txt3.string = "                                    ?EHFVQE VFNHE WFVB WL UJ EM [JREL TUQA YFLME LENM";// מנהל המלון אפשר להציץ מה יש לך בתוך החנות הפתוחה?
	}
}

function SetDialog (X)
{
	DialogIndex = DialogIndex + 1;
}

function ShowDialog
{
	DialogChoice = 0;
	SetDialogOptions();
	ShowText();
	Dialog.visible = on;
}