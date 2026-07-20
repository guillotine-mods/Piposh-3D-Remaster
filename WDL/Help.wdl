// Game Help

bmap bHlp1 = <Help1a.pcx>;
bmap bHlp2 = <Help1b.pcx>;
bmap bHelp = <Help2.pcx>;

panel pHelp
{
	layer = 8;
	bmap = bHelp;
	flags = refresh,d3d,overlay;

	BUTTON 5,410,bhlp1,bhlp2,bhlp1,CloseHelp,NULL,NULL;
}

text tHelp
{
	font = standard_font;
	layer = 9;
	pos_x = 250;
	pos_y = 60;
	strings = 20;
}

function CloseHelp
{
	pHelp.visible = off;
	tHelp.visible = off;
	freeze_mode = 0;
}

function SetHelp
{
	var HasHelp = 0;

	if (str_cmpi(app_name,"asyact1") == 1)
	{
		tHelp.string[0] = "                               XJPCFUME VJBL EOJNK\n";
		tHelp.string[1] = "                      VJB WFVL TFDHL YJJNFPM UFQJQ";
		tHelp.string[2] = "               LITCAE TBU VA AFRML VNM LP XJPCFUME\n";
		tHelp.string[3] = "VJBL ONKJELF SAMGFQ VFHAE VA VFMTL XJKTD AFRML FON";
		tHelp.string[4] = "                                          XJPCFUME\n";
		tHelp.string[5] = "                              EJAT VJFFG ENUM - f1";
		tHelp.string[6] = "                 JTFINBNJAE SJV VA TCFOF HVFQ - f2";
		tHelp.string[7] = "     THA VHSL TUQAMF DJB SJGHM EVAU [QH TTHUM - f3";
		tHelp.string[8] = "       WMRP LP XJRQH VFONL JDK EG USM LP FRHL -  u\n";
	        tHelp.string[9] = "   XJTHA XJRQH LP XJRQH LJPQEL FKTIRV XJTSMEM SLHB";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"asyact2") == 1)
	{
		tHelp.string[0] = "                              XJPCFUME VJBB UFQJHE\n";
		tHelp.string[1] = "                               LITCAE TBU VA FCJUE\n";
		tHelp.string[2] = "                              EJAT VJFFG ENUM - f1";
		tHelp.string[3] = "                 JTFINBNJAE SJV VA TCFOF HVFQ - f2";
		tHelp.string[4] = "      THA VHSL TUQAMF DJB SJGHM EVAU [QH TTHUM- f3\n";
		tHelp.string[5] = "               TBKP LU JNMJE TFVQKE LP ERJHL VTGPB";
		tHelp.string[6] = "                                  XJPCFUME XP FTBD\n";
		tHelp.string[7] = "                     LFLRL JGHL XJTUQAM - home,end";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"asyact3") == 1)
	{
		tHelp.string[0] = "                           XJPCFUME VJBB XFTJH BRM\n";
		tHelp.string[1] = "               ETGHB XJPCFUME LK VA OJNKEL - ETIME";
		tHelp.string[2] = "                FRHL ,XJAVB XLFKU PCTB .XELU XJAVL";
		tHelp.string[3] = "              .XFTJHE BRM LFIJBL TJSE LP TFVQKE LP\n";
		tHelp.string[4] = "                                  XJSUN ZJLHM - f1";
		tHelp.string[5] = "               ETFJ VDLSM-YFBUHMB OQA TFVQK - ctrl\n";
		tHelp.string[6] = " YVFA TFCOLF HFVQL JDK TBKPE XP XJAVE VFVLD LP [HL\n";
		tHelp.string[7] = "                        IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"cardgame") == 1)
	{
		tHelp.string[0] = "                                      TSFQ-GFQGFQ\n";
		tHelp.string[1] = "    XJQLSE LP [HL GAF XJQLSE VSFLHL ELJBHE LP [HL";
		tHelp.string[2] = "         BUHMEF ELJBHE LP BFU GAF TFMUL ERFT EVAU";
		tHelp.string[3] = "                 VTMU ALU FLA XFSMB XJQLS WL SLHJ\n";
		tHelp.string[4] = " 4 VSGHB EFBC JKE ZLSE :CFO FVFAM BSFP TDOB XJQLS";
		tHelp.string[5] = "   XJQLSE LK WTP VLQKE :ENFU CFOM BSFP TDOB XJQLS";
		tHelp.string[6] = "4 VSGHB TVFJB WFMNE ZLSE :CFO FVFAM XLFK :XLU TDP";
		tHelp.string[7] = "              XELU XJKTPE VLQKE :TQOM FVFAM XJQLS";
		tHelp.string[8] = "                XJQLSE WTP TFBJH :CFO FVFAM XJQLS";
		tHelp.string[9] = "              XKTP VTOHE :XJDDFB VJIBJI EMEB JQLS";
	       tHelp.string[10] = " VFJIBJIE VFMEBE TQOMB EARFVE VLQKE ,XJNFQ YJA XA\n";
	       tHelp.string[11] = "    WFQEJ AFE VJIBJI EMEB LU DHA ZLS ZFOB TAUN XA";
	       tHelp.string[12] = "                                       DHFJM ZLSL\n";
	       tHelp.string[13] = "       DJOQM AFE FLU OFKB ESUME LK VA EVFU JGH XA";
	       tHelp.string[14] = " XEJVFOFK VA FNSFTJ XJTHVME LKU WJTR AFE HRNL JDK\n";
               tHelp.string[15] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"desert") == 1)
	{
		tHelp.string[0] = "                                     PFNISB EPJON\n";
		tHelp.string[1] = "            .VFQLFH VFJNFKMF XJUSFMF XJLJIM TEGJE";
		tHelp.string[2] = "    FDPJ LA PJCJ UFQJQU DP TBKPE VTGPB PFOJL WUME\n";
		tHelp.string[3] = "                      IJ'R OJNKEL WL TUQAM  - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"fight") == 1)
	{
		tHelp.string[0] = "                                XJLABJNS VFUUFCVE\n";
		tHelp.string[1] = "                                       ETJVOL - z";
		tHelp.string[2] = "                                       EIJPBL - x";
		tHelp.string[3] = "                                 VBBFOM EIJPB - c";
		tHelp.string[4] = "                                        EJOAT - v\n";
		tHelp.string[5] = "                   .XVFA HSJ UFQJQF XJRQH LP FTBP";
		tHelp.string[6] = "            XVFA WJLUEL VNM LP XJUSME DHA LP FRHL\n";
		tHelp.string[7] = "                      IJ'R OJNKEL WL TUQAM  - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"final") == 1)
	{
		tHelp.string[0] = "                           SIOFBLB LU ELJFB EMJHL\n";
		tHelp.string[1] = "             .ZFTPMF SJN'RFFS XJNKFOE JNU VA FLOH";
		tHelp.string[2] = "   LDHJU VFNMDGJEE VA FLRN .XJLJJHE VFJTJM FTEGJE";
		tHelp.string[3] = "        VFTJL XJSJOQM XLFK GA JK WOB TBFP SIOFBLB\n";
		tHelp.string[4] = "                        XJMFOHME VA XJNKFOL FOTJE\n";
		tHelp.string[5] = "                                EJJTJ JLAMU TFVQK\n";
		tHelp.string[6] = "             VJBHE JTFHAM ST LPFQ .ZQFKVM EIML [H\n";
		tHelp.string[7] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"golf") == 1)
	{
		tHelp.string[0] = "                                      XJUJUS ZLFC\n";
		tHelp.string[1] = "                                     OJNKEL XKJLP";
		tHelp.string[2] = "                    XFMJOSMEM VFKM VFHQB TFDKE VA";
		tHelp.string[3] = "                  FPBS JLAMUE TFVQKE VTGPB .ELPML";
		tHelp.string[4] = "            .EVMRFP VA EABE ERJHLBF EKME YFFJK VA\n";
		tHelp.string[5] = "                         EJATE VDFSN VA ENUM - f1";
		tHelp.string[6] = "                            TFDKE YKJE PJBRM - f2";
		tHelp.string[7] = "                                   ELA ZJLHM - f3\n";
		tHelp.string[8] = "                              ZJLHM JLAMUE TFVQKE";
		tHelp.string[9] = "               .EKM LU BRML EKME YFFJK LU BRM YJB\n";
	       tHelp.string[10] = "                              XPQ LK .HFTB FBUHVE";
	       tHelp.string[11] = "            .FNVUE YFFJKEF EMRFPE HFT LU LJLR UJU\n";
	       tHelp.string[12] = "                                           :VFLSM\n";
	       tHelp.string[13] = "   BTSVEL JDK ELHVEB UMVUE ,ESGH EKM - 1 TQOM LSM";
	       tHelp.string[14] = "BTSVM EVAUK UMVUE ,VJVUS VJNFNJB EKM - 2 TQOM LSM";
	       tHelp.string[15] = "  LFHE VJLFLVB EVAUK UMVUE ,EULH EKM - 3 TQOM LSM\n";
	       tHelp.string[16] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"hitufo") == 1)
	{
		tHelp.string[0] = "                                            u.f.o\n";
		tHelp.string[1] = "                                   VFKM VVL ETIME";
		tHelp.string[2] = "               SJTBMF UDH JNCQA ZLS OTQE .XJNRFHL\n";
		tHelp.string[3] = "                                            VTGPB";
		tHelp.string[4] = "           DBLB XJTGJJHE VA FKE XJNFOKLAEF XJRJHE";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"inshrine") == 1)
	{
		tHelp.string[0] = "                                       EMDAL VHVM\n";
		tHelp.string[1] = "                                      AFRML XKJLP";
		tHelp.string[2] = "               HVQJ DHA .XEJLP [FHLLF XJTFVQK JNU";
		tHelp.string[3] = "               TUCE VA LJPQJ DHAF VJGKTME VLDE VA";
		tHelp.string[4] = "                   AL BFUH YKL IAL IAL ELPV EBALE";
		tHelp.string[5] = "              EGE XFSMB SJNSJQ VFUPLF XVO EMEMVEL\n";
		tHelp.string[6] = "                XJBRJJM TUA DP VFSVFUM VFJLPME LK";
		tHelp.string[7] = "               TFVQKB ELPML FPJBRJU XJRJHE JNU VA\n";
		tHelp.string[8] = "                             EJAT VJFFG ENUM - f1";
		tHelp.string[9] = "                                     ERJT - shift";
	       tHelp.string[10] = "              [FQSJ UFQJQF EG USM LP ERJHL - home";
	       tHelp.string[11] = "                     EIML LKVOM UFQJQ - page-down";
	       tHelp.string[12] = "                    ELPML LKVOM UFQJQ -   page-up\n";
	       tHelp.string[13] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"mine") == 1)
	{
		tHelp.string[0] = "                                    ETKMB VJNFTSE\n";
		tHelp.string[1] = "              LFLOME ZFO DP FDTUF XJLFUKMM FTEGJE\n";
		tHelp.string[2] = "                             EJAT VJFFG ENUM - f1";
		tHelp.string[3] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"mount") == 1)
	{
		tHelp.string[0] = "                                TEE UAT LU VOJJIE\n";
		tHelp.string[1] = "                             EJAT VJFFG ENUM - f1";
		tHelp.string[2] = "            ELSEL FVFA TJGHMF LNAQE VA XJLPM - f2\n";
		tHelp.string[3] = "         XJTFJ TBKPE LU JLAMU TFVQK FA - spacebar";
		tHelp.string[4] = "                      VVJJBVM EKTB VRRQ TCUM -  b";
		tHelp.string[5] = "     VQQFPVM EKTBU JTHA YFLHE VA EATMF XJLPM -  v\n";
		tHelp.string[6] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"race") == 1)
	{
		tHelp.string[0] = "                               XJUJUS VBJKT [FTJM\n";
		tHelp.string[1] = "       EUFLU XNUJ .YFUAT XFSML [FTJMB PJCEL XKJLP";
		tHelp.string[2] = "              LNAQBU ELPMLM VJFGB FTGPJE .XJBFBJO";
		tHelp.string[3] = "             .XJTUCE LK WTD TFBPL XJKJTR !BL FMJU";
		tHelp.string[4] = "                                 OTBTB PFOJL YVJN\n";
		tHelp.string[5] = "                               VJFGE VA ENUM - f1";
		tHelp.string[6] = "                BJBOM LNAQE VA XJLPEL VNM LP - f2\n";
		tHelp.string[7] = "          EVFA DJTFM EIML [H VFTJEM ELPM ELPML [H\n";
		tHelp.string[8] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"range") == 1)
	{
		tHelp.string[0] = "                                     OFIMB XJQIFH\n";
		tHelp.string[1] = "                       XJUNA VFHQU EMK LOHL ETIME";
		tHelp.string[2] = "             OME VA ST FMJTU VFHQL FA...PUQM XJQH\n";
		tHelp.string[3] = "          FTJ JLAMUE TFVQKE VTGPBF TBKPE XP FNFFK";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"shooter") == 1)
	{
		tHelp.string[0] = "                                VFQMFQB EJTJ ERSM\n";
		tHelp.string[1] = "                      XJLBSM TJFFAB YSGB XJTFJ XA";
		tHelp.string[2] = "                JA EQRJTE LP VHN YSGUK .HFK OFNFB";
		tHelp.string[3] = "             EQMFQE XP SJHTEL ST FNMM TVQJEL TUQA\n";
		tHelp.string[4] = "                           EQMFQ ETFJ JLAMU TFVQK\n";
		tHelp.string[5] = "                       IJ'R OJNKEL WL TUQAM - tab";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"town") == 1)
	{
		tHelp.string[0] = "                           JIJOGFQGFQ ELFDCE TJPE\n";
		tHelp.string[1] = "                                         ENBJM LK";
		tHelp.string[2] = "              EJRSATINJA FB VFUPL YVJN [HB YMFOME\n";
		tHelp.string[3] = "                    TJPB THA BFHTM IBML TJBPM - v";
		tHelp.string[4] = "                  XJPBU LU TCAM WFVM EHJDB VPJMUL";
		tHelp.string[5] = "           XEJLA XJBFTS XVAUK E'RHNF ELRS LP FRHL\n";
		tHelp.string[6] = "            VQSUME XFGB XJILFU ETFHA [HF EMJDS [H";
		HasHelp = 1;
	}

	if (str_cmpi(app_name,"ziggy") == 1)
	{
		tHelp.string[0] = "                           DMJM VLVB IOJITSE JCJG\n";
		tHelp.string[1] = "               .XJBJJFA LU XJJFOM TQOM LOHL ETIME";
		tHelp.string[2] = "                 J\"P ST VFRQFSU VF'CNJN LOHL YVJN";
		tHelp.string[3] = "            EKM J\"P ST EKM VFNVFNU VF'CNJN ,ERJQS\n";
		tHelp.string[4] = "           ERJQS J\"P ST ILMJEL YVJN E'CNJN JBKFKM\n";
		tHelp.string[5] = "                                        ZFTCA - z";
		tHelp.string[6] = "                                        EIJPB - x";
		tHelp.string[7] = "                                        ERJQS - c";
		HasHelp = 1;
	}

	if (HasHelp != 1)
	{
		tHelp.string[0] = "                                     XJJLLK XJUSM\n";
		tHelp.string[1] = "                     EIML LKVOM UFQJQ - page-down";
		tHelp.string[2] = "                    ELPML LKVOM UFQJQ -   page-up\n";
		tHelp.string[3] = "                         [FTL JDKB FUMVUE - shift";
		tHelp.string[4] = "                  XJBLUEM SLHB [FQSJ UFQJQ - home\n";
		tHelp.string[5] = "                                             FRHL";
		tHelp.string[6] = "            CJREL VNM LP TBKPE LU JNMJE TFVQKE LP";
		tHelp.string[7] = "              XJTBD LP [FHLL FLKFV FVTGPB YMOE VA\n";
		tHelp.string[8] = "                                      VTGPB - < >";
		tHelp.string[9] = "               DRE LP VKLL LKFJ UFQJQ FLA XJTFVQK\n";
		tHelp.string[10] = "                                        pause - p";
	}

	tHelp.visible = on;
	pHelp.visible = on;
}