*&---------------------------------------------------------------------*
*&  Include           H99_TRMAC_REFERENCE
*&---------------------------------------------------------------------*
*
* Copy of table TRMAC created on 18.11.2016 in system HRI/000.
*
*----------------------------------------------------------------------*

*Tabelle:        TRMAC               Number of entries:          3675
*Angezeigte Felder:  3 von  3        Feststehende Führungsspalten:  2
*----------------------------------------------------------------------
*| |NAME                |NUMM|LINE                                    |
*----------------------------------------------------------------------
*| |AA_COMMENT          |000 |Include H99_TRMAC_REFERENCE contains    |
*| |AA_COMMENT          |001 |table TRMAC as comments (for search!)   |
*| |AA_COMMENT          |002 |(please change accordingly)             |
*| |AA_COMMENT          |003 |****************************************|
*| |BREAK               |000 |* USER specific BREAK-POINT             |
*| |BREAK               |001 |if sy-uname = '&1'                      |
*| |BREAK               |002 |break-point                             |
*| |BREAK               |003 |endif                                   |
*| |BREAKRC             |000 |* Programmfehler bei SY-Subrc <> 0.     |
*| |BREAKRC             |001 |if not sy-subrc is initial.             |
*| |BREAKRC             |002 |* raise breakrc_dump.                   |
*| |BREAKRC             |003 |  message a895(CJ) with sy-repid.       |
*| |BREAKRC             |004 |endif.                                  |
*| |COMMIT WORK         |014 |ID PC-KEY                               |
*| |GET_KEY_DATA        |000 |* Dynamischer Select für CL30           |
*| |GET_KEY_DATA        |001 |WHEN 'MARA'. TABLES MARA                |
*| |GET_KEY_DATA        |002 | MARA-MANDT = SY-MANDT                  |
*| |GET_KEY_DATA        |003 |MARA-MATNR = OBJECT_ID.GK = MARA(21)    |
*| |GET_KEY_DATA        |004 |WHEN 'MAKT'. TABLES MAKT                |
*| |GET_KEY_DATA        |005 | MAKT-MANDT = SY-MANDT                  |
*| |GET_KEY_DATA        |006 | MAKT-MATNR = OBJECT_ID                 |
*| |GET_KEY_DATA        |009 |    MAKT-SPRAS = LANGUAGE               |
*| |GET_KEY_DATA        |010 |    GK = MAKT(22)                       |
*| |GET_KEY_DATA        |019 |*                                       |
*| |GET_KEY_DATA_1      |000 |* Dynamischer Select für CL30           |
*| |GET_KEY_DATA_1      |001 |  WHEN 'MARA'.                          |
*| |GET_KEY_DATA_1      |002 |    MARA = I_TAB.                       |
*| |GET_KEY_DATA_1      |004 |  WHEN 'MAKT'.                          |
*| |GET_KEY_DATA_1      |005 |   MAKT = I_TAB.                        |
*| |RI-SET-LOHI-DATE    |001 |****************************************|
*| |RI-SET-LOHI-DATE    |002 |* RI: High-Date und Low-Date           *|
*| |RI-SET-LOHI-DATE    |003 |****************************************|
*| |RI-SET-LOHI-DATE    |004 |DATA LO_DATE TYPE D VALUE '18000101'    |
*| |RI-SET-LOHI-DATE    |005 |DATA HI_DATE TYPE D VALUE '99991231'    |
*| |RI-SET-LOHI-DATE    |006 |****************************************|
*| |RP-ABRECHNUNGSPER1  |001 |****************************************|
*| |RP-ABRECHNUNGSPER1  |002 |* RP: GEM ABRECHNUNGSPER IN 2TE ZEILE  *|
*| |RP-ABRECHNUNGSPER1  |003 |****************************************|
*| |RP-ABRECHNUNGSPER1  |004 |SKIP TO LINE 2                          |
*| |RP-ABRECHNUNGSPER1  |005 |POSITION 15                             |
*| |RP-ABRECHNUNGSPER1  |006 |WRITE (54) TEXT-AP1                     |
*| |RP-ABRECHNUNGSPER1  |007 |POSITION 36                             |
*| |RP-ABRECHNUNGSPER1  |008 |WRITE (2) ACPER+4(2)                    |
*| |RP-ABRECHNUNGSPER1  |009 |WRITE (4) ACPER(4)                      |
*| |RP-ABRECHNUNGSPER1  |010 |POSITION 46                             |
*| |RP-ABRECHNUNGSPER1  |011 |WRITE (10) PN-BEGDA DD/MM/YYYY          |
*| |RP-ABRECHNUNGSPER1  |012 |POSITION 59                             |
*| |RP-ABRECHNUNGSPER1  |013 |WRITE (10) PN-ENDDA DD/MM/YYYY          |
*| |RP-ADJ-SJISLEN-J    |010 |****************************************|
*| |RP-ADJ-SJISLEN-J    |020 |* ADJUST SHIFT-JIS CHAR LENGTH         *|
*| |RP-ADJ-SJISLEN-J    |030 |*                        (JAPAN)       *|
*| |RP-ADJ-SJISLEN-J    |040 |* PARAMETERS      SJIS STRINGS         *|
*| |RP-ADJ-SJISLEN-J    |050 |*                 LENGTH               *|
*| |RP-ADJ-SJISLEN-J    |060 |* OBSOLETE!                            *|
*| |RP-ADJ-SJISLEN-J    |070 |* USE F.M. HR_JP_ADJUST_STRING_LENGTH  *|
*| |RP-ADJ-SJISLEN-J    |080 |****************************************|
*| |RP-ADJ-SJISLEN-J    |090 |                                        |
*| |RP-ADJ-SJISLEN-J    |100 |gv_string_to_adjust = &1.               |
*| |RP-ADJ-SJISLEN-J    |110 |gv_sjis_string_length = &2.             |
*| |RP-ADJ-SJISLEN-J    |120 |                                        |
*| |RP-ADJ-SJISLEN-J    |130 |CALL FUNCTION                          *|
*| |RP-ADJ-SJISLEN-J    |140 | 'HR_JP_ADJUST_STRING_LENGTH'          *|
*| |RP-ADJ-SJISLEN-J    |150 |   EXPORTING                           *|
*| |RP-ADJ-SJISLEN-J    |160 |     IV_STRING = gv_string_to_adjust   *|
*| |RP-ADJ-SJISLEN-J    |170 |   CHANGING                            *|
*| |RP-ADJ-SJISLEN-J    |180 |     CV_LENGTH = gv_sjis_string_length. |
*| |RP-ADJ-SJISLEN-J    |190 |                                        |
*| |RP-ADJ-SJISLEN-J    |200 |&2 = gv_sjis_string_length.             |
*| |RP-APP-CLEAR-SCREEN |001 |****************************************|
*| |RP-APP-CLEAR-SCREEN |002 |* RP: CLEAR INITIAL ENTRY SCREEN       *|
*| |RP-APP-CLEAR-SCREEN |003 |****************************************|
*| |RP-APP-CLEAR-SCREEN |004 |CLEAR P0002                             |
*| |RP-APP-CLEAR-SCREEN |005 |CLEAR P0006                             |
*| |RP-APP-CLEAR-SCREEN |006 |CLEAR Q0006                             |
*| |RP-APP-CLEAR-SCREEN |007 |*----------ADDITIONAL DATA----------*   |
*| |RP-APP-CLEAR-SCREEN |008 |CLEAR QPAPL-ADD_0001                    |
*| |RP-APP-CLEAR-SCREEN |009 |CLEAR QPAPL-ADD_0002                    |
*| |RP-APP-CLEAR-SCREEN |010 |CLEAR QPAPL-ADD_0006                    |
*| |RP-APP-CLEAR-SCREEN |011 |CLEAR QPAPL-ADD_4001                    |
*| |RP-APP-CLEAR-SCREEN |012 |*CLEAR Q4000-BUKRS                      |
*| |RP-APP-CLEAR-SCREEN |013 |*CLEAR Q4000-WERKS                      |
*| |RP-APP-CLEAR-SCREEN |014 |*-----------BEWERBERRGRUPPE---------*   |
*| |RP-APP-CLEAR-SCREEN |015 |*CLEAR Q4000-APGRP                      |
*| |RP-APP-CLEAR-SCREEN |016 |*CLEAR T750E-GPTXT                      |
*| |RP-APP-CLEAR-SCREEN |017 |*-----------BEWERBERKREIS-----------*   |
*| |RP-APP-CLEAR-SCREEN |018 |*CLEAR Q4000-APTYP                      |
*| |RP-APP-CLEAR-SCREEN |019 |*CLEAR T750F-TXTTY                      |
*| |RP-APP-CLEAR-SCREEN |020 |*-----------ANREDE------------------*   |
*| |RP-APP-CLEAR-SCREEN |021 | CLEAR Q0002-ANREX                      |
*| |RP-APP-CLEAR-SCREEN |022 |*-----------STATUSGRUND-------------*   |
*| |RP-APP-CLEAR-SCREEN |023 |*CLEAR P4000-STREA                      |
*| |RP-APP-CLEAR-SCREEN |024 |*CLEAR T751C-REATX                      |
*| |RP-APP-CLEAR-SCREEN |025 |*-----------AUSSCHREIBUNG-----------*   |
*| |RP-APP-CLEAR-SCREEN |026 |*CLEAR P4001-OFFID                      |
*| |RP-APP-CLEAR-SCREEN |027 |*CLEAR T750C-INAME                      |
*| |RP-APP-CLEAR-SCREEN |028 |*CLEAR T750B-PBDAT                      |
*| |RP-APP-CLEAR-SCREEN |029 |*-----------SPONTANBEWERBER---------*   |
*| |RP-APP-CLEAR-SCREEN |030 |*CLEAR P4001-SPAPL                      |
*| |RP-APP-CLEAR-SCREEN |031 |*CLEAR T750I-USTXT                      |
*| |RP-APP-CLEAR-SCREEN |032 |*----------------MEDIUM-------------*   |
*| |RP-APP-CLEAR-SCREEN |033 |*CLEAR P4001-MEDIA                      |
*| |RP-APP-CLEAR-SCREEN |034 |*CLEAR T750H-MEDTX                      |
*| |RP-APP-CLEAR-SCREEN |035 |*----------SACHBEARBEITER-----------*   |
*| |RP-APP-CLEAR-SCREEN |036 |*CLEAR Q0001-RESRF                      |
*| |RP-APP-CLEAR-SCREEN |037 |*CLEAR T526-SACHN                       |
*| |RP-APP-CLEAR-SCREEN |038 |****************************************|
*| |RP-APP-DEL-RECTK    |001 |****************************************|
*| |RP-APP-DEL-RECTK    |002 |* RP: DEL MATCHCODE FOR RECURRING TASK *|
*| |RP-APP-DEL-RECTK    |003 |****************************************|
*| |RP-APP-DEL-RECTK    |004 |CASE &1.                                |
*| |RP-APP-DEL-RECTK    |005 |  WHEN 'D'.                             |
*| |RP-APP-DEL-RECTK    |006 |    P4004-RCTK1 = ' '.                  |
*| |RP-APP-DEL-RECTK    |007 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-DEL-RECTK    |008 |  WHEN 'I'.                             |
*| |RP-APP-DEL-RECTK    |009 |    P4004-RCTK2 = ' '.                  |
*| |RP-APP-DEL-RECTK    |010 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-DEL-RECTK    |011 |  WHEN 'P'.                             |
*| |RP-APP-DEL-RECTK    |012 |    P4004-RCTK3 = ' '.                  |
*| |RP-APP-DEL-RECTK    |013 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-DEL-RECTK    |014 |  WHEN 'T'.                             |
*| |RP-APP-DEL-RECTK    |015 |    P4004-RCTK4 = ' '.                  |
*| |RP-APP-DEL-RECTK    |016 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-DEL-RECTK    |017 |ENDCASE.                                |
*| |RP-APP-GET-RECTK    |001 |****************************************|
*| |RP-APP-GET-RECTK    |002 |* RP: GET MATCHCODE FOR RECURRING TASK *|
*| |RP-APP-GET-RECTK    |003 |****************************************|
*| |RP-APP-GET-RECTK    |004 |DATA: RTK1(1) TYPE C, RTK2(1) TYPE C    |
*| |RP-APP-GET-RECTK    |005 |DATA: RTK3(1) TYPE C, RTK4(1) TYPE C    |
*| |RP-APP-GET-RECTK    |006 |*  SYSTEMFUNKTION D                     |
*| |RP-APP-GET-RECTK    |007 |RTK1 = P4004-RCTK1                      |
*| |RP-APP-GET-RECTK    |008 |*  SYSTEMFUNKTION I                     |
*| |RP-APP-GET-RECTK    |009 |RTK2 = P4004-RCTK2                      |
*| |RP-APP-GET-RECTK    |010 |*  SYSTEMFUNKTION P                     |
*| |RP-APP-GET-RECTK    |011 |RTK3 = P4004-RCTK3                      |
*| |RP-APP-GET-RECTK    |012 |*  SYSTEMFUNKTION T                     |
*| |RP-APP-GET-RECTK    |013 |RTK4 = P4004-RCTK4                      |
*| |RP-APP-SET-CLERK    |001 |****************************************|
*| |RP-APP-SET-CLERK    |002 |* RP: PROPOSAL FOR PERS. CLERK         *|
*| |RP-APP-SET-CLERK    |003 |****************************************|
*| |RP-APP-SET-CLERK    |004 |DATA: $$SBMOD LIKE T526-WERKS,         *|
*| |RP-APP-SET-CLERK    |005 |      $$RETCD LIKE SY-SUBRC:            |
*| |RP-APP-SET-CLERK    |006 |  CLEAR PME17.                          |
*| |RP-APP-SET-CLERK    |007 |  MOVE 'B' TO PME17-TCLAS.              |
*| |RP-APP-SET-CLERK    |008 |  PERFORM RE549D                       *|
*| |RP-APP-SET-CLERK    |009 |     USING 'PINCH' '3' $$SBMOD $$RETCD. |
*| |RP-APP-SET-CLERK    |010 |  IF $$RETCD NE 0.                      |
*| |RP-APP-SET-CLERK    |011 |    CLEAR $$SBMOD.                      |
*| |RP-APP-SET-CLERK    |012 |  ELSE.                                 |
*| |RP-APP-SET-CLERK    |013 |    SELECT * FROM T526                 *|
*| |RP-APP-SET-CLERK    |014 |             WHERE WERKS EQ $$SBMOD    *|
*| |RP-APP-SET-CLERK    |015 |             AND   USRID EQ SY-UNAME.   |
*| |RP-APP-SET-CLERK    |016 |      EXIT.                             |
*| |RP-APP-SET-CLERK    |017 |    ENDSELECT.                          |
*| |RP-APP-SET-CLERK    |018 |    IF SY-SUBRC EQ 0.                   |
*| |RP-APP-SET-CLERK    |019 |      PAPRESRF-SIGN   = 'I'.            |
*| |RP-APP-SET-CLERK    |020 |      PAPRESRF-OPTION = 'EQ'.           |
*| |RP-APP-SET-CLERK    |021 |      PAPRESRF-LOW    = T526-SACHX.     |
*| |RP-APP-SET-CLERK    |022 |      APPEND PAPRESRF.                  |
*| |RP-APP-SET-CLERK    |023 |    ENDIF.                              |
*| |RP-APP-SET-CLERK    |024 |  ENDIF.                                |
*| |RP-APP-SET-RECTK    |001 |****************************************|
*| |RP-APP-SET-RECTK    |002 |* RP: SET MATCHCODE FOR RECURRING TASK *|
*| |RP-APP-SET-RECTK    |003 |****************************************|
*| |RP-APP-SET-RECTK    |004 |*  MATCHCODE PAPL W1                    |
*| |RP-APP-SET-RECTK    |005 |  IF ( &1 EQ 'D' OR &1 EQ '1' ) AND    *|
*| |RP-APP-SET-RECTK    |006 |     ( RTK1 EQ SPACE ).                 |
*| |RP-APP-SET-RECTK    |007 |    P4004-RCTK1 = 'X'.                  |
*| |RP-APP-SET-RECTK    |008 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-SET-RECTK    |009 |  ENDIF.                                |
*| |RP-APP-SET-RECTK    |010 |* MATCHCODE PAPL W2                     |
*| |RP-APP-SET-RECTK    |011 |  IF ( &1 EQ 'I' OR &1 EQ '2' ) AND    *|
*| |RP-APP-SET-RECTK    |012 |     ( RTK2 EQ SPACE ).                 |
*| |RP-APP-SET-RECTK    |013 |    P4004-RCTK2 = 'X'.                  |
*| |RP-APP-SET-RECTK    |014 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-SET-RECTK    |015 |  ENDIF.                                |
*| |RP-APP-SET-RECTK    |016 |* MATCHCODE PAPL W3                     |
*| |RP-APP-SET-RECTK    |017 |  IF ( &1 EQ 'P' OR &1 EQ '3' ) AND    *|
*| |RP-APP-SET-RECTK    |018 |     ( RTK3 EQ SPACE ).                 |
*| |RP-APP-SET-RECTK    |019 |    P4004-RCTK3 = 'X'.                  |
*| |RP-APP-SET-RECTK    |020 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-SET-RECTK    |021 |  ENDIF.                                |
*| |RP-APP-SET-RECTK    |022 |* MATCHCODE PAPL W4                     |
*| |RP-APP-SET-RECTK    |023 |  IF ( &1 EQ 'T' OR &1 EQ '4' ) AND    *|
*| |RP-APP-SET-RECTK    |024 |     ( RTK4 EQ SPACE ).                 |
*| |RP-APP-SET-RECTK    |025 |    P4004-RCTK4 = 'X'.                  |
*| |RP-APP-SET-RECTK    |026 |    UPDATE_P4004 = YES.                 |
*| |RP-APP-SET-RECTK    |027 |  ENDIF.                                |
*| |RP-APP-VALID-STATUS |001 |*----RPVALID STATUS of applicant-------*|
*| |RP-APP-VALID-STATUS |002 |data: valid_status(10) value '13      ' |
*| |RP-APP-VALID-STATUS |003 |*----RPVALID STATUS of applicant-------*|
*| |RP-BESCH            |001 |****************************************|
*| |RP-BESCH            |002 |* RP-BESCH                             *|
*| |RP-BESCH            |003 |*   PARAMETERS: NAME OF TABLE          *|
*| |RP-BESCH            |004 |*               FORMULARKENNUNG        *|
*| |RP-BESCH            |005 |* SHOW ENTRIES                         *|
*| |RP-BESCH            |006 |*                                      *|
*| |RP-BESCH            |007 |****************************************|
*| |RP-BESCH            |008 |LOOP AT &1                              |
*| |RP-BESCH            |009 |  CHECK &1-FORML EQ &2                  |
*| |RP-BESCH            |010 |* DELETE &1                             |
*| |RP-BESCH            |011 |* CHECK &2 NE SPACE                     |
*| |RP-BESCH            |012 |  WRITE: / 'EINTRAG AUS TABELLE       ' |
*| |RP-BESCH            |013 |  WRITE: / &1-FNAME                     |
*| |RP-BESCH            |014 |ENDLOOP                                 |
*| |RP-CHECK-PASSWORD   |010 |****************************************|
*| |RP-CHECK-PASSWORD   |020 |*PASSWORD-PRUEFUNG FUER UMSETZREPORTS  *|
*| |RP-CHECK-PASSWORD   |030 |****************************************|
*| |RP-CHECK-PASSWORD   |040 |PARAMETERS: PASSWORD LIKE SY-UNAME      |
*| |RP-CHECK-PASSWORD   |050 |DATA: BEGIN OF $RP-ERR-U000-TAB OCCURS 9|
*| |RP-CHECK-PASSWORD   |060 |        INCLUDE STRUCTURE TLINE         |
*| |RP-CHECK-PASSWORD   |070 |DATA: END OF $RP-ERR-U000-TAB           |
*| |RP-CHECK-PASSWORD   |090 |IF PASSWORD NE SY-UNAME                 |
*| |RP-CHECK-PASSWORD   |100 |  CALL FUNCTION 'DOCU_GET'             *|
*| |RP-CHECK-PASSWORD   |110 |       EXPORTING ID = 'TX'             *|
*| |RP-CHECK-PASSWORD   |120 |                 LANGU = SY-LANGU      *|
*| |RP-CHECK-PASSWORD   |121 |                 OBJECT = 'RP-ERR-U000'*|
*| |RP-CHECK-PASSWORD   |122 |       TABLES  LINE = $RP-ERR-U000-TAB *|
*| |RP-CHECK-PASSWORD   |123 |       exceptions ret_code = 4          |
*| |RP-CHECK-PASSWORD   |124 |  if sy-subrc ne 0                      |
*| |RP-CHECK-PASSWORD   |125 |    CALL FUNCTION 'DOCU_GET'           *|
*| |RP-CHECK-PASSWORD   |126 |      EXPORTING ID = 'TX'              *|
*| |RP-CHECK-PASSWORD   |127 |                langu = 'E'            *|
*| |RP-CHECK-PASSWORD   |128 |                OBJECT = 'RP-ERR-U000' *|
*| |RP-CHECK-PASSWORD   |129 |      TABLES  LINE = $RP-ERR-U000-TAB  *|
*| |RP-CHECK-PASSWORD   |130 |      exceptions ret_code = 4           |
*| |RP-CHECK-PASSWORD   |131 |  endif                                 |
*| |RP-CHECK-PASSWORD   |135 |  LOOP AT $RP-ERR-U000-TAB              |
*| |RP-CHECK-PASSWORD   |140 |    SHIFT $RP-ERR-U000-TAB              |
*| |RP-CHECK-PASSWORD   |150 |    WRITE: / $RP-ERR-U000-TAB           |
*| |RP-CHECK-PASSWORD   |160 |  ENDLOOP                               |
*| |RP-CHECK-PASSWORD   |170 |  STOP                                  |
*| |RP-CHECK-PASSWORD   |180 |ENDIF                                   |
*| |RP-CHECK-PASSWORD-2 |010 |****************************************|
*| |RP-CHECK-PASSWORD-2 |020 |*PASSWORD-PRUEFUNG FUER UMSETZREPORTS  *|
*| |RP-CHECK-PASSWORD-2 |030 |****************************************|
*| |RP-CHECK-PASSWORD-2 |040 |PARAMETERS: PASSWORD LIKE SY-UNAME      |
*| |RP-CHECK-PASSWORD-2 |045 |FORM RP-CHECK-PASSWORD-2                |
*| |RP-CHECK-PASSWORD-2 |050 |DATA: BEGIN OF $RP-ERR-U000-TAB OCCURS 9|
*| |RP-CHECK-PASSWORD-2 |060 |        INCLUDE STRUCTURE TLINE         |
*| |RP-CHECK-PASSWORD-2 |070 |DATA: END OF $RP-ERR-U000-TAB           |
*| |RP-CHECK-PASSWORD-2 |090 |IF PASSWORD NE SY-UNAME                 |
*| |RP-CHECK-PASSWORD-2 |100 |  CALL FUNCTION 'DOCU_GET'             *|
*| |RP-CHECK-PASSWORD-2 |110 |       EXPORTING ID = 'TX'             *|
*| |RP-CHECK-PASSWORD-2 |120 |                 LANGU = SY-LANGU      *|
*| |RP-CHECK-PASSWORD-2 |121 |                 OBJECT = 'RP-ERR-U000'*|
*| |RP-CHECK-PASSWORD-2 |122 |       TABLES  LINE = $RP-ERR-U000-TAB  |
*| |RP-CHECK-PASSWORD-2 |130 |  LOOP AT $RP-ERR-U000-TAB              |
*| |RP-CHECK-PASSWORD-2 |140 |    SHIFT $RP-ERR-U000-TAB              |
*| |RP-CHECK-PASSWORD-2 |150 |    WRITE: / $RP-ERR-U000-TAB           |
*| |RP-CHECK-PASSWORD-2 |160 |  ENDLOOP                               |
*| |RP-CHECK-PASSWORD-2 |170 |  STOP                                  |
*| |RP-CHECK-PASSWORD-2 |180 |ENDIF                                   |
*| |RP-CHECK-PASSWORD-2 |190 |ENDFORM                                 |
*| |RP-CHECK-TABINCLIENT|010 |****************************************|
*| |RP-CHECK-TABINCLIENT|100 |FORM CHECK-TABINCLIENT USING            |
*| |RP-CHECK-TABINCLIENT|110 |     CHECK-TABINCLIENT-TABLE-NAME       |
*| |RP-CHECK-TABINCLIENT|500 |ENDFORM                                 |
*| |RP-DEF-BOOLEAN      |001 |****************************************|
*| |RP-DEF-BOOLEAN      |002 |* DEFINES TYPE 'BOOLEAN' AND CONST  VKI*|
*| |RP-DEF-BOOLEAN      |003 |****************************************|
*| |RP-DEF-BOOLEAN      |004 |DATA:                                  *|
*| |RP-DEF-BOOLEAN      |005 |  BOOLEAN(1)  TYPE C                    |
*| |RP-DEF-BOOLEAN      |006 |DATA:                                  *|
*| |RP-DEF-BOOLEAN      |007 |  FALSE       LIKE BOOLEAN   VALUE ' ',*|
*| |RP-DEF-BOOLEAN      |008 |  TRUE        LIKE BOOLEAN   VALUE 'X'  |
*| |RP-DEF-BOOLEAN      |009 |* END OF RP-DEF-BOOLEAN             VKI*|
*| |RP-DEF-TIME-PERIOD  |001 |****************************************|
*| |RP-DEF-TIME-PERIOD  |002 |DATA RPTIME_PERIOD(2) VALUE '01'        |
*| |RP-DEF-TIME-PERIOD  |003 |****************************************|
*| |RP-DEF-TIME-PERIOD-J|001 |**********  For Japan only  ************|
*| |RP-DEF-TIME-PERIOD-J|002 |DATA RPTIME_PERIOD(2) VALUE '78'        |
*| |RP-DEF-TIME-PERIOD-J|003 |****************************************|
*| |RP-DEL-LOCKED-RECORD|001 |****************************************|
*| |RP-DEL-LOCKED-RECORD|002 |* RP-DEL-LOCKED-RECRDS                 *|
*| |RP-DEL-LOCKED-RECORD|003 |*   PARAMETERS: NAME OF INFOTYPE-TABLE *|
*| |RP-DEL-LOCKED-RECORD|004 |*               TESTOPTION 'X' OR SPACE*|
*| |RP-DEL-LOCKED-RECORD|005 |* DELETE LOCKED RECORDS FROM           *|
*| |RP-DEL-LOCKED-RECORD|006 |*   INFOTYPE-TABLE                     *|
*| |RP-DEL-LOCKED-RECORD|007 |****************************************|
*| |RP-DEL-LOCKED-RECORD|008 |LOOP AT &1                              |
*| |RP-DEL-LOCKED-RECORD|009 |  CHECK &1-SPRPS EQ 'X'                 |
*| |RP-DEL-LOCKED-RECORD|010 |  DELETE &1                             |
*| |RP-DEL-LOCKED-RECORD|011 |  CHECK &2 NE SPACE                     |
*| |RP-DEL-LOCKED-RECORD|012 |  WRITE: / 'LOCKED RECORD DELETED FROM' |
*| |RP-DEL-LOCKED-RECORD|013 |  WRITE: 'INFOTYPE-TABLE', '&1', ':', &1|
*| |RP-DEL-LOCKED-RECORD|014 |ENDLOOP                                 |
*| |RP-DEPEND-CHK-J     |010 |****************************************|
*| |RP-DEPEND-CHK-J     |020 |* RP-depend-chk-J                      *|
*| |RP-DEPEND-CHK-J     |030 |****************************************|
*| |RP-DEPEND-CHK-J     |040 |CASE &1.                                |
*| |RP-DEPEND-CHK-J     |050 |  WHEN '01'.                            |
*| |RP-DEPEND-CHK-J     |060 |    IF &4(4) EQ &6(4).                  |
*| |RP-DEPEND-CHK-J     |070 |      &8 = &2.                          |
*| |RP-DEPEND-CHK-J     |080 |    ELSEIF &4(4) LT &6(4).              |
*| |RP-DEPEND-CHK-J     |090 |      &8 = '0'.                         |
*| |RP-DEPEND-CHK-J     |100 |    ELSE.                               |
*| |RP-DEPEND-CHK-J     |110 |      &8 = '8'.                         |
*| |RP-DEPEND-CHK-J     |120 |    ENDIF.                              |
*| |RP-DEPEND-CHK-J     |130 |  WHEN '02'.                            |
*| |RP-DEPEND-CHK-J     |140 |    IF   &5(4) EQ &6(4).                |
*| |RP-DEPEND-CHK-J     |150 |      &8 = &2.                          |
*| |RP-DEPEND-CHK-J     |160 |    ELSE.                               |
*| |RP-DEPEND-CHK-J     |170 |      &8 = '8'.                         |
*| |RP-DEPEND-CHK-J     |180 |    ENDIF.                              |
*| |RP-DEPEND-CHK-J     |190 |  WHEN OTHERS.                          |
*| |RP-DEPEND-CHK-J     |200 |    IF ( &5(4) EQ &6(4) ) AND          *|
*| |RP-DEPEND-CHK-J     |201 |       ( &5+4(4) NE &7+4(4) ).          |
*| |RP-DEPEND-CHK-J     |210 |      &8 = '0'.                         |
*| |RP-DEPEND-CHK-J     |220 |    ELSEIF ( &5(4) EQ &6(4) ) AND      *|
*| |RP-DEPEND-CHK-J     |221 |       ( &5+4(4) EQ &7+4(4) ).          |
*| |RP-DEPEND-CHK-J     |230 |      &8 = &3.                          |
*| |RP-DEPEND-CHK-J     |240 |    ELSEIF &5(4) GT &6(4).              |
*| |RP-DEPEND-CHK-J     |250 |      &8 = &3.                          |
*| |RP-DEPEND-CHK-J     |260 |    ELSE.                               |
*| |RP-DEPEND-CHK-J     |270 |      &8 = '8'.                         |
*| |RP-DEPEND-CHK-J     |280 |    ENDIF.                              |
*| |RP-DEPEND-CHK-J     |290 |ENDCASE.                                |
*| |RP-EDIT-ADDRESS     |001 |****************************************|
*| |RP-EDIT-ADDRESS     |002 |* RP-ADRESS-AUFBEREITUNG:              *|
*| |RP-EDIT-ADDRESS     |003 |* PARAMETER IN:  P0001 (ORG. ZUORDNUNG)*|
*| |RP-EDIT-ADDRESS     |004 |*                P0002 (DATEN ZUR PERS)*|
*| |RP-EDIT-ADDRESS     |005 |*                P0006 (ANSCHRIFTEN)   *|
*| |RP-EDIT-ADDRESS     |006 |*                EDIT-NAME             *|
*| |RP-EDIT-ADDRESS     |007 |*                ZEILEN-ANZAHL (FENST.)*|
*| |RP-EDIT-ADDRESS     |008 |*                ZEILE VON (IM FENSTER)*|
*| |RP-EDIT-ADDRESS     |009 |*                SPALTE VON (FENSTER)  *|
*| |RP-EDIT-ADDRESS     |010 |*                ZEILE BIS (IM FENSTER)*|
*| |RP-EDIT-ADDRESS     |011 |*                SPALTE BIS (FENSTER)  *|
*| |RP-EDIT-ADDRESS     |012 |* PARAMETER OUT: ADRS-LINE0            *|
*| |RP-EDIT-ADDRESS     |013 |*                .                     *|
*| |RP-EDIT-ADDRESS     |014 |*                ADRS-LINE9            *|
*| |RP-EDIT-ADDRESS     |015 |****************************************|
*| |RP-EDIT-ADDRESS     |016 |* BITTE DEFINIEREN SIE DIE TABELLEN    *|
*| |RP-EDIT-ADDRESS     |017 |* ADRS UND T522T IN IHREM REPORT!      *|
*| |RP-EDIT-ADDRESS     |018 |****************************************|
*| |RP-EDIT-ADDRESS     |019 |* TABLES :T001F R3!=R2!!!               |
*| |RP-EDIT-ADDRESS     |020 |* CALL TO FUNCTION RP-MAKE-ADDRESS      |
*| |RP-EDIT-ADDRESS     |021 |RP-MAKE-ADDRESS &1 &2 &3 &4 &5          |
*| |RP-EDIT-ADDRESS     |022 |* AUFBEREITUNGS-ROUTINE IN VERB. T001F  |
*| |RP-EDIT-ADDRESS     |023 |* DETAIL                                |
*| |RP-EDIT-ADDRESS     |024 |SET BLANK LINES ON                      |
*| |RP-EDIT-ADDRESS     |025 |* WRITE / &6                            |
*| |RP-EDIT-ADDRESS     |026 |* WRITE / &7                            |
*| |RP-EDIT-ADDRESS     |027 |* WRITE / &8                            |
*| |RP-EDIT-ADDRESS     |028 |* WRITE / &9                            |
*| |RP-EDIT-ADDRESS     |029 |* T001F IM R3 ENTSPRICHT NICHT R2!!!!!  |
*| |RP-EDIT-ADDRESS     |030 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |031 |*SELECT SINGLE * FROM T001F             |
*| |RP-EDIT-ADDRESS     |032 |*             WHERE BUKRS EQ &1-BUKRS   |
*| |RP-EDIT-ADDRESS     |033 |* WRITE / T001F-ZEIVN                   |
*| |RP-EDIT-ADDRESS     |034 |* WRITE / T001F-SPLVN                   |
*| |RP-EDIT-ADDRESS     |035 |* WRITE / T001F-ZEIBS                   |
*| |RP-EDIT-ADDRESS     |036 |* WRITE / T001F-SPLBS                   |
*| |RP-EDIT-ADDRESS     |037 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |038 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |039 |ZEILENLAENGE = 40                       |
*| |RP-EDIT-ADDRESS     |040 |*     T001F-SPLBS - T001F-SPLVN + 1     |
*| |RP-EDIT-ADDRESS     |041 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |042 |ZEILENLAENGE = &9 - &7 + 1              |
*| |RP-EDIT-ADDRESS     |043 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |044 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |045 |STARTZEILE = 5                          |
*| |RP-EDIT-ADDRESS     |046 |*STARTZEILE   = T001F-ZEIVN             |
*| |RP-EDIT-ADDRESS     |047 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |048 |STARTZEILE   = &6                       |
*| |RP-EDIT-ADDRESS     |049 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |050 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |051 |ANZAHLZEILEN = 6                        |
*| |RP-EDIT-ADDRESS     |052 |*     T001F-ZEIBS - T001F-ZEIVN + 1     |
*| |RP-EDIT-ADDRESS     |053 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |054 |ANZAHLZEILEN = &8 - &6 + 1              |
*| |RP-EDIT-ADDRESS     |055 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |056 |*F T001F-ZEIVN GT 0 AND                 |
*| |RP-EDIT-ADDRESS     |057 |*  T001F-SPLVN GT 0                     |
*| |RP-EDIT-ADDRESS     |058 |IF STARTZEILE GT 0                     *|
*| |RP-EDIT-ADDRESS     |059 |   AND ANZAHLZEILEN GT 0                |
*| |RP-EDIT-ADDRESS     |060 |* NEW-PAGE                              |
*| |RP-EDIT-ADDRESS     |061 |  NEW-LINE                              |
*| |RP-EDIT-ADDRESS     |062 |  DO ANZAHLZEILEN TIMES VARYING ZEILE  *|
*| |RP-EDIT-ADDRESS     |063 |     FROM ADRS-LINE0 NEXT ADRS-LINE1    |
*| |RP-EDIT-ADDRESS     |064 |  IF &6 LE 0                            |
*| |RP-EDIT-ADDRESS     |065 |    STARTSPALTE = 5                     |
*| |RP-EDIT-ADDRESS     |066 |*   STARTSPALTE = T001F-SPLVN           |
*| |RP-EDIT-ADDRESS     |067 |  ELSE                                  |
*| |RP-EDIT-ADDRESS     |068 |    STARTSPALTE = &7                    |
*| |RP-EDIT-ADDRESS     |069 |  ENDIF                                 |
*| |RP-EDIT-ADDRESS     |070 |  SKIP TO LINE STARTZEILE               |
*| |RP-EDIT-ADDRESS     |071 |  DO ZEILENLAENGE TIMES                 |
*| |RP-EDIT-ADDRESS     |072 |    POSITION STARTSPALTE                |
*| |RP-EDIT-ADDRESS     |073 |    WRITE ZEILE(1)                      |
*| |RP-EDIT-ADDRESS     |074 |    SHIFT ZEILE                         |
*| |RP-EDIT-ADDRESS     |075 |    STARTSPALTE = STARTSPALTE + 1       |
*| |RP-EDIT-ADDRESS     |076 |  ENDDO                                 |
*| |RP-EDIT-ADDRESS     |077 |    STARTZEILE = STARTZEILE + 1         |
*| |RP-EDIT-ADDRESS     |078 |  ENDDO                                 |
*| |RP-EDIT-ADDRESS     |079 |* KURZ-ANSCHRIFT                        |
*| |RP-EDIT-ADDRESS     |080 |* SKIP 2                                |
*| |RP-EDIT-ADDRESS     |081 |* SUMMARY                               |
*| |RP-EDIT-ADDRESS     |082 |* ULINE                                 |
*| |RP-EDIT-ADDRESS     |083 |* WRITE / ADRS-LINEK(79)                |
*| |RP-EDIT-ADDRESS     |084 |* ULINE                                 |
*| |RP-EDIT-ADDRESS     |085 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |086 |ADRS-ANZZL = &5                         |
*| |RP-EDIT-ADDRESS     |087 |* LANDESBEZ., WENN VERSENDUNG AUSLAND   |
*| |RP-EDIT-ADDRESS     |088 |ADRS-WAREN = 'X'                        |
*| |RP-EDIT-ADDRESS     |089 |* EXTERNE AUFBEREITUNG DER ADRESSE (SAP)|
*| |RP-EDIT-ADDRESS     |090 |CALL FUNCTION 'ADDRESS_INTO_PRINTFORM' *|
*| |RP-EDIT-ADDRESS     |091 |     EXPORTING ADRSWA_IN  = ADRS       *|
*| |RP-EDIT-ADDRESS     |092 |     IMPORTING ADRSWA_OUT = ADRS        |
*| |RP-EDIT-ADDRESS     |093 |* DA ADRS-NAME1 NUR 35 BYTES LANG IST   |
*| |RP-EDIT-ADDRESS     |094 |* WIRD HIER DER EDIT-NAME BENUTZT =>&4  |
*| |RP-EDIT-ADDRESS     |095 |MOVE ADRS-NAME1 TO ZEILE                |
*| |RP-EDIT-ADDRESS     |096 |DO 20 TIMES                             |
*| |RP-EDIT-ADDRESS     |097 |  IF ZEILE(1) NE SPACE                  |
*| |RP-EDIT-ADDRESS     |098 |    MARGIN = SY-INDEX - 1               |
*| |RP-EDIT-ADDRESS     |099 |    EXIT                                |
*| |RP-EDIT-ADDRESS     |100 |  ENDIF                                 |
*| |RP-EDIT-ADDRESS     |101 |  SHIFT ZEILE                           |
*| |RP-EDIT-ADDRESS     |102 |ENDDO                                   |
*| |RP-EDIT-ADDRESS     |103 |MOVE SPACE TO ZEILE                     |
*| |RP-EDIT-ADDRESS     |104 |WRITE &4 TO ZEILE+MARGIN                |
*| |RP-EDIT-ADDRESS     |105 |*CHECK IF NAME IS IN FIRST LINE         |
*| |RP-EDIT-ADDRESS     |106 |IF ADRS-LINE0(20) EQ ZEILE(20)          |
*| |RP-EDIT-ADDRESS     |107 |  WRITE ZEILE TO ADRS-LINE0             |
*| |RP-EDIT-ADDRESS     |108 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |109 |*CHECK IF NAME IS IN 2ND LINE           |
*| |RP-EDIT-ADDRESS     |110 |IF ADRS-LINE1(20) EQ ZEILE(20)          |
*| |RP-EDIT-ADDRESS     |111 |  WRITE ZEILE TO ADRS-LINE1             |
*| |RP-EDIT-ADDRESS     |112 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |113 |* AUFBEREITUNGS-ROUTINE IN VERB. T001F  |
*| |RP-EDIT-ADDRESS     |114 |* DETAIL                                |
*| |RP-EDIT-ADDRESS     |115 |SET BLANK LINES ON                      |
*| |RP-EDIT-ADDRESS     |116 |* WRITE / &6                            |
*| |RP-EDIT-ADDRESS     |117 |* WRITE / &7                            |
*| |RP-EDIT-ADDRESS     |118 |* WRITE / &8                            |
*| |RP-EDIT-ADDRESS     |119 |* WRITE / &9                            |
*| |RP-EDIT-ADDRESS     |120 |* T001F IM R3 ENTSPRICHT NICHT R2!!!!!  |
*| |RP-EDIT-ADDRESS     |121 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |122 |*SELECT SINGLE * FROM T001F             |
*| |RP-EDIT-ADDRESS     |123 |*             WHERE BUKRS EQ &1-BUKRS   |
*| |RP-EDIT-ADDRESS     |124 |* WRITE / T001F-ZEIVN                   |
*| |RP-EDIT-ADDRESS     |125 |* WRITE / T001F-SPLVN                   |
*| |RP-EDIT-ADDRESS     |126 |* WRITE / T001F-ZEIBS                   |
*| |RP-EDIT-ADDRESS     |127 |* WRITE / T001F-SPLBS                   |
*| |RP-EDIT-ADDRESS     |128 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |129 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |130 |ZEILENLAENGE = 40                       |
*| |RP-EDIT-ADDRESS     |131 |*     T001F-SPLBS - T001F-SPLVN + 1     |
*| |RP-EDIT-ADDRESS     |132 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |133 |ZEILENLAENGE = &9 - &7 + 1              |
*| |RP-EDIT-ADDRESS     |134 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |135 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |136 |STARTZEILE = 5                          |
*| |RP-EDIT-ADDRESS     |137 |*STARTZEILE   = T001F-ZEIVN             |
*| |RP-EDIT-ADDRESS     |138 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |139 |STARTZEILE   = &6                       |
*| |RP-EDIT-ADDRESS     |140 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |141 |IF &6 LE 0                              |
*| |RP-EDIT-ADDRESS     |142 |ANZAHLZEILEN = 6                        |
*| |RP-EDIT-ADDRESS     |143 |*     T001F-ZEIBS - T001F-ZEIVN + 1     |
*| |RP-EDIT-ADDRESS     |144 |ELSE                                    |
*| |RP-EDIT-ADDRESS     |145 |ANZAHLZEILEN = &8 - &6 + 1              |
*| |RP-EDIT-ADDRESS     |146 |ENDIF                                   |
*| |RP-EDIT-ADDRESS     |147 |*F T001F-ZEIVN GT 0 AND                 |
*| |RP-EDIT-ADDRESS     |148 |*  T001F-SPLVN GT 0                     |
*| |RP-EDIT-ADDRESS     |149 |IF STARTZEILE GT 0                     *|
*| |RP-EDIT-ADDRESS     |150 |   AND ANZAHLZEILEN GT 0                |
*| |RP-EDIT-ADDRESS     |151 |* NEW-PAGE                              |
*| |RP-EDIT-ADDRESS     |152 |  NEW-LINE                              |
*| |RP-EDIT-ADDRESS     |153 |  DO ANZAHLZEILEN TIMES VARYING ZEILE  *|
*| |RP-EDIT-ADDRESS     |154 |     FROM ADRS-LINE0 NEXT ADRS-LINE1    |
*| |RP-EDIT-ADDRESS     |155 |  IF &6 LE 0                            |
*| |RP-EDIT-ADDRESS     |156 |    STARTSPALTE = 5                     |
*| |RP-EDIT-ADDRESS     |157 |*   STARTSPALTE = T001F-SPLVN           |
*| |RP-EDIT-ADDRESS     |158 |  ELSE                                  |
*| |RP-EDIT-ADDRESS     |159 |    STARTSPALTE = &7                    |
*| |RP-EDIT-ADDRESS     |160 |  ENDIF                                 |
*| |RP-EDIT-ADDRESS     |161 |  SKIP TO LINE STARTZEILE               |
*| |RP-EDIT-ADDRESS     |162 |  DO ZEILENLAENGE TIMES                 |
*| |RP-EDIT-ADDRESS     |163 |    POSITION STARTSPALTE                |
*| |RP-EDIT-ADDRESS     |164 |    WRITE ZEILE(1)                      |
*| |RP-EDIT-ADDRESS     |165 |    SHIFT ZEILE                         |
*| |RP-EDIT-ADDRESS     |166 |    STARTSPALTE = STARTSPALTE + 1       |
*| |RP-EDIT-ADDRESS     |167 |  ENDDO                                 |
*| |RP-EDIT-ADDRESS     |168 |    STARTZEILE = STARTZEILE + 1         |
*| |RP-EDIT-ADDRESS     |169 |  ENDDO                                 |
*| |RP-EDIT-ADDRESS     |170 |* KURZ-ANSCHRIFT                        |
*| |RP-EDIT-ADDRESS     |171 |* SKIP 2                                |
*| |RP-EDIT-ADDRESS     |172 |* SUMMARY                               |
*| |RP-EDIT-ADDRESS     |173 |* ULINE                                 |
*| |RP-EDIT-ADDRESS     |174 |* WRITE / ADRS-LINEK(79)                |
*| |RP-EDIT-ADDRESS     |175 |* ULINE                                 |
*| |RP-EDIT-ADDRESS     |176 |ENDIF                                   |
*| |RP-EDIT-NAME        |001 |****************************************|
*| |RP-EDIT-NAME        |002 |* RP-EDIT-NAME   RP-NAMENSAUFBEREITUNG *|
*| |RP-EDIT-NAME        |003 |****************************************|
*| |RP-EDIT-NAME        |004 |* PARAMETER IN:  P0001 (DEFAULT: ENAME)*|
*| |RP-EDIT-NAME        |005 |*                P0002 (DATEN ZUR PERS)*|
*| |RP-EDIT-NAME        |006 |*               <P0021 (FAMILIE-DATEN)>*|
*| |RP-EDIT-NAME        |007 |*                MOLGA (T001P-MOLGA)   *|
*| |RP-EDIT-NAME        |008 |*                LANGU (ANREDE-SPRACHE)*|
*| |RP-EDIT-NAME        |009 |* PARAMETER OUT: $EDIT-NAME            *|
*| |RP-EDIT-NAME        |010 |*                $RET-CODE             *|
*| |RP-EDIT-NAME        |011 |****************************************|
*| |RP-EDIT-NAME        |012 |CASE &2-INFTY                           |
*| |RP-EDIT-NAME        |013 |  WHEN '0002'                           |
*| |RP-EDIT-NAME        |014 |  IF $$FORMAT = '01'                    |
*| |RP-EDIT-NAME        |015 |    $EDIT-NAME = &1-ENAME               |
*| |RP-EDIT-NAME        |016 |    $RET-CODE  = 0                      |
*| |RP-EDIT-NAME        |017 |  ELSE                                  |
*| |RP-EDIT-NAME        |018 |    SET EXTENDED CHECK OFF              |
*| |RP-EDIT-NAME        |019 |    CALL FUNCTION 'RP_EDIT_NAME'       *|
*| |RP-EDIT-NAME        |020 |      EXPORTING    PP0002 = &2         *|
*| |RP-EDIT-NAME        |021 |                   MOLGA  = &3         *|
*| |RP-EDIT-NAME        |022 |                   LANGU  = &4         *|
*| |RP-EDIT-NAME        |023 |                   FORMAT = $$FORMAT   *|
*| |RP-EDIT-NAME        |024 |      IMPORTING EDIT_NAME = $EDIT-NAME *|
*| |RP-EDIT-NAME        |025 |                RETCODE   = $RET-CODE   |
*| |RP-EDIT-NAME        |026 |    SET EXTENDED CHECK ON               |
*| |RP-EDIT-NAME        |027 |  ENDIF                                 |
*| |RP-EDIT-NAME        |028 |  WHEN '0021'                           |
*| |RP-EDIT-NAME        |029 |    SET EXTENDED CHECK OFF              |
*| |RP-EDIT-NAME        |030 |    CALL FUNCTION 'RP_EDIT_NAME'       *|
*| |RP-EDIT-NAME        |031 |      EXPORTING    PP0021 = &2         *|
*| |RP-EDIT-NAME        |032 |                   MOLGA  = &3         *|
*| |RP-EDIT-NAME        |033 |                   LANGU  = &4         *|
*| |RP-EDIT-NAME        |034 |                   FORMAT = $$FORMAT   *|
*| |RP-EDIT-NAME        |035 |      IMPORTING EDIT_NAME = $EDIT-NAME *|
*| |RP-EDIT-NAME        |036 |                RETCODE   = $RET-CODE   |
*| |RP-EDIT-NAME        |037 |    SET EXTENDED CHECK ON               |
*| |RP-EDIT-NAME        |038 |  WHEN OTHERS                           |
*| |RP-EDIT-NAME        |039 |*   ABBRUCH-SITUATION                   |
*| |RP-EDIT-NAME        |040 |    $RET-CODE  = 12                     |
*| |RP-EDIT-NAME        |041 |ENDCASE                                 |
*| |RP-EDIT-NAME-J      |010 |****************************************|
*| |RP-EDIT-NAME-J      |020 |* RP-EDIT-NAME (JAPAN)                 *|
*| |RP-EDIT-NAME-J      |030 |****************************************|
*| |RP-EDIT-NAME-J      |040 |* PARAMETER IN:  P0001 (DEFAULT: ENAME)*|
*| |RP-EDIT-NAME-J      |050 |*                P0002 (DATEN ZUR PERS)*|
*| |RP-EDIT-NAME-J      |060 |*               <P0021 (FAMILIE-DATEN)>*|
*| |RP-EDIT-NAME-J      |070 |*                MOLGA (T001P-MOLGA)   *|
*| |RP-EDIT-NAME-J      |080 |*                LANGU (ANREDE-SPRACHE)*|
*| |RP-EDIT-NAME-J      |090 |*                FORMAT(LIKE SY-REPID )*|
*| |RP-EDIT-NAME-J      |100 |*                                      *|
*| |RP-EDIT-NAME-J      |110 |* PARAMETER OUT: $EDIT-NAME            *|
*| |RP-EDIT-NAME-J      |120 |*                $RET-CODE             *|
*| |RP-EDIT-NAME-J      |130 |****************************************|
*| |RP-EDIT-NAME-J      |140 |$$FORMAT_SAVE = $$FORMAT                |
*| |RP-EDIT-NAME-J      |150 |*                                       |
*| |RP-EDIT-NAME-J      |160 |  SELECT SINGLE * FROM T522F           *|
*| |RP-EDIT-NAME-J      |170 |         WHERE REPID EQ &5              |
*| |RP-EDIT-NAME-J      |180 |  IF SY-SUBRC EQ 0                      |
*| |RP-EDIT-NAME-J      |190 |    $$FORMAT = T522F-FORMT              |
*| |RP-EDIT-NAME-J      |200 |  ENDIF                                 |
*| |RP-EDIT-NAME-J      |210 |*                                       |
*| |RP-EDIT-NAME-J      |220 |CASE &2-INFTY                           |
*| |RP-EDIT-NAME-J      |230 |  WHEN '0002'                           |
*| |RP-EDIT-NAME-J      |240 |    IF $$FORMAT = '01'                  |
*| |RP-EDIT-NAME-J      |250 |      $EDIT-NAME = &1-ENAME             |
*| |RP-EDIT-NAME-J      |260 |      $RET-CODE  = 0                    |
*| |RP-EDIT-NAME-J      |270 |    ELSE                                |
*| |RP-EDIT-NAME-J      |280 |      CALL FUNCTION 'RP_EDIT_NAME'     *|
*| |RP-EDIT-NAME-J      |290 |           EXPORTING                   *|
*| |RP-EDIT-NAME-J      |300 |                PP0002    = &2         *|
*| |RP-EDIT-NAME-J      |310 |                MOLGA     = &3         *|
*| |RP-EDIT-NAME-J      |320 |                LANGU     = &4         *|
*| |RP-EDIT-NAME-J      |330 |                FORMAT    = $$FORMAT   *|
*| |RP-EDIT-NAME-J      |340 |           IMPORTING                   *|
*| |RP-EDIT-NAME-J      |350 |                EDIT_NAME = $EDIT-NAME *|
*| |RP-EDIT-NAME-J      |360 |                RETCODE   = $RET-CODE   |
*| |RP-EDIT-NAME-J      |370 |    ENDIF                               |
*| |RP-EDIT-NAME-J      |380 |  WHEN '0021'                           |
*| |RP-EDIT-NAME-J      |390 |    CALL FUNCTION 'RP_EDIT_NAME'       *|
*| |RP-EDIT-NAME-J      |400 |         EXPORTING                     *|
*| |RP-EDIT-NAME-J      |410 |              PP0021    = &2           *|
*| |RP-EDIT-NAME-J      |420 |              MOLGA     = &3           *|
*| |RP-EDIT-NAME-J      |430 |              LANGU     = &4           *|
*| |RP-EDIT-NAME-J      |440 |              FORMAT    = $$FORMAT     *|
*| |RP-EDIT-NAME-J      |450 |         IMPORTING                     *|
*| |RP-EDIT-NAME-J      |460 |              EDIT_NAME = $EDIT-NAME   *|
*| |RP-EDIT-NAME-J      |470 |              RETCODE   = $RET-CODE     |
*| |RP-EDIT-NAME-J      |480 |  WHEN OTHERS                           |
*| |RP-EDIT-NAME-J      |490 |    $RET-CODE  = 12                     |
*| |RP-EDIT-NAME-J      |500 |ENDCASE                                 |
*| |RP-EDIT-NAME-J      |510 |$$FORMAT = $$FORMAT_SAVE                |
*| |RP-EXP-AP           |001 |****************************************|
*| |RP-EXP-AP           |002 |* CLUSTER AP: Action-log Schedule      *|
*| |RP-EXP-AP           |003 |****************************************|
*| |RP-EXP-AP           |004 |EXPORT ACT_LOG                         *|
*| |RP-EXP-AP           |005 |****************************************|
*| |RP-EXP-AP           |006 |       SCHEDULE                        *|
*| |RP-EXP-AP           |007 |TO DATABASE PCL1(AP)                   *|
*| |RP-EXP-AP           |008 |ID AP-KEY                               |
*| |RP-EXP-B0-DS        |001 |****************************************|
*| |RP-EXP-B0-DS        |002 |* CLUSTER B0: BDE-DATEN AUF FILE       *|
*| |RP-EXP-B0-DS        |003 |****************************************|
*| |RP-EXP-B0-DS        |007 |EXPORT B0-VERSION                      *|
*| |RP-EXP-B0-DS        |008 |       ZL                              *|
*| |RP-EXP-B0-DS        |009 |       KNTAG                           *|
*| |RP-EXP-B0-DS        |010 |       MT                              *|
*| |RP-EXP-B0-DS        |011 |       PT                              *|
*| |RP-EXP-B0-DS        |012 |       AT                              *|
*| |RP-EXP-B0-DS        |013 |       WST                             *|
*| |RP-EXP-B0-DS        |014 |       SALDO                           *|
*| |RP-EXP-B0-DS        |015 |       ZES                             *|
*| |RP-EXP-B0-DS        |016 |       ZKO                             *|
*| |RP-EXP-B0-DS        |017 |       ANWKONTI                        *|
*| |RP-EXP-B0-DS        |018 |       ABWKONTI                        *|
*| |RP-EXP-B0-DS        |019 |       FEHLER                          *|
*| |RP-EXP-B0-DS        |020 |       FT                              *|
*| |RP-EXP-B0-DS        |021 |       PSP                             *|
*| |RP-EXP-B0-DS        |022 |       NAME                            *|
*| |RP-EXP-B0-DS        |023 |       ADR                             *|
*| |RP-EXP-B0-DS        |024 |       AP                              *|
*| |RP-EXP-B0-DS        |025 |       ABWES                           *|
*| |RP-EXP-B0-DS        |026 |       VERT                            *|
*| |RP-EXP-B0-DS        |027 |       BEZUG                           *|
*| |RP-EXP-B0-DS        |028 |       SKO                             *|
*| |RP-EXP-B0-DS        |029 |       MEHR                            *|
*| |RP-EXP-B0-DS        |030 |       ANWES                           *|
*| |RP-EXP-B0-DS        |031 |       RUFB                            *|
*| |RP-EXP-B0-DS        |032 |TO DATASET FILE(B0)                    *|
*| |RP-EXP-B0-DS        |033 |ID KEY                                  |
*| |RP-EXP-B1-DS        |001 |****************************************|
*| |RP-EXP-B1-DS        |002 |* CLUSTER B1: BDE-DATEN                *|
*| |RP-EXP-B1-DS        |004 |****************************************|
*| |RP-EXP-B1-DS        |005 |EXPORT B1-VERSION                      *|
*| |RP-EXP-B1-DS        |006 |       MTB1                            *|
*| |RP-EXP-B1-DS        |007 |       NT1                             *|
*| |RP-EXP-B1-DS        |008 |       NT2                             *|
*| |RP-EXP-B1-DS        |009 |       DT                              *|
*| |RP-EXP-B1-DS        |010 |       PTB1                            *|
*| |RP-EXP-B1-DS        |011 |       ATB1                            *|
*| |RP-EXP-B1-DS        |012 |       WSTB1                           *|
*| |RP-EXP-B1-DS        |013 |       ERT                             *|
*| |RP-EXP-B1-DS        |014 |       NCT                             *|
*| |RP-EXP-B1-DS        |015 |       QT                              *|
*| |RP-EXP-B1-DS        |016 |       ST                              *|
*| |RP-EXP-B1-DS        |017 |TO DATASET FILE(B1)                    *|
*| |RP-EXP-B1-DS        |018 |ID KEY                                  |
*| |RP-EXP-C1-G1        |001 |****************************************|
*| |RP-EXP-C1-G1        |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-EXP-C1-G1        |003 |****************************************|
*| |RP-EXP-C1-G1        |004 |EXPORT G1-VERSION                      *|
*| |RP-EXP-C1-G1        |005 |       GB                              *|
*| |RP-EXP-C1-G1        |006 |       GA                              *|
*| |RP-EXP-C1-G1        |007 |       GE                              *|
*| |RP-EXP-C1-G1        |008 |       GK                              *|
*| |RP-EXP-C1-G1        |009 |       GP                              *|
*| |RP-EXP-C1-G1        |010 |       GPA                             *|
*| |RP-EXP-C1-G1        |011 |TO   DATABASE PCL1(G1)                 *|
*| |RP-EXP-C1-G1        |012 |ID G1-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-G1        |013 |RP-IMP-G1-SUBRC = SY-SUBRC              |
*| |RP-EXP-C1-G3        |001 |****************************************|
*| |RP-EXP-C1-G3        |002 |* CLUSTER G3: BDE-DATEN FUER GRUPPEN   *|
*| |RP-EXP-C1-G3        |003 |****************************************|
*| |RP-EXP-C1-G3        |004 |EXPORT G3-VERSION                      *|
*| |RP-EXP-C1-G3        |005 |       GMT                             *|
*| |RP-EXP-C1-G3        |006 |       GNT1                            *|
*| |RP-EXP-C1-G3        |007 |       GNT2                            *|
*| |RP-EXP-C1-G3        |008 |       GDT                             *|
*| |RP-EXP-C1-G3        |009 |       GGMT                            *|
*| |RP-EXP-C1-G3        |010 |       GSTT                            *|
*| |RP-EXP-C1-G3        |011 |       SGMT                            *|
*| |RP-EXP-C1-G3        |012 |       PNT                             *|
*| |RP-EXP-C1-G3        |013 |       GERT                            *|
*| |RP-EXP-C1-G3        |014 |       GNCT                            *|
*| |RP-EXP-C1-G3        |015 |       GQT                             *|
*| |RP-EXP-C1-G3        |016 |TO   DATABASE PCL1(G3)                 *|
*| |RP-EXP-C1-G3        |017 |ID G3-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-G3        |018 |RP-IMP-G3-SUBRC = SY-SUBRC              |
*| |RP-EXP-C1-G3        |019 |       GNCT                            *|
*| |RP-EXP-C1-G3        |020 |       GQT                             *|
*| |RP-EXP-C1-G3        |024 |TO   DATABASE PCL1(G3)                 *|
*| |RP-EXP-C1-G3        |025 |ID G3-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-G3-CONV   |001 |****************************************|
*| |RP-EXP-C1-G3-CONV   |002 |* CLUSTER G3: BDE-DATEN FÜR GRUPPEN    *|
*| |RP-EXP-C1-G3-CONV   |003 |****************************************|
*| |RP-EXP-C1-G3-CONV   |004 |EXPORT G3-VERSION                      *|
*| |RP-EXP-C1-G3-CONV   |005 |       GMTG3  FROM GMT                 *|
*| |RP-EXP-C1-G3-CONV   |006 |       GNT1                            *|
*| |RP-EXP-C1-G3-CONV   |007 |       GNT2                            *|
*| |RP-EXP-C1-G3-CONV   |008 |       GDTG3  FROM GDT                 *|
*| |RP-EXP-C1-G3-CONV   |009 |       GGMTG3 FROM GGMT                *|
*| |RP-EXP-C1-G3-CONV   |010 |       GSTTG3 FROM GSTT                *|
*| |RP-EXP-C1-G3-CONV   |011 |       SGMTG3 FROM SGMT                *|
*| |RP-EXP-C1-G3-CONV   |012 |       PNTG3  FROM PNT                 *|
*| |RP-EXP-C1-G3-CONV   |013 |       GERT                            *|
*| |RP-EXP-C1-G3-CONV   |014 |       GNCT                            *|
*| |RP-EXP-C1-G3-CONV   |015 |       GQT                             *|
*| |RP-EXP-C1-G3-CONV   |016 |TO DATABASE PCL1(G3)                   *|
*| |RP-EXP-C1-G3-CONV   |017 |ID G3-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-G3-CONV   |018 |RP-IMP-G3-SUBRC = SY-SUBRC              |
*| |RP-EXP-C1-L1        |001 |****************************************|
*| |RP-EXP-C1-L1        |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-EXP-C1-L1        |003 |****************************************|
*| |RP-EXP-C1-L1        |004 |EXPORT L1-VERSION                      *|
*| |RP-EXP-C1-L1        |005 |       PB                              *|
*| |RP-EXP-C1-L1        |006 |       LE                              *|
*| |RP-EXP-C1-L1        |007 |       PE                              *|
*| |RP-EXP-C1-L1        |008 |       LK                              *|
*| |RP-EXP-C1-L1        |009 |       GT                              *|
*| |RP-EXP-C1-L1        |010 |       LPA                             *|
*| |RP-EXP-C1-L1        |011 |TO DATABASE PCL1(L1)                   *|
*| |RP-EXP-C1-L1        |012 |ID L1-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-L1        |013 |RP-IMP-L1-SUBRC = SY-SUBRC              |
*| |RP-EXP-C1-LL        |001 |****************************************|
*| |RP-EXP-C1-LL        |002 |* CLUSTER LL: EINZEL-LEISTUNGSLOHN     *|
*| |RP-EXP-C1-LL        |003 |* DIESES CLUSTER WIRD NICHT AUF DIE    *|
*| |RP-EXP-C1-LL        |004 |* DATENBANK GESCHRIEBEN, SONDERN DIENT *|
*| |RP-EXP-C1-LL        |005 |* ALS SCHNITTSTELLE ZUM VERBUCHER      *|
*| |RP-EXP-C1-LL        |006 |****************************************|
*| |RP-EXP-C1-LL        |007 |EXPORT IPTAB                           *|
*| |RP-EXP-C1-LL        |008 |       LE2 GT2 PB2 PE2 LK2             *|
*| |RP-EXP-C1-LL        |009 |TO   DATABASE PCL1(LL)                 *|
*| |RP-EXP-C1-LL        |010 |ID SPACE USING PCL1_EXP_IMP             |
*| |RP-EXP-C1-LL        |011 |RP-IMP-LL-SUBRC = SY-SUBRC              |
*| |RP-EXP-C1-PC        |001 |****************************************|
*| |RP-EXP-C1-PC        |002 |* CLUSTER PC: PERSONNEL CALENDAR       *|
*| |RP-EXP-C1-PC        |003 |****************************************|
*| |RP-EXP-C1-PC        |004 |****************************************|
*| |RP-EXP-C1-PC        |005 |PCL1-VERSN = PC-VERSION-NUMMER          |
*| |RP-EXP-C1-PC        |006 |PC-VERSION-UNAME = SY-UNAME             |
*| |RP-EXP-C1-PC        |007 |PC-VERSION-DATUM = SY-DATUM             |
*| |RP-EXP-C1-PC        |008 |PC-VERSION-UZEIT = SY-UZEIT             |
*| |RP-EXP-C1-PC        |009 |PC-VERSION-PGMID = SY-REPID             |
*| |RP-EXP-C1-PC        |010 |EXPORT PC-VERSION                      *|
*| |RP-EXP-C1-PC        |011 |       PCALE                           *|
*| |RP-EXP-C1-PC        |012 |       NCALE                           *|
*| |RP-EXP-C1-PC        |013 |       PC-NATION                       *|
*| |RP-EXP-C1-PC        |014 |       PURL                            *|
*| |RP-EXP-C1-PC        |015 |TO DATABASE PCL1(PC)                   *|
*| |RP-EXP-C1-PC        |016 |ID PC-KEY                              *|
*| |RP-EXP-C1-PC        |017 |USING PCL1_EXP_IMP                      |
*| |RP-EXP-C1-TX        |001 |****************************************|
*| |RP-EXP-C1-TX        |002 |* CLUSTER TX: TEXTE FUER PREL          *|
*| |RP-EXP-C1-TX        |003 |****************************************|
*| |RP-EXP-C1-TX        |004 |EXPORT TEXT-VERSION                    *|
*| |RP-EXP-C1-TX        |005 |       PTEXT                           *|
*| |RP-EXP-C1-TX        |006 |TO DATABASE PCL1(TX)                   *|
*| |RP-EXP-C1-TX        |007 |ID TX-KEY                              *|
*| |RP-EXP-C1-TX        |008 |USING PCL1_EXP_IMP                      |
*| |RP-EXP-C1-U1        |001 |****************************************|
*| |RP-EXP-C1-U1        |002 |* CLUSTER U1: North America            *|
*| |RP-EXP-C1-U1        |003 |* Extra data for infotypes             *|
*| |RP-EXP-C1-U1        |004 |****************************************|
*| |RP-EXP-C1-U1        |005 |EXPORT U1-VERSION                      *|
*| |RP-EXP-C1-U1        |006 |       AT                              *|
*| |RP-EXP-C1-U1        |007 |TO   DATABASE PCL1(U1)                 *|
*| |RP-EXP-C1-U1        |008 |ID U1-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-C1-ZI        |001 |****************************************|
*| |RP-EXP-C1-ZI        |002 |* CLUSTER ZI: INTERFACE ZU RK/RM       *|
*| |RP-EXP-C1-ZI        |003 |****************************************|
*| |RP-EXP-C1-ZI        |004 |EXPORT ZI-VERSION                      *|
*| |RP-EXP-C1-ZI        |005 |       VBINT                           *|
*| |RP-EXP-C1-ZI        |006 |TO DATABASE PCL1(ZI)                   *|
*| |RP-EXP-C1-ZI        |007 |ID ZI-KEY                               |
*| |RP-EXP-C2-CW        |001 |****************************************|
*| |RP-EXP-C2-CW        |002 |* CLUSTER CW: CLUSTER DIRECTORY EXPORT *|
*| |RP-EXP-C2-CW        |003 |* SI TRIMESTERDATA PER PERSON  (B)     *|
*| |RP-EXP-C2-CW        |004 |****************************************|
*| |RP-EXP-C2-CW        |005 |PCL2-AEDTM = SY-DATUM                   |
*| |RP-EXP-C2-CW        |006 |PCL2-UNAME = SY-UNAME                   |
*| |RP-EXP-C2-CW        |007 |PCL2-PGMID = SY-REPID                   |
*| |RP-EXP-C2-CW        |008 |MOVE: SY-SAPRL    TO CW_VERSION-SAPRL, *|
*| |RP-EXP-C2-CW        |009 |      SY-UNAME    TO CW_VERSION-UNAME, *|
*| |RP-EXP-C2-CW        |010 |      SY-DATUM    TO CW_VERSION-DATUM, *|
*| |RP-EXP-C2-CW        |011 |      SY-UZEIT    TO CW_VERSION-UZEIT, *|
*| |RP-EXP-C2-CW        |012 |      SY-REPID    TO CW_VERSION-PGMID, *|
*| |RP-EXP-C2-CW        |013 |      VERSC-MOLGA TO CW_VERSION-MOLGA   |
*| |RP-EXP-C2-CW        |014 |EXPORT CW_VERSION                      *|
*| |RP-EXP-C2-CW        |015 |       CW_NEXT_SEQ                     *|
*| |RP-EXP-C2-CW        |016 |       CW_LAST_SI                      *|
*| |RP-EXP-C2-CW        |017 |       WWDIR                           *|
*| |RP-EXP-C2-CW        |018 |       RBDIR                           *|
*| |RP-EXP-C2-CW        |019 |       HRT                             *|
*| |RP-EXP-C2-CW        |020 |TO DATABASE PCL2(CW)                   *|
*| |RP-EXP-C2-CW        |021 |ID CW-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-CW        |022 |IF SY-SUBRC NE 0                        |
*| |RP-EXP-C2-CW        |023 |  CLEAR: CW_NEXT_SEQ,                  *|
*| |RP-EXP-C2-CW        |024 |         CW_LAST_SI,                   *|
*| |RP-EXP-C2-CW        |025 |         WWDIR,                        *|
*| |RP-EXP-C2-CW        |026 |         RBDIR,                        *|
*| |RP-EXP-C2-CW        |027 |         HRT                            |
*| |RP-EXP-C2-CW        |028 |  REFRESH: WWDIR, RBDIR, HRT            |
*| |RP-EXP-C2-CW        |029 |ENDIF                                   |
*| |RP-EXP-C2-CX        |001 |****************************************|
*| |RP-EXP-C2-CX        |002 |* CLUSTER CX: CLUSTER DIRECTORY EXPORT *|
*| |RP-EXP-C2-CX        |003 |****************************************|
*| |RP-EXP-C2-CX        |004 |PCL2-AEDTM = SY-DATUM                   |
*| |RP-EXP-C2-CX        |005 |PCL2-UNAME = SY-UNAME                   |
*| |RP-EXP-C2-CX        |006 |PCL2-PGMID = SY-REPID                   |
*| |RP-EXP-C2-CX        |007 |MOVE: SY-SAPRL    TO CX_VERSION-SAPRL, *|
*| |RP-EXP-C2-CX        |008 |      SY-UNAME    TO CX_VERSION-UNAME, *|
*| |RP-EXP-C2-CX        |009 |      SY-DATUM    TO CX_VERSION-DATUM, *|
*| |RP-EXP-C2-CX        |010 |      SY-UZEIT    TO CX_VERSION-UZEIT, *|
*| |RP-EXP-C2-CX        |011 |      SY-REPID    TO CX_VERSION-PGMID   |
*| |RP-EXP-C2-CX        |013 |EXPORT CX_VERSION                      *|
*| |RP-EXP-C2-CX        |014 |       CX_NEXT_SEQ                     *|
*| |RP-EXP-C2-CX        |015 |       CX_LAST_SI                      *|
*| |RP-EXP-C2-CX        |016 |       WXDIR                           *|
*| |RP-EXP-C2-CX        |017 |       XWWDIR                          *|
*| |RP-EXP-C2-CX        |018 |TO DATABASE PCL2(CX)                   *|
*| |RP-EXP-C2-CX        |019 |ID CX-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-CX        |020 |IF SY-SUBRC NE 0                        |
*| |RP-EXP-C2-CX        |021 |  CLEAR: CX_NEXT_SEQ,                  *|
*| |RP-EXP-C2-CX        |022 |         WXDIR,                        *|
*| |RP-EXP-C2-CX        |023 |         XWWDIR                         |
*| |RP-EXP-C2-CX        |024 |  REFRESH: WXDIR, XWWDIR                |
*| |RP-EXP-C2-CX        |025 |ENDIF                                   |
*| |RP-EXP-C2-CY        |001 |****************************************|
*| |RP-EXP-C2-CY        |002 |* CLUSTER CY: CLUSTER DIRECTORY EXPORT *|
*| |RP-EXP-C2-CY        |003 |****************************************|
*| |RP-EXP-C2-CY        |004 |PCL2-AEDTM = SY-DATUM                   |
*| |RP-EXP-C2-CY        |005 |PCL2-UNAME = SY-UNAME                   |
*| |RP-EXP-C2-CY        |006 |PCL2-PGMID = SY-REPID                   |
*| |RP-EXP-C2-CY        |007 |MOVE: SY-SAPRL    TO CY-VERSION-SAPRL, *|
*| |RP-EXP-C2-CY        |008 |      SY-UNAME    TO CY-VERSION-UNAME, *|
*| |RP-EXP-C2-CY        |009 |      SY-DATUM    TO CY-VERSION-DATUM, *|
*| |RP-EXP-C2-CY        |010 |      SY-UZEIT    TO CY-VERSION-UZEIT, *|
*| |RP-EXP-C2-CY        |011 |      SY-REPID    TO CY-VERSION-PGMID   |
*| |RP-EXP-C2-CY        |012 |                                        |
*| |RP-EXP-C2-CY        |013 |EXPORT CY-VERSION                      *|
*| |RP-EXP-C2-CY        |014 |       CY-NEXT_SEQ                     *|
*| |RP-EXP-C2-CY        |015 |       CY-LAST_SI                      *|
*| |RP-EXP-C2-CY        |016 |       WYDIR                           *|
*| |RP-EXP-C2-CY        |017 |       WRBDIR                          *|
*| |RP-EXP-C2-CY        |018 |TO DATABASE PCL2(CY)                   *|
*| |RP-EXP-C2-CY        |019 |ID CY-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-CY        |020 |IF SY-SUBRC NE 0                        |
*| |RP-EXP-C2-CY        |021 |  CLEAR: CY-NEXT_SEQ,                  *|
*| |RP-EXP-C2-CY        |022 |         WYDIR,                        *|
*| |RP-EXP-C2-CY        |023 |         WRBDIR                         |
*| |RP-EXP-C2-CY        |024 |  REFRESH: WYDIR, WRBDIR                |
*| |RP-EXP-C2-CY        |025 |ENDIF                                   |
*| |RP-EXP-C2-GP        |001 |****************************************|
*| |RP-EXP-C2-GP        |002 |* CLUSTER GP:GB RECONCILIATION RECORDS *|
*| |RP-EXP-C2-GP        |003 |* RPC2GPG0 CONTAINS CLUSTER DEFINITION *|
*| |RP-EXP-C2-GP        |004 |****************************************|
*| |RP-EXP-C2-GP        |005 |GP-VERSION-SAPRL  = SY-SAPRL            |
*| |RP-EXP-C2-GP        |006 |GP-VERSION-UNAME  = SY-UNAME            |
*| |RP-EXP-C2-GP        |007 |GP-VERSION-DATUM  = SY-DATUM            |
*| |RP-EXP-C2-GP        |008 |GP-VERSION-UZEIT  = SY-UZEIT            |
*| |RP-EXP-C2-GP        |009 |GP-VERSION-PGMID  = SY-REPID            |
*| |RP-EXP-C2-GP        |010 |EXPORT GP-VERSION                      *|
*| |RP-EXP-C2-GP        |011 |       TRANSFER                        *|
*| |RP-EXP-C2-GP        |012 |       CUMT                            *|
*| |RP-EXP-C2-GP        |013 |       ADJMT                           *|
*| |RP-EXP-C2-GP        |014 |       STLVS                           *|
*| |RP-EXP-C2-GP        |015 |       CRTLVS                          *|
*| |RP-EXP-C2-GP        |016 |       REJECTED                        *|
*| |RP-EXP-C2-GP        |017 |       HD_CNT                          *|
*| |RP-EXP-C2-GP        |018 |       BDPAY                           *|
*| |RP-EXP-C2-GP        |019 |       ADRET                           *|
*| |RP-EXP-C2-GP        |020 |TO DATABASE PCL2(GP) ID GP-KEY         *|
*| |RP-EXP-C2-GP        |021 |      USING PCL2_EXP_IMP                |
*| |RP-EXP-C2-GP        |022 |RP-EXP-GP-SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-Q0        |001 |****************************************|
*| |RP-EXP-C2-Q0        |002 |* CLUSTER Q0: BESCHEINIGUNG INTERNATION*|
*| |RP-EXP-C2-Q0        |003 |****************************************|
*| |RP-EXP-C2-Q0        |004 |EXPORT Q0-VERSION                      *|
*| |RP-EXP-C2-Q0        |005 |       VAL                             *|
*| |RP-EXP-C2-Q0        |006 |       TXT                             *|
*| |RP-EXP-C2-Q0        |007 |TO DATABASE PCL2(Q0)                   *|
*| |RP-EXP-C2-Q0        |008 |ID Q0-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-R1        |001 |****************************************|
*| |RP-EXP-C2-R1        |002 |* CLUSTER RU: PAYROLL RESULTS (USA)    *|
*| |RP-EXP-C2-R1        |003 |****************************************|
*| |RP-EXP-C2-R1        |004 |  CALL FUNCTION 'RP_SPLIT_TCRT'        *|
*| |RP-EXP-C2-R1        |005 |    TABLES    ITCRT   =  TCRT          *|
*| |RP-EXP-C2-R1        |006 |              OTCRTA  =  TCRT          *|
*| |RP-EXP-C2-R1        |007 |              OTCRTB  =  TCRT          *|
*| |RP-EXP-C2-R1        |008 |    EXCEPTIONS  SPLIT_ERROR = 01        |
*| |RP-EXP-C2-R1        |009 |*                                       |
*| |RP-EXP-C2-R1        |010 |RU-VERSION-NUMBER = '00'                |
*| |RP-EXP-C2-R1        |011 |PCL2-VERSN = '00'                       |
*| |RP-EXP-C2-R1        |012 |EXPORT RU-VERSION                      *|
*| |RP-EXP-C2-R1        |013 |       PERM                            *|
*| |RP-EXP-C2-R1        |014 |       WPBP                            *|
*| |RP-EXP-C2-R1        |015 |       TAX                             *|
*| |RP-EXP-C2-R1        |016 |       TAXR                            *|
*| |RP-EXP-C2-R1        |017 |       TAXPR                           *|
*| |RP-EXP-C2-R1        |018 |       RT                              *|
*| |RP-EXP-C2-R1        |019 |       CRT                             *|
*| |RP-EXP-C2-R1        |020 |       TCRT                            *|
*| |RP-EXP-C2-R1        |022 |TO   DATABASE PCL2(R1)                 *|
*| |RP-EXP-C2-R1        |023 |ID RX-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-R1        |024 |RP-IMP-RU-SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-R1        |025 |                                        |
*| |RP-EXP-C2-R1        |026 |                                        |
*| |RP-EXP-C2-R1        |027 |                                        |
*| |RP-EXP-C2-R1        |028 |                                        |
*| |RP-EXP-C2-R1        |029 |                                        |
*| |RP-EXP-C2-SP        |001 |* CLUSTER SP: STATUTORY SICKPAY (GB)   *|
*| |RP-EXP-C2-SP        |002 |EXPORT SP-VERSION                      *|
*| |RP-EXP-C2-SP        |003 |       WEEKS_FILLED                    *|
*| |RP-EXP-C2-SP        |004 |       WEEK01                          *|
*| |RP-EXP-C2-SP        |005 |       WEEK02                          *|
*| |RP-EXP-C2-SP        |006 |       WEEK03                          *|
*| |RP-EXP-C2-SP        |007 |       WEEK04                          *|
*| |RP-EXP-C2-SP        |008 |       WEEK05                          *|
*| |RP-EXP-C2-SP        |009 |       WEEK06                          *|
*| |RP-EXP-C2-SP        |010 |       WEEK07                          *|
*| |RP-EXP-C2-SP        |011 |       WEEK08                          *|
*| |RP-EXP-C2-SP        |012 |       WEEK09                          *|
*| |RP-EXP-C2-SP        |013 |       WEEK10                          *|
*| |RP-EXP-C2-SP        |014 |       WEEK11                          *|
*| |RP-EXP-C2-SP        |015 |       WEEK12                          *|
*| |RP-EXP-C2-SP        |016 |       WEEK13                          *|
*| |RP-EXP-C2-SP        |017 |       WEEK14                          *|
*| |RP-EXP-C2-SP        |018 |       WEEK15                          *|
*| |RP-EXP-C2-SP        |019 |       WEEK16                          *|
*| |RP-EXP-C2-SP        |020 |       WEEK17                          *|
*| |RP-EXP-C2-SP        |021 |       WEEK18                          *|
*| |RP-EXP-C2-SP        |022 |       WEEK19                          *|
*| |RP-EXP-C2-SP        |023 |       WEEK20                          *|
*| |RP-EXP-C2-SP        |024 |       WEEK21                          *|
*| |RP-EXP-C2-SP        |025 |       WEEK22                          *|
*| |RP-EXP-C2-SP        |026 |       WEEK23                          *|
*| |RP-EXP-C2-SP        |027 |       WEEK24                          *|
*| |RP-EXP-C2-SP        |028 |       WEEK25                          *|
*| |RP-EXP-C2-SP        |029 |       WEEK26                          *|
*| |RP-EXP-C2-SP        |030 |       WEEK27                          *|
*| |RP-EXP-C2-SP        |031 |       WEEK28                          *|
*| |RP-EXP-C2-SP        |032 |       WEEK29                          *|
*| |RP-EXP-C2-SP        |033 |       WEEK30                          *|
*| |RP-EXP-C2-SP        |034 |       WEEK31                          *|
*| |RP-EXP-C2-SP        |035 |       WEEK32                          *|
*| |RP-EXP-C2-SP        |036 |       WEEK33                          *|
*| |RP-EXP-C2-SP        |037 |       WEEK34                          *|
*| |RP-EXP-C2-SP        |038 |       WEEK35                          *|
*| |RP-EXP-C2-SP        |039 |       WEEK36                          *|
*| |RP-EXP-C2-SP        |040 |       WEEK37                          *|
*| |RP-EXP-C2-SP        |041 |       WEEK38                          *|
*| |RP-EXP-C2-SP        |042 |       WEEK39                          *|
*| |RP-EXP-C2-SP        |043 |       WEEK40                          *|
*| |RP-EXP-C2-SP        |044 |       WEEK41                          *|
*| |RP-EXP-C2-SP        |045 |       WEEK42                          *|
*| |RP-EXP-C2-SP        |046 |       WEEK43                          *|
*| |RP-EXP-C2-SP        |047 |       WEEK44                          *|
*| |RP-EXP-C2-SP        |048 |       WEEK45                          *|
*| |RP-EXP-C2-SP        |049 |       WEEK46                          *|
*| |RP-EXP-C2-SP        |050 |       WEEK47                          *|
*| |RP-EXP-C2-SP        |051 |       WEEK48                          *|
*| |RP-EXP-C2-SP        |052 |       WEEK49                          *|
*| |RP-EXP-C2-SP        |053 |       WEEK50                          *|
*| |RP-EXP-C2-SP        |054 |       WEEK51                          *|
*| |RP-EXP-C2-SP        |055 |       WEEK52                          *|
*| |RP-EXP-C2-SP        |056 |       WEEK53                          *|
*| |RP-EXP-C2-SP        |057 |TO DATABASE PCL2(SP)                   *|
*| |RP-EXP-C2-SP        |058 |ID SP-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-WW        |001 |****************************************|
*| |RP-EXP-C2-WW        |002 |* CLUSTER WW: PAYROLL (BELGIUM)  SI  ***|
*| |RP-EXP-C2-WW        |003 |****************************************|
*| |RP-EXP-C2-WW        |004 |EXPORT WW_VERSION                      *|
*| |RP-EXP-C2-WW        |005 |       WWPBP                           *|
*| |RP-EXP-C2-WW        |006 |       WAB                             *|
*| |RP-EXP-C2-WW        |007 |       WRT                             *|
*| |RP-EXP-C2-WW        |008 |       WSV                             *|
*| |RP-EXP-C2-WW        |009 |       WDATE                           *|
*| |RP-EXP-C2-WW        |010 |       WFIRE                           *|
*| |RP-EXP-C2-WW        |011 |TO   DATABASE PCL2(WW)                 *|
*| |RP-EXP-C2-WW        |012 |ID WW-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-WW        |013 |RP_IMP_WW_SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-WX        |001 |****************************************|
*| |RP-EXP-C2-WX        |002 |* CLUSTER WX: PAYROLL (BELGIUM)  SI  ***|
*| |RP-EXP-C2-WX        |003 |****************************************|
*| |RP-EXP-C2-WX        |004 |EXPORT WX_VERSION                      *|
*| |RP-EXP-C2-WX        |005 |       WSI                             *|
*| |RP-EXP-C2-WX        |006 |TO   DATABASE PCL2(WX)                 *|
*| |RP-EXP-C2-WX        |007 |ID WX-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-WX        |008 |RP_IMP_WX_SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-WY        |001 |****************************************|
*| |RP-EXP-C2-WY        |002 |* CLUSTER WY: PAYROLL (BELGIUM)  TAXES *|
*| |RP-EXP-C2-WY        |003 |****************************************|
*| |RP-EXP-C2-WY        |004 |EXPORT WY-VERSION                      *|
*| |RP-EXP-C2-WY        |005 |       W274                            *|
*| |RP-EXP-C2-WY        |006 |       WTAX                            *|
*| |RP-EXP-C2-WY        |007 |TO   DATABASE PCL2(WY)                 *|
*| |RP-EXP-C2-WY        |008 |ID WY-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-WY        |009 |RP-IMP-WY-SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-ZA        |001 |****************************************|
*| |RP-EXP-C2-ZA        |002 |* CLUSTER ZA: DURCHSCHNITT     VBL/ZVK *|
*| |RP-EXP-C2-ZA        |003 |****************************************|
*| |RP-EXP-C2-ZA        |004 |EXPORT DURCHSCHNITT                    *|
*| |RP-EXP-C2-ZA        |007 |TO DATABASE PCL2(ZA)                   *|
*| |RP-EXP-C2-ZA        |008 |ID ZA-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-ZA        |009 |RP-EXP-ZA-SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-ZD        |001 |****************************************|
*| |RP-EXP-C2-ZD        |002 |* CLUSTER ZD: STEUER/DURCHSCH. VBL/ZVK *|
*| |RP-EXP-C2-ZD        |003 |****************************************|
*| |RP-EXP-C2-ZD        |004 |EXPORT VORAUS_UMLAGE                   *|
*| |RP-EXP-C2-ZD        |007 |TO DATABASE PCL2(ZD)                   *|
*| |RP-EXP-C2-ZD        |008 |ID ZD-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-ZD        |009 |RP-EXP-ZD-SUBRC = SY-SUBRC              |
*| |RP-EXP-C2-ZS        |001 |****************************************|
*| |RP-EXP-C2-ZS        |002 |* CLUSTER ZS: EINMALZAHLUNG VBL/ZVK    *|
*| |RP-EXP-C2-ZS        |003 |****************************************|
*| |RP-EXP-C2-ZS        |004 |PCL2-VERSN = '00'                       |
*| |RP-EXP-C2-ZS        |005 |EXPORT ZS-VERSION                      *|
*| |RP-EXP-C2-ZS        |006 |       EINMAL_ZAHLUNG                  *|
*| |RP-EXP-C2-ZS        |007 |TO DATABASE PCL2(ZS)                   *|
*| |RP-EXP-C2-ZS        |008 |ID ZS-KEY USING PCL2_EXP_IMP            |
*| |RP-EXP-C2-ZS        |009 |RP-EXP-ZS-SUBRC = SY-SUBRC              |
*| |RP-EXP-C3-AL        |001 |****************************************|
*| |RP-EXP-C3-AL        |002 |* CLUSTER AL: BRIEFE FÜR VORGÄNGE      *|
*| |RP-EXP-C3-AL        |003 |****************************************|
*| |RP-EXP-C3-AL        |004 |DATA: RP-EXP-C3-AL-SUBRC LIKE SY-SUBRC  |
*| |RP-EXP-C3-AL        |005 |AL-VERSION-NUMMER = '01'                |
*| |RP-EXP-C3-AL        |006 |EXPORT AL-VERSION                      *|
*| |RP-EXP-C3-AL        |007 |       LETTER                          *|
*| |RP-EXP-C3-AL        |008 |TO DATABASE PCL3(AL)                   *|
*| |RP-EXP-C3-AL        |009 |ID AL-KEY                              *|
*| |RP-EXP-C3-AL        |010 |USING PCL3_EXP_IMP                      |
*| |RP-EXP-C3-AL        |011 |RP-EXP-C3-AL-SUBRC = SY-SUBRC           |
*| |RP-EXP-C3-AN        |001 |****************************************|
*| |RP-EXP-C3-AN        |002 |* CLUSTER AN: NOTE-PAD F. VORGÄNGE     *|
*| |RP-EXP-C3-AN        |003 |****************************************|
*| |RP-EXP-C3-AN        |004 |DATA: RP-EXP-C3-AN-SUBRC LIKE SY-SUBRC  |
*| |RP-EXP-C3-AN        |005 |AN-VERSION-NUMMER = '01'                |
*| |RP-EXP-C3-AN        |006 |EXPORT AN-VERSION                      *|
*| |RP-EXP-C3-AN        |007 |       NOTES                           *|
*| |RP-EXP-C3-AN        |008 |TO DATABASE PCL3(AN)                   *|
*| |RP-EXP-C3-AN        |009 |ID AN-KEY                              *|
*| |RP-EXP-C3-AN        |010 |USING PCL3_EXP_IMP                      |
*| |RP-EXP-C3-AN        |011 |RP-EXP-C3-AN-SUBRC = SY-SUBRC           |
*| |RP-EXP-C3-AP        |001 |****************************************|
*| |RP-EXP-C3-AP        |002 |* CLUSTER AP: VORGAENGE BEWERBERVERW.  *|
*| |RP-EXP-C3-AP        |003 |****************************************|
*| |RP-EXP-C3-AP        |004 |DATA: RP-EXP-C3-AP-SUBRC LIKE SY-SUBRC  |
*| |RP-EXP-C3-AP        |005 |DATA: ENTRIES LIKE SY-TABIX             |
*| |RP-EXP-C3-AP        |006 |AP-VERSION-NUMMER = '02'                |
*| |RP-EXP-C3-AP        |007 |EXPORT AP-VERSION                      *|
*| |RP-EXP-C3-AP        |008 |       ACTIV                           *|
*| |RP-EXP-C3-AP        |009 |TO DATABASE PCL3(AP)                   *|
*| |RP-EXP-C3-AP        |010 |ID AP-KEY                              *|
*| |RP-EXP-C3-AP        |011 |USING PCL3_EXP_IMP                      |
*| |RP-EXP-C3-AP        |012 |RP-EXP-C3-AP-SUBRC = SY-SUBRC           |
*| |RP-EXP-C3-AP        |013 |IF RP-EXP-C3-AP-SUBRC EQ 0              |
*| |RP-EXP-C3-AP        |014 |  CLEAR ENTRIES                         |
*| |RP-EXP-C3-AP        |015 |  DESCRIBE TABLE EVENT_GENERATOR       *|
*| |RP-EXP-C3-AP        |016 |  LINES ENTRIES                         |
*| |RP-EXP-C3-AP        |017 |  IF NOT ENTRIES IS INITIAL             |
*| |RP-EXP-C3-AP        |018 |  CALL FUNCTION                        *|
*| |RP-EXP-C3-AP        |019 |       'RP_CREATE_EVENT_BY_ACTIVITY'   *|
*| |RP-EXP-C3-AP        |020 |    TABLES DB_CHANGES = EVENT_GENERATOR |
*| |RP-EXP-C3-AP        |021 |  ENDIF                                 |
*| |RP-EXP-C3-AP        |022 |ENDIF                                   |
*| |RP-EXP-C3-TY        |001 |****************************************|
*| |RP-EXP-C3-TY        |002 |* CLUSTER TY: TEXTE BEWERBERDATEN      *|
*| |RP-EXP-C3-TY        |003 |****************************************|
*| |RP-EXP-C3-TY        |004 |EXPORT TEXT-VERSION                    *|
*| |RP-EXP-C3-TY        |005 |       PTEXT                           *|
*| |RP-EXP-C3-TY        |006 |TO DATABASE PCL3(TY)                   *|
*| |RP-EXP-C3-TY        |007 |ID TY-KEY                              *|
*| |RP-EXP-C3-TY        |008 |USING PCL3_EXP_IMP.                     |
*| |RP-EXP-C4-$0        |001 |****************************************|
*| |RP-EXP-C4-$0        |002 |* CLUSTER $0: FILLED PAY STATEMENT     *|
*| |RP-EXP-C4-$0        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-EXP-C4-$0        |004 |*             RPCDTCX0 AND RFFOUS_C   * |
*| |RP-EXP-C4-$0        |005 |****************************************|
*| |RP-EXP-C4-$0        |006 |*XPORT VERSC                           *|
*| |RP-EXP-C4-$0        |007 |EXPORT PINFO                           *|
*| |RP-EXP-C4-$0        |008 |       PFORM                           *|
*| |RP-EXP-C4-$0        |009 |TO   DATABASE PCL4(F1)                 *|
*| |RP-EXP-C4-$0        |010 |ID $0-KEY                              *|
*| |RP-EXP-C4-$0        |011 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-F1        |001 |****************************************|
*| |RP-EXP-C4-F1        |002 |* CLUSTER F1: FILLED PAY STATEMENT     *|
*| |RP-EXP-C4-F1        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-EXP-C4-F1        |004 |*             RPCDTCX0 AND RFFOUS_C    *|
*| |RP-EXP-C4-F1        |005 |****************************************|
*| |RP-EXP-C4-F1        |006 |PCL4-VERSN = '01'.                     *|
*| |RP-EXP-C4-F1        |007 |EXPORT PINFO                           *|
*| |RP-EXP-C4-F1        |008 |       PFORM                           *|
*| |RP-EXP-C4-F1        |009 |TO   DATABASE PCL4(F1)                 *|
*| |RP-EXP-C4-F1        |010 |ID F1-KEY                              *|
*| |RP-EXP-C4-F1        |011 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-F2        |001 |****************************************|
*| |RP-EXP-C4-F2        |002 |* CLUSTER F2: GARNISHMENT SLIPS        *|
*| |RP-EXP-C4-F2        |003 |*       PFORM  AVISE INFORMATION       *|
*| |RP-EXP-C4-F2        |004 |*       PFORM1 CHECK INFORMATION       *|
*| |RP-EXP-C4-F2        |005 |****************************************|
*| |RP-EXP-C4-F2        |006 |PCL4-VERSN = '01'.                     *|
*| |RP-EXP-C4-F2        |007 |EXPORT PFORM PFORM1                    *|
*| |RP-EXP-C4-F2        |008 |       PINFO PINFO1                    *|
*| |RP-EXP-C4-F2        |009 |TO DATABASE PCL4(F2)                   *|
*| |RP-EXP-C4-F2        |010 |ID F2-KEY                              *|
*| |RP-EXP-C4-F2        |011 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-LA        |001 |****************************************|
*| |RP-EXP-C4-LA        |002 |* CLUSTER LA: Langzeit-Belege für PREL *|
*| |RP-EXP-C4-LA        |003 |****************************************|
*| |RP-EXP-C4-LA        |004 |EXPORT VERSION                         *|
*| |RP-EXP-C4-LA        |005 |       HEADER FROM LO_HEADER           *|
*| |RP-EXP-C4-LA        |006 |       BELEGE FROM LO_BELEGE           *|
*| |RP-EXP-C4-LA        |007 |TO DATABASE PCL4(LA)                   *|
*| |RP-EXP-C4-LA        |008 |ID LO-KEY                              *|
*| |RP-EXP-C4-LA        |009 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-LB        |001 |****************************************|
*| |RP-EXP-C4-LB        |002 |* CLUSTER LB: Langzeit-Belege für PAPL *|
*| |RP-EXP-C4-LB        |003 |****************************************|
*| |RP-EXP-C4-LB        |004 |EXPORT VERSION                         *|
*| |RP-EXP-C4-LB        |005 |       HEADER FROM LO_HEADER           *|
*| |RP-EXP-C4-LB        |006 |       BELEGE FROM LO_BELEGE           *|
*| |RP-EXP-C4-LB        |007 |TO DATABASE PCL4(LB)                   *|
*| |RP-EXP-C4-LB        |008 |ID LO-KEY                              *|
*| |RP-EXP-C4-LB        |009 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-PR        |001 |****************************************|
*| |RP-EXP-C4-PR        |002 |* CLUSTER PR: PROTOCOL REPORT-START    *|
*| |RP-EXP-C4-PR        |003 |* DESCRICTION IN INCLUDE RPC4PR00      *|
*| |RP-EXP-C4-PR        |004 |****************************************|
*| |RP-EXP-C4-SA        |001 |****************************************|
*| |RP-EXP-C4-SA        |002 |* CLUSTER SA: Kurzzeit-Belege für PREL *|
*| |RP-EXP-C4-SA        |003 |****************************************|
*| |RP-EXP-C4-SA        |004 |EXPORT VERSION                         *|
*| |RP-EXP-C4-SA        |005 |       HEADER FROM SH_HEADER           *|
*| |RP-EXP-C4-SA        |006 |       BELEGE FROM SH_BELEGE           *|
*| |RP-EXP-C4-SA        |007 |TO DATABASE PCL4(SA)                   *|
*| |RP-EXP-C4-SA        |008 |ID SH-KEY                              *|
*| |RP-EXP-C4-SA        |009 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-C4-SB        |001 |****************************************|
*| |RP-EXP-C4-SB        |002 |* CLUSTER SB: Kurzzeit-Belege für PAPL *|
*| |RP-EXP-C4-SB        |003 |****************************************|
*| |RP-EXP-C4-SB        |004 |EXPORT VERSION                         *|
*| |RP-EXP-C4-SB        |005 |       HEADER FROM SH_HEADER           *|
*| |RP-EXP-C4-SB        |006 |       BELEGE FROM SH_BELEGE           *|
*| |RP-EXP-C4-SB        |007 |TO DATABASE PCL4(SB)                   *|
*| |RP-EXP-C4-SB        |008 |ID SH-KEY                              *|
*| |RP-EXP-C4-SB        |009 |USING PCL4_EXP_IMP                      |
*| |RP-EXP-CM-F0        |001 |****************************************|
*| |RP-EXP-CM-F0        |002 |* CLUSTER F0: FILLED PAY STATEMENT     *|
*| |RP-EXP-CM-F0        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-EXP-CM-F0        |004 |*             EXTERNAL CALL RPCEDTX0   *|
*| |RP-EXP-CM-F0        |005 |****************************************|
*| |RP-EXP-CM-F0        |006 |EXPORT XINFO                           *|
*| |RP-EXP-CM-F0        |007 |       XFORM                           *|
*| |RP-EXP-CM-F0        |008 |TO   MEMORY                            *|
*| |RP-EXP-CM-F0        |009 |ID F0-KEY                               |
*| |RP-EXP-ES-DS        |001 |****************************************|
*| |RP-EXP-ES-DS        |002 |* CLUSTER ES: AUSWERTUNGEN ABRECHN.ERG.*|
*| |RP-EXP-ES-DS        |003 |****************************************|
*| |RP-EXP-ES-DS        |004 |EXPORT ES                              *|
*| |RP-EXP-ES-DS        |005 |TO DATASET FILE(ES)                    *|
*| |RP-EXP-ES-DS        |006 |ID KEY                                  |
*| |RP-EXP-G1           |001 |****************************************|
*| |RP-EXP-G1           |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-EXP-G1           |003 |****************************************|
*| |RP-EXP-G1           |004 |PCL1-AEDTM = SY-DATUM                   |
*| |RP-EXP-G1           |005 |PCL1-UNAME = SY-UNAME                   |
*| |RP-EXP-G1           |006 |PCL1-PGMID = SY-REPID                   |
*| |RP-EXP-G1           |007 |EXPORT G1-VERSION                      *|
*| |RP-EXP-G1           |008 |       GB                              *|
*| |RP-EXP-G1           |009 |       GA                              *|
*| |RP-EXP-G1           |010 |       GE                              *|
*| |RP-EXP-G1           |011 |       GK                              *|
*| |RP-EXP-G1           |012 |       GP                              *|
*| |RP-EXP-G1           |013 |TO   DATABASE PCL1(G1)                 *|
*| |RP-EXP-G1           |014 |ID G1-KEY                               |
*| |RP-EXP-G1-DS        |001 |****************************************|
*| |RP-EXP-G1-DS        |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-EXP-G1-DS        |003 |****************************************|
*| |RP-EXP-G1-DS        |004 |EXPORT G1-VERSION                      *|
*| |RP-EXP-G1-DS        |005 |       GB                              *|
*| |RP-EXP-G1-DS        |006 |       GA                              *|
*| |RP-EXP-G1-DS        |007 |       GE                              *|
*| |RP-EXP-G1-DS        |008 |       GK                              *|
*| |RP-EXP-G1-DS        |009 |       GP                              *|
*| |RP-EXP-G1-DS        |010 |TO   DATASET FILE(G1)                  *|
*| |RP-EXP-G1-DS        |011 |ID KEY                                  |
*| |RP-EXP-L1           |001 |****************************************|
*| |RP-EXP-L1           |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-EXP-L1           |003 |****************************************|
*| |RP-EXP-L1           |004 |PCL1-AEDTM = SY-DATUM                   |
*| |RP-EXP-L1           |005 |PCL1-UNAME = SY-UNAME                   |
*| |RP-EXP-L1           |006 |PCL1-PGMID = SY-REPID                   |
*| |RP-EXP-L1           |007 |EXPORT L1-VERSION                      *|
*| |RP-EXP-L1           |008 |       PB                              *|
*| |RP-EXP-L1           |009 |       LE                              *|
*| |RP-EXP-L1           |010 |       PE                              *|
*| |RP-EXP-L1           |011 |       LK                              *|
*| |RP-EXP-L1           |012 |       GT                              *|
*| |RP-EXP-L1           |013 |TO DATABASE PCL1(L1)                   *|
*| |RP-EXP-L1           |014 |ID L1-KEY                               |
*| |RP-EXP-L1-DS        |001 |****************************************|
*| |RP-EXP-L1-DS        |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-EXP-L1-DS        |003 |****************************************|
*| |RP-EXP-L1-DS        |004 |EXPORT L1-VERSION                      *|
*| |RP-EXP-L1-DS        |005 |       PB                              *|
*| |RP-EXP-L1-DS        |006 |       LE                              *|
*| |RP-EXP-L1-DS        |007 |       PE                              *|
*| |RP-EXP-L1-DS        |008 |       LK                              *|
*| |RP-EXP-L1-DS        |009 |       GT                              *|
*| |RP-EXP-L1-DS        |010 |TO DATASET FILE(L1)                    *|
*| |RP-EXP-L1-DS        |011 |ID KEY                                  |
*| |RP-EXP-L1LE-PP      |001 |****************************************|
*| |RP-EXP-L1LE-PP      |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-EXP-L1LE-PP      |003 |****************************************|
*| |RP-EXP-L1LE-PP      |004 |EXPORT L1-VERSION                      *|
*| |RP-EXP-L1LE-PP      |005 |       LE                              *|
*| |RP-EXP-L1LE-PP      |006 |TO DATABASE PCL1(L1)                   *|
*| |RP-EXP-L1LE-PP      |007 |ID L1-KEY USING PCL1_EXP_IMP            |
*| |RP-EXP-L1LE-PP      |008 |IF SY-SUBRC NE 0                        |
*| |RP-EXP-L1LE-PP      |009 |CLEAR: OL1-VERSION, LE                  |
*| |RP-EXP-L1LE-PP      |010 |REFRESH LE                              |
*| |RP-EXP-L1LE-PP      |011 |SY-SUBRC = 4                            |
*| |RP-EXP-L1LE-PP      |012 |ENDIF                                   |
*| |RP-EXP-PA           |001 |****************************************|
*| |RP-EXP-PA           |002 |* RESERVED FOR CLUSTER PA              *|
*| |RP-EXP-PA           |003 |* PERSONEL CALENDAR (FOR AUSTRIA)      *|
*| |RP-EXP-PA           |004 |****************************************|
*| |RP-EXP-PA           |005 |* SEE ALSO                             *|
*| |RP-EXP-PA           |006 |* RP-EXP-PCA                           *|
*| |RP-EXP-PA           |007 |****************************************|
*| |RP-EXP-PC           |001 |****************************************|
*| |RP-EXP-PC           |002 |* CLUSTER PC: PERSONNEL CALENDAR       *|
*| |RP-EXP-PC           |003 |****************************************|
*| |RP-EXP-PC           |004 |PCL1-UNAME = SY-UNAME                   |
*| |RP-EXP-PC           |005 |PCL1-AEDTM = SY-DATUM                   |
*| |RP-EXP-PC           |006 |PCL1-PGMID = SY-REPID                   |
*| |RP-EXP-PC           |007 |EXPORT PC-VERSION                      *|
*| |RP-EXP-PC           |008 |       PCALE                           *|
*| |RP-EXP-PC           |009 |       NCALE                           *|
*| |RP-EXP-PC           |010 |       PURL                            *|
*| |RP-EXP-PC           |011 |       PC-NATION                       *|
*| |RP-EXP-PC           |012 |TO DATABASE PCL1(PC)                   *|
*| |RP-EXP-PC           |013 |ID PC-KEY                               |
*| |RP-EXP-PK-DS        |001 |****************************************|
*| |RP-EXP-PK-DS        |002 |* CLUSTER PK: PERSOENLICHER KALENDER   *|
*| |RP-EXP-PK-DS        |003 |****************************************|
*| |RP-EXP-PK-DS        |004 |EXPORT PK                              *|
*| |RP-EXP-PK-DS        |010 |TO DATASET FILE(PK)                    *|
*| |RP-EXP-PK-DS        |015 |ID KEY                                  |
*| |RP-EXP-RA-DS        |001 |****************************************|
*| |RP-EXP-RA-DS        |002 |* CLUSTER RG: ABRECHNUNGSERGEBNISSE (A)*|
*| |RP-EXP-RA-DS        |003 |****************************************|
*| |RP-EXP-RA-DS        |004 |EXPORT RG-VERSION                      *|
*| |RP-EXP-RA-DS        |005 |       NAME                            *|
*| |RP-EXP-RA-DS        |006 |       ADR                             *|
*| |RP-EXP-RA-DS        |007 |       AP                              *|
*| |RP-EXP-RA-DS        |008 |       BB                              *|
*| |RP-EXP-RA-DS        |009 |       ABW                             *|
*| |RP-EXP-RA-DS        |010 |       ST                              *|
*| |RP-EXP-RA-DS        |011 |       SV                              *|
*| |RP-EXP-RA-DS        |012 |       ET                              *|
*| |RP-EXP-RA-DS        |013 |       KET                             *|
*| |RP-EXP-RA-DS        |014 |       UW                              *|
*| |RP-EXP-RA-DS        |015 |       K0                              *|
*| |RP-EXP-RA-DS        |016 |       K1                              *|
*| |RP-EXP-RA-DS        |017 |       K2                              *|
*| |RP-EXP-RA-DS        |018 |       URLP                            *|
*| |RP-EXP-RA-DS        |019 |       VT                              *|
*| |RP-EXP-RA-DS        |020 |       BN                              *|
*| |RP-EXP-RA-DS        |021 |       DFT                             *|
*| |RP-EXP-RA-DS        |022 |       KDFT                            *|
*| |RP-EXP-RA-DS        |023 |       BET                             *|
*| |RP-EXP-RA-DS        |024 |       LS                              *|
*| |RP-EXP-RA-DS        |025 |TO DATASET FILE(RG)                    *|
*| |RP-EXP-RA-DS        |026 |ID KEY                                  |
*| |RP-EXP-RC-DS        |001 |****************************************|
*| |RP-EXP-RC-DS        |002 |* CLUSTER RG: ABRECHNUNGSERGEBNISSE (C)*|
*| |RP-EXP-RC-DS        |003 |****************************************|
*| |RP-EXP-RC-DS        |004 |EXPORT RG-VERSION                      *|
*| |RP-EXP-RC-DS        |005 |       NAME                            *|
*| |RP-EXP-RC-DS        |006 |       ADR                             *|
*| |RP-EXP-RC-DS        |007 |       AP                              *|
*| |RP-EXP-RC-DS        |008 |       BB                              *|
*| |RP-EXP-RC-DS        |009 |       ABW                             *|
*| |RP-EXP-RC-DS        |010 |       ST                              *|
*| |RP-EXP-RC-DS        |011 |       SV                              *|
*| |RP-EXP-RC-DS        |012 |       ET                              *|
*| |RP-EXP-RC-DS        |013 |       KET                             *|
*| |RP-EXP-RC-DS        |014 |       UW                              *|
*| |RP-EXP-RC-DS        |015 |       K0                              *|
*| |RP-EXP-RC-DS        |016 |       K1                              *|
*| |RP-EXP-RC-DS        |017 |       K2                              *|
*| |RP-EXP-RC-DS        |018 |       URLP                            *|
*| |RP-EXP-RC-DS        |019 |       VT                              *|
*| |RP-EXP-RC-DS        |020 |       BN                              *|
*| |RP-EXP-RC-DS        |021 |       DFT                             *|
*| |RP-EXP-RC-DS        |022 |       KDFT                            *|
*| |RP-EXP-RC-DS        |023 |       BET                             *|
*| |RP-EXP-RC-DS        |024 |       LS                              *|
*| |RP-EXP-RC-DS        |025 |TO DATASET FILE(RG)                    *|
*| |RP-EXP-RC-DS        |026 |ID KEY                                  |
*| |RP-EXP-RD-DS        |001 |****************************************|
*| |RP-EXP-RD-DS        |002 |* CLUSTER RG: ABRECHNUNGSERG. GERMANY  *|
*| |RP-EXP-RD-DS        |003 |****************************************|
*| |RP-EXP-RD-DS        |004 |EXPORT RG-VERSION                      *|
*| |RP-EXP-RD-DS        |005 |       NAME                            *|
*| |RP-EXP-RD-DS        |006 |       ADR                             *|
*| |RP-EXP-RD-DS        |007 |       AP                              *|
*| |RP-EXP-RD-DS        |008 |       BB                              *|
*| |RP-EXP-RD-DS        |009 |       ABW                             *|
*| |RP-EXP-RD-DS        |010 |       ST                              *|
*| |RP-EXP-RD-DS        |011 |       SV                              *|
*| |RP-EXP-RD-DS        |012 |       ET                              *|
*| |RP-EXP-RD-DS        |013 |       KET                             *|
*| |RP-EXP-RD-DS        |014 |       UW                              *|
*| |RP-EXP-RD-DS        |015 |       DUVOS                           *|
*| |RP-EXP-RD-DS        |016 |       DUVOT                           *|
*| |RP-EXP-RD-DS        |017 |       K0                              *|
*| |RP-EXP-RD-DS        |018 |       K1                              *|
*| |RP-EXP-RD-DS        |019 |       K2                              *|
*| |RP-EXP-RD-DS        |020 |       SKETD                           *|
*| |RP-EXP-RD-DS        |021 |       URLP                            *|
*| |RP-EXP-RD-DS        |022 |       VT                              *|
*| |RP-EXP-RD-DS        |023 |       KUG                             *|
*| |RP-EXP-RD-DS        |024 |       BN                              *|
*| |RP-EXP-RD-DS        |025 |       DFT                             *|
*| |RP-EXP-RD-DS        |026 |       KDFT                            *|
*| |RP-EXP-RD-DS        |027 |       BET                             *|
*| |RP-EXP-RD-DS        |028 |       LS                              *|
*| |RP-EXP-RD-DS        |029 |       STATUS                          *|
*| |RP-EXP-RD-DS        |030 |       XIT                             *|
*| |RP-EXP-RD-DS        |031 |       VBL                             *|
*| |RP-EXP-RD-DS        |032 |TO DATASET FILE(RG)                    *|
*| |RP-EXP-RD-DS        |033 |ID KEY                                  |
*| |RP-EXP-RE-DS        |001 |****************************************|
*| |RP-EXP-RE-DS        |002 |* CLUSTER RG: ABRECHNUNGSERGEBNISSE (E)*|
*| |RP-EXP-RE-DS        |003 |****************************************|
*| |RP-EXP-RE-DS        |004 |EXPORT RG-VERSION                      *|
*| |RP-EXP-RE-DS        |005 |       NAME                            *|
*| |RP-EXP-RE-DS        |006 |       ADR                             *|
*| |RP-EXP-RE-DS        |007 |       AP                              *|
*| |RP-EXP-RE-DS        |008 |       BB                              *|
*| |RP-EXP-RE-DS        |009 |       ABW                             *|
*| |RP-EXP-RE-DS        |010 |       ST                              *|
*| |RP-EXP-RE-DS        |011 |       SV                              *|
*| |RP-EXP-RE-DS        |012 |       ET                              *|
*| |RP-EXP-RE-DS        |013 |       KET                             *|
*| |RP-EXP-RE-DS        |014 |       UW                              *|
*| |RP-EXP-RE-DS        |015 |       K0                              *|
*| |RP-EXP-RE-DS        |016 |       K1                              *|
*| |RP-EXP-RE-DS        |017 |       K2                              *|
*| |RP-EXP-RE-DS        |018 |       URLP                            *|
*| |RP-EXP-RE-DS        |019 |       VT                              *|
*| |RP-EXP-RE-DS        |020 |       BN                              *|
*| |RP-EXP-RE-DS        |021 |       DFT                             *|
*| |RP-EXP-RE-DS        |022 |       KDFT                            *|
*| |RP-EXP-RE-DS        |023 |       BET                             *|
*| |RP-EXP-RE-DS        |024 |*      LS                              *|
*| |RP-EXP-RE-DS        |025 |       STATUS                          *|
*| |RP-EXP-RE-DS        |026 |TO DATASET FILE(RG)                    *|
*| |RP-EXP-RE-DS        |027 |ID KEY                                  |
*| |RP-EXP-ST-MEM       |001 |****************************************|
*| |RP-EXP-ST-MEM       |002 |* CLUSTER ST: STATISTISCHE DATEN       *|
*| |RP-EXP-ST-MEM       |003 |****************************************|
*| |RP-EXP-ST-MEM       |004 |EXPORT STAT                            *|
*| |RP-EXP-ST-MEM       |027 |TO MEMORY                              *|
*| |RP-EXP-ST-MEM       |028 |ID ST-KEY                               |
*| |RP-EXP-TX           |001 |****************************************|
*| |RP-EXP-TX           |002 |* CLUSTER TX: TEXTE                    *|
*| |RP-EXP-TX           |003 |****************************************|
*| |RP-EXP-TX           |004 |PCL1-aedtm = SY-DATUM                   |
*| |RP-EXP-TX           |005 |PCL1-UNAME = SY-UNAME                   |
*| |RP-EXP-TX           |006 |PCL1-PGMID = SY-REPID                   |
*| |RP-EXP-TX           |007 |EXPORT PKEY                            *|
*| |RP-EXP-TX           |008 |       PTEXT                           *|
*| |RP-EXP-TX           |009 |TO DATABASE Pcl1(TX)                   *|
*| |RP-EXP-TX           |010 |ID TX-KEY                               |
*| |RP-FETCH-ALTER-PERID|001 |****************************************|
*| |RP-FETCH-ALTER-PERID|002 |* RP-FETCH-ALTER-PERID                 *|
*| |RP-FETCH-ALTER-PERID|003 |****************************************|
*| |RP-FETCH-ALTER-PERID|004 |* PARAMETER  IN: - $MOL                *|
*| |RP-FETCH-ALTER-PERID|005 |*                  GET PARAMETER ID    *|
*| |RP-FETCH-ALTER-PERID|006 |* PARAMETER OUT: - ALTER-PERID (YES/NO)*|
*| |RP-FETCH-ALTER-PERID|007 |*                  DRUCK ALTERNATE PER *|
*| |RP-FETCH-ALTER-PERID|008 |*                - $RETCODE            *|
*| |RP-FETCH-ALTER-PERID|009 |*                  RETURN-CODE RE549B  *|
*| |RP-FETCH-ALTER-PERID|010 |****************************************|
*| |RP-FETCH-ALTER-PERID|011 |DATA $$SW-ALTER-PERID                   |
*| |RP-FETCH-ALTER-PERID|012 |DATA $$ALTER-PERID-YES VALUE '1'        |
*| |RP-FETCH-ALTER-PERID|013 |DATA $$ALTER-PERID-NO  VALUE '0'        |
*| |RP-FETCH-ALTER-PERID|014 |CALL FUNCTION                          *|
*| |RP-FETCH-ALTER-PERID|015 |     'RP_FETCH_ALTERNATE_PERNR'        *|
*| |RP-FETCH-ALTER-PERID|016 |     IMPORTING                         *|
*| |RP-FETCH-ALTER-PERID|017 |     ALTER_PERNR = $$SW-ALTER-PERID    *|
*| |RP-FETCH-ALTER-PERID|018 |     RETCODE     = $RET-CODE            |
*| |RP-GET-PSREF        |001 |****************************************|
*| |RP-GET-PSREF        |002 |* RP-GET-PSREF                         *|
*| |RP-GET-PSREF        |003 |****************************************|
*| |RP-GET-PSREF        |004 |* PARAMETERS:                          *|
*| |RP-GET-PSREF        |005 |*   PERNR      REQUESTED PERSONALNUMBER*|
*| |RP-GET-PSREF        |006 |*   INFTY      REQUESTED INFOTYPNUMBER *|
*| |RP-GET-PSREF        |007 |*   SUBTY      REQUESTED SUBTYPNUMBER  *|
*| |RP-GET-PSREF        |008 |*   OBJPS      REQUESTED OBJECTID      *|
*| |RP-GET-PSREF        |009 |*   SPRPS      REQUESTED LOCK          *|
*| |RP-GET-PSREF        |010 |*   ENDDA      REQUESTED INTERVAL END  *|
*| |RP-GET-PSREF        |011 |*   BEGDA      REQUESTED INTERVAL BEGIN*|
*| |RP-GET-PSREF        |012 |*   SEQNR      REQUESTED SEQ. NR       *|
*| |RP-GET-PSREF        |013 |*   REFEX      REFERENCE ID            *|
*| |RP-GET-PSREF        |014 |****************************************|
*| |RP-GET-PSREF        |015 |CLEAR PSREF                             |
*| |RP-GET-PSREF        |016 |IF &9 NE 'X'                            |
*| |RP-GET-PSREF        |017 |  SY-SUBRC = 2                          |
*| |RP-GET-PSREF        |018 |ELSE                                    |
*| |RP-GET-PSREF        |019 |  SELECT * FROM ASSOB_HR WHERE         *|
*| |RP-GET-PSREF        |020 |    PERNR = &1 AND                     *|
*| |RP-GET-PSREF        |021 |    INFTY = &2 AND                     *|
*| |RP-GET-PSREF        |022 |    SUBTY = &3 AND                     *|
*| |RP-GET-PSREF        |023 |    OBJPS = &4 AND                     *|
*| |RP-GET-PSREF        |024 |    SPRPS = &5 AND                     *|
*| |RP-GET-PSREF        |025 |    ENDDA = &6 AND                     *|
*| |RP-GET-PSREF        |026 |    BEGDA = &7 AND                     *|
*| |RP-GET-PSREF        |027 |    SEQNR = &8                          |
*| |RP-GET-PSREF        |028 |   MOVE-CORRESPONDING ASSOB_HR TO PSREF |
*| |RP-GET-PSREF        |029 |   CLEAR PSREF-POHRS                    |
*| |RP-GET-PSREF        |030 |endselect                               |
*| |RP-GET-PSREF        |031 |ENDIF                                   |
*| |RP-IMP-AP           |001 |****************************************|
*| |RP-IMP-AP           |002 |* CLUSTER AP: Action-log Schedule      *|
*| |RP-IMP-AP           |003 |****************************************|
*| |RP-IMP-AP           |004 |IMPORT ACT_LOG                         *|
*| |RP-IMP-AP           |005 |****************************************|
*| |RP-IMP-AP           |006 |       SCHEDULE                        *|
*| |RP-IMP-AP           |007 |FROM DATABASE PCL1(AP)                 *|
*| |RP-IMP-AP           |008 |ID AP-KEY.                              |
*| |RP-IMP-AP           |009 |DESCRIBE TABLE ACT_LOG LINES ACT_COUNT. |
*| |RP-IMP-AP           |010 |DESCRIBE TABLE SCHEDULE LINES SCH_COUNT.|
*| |RP-IMP-B0-DS        |001 |****************************************|
*| |RP-IMP-B0-DS        |002 |* CLUSTER B0: BDE-DATEN (MONAT)        *|
*| |RP-IMP-B0-DS        |003 |****************************************|
*| |RP-IMP-B0-DS        |004 |IMPORT B0-VERSION TO OB0-VERSION       *|
*| |RP-IMP-B0-DS        |005 |       ZL                              *|
*| |RP-IMP-B0-DS        |006 |       KNTAG                           *|
*| |RP-IMP-B0-DS        |007 |       MT                              *|
*| |RP-IMP-B0-DS        |008 |       PT                              *|
*| |RP-IMP-B0-DS        |009 |       AT                              *|
*| |RP-IMP-B0-DS        |010 |       WST                             *|
*| |RP-IMP-B0-DS        |011 |       SALDO                           *|
*| |RP-IMP-B0-DS        |012 |       ZES                             *|
*| |RP-IMP-B0-DS        |013 |       ZKO                             *|
*| |RP-IMP-B0-DS        |014 |       ANWKONTI                        *|
*| |RP-IMP-B0-DS        |015 |       ABWKONTI                        *|
*| |RP-IMP-B0-DS        |016 |       FEHLER                          *|
*| |RP-IMP-B0-DS        |017 |       FT                              *|
*| |RP-IMP-B0-DS        |018 |       PSP                             *|
*| |RP-IMP-B0-DS        |019 |       NAME                            *|
*| |RP-IMP-B0-DS        |020 |       ADR                             *|
*| |RP-IMP-B0-DS        |021 |       AP                              *|
*| |RP-IMP-B0-DS        |022 |       ABWES                           *|
*| |RP-IMP-B0-DS        |023 |       VERT                            *|
*| |RP-IMP-B0-DS        |024 |       BEZUG                           *|
*| |RP-IMP-B0-DS        |025 |       SKO                             *|
*| |RP-IMP-B0-DS        |026 |       MEHR                            *|
*| |RP-IMP-B0-DS        |027 |       ANWES                           *|
*| |RP-IMP-B0-DS        |028 |       RUFB                            *|
*| |RP-IMP-B0-DS        |029 |FROM DATASET FILE(B0)                  *|
*| |RP-IMP-B0-DS        |030 |ID KEY                                  |
*| |RP-IMP-B0-DS        |031 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-B0-DS        |032 |  CLEAR:   OB0-VERSION                  |
*| |RP-IMP-B0-DS        |033 |  CLEAR:   BEZUG                        |
*| |RP-IMP-B0-DS        |034 |  CLEAR:   KNTAG                        |
*| |RP-IMP-B0-DS        |035 |  CLEAR:   NAME                         |
*| |RP-IMP-B0-DS        |036 |  CLEAR:   ADR                          |
*| |RP-IMP-B0-DS        |037 |  REFRESH : ZL                          |
*| |RP-IMP-B0-DS        |038 |  REFRESH : MT                          |
*| |RP-IMP-B0-DS        |039 |  REFRESH : PT                          |
*| |RP-IMP-B0-DS        |040 |  REFRESH : AT                          |
*| |RP-IMP-B0-DS        |041 |  REFRESH : WST                         |
*| |RP-IMP-B0-DS        |042 |  REFRESH : SALDO                       |
*| |RP-IMP-B0-DS        |043 |  REFRESH : ZES                         |
*| |RP-IMP-B0-DS        |044 |  REFRESH : ZKO                         |
*| |RP-IMP-B0-DS        |045 |  REFRESH : ANWKONTI                    |
*| |RP-IMP-B0-DS        |046 |  REFRESH : ABWKONTI                    |
*| |RP-IMP-B0-DS        |047 |  REFRESH : FEHLER                      |
*| |RP-IMP-B0-DS        |048 |  REFRESH : FT                          |
*| |RP-IMP-B0-DS        |049 |  REFRESH : PSP                         |
*| |RP-IMP-B0-DS        |050 |  REFRESH : AP                          |
*| |RP-IMP-B0-DS        |051 |  REFRESH : ABWES                       |
*| |RP-IMP-B0-DS        |052 |  REFRESH : VERT                        |
*| |RP-IMP-B0-DS        |053 |  REFRESH:  SKO                         |
*| |RP-IMP-B0-DS        |054 |  REFRESH:  MEHR                        |
*| |RP-IMP-B0-DS        |055 |  REFRESH:  ANWES                       |
*| |RP-IMP-B0-DS        |056 |  REFRESH:  RUFB                        |
*| |RP-IMP-B0-DS        |057 |  SY-SUBRC = 4                          |
*| |RP-IMP-B0-DS        |058 |ENDIF                                   |
*| |RP-IMP-C1-G1        |001 |****************************************|
*| |RP-IMP-C1-G1        |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-IMP-C1-G1        |003 |****************************************|
*| |RP-IMP-C1-G1        |004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-C1-G1        |005 |       GB                              *|
*| |RP-IMP-C1-G1        |006 |       GA                              *|
*| |RP-IMP-C1-G1        |007 |       GE                              *|
*| |RP-IMP-C1-G1        |008 |       GK                              *|
*| |RP-IMP-C1-G1        |009 |       GP                              *|
*| |RP-IMP-C1-G1        |010 |       GPA                             *|
*| |RP-IMP-C1-G1        |011 |FROM DATABASE PCL1(G1)                 *|
*| |RP-IMP-C1-G1        |012 |ID G1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-C1-G1        |013 |RP-IMP-G1-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-G1        |014 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-G1        |015 |CLEAR: OG1-VERSION, GB, GA, GP, GE, GK  |
*| |RP-IMP-C1-G1        |016 |CLEAR: GPA                              |
*| |RP-IMP-C1-G1        |017 |REFRESH: GA, GP, GE, GK, GPA            |
*| |RP-IMP-C1-G1        |018 |SY-SUBRC = RP-IMP-G1-SUBRC              |
*| |RP-IMP-C1-G1        |019 |ENDIF                                   |
*| |RP-IMP-C1-G1-PR     |001 |****************************************|
*| |RP-IMP-C1-G1-PR     |002 |* CLUSTER G1: GRUPPENLEISTUNGSLOHN     *|
*| |RP-IMP-C1-G1-PR     |003 |****************************************|
*| |RP-IMP-C1-G1-PR     |004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-C1-G1-PR     |005 |       GB                              *|
*| |RP-IMP-C1-G1-PR     |006 |       GE                              *|
*| |RP-IMP-C1-G1-PR     |007 |       GK                              *|
*| |RP-IMP-C1-G1-PR     |008 |FROM DATABASE PCL1(G1)                 *|
*| |RP-IMP-C1-G1-PR     |009 |ID G1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-C1-G1-PR     |010 |RP-IMP-G1-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-G1-PR     |011 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-G1-PR     |012 |  CLEAR: OG1-VERSION, GB, GE, GK        |
*| |RP-IMP-C1-G1-PR     |013 |  REFRESH: GE, GK                       |
*| |RP-IMP-C1-G1-PR     |014 |ENDIF                                   |
*| |RP-IMP-C1-G1-PR     |015 |SY-SUBRC = RP-IMP-G1-SUBRC              |
*| |RP-IMP-C1-G1-PR-CONV|001 |****************************************|
*| |RP-IMP-C1-G1-PR-CONV|002 |* CLUSTER G1: GRUPPENLEISTUNGSLOHN     *|
*| |RP-IMP-C1-G1-PR-CONV|003 |****************************************|
*| |RP-IMP-C1-G1-PR-CONV|004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-C1-G1-PR-CONV|005 |       GB                              *|
*| |RP-IMP-C1-G1-PR-CONV|006 |       GE                              *|
*| |RP-IMP-C1-G1-PR-CONV|007 |       GK TO GKH                       *|
*| |RP-IMP-C1-G1-PR-CONV|008 |FROM DATABASE PCL1(G1)                 *|
*| |RP-IMP-C1-G1-PR-CONV|009 |ID G1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-C1-G1-PR-CONV|010 |RP-IMP-G1-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-G1-PR-CONV|011 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-G1-PR-CONV|012 |  CLEAR: OG1-VERSION, GB, GE, GKH       |
*| |RP-IMP-C1-G1-PR-CONV|013 |  REFRESH: GE, GKH                      |
*| |RP-IMP-C1-G1-PR-CONV|014 |  SY-SUBRC = RP-IMP-G1-SUBRC            |
*| |RP-IMP-C1-G1-PR-CONV|015 |ENDIF                                   |
*| |RP-IMP-C1-G3        |001 |****************************************|
*| |RP-IMP-C1-G3        |002 |* CLUSTER G3: BDE-DATEN FUER GRUPPEN   *|
*| |RP-IMP-C1-G3        |003 |****************************************|
*| |RP-IMP-C1-G3        |004 |IMPORT G3-VERSION TO OG3-VERSION       *|
*| |RP-IMP-C1-G3        |005 |       GMT                             *|
*| |RP-IMP-C1-G3        |006 |       GNT1                            *|
*| |RP-IMP-C1-G3        |007 |       GNT2                            *|
*| |RP-IMP-C1-G3        |008 |       GDT                             *|
*| |RP-IMP-C1-G3        |009 |       GGMT                            *|
*| |RP-IMP-C1-G3        |010 |       GSTT                            *|
*| |RP-IMP-C1-G3        |011 |       SGMT                            *|
*| |RP-IMP-C1-G3        |012 |       PNT                             *|
*| |RP-IMP-C1-G3        |013 |       GERT                            *|
*| |RP-IMP-C1-G3        |014 |       GNCT                            *|
*| |RP-IMP-C1-G3        |015 |       GQT                             *|
*| |RP-IMP-C1-G3        |016 |FROM DATABASE PCL1(G3)                 *|
*| |RP-IMP-C1-G3        |017 |ID G3-KEY  USING PCL1_EXP_IMP           |
*| |RP-IMP-C1-G3        |018 |RP-IMP-G3-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-G3        |019 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-G3        |020 |  CLEAR   OG3-VERSION                   |
*| |RP-IMP-C1-G3        |021 |  CLEAR   GMT                           |
*| |RP-IMP-C1-G3        |022 |  CLEAR   GNT1                          |
*| |RP-IMP-C1-G3        |023 |  CLEAR   GNT2                          |
*| |RP-IMP-C1-G3        |024 |  CLEAR   GDT                           |
*| |RP-IMP-C1-G3        |025 |  CLEAR   GGMT                          |
*| |RP-IMP-C1-G3        |026 |  CLEAR   GSTT                          |
*| |RP-IMP-C1-G3        |027 |  CLEAR   SGMT                          |
*| |RP-IMP-C1-G3        |028 |  CLEAR   PNT                           |
*| |RP-IMP-C1-G3        |029 |  CLEAR   GERT                          |
*| |RP-IMP-C1-G3        |030 |  CLEAR   GNCT                          |
*| |RP-IMP-C1-G3        |031 |  CLEAR   GQT                           |
*| |RP-IMP-C1-G3        |032 |  REFRESH GMT                           |
*| |RP-IMP-C1-G3        |033 |  REFRESH GNT1                          |
*| |RP-IMP-C1-G3        |034 |  REFRESH GNT2                          |
*| |RP-IMP-C1-G3        |035 |  REFRESH GDT                           |
*| |RP-IMP-C1-G3        |036 |  REFRESH GGMT                          |
*| |RP-IMP-C1-G3        |037 |  REFRESH GSTT                          |
*| |RP-IMP-C1-G3        |038 |  REFRESH SGMT                          |
*| |RP-IMP-C1-G3        |039 |  REFRESH PNT                           |
*| |RP-IMP-C1-G3        |040 |  REFRESH GERT                          |
*| |RP-IMP-C1-G3        |041 |  REFRESH GNCT                          |
*| |RP-IMP-C1-G3        |042 |  SY-SUBRC = RP-IMP-G3-SUBRC            |
*| |RP-IMP-C1-G3        |043 |ENDIF                                   |
*| |RP-IMP-C1-G3-CONV   |001 |****************************************|
*| |RP-IMP-C1-G3-CONV   |002 |* CLUSTER G3: BDE-DATEN FUER GRUPPEN   *|
*| |RP-IMP-C1-G3-CONV   |003 |****************************************|
*| |RP-IMP-C1-G3-CONV   |004 |IMPORT G3-VERSION TO OG3-VERSION       *|
*| |RP-IMP-C1-G3-CONV   |005 |       GMTG3  TO GMT                   *|
*| |RP-IMP-C1-G3-CONV   |006 |       GNT1                            *|
*| |RP-IMP-C1-G3-CONV   |007 |       GNT2                            *|
*| |RP-IMP-C1-G3-CONV   |008 |       GDTG3  TO GDT                   *|
*| |RP-IMP-C1-G3-CONV   |009 |       GGMTG3 TO GGMT                  *|
*| |RP-IMP-C1-G3-CONV   |010 |       GSTTG3 TO GSTT                  *|
*| |RP-IMP-C1-G3-CONV   |011 |       SGMTG3 TO SGMT                  *|
*| |RP-IMP-C1-G3-CONV   |012 |       PNTG3  TO PNT                   *|
*| |RP-IMP-C1-G3-CONV   |013 |       GERT                            *|
*| |RP-IMP-C1-G3-CONV   |014 |       GNCT                            *|
*| |RP-IMP-C1-G3-CONV   |015 |       GQT                             *|
*| |RP-IMP-C1-G3-CONV   |016 |FROM DATABASE PCL1(G3)                 *|
*| |RP-IMP-C1-G3-CONV   |017 |ID G3-KEY  USING PCL1_EXP_IMP           |
*| |RP-IMP-C1-G3-CONV   |018 |RP-IMP-G3-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-G3-CONV   |019 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-G3-CONV   |020 |  CLEAR   OG3-VERSION                   |
*| |RP-IMP-C1-G3-CONV   |021 |  CLEAR   GMT                           |
*| |RP-IMP-C1-G3-CONV   |022 |  CLEAR   GNT1                          |
*| |RP-IMP-C1-G3-CONV   |023 |  CLEAR   GNT2                          |
*| |RP-IMP-C1-G3-CONV   |024 |  CLEAR   GDT                           |
*| |RP-IMP-C1-G3-CONV   |025 |  CLEAR   GGMT                          |
*| |RP-IMP-C1-G3-CONV   |026 |  CLEAR   GSTT                          |
*| |RP-IMP-C1-G3-CONV   |027 |  CLEAR   SGMT                          |
*| |RP-IMP-C1-G3-CONV   |028 |  CLEAR   PNT                           |
*| |RP-IMP-C1-G3-CONV   |029 |  CLEAR   GERT                          |
*| |RP-IMP-C1-G3-CONV   |030 |  CLEAR   GNCT                          |
*| |RP-IMP-C1-G3-CONV   |031 |  CLEAR   GQT                           |
*| |RP-IMP-C1-G3-CONV   |032 |  REFRESH GMT                           |
*| |RP-IMP-C1-G3-CONV   |033 |  REFRESH GNT1                          |
*| |RP-IMP-C1-G3-CONV   |034 |  REFRESH GNT2                          |
*| |RP-IMP-C1-G3-CONV   |035 |  REFRESH GDT                           |
*| |RP-IMP-C1-G3-CONV   |036 |  REFRESH GGMT                          |
*| |RP-IMP-C1-G3-CONV   |037 |  REFRESH GSTT                          |
*| |RP-IMP-C1-G3-CONV   |038 |  REFRESH SGMT                          |
*| |RP-IMP-C1-G3-CONV   |039 |  REFRESH PNT                           |
*| |RP-IMP-C1-G3-CONV   |040 |  REFRESH GERT                          |
*| |RP-IMP-C1-G3-CONV   |041 |  REFRESH GNCT                          |
*| |RP-IMP-C1-G3-CONV   |042 |SY-SUBRC = RP-IMP-G3-SUBRC              |
*| |RP-IMP-C1-G3-CONV   |043 |ENDIF                                   |
*| |RP-IMP-C1-L1        |001 |****************************************|
*| |RP-IMP-C1-L1        |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-C1-L1        |003 |****************************************|
*| |RP-IMP-C1-L1        |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-C1-L1        |005 |       PB                              *|
*| |RP-IMP-C1-L1        |006 |       LE                              *|
*| |RP-IMP-C1-L1        |007 |       PE                              *|
*| |RP-IMP-C1-L1        |008 |       LK                              *|
*| |RP-IMP-C1-L1        |009 |       GT                              *|
*| |RP-IMP-C1-L1        |010 |       LPA                             *|
*| |RP-IMP-C1-L1        |011 |FROM DATABASE PCL1(L1)                 *|
*| |RP-IMP-C1-L1        |012 |ID L1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-C1-L1        |013 |RP-IMP-L1-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-L1        |014 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-L1        |015 |CLEAR: LE, PB, PE, LK, GT, LPA          |
*| |RP-IMP-C1-L1        |016 |CLEAR: OL1-VERSION                      |
*| |RP-IMP-C1-L1        |017 |REFRESH: LE, PE, LK, GT, LPA            |
*| |RP-IMP-C1-L1        |018 |SY-SUBRC = RP-IMP-L1-SUBRC              |
*| |RP-IMP-C1-L1        |019 |ENDIF                                   |
*| |RP-IMP-C1-L1-CONV   |001 |****************************************|
*| |RP-IMP-C1-L1-CONV   |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-C1-L1-CONV   |003 |****************************************|
*| |RP-IMP-C1-L1-CONV   |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-C1-L1-CONV   |005 |       PB                              *|
*| |RP-IMP-C1-L1-CONV   |006 |       LE TO LEH                       *|
*| |RP-IMP-C1-L1-CONV   |007 |       PE                              *|
*| |RP-IMP-C1-L1-CONV   |008 |       LK TO LKH                       *|
*| |RP-IMP-C1-L1-CONV   |009 |       GT TO GTH                       *|
*| |RP-IMP-C1-L1-CONV   |010 |       LPA                             *|
*| |RP-IMP-C1-L1-CONV   |011 |FROM DATABASE PCL1(L1)                 *|
*| |RP-IMP-C1-L1-CONV   |012 |ID L1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-C1-L1-CONV   |013 |RP-IMP-L1-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-L1-CONV   |014 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-L1-CONV   |015 |CLEAR: PB, PE, LPA, OL1-VERSION         |
*| |RP-IMP-C1-L1-CONV   |016 |CLEAR: LEH, LKH, GTH                    |
*| |RP-IMP-C1-L1-CONV   |017 |REFRESH: LEH, PE, LKH, GTH, LPA         |
*| |RP-IMP-C1-L1-CONV   |018 |SY-SUBRC = RP-IMP-L1-SUBRC              |
*| |RP-IMP-C1-L1-CONV   |019 |ENDIF                                   |
*| |RP-IMP-C1-LL        |001 |****************************************|
*| |RP-IMP-C1-LL        |002 |* CLUSTER LL: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-C1-LL        |003 |* DIESES CLUSTER WIRD NICHT AUF DIE    *|
*| |RP-IMP-C1-LL        |004 |* DATENBANK GESCHRIEBEN, SONDERN DIENT *|
*| |RP-IMP-C1-LL        |005 |* ALS SCHNITTSTELLE ZUM VERBUCHER      *|
*| |RP-IMP-C1-LL        |006 |****************************************|
*| |RP-IMP-C1-LL        |007 |IMPORT IPTAB                           *|
*| |RP-IMP-C1-LL        |008 |       LE2 GT2 PB2 PE2 LK2             *|
*| |RP-IMP-C1-LL        |009 |FROM DATABASE PCL1(LL)                 *|
*| |RP-IMP-C1-LL        |010 |ID SPACE USING PCL1_EXP_IMP             |
*| |RP-IMP-C1-LL        |011 |RP-IMP-LL-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-LL        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-LL        |013 |CLEAR:   IPTAB, LE2, PB2, PE2, LK2, GT2 |
*| |RP-IMP-C1-LL        |014 |REFRESH: IPTAB, LE2, PB2, PE2, LK2, GT2 |
*| |RP-IMP-C1-LL        |015 |SY-SUBRC = RP-IMP-LL-SUBRC              |
*| |RP-IMP-C1-LL        |016 |ENDIF                                   |
*| |RP-IMP-C1-LL-CONV   |001 |****************************************|
*| |RP-IMP-C1-LL-CONV   |002 |* CLUSTER LL: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-C1-LL-CONV   |003 |* DIESES CLUSTER WIRD NICHT AUF DIE    *|
*| |RP-IMP-C1-LL-CONV   |004 |* DATENBANK GESCHRIEBEN, SONDERN DIENT *|
*| |RP-IMP-C1-LL-CONV   |005 |* ALS SCHNITTSTELLE ZUM VERBUCHER      *|
*| |RP-IMP-C1-LL-CONV   |006 |****************************************|
*| |RP-IMP-C1-LL-CONV   |007 |IMPORT IPTAB TO IPTAB3                 *|
*| |RP-IMP-C1-LL-CONV   |008 |       LE2   TO LE3                    *|
*| |RP-IMP-C1-LL-CONV   |009 |       GT2   TO GT3                    *|
*| |RP-IMP-C1-LL-CONV   |010 |       PB2   TO PB3                    *|
*| |RP-IMP-C1-LL-CONV   |011 |       PE2   TO PE3                    *|
*| |RP-IMP-C1-LL-CONV   |012 |       LK2   TO LK3                    *|
*| |RP-IMP-C1-LL-CONV   |013 |FROM DATABASE PCL1(LL)                 *|
*| |RP-IMP-C1-LL-CONV   |014 |ID SPACE USING PCL1_EXP_IMP             |
*| |RP-IMP-C1-LL-CONV   |015 |RP-IMP-LL-SUBRC = SY-SUBRC              |
*| |RP-IMP-C1-LL-CONV   |016 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-LL-CONV   |017 |CLEAR: IPTAB3,                         *|
*| |RP-IMP-C1-LL-CONV   |018 |       LE3, PB3, PE3, LK3, GT3          |
*| |RP-IMP-C1-LL-CONV   |019 |REFRESH: IPTAB3,                       *|
*| |RP-IMP-C1-LL-CONV   |020 |       LE3, PB3, PE3, LK3, GT3          |
*| |RP-IMP-C1-LL-CONV   |021 |SY-SUBRC = RP-IMP-LL-SUBRC              |
*| |RP-IMP-C1-LL-CONV   |022 |ENDIF                                   |
*| |RP-IMP-C1-PC        |001 |****************************************|
*| |RP-IMP-C1-PC        |002 |* CLUSTER PC: PERSONNEL CALENDAR       *|
*| |RP-IMP-C1-PC        |003 |****************************************|
*| |RP-IMP-C1-PC        |004 |IMPORT PC-VERSION TO OPC-VERSION       *|
*| |RP-IMP-C1-PC        |005 |       PCALE                           *|
*| |RP-IMP-C1-PC        |006 |       NCALE                           *|
*| |RP-IMP-C1-PC        |007 |       PURL                            *|
*| |RP-IMP-C1-PC        |008 |       PC-NATION                       *|
*| |RP-IMP-C1-PC        |009 |FROM DATABASE PCL1(PC)                 *|
*| |RP-IMP-C1-PC        |010 |ID PC-KEY                              *|
*| |RP-IMP-C1-PC        |011 |USING PCL1_EXP_IMP                      |
*| |RP-IMP-C1-PC        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-PC        |013 |   CLEAR: OPC-VERSION                   |
*| |RP-IMP-C1-PC        |014 |   CLEAR: PCALE                         |
*| |RP-IMP-C1-PC        |015 |   CLEAR: NCALE                         |
*| |RP-IMP-C1-PC        |016 |   CLEAR: PURL                          |
*| |RP-IMP-C1-PC        |017 |   CLEAR: PC-NATION                     |
*| |RP-IMP-C1-PC        |018 |   REFRESH: PCALE                       |
*| |RP-IMP-C1-PC        |019 |   REFRESH: NCALE                       |
*| |RP-IMP-C1-PC        |020 |   REFRESH: PURL                        |
*| |RP-IMP-C1-PC        |021 |   SY-SUBRC = 4                         |
*| |RP-IMP-C1-PC        |022 |ENDIF                                   |
*| |RP-IMP-C1-PC-MAJOR  |001 |****************************************|
*| |RP-IMP-C1-PC-MAJOR  |002 |* CLUSTER PC: PERSONNEL CALENDAR       *|
*| |RP-IMP-C1-PC-MAJOR  |003 |****************************************|
*| |RP-IMP-C1-PC-MAJOR  |004 |IMPORT PC-VERSION TO OPC-VERSION       *|
*| |RP-IMP-C1-PC-MAJOR  |005 |       PCALE                           *|
*| |RP-IMP-C1-PC-MAJOR  |006 |       NCALE                           *|
*| |RP-IMP-C1-PC-MAJOR  |007 |       PC-NATION                       *|
*| |RP-IMP-C1-PC-MAJOR  |008 |       PURL                            *|
*| |RP-IMP-C1-PC-MAJOR  |009 |FROM DATABASE PCL1(PC)                 *|
*| |RP-IMP-C1-PC-MAJOR  |010 |MAJOR-ID PC-KEY-PERNR                  *|
*| |RP-IMP-C1-PC-MAJOR  |011 |MINOR-ID PC-KEY-KJAHR                   |
*| |RP-IMP-C1-PC-MAJOR  |012 |IF SY-SUBRC EQ 0                        |
*| |RP-IMP-C1-PC-MAJOR  |013 |  MOVE PCL1-SRTFD+8(4) TO PC-KEY-KJAHR  |
*| |RP-IMP-C1-PC-MAJOR  |014 |ELSE                                    |
*| |RP-IMP-C1-PC-MAJOR  |015 |  CLEAR: OPC-VERSION                    |
*| |RP-IMP-C1-PC-MAJOR  |016 |  CLEAR: PURL                           |
*| |RP-IMP-C1-PC-MAJOR  |017 |  CLEAR: PCALE                          |
*| |RP-IMP-C1-PC-MAJOR  |018 |  CLEAR: NCALE                          |
*| |RP-IMP-C1-PC-MAJOR  |019 |  CLEAR: PC-NATION                      |
*| |RP-IMP-C1-PC-MAJOR  |020 |  REFRESH: PCALE                        |
*| |RP-IMP-C1-PC-MAJOR  |021 |  REFRESH: NCALE                        |
*| |RP-IMP-C1-PC-MAJOR  |022 |  REFRESH: PURL                         |
*| |RP-IMP-C1-PC-MAJOR  |023 |  SY-SUBRC = 4                          |
*| |RP-IMP-C1-PC-MAJOR  |024 |ENDIF                                   |
*| |RP-IMP-C1-PC-O      |001 |****************************************|
*| |RP-IMP-C1-PC-O      |002 |* CLUSTER PC: PERSONNEL CALENDAR - old *|
*| |RP-IMP-C1-PC-O      |003 |****************************************|
*| |RP-IMP-C1-PC-O      |004 |IMPORT PC-VERSION TO OPC-VERSION       *|
*| |RP-IMP-C1-PC-O      |005 |       PCALE      TO OPCALE            *|
*| |RP-IMP-C1-PC-O      |006 |       NCALE      TO ONCALE            *|
*| |RP-IMP-C1-PC-O      |007 |       PURL       TO OPURL             *|
*| |RP-IMP-C1-PC-O      |008 |       PC-NATION  TO OPC-NATION        *|
*| |RP-IMP-C1-PC-O      |009 |FROM DATABASE PCL1(PC)                 *|
*| |RP-IMP-C1-PC-O      |010 |ID OPC-KEY                             *|
*| |RP-IMP-C1-PC-O      |011 |USING PCL1_EXP_IMP                      |
*| |RP-IMP-C1-PC-O      |012 |IF SY-SUBRC <> 0                        |
*| |RP-IMP-C1-PC-O      |013 |  CLEAR: OPC-VERSION,                  *|
*| |RP-IMP-C1-PC-O      |014 |         OPCALE,                       *|
*| |RP-IMP-C1-PC-O      |015 |         ONCALE,                       *|
*| |RP-IMP-C1-PC-O      |016 |         OPURL,                        *|
*| |RP-IMP-C1-PC-O      |017 |         OPC-NATION                     |
*| |RP-IMP-C1-PC-O      |018 |  REFRESH: OPCALE,                     *|
*| |RP-IMP-C1-PC-O      |019 |           ONCALE,                     *|
*| |RP-IMP-C1-PC-O      |020 |           OPURL                        |
*| |RP-IMP-C1-PC-O      |021 |   SY-SUBRC = 4                         |
*| |RP-IMP-C1-PC-O      |022 |ENDIF                                   |
*| |RP-IMP-C1-PC-PREV   |001 |****************************************|
*| |RP-IMP-C1-PC-PREV   |002 |* CLUSTER PC:GB Absnce cal.for prev.yr *|
*| |RP-IMP-C1-PC-PREV   |003 |****************************************|
*| |RP-IMP-C1-PC-PREV   |004 |IMPORT PC-VERSION TO OPC-VERSION       *|
*| |RP-IMP-C1-PC-PREV   |006 |       NCALE      TO ONCALE            *|
*| |RP-IMP-C1-PC-PREV   |009 |FROM DATABASE PCL1(PC)                 *|
*| |RP-IMP-C1-PC-PREV   |010 |ID OPC-KEY                             *|
*| |RP-IMP-C1-PC-PREV   |011 |USING PCL1_EXP_IMP                      |
*| |RP-IMP-C1-PC-PREV   |012 |IF SY-SUBRC <> 0                        |
*| |RP-IMP-C1-PC-PREV   |013 |  CLEAR: OPC-VERSION,                  *|
*| |RP-IMP-C1-PC-PREV   |015 |         ONCALE                         |
*| |RP-IMP-C1-PC-PREV   |018 |  REFRESH: ONCALE                       |
*| |RP-IMP-C1-PC-PREV   |021 |   SY-SUBRC = 4                         |
*| |RP-IMP-C1-PC-PREV   |022 |ENDIF                                   |
*| |RP-IMP-C1-TX        |001 |****************************************|
*| |RP-IMP-C1-TX        |002 |* CLUSTER TX: TEXTE FUER PREL          *|
*| |RP-IMP-C1-TX        |003 |PERFORM DO_NOTHING(SAPFP50P)            |
*| |RP-IMP-C1-TX        |004 |IMPORT TEXT-VERSION                    *|
*| |RP-IMP-C1-TX        |005 |       PTEXT                           *|
*| |RP-IMP-C1-TX        |006 |FROM DATABASE PCL1(TX)                 *|
*| |RP-IMP-C1-TX        |007 |ID TX-KEY                              *|
*| |RP-IMP-C1-TX        |008 |USING PCL1_EXP_IMP(SAPFP50P)            |
*| |RP-IMP-C1-TX        |009 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-TX        |010 |   CLEAR:   TEXT-VERSION                |
*| |RP-IMP-C1-TX        |011 |   CLEAR:   PTEXT                       |
*| |RP-IMP-C1-TX        |012 |   REFRESH: PTEXT                       |
*| |RP-IMP-C1-TX        |013 |   SY-SUBRC = 4                         |
*| |RP-IMP-C1-TX        |014 |ENDIF                                   |
*| |RP-IMP-C1-U1        |001 |****************************************|
*| |RP-IMP-C1-U1        |002 |* CLUSTER U1: North America            *|
*| |RP-IMP-C1-U1        |003 |* Reserve and dependent care accounts  *|
*| |RP-IMP-C1-U1        |004 |****************************************|
*| |RP-IMP-C1-U1        |005 |IMPORT U1-VERSION TO OU1-VERSION       *|
*| |RP-IMP-C1-U1        |006 |       AT                              *|
*| |RP-IMP-C1-U1        |007 |FROM DATABASE PCL1(U1)                 *|
*| |RP-IMP-C1-U1        |008 |ID U1-KEY  USING PCL1_EXP_IMP           |
*| |RP-IMP-C1-U1        |009 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C1-U1        |010 |  CLEAR   OU1-VERSION                   |
*| |RP-IMP-C1-U1        |011 |  CLEAR   AT                            |
*| |RP-IMP-C1-U1        |012 |  SY-SUBRC = 4                          |
*| |RP-IMP-C1-U1        |013 |ENDIF                                   |
*| |RP-IMP-C1-ZI        |001 |****************************************|
*| |RP-IMP-C1-ZI        |002 |* CLUSTER ZI: INTERFACE ZU RK/RM       *|
*| |RP-IMP-C1-ZI        |003 |****************************************|
*| |RP-IMP-C1-ZI        |004 |IMPORT ZI-VERSION TO OZI-VERSION       *|
*| |RP-IMP-C1-ZI        |005 |       VBINT                           *|
*| |RP-IMP-C1-ZI        |006 |FROM DATABASE PCL1(ZI)                 *|
*| |RP-IMP-C1-ZI        |007 |ID ZI-KEY                              *|
*| |RP-IMP-C1-ZI        |008 |USING PCL1_EXP_IMP.                     |
*| |RP-IMP-C2-CW        |001 |****************************************|
*| |RP-IMP-C2-CW        |002 |* CLUSTER CW: CLUSTER DIRECTORY  (B)   *|
*| |RP-IMP-C2-CW        |003 |* SI TRIMESTERDATA PER PERSON          *|
*| |RP-IMP-C2-CW        |004 |****************************************|
*| |RP-IMP-C2-CW        |005 |IMPORT CW_VERSION TO OCW_VERSION       *|
*| |RP-IMP-C2-CW        |006 |       CW_NEXT_SEQ                     *|
*| |RP-IMP-C2-CW        |007 |       CW_LAST_SI                      *|
*| |RP-IMP-C2-CW        |008 |       WWDIR                           *|
*| |RP-IMP-C2-CW        |009 |       RBDIR                           *|
*| |RP-IMP-C2-CW        |010 |       HRT                             *|
*| |RP-IMP-C2-CW        |011 |FROM DATABASE PCL2(CW)                 *|
*| |RP-IMP-C2-CW        |012 |ID CW-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-CW        |013 |RP_IMP_CW_SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-CW        |014 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C2-CW        |015 |  CLEAR: CW_NEXT_SEQ,                  *|
*| |RP-IMP-C2-CW        |016 |         CW_LAST_SI,                   *|
*| |RP-IMP-C2-CW        |017 |         WWDIR,                        *|
*| |RP-IMP-C2-CW        |018 |         RBDIR,                        *|
*| |RP-IMP-C2-CW        |019 |         HRT                            |
*| |RP-IMP-C2-CW        |020 |  REFRESH: WWDIR, RBDIR, HRT            |
*| |RP-IMP-C2-CW        |021 |ENDIF                                   |
*| |RP-IMP-C2-CX        |001 |****************************************|
*| |RP-IMP-C2-CX        |002 |* CLUSTER CX: CLUSTER DIRECTORY  (B)   *|
*| |RP-IMP-C2-CX        |003 |* SI TRIMESTERDATA PER TAPE            *|
*| |RP-IMP-C2-CX        |004 |****************************************|
*| |RP-IMP-C2-CX        |005 |IMPORT CX_VERSION TO OCX_VERSION       *|
*| |RP-IMP-C2-CX        |006 |       CX_NEXT_SEQ                     *|
*| |RP-IMP-C2-CX        |007 |       CX_LAST_SI                      *|
*| |RP-IMP-C2-CX        |008 |       WXDIR                           *|
*| |RP-IMP-C2-CX        |009 |       XWWDIR                          *|
*| |RP-IMP-C2-CX        |010 |FROM DATABASE PCL2(CX)                 *|
*| |RP-IMP-C2-CX        |011 |ID CX-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-CX        |012 |RP_IMP_CX_SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-CX        |013 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C2-CX        |014 |  CLEAR: CX_NEXT_SEQ,                  *|
*| |RP-IMP-C2-CX        |015 |         CX_LAST_SI,                   *|
*| |RP-IMP-C2-CX        |016 |         WXDIR,                        *|
*| |RP-IMP-C2-CX        |017 |         XWWDIR                         |
*| |RP-IMP-C2-CX        |018 |  REFRESH: WXDIR, XWWDIR                |
*| |RP-IMP-C2-CX        |019 |ENDIF                                   |
*| |RP-IMP-C2-CY        |001 |****************************************|
*| |RP-IMP-C2-CY        |002 |* CLUSTER CY: CLUSTER DIRECTORY  (B)   *|
*| |RP-IMP-C2-CY        |003 |* TAXES   -   DATA PER TAPE            *|
*| |RP-IMP-C2-CY        |004 |****************************************|
*| |RP-IMP-C2-CY        |005 |IMPORT CY-VERSION TO OCY-VERSION       *|
*| |RP-IMP-C2-CY        |006 |       CY-NEXT_SEQ                     *|
*| |RP-IMP-C2-CY        |007 |       CY-LAST_SI                      *|
*| |RP-IMP-C2-CY        |008 |       WYDIR                           *|
*| |RP-IMP-C2-CY        |009 |       WRBDIR                          *|
*| |RP-IMP-C2-CY        |010 |FROM DATABASE PCL2(CY)                 *|
*| |RP-IMP-C2-CY        |011 |ID CY-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-CY        |012 |RP-IMP-CY-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-CY        |013 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C2-CY        |014 |  CLEAR: CY-NEXT_SEQ,                  *|
*| |RP-IMP-C2-CY        |015 |         CY-LAST_SI,                   *|
*| |RP-IMP-C2-CY        |016 |         WYDIR,                        *|
*| |RP-IMP-C2-CY        |017 |         WRBDIR                         |
*| |RP-IMP-C2-CY        |018 |  REFRESH: WYDIR, WRBDIR                |
*| |RP-IMP-C2-CY        |019 |ENDIF                                   |
*| |RP-IMP-C2-GP        |001 |****************************************|
*| |RP-IMP-C2-GP        |002 |* CLUSTER GP:GB RECONCILIATION RECORDS *|
*| |RP-IMP-C2-GP        |003 |* RPC2GPG0 CONTAINS CLUSTER DEFINITION *|
*| |RP-IMP-C2-GP        |004 |****************************************|
*| |RP-IMP-C2-GP        |005 |IMPORT GP-VERSION TO OGP-VERSION       *|
*| |RP-IMP-C2-GP        |006 |       TRANSFER                        *|
*| |RP-IMP-C2-GP        |007 |       CUMT                            *|
*| |RP-IMP-C2-GP        |008 |       ADJMT                           *|
*| |RP-IMP-C2-GP        |009 |       STLVS                           *|
*| |RP-IMP-C2-GP        |010 |       CRTLVS                          *|
*| |RP-IMP-C2-GP        |011 |       REJECTED                        *|
*| |RP-IMP-C2-GP        |012 |       HD_CNT                          *|
*| |RP-IMP-C2-GP        |013 |       BDPAY                           *|
*| |RP-IMP-C2-GP        |014 |       ADRET                           *|
*| |RP-IMP-C2-GP        |015 |FROM DATABASE PCL2(GP) ID GP-KEY       *|
*| |RP-IMP-C2-GP        |016 |      USING PCL2_EXP_IMP                |
*| |RP-IMP-C2-GP        |017 |RP-IMP-GP-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-GP        |018 |IF RP-IMP-GP-SUBRC NE 0                 |
*| |RP-IMP-C2-GP        |019 |   CLEAR: OGP-VERSION, TRANSFER, CUMT, *|
*| |RP-IMP-C2-GP        |020 |          ADJMT, STLVS, REJECTED,      *|
*| |RP-IMP-C2-GP        |021 |          HD_CNT, BDPAY, ADRET, CRTLVS  |
*| |RP-IMP-C2-GP        |022 |   REFRESH: TRANSFER, CUMT, ADJMT,     *|
*| |RP-IMP-C2-GP        |023 |            STLVS, REJECTED, BDPAY,    *|
*| |RP-IMP-C2-GP        |024 |            ADRET, CRTLVS               |
*| |RP-IMP-C2-GP        |025 |ENDIF                                   |
*| |RP-IMP-C2-GP-O      |001 |****************************************|
*| |RP-IMP-C2-GP-O      |002 |* CLUSTER GP:GB OLD RECONCILS. RECORDS *|
*| |RP-IMP-C2-GP-O      |003 |* RPC2GPG1 CONTAINS CLUSTER DEFINITION *|
*| |RP-IMP-C2-GP-O      |004 |****************************************|
*| |RP-IMP-C2-GP-O      |005 |IMPORT GP-VERSION TO OGP-VERSION       *|
*| |RP-IMP-C2-GP-O      |006 |       TRANSFER   TO OTRANSFER         *|
*| |RP-IMP-C2-GP-O      |007 |       CUMT       TO OCUMT             *|
*| |RP-IMP-C2-GP-O      |008 |       ADJMT      TO OADJMT            *|
*| |RP-IMP-C2-GP-O      |009 |       STLVS      TO OSTLVS            *|
*| |RP-IMP-C2-GP-O      |010 |       CRTLVS     TO OCRTLVS           *|
*| |RP-IMP-C2-GP-O      |011 |       HD_CNT     TO OHD_CNT           *|
*| |RP-IMP-C2-GP-O      |012 |       REJECTED   TO OREJECTED         *|
*| |RP-IMP-C2-GP-O      |013 |       BDPAY      TO OBDPAY            *|
*| |RP-IMP-C2-GP-O      |014 |       ADRET      TO OADRET            *|
*| |RP-IMP-C2-GP-O      |015 |FROM DATABASE PCL2(GP) ID OGP-KEY      *|
*| |RP-IMP-C2-GP-O      |016 |      USING PCL2_EXP_IMP                |
*| |RP-IMP-C2-GP-O      |017 |RP-IMP-GP-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-GP-O      |018 |IF RP-IMP-GP-SUBRC NE 0                 |
*| |RP-IMP-C2-GP-O      |019 |   CLEAR: OGP-VERSION, OTRANSFER,      *|
*| |RP-IMP-C2-GP-O      |020 |          OCUMT, OADJMT, OSTLVS,       *|
*| |RP-IMP-C2-GP-O      |021 |          OHD_CNT, OREJECTED,          *|
*| |RP-IMP-C2-GP-O      |022 |          OBDPAY, OADRET, OCRTLVS       |
*| |RP-IMP-C2-GP-O      |023 |   REFRESH: OTRANSFER, OCUMT, OADJMT,  *|
*| |RP-IMP-C2-GP-O      |024 |            OSTLVS, OREJECTED,         *|
*| |RP-IMP-C2-GP-O      |025 |            OBDPAY, OADRET, OCRTLVS     |
*| |RP-IMP-C2-GP-O      |026 |ENDIF                                   |
*| |RP-IMP-C2-R1        |001 |****************************************|
*| |RP-IMP-C2-R1        |002 |* CLUSTER RU: PAYROLL RESULTS (USA)    *|
*| |RP-IMP-C2-R1        |003 |****************************************|
*| |RP-IMP-C2-R1        |004 |IMPORT RU-VERSION TO ORU-VERSION       *|
*| |RP-IMP-C2-R1        |005 |       PERM       TO OPERM             *|
*| |RP-IMP-C2-R1        |006 |       WPBP       TO OWPBP             *|
*| |RP-IMP-C2-R1        |007 |       TAX        TO OTAX              *|
*| |RP-IMP-C2-R1        |008 |       TAXR       TO OTAXR             *|
*| |RP-IMP-C2-R1        |009 |       TAXPR      TO OTAXPR            *|
*| |RP-IMP-C2-R1        |010 |       RT         TO ORT               *|
*| |RP-IMP-C2-R1        |011 |       CRT        TO OCRT              *|
*| |RP-IMP-C2-R1        |012 |       TCRT      TO OTCRT              *|
*| |RP-IMP-C2-R1        |014 |FROM DATABASE PCL2(R1)                 *|
*| |RP-IMP-C2-R1        |015 |ID RX-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-R1        |016 |RU-VERSION-NUMBER = '00'                |
*| |RP-IMP-C2-R1        |017 |RP-IMP-RU-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-R1        |018 |IF RP-IMP-RU-SUBRC NE 0                 |
*| |RP-IMP-C2-R1        |019 |CLEAR: ORU-VERSION,                    *|
*| |RP-IMP-C2-R1        |020 |       OPERM,                          *|
*| |RP-IMP-C2-R1        |021 |       OWPBP,                          *|
*| |RP-IMP-C2-R1        |022 |       OTAX,                           *|
*| |RP-IMP-C2-R1        |023 |       OTAXR,                          *|
*| |RP-IMP-C2-R1        |024 |       OTAXPR,                         *|
*| |RP-IMP-C2-R1        |025 |       ORT,                            *|
*| |RP-IMP-C2-R1        |026 |       OCRT,                           *|
*| |RP-IMP-C2-R1        |027 |       OTCRT.                          *|
*| |RP-IMP-C2-R1        |029 |REFRESH:                               *|
*| |RP-IMP-C2-R1        |030 |       OWPBP,                          *|
*| |RP-IMP-C2-R1        |031 |       OTAX,                           *|
*| |RP-IMP-C2-R1        |032 |       OTAXR,                          *|
*| |RP-IMP-C2-R1        |033 |       OTAXPR,                         *|
*| |RP-IMP-C2-R1        |034 |       ORT,                            *|
*| |RP-IMP-C2-R1        |035 |       OCRT,                           *|
*| |RP-IMP-C2-R1        |036 |       OTCRT.                          *|
*| |RP-IMP-C2-R1        |038 |  ELSE                                  |
*| |RP-IMP-C2-R1        |039 |  CALL FUNCTION 'RP_FILL_TCRT'         *|
*| |RP-IMP-C2-R1        |040 |    TABLES    ITCRTA  =  OTCRT         *|
*| |RP-IMP-C2-R1        |041 |              ITCRTB  =  OTCRT         *|
*| |RP-IMP-C2-R1        |042 |              OTCRT   =  OTCRT          |
*| |RP-IMP-C2-R1        |043 |ENDIF                                   |
*| |RP-IMP-C2-R1        |044 |                                        |
*| |RP-IMP-C2-R1        |045 |                                        |
*| |RP-IMP-C2-R1        |046 |                                        |
*| |RP-IMP-C2-R1        |047 |                                        |
*| |RP-IMP-C2-R1        |048 |                                        |
*| |RP-IMP-C2-R1        |049 |                                        |
*| |RP-IMP-C2-R1        |050 |                                        |
*| |RP-IMP-C2-R1        |051 |                                        |
*| |RP-IMP-C2-R1        |052 |                                        |
*| |RP-IMP-C2-R1        |053 |                                        |
*| |RP-IMP-C2-R1        |054 |                                        |
*| |RP-IMP-C2-R1        |055 |                                        |
*| |RP-IMP-C2-R1        |056 |                                        |
*| |RP-IMP-C2-R1        |057 |                                        |
*| |RP-IMP-C2-R1        |058 |                                        |
*| |RP-IMP-C2-R1        |059 |                                        |
*| |RP-IMP-C2-R1        |060 |                                        |
*| |RP-IMP-C2-R1        |061 |                                        |
*| |RP-IMP-C2-R1        |062 |                                        |
*| |RP-IMP-C2-R1        |063 |                                        |
*| |RP-IMP-C2-R1        |064 |                                        |
*| |RP-IMP-C2-R1        |065 |                                        |
*| |RP-IMP-C2-R1        |066 |                                        |
*| |RP-IMP-C2-R1        |067 |                                        |
*| |RP-IMP-C2-R1        |068 |                                        |
*| |RP-IMP-C2-R1        |069 |                                        |
*| |RP-IMP-C2-R1        |070 |                                        |
*| |RP-IMP-C2-R1        |071 |                                        |
*| |RP-IMP-C2-R1        |072 |                                        |
*| |RP-IMP-C2-R1        |073 |                                        |
*| |RP-IMP-C2-R1        |074 |                                        |
*| |RP-IMP-C2-R1        |075 |                                        |
*| |RP-IMP-C2-R1        |076 |                                        |
*| |RP-IMP-C2-R1        |077 |                                        |
*| |RP-IMP-C2-R1        |078 |                                        |
*| |RP-IMP-C2-R1        |079 |                                        |
*| |RP-IMP-C2-R1        |080 |                                        |
*| |RP-IMP-C2-R1        |081 |                                        |
*| |RP-IMP-C2-R1        |082 |                                        |
*| |RP-IMP-C2-R1        |083 |                                        |
*| |RP-IMP-C2-R1        |084 |                                        |
*| |RP-IMP-C2-R1        |085 |                                        |
*| |RP-IMP-C2-R1        |086 |                                        |
*| |RP-IMP-C2-R1        |087 |                                        |
*| |RP-IMP-C2-R1        |088 |                                        |
*| |RP-IMP-C2-R1        |089 |                                        |
*| |RP-IMP-C2-R1        |090 |                                        |
*| |RP-IMP-C2-R1        |091 |                                        |
*| |RP-IMP-C2-R1        |092 |                                        |
*| |RP-IMP-C2-R1        |093 |                                        |
*| |RP-IMP-C2-SP        |001 |****************************************|
*| |RP-IMP-C2-SP        |002 |* CLUSTER SP: STATUTORY SICKPAY (GB)   *|
*| |RP-IMP-C2-SP        |003 |IMPORT SP-VERSION                      *|
*| |RP-IMP-C2-SP        |004 |       WEEKS_FILLED                    *|
*| |RP-IMP-C2-SP        |005 |       WEEK01                          *|
*| |RP-IMP-C2-SP        |006 |       WEEK02                          *|
*| |RP-IMP-C2-SP        |007 |       WEEK03                          *|
*| |RP-IMP-C2-SP        |008 |       WEEK04                          *|
*| |RP-IMP-C2-SP        |009 |       WEEK05                          *|
*| |RP-IMP-C2-SP        |010 |       WEEK06                          *|
*| |RP-IMP-C2-SP        |011 |       WEEK07                          *|
*| |RP-IMP-C2-SP        |012 |       WEEK08                          *|
*| |RP-IMP-C2-SP        |013 |       WEEK09                          *|
*| |RP-IMP-C2-SP        |014 |       WEEK10                          *|
*| |RP-IMP-C2-SP        |015 |       WEEK11                          *|
*| |RP-IMP-C2-SP        |016 |       WEEK12                          *|
*| |RP-IMP-C2-SP        |017 |       WEEK13                          *|
*| |RP-IMP-C2-SP        |018 |       WEEK14                          *|
*| |RP-IMP-C2-SP        |019 |       WEEK15                          *|
*| |RP-IMP-C2-SP        |020 |       WEEK16                          *|
*| |RP-IMP-C2-SP        |021 |       WEEK17                          *|
*| |RP-IMP-C2-SP        |022 |       WEEK18                          *|
*| |RP-IMP-C2-SP        |023 |       WEEK19                          *|
*| |RP-IMP-C2-SP        |024 |       WEEK20                          *|
*| |RP-IMP-C2-SP        |025 |       WEEK21                          *|
*| |RP-IMP-C2-SP        |026 |       WEEK22                          *|
*| |RP-IMP-C2-SP        |027 |       WEEK23                          *|
*| |RP-IMP-C2-SP        |028 |       WEEK24                          *|
*| |RP-IMP-C2-SP        |029 |       WEEK25                          *|
*| |RP-IMP-C2-SP        |030 |       WEEK26                          *|
*| |RP-IMP-C2-SP        |031 |       WEEK27                          *|
*| |RP-IMP-C2-SP        |032 |       WEEK28                          *|
*| |RP-IMP-C2-SP        |033 |       WEEK29                          *|
*| |RP-IMP-C2-SP        |034 |       WEEK30                          *|
*| |RP-IMP-C2-SP        |035 |       WEEK31                          *|
*| |RP-IMP-C2-SP        |036 |       WEEK32                          *|
*| |RP-IMP-C2-SP        |037 |       WEEK33                          *|
*| |RP-IMP-C2-SP        |038 |       WEEK34                          *|
*| |RP-IMP-C2-SP        |039 |       WEEK35                          *|
*| |RP-IMP-C2-SP        |040 |       WEEK36                          *|
*| |RP-IMP-C2-SP        |041 |       WEEK37                          *|
*| |RP-IMP-C2-SP        |042 |       WEEK38                          *|
*| |RP-IMP-C2-SP        |043 |       WEEK39                          *|
*| |RP-IMP-C2-SP        |044 |       WEEK40                          *|
*| |RP-IMP-C2-SP        |045 |       WEEK41                          *|
*| |RP-IMP-C2-SP        |046 |       WEEK42                          *|
*| |RP-IMP-C2-SP        |047 |       WEEK43                          *|
*| |RP-IMP-C2-SP        |048 |       WEEK44                          *|
*| |RP-IMP-C2-SP        |049 |       WEEK45                          *|
*| |RP-IMP-C2-SP        |050 |       WEEK46                          *|
*| |RP-IMP-C2-SP        |051 |       WEEK47                          *|
*| |RP-IMP-C2-SP        |052 |       WEEK48                          *|
*| |RP-IMP-C2-SP        |053 |       WEEK49                          *|
*| |RP-IMP-C2-SP        |054 |       WEEK50                          *|
*| |RP-IMP-C2-SP        |055 |       WEEK51                          *|
*| |RP-IMP-C2-SP        |056 |       WEEK52                          *|
*| |RP-IMP-C2-SP        |057 |       WEEK53                          *|
*| |RP-IMP-C2-SP        |058 |FROM DATABASE PCL2(SP)                 *|
*| |RP-IMP-C2-SP        |059 |ID SP-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-SP        |060 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C2-SP        |061 |* MSG GOES TO ERRORTAB OR STH.          |
*| |RP-IMP-C2-SP        |062 |* OR SET RETURNCODE                     |
*| |RP-IMP-C2-SP        |063 |ENDIF                                   |
*| |RP-IMP-C2-SP-O      |001 |****************************************|
*| |RP-IMP-C2-SP-O      |002 |* CLUSTER SP: STATUTORY SICKPAY (GB)   *|
*| |RP-IMP-C2-SP-O      |003 |IMPORT SP-VERSION TO OLD_SP-VERSION    *|
*| |RP-IMP-C2-SP-O      |004 |       WEEKS_FILLED TO OLD_WEEKS_FILLED*|
*| |RP-IMP-C2-SP-O      |005 |       WEEK01 TO OLD_WEEK01            *|
*| |RP-IMP-C2-SP-O      |006 |       WEEK02 TO OLD_WEEK02            *|
*| |RP-IMP-C2-SP-O      |007 |       WEEK03 TO OLD_WEEK03            *|
*| |RP-IMP-C2-SP-O      |008 |       WEEK04 TO OLD_WEEK04            *|
*| |RP-IMP-C2-SP-O      |009 |       WEEK05 TO OLD_WEEK05            *|
*| |RP-IMP-C2-SP-O      |010 |       WEEK06 TO OLD_WEEK06            *|
*| |RP-IMP-C2-SP-O      |011 |       WEEK07 TO OLD_WEEK07            *|
*| |RP-IMP-C2-SP-O      |012 |       WEEK08 TO OLD_WEEK08            *|
*| |RP-IMP-C2-SP-O      |013 |       WEEK09 TO OLD_WEEK09            *|
*| |RP-IMP-C2-SP-O      |014 |       WEEK10 TO OLD_WEEK10            *|
*| |RP-IMP-C2-SP-O      |015 |       WEEK11 TO OLD_WEEK11            *|
*| |RP-IMP-C2-SP-O      |016 |       WEEK12 TO OLD_WEEK12            *|
*| |RP-IMP-C2-SP-O      |017 |       WEEK13 TO OLD_WEEK13            *|
*| |RP-IMP-C2-SP-O      |018 |       WEEK14 TO OLD_WEEK14            *|
*| |RP-IMP-C2-SP-O      |019 |       WEEK15 TO OLD_WEEK15            *|
*| |RP-IMP-C2-SP-O      |020 |       WEEK16 TO OLD_WEEK16            *|
*| |RP-IMP-C2-SP-O      |021 |       WEEK17 TO OLD_WEEK17            *|
*| |RP-IMP-C2-SP-O      |022 |       WEEK18 TO OLD_WEEK18            *|
*| |RP-IMP-C2-SP-O      |023 |       WEEK19 TO OLD_WEEK19            *|
*| |RP-IMP-C2-SP-O      |024 |       WEEK20 TO OLD_WEEK20            *|
*| |RP-IMP-C2-SP-O      |025 |       WEEK21 TO OLD_WEEK21            *|
*| |RP-IMP-C2-SP-O      |026 |       WEEK22 TO OLD_WEEK22            *|
*| |RP-IMP-C2-SP-O      |027 |       WEEK23 TO OLD_WEEK23            *|
*| |RP-IMP-C2-SP-O      |028 |       WEEK24 TO OLD_WEEK24            *|
*| |RP-IMP-C2-SP-O      |029 |       WEEK25 TO OLD_WEEK25            *|
*| |RP-IMP-C2-SP-O      |030 |       WEEK26 TO OLD_WEEK26            *|
*| |RP-IMP-C2-SP-O      |031 |       WEEK27 TO OLD_WEEK27            *|
*| |RP-IMP-C2-SP-O      |032 |       WEEK28 TO OLD_WEEK28            *|
*| |RP-IMP-C2-SP-O      |033 |       WEEK29 TO OLD_WEEK29            *|
*| |RP-IMP-C2-SP-O      |034 |       WEEK30 TO OLD_WEEK30            *|
*| |RP-IMP-C2-SP-O      |035 |       WEEK31 TO OLD_WEEK31            *|
*| |RP-IMP-C2-SP-O      |036 |       WEEK32 TO OLD_WEEK32            *|
*| |RP-IMP-C2-SP-O      |037 |       WEEK33 TO OLD_WEEK33            *|
*| |RP-IMP-C2-SP-O      |038 |       WEEK34 TO OLD_WEEK34            *|
*| |RP-IMP-C2-SP-O      |039 |       WEEK35 TO OLD_WEEK35            *|
*| |RP-IMP-C2-SP-O      |040 |       WEEK36 TO OLD_WEEK36            *|
*| |RP-IMP-C2-SP-O      |041 |       WEEK37 TO OLD_WEEK37            *|
*| |RP-IMP-C2-SP-O      |042 |       WEEK38 TO OLD_WEEK38            *|
*| |RP-IMP-C2-SP-O      |043 |       WEEK39 TO OLD_WEEK39            *|
*| |RP-IMP-C2-SP-O      |044 |       WEEK40 TO OLD_WEEK40            *|
*| |RP-IMP-C2-SP-O      |045 |       WEEK41 TO OLD_WEEK41            *|
*| |RP-IMP-C2-SP-O      |046 |       WEEK42 TO OLD_WEEK42            *|
*| |RP-IMP-C2-SP-O      |047 |       WEEK43 TO OLD_WEEK43            *|
*| |RP-IMP-C2-SP-O      |048 |       WEEK44 TO OLD_WEEK44            *|
*| |RP-IMP-C2-SP-O      |049 |       WEEK45 TO OLD_WEEK45            *|
*| |RP-IMP-C2-SP-O      |050 |       WEEK46 TO OLD_WEEK46            *|
*| |RP-IMP-C2-SP-O      |051 |       WEEK47 TO OLD_WEEK47            *|
*| |RP-IMP-C2-SP-O      |052 |       WEEK48 TO OLD_WEEK48            *|
*| |RP-IMP-C2-SP-O      |053 |       WEEK49 TO OLD_WEEK49            *|
*| |RP-IMP-C2-SP-O      |054 |       WEEK50 TO OLD_WEEK50            *|
*| |RP-IMP-C2-SP-O      |055 |       WEEK51 TO OLD_WEEK51            *|
*| |RP-IMP-C2-SP-O      |056 |       WEEK52 TO OLD_WEEK52            *|
*| |RP-IMP-C2-SP-O      |057 |       WEEK53 TO OLD_WEEK53            *|
*| |RP-IMP-C2-SP-O      |058 |FROM DATABASE PCL2(SP)                 *|
*| |RP-IMP-C2-SP-O      |059 |ID SP-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-SP-O      |060 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C2-SP-O      |061 |* MSG GOES TO ERRORTAB OR STH.          |
*| |RP-IMP-C2-SP-O      |062 |* OR SET RETURNCODE                     |
*| |RP-IMP-C2-SP-O      |063 |ENDIF                                   |
*| |RP-IMP-C2-WW        |001 |****************************************|
*| |RP-IMP-C2-WW        |002 |* CLUSTER WW: PAYROLL (BELGIUM) SI    **|
*| |RP-IMP-C2-WW        |003 |****************************************|
*| |RP-IMP-C2-WW        |004 |IMPORT WW_VERSION TO OWW_VERSION       *|
*| |RP-IMP-C2-WW        |005 |       WWPBP                           *|
*| |RP-IMP-C2-WW        |006 |       WAB                             *|
*| |RP-IMP-C2-WW        |007 |       WRT                             *|
*| |RP-IMP-C2-WW        |008 |       WSV                             *|
*| |RP-IMP-C2-WW        |009 |       WDATE                           *|
*| |RP-IMP-C2-WW        |010 |       WFIRE                           *|
*| |RP-IMP-C2-WW        |011 |FROM DATABASE PCL2(WW)                 *|
*| |RP-IMP-C2-WW        |012 |ID WW-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-WW        |013 |RP_IMP_WW_SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-WW        |014 |IF RP_IMP_WW_SUBRC <> 0                 |
*| |RP-IMP-C2-WW        |015 |CLEAR: OWW_VERSION,                    *|
*| |RP-IMP-C2-WW        |016 |       WWPBP,                          *|
*| |RP-IMP-C2-WW        |017 |       WAB,                            *|
*| |RP-IMP-C2-WW        |018 |       WRT,                            *|
*| |RP-IMP-C2-WW        |019 |       WSV,                            *|
*| |RP-IMP-C2-WW        |020 |       WDATE,                          *|
*| |RP-IMP-C2-WW        |021 |       WFIRE                            |
*| |RP-IMP-C2-WW        |022 |REFRESH:                               *|
*| |RP-IMP-C2-WW        |023 |       WWPBP,                          *|
*| |RP-IMP-C2-WW        |024 |       WAB,                            *|
*| |RP-IMP-C2-WW        |025 |       WRT,                            *|
*| |RP-IMP-C2-WW        |026 |       WSV,                            *|
*| |RP-IMP-C2-WW        |027 |       WFIRE                            |
*| |RP-IMP-C2-WW        |028 |ENDIF                                   |
*| |RP-IMP-C2-WX        |001 |****************************************|
*| |RP-IMP-C2-WX        |002 |* CLUSTER WX: PAYROLL (BELGIUM) SI     *|
*| |RP-IMP-C2-WX        |003 |****************************************|
*| |RP-IMP-C2-WX        |004 |IMPORT WX_VERSION TO OWX_VERSION       *|
*| |RP-IMP-C2-WX        |005 |       WSI                             *|
*| |RP-IMP-C2-WX        |006 |FROM DATABASE PCL2(WX)                 *|
*| |RP-IMP-C2-WX        |007 |ID WX-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-WX        |008 |RP_IMP_WX_SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-WX        |009 |IF RP_IMP_WX_SUBRC <> 0                 |
*| |RP-IMP-C2-WX        |010 |CLEAR: OWX_VERSION,                    *|
*| |RP-IMP-C2-WX        |011 |       WSI                              |
*| |RP-IMP-C2-WX        |012 |REFRESH:                               *|
*| |RP-IMP-C2-WX        |013 |       WSI                              |
*| |RP-IMP-C2-WX        |014 |ENDIF                                   |
*| |RP-IMP-C2-WY        |001 |****************************************|
*| |RP-IMP-C2-WY        |002 |* CLUSTER WY: PAYROLL (BELGIUM) TAXES  *|
*| |RP-IMP-C2-WY        |003 |****************************************|
*| |RP-IMP-C2-WY        |004 |IMPORT WY-VERSION TO OWY-VERSION       *|
*| |RP-IMP-C2-WY        |005 |       W274                            *|
*| |RP-IMP-C2-WY        |006 |       WTAX                            *|
*| |RP-IMP-C2-WY        |007 |FROM DATABASE PCL2(WY)                 *|
*| |RP-IMP-C2-WY        |008 |ID WY-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-WY        |009 |RP-IMP-WY-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-WY        |010 |IF RP-IMP-WY-SUBRC <> 0                 |
*| |RP-IMP-C2-WY        |011 |CLEAR: OWY-VERSION,                    *|
*| |RP-IMP-C2-WY        |012 |       W274,                           *|
*| |RP-IMP-C2-WY        |013 |       WTAX                             |
*| |RP-IMP-C2-WY        |014 |REFRESH:                               *|
*| |RP-IMP-C2-WY        |015 |       WTAX                             |
*| |RP-IMP-C2-WY        |016 |ENDIF                                   |
*| |RP-IMP-C2-ZA        |001 |****************************************|
*| |RP-IMP-C2-ZA        |002 |* CLUSTER ZA: DURCHSCHNITT     VBL/ZVK *|
*| |RP-IMP-C2-ZA        |003 |****************************************|
*| |RP-IMP-C2-ZA        |004 |IMPORT DURCHSCHNITT                    *|
*| |RP-IMP-C2-ZA        |007 |FROM DATABASE PCL2(ZA)                 *|
*| |RP-IMP-C2-ZA        |008 |ID ZA-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-ZA        |009 |RP-IMP-ZA-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-ZD        |001 |****************************************|
*| |RP-IMP-C2-ZD        |002 |* CLUSTER ZD: STEUER/DURCHSCH. VBL/ZVK *|
*| |RP-IMP-C2-ZD        |003 |****************************************|
*| |RP-IMP-C2-ZD        |004 |IMPORT VORAUS_UMLAGE                   *|
*| |RP-IMP-C2-ZD        |007 |FROM DATABASE PCL2(ZD)                 *|
*| |RP-IMP-C2-ZD        |008 |ID ZD-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-ZD        |009 |RP-IMP-ZD-SUBRC = SY-SUBRC              |
*| |RP-IMP-C2-ZS        |001 |****************************************|
*| |RP-IMP-C2-ZS        |002 |* CLUSTER ZS: EINMALZAHLUNG VBL/ZVK    *|
*| |RP-IMP-C2-ZS        |003 |****************************************|
*| |RP-IMP-C2-ZS        |004 |IMPORT ZS-VERSION                      *|
*| |RP-IMP-C2-ZS        |005 |       EINMAL_ZAHLUNG                  *|
*| |RP-IMP-C2-ZS        |007 |FROM DATABASE PCL2(ZS)                 *|
*| |RP-IMP-C2-ZS        |008 |ID ZS-KEY USING PCL2_EXP_IMP            |
*| |RP-IMP-C2-ZS        |009 |RP-IMP-ZS-SUBRC = SY-SUBRC              |
*| |RP-IMP-C3-AL        |001 |****************************************|
*| |RP-IMP-C3-AL        |002 |* CLUSTER AL: BRIEFE FÜR VORGÄNGE      *|
*| |RP-IMP-C3-AL        |003 |****************************************|
*| |RP-IMP-C3-AL        |004 |REFRESH: LETTER                         |
*| |RP-IMP-C3-AL        |005 |CLEAR: LETTER, OAL-VERSION              |
*| |RP-IMP-C3-AL        |006 |IMPORT AL-VERSION TO OAL-VERSION       *|
*| |RP-IMP-C3-AL        |007 |       LETTER                          *|
*| |RP-IMP-C3-AL        |008 |FROM DATABASE PCL3(AL)                 *|
*| |RP-IMP-C3-AL        |009 |ID AL-KEY USING PCL3_EXP_IMP            |
*| |RP-IMP-C3-AL        |010 |AL-VERSION-NUMMER = '01'                |
*| |RP-IMP-C3-AL        |011 |RP-IMP-C3-AL-SUBRC = SY-SUBRC           |
*| |RP-IMP-C3-AL        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-AL        |013 |  CLEAR: LETTER, OAL-VERSION            |
*| |RP-IMP-C3-AL        |014 |  REFRESH: LETTER                       |
*| |RP-IMP-C3-AL        |015 |ELSE                                    |
*| |RP-IMP-C3-AL        |016 |  IF AL-VERSION-NUMMER NE              *|
*| |RP-IMP-C3-AL        |017 |     OAL-VERSION-NUMMER                 |
*| |RP-IMP-C3-AL        |018 |    RP-IMP-C3-AL-SUBRC = 8              |
*| |RP-IMP-C3-AL        |019 |  ENDIF                                 |
*| |RP-IMP-C3-AL        |020 |ENDIF                                   |
*| |RP-IMP-C3-AL-WINWORD|001 |****************************************|
*| |RP-IMP-C3-AL-WINWORD|002 |* CLUSTER AL: BRIEFE FÜR VORGÄNGE      *|
*| |RP-IMP-C3-AL-WINWORD|003 |****************************************|
*| |RP-IMP-C3-AL-WINWORD|004 |REFRESH: TEXT, LETTER                   |
*| |RP-IMP-C3-AL-WINWORD|005 |CLEAR: TEXT, LETTER, OAL-VERSION        |
*| |RP-IMP-C3-AL-WINWORD|006 |IMPORT AL-VERSION TO OAL-VERSION       *|
*| |RP-IMP-C3-AL-WINWORD|007 |       LETTER     TO TEXT              *|
*| |RP-IMP-C3-AL-WINWORD|008 |FROM DATABASE PCL3(AL)                 *|
*| |RP-IMP-C3-AL-WINWORD|009 |ID AL-KEY USING PCL3_EXP_IMP            |
*| |RP-IMP-C3-AL-WINWORD|010 |AL-VERSION-NUMMER = '01'                |
*| |RP-IMP-C3-AL-WINWORD|011 |RP-IMP-C3-AL-SUBRC = SY-SUBRC           |
*| |RP-IMP-C3-AL-WINWORD|012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-AL-WINWORD|013 |  CLEAR: TEXT, OAL-VERSION              |
*| |RP-IMP-C3-AL-WINWORD|014 |  REFRESH: TEXT                         |
*| |RP-IMP-C3-AL-WINWORD|015 |ELSE                                    |
*| |RP-IMP-C3-AL-WINWORD|016 |  IF AL-VERSION-NUMMER NE              *|
*| |RP-IMP-C3-AL-WINWORD|017 |     OAL-VERSION-NUMMER                 |
*| |RP-IMP-C3-AL-WINWORD|018 |    RP-IMP-C3-AL-SUBRC = 8              |
*| |RP-IMP-C3-AL-WINWORD|019 |  ENDIF                                 |
*| |RP-IMP-C3-AL-WINWORD|020 |ENDIF                                   |
*| |RP-IMP-C3-AN        |001 |****************************************|
*| |RP-IMP-C3-AN        |002 |* CLUSTER AN: NOTE-PAD F. VORGÄNGE     *|
*| |RP-IMP-C3-AN        |003 |****************************************|
*| |RP-IMP-C3-AN        |004 |REFRESH: NOTES                          |
*| |RP-IMP-C3-AN        |005 |CLEAR: NOTES, OAN-VERSION               |
*| |RP-IMP-C3-AN        |006 |IMPORT AN-VERSION TO OAN-VERSION       *|
*| |RP-IMP-C3-AN        |007 |       NOTES                           *|
*| |RP-IMP-C3-AN        |008 |FROM DATABASE PCL3(AN)                 *|
*| |RP-IMP-C3-AN        |009 |ID AN-KEY USING PCL3_EXP_IMP            |
*| |RP-IMP-C3-AN        |010 |AN-VERSION-NUMMER = '01'                |
*| |RP-IMP-C3-AN        |011 |RP-IMP-C3-AN-SUBRC = SY-SUBRC           |
*| |RP-IMP-C3-AN        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-AN        |013 |  CLEAR: NOTES, OAN-VERSION             |
*| |RP-IMP-C3-AN        |014 |  REFRESH: NOTES                        |
*| |RP-IMP-C3-AN        |015 |ELSE                                    |
*| |RP-IMP-C3-AN        |016 |  IF AN-VERSION-NUMMER NE              *|
*| |RP-IMP-C3-AN        |017 |     OAN-VERSION-NUMMER                 |
*| |RP-IMP-C3-AN        |018 |    RP-IMP-C3-AN-SUBRC = 8              |
*| |RP-IMP-C3-AN        |019 |  ENDIF                                 |
*| |RP-IMP-C3-AN        |020 |ENDIF                                   |
*| |RP-IMP-C3-AP        |001 |****************************************|
*| |RP-IMP-C3-AP        |002 |* CLUSTER AP: BEWERBERVORGÄNGE         *|
*| |RP-IMP-C3-AP        |003 |****************************************|
*| |RP-IMP-C3-AP        |004 |REFRESH: ACTIV                          |
*| |RP-IMP-C3-AP        |005 |CLEAR: ACTIV, OAP-VERSION               |
*| |RP-IMP-C3-AP        |006 |IMPORT AP-VERSION TO OAP-VERSION       *|
*| |RP-IMP-C3-AP        |007 |       ACTIV                           *|
*| |RP-IMP-C3-AP        |008 |FROM DATABASE PCL3(AP)                 *|
*| |RP-IMP-C3-AP        |009 |ID AP-KEY USING PCL3_EXP_IMP            |
*| |RP-IMP-C3-AP        |010 |AP-VERSION-NUMMER = '02'                |
*| |RP-IMP-C3-AP        |011 |RP-IMP-C3-AP-SUBRC = SY-SUBRC           |
*| |RP-IMP-C3-AP        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-AP        |013 |  CLEAR: ACTIV, OAP-VERSION             |
*| |RP-IMP-C3-AP        |014 |  REFRESH: ACTIV                        |
*| |RP-IMP-C3-AP        |015 |ELSE                                    |
*| |RP-IMP-C3-AP        |016 |  IF AP-VERSION-NUMMER NE              *|
*| |RP-IMP-C3-AP        |017 |     OAP-VERSION-NUMMER                 |
*| |RP-IMP-C3-AP        |018 |    RP-IMP-C3-AP-SUBRC = 8              |
*| |RP-IMP-C3-AP        |019 |  ENDIF                                 |
*| |RP-IMP-C3-AP        |020 |ENDIF                                   |
*| |RP-IMP-C3-AP-CHECK  |001 |****************************************|
*| |RP-IMP-C3-AP-CHECK  |002 |* CLUSTER AP: BEWERBERVORGÄNGE CHECK   *|
*| |RP-IMP-C3-AP-CHECK  |003 |****************************************|
*| |RP-IMP-C3-AP-CHECK  |004 |DATA: RP-IMP-C3-AP-SUBRC LIKE SY-SUBRC  |
*| |RP-IMP-C3-AP-CHECK  |005 |CLEAR: ACTIV-CHECK, OAP-VERSION-CHECK   |
*| |RP-IMP-C3-AP-CHECK  |006 |REFRESH: ACTIV-CHECK                    |
*| |RP-IMP-C3-AP-CHECK  |007 |IMPORT AP-VERSION TO OAP-VERSION-CHECK *|
*| |RP-IMP-C3-AP-CHECK  |008 |       ACTIV      TO ACTIV-CHECK       *|
*| |RP-IMP-C3-AP-CHECK  |009 |FROM DATABASE PCL3(AP)                 *|
*| |RP-IMP-C3-AP-CHECK  |010 |ID AP-KEY-CHECK USING PCL3_EXP_IMP      |
*| |RP-IMP-C3-AP-CHECK  |011 |AP-VERSION-NUMMER = '02'                |
*| |RP-IMP-C3-AP-CHECK  |012 |RP-IMP-C3-AP-SUBRC = SY-SUBRC           |
*| |RP-IMP-C3-AP-CHECK  |013 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-AP-CHECK  |014 |  CLEAR: ACTIV-CHECK,OAP-VERSION-CHECK  |
*| |RP-IMP-C3-AP-CHECK  |015 |  REFRESH: ACTIV-CHECK                  |
*| |RP-IMP-C3-AP-CHECK  |016 |ELSE                                    |
*| |RP-IMP-C3-AP-CHECK  |017 |  IF AP-VERSION-NUMMER NE              *|
*| |RP-IMP-C3-AP-CHECK  |018 |     OAP-VERSION-CHECK-NUMMER           |
*| |RP-IMP-C3-AP-CHECK  |019 |    RP-IMP-C3-AP-SUBRC = 8              |
*| |RP-IMP-C3-AP-CHECK  |020 |  ENDIF                                 |
*| |RP-IMP-C3-AP-CHECK  |021 |ENDIF                                   |
*| |RP-IMP-C3-TY        |001 |****************************************|
*| |RP-IMP-C3-TY        |002 |* CLUSTER TY: TEXTE BEWERBERDATEN      *|
*| |RP-IMP-C3-TY        |003 |PERFORM DO_NOTHING(SAPFP50P)            |
*| |RP-IMP-C3-TY        |004 |IMPORT TEXT-VERSION PTEXT              *|
*| |RP-IMP-C3-TY        |005 |FROM DATABASE PCL3(TY)                 *|
*| |RP-IMP-C3-TY        |006 |ID TY-KEY                              *|
*| |RP-IMP-C3-TY        |007 |USING PCL3_EXP_IMP(SAPFP50P)            |
*| |RP-IMP-C3-TY        |008 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C3-TY        |009 |   CLEAR: TEXT-VERSION                  |
*| |RP-IMP-C3-TY        |010 |   CLEAR: PTEXT                         |
*| |RP-IMP-C3-TY        |011 |   REFRESH: PTEXT                       |
*| |RP-IMP-C3-TY        |012 |   SY-SUBRC = 4                         |
*| |RP-IMP-C3-TY        |013 |ENDIF                                   |
*| |RP-IMP-C4-$0        |001 |****************************************|
*| |RP-IMP-C4-$0        |002 |* CLUSTER $0: FILLED PAY STATEMENT     *|
*| |RP-IMP-C4-$0        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-IMP-C4-$0        |004 |*             RPCDTCX0                 *|
*| |RP-IMP-C4-$0        |005 |****************************************|
*| |RP-IMP-C4-$0        |006 |*MPORT VERSC                           *|
*| |RP-IMP-C4-$0        |007 |IMPORT PINFO                           *|
*| |RP-IMP-C4-$0        |008 |       PFORM                           *|
*| |RP-IMP-C4-$0        |009 |FROM DATABASE PCL4(F1)                 *|
*| |RP-IMP-C4-$0        |010 |ID $0-KEY                              *|
*| |RP-IMP-C4-$0        |011 |USING PCL4_EXP_IMP                      |
*| |RP-IMP-C4-$0        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-$0        |013 |   CLEAR:   PINFO                       |
*| |RP-IMP-C4-$0        |014 |   CLEAR:   PFORM                       |
*| |RP-IMP-C4-$0        |015 |   REFRESH: PFORM                       |
*| |RP-IMP-C4-$0        |016 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-$0        |017 |ENDIF                                   |
*| |RP-IMP-C4-F1        |001 |****************************************|
*| |RP-IMP-C4-F1        |002 |* CLUSTER F1: FILLED PAY STATEMENT     *|
*| |RP-IMP-C4-F1        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-IMP-C4-F1        |004 |*             RPCDTCX0                 *|
*| |RP-IMP-C4-F1        |005 |****************************************|
*| |RP-IMP-C4-F1        |006 |IMPORT PINFO                           *|
*| |RP-IMP-C4-F1        |007 |       PFORM                           *|
*| |RP-IMP-C4-F1        |008 |FROM DATABASE PCL4(F1)                 *|
*| |RP-IMP-C4-F1        |009 |ID F1-KEY                              *|
*| |RP-IMP-C4-F1        |010 |USING PCL4_EXP_IMP                      |
*| |RP-IMP-C4-F1        |011 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-F1        |012 |   CLEAR:   PINFO                       |
*| |RP-IMP-C4-F1        |013 |   CLEAR:   PFORM                       |
*| |RP-IMP-C4-F1        |014 |   REFRESH: PFORM                       |
*| |RP-IMP-C4-F1        |015 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-F1        |016 |ENDIF                                   |
*| |RP-IMP-C4-F2        |001 |****************************************|
*| |RP-IMP-C4-F2        |002 |* CLUSTER F2: FILLED GARNISH. STATEMENT*|
*| |RP-IMP-C4-F2        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-IMP-C4-F2        |004 |*             RPURMP00                 *|
*| |RP-IMP-C4-F2        |005 |****************************************|
*| |RP-IMP-C4-F2        |006 |IMPORT PFORM PFORM1                    *|
*| |RP-IMP-C4-F2        |007 |       PINFO PINFO1                    *|
*| |RP-IMP-C4-F2        |008 |FROM DATABASE PCL4(F2)                 *|
*| |RP-IMP-C4-F2        |009 |ID F2-KEY                              *|
*| |RP-IMP-C4-F2        |010 |USING PCL4_EXP_IMP                      |
*| |RP-IMP-C4-F2        |011 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-F2        |012 |   CLEAR:   PINFO, PINFO1               |
*| |RP-IMP-C4-F2        |013 |   CLEAR:   PFORM, PFORM1               |
*| |RP-IMP-C4-F2        |014 |   REFRESH: PFORM, PFORM1               |
*| |RP-IMP-C4-F2        |015 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-F2        |016 |ENDIF                                   |
*| |RP-IMP-C4-LA        |001 |****************************************|
*| |RP-IMP-C4-LA        |002 |* Cluster LA: Langzeit-Belege für PREL *|
*| |RP-IMP-C4-LA        |003 |****************************************|
*| |RP-IMP-C4-LA        |004 |IMPORT VERSION                         *|
*| |RP-IMP-C4-LA        |005 |       HEADER                          *|
*| |RP-IMP-C4-LA        |006 |       BELEGE                          *|
*| |RP-IMP-C4-LA        |007 |FROM DATABASE PCL4(LA)                 *|
*| |RP-IMP-C4-LA        |008 |ID LO-KEY                               |
*| |RP-IMP-C4-LA        |009 |*USING PCL4_EXP_IMP                     |
*| |RP-IMP-C4-LA        |010 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-LA        |011 |   CLEAR:   VERSION                     |
*| |RP-IMP-C4-LA        |012 |   CLEAR:   HEADER, BELEGE              |
*| |RP-IMP-C4-LA        |013 |   REFRESH: HEADER, BELEGE              |
*| |RP-IMP-C4-LA        |014 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-LA        |015 |ENDIF                                   |
*| |RP-IMP-C4-LB        |001 |****************************************|
*| |RP-IMP-C4-LB        |002 |* Cluster LB: Langzeit-Belege für PAPL *|
*| |RP-IMP-C4-LB        |003 |****************************************|
*| |RP-IMP-C4-LB        |004 |IMPORT VERSION                         *|
*| |RP-IMP-C4-LB        |005 |       HEADER                          *|
*| |RP-IMP-C4-LB        |006 |       BELEGE                          *|
*| |RP-IMP-C4-LB        |007 |FROM DATABASE PCL4(LB)                 *|
*| |RP-IMP-C4-LB        |008 |ID LO-KEY                               |
*| |RP-IMP-C4-LB        |009 |*USING PCL4_EXP_IMP                     |
*| |RP-IMP-C4-LB        |010 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-LB        |011 |   CLEAR:   VERSION                     |
*| |RP-IMP-C4-LB        |012 |   CLEAR:   HEADER, BELEGE              |
*| |RP-IMP-C4-LB        |013 |   REFRESH: HEADER, BELEGE              |
*| |RP-IMP-C4-LB        |014 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-LB        |015 |ENDIF                                   |
*| |RP-IMP-C4-PR        |001 |****************************************|
*| |RP-IMP-C4-PR        |002 |* CLUSTER PR: PROTOCOL REPORT-START    *|
*| |RP-IMP-C4-PR        |003 |* DESCRICTION IN INCLUDE RPC4PR00      *|
*| |RP-IMP-C4-PR        |004 |****************************************|
*| |RP-IMP-C4-SA        |001 |****************************************|
*| |RP-IMP-C4-SA        |002 |* Cluster SA: Kurzzeit-Belege für PREL *|
*| |RP-IMP-C4-SA        |003 |****************************************|
*| |RP-IMP-C4-SA        |004 |IMPORT VERSION                         *|
*| |RP-IMP-C4-SA        |005 |       HEADER                          *|
*| |RP-IMP-C4-SA        |006 |       BELEGE                          *|
*| |RP-IMP-C4-SA        |007 |FROM DATABASE PCL4(SA)                 *|
*| |RP-IMP-C4-SA        |008 |ID SH-KEY                               |
*| |RP-IMP-C4-SA        |009 |*USING PCL4_EXP_IMP                     |
*| |RP-IMP-C4-SA        |010 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-SA        |011 |   CLEAR:   VERSION                     |
*| |RP-IMP-C4-SA        |012 |   CLEAR:   HEADER, BELEGE              |
*| |RP-IMP-C4-SA        |013 |   REFRESH: HEADER, BELEGE              |
*| |RP-IMP-C4-SA        |014 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-SA        |015 |ENDIF                                   |
*| |RP-IMP-C4-SB        |001 |****************************************|
*| |RP-IMP-C4-SB        |002 |* Cluster SB: Kurzzeit-Belege für PAPL *|
*| |RP-IMP-C4-SB        |003 |****************************************|
*| |RP-IMP-C4-SB        |004 |IMPORT VERSION                         *|
*| |RP-IMP-C4-SB        |005 |       HEADER                          *|
*| |RP-IMP-C4-SB        |006 |       BELEGE                          *|
*| |RP-IMP-C4-SB        |007 |FROM DATABASE PCL4(SB)                 *|
*| |RP-IMP-C4-SB        |008 |ID SH-KEY                               |
*| |RP-IMP-C4-SB        |009 |*USING PCL4_EXP_IMP                     |
*| |RP-IMP-C4-SB        |010 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-C4-SB        |011 |   CLEAR:   VERSION                     |
*| |RP-IMP-C4-SB        |012 |   CLEAR:   HEADER, BELEGE              |
*| |RP-IMP-C4-SB        |013 |   REFRESH: HEADER, BELEGE              |
*| |RP-IMP-C4-SB        |014 |   SY-SUBRC = 4                         |
*| |RP-IMP-C4-SB        |015 |ENDIF                                   |
*| |RP-IMP-CM-F0        |001 |****************************************|
*| |RP-IMP-CM-F0        |002 |* CLUSTER F0: FILLED PAY STATEMENT     *|
*| |RP-IMP-CM-F0        |003 |*             SPECIAL CLUSTER FOR      *|
*| |RP-IMP-CM-F0        |004 |*             RPCDTCX0 AND RFFOUS_C    *|
*| |RP-IMP-CM-F0        |005 |****************************************|
*| |RP-IMP-CM-F0        |006 |IMPORT XINFO                           *|
*| |RP-IMP-CM-F0        |007 |       XFORM                           *|
*| |RP-IMP-CM-F0        |008 |FROM MEMORY                            *|
*| |RP-IMP-CM-F0        |009 |ID F0-KEY                               |
*| |RP-IMP-CM-F0        |010 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-CM-F0        |011 |   CLEAR:   XINFO                       |
*| |RP-IMP-CM-F0        |012 |   CLEAR:   XFORM                       |
*| |RP-IMP-CM-F0        |013 |   REFRESH: XFORM                       |
*| |RP-IMP-CM-F0        |014 |   SY-SUBRC = 4                         |
*| |RP-IMP-CM-F0        |015 |ENDIF                                   |
*| |RP-IMP-ES-DS        |001 |****************************************|
*| |RP-IMP-ES-DS        |002 |* CLUSTER ES: AUSWERTUNGEN ABRECHN.ERG.*|
*| |RP-IMP-ES-DS        |003 |****************************************|
*| |RP-IMP-ES-DS        |004 |IMPORT ES                              *|
*| |RP-IMP-ES-DS        |005 |FROM DATASET FILE(ES)                  *|
*| |RP-IMP-ES-DS        |006 |ID KEY                                  |
*| |RP-IMP-G1           |001 |****************************************|
*| |RP-IMP-G1           |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-IMP-G1           |003 |****************************************|
*| |RP-IMP-G1           |004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-G1           |005 |       GB                              *|
*| |RP-IMP-G1           |006 |       GA                              *|
*| |RP-IMP-G1           |007 |       GE                              *|
*| |RP-IMP-G1           |008 |       GK                              *|
*| |RP-IMP-G1           |009 |       GP                              *|
*| |RP-IMP-G1           |010 |FROM DATABASE PCL1(G1)                 *|
*| |RP-IMP-G1           |011 |ID G1-KEY                               |
*| |RP-IMP-G1           |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-G1           |013 |CLEAR: OG1-VERSION, GB, GA, GP, GE, GK  |
*| |RP-IMP-G1           |014 |REFRESH: GA, GP, GE, GK                 |
*| |RP-IMP-G1           |015 |SY-SUBRC = 4                            |
*| |RP-IMP-G1           |016 |ENDIF                                   |
*| |RP-IMP-G1-DS        |001 |****************************************|
*| |RP-IMP-G1-DS        |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-IMP-G1-DS        |003 |****************************************|
*| |RP-IMP-G1-DS        |004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-G1-DS        |005 |       GB                              *|
*| |RP-IMP-G1-DS        |006 |       GA                              *|
*| |RP-IMP-G1-DS        |007 |       GE                              *|
*| |RP-IMP-G1-DS        |008 |       GK                              *|
*| |RP-IMP-G1-DS        |009 |       GP                              *|
*| |RP-IMP-G1-DS        |010 |FROM DATASET FILE(G1)                  *|
*| |RP-IMP-G1-DS        |011 |ID KEY                                  |
*| |RP-IMP-G1-DS        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-G1-DS        |013 |CLEAR: OG1-VERSION, GB, GA, GP, GE, GK  |
*| |RP-IMP-G1-DS        |014 |REFRESH: GA, GP, GE, GK                 |
*| |RP-IMP-G1-DS        |015 |SY-SUBRC = 4                            |
*| |RP-IMP-G1-DS        |016 |ENDIF                                   |
*| |RP-IMP-G1GB         |001 |****************************************|
*| |RP-IMP-G1GB         |002 |* CLUSTER G1: GRUPPEN_LEISTUNGSLOHN    *|
*| |RP-IMP-G1GB         |003 |****************************************|
*| |RP-IMP-G1GB         |004 |IMPORT G1-VERSION TO OG1-VERSION       *|
*| |RP-IMP-G1GB         |005 |       GB                              *|
*| |RP-IMP-G1GB         |006 |FROM DATABASE PCL1(G1)                 *|
*| |RP-IMP-G1GB         |007 |ID G1-KEY                               |
*| |RP-IMP-G1GB         |008 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-G1GB         |009 |CLEAR: OG1-VERSION, GB                  |
*| |RP-IMP-G1GB         |010 |SY-SUBRC = 4                            |
*| |RP-IMP-G1GB         |011 |ENDIF                                   |
*| |RP-IMP-L1           |001 |****************************************|
*| |RP-IMP-L1           |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-L1           |003 |****************************************|
*| |RP-IMP-L1           |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-L1           |005 |       PB                              *|
*| |RP-IMP-L1           |006 |       LE                              *|
*| |RP-IMP-L1           |007 |       PE                              *|
*| |RP-IMP-L1           |008 |       LK                              *|
*| |RP-IMP-L1           |009 |       GT                              *|
*| |RP-IMP-L1           |010 |FROM DATABASE PCL1(L1)                 *|
*| |RP-IMP-L1           |011 |ID L1-KEY                               |
*| |RP-IMP-L1           |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-L1           |013 |CLEAR: LE, PB, PE, LK, GT, OL1-VERSION  |
*| |RP-IMP-L1           |014 |REFRESH: LE, PE, LK, GT                 |
*| |RP-IMP-L1           |015 |SY-SUBRC = 4                            |
*| |RP-IMP-L1           |016 |ENDIF                                   |
*| |RP-IMP-L1-DS        |001 |****************************************|
*| |RP-IMP-L1-DS        |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-L1-DS        |003 |****************************************|
*| |RP-IMP-L1-DS        |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-L1-DS        |005 |       PB                              *|
*| |RP-IMP-L1-DS        |006 |       LE                              *|
*| |RP-IMP-L1-DS        |007 |       PE                              *|
*| |RP-IMP-L1-DS        |008 |       LK                              *|
*| |RP-IMP-L1-DS        |009 |       GT                              *|
*| |RP-IMP-L1-DS        |010 |FROM DATASET FILE(L1)                  *|
*| |RP-IMP-L1-DS        |011 |ID KEY                                  |
*| |RP-IMP-L1-DS        |012 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-L1-DS        |013 |CLEAR: OL1-VERSION, LE, PE, LK, GT, PB  |
*| |RP-IMP-L1-DS        |014 |REFRESH: LE, PE, LK, GT                 |
*| |RP-IMP-L1-DS        |015 |SY-SUBRC = 4                            |
*| |RP-IMP-L1-DS        |016 |ENDIF.                                  |
*| |RP-IMP-L1LE         |001 |****************************************|
*| |RP-IMP-L1LE         |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-L1LE         |003 |****************************************|
*| |RP-IMP-L1LE         |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-L1LE         |005 |       LE                              *|
*| |RP-IMP-L1LE         |006 |FROM DATABASE PCL1(L1)                 *|
*| |RP-IMP-L1LE         |007 |ID L1-KEY                               |
*| |RP-IMP-L1LE         |008 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-L1LE         |009 |CLEAR: OL1-VERSION, LE                  |
*| |RP-IMP-L1LE         |010 |REFRESH LE                              |
*| |RP-IMP-L1LE         |011 |SY-SUBRC = 4                            |
*| |RP-IMP-L1LE         |012 |ENDIF                                   |
*| |RP-IMP-L1LE-PP      |001 |****************************************|
*| |RP-IMP-L1LE-PP      |002 |* CLUSTER L1: EINZEL-LEISTUNGSLOHN     *|
*| |RP-IMP-L1LE-PP      |003 |****************************************|
*| |RP-IMP-L1LE-PP      |004 |IMPORT L1-VERSION TO OL1-VERSION       *|
*| |RP-IMP-L1LE-PP      |005 |       LE                              *|
*| |RP-IMP-L1LE-PP      |006 |FROM DATABASE PCL1(L1)                 *|
*| |RP-IMP-L1LE-PP      |007 |ID L1-KEY USING PCL1_EXP_IMP            |
*| |RP-IMP-L1LE-PP      |008 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-L1LE-PP      |009 |CLEAR: OL1-VERSION, LE                  |
*| |RP-IMP-L1LE-PP      |010 |REFRESH LE                              |
*| |RP-IMP-L1LE-PP      |011 |SY-SUBRC = 4                            |
*| |RP-IMP-L1LE-PP      |012 |ENDIF                                   |
*| |RP-IMP-PA           |001 |****************************************|
*| |RP-IMP-PA           |002 |* RESERVED FOR CLUSTER PA              *|
*| |RP-IMP-PA           |003 |* PERSONEL CALENDAR (FOR AUSTRIA)      *|
*| |RP-IMP-PA           |004 |****************************************|
*| |RP-IMP-PA           |005 |* SEE ALSO                             *|
*| |RP-IMP-PA           |006 |* RP-IMP-PCA                           *|
*| |RP-IMP-PA           |007 |****************************************|
*| |RP-IMP-RA-DS        |001 |****************************************|
*| |RP-IMP-RA-DS        |002 |* CLUSTER RG: ABR.ERG. (A), ALLE DATEN *|
*| |RP-IMP-RA-DS        |003 |****************************************|
*| |RP-IMP-RA-DS        |004 |IMPORT RG-VERSION TO ORG-VERSION       *|
*| |RP-IMP-RA-DS        |005 |       NAME                            *|
*| |RP-IMP-RA-DS        |006 |       ADR                             *|
*| |RP-IMP-RA-DS        |007 |       AP                              *|
*| |RP-IMP-RA-DS        |008 |       BB                              *|
*| |RP-IMP-RA-DS        |009 |       ABW                             *|
*| |RP-IMP-RA-DS        |010 |       ST                              *|
*| |RP-IMP-RA-DS        |011 |       SV                              *|
*| |RP-IMP-RA-DS        |012 |       ET                              *|
*| |RP-IMP-RA-DS        |013 |       KET                             *|
*| |RP-IMP-RA-DS        |014 |       UW                              *|
*| |RP-IMP-RA-DS        |015 |       K0                              *|
*| |RP-IMP-RA-DS        |016 |       K1                              *|
*| |RP-IMP-RA-DS        |017 |       K2                              *|
*| |RP-IMP-RA-DS        |018 |       URLP                            *|
*| |RP-IMP-RA-DS        |019 |       VT                              *|
*| |RP-IMP-RA-DS        |020 |       BN                              *|
*| |RP-IMP-RA-DS        |021 |       DFT                             *|
*| |RP-IMP-RA-DS        |022 |       KDFT                            *|
*| |RP-IMP-RA-DS        |023 |       BET                             *|
*| |RP-IMP-RA-DS        |024 |       LS                              *|
*| |RP-IMP-RA-DS        |025 |FROM DATASET FILE(RG)                  *|
*| |RP-IMP-RA-DS        |026 |ID KEY                                  |
*| |RP-IMP-RC-DS        |001 |****************************************|
*| |RP-IMP-RC-DS        |002 |* CLUSTER RG: ABR.ERG. (C), ALLE DATEN *|
*| |RP-IMP-RC-DS        |003 |****************************************|
*| |RP-IMP-RC-DS        |004 |IMPORT RG-VERSION TO ORG-VERSION       *|
*| |RP-IMP-RC-DS        |005 |       NAME                            *|
*| |RP-IMP-RC-DS        |006 |       ADR                             *|
*| |RP-IMP-RC-DS        |007 |       AP                              *|
*| |RP-IMP-RC-DS        |008 |       BB                              *|
*| |RP-IMP-RC-DS        |009 |       ABW                             *|
*| |RP-IMP-RC-DS        |010 |       ST                              *|
*| |RP-IMP-RC-DS        |011 |       SV                              *|
*| |RP-IMP-RC-DS        |012 |       ET                              *|
*| |RP-IMP-RC-DS        |013 |       KET                             *|
*| |RP-IMP-RC-DS        |014 |       UW                              *|
*| |RP-IMP-RC-DS        |015 |       K0                              *|
*| |RP-IMP-RC-DS        |016 |       K1                              *|
*| |RP-IMP-RC-DS        |017 |       K2                              *|
*| |RP-IMP-RC-DS        |018 |       URLP                            *|
*| |RP-IMP-RC-DS        |019 |       VT                              *|
*| |RP-IMP-RC-DS        |020 |       BN                              *|
*| |RP-IMP-RC-DS        |021 |       DFT                             *|
*| |RP-IMP-RC-DS        |022 |       KDFT                            *|
*| |RP-IMP-RC-DS        |023 |       BET                             *|
*| |RP-IMP-RC-DS        |024 |       LS                              *|
*| |RP-IMP-RC-DS        |025 |FROM DATASET FILE(RG)                  *|
*| |RP-IMP-RC-DS        |026 |ID KEY                                  |
*| |RP-IMP-RC-DS        |050 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-RC-DS        |054 |  CLEAR:   ORG-VERSION                  |
*| |RP-IMP-RC-DS        |055 |  CLEAR:   NAME                         |
*| |RP-IMP-RC-DS        |056 |  CLEAR:   ADR                          |
*| |RP-IMP-RC-DS        |057 |  REFRESH: AP                           |
*| |RP-IMP-RC-DS        |058 |  REFRESH: BB                           |
*| |RP-IMP-RC-DS        |059 |  REFRESH: ABW                          |
*| |RP-IMP-RC-DS        |060 |  REFRESH: ST                           |
*| |RP-IMP-RC-DS        |061 |  REFRESH: SV                           |
*| |RP-IMP-RC-DS        |062 |  REFRESH: ET                           |
*| |RP-IMP-RC-DS        |063 |  REFRESH: KET                          |
*| |RP-IMP-RC-DS        |064 |  REFRESH: UW                           |
*| |RP-IMP-RC-DS        |065 |  REFRESH: K0                           |
*| |RP-IMP-RC-DS        |066 |  REFRESH: K1                           |
*| |RP-IMP-RC-DS        |067 |  REFRESH: K2                           |
*| |RP-IMP-RC-DS        |068 |  REFRESH: URLP                         |
*| |RP-IMP-RC-DS        |069 |  REFRESH: VT                           |
*| |RP-IMP-RC-DS        |070 |  CLEAR:   BN                           |
*| |RP-IMP-RC-DS        |071 |  REFRESH: DFT                          |
*| |RP-IMP-RC-DS        |072 |  REFRESH: KDFT                         |
*| |RP-IMP-RC-DS        |073 |  REFRESH: BET                          |
*| |RP-IMP-RC-DS        |074 |  REFRESH: LS                           |
*| |RP-IMP-RC-DS        |080 |  SY-SUBRC = 4                          |
*| |RP-IMP-RC-DS        |081 |ENDIF                                   |
*| |RP-IMP-RD-DS        |001 |****************************************|
*| |RP-IMP-RD-DS        |002 |* CLUSTER RG: ABR.ERG. (D), ALLE DATEN *|
*| |RP-IMP-RD-DS        |003 |****************************************|
*| |RP-IMP-RD-DS        |004 |IMPORT RG-VERSION TO ORG-VERSION       *|
*| |RP-IMP-RD-DS        |005 |       NAME                            *|
*| |RP-IMP-RD-DS        |006 |       ADR                             *|
*| |RP-IMP-RD-DS        |007 |       AP                              *|
*| |RP-IMP-RD-DS        |008 |       BB                              *|
*| |RP-IMP-RD-DS        |009 |       ABW                             *|
*| |RP-IMP-RD-DS        |010 |       ST                              *|
*| |RP-IMP-RD-DS        |011 |       SV                              *|
*| |RP-IMP-RD-DS        |012 |       ET                              *|
*| |RP-IMP-RD-DS        |013 |       KET                             *|
*| |RP-IMP-RD-DS        |014 |       UW                              *|
*| |RP-IMP-RD-DS        |015 |       DUVOS                           *|
*| |RP-IMP-RD-DS        |016 |       DUVOT                           *|
*| |RP-IMP-RD-DS        |017 |       K0                              *|
*| |RP-IMP-RD-DS        |018 |       K1                              *|
*| |RP-IMP-RD-DS        |019 |       K2                              *|
*| |RP-IMP-RD-DS        |020 |       SKETD                           *|
*| |RP-IMP-RD-DS        |021 |       URLP                            *|
*| |RP-IMP-RD-DS        |022 |       VT                              *|
*| |RP-IMP-RD-DS        |023 |       KUG                             *|
*| |RP-IMP-RD-DS        |024 |       BN                              *|
*| |RP-IMP-RD-DS        |025 |       DFT                             *|
*| |RP-IMP-RD-DS        |026 |       KDFT                            *|
*| |RP-IMP-RD-DS        |027 |       BET                             *|
*| |RP-IMP-RD-DS        |028 |       LS                              *|
*| |RP-IMP-RD-DS        |029 |       STATUS                          *|
*| |RP-IMP-RD-DS        |030 |       XIT                             *|
*| |RP-IMP-RD-DS        |031 |       VBL                             *|
*| |RP-IMP-RD-DS        |032 |FROM DATASET FILE(RG)                  *|
*| |RP-IMP-RD-DS        |033 |ID KEY                                  |
*| |RP-IMP-ST-MEM       |001 |****************************************|
*| |RP-IMP-ST-MEM       |002 |* CLUSTER ST: STATISTISCHE DATEN       *|
*| |RP-IMP-ST-MEM       |003 |****************************************|
*| |RP-IMP-ST-MEM       |004 |IMPORT STAT                            *|
*| |RP-IMP-ST-MEM       |024 |FROM MEMORY                            *|
*| |RP-IMP-ST-MEM       |025 |ID ST-KEY                               |
*| |RP-IMP-ST-MEM       |027 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-ST-MEM       |028 |  CLEAR:   ST-VERSION                   |
*| |RP-IMP-ST-MEM       |033 |  REFRESH: STAT                         |
*| |RP-IMP-ST-MEM       |049 |  SY-SUBRC = 4                          |
*| |RP-IMP-ST-MEM       |050 |ENDIF                                   |
*| |RP-IMP-TX           |001 |****************************************|
*| |RP-IMP-TX           |002 |* CLUSTER TX: TEXTE                    *|
*| |RP-IMP-TX           |003 |****************************************|
*| |RP-IMP-TX           |004 |IMPORT PKEY PTEXT                      *|
*| |RP-IMP-TX           |005 |FROM DATABASE PCL1(TX)                 *|
*| |RP-IMP-TX           |006 |ID TX-KEY                               |
*| |RP-IMP-TX           |007 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-TX           |008 |   CLEAR: PKEY                          |
*| |RP-IMP-TX           |009 |   CLEAR: PTEXT                         |
*| |RP-IMP-TX           |010 |   REFRESH: PTEXT                       |
*| |RP-IMP-TX           |011 |   SY-SUBRC = 4                         |
*| |RP-IMP-TX           |012 |ENDIF                                   |
*| |RP-IMP-TX-PKEY      |001 |****************************************|
*| |RP-IMP-TX-PKEY      |002 |* CLUSTER TX: TEXTE                    *|
*| |RP-IMP-TX-PKEY      |003 |****************************************|
*| |RP-IMP-TX-PKEY      |004 |IMPORT PKEY                            *|
*| |RP-IMP-TX-PKEY      |005 |FROM DATABASE PCL1(TX)                 *|
*| |RP-IMP-TX-PKEY      |006 |ID TX-KEY                               |
*| |RP-IMP-TX-PKEY      |007 |IF SY-SUBRC NE 0                        |
*| |RP-IMP-TX-PKEY      |008 |   CLEAR: PKEY                          |
*| |RP-IMP-TX-PKEY      |009 |   SY-SUBRC = 4                         |
*| |RP-IMP-TX-PKEY      |010 |ENDIF                                   |
*| |RP-INIT-BUFFER      |001 |****************************************|
*| |RP-INIT-BUFFER      |002 |* RP: initialisierung puffer-tabellen  *|
*| |RP-INIT-BUFFER      |003 |****************************************|
*| |RP-INIT-BUFFER      |004 |CLEAR:   BUFFER_DIR                     |
*| |RP-INIT-BUFFER      |005 |REFRESH: BUFFER_DIR                     |
*| |RP-INIT-BUFFER      |006 |CLEAR:   TBUFF                          |
*| |RP-INIT-BUFFER      |007 |REFRESH: TBUFF                          |
*| |RP-INIT-BUFFER      |008 |CLEAR:   BEFORE_IMAGE_PCLX              |
*| |RP-INIT-BUFFER      |009 |REFRESH: BEFORE_IMAGE_PCLX              |
*| |RP-INIT-BUFFER      |010 |CLEAR:   DEL_PCLX_TAB                   |
*| |RP-INIT-BUFFER      |011 |REFRESH: DEL_PCLX_TAB                   |
*| |RP-INIT-BUFFER      |012 |CLEAR: PAYR_BUFFER                      |
*| |RP-INIT-BUFFER      |013 |REFRESH: PAYR_BUFFER                    |
*| |RP-INIT-WITH-SYDATUM|001 |****************************************|
*| |RP-INIT-WITH-SYDATUM|002 |* SY-DATUM als Stichtag vorschlagen    *|
*| |RP-INIT-WITH-SYDATUM|003 |* zu INITIALIZATION                    *|
*| |RP-INIT-WITH-SYDATUM|004 |****************************************|
*| |RP-INIT-WITH-SYDATUM|005 |PNPBEGDA = SY-DATUM                     |
*| |RP-INIT-WITH-SYDATUM|006 |PNPBEGPS = SY-DATUM                     |
*| |RP-KALJAHR          |001 |****************************************|
*| |RP-KALJAHR          |002 |* RP: STICHTAGS-DATUM IN 2TE ZEILE     *|
*| |RP-KALJAHR          |003 |****************************************|
*| |RP-KALJAHR          |004 |DATA NEXT-LINE-ST LIKE SY-LINNO         |
*| |RP-KALJAHR          |005 |DATA LINS(2) TYPE P                     |
*| |RP-KALJAHR          |006 |LINS = SY-LINSZ                         |
*| |RP-KALJAHR          |007 |LINS = LINS / 2                         |
*| |RP-KALJAHR          |008 |LINS = LINS - 9                         |
*| |RP-KALJAHR          |009 |NEXT-LINE-ST = SY-LINNO                 |
*| |RP-KALJAHR          |010 |SKIP TO LINE 2                          |
*| |RP-KALJAHR          |011 |POSITION LINS                           |
*| |RP-KALJAHR          |012 |WRITE (19) &1                           |
*| |RP-KALJAHR          |013 |LINS = LINS + 14                        |
*| |RP-KALJAHR          |014 |POSITION LINS                           |
*| |RP-KALJAHR          |015 |WRITE PN-BEGDA+0(4)                     |
*| |RP-KALJAHR          |016 |SKIP TO LINE NEXT-LINE-ST               |
*| |RP-LOW-HIGH         |001 |****************************************|
*| |RP-LOW-HIGH         |002 |* RP: LOW_DATE, HIGH_DATE DEFINITION    |
*| |RP-LOW-HIGH         |003 |****************************************|
*| |RP-LOW-HIGH         |004 |DATA LOW_DATE  TYPE D VALUE '18000101'  |
*| |RP-LOW-HIGH         |005 |DATA HIGH_DATE TYPE D VALUE '99991231'  |
*| |RP-LOWDATE-HIGHDATE |001 |****************************************|
*| |RP-LOWDATE-HIGHDATE |002 |* RP: LOW-DATE, HIGH-DATE DEFINITION    |
*| |RP-LOWDATE-HIGHDATE |003 |****************************************|
*| |RP-LOWDATE-HIGHDATE |004 |DATA LOW-DATE  TYPE D VALUE '18000101'  |
*| |RP-LOWDATE-HIGHDATE |005 |DATA HIGH-DATE TYPE D VALUE '99991231'  |
*| |RP-LSTRTAB          |001 |****************************************|
*| |RP-LSTRTAB          |002 |* RP: AUFBAU DER LOHNSTEUER-TABELLE    *|
*| |RP-LSTRTAB          |003 |****************************************|
*| |RP-LSTRTAB          |010 |DATA BEGIN OF STEU OCCURS 500           |
*| |RP-LSTRTAB          |020 |DATA ABR-DATUM TYPE 2                   |
*| |RP-LSTRTAB          |025 |DATA GBDAT                              |
*| |RP-LSTRTAB          |035 |DATA STRKL                              |
*| |RP-LSTRTAB          |040 |DATA ANZKD                              |
*| |RP-LSTRTAB          |050 |DATA BRUTTO  TYPE P DECIMALS 2          |
*| |RP-LSTRTAB          |051 |DATA VERSBZ  TYPE P DECIMALS 2          |
*| |RP-LSTRTAB          |052 |DATA ANFREI  TYPE P DECIMALS 2          |
*| |RP-LSTRTAB          |055 |*-------------------------------------- |
*| |RP-LSTRTAB          |060 |DATA STEUER  TYPE P DECIMALS 2          |
*| |RP-LSTRTAB          |070 |DATA NETTO   TYPE P DECIMALS 2          |
*| |RP-LSTRTAB          |099 |DATA END OF STEU                        |
*| |RP-LSTRTAB          |200 |*-------------------------------------- |
*| |RP-LSTRTAB          |201 |*  ABRECHNUNGSDATUM := CPU-DATUM IN     |
*| |RP-LSTRTAB          |202 |*  JJMMTT-FORM BRINGEN                  |
*| |RP-LSTRTAB          |204 |*-------------------------------------- |
*| |RP-LSTRTAB          |210 |MOVE DATE+7(2) TO STEU-ABR-DATUM        |
*| |RP-LSTRTAB          |211 |MOVE DATE+4(2) TO STEU-ABR-DATUM+2      |
*| |RP-LSTRTAB          |212 |MOVE DATE(2) TO STEU-ABR-DATUM+4        |
*| |RP-MAKE-ADDRESS     |001 |****************************************|
*| |RP-MAKE-ADDRESS     |002 |****************************************|
*| |RP-MAKE-ADDRESS     |003 |* PARAMETER IN:  P0001 (ORG. ZUORDNUNG)*|
*| |RP-MAKE-ADDRESS     |004 |*                P0002 (DATEN ZUR PERS)*|
*| |RP-MAKE-ADDRESS     |005 |*                P0006 (ANSCHRIFTEN)   *|
*| |RP-MAKE-ADDRESS     |006 |*                EDIT-NAME             *|
*| |RP-MAKE-ADDRESS     |007 |*                Zeilen-Anzahl         *|
*| |RP-MAKE-ADDRESS     |008 |* PARAMETER OUT: ADRS LIKE ADRS        *|
*| |RP-MAKE-ADDRESS     |009 |****************************************|
*| |RP-MAKE-ADDRESS     |010 |call function 'HR_MAKE_ADDRESS'        *|
*| |RP-MAKE-ADDRESS     |011 |     exporting                         *|
*| |RP-MAKE-ADDRESS     |012 |         pp0001     = &1               *|
*| |RP-MAKE-ADDRESS     |013 |         pp0002     = &2               *|
*| |RP-MAKE-ADDRESS     |014 |         pp0006     = &3               *|
*| |RP-MAKE-ADDRESS     |015 |         edit_name  = &4               *|
*| |RP-MAKE-ADDRESS     |016 |         line_count = &5               *|
*| |RP-MAKE-ADDRESS     |017 |     importing                         *|
*| |RP-MAKE-ADDRESS     |018 |         adrs       = adrs             *|
*| |RP-MAKE-ADDRESS     |019 |     exceptions                        *|
*| |RP-MAKE-ADDRESS     |020 |         others     = 1.                |
*| |RP-MINUS-EDIT-DEF-J |001 |DATA: $$L(2) TYPE N NON-LOCAL.          |
*| |RP-MINUS-EDIT-J     |001 |****************************************|
*| |RP-MINUS-EDIT-J     |002 |* Move Minus sing front for Japan      *|
*| |RP-MINUS-EDIT-J     |003 |****************************************|
*| |RP-MINUS-EDIT-J     |004 |MOVE &1 TO &2.                          |
*| |RP-MINUS-EDIT-J     |005 |SHIFT &2 CIRCULAR  RIGHT.               |
*| |RP-MINUS-EDIT-J     |006 |$$L = STRLEN( &2 ).                     |
*| |RP-MINUS-EDIT-J     |007 |CONDENSE &2 NO-GAPS.                    |
*| |RP-MINUS-EDIT-J     |008 |$$L = $$L - STRLEN( &2 ).               |
*| |RP-MINUS-EDIT-J     |009 |SHIFT &2 CIRCULAR RIGHT BY $$L PLACES.  |
*| |RP-NEG-POS          |001 |****************************************|
*| |RP-NEG-POS          |002 |* Entscheidung ob negativ- oder positiv*|
*| |RP-NEG-POS          |003 |* '0'=negativ, '1'=positiv zeitart 0050*|
*| |RP-NEG-POS          |004 |****************************************|
*| |RP-NEG-POS          |005 |DATA: RP_NEG_POS VALUE '0'              |
*| |RP-NEG-POS          |006 |DATA: RP_ZTART(4) VALUE '0050'          |
*| |RP-NEG-POS          |007 |****************************************|
*| |RP-PROVIDE-FROM-FRST|001 |****************************************|
*| |RP-PROVIDE-FROM-FRST|002 |* RP-PROVIDE-FRST INFTY SUBTY BEG END  *|
*| |RP-PROVIDE-FROM-FRST|003 |****************************************|
*| |RP-PROVIDE-FROM-FRST|004 |* SORT &1                               |
*| |RP-PROVIDE-FROM-FRST|005 |PNP-SW-FOUND = '0'                      |
*| |RP-PROVIDE-FROM-FRST|006 |LOOP AT &1                              |
*| |RP-PROVIDE-FROM-FRST|007 |  IF &2 NE SPACE                        |
*| |RP-PROVIDE-FROM-FRST|008 |    CHECK &1-SUBTY EQ &2                |
*| |RP-PROVIDE-FROM-FRST|009 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-FRST|010 |  IF &1-BEGDA LE &4 AND &1-ENDDA GE &3  |
*| |RP-PROVIDE-FROM-FRST|011 |    PNP-SW-FOUND = '1'                  |
*| |RP-PROVIDE-FROM-FRST|012 |    EXIT                                |
*| |RP-PROVIDE-FROM-FRST|013 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-FRST|014 |ENDLOOP                                 |
*| |RP-PROVIDE-FROM-FRST|015 |IF PNP-SW-FOUND EQ '0'                  |
*| |RP-PROVIDE-FROM-FRST|016 |  CLEAR &1                              |
*| |RP-PROVIDE-FROM-FRST|017 |ENDIF                                   |
*| |RP-PROVIDE-FROM-LAST|001 |****************************************|
*| |RP-PROVIDE-FROM-LAST|002 |* RP-PROVIDE-LAST INFTY SUBTY BEG END  *|
*| |RP-PROVIDE-FROM-LAST|003 |****************************************|
*| |RP-PROVIDE-FROM-LAST|004 |* SORT &1                               |
*| |RP-PROVIDE-FROM-LAST|005 |PNP-SW-FOUND = '0'                      |
*| |RP-PROVIDE-FROM-LAST|006 |CLEAR PNP-SY-TABIX                      |
*| |RP-PROVIDE-FROM-LAST|007 |LOOP AT &1                              |
*| |RP-PROVIDE-FROM-LAST|008 |  IF &2 NE SPACE                        |
*| |RP-PROVIDE-FROM-LAST|009 |    CHECK &1-SUBTY EQ &2                |
*| |RP-PROVIDE-FROM-LAST|010 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-LAST|011 |  IF &1-BEGDA LE &4 AND &1-ENDDA GE &4  |
*| |RP-PROVIDE-FROM-LAST|012 |    PNP-SW-FOUND = '1'                  |
*| |RP-PROVIDE-FROM-LAST|013 |    EXIT                                |
*| |RP-PROVIDE-FROM-LAST|014 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-LAST|015 |  IF &1-BEGDA LE &4 AND &1-ENDDA GE &3  |
*| |RP-PROVIDE-FROM-LAST|016 |    PNP-SY-TABIX = SY-TABIX             |
*| |RP-PROVIDE-FROM-LAST|017 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-LAST|018 |ENDLOOP                                 |
*| |RP-PROVIDE-FROM-LAST|019 |IF PNP-SW-FOUND EQ '0'                  |
*| |RP-PROVIDE-FROM-LAST|020 |  IF PNP-SY-TABIX NE 0                  |
*| |RP-PROVIDE-FROM-LAST|021 |    PNP-SW-FOUND = '1'                  |
*| |RP-PROVIDE-FROM-LAST|022 |    READ TABLE &1 INDEX PNP-SY-TABIX    |
*| |RP-PROVIDE-FROM-LAST|023 |  ELSE                                  |
*| |RP-PROVIDE-FROM-LAST|024 |    CLEAR &1                            |
*| |RP-PROVIDE-FROM-LAST|025 |  ENDIF                                 |
*| |RP-PROVIDE-FROM-LAST|026 |ENDIF                                   |
*| |RP-READ-ALL-TIME-ITY|001 |****************************************|
*| |RP-READ-ALL-TIME-ITY|002 |* RP-READ-ALL-TIME-ITY                 *|
*| |RP-READ-ALL-TIME-ITY|003 |* READ ALL INFOTYPES BETWEEN 2000-2999 *|
*| |RP-READ-ALL-TIME-ITY|004 |* INTO ITS CORRESPONDING INFOTYPETABLE *|
*| |RP-READ-ALL-TIME-ITY|005 |****************************************|
*| |RP-READ-ALL-TIME-ITY|006 |* PARAMETERS:                          *|
*| |RP-READ-ALL-TIME-ITY|007 |*   BEGDA      REQUESTED INTERVAL-BEGIN*|
*| |RP-READ-ALL-TIME-ITY|008 |*   ENDDA      REQUESTED INTERVAL-END  *|
*| |RP-READ-ALL-TIME-ITY|009 |****************************************|
*| |RP-READ-ALL-TIME-ITY|010 |*   PERNR-PERNR IS USED IMPLICITLY     *|
*| |RP-READ-ALL-TIME-ITY|011 |****************************************|
*| |RP-READ-ALL-TIME-ITY|012 |*SET DEBUGGING INTERRUPT ON            *|
*| |RP-READ-ALL-TIME-ITY|013 |PERFORM                                *|
*| |RP-READ-ALL-TIME-ITY|014 |FILL-ALL-TIME-INFOTYPE-TABLES(SAPDBPNP)*|
*| |RP-READ-ALL-TIME-ITY|015 |         USING  &1 &2                   |
*| |RP-READ-ALL-TIME-ITY|016 |*SET DEBUGGING INTERRUPT OFF           *|
*| |RP-READ-INFOTYPE    |001 |****************************************|
*| |RP-READ-INFOTYPE    |002 |* RP-READ-INFOTYPE                     *|
*| |RP-READ-INFOTYPE    |003 |****************************************|
*| |RP-READ-INFOTYPE    |004 |* PARAMETERS:                          *|
*| |RP-READ-INFOTYPE    |005 |*   PERNR      REQUESTED PERSONALNUMBER*|
*| |RP-READ-INFOTYPE    |006 |*   INFTY      REQUESTED INFOTYPNUMBER *|
*| |RP-READ-INFOTYPE    |007 |*   INFTY-TABLE OUTPUT-TABLE LIKE PNNNN*|
*| |RP-READ-INFOTYPE    |008 |*   BEGDA      REQUESTED INTERVAL-BEGIN*|
*| |RP-READ-INFOTYPE    |009 |*   ENDDA      REQUESTED INTERVAL-END  *|
*| |RP-READ-INFOTYPE    |010 |****************************************|
*| |RP-READ-INFOTYPE    |011 |*SET DEBUGGING INTERRUPT ON            *|
*| |RP-READ-INFOTYPE    |012 |PERFORM READ-INFOTYPE(SAPDBPNP)        *|
*| |RP-READ-INFOTYPE    |013 |        TABLES &3                      *|
*| |RP-READ-INFOTYPE    |014 |        USING  &1 '&2' &4 &5            |
*| |RP-READ-INFOTYPE    |015 |*SET DEBUGGING INTERRUPT OFF           *|
*| |RP-READ-PAYROLL-DI9 |001 |****************************************|
*| |RP-READ-PAYROLL-DI9 |002 |* READ DIRECTORY                       *|
*| |RP-READ-PAYROLL-DI9 |003 |*      OF PAYROLL-RESULT- CLUSTER      *|
*| |RP-READ-PAYROLL-DI9 |004 |* ONLY USED IN DB PNP UNDER  GET PERNR *|
*| |RP-READ-PAYROLL-DI9 |005 |****************************************|
*| |RP-READ-PAYROLL-DI9 |006 |*WE ASSUME, THAT THE FOLLOWING          |
*| |RP-READ-PAYROLL-DI9 |007 |*DATA-DESCRIPTION OF CLUSTER-DIRECTORY  |
*| |RP-READ-PAYROLL-DI9 |008 |*IS INCLUDED ON TOP OF EVERY REPORT,    |
*| |RP-READ-PAYROLL-DI9 |009 |*WHICH USE THIS FORM                    |
*| |RP-READ-PAYROLL-DI9 |010 |* INCLUDE RPCDCD09                      |
*| |RP-READ-PAYROLL-DI9 |011 |*INCLUDES SOME NEEDED FIELDS AS         |
*| |RP-READ-PAYROLL-DI9 |012 |DATA: READ-PAYROLL-DIRECTORY-PERNR     *|
*| |RP-READ-PAYROLL-DI9 |013 |                  LIKE PERNR-PERNR      |
*| |RP-READ-PAYROLL-DI9 |014 |****************************************|
*| |RP-READ-PAYROLL-DI9 |015 |*                                       |
*| |RP-READ-PAYROLL-DI9 |016 |FORM READ-PAYROLL-DIRECTORY             |
*| |RP-READ-PAYROLL-DI9 |017 |*OUTPUT: 1) RP-IMP-CD-SUBRC             |
*| |RP-READ-PAYROLL-DI9 |018 |*        2) CLUSTER CD                  |
*| |RP-READ-PAYROLL-DI9 |019 |* BUFFERED?                             |
*| |RP-READ-PAYROLL-DI9 |020 |  IF PERNR-PERNR NE                    *|
*| |RP-READ-PAYROLL-DI9 |021 |      READ-PAYROLL-DIRECTORY-PERNR      |
*| |RP-READ-PAYROLL-DI9 |022 |* EXISTANCE?                            |
*| |RP-READ-PAYROLL-DI9 |023 |    IF NOT ( P0003-ABRDT IS INITIAL )   |
*| |RP-READ-PAYROLL-DI9 |024 |      CD-KEY-PERNR = PERNR-PERNR        |
*| |RP-READ-PAYROLL-DI9 |025 |      RP-IMP-C2-CU                      |
*| |RP-READ-PAYROLL-DI9 |026 |    ELSE                                |
*| |RP-READ-PAYROLL-DI9 |027 |*SIMILARY TO REFRESH IN RP-IMP-CD       |
*| |RP-READ-PAYROLL-DI9 |028 |      REFRESH RGDIR. CLEAR RGDIR        |
*| |RP-READ-PAYROLL-DI9 |029 |      RP-IMP-CD-SUBRC = 4               |
*| |RP-READ-PAYROLL-DI9 |030 |    ENDIF                               |
*| |RP-READ-PAYROLL-DI9 |031 |    READ-PAYROLL-DIRECTORY-PERNR =     *|
*| |RP-READ-PAYROLL-DI9 |032 |                     PERNR-PERNR        |
*| |RP-READ-PAYROLL-DI9 |033 |* ELSE                                  |
*| |RP-READ-PAYROLL-DI9 |034 |*   RP-IMP-CD-SUBRC = 0                 |
*| |RP-READ-PAYROLL-DI9 |035 |  ENDIF                                 |
*| |RP-READ-PAYROLL-DI9 |036 |ENDFORM                                 |
*| |RP-READ-PAYROLL-DI9 |037 |*                                       |
*| |RP-READ-PAYROLL-DI9 |038 |FORM IN_PERIOD-IN-RGDIR                 |
*| |RP-READ-PAYROLL-DI9 |039 |*OUTPUT: 1) RP-IMP-CD-SUBRC             |
*| |RP-READ-PAYROLL-DI9 |040 |*        2) CLUSTER CD                  |
*| |RP-READ-PAYROLL-DI9 |041 |*        3) PNP-SW-FOUND                |
*| |RP-READ-PAYROLL-DI9 |042 |*        4) RP-SEL-CALC-RRDAT           |
*| |RP-READ-PAYROLL-DI9 |043 |  PNP-SW-FOUND = '0'                    |
*| |RP-READ-PAYROLL-DI9 |044 |  PERFORM READ-PAYROLL-DIRECTORY        |
*| |RP-READ-PAYROLL-DI9 |045 |  IF RP-IMP-CD-SUBRC EQ 0               |
*| |RP-READ-PAYROLL-DI9 |046 |*   SORT RGDIR BY SEQNO                 |
*| |RP-READ-PAYROLL-DI9 |047 |    CLEAR RP-SEL-CALC-RRDAT             |
*| |RP-READ-PAYROLL-DI9 |048 |    LOOP AT RGDIR                      *|
*| |RP-READ-PAYROLL-DI9 |049 |         WHERE IPERM EQ PN-PERMO       *|
*| |RP-READ-PAYROLL-DI9 |050 |           AND INPER EQ PN-PAPER        |
*| |RP-READ-PAYROLL-DI9 |051 |      PNP-SW-FOUND = '1'                |
*| |RP-READ-PAYROLL-DI9 |052 |      IF RP-SEL-CALC-RRDAT IS INITIAL   |
*| |RP-READ-PAYROLL-DI9 |053 |        RP-SEL-CALC-RRDAT = RGDIR-FPBEG |
*| |RP-READ-PAYROLL-DI9 |054 |      ELSE.                             |
*| |RP-READ-PAYROLL-DI9 |055 |        IF RP-SEL-CALC-RRDAT GT        *|
*| |RP-READ-PAYROLL-DI9 |056 |           RGDIR-FPBEG                  |
*| |RP-READ-PAYROLL-DI9 |057 |          RP-SEL-CALC-RRDAT =          *|
*| |RP-READ-PAYROLL-DI9 |058 |             RGDIR-FPBEG                |
*| |RP-READ-PAYROLL-DI9 |059 |        ENDIF                           |
*| |RP-READ-PAYROLL-DI9 |060 |      ENDIF                             |
*| |RP-READ-PAYROLL-DI9 |061 |    ENDLOOP                             |
*| |RP-READ-PAYROLL-DI9 |062 |* ELSE                                  |
*| |RP-READ-PAYROLL-DI9 |063 |*   ERROR                               |
*| |RP-READ-PAYROLL-DI9 |064 |  ENDIF.                                |
*| |RP-READ-PAYROLL-DI9 |065 |ENDFORM                                 |
*| |RP-READ-PAYROLL-DIR |001 |****************************************|
*| |RP-READ-PAYROLL-DIR |002 |* READ DIRECTORY                       *|
*| |RP-READ-PAYROLL-DIR |003 |*      OF PAYROLL-RESULT- CLUSTER      *|
*| |RP-READ-PAYROLL-DIR |004 |* ONLY USED IN DB PNP UNDER  GET PERNR *|
*| |RP-READ-PAYROLL-DIR |005 |****************************************|
*| |RP-READ-PAYROLL-DIR |006 |*WE ASSUME, THAT THE FOLLOWING          |
*| |RP-READ-PAYROLL-DIR |007 |*DATA-DESCRIPTION OF CLUSTER-DIRECTORY  |
*| |RP-READ-PAYROLL-DIR |008 |*IS INCLUDED ON TOP OF EVERY REPORT,    |
*| |RP-READ-PAYROLL-DIR |009 |*WHICH USE THIS FORM                    |
*| |RP-READ-PAYROLL-DIR |010 |* INCLUDE RPCDCD00                      |
*| |RP-READ-PAYROLL-DIR |011 |*INCLUDES SOME NEEDED FIELDS AS         |
*| |RP-READ-PAYROLL-DIR |012 |DATA: READ-PAYROLL-DIRECTORY-PERNR     *|
*| |RP-READ-PAYROLL-DIR |013 |                  LIKE PERNR-PERNR      |
*| |RP-READ-PAYROLL-DIR |014 |****************************************|
*| |RP-READ-PAYROLL-DIR |015 |*                                      *|
*| |RP-READ-PAYROLL-DIR |016 |FORM READ-PAYROLL-DIRECTORY             |
*| |RP-READ-PAYROLL-DIR |017 |*OUTPUT: 1) RP-IMP-CD-SUBRC             |
*| |RP-READ-PAYROLL-DIR |018 |*        2) CLUSTER CD                  |
*| |RP-READ-PAYROLL-DIR |019 |* BUFFERED?                             |
*| |RP-READ-PAYROLL-DIR |020 |  IF PERNR-PERNR NE                    *|
*| |RP-READ-PAYROLL-DIR |021 |      READ-PAYROLL-DIRECTORY-PERNR      |
*| |RP-READ-PAYROLL-DIR |022 |* EXISTANCE?                            |
*| |RP-READ-PAYROLL-DIR |023 |    READ TABLE P0003 INDEX 1            |
*| |RP-READ-PAYROLL-DIR |024 |    IF NOT ( P0003-ABRDT IS INITIAL )   |
*| |RP-READ-PAYROLL-DIR |025 |      CD-KEY-PERNR = PERNR-PERNR        |
*| |RP-READ-PAYROLL-DIR |026 |      RP-IMP-C2-CD                      |
*| |RP-READ-PAYROLL-DIR |027 |    ELSE                                |
*| |RP-READ-PAYROLL-DIR |028 |*SIMILARY TO REFRESH IN RP-IMP-CD       |
*| |RP-READ-PAYROLL-DIR |029 |      REFRESH RGDIR. CLEAR RGDIR        |
*| |RP-READ-PAYROLL-DIR |030 |      RP-IMP-CD-SUBRC = 4               |
*| |RP-READ-PAYROLL-DIR |031 |    ENDIF                               |
*| |RP-READ-PAYROLL-DIR |032 |    READ-PAYROLL-DIRECTORY-PERNR =     *|
*| |RP-READ-PAYROLL-DIR |033 |                     PERNR-PERNR        |
*| |RP-READ-PAYROLL-DIR |034 |* ELSE                                  |
*| |RP-READ-PAYROLL-DIR |035 |*   RP-IMP-CD-SUBRC = 0                 |
*| |RP-READ-PAYROLL-DIR |036 |  ENDIF                                 |
*| |RP-READ-PAYROLL-DIR |037 |ENDFORM                                 |
*| |RP-READ-PAYROLL-DIR |038 |*                                       |
*| |RP-READ-PAYROLL-DIR |039 |FORM IN_PERIOD-IN-RGDIR                 |
*| |RP-READ-PAYROLL-DIR |040 |*OUTPUT: 1) RP-IMP-CD-SUBRC             |
*| |RP-READ-PAYROLL-DIR |041 |*        2) CLUSTER CD                  |
*| |RP-READ-PAYROLL-DIR |042 |*        3) PNP-SW-FOUND                |
*| |RP-READ-PAYROLL-DIR |043 |*        4) RP-SEL-CALC-RRDAT           |
*| |RP-READ-PAYROLL-DIR |044 |  PNP-SW-FOUND = '0'                    |
*| |RP-READ-PAYROLL-DIR |045 |  PERFORM READ-PAYROLL-DIRECTORY        |
*| |RP-READ-PAYROLL-DIR |046 |  IF RP-IMP-CD-SUBRC EQ 0               |
*| |RP-READ-PAYROLL-DIR |047 |*   SORT RGDIR BY SEQNO                 |
*| |RP-READ-PAYROLL-DIR |048 |    CLEAR RP-SEL-CALC-RRDAT             |
*| |RP-READ-PAYROLL-DIR |049 |    LOOP AT RGDIR                      *|
*| |RP-READ-PAYROLL-DIR |050 |         WHERE IPERM EQ PN-PERMO       *|
*| |RP-READ-PAYROLL-DIR |051 |           AND INPER EQ PN-PAPER        |
*| |RP-READ-PAYROLL-DIR |052 |      PNP-SW-FOUND = '1'                |
*| |RP-READ-PAYROLL-DIR |053 |      IF RP-SEL-CALC-RRDAT IS INITIAL   |
*| |RP-READ-PAYROLL-DIR |054 |        RP-SEL-CALC-RRDAT = RGDIR-FPBEG |
*| |RP-READ-PAYROLL-DIR |055 |      ELSE                              |
*| |RP-READ-PAYROLL-DIR |056 |        IF RP-SEL-CALC-RRDAT GT        *|
*| |RP-READ-PAYROLL-DIR |057 |           RGDIR-FPBEG                  |
*| |RP-READ-PAYROLL-DIR |058 |          RP-SEL-CALC-RRDAT =          *|
*| |RP-READ-PAYROLL-DIR |059 |             RGDIR-FPBEG                |
*| |RP-READ-PAYROLL-DIR |060 |        ENDIF                           |
*| |RP-READ-PAYROLL-DIR |061 |      ENDIF                             |
*| |RP-READ-PAYROLL-DIR |062 |    ENDLOOP                             |
*| |RP-READ-PAYROLL-DIR |063 |* ELSE                                  |
*| |RP-READ-PAYROLL-DIR |064 |*   ERROR                               |
*| |RP-READ-PAYROLL-DIR |065 |  ENDIF                                 |
*| |RP-READ-PAYROLL-DIR |066 |ENDFORM                                 |
*| |RP-READ-T001P       |001 |****************************************|
*| |RP-READ-T001P       |002 |* RP-READ-T001P                        *|
*| |RP-READ-T001P       |003 |* LESEN DER ATAB-TABELLE 001P          *|
*| |RP-READ-T001P       |004 |* PARAMETER:                           *|
*| |RP-READ-T001P       |005 |*   &1 = WERK                          *|
*| |RP-READ-T001P       |006 |*   &2 = BETRIEBSTEIL                  *|
*| |RP-READ-T001P       |007 |*   &3 = REAKTION BEI SY-SUBRC NE 0    *|
*| |RP-READ-T001P       |008 |*        X = ABBRUCH MIT MESSAGE       *|
*| |RP-READ-T001P       |009 |*    SPACE = WEITERGABE VON SY-SUBRC,  *|
*| |RP-READ-T001P       |010 |*            UND T001P CLEARED         *|
*| |RP-READ-T001P       |011 |****************************************|
*| |RP-READ-T001P       |012 | IF    T001P-WERKS NE &1 OR            *|
*| |RP-READ-T001P       |013 |       T001P-BTRTL NE &2                |
*| |RP-READ-T001P       |014 |   SELECT SINGLE * FROM T001P          *|
*| |RP-READ-T001P       |015 |          WHERE WERKS EQ &1            *|
*| |RP-READ-T001P       |016 |          AND   BTRTL EQ &2             |
*| |RP-READ-T001P       |017 |   IF SY-SUBRC NE 0                     |
*| |RP-READ-T001P       |018 |     IF &3 NE SPACE                     |
*| |RP-READ-T001P       |019 |       MOVE &1 TO T001P-WERKS           |
*| |RP-READ-T001P       |020 |       MOVE &2 TO T001P-BTRTL           |
*| |RP-READ-T001P       |021 |       MESSAGE E001(PN) WITH 'T001P'   *|
*| |RP-READ-T001P       |022 |       T001P                            |
*| |RP-READ-T001P       |023 |     ENDIF                              |
*| |RP-READ-T001P       |024 |     MOVE SPACE TO T001P                |
*| |RP-READ-T001P       |025 |*    SY-SUBRC = 4                       |
*| |RP-READ-T001P       |026 |   ENDIF                                |
*| |RP-READ-T001P       |027 | ELSE                                   |
*| |RP-READ-T001P       |028 |   SY-SUBRC = 0                         |
*| |RP-READ-T001P       |029 | ENDIF                                  |
*| |RP-REF-C2-OD        |001 |****************************************|
*| |RP-REF-C2-OD        |002 |* CLUSTER OD: OED ZVB  (D), ALLE DATEN *|
*| |RP-REF-C2-OD        |003 |****************************************|
*| |RP-REF-C2-OD        |004 |CLEAR: OOD-VERSION, ODDIR               |
*| |RP-REF-C2-OD        |012 |REFRESH: ODDIR                          |
*| |RP-RSTR-BEGDA+ENDDA |001 |****************************************|
*| |RP-RSTR-BEGDA+ENDDA |002 |* RESTORE PN/BEGDA AND PN/ENDDA        *|
*| |RP-RSTR-BEGDA+ENDDA |003 |****************************************|
*| |RP-RSTR-BEGDA+ENDDA |004 |PN-BEGDA = $SAVE_PN_BEGDA               |
*| |RP-RSTR-BEGDA+ENDDA |005 |PN-ENDDA = $SAVE_PN_ENDDA               |
*| |RP-RSTR-BRP-IMPNDDA |001 |****************************************|
*| |RP-SAVE-BEGDA+ENDDA |001 |****************************************|
*| |RP-SAVE-BEGDA+ENDDA |002 |* SAVE PN/BEGDA AND PN/ENDDA           *|
*| |RP-SAVE-BEGDA+ENDDA |003 |****************************************|
*| |RP-SAVE-BEGDA+ENDDA |004 |DATA: $SAVE_PN_BEGDA TYPE D             |
*| |RP-SAVE-BEGDA+ENDDA |005 |DATA: $SAVE_PN_ENDDA TYPE D             |
*| |RP-SAVE-BEGDA+ENDDA |006 |$SAVE_PN_BEGDA = PN-BEGDA               |
*| |RP-SAVE-BEGDA+ENDDA |007 |$SAVE_PN_ENDDA = PN-ENDDA               |
*| |RP-SEL-APP-INIT     |001 |****************************************|
*| |RP-SEL-APP-INIT     |002 |* RP: APPLICANT IN PROCESSING ?        *|
*| |RP-SEL-APP-INIT     |003 |****************************************|
*| |RP-SEL-APP-INIT     |004 |REFRESH PAPSTARE                        |
*| |RP-SEL-APP-INIT     |005 |CLEAR   PAPSTARE                        |
*| |RP-SEL-APP-INIT     |006 |PAPSTARE-SIGN   = 'I'                   |
*| |RP-SEL-APP-INIT     |007 |PAPSTARE-OPTION = 'CP'                  |
*| |RP-SEL-APP-INIT     |008 |PAPSTARE-LOW    = '1*'                  |
*| |RP-SEL-APP-INIT     |009 |APPEND PAPSTARE                         |
*| |RP-SEL-CALC         |001 |****************************************|
*| |RP-SEL-CALC         |002 |* REJECT PERNR, IF REQUIRED            *|
*| |RP-SEL-CALC         |003 |* PAYROLL-RESULT DOES NOT EXIST        *|
*| |RP-SEL-CALC         |004 |****************************************|
*| |RP-SEL-CALC         |005 |* makro totally changed XTWP30K012821   |
*| |RP-SEL-CALC         |006 |DATA: RP-SEL-CALC-RRDAT TYPE D         *|
*| |RP-SEL-CALC         |007 |                        NON-LOCAL       |
*| |RP-SEL-CALC         |008 |PERFORM IN_PERIOD-IN-RGDIR              |
*| |RP-SEL-CALC         |009 |IF PNP-SW-FOUND EQ '0'                  |
*| |RP-SEL-CALC         |010 |  REJECT                                |
*| |RP-SEL-CALC         |011 |ENDIF                                   |
*| |RP-SEL-EIN-AUS      |001 |****************************************|
*| |RP-SEL-EIN-AUS      |002 |* RP: MITARBEITER NOCH IN FIRMA ?      *|
*| |RP-SEL-EIN-AUS      |003 |****************************************|
*| |RP-SEL-EIN-AUS      |004 |DATA: RP-SEL-EIN-AUS-SW                 |
*| |RP-SEL-EIN-AUS      |005 |MOVE '0' TO RP-SEL-EIN-AUS-SW           |
*| |RP-SEL-EIN-AUS      |006 |PROVIDE STAT2 FROM P0000 BETWEEN       *|
*| |RP-SEL-EIN-AUS      |007 |        PN-BEGDA AND PN-ENDDA           |
*| |RP-SEL-EIN-AUS      |008 |  IF P0000-STAT2 EQ '1'                 |
*| |RP-SEL-EIN-AUS      |009 |    MOVE '1' TO RP-SEL-EIN-AUS-SW       |
*| |RP-SEL-EIN-AUS      |010 |  ENDIF                                 |
*| |RP-SEL-EIN-AUS      |011 |ENDPROVIDE                              |
*| |RP-SEL-EIN-AUS      |012 |IF RP-SEL-EIN-AUS-SW EQ '0'             |
*| |RP-SEL-EIN-AUS      |013 |  REJECT                                |
*| |RP-SEL-EIN-AUS      |014 |ENDIF                                   |
*| |RP-SEL-EIN-AUS-INIT |001 |****************************************|
*| |RP-SEL-EIN-AUS-INIT |002 |* RP: MITARBEITER NOCH IN FIRMA ?      *|
*| |RP-SEL-EIN-AUS-INIT |003 |****************************************|
*| |RP-SEL-EIN-AUS-INIT |004 |* REFRESH PNPSTATU                      |
*| |RP-SEL-EIN-AUS-INIT |005 |* CLEAR   PNPSTATU                      |
*| |RP-SEL-EIN-AUS-INIT |006 |* PNPSTATU-SIGN   = 'E'                 |
*| |RP-SEL-EIN-AUS-INIT |007 |* PNPSTATU-OPTION = 'CP'                |
*| |RP-SEL-EIN-AUS-INIT |008 |* PNPSTATU-LOW    = '+0+'               |
*| |RP-SEL-EIN-AUS-INIT |009 |* APPEND PNPSTATU                       |
*| |RP-SEL-EIN-AUS-INIT |010 |REFRESH PNPSTAT2                        |
*| |RP-SEL-EIN-AUS-INIT |011 |CLEAR   PNPSTAT2                        |
*| |RP-SEL-EIN-AUS-INIT |012 |PNPSTAT2-SIGN   = 'I'                   |
*| |RP-SEL-EIN-AUS-INIT |013 |PNPSTAT2-OPTION = 'NE'                  |
*| |RP-SEL-EIN-AUS-INIT |014 |PNPSTAT2-LOW    = '0'                   |
*| |RP-SEL-EIN-AUS-INIT |015 |APPEND PNPSTAT2                         |
*| |RP-SEL-ZE           |001 |****************************************|
*| |RP-SEL-ZE           |002 |* RP: MA AKTIV UND ZTERF NICHT 0       *|
*| |RP-SEL-ZE           |003 |****************************************|
*| |RP-SEL-ZE           |004 |DATA: RP-SEL-ZE-SW(1)                   |
*| |RP-SEL-ZE           |005 |MOVE '0' TO RP-SEL-ZE-SW                |
*| |RP-SEL-ZE           |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE           |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE           |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE           |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE           |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE           |011 |    IF  P0007-ZTERF NE '0'              |
*| |RP-SEL-ZE           |012 |      MOVE '1' TO RP-SEL-ZE-SW          |
*| |RP-SEL-ZE           |013 |    ENDIF                               |
*| |RP-SEL-ZE           |014 |  ENDIF                                 |
*| |RP-SEL-ZE           |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE           |016 |IF RP-SEL-ZE-SW EQ '0'                  |
*| |RP-SEL-ZE           |017 |  REJECT                                |
*| |RP-SEL-ZE           |018 |ENDIF                                   |
*| |RP-SEL-ZE-7         |001 |****************************************|
*| |RP-SEL-ZE-7         |002 |* RP: MA AKTIV UND ZTERF GLEICH 7      *|
*| |RP-SEL-ZE-7         |003 |****************************************|
*| |RP-SEL-ZE-7         |004 |DATA: RP-SEL-ZE-7-SW                    |
*| |RP-SEL-ZE-7         |005 |MOVE '0' TO RP-SEL-ZE-7-SW              |
*| |RP-SEL-ZE-7         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-7         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-7         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-7         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-7         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-7         |011 |    IF  P0007-ZTERF EQ '7'              |
*| |RP-SEL-ZE-7         |012 |      MOVE '1' TO RP-SEL-ZE-7-SW        |
*| |RP-SEL-ZE-7         |013 |    ENDIF                               |
*| |RP-SEL-ZE-7         |014 |  ENDIF                                 |
*| |RP-SEL-ZE-7         |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE-7         |016 |IF RP-SEL-ZE-7-SW EQ '0'                |
*| |RP-SEL-ZE-7         |017 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-7         |018 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-7         |019 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-7         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-7         |021 |  REJECT                                |
*| |RP-SEL-ZE-7         |022 |ENDIF                                   |
*| |RP-SEL-ZE-A         |001 |****************************************|
*| |RP-SEL-ZE-A         |002 |* RP: MA AKTIV UND ZTERF NICHT 0       *|
*| |RP-SEL-ZE-A         |003 |****************************************|
*| |RP-SEL-ZE-A         |004 |DATA: RP-SEL-ZE-SW(1)                   |
*| |RP-SEL-ZE-A         |005 |MOVE '0' TO RP-SEL-ZE-SW                |
*| |RP-SEL-ZE-A         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-A         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-A         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-A         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-A         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-A         |011 |    IF  P0007-ZTERF NE '0'              |
*| |RP-SEL-ZE-A         |012 |      MOVE '1' TO RP-SEL-ZE-SW          |
*| |RP-SEL-ZE-A         |013 |    ENDIF                               |
*| |RP-SEL-ZE-A         |014 |  ENDIF                                 |
*| |RP-SEL-ZE-A         |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE-A         |016 |IF RP-SEL-ZE-SW EQ '0'                  |
*| |RP-SEL-ZE-A         |017 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-A         |018 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-A         |019 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-A         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-A         |021 |  REJECT                                |
*| |RP-SEL-ZE-A         |022 |ENDIF                                   |
*| |RP-SEL-ZE-B         |001 |****************************************|
*| |RP-SEL-ZE-B         |002 |* RP: MA AKTIV UND ZTERF GLECIH 2      *|
*| |RP-SEL-ZE-B         |003 |****************************************|
*| |RP-SEL-ZE-B         |004 |DATA: RP-SEL-ZE-B-SW(1)                 |
*| |RP-SEL-ZE-B         |005 |MOVE '0' TO RP-SEL-ZE-B-SW              |
*| |RP-SEL-ZE-B         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-B         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-B         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-B         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-B         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-B         |011 |    IF  P0007-ZTERF EQ '2'              |
*| |RP-SEL-ZE-B         |012 |      MOVE '1' TO RP-SEL-ZE-B-SW        |
*| |RP-SEL-ZE-B         |013 |    ENDIF                               |
*| |RP-SEL-ZE-B         |014 |  ENDIF                                 |
*| |RP-SEL-ZE-B         |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE-B         |016 |IF RP-SEL-ZE-B-SW EQ '0'                |
*| |RP-SEL-ZE-B         |017 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-B         |018 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-B         |019 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-B         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-B         |021 |  REJECT                                |
*| |RP-SEL-ZE-B         |022 |ENDIF                                   |
*| |RP-SEL-ZE-N         |001 |****************************************|
*| |RP-SEL-ZE-N         |002 |* RP: MA AKTIV UND ZTERF GLECIH 9      *|
*| |RP-SEL-ZE-N         |003 |****************************************|
*| |RP-SEL-ZE-N         |004 |DATA: RP-SEL-ZE-N-SW                    |
*| |RP-SEL-ZE-N         |005 |MOVE '0' TO RP-SEL-ZE-N-SW              |
*| |RP-SEL-ZE-N         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-N         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-N         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-N         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-N         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-N         |011 |    IF  P0007-ZTERF EQ '9'              |
*| |RP-SEL-ZE-N         |012 |      MOVE '1' TO RP-SEL-ZE-N-SW        |
*| |RP-SEL-ZE-N         |013 |    ENDIF                               |
*| |RP-SEL-ZE-N         |014 |  ENDIF                                 |
*| |RP-SEL-ZE-N         |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE-N         |016 |IF RP-SEL-ZE-N-SW EQ '0'                |
*| |RP-SEL-ZE-N         |017 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-N         |018 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-N         |019 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-N         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-N         |021 |  REJECT                                |
*| |RP-SEL-ZE-N         |022 |ENDIF                                   |
*| |RP-SEL-ZE-P         |001 |****************************************|
*| |RP-SEL-ZE-P         |002 |* RP: MA AKTIV UND ZTERF NICHT 0,9     *|
*| |RP-SEL-ZE-P         |003 |****************************************|
*| |RP-SEL-ZE-P         |004 |DATA: RP-SEL-ZE-P-SW                    |
*| |RP-SEL-ZE-P         |005 |MOVE '0' TO RP-SEL-ZE-P-SW              |
*| |RP-SEL-ZE-P         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-P         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-P         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-P         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-P         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-P         |011 |    IF  P0007-ZTERF NE '0' AND         *|
*| |RP-SEL-ZE-P         |012 |        P0007-ZTERF NE '7' AND         *|
*| |RP-SEL-ZE-P         |013 |        P0007-ZTERF NE '9'              |
*| |RP-SEL-ZE-P         |014 |      MOVE '1' TO RP-SEL-ZE-P-SW        |
*| |RP-SEL-ZE-P         |015 |    ENDIF                               |
*| |RP-SEL-ZE-P         |016 |  ENDIF                                 |
*| |RP-SEL-ZE-P         |017 |ENDPROVIDE                              |
*| |RP-SEL-ZE-P         |018 |IF RP-SEL-ZE-P-SW EQ '0'                |
*| |RP-SEL-ZE-P         |019 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-P         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-P         |021 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-P         |022 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-P         |023 |  REJECT                                |
*| |RP-SEL-ZE-P         |024 |ENDIF                                   |
*| |RP-SEL-ZE-SRV       |001 |****************************************|
*| |RP-SEL-ZE-SRV       |002 |* RP: MA AKTIV UND ZTERF GLECIH 8      *|
*| |RP-SEL-ZE-SRV       |003 |****************************************|
*| |RP-SEL-ZE-SRV       |004 |MOVE '0' TO RP-SEL-ZE-N-SW              |
*| |RP-SEL-ZE-SRV       |005 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-SRV       |006 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-SRV       |007 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-SRV       |008 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-SRV       |009 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-SRV       |010 |    IF  P0007-ZTERF EQ '8'              |
*| |RP-SEL-ZE-SRV       |011 |      MOVE '1' TO RP-SEL-ZE-N-SW        |
*| |RP-SEL-ZE-SRV       |012 |    ENDIF                               |
*| |RP-SEL-ZE-SRV       |013 |  ENDIF                                 |
*| |RP-SEL-ZE-SRV       |014 |ENDPROVIDE                              |
*| |RP-SEL-ZE-SRV       |015 |IF RP-SEL-ZE-N-SW EQ '0'                |
*| |RP-SEL-ZE-SRV       |016 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-SRV       |017 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-SRV       |018 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-SRV       |019 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-SRV       |020 |  REJECT                                |
*| |RP-SEL-ZE-SRV       |021 |ENDIF                                   |
*| |RP-SEL-ZE-Z         |001 |****************************************|
*| |RP-SEL-ZE-Z         |002 |* RP: MA AKTIV UND ZTERF GLECIH 1      *|
*| |RP-SEL-ZE-Z         |003 |****************************************|
*| |RP-SEL-ZE-Z         |004 |DATA: RP-SEL-ZE-Z-SW                    |
*| |RP-SEL-ZE-Z         |005 |MOVE '0' TO RP-SEL-ZE-Z-SW              |
*| |RP-SEL-ZE-Z         |006 |PROVIDE STAT2         FROM P0000       *|
*| |RP-SEL-ZE-Z         |007 |        ZTERF         FROM P0007       *|
*| |RP-SEL-ZE-Z         |008 |  BETWEEN PN-BEGDA AND PN-ENDDA         |
*| |RP-SEL-ZE-Z         |009 |  IF P0000-STAT2 EQ '3' AND            *|
*| |RP-SEL-ZE-Z         |010 |     P0007_VALID EQ 'X'                 |
*| |RP-SEL-ZE-Z         |011 |    IF  P0007-ZTERF EQ '1'              |
*| |RP-SEL-ZE-Z         |012 |      MOVE '1' TO RP-SEL-ZE-Z-SW        |
*| |RP-SEL-ZE-Z         |013 |    ENDIF                               |
*| |RP-SEL-ZE-Z         |014 |  ENDIF                                 |
*| |RP-SEL-ZE-Z         |015 |ENDPROVIDE                              |
*| |RP-SEL-ZE-Z         |016 |IF RP-SEL-ZE-Z-SW EQ '0'                |
*| |RP-SEL-ZE-Z         |017 |  PERFORM DEQUEUE_PERNR                *|
*| |RP-SEL-ZE-Z         |018 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-Z         |019 |  PERFORM DEQUEUE_B1                   *|
*| |RP-SEL-ZE-Z         |020 |  USING PERNR-PERNR                     |
*| |RP-SEL-ZE-Z         |021 |  REJECT                                |
*| |RP-SEL-ZE-Z         |022 |ENDIF                                   |
*| |RP-SEQINPUT-PREPARE |001 |****************************************|
*| |RP-SEQINPUT-PREPARE |002 |* RP-SEQINPUT-PREPARE                  *|
*| |RP-SEQINPUT-PREPARE |003 |*   PARAMETERS: PUT-OPTION 'X' OR SPACE*|
*| |RP-SEQINPUT-PREPARE |004 |*               DATASETNAME            *|
*| |RP-SEQINPUT-PREPARE |005 |* INCLUDE DBPNPSEQ  FOR DATADEFINITION *|
*| |RP-SEQINPUT-PREPARE |006 |* IS SUPPOSED TO STAND BEFORE          *|
*| |RP-SEQINPUT-PREPARE |007 |****************************************|
*| |RP-SEQINPUT-PREPARE |008 |DATA BEGIN OF $INFTYLENGTH OCCURS 100   |
*| |RP-SEQINPUT-PREPARE |009 |DATA   INFTY LIKE PREL-INFTY            |
*| |RP-SEQINPUT-PREPARE |010 |DATA   LENGTH(3) TYPE P                 |
*| |RP-SEQINPUT-PREPARE |011 |DATA END OF $INFTYLENGTH                |
*| |RP-SEQINPUT-PREPARE |012 |DATA $INFTY-MAXLENGTH(3) TYPE P         |
*| |RP-SEQINPUT-PREPARE |013 |DATA $STATISTIC-PUTS   TYPE P           |
*| |RP-SEQINPUT-PREPARE |014 |DATA $STATISTIC-LENGTH TYPE P           |
*| |RP-SEQINPUT-PREPARE |015 |*INCLUDE RPDDICD1                       |
*| |RP-SEQINPUT-PREPARE |016 |                                        |
*| |RP-SEQINPUT-PREPARE |017 |DESCRIBE FIELD  RECRD-LENGTH           *|
*| |RP-SEQINPUT-PREPARE |018 |         LENGTH $INFTY-MAXLENGTH        |
*| |RP-SEQINPUT-PREPARE |019 |DESCRIBE FIELD  RECRD-SORTH            *|
*| |RP-SEQINPUT-PREPARE |020 |         LENGTH $DDICP                  |
*| |RP-SEQINPUT-PREPARE |021 |ADD $INFTY-MAXLENGTH TO $DDICP          |
*| |RP-SEQINPUT-PREPARE |022 |DESCRIBE FIELD  RECRD-PNNNN            *|
*| |RP-SEQINPUT-PREPARE |023 |         LENGTH $INFTY-MAXLENGTH        |
*| |RP-SEQINPUT-PREPARE |024 |* CLEAR   $INFTYLENGTH                  |
*| |RP-SEQINPUT-PREPARE |025 |* REFRESH $INFTYLENGTH                  |
*| |RP-SEQINPUT-PREPARE |026 |LOOP AT $RINFO$                         |
*| |RP-SEQINPUT-PREPARE |027 |  $INFTYLENGTH-INFTY = $RINFO$-NUMBER   |
*| |RP-SEQINPUT-PREPARE |028 |  COLLECT $INFTYLENGTH                  |
*| |RP-SEQINPUT-PREPARE |029 |ENDLOOP                                 |
*| |RP-SEQINPUT-PREPARE |030 |$DDICTABLELENGTHIN+0(1) = 'P'           |
*| |RP-SEQINPUT-PREPARE |031 |LOOP AT $INFTYLENGTH                    |
*| |RP-SEQINPUT-PREPARE |032 |  $DDICTABLELENGTHIN+1(4) =            *|
*| |RP-SEQINPUT-PREPARE |033 |         $INFTYLENGTH-INFTY             |
*| |RP-SEQINPUT-PREPARE |034 |  PERFORM $DDICTABLELENGTH(RPDDICMP)   *|
*| |RP-SEQINPUT-PREPARE |035 |           USING $DDICTABLELENGTHIN    *|
*| |RP-SEQINPUT-PREPARE |036 |        CHANGING $DDICTABLELENGTHOUT    |
*| |RP-SEQINPUT-PREPARE |037 |  IF $DDICTABLELENGTHOUT-RETURNCODE EQ 0|
*| |RP-SEQINPUT-PREPARE |038 |    $INFTYLENGTH-LENGTH =              *|
*| |RP-SEQINPUT-PREPARE |039 |        $DDICTABLELENGTHOUT-USELENGTH   |
*| |RP-SEQINPUT-PREPARE |040 |  ELSE                                  |
*| |RP-SEQINPUT-PREPARE |041 |    $INFTYLENGTH-LENGTH =              *|
*| |RP-SEQINPUT-PREPARE |042 |        $INFTYLENGTH-LENGTH             |
*| |RP-SEQINPUT-PREPARE |043 |  ENDIF                                 |
*| |RP-SEQINPUT-PREPARE |044 |  ADD $DDICP TO $INFTYLENGTH-LENGTH     |
*| |RP-SEQINPUT-PREPARE |045 |  MODIFY $INFTYLENGTH                   |
*| |RP-SEQINPUT-PREPARE |046 |ENDLOOP                                 |
*| |RP-SEQINPUT-PREPARE |047 |IF &1 NE SPACE                          |
*| |RP-SEQINPUT-PREPARE |048 |  OPEN DATASET &2 FOR OUTPUT            |
*| |RP-SEQINPUT-PREPARE |049 |ENDIF                                   |
*| |RP-SEQINPUT-TRANSFER|001 |****************************************|
*| |RP-SEQINPUT-TRANSFER|002 |* RP-SEQINPUT-TRANSFER                 *|
*| |RP-SEQINPUT-TRANSFER|003 |*   PARAMETERS: 1 INFTY                *|
*| |RP-SEQINPUT-TRANSFER|004 |*               2 SUBTY                *|
*| |RP-SEQINPUT-TRANSFER|005 |*               3 OBJPS                *|
*| |RP-SEQINPUT-TRANSFER|006 |*               4 BEGDA                *|
*| |RP-SEQINPUT-TRANSFER|007 |*               5 ENDDA                *|
*| |RP-SEQINPUT-TRANSFER|008 |*               6 TRANSFER             *|
*| |RP-SEQINPUT-TRANSFER|009 |*               7 DSNNAME              *|
*| |RP-SEQINPUT-TRANSFER|010 |*               8 TESTWRITE            *|
*| |RP-SEQINPUT-TRANSFER|011 |****************************************|
*| |RP-SEQINPUT-TRANSFER|012 |READ TABLE $INFTYLENGTH WITH KEY '&1'   |
*| |RP-SEQINPUT-TRANSFER|013 |IF SY-SUBRC NE 0                        |
*| |RP-SEQINPUT-TRANSFER|014 |  $INFTYLENGTH-LENGTH = $INFTY-MAXLENGTH|
*| |RP-SEQINPUT-TRANSFER|015 |ENDIF                                   |
*| |RP-SEQINPUT-TRANSFER|016 |RECRD-LENGTH = $INFTYLENGTH-LENGTH      |
*| |RP-SEQINPUT-TRANSFER|017 |  IF &8 NE SPACE                        |
*| |RP-SEQINPUT-TRANSFER|018 |    WRITE: / 'INFOTYPE', '&1'           |
*| |RP-SEQINPUT-TRANSFER|019 |    WRITE:   '  LENGTH'                 |
*| |RP-SEQINPUT-TRANSFER|020 |    WRITE:   (4) $INFTYLENGTH-LENGTH    |
*| |RP-SEQINPUT-TRANSFER|021 |  ENDIF                                 |
*| |RP-SEQINPUT-TRANSFER|022 |LOOP AT P&1 WHERE BEGDA LE &5          *|
*| |RP-SEQINPUT-TRANSFER|023 |              AND ENDDA GE &4           |
*| |RP-SEQINPUT-TRANSFER|024 |  IF &2 NE SPACE                        |
*| |RP-SEQINPUT-TRANSFER|025 |    CHECK P&1-SUBTY EQ &2               |
*| |RP-SEQINPUT-TRANSFER|026 |  ENDIF                                 |
*| |RP-SEQINPUT-TRANSFER|027 |  IF &3 NE SPACE                        |
*| |RP-SEQINPUT-TRANSFER|028 |    CHECK P&1-OBJPS EQ &3               |
*| |RP-SEQINPUT-TRANSFER|029 |  ENDIF                                 |
*| |RP-SEQINPUT-TRANSFER|030 |  RECRD-PNNNN = P&1                     |
*| |RP-SEQINPUT-TRANSFER|031 |  IF &6 NE SPACE                        |
*| |RP-SEQINPUT-TRANSFER|032 |    TRANSFER RECRD TO &7                |
*| |RP-SEQINPUT-TRANSFER|033 |  ENDIF                                 |
*| |RP-SEQINPUT-TRANSFER|034 |  IF &8 NE SPACE                        |
*| |RP-SEQINPUT-TRANSFER|035 |    WRITE: / RECRD-PNNNN                |
*| |RP-SEQINPUT-TRANSFER|036 |  ENDIF                                 |
*| |RP-SEQINPUT-TRANSFER|037 |  ADD 1 TO $STATISTIC-PUTS              |
*| |RP-SEQINPUT-TRANSFER|038 |  ADD $INFTYLENGTH-LENGTH              *|
*| |RP-SEQINPUT-TRANSFER|039 |        TO $STATISTIC-LENGTH            |
*| |RP-SEQINPUT-TRANSFER|040 |ENDLOOP                                 |
*| |RP-SET-KEY-DATE     |001 |****************************************|
*| |RP-SET-KEY-DATE     |002 |* STICHTAG-SETZEN                      *|
*| |RP-SET-KEY-DATE     |003 |****************************************|
*| |RP-SET-KEY-DATE     |004 |IF PN-BEGDA EQ LOW-DATE                 |
*| |RP-SET-KEY-DATE     |005 |  PN-BEGDA = SY-DATUM                   |
*| |RP-SET-KEY-DATE     |006 |  PN-BEGPS = SY-DATUM                   |
*| |RP-SET-KEY-DATE     |007 |ENDIF                                   |
*| |RP-SET-KEY-DATE     |008 |PN-ENDDA = PN-BEGDA                     |
*| |RP-SET-KEY-DATE     |009 |PN-ENDPS = PN-BEGPS                     |
*| |RP-SET-NAME-FORMAT  |001 |****************************************|
*| |RP-SET-NAME-FORMAT  |002 |* RP: SETZT NAMENS-FORMAT AUS T522F    *|
*| |RP-SET-NAME-FORMAT  |003 |****************************************|
*| |RP-SET-NAME-FORMAT  |004 |TABLES T522F                            |
*| |RP-SET-NAME-FORMAT  |005 |DATA $$FORMAT LIKE P0002-KNZNM         *|
*| |RP-SET-NAME-FORMAT  |006 |                           NON-LOCAL    |
*| |RP-SET-NAME-FORMAT  |007 |SELECT SINGLE * FROM T522F             *|
*| |RP-SET-NAME-FORMAT  |008 |                WHERE REPID EQ SY-REPID |
*| |RP-SET-NAME-FORMAT  |009 |IF SY-SUBRC EQ 0                        |
*| |RP-SET-NAME-FORMAT  |010 |  $$FORMAT = T522F-FORMT                |
*| |RP-SET-NAME-FORMAT  |011 |ELSE                                    |
*| |RP-SET-NAME-FORMAT  |012 |  $$FORMAT = '01'                       |
*| |RP-SET-NAME-FORMAT  |013 |ENDIF                                   |
*| |RP-SET-NAME-FORMAT-J|010 |****************************************|
*| |RP-SET-NAME-FORMAT-J|020 |* RP-SET-NAME-FORMAT-J (JAPAN)         *|
*| |RP-SET-NAME-FORMAT-J|030 |****************************************|
*| |RP-SET-NAME-FORMAT-J|040 |DATA $$FORMAT_SAVE LIKE P0002-KNZNM    *|
*| |RP-SET-NAME-FORMAT-J|050 |                           NON-LOCAL    |
*| |RP-SET-SJIS-J       |010 |****************************************|
*| |RP-SET-SJIS-J       |020 |* ADJUST SHIFT-JIS CHAR LENGTH         *|
*| |RP-SET-SJIS-J       |030 |****************************************|
*| |RP-SET-SJIS-J       |040 |*   DATA DEF             (JAPAN)       *|
*| |RP-SET-SJIS-J       |050 |****************************************|
*| |RP-SET-SJIS-J       |060 |data: gv_string_to_adjust              *|
*| |RP-SET-SJIS-J       |070 |       type string non-local.           |
*| |RP-SET-SJIS-J       |080 |data: gv_sjis_string_length            *|
*| |RP-SET-SJIS-J       |090 |       type i non-local.                |
*| |RP-STICHTAG         |001 |****************************************|
*| |RP-STICHTAG         |002 |* RP-STICHTAG                          *|
*| |RP-STICHTAG         |003 |* STICHTAGSDATUM IN DIE 2TE ZEILE      *|
*| |RP-STICHTAG         |004 |****************************************|
*| |RP-STICHTAG         |005 |DATA $SLINE(40)                         |
*| |RP-STICHTAG         |006 |DATA $SDATE(13) VALUE 'TT.MM.JJJJ $3'   |
*| |RP-STICHTAG         |007 |DATA NEXT-LINE-ST LIKE SY-LINNO         |
*| |RP-STICHTAG         |008 |DATA LINS(2) TYPE P                     |
*| |RP-STICHTAG         |009 |LINS = SY-LINSZ - STRLEN( TEXT-STT ) - 9|
*| |RP-STICHTAG         |010 |LINS = LINS / 2                         |
*| |RP-STICHTAG         |011 |NEXT-LINE-ST = SY-LINNO                 |
*| |RP-STICHTAG         |012 |SKIP TO LINE 2                          |
*| |RP-STICHTAG         |013 |POSITION LINS                           |
*| |RP-STICHTAG         |014 |$SLINE+1 = 'STICHTAG $1'(STT)           |
*| |RP-STICHTAG         |015 |WRITE PN-ENDDA DD/MM/YYYY TO $SDATE(10) |
*| |RP-STICHTAG         |016 |REPLACE '$1' WITH $SDATE INTO $SLINE    |
*| |RP-STICHTAG         |017 |REPLACE '$3' WITH SY-ULINE INTO $SLINE  |
*| |RP-STICHTAG         |018 |WRITE $SLINE                            |
*| |RP-STICHTAG         |019 |SKIP TO LINE NEXT-LINE-ST               |
*| |RP-SW-554S-UNIT     |000 |*4.0C This program code is obsolete     |
*| |RP-SW-554S-UNIT     |001 |*Einheit fuer T554S-MINTG, MAXTG.       |
*| |RP-SW-554S-UNIT     |002 |*K=Kalendertage, A=Abwesenh., R=Abrechn.|
*| |RP-SW-554S-UNIT     |003 |*data: sw_554s_unit(1) type c value 'K'.|
*| |RP-SW-554S-UNIT     |004 |*D=absteigend, A=aufsteigend            |
*| |RP-SW-554S-UNIT     |005 |*data: sw_sort_vac(1)  type c value 'D'.|
*| |RP-SW-P0005         |000 |****************************************|
*| |RP-SW-P0005         |001 |* RP: Festlegung Schalter Infotyp 0005 *|
*| |RP-SW-P0005         |002 |****************************************|
*| |RP-SW-P0005         |004 |DATA START_SENORITY(2) VALUE '01'.      |
*| |RP-SW-P0005         |005 |DATA KEYDATE_SENORITY(2) VALUE '26'.    |
*| |RP-TEST             |001 |WRITE: / &1                             |
*| |RP-TEST             |002 |WRITE: / &2                             |
*| |RP-UPDATE           |001 |****************************************|
*| |RP-UPDATE           |002 |*RP-UPDATE                             *|
*| |RP-UPDATE           |003 |*   PARAMETERS:                        *|
*| |RP-UPDATE           |004 |*     1 :  OLD TABLE                   *|
*| |RP-UPDATE           |005 |*     2 :  NEW TABLE                   *|
*| |RP-UPDATE           |006 |*   SW_REFRESH = 'X'                   *|
*| |RP-UPDATE           |007 |*   SW_GET     = 'X'                   *|
*| |RP-UPDATE           |008 |*   SW_CALL_VB = 'X'                   *|
*| |RP-UPDATE           |009 |****************************************|
*| |RP-UPDATE           |010 |PERFORM UPDATE(RPUPDCTL)               *|
*| |RP-UPDATE           |011 |        TABLES &1 &2                   *|
*| |RP-UPDATE           |012 |        USING 'X' 'X' 'X'.              |
*| |RP-UTAB-SET-BEG-END |001 |****************************************|
*| |RP-UTAB-SET-BEG-END |002 |*RP-UTAB-SET-BEG-END                   *|
*| |RP-UTAB-SET-BEG-END |003 |*   PARAMETERS:                        *|
*| |RP-UTAB-SET-BEG-END |004 |*     1 :     TABLENAME                *|
*| |RP-UTAB-SET-BEG-END |005 |****************************************|
*| |RP-UTAB-SET-BEG-END |006 |T&1-BEGDA = OLD-BEGDT                   |
*| |RP-UTAB-SET-BEG-END |007 |T&1-BEGDA+0(2) = '19'                   |
*| |RP-UTAB-SET-BEG-END |008 |T&1-ENDDA = OLD-ENDDT                   |
*| |RP-UTAB-SET-BEG-END |009 |IF OLD-ENDDT EQ '991231'                |
*| |RP-UTAB-SET-BEG-END |010 |  T&1-ENDDA+0(2) = '99'                 |
*| |RP-UTAB-SET-BEG-END |011 |ELSE                                    |
*| |RP-UTAB-SET-BEG-END |012 |  T&1-ENDDA+0(2) = '19'                 |
*| |RP-UTAB-SET-BEG-END |013 |ENDIF                                   |
*| |RP-UTAB-SET-MOLGA   |001 |****************************************|
*| |RP-UTAB-SET-MOLGA   |002 |* RP-UTAB-SET-MOLGA   &1=LAND &2=MOLGA *|
*| |RP-UTAB-SET-MOLGA   |003 |* PARAMETERS:                          *|
*| |RP-UTAB-SET-MOLGA   |004 |* IN   1 : LAND                        *|
*| |RP-UTAB-SET-MOLGA   |005 |* OUT  2 : MOLGA ; '00' IF FAULTY      *|
*| |RP-UTAB-SET-MOLGA   |006 |****************************************|
*| |RP-UTAB-SET-MOLGA   |007 |TABLES: T001, T001P                     |
*| |RP-UTAB-SET-MOLGA   |008 |CASE &1                                 |
*| |RP-UTAB-SET-MOLGA   |009 |  WHEN 'D  '.   &2 = '01'               |
*| |RP-UTAB-SET-MOLGA   |010 |  WHEN 'CH '.   &2 = '02'               |
*| |RP-UTAB-SET-MOLGA   |011 |  WHEN 'A  '.   &2 = '03'               |
*| |RP-UTAB-SET-MOLGA   |012 |  WHEN 'E  '.   &2 = '04'               |
*| |RP-UTAB-SET-MOLGA   |013 |  WHEN 'NL '.   &2 = '05'               |
*| |RP-UTAB-SET-MOLGA   |014 |  WHEN 'F  '.   &2 = '06'               |
*| |RP-UTAB-SET-MOLGA   |015 |  WHEN 'CAN'.   &2 = '07'               |
*| |RP-UTAB-SET-MOLGA   |016 |  WHEN 'GB '.   &2 = '08'               |
*| |RP-UTAB-SET-MOLGA   |017 |  WHEN 'DK '.   &2 = '09'               |
*| |RP-UTAB-SET-MOLGA   |018 |  WHEN 'USA'.   &2 = '10'               |
*| |RP-UTAB-SET-MOLGA   |019 |  WHEN 'I  '.   &2 = '11'               |
*| |RP-UTAB-SET-MOLGA   |020 |  WHEN 'B  '.   &2 = '12'               |
*| |RP-UTAB-SET-MOLGA   |021 |  WHEN OTHERS                           |
*| |RP-UTAB-SET-MOLGA   |022 |SELECT * FROM T001  WHERE LAND EQ &1    |
*| |RP-UTAB-SET-MOLGA   |023 |  EXIT                                  |
*| |RP-UTAB-SET-MOLGA   |024 |ENDSELECT                               |
*| |RP-UTAB-SET-MOLGA   |025 |IF SY-SUBRC EQ 0                        |
*| |RP-UTAB-SET-MOLGA   |026 |SELECT * FROM T001P                    *|
*| |RP-UTAB-SET-MOLGA   |027 |  WHERE BUKRS EQ T001-BUKRS             |
*| |RP-UTAB-SET-MOLGA   |028 |  &2 = T001P-MOLGA                      |
*| |RP-UTAB-SET-MOLGA   |029 |  EXIT                                  |
*| |RP-UTAB-SET-MOLGA   |030 |ENDSELECT                               |
*| |RP-UTAB-SET-MOLGA   |031 |ENDIF                                   |
*| |RP-UTAB-SET-MOLGA   |032 |ENDCASE                                 |
*| |RP-WRITE-ALTER-PERID|001 |****************************************|
*| |RP-WRITE-ALTER-PERID|002 |* RP-WRITE-ALTER-PERID                 *|
*| |RP-WRITE-ALTER-PERID|003 |****************************************|
*| |RP-WRITE-ALTER-PERID|004 |* PARAMETER  IN: - ALTER-PERID (YES/NO)*|
*| |RP-WRITE-ALTER-PERID|005 |*                  DRUCK ALTERNATE PER *|
*| |RP-WRITE-ALTER-PERID|006 |*                - P0002               *|
*| |RP-WRITE-ALTER-PERID|007 |*                  DATEN ZUR PERSON    *|
*| |RP-WRITE-ALTER-PERID|008 |*                - 'X'/SPACE           *|
*| |RP-WRITE-ALTER-PERID|009 |*                  DRUCKOPTION         *|
*| |RP-WRITE-ALTER-PERID|010 |* PARAMETER OUT: - $LENGTH             *|
*| |RP-WRITE-ALTER-PERID|011 |*                  LAENGE FELD PERID   *|
*| |RP-WRITE-ALTER-PERID|012 |****************************************|
*| |RP-WRITE-ALTER-PERID|013 |DATA $$PERID LIKE &1-PERID              |
*| |RP-WRITE-ALTER-PERID|014 |IF $$SW-ALTER-PERID = $$ALTER-PERID-YES |
*| |RP-WRITE-ALTER-PERID|015 |  IF &1-PERID NE SPACE                  |
*| |RP-WRITE-ALTER-PERID|016 |    IF &2 NE SPACE                      |
*| |RP-WRITE-ALTER-PERID|017 |      WRITE: / &1-PERID                 |
*| |RP-WRITE-ALTER-PERID|018 |    ELSE                                |
*| |RP-WRITE-ALTER-PERID|019 |      $LENGTH = 0                       |
*| |RP-WRITE-ALTER-PERID|020 |      $$PERID  = &1-PERID               |
*| |RP-WRITE-ALTER-PERID|021 |      WHILE $$PERID+0(1) NE SPACE       |
*| |RP-WRITE-ALTER-PERID|022 |        SHIFT $$PERID                   |
*| |RP-WRITE-ALTER-PERID|023 |        $LENGTH = $LENGTH + 1           |
*| |RP-WRITE-ALTER-PERID|024 |      ENDWHILE                          |
*| |RP-WRITE-ALTER-PERID|025 |    ENDIF                               |
*| |RP-WRITE-ALTER-PERID|026 |  ENDIF                                 |
*| |RP-WRITE-ALTER-PERID|027 |ENDIF                                   |
*| |RP-WRITE-ALTER-PERNO|001 |****************************************|
*| |RP-WRITE-ALTER-PERNO|002 |* RP-WRITE-ALTER-PERNO                 *|
*| |RP-WRITE-ALTER-PERNO|003 |* PARAMETER  IN: - P0002               *|
*| |RP-WRITE-ALTER-PERNO|004 |*                  DATEN ZUR PERSON    *|
*| |RP-WRITE-ALTER-PERNO|005 |*                - 'X'/SPACE           *|
*| |RP-WRITE-ALTER-PERNO|006 |*                  DRUCKOPTION         *|
*| |RP-WRITE-ALTER-PERNO|007 |* PARAMETER OUT: - LENGTH              *|
*| |RP-WRITE-ALTER-PERNO|008 |*                  LAENGE FELD PERID   *|
*| |RP-WRITE-ALTER-PERNO|009 |****************************************|
*| |RP-WRITE-ALTER-PERNO|010 |DATA LENGTH(2) TYPE N                   |
*| |RP-WRITE-ALTER-PERNO|011 |DATA PERID LIKE &1-PERID                |
*| |RP-WRITE-ALTER-PERNO|012 |IF &1-PERID NE SPACE                    |
*| |RP-WRITE-ALTER-PERNO|013 |  IF &2 NE SPACE                        |
*| |RP-WRITE-ALTER-PERNO|014 |    WRITE: / &1-PERID                   |
*| |RP-WRITE-ALTER-PERNO|015 |  ELSE                                  |
*| |RP-WRITE-ALTER-PERNO|016 |    LENGTH = 0.                         |
*| |RP-WRITE-ALTER-PERNO|017 |    PERID  = &1-PERID                   |
*| |RP-WRITE-ALTER-PERNO|018 |    WHILE PERID+0(1) NE SPACE.          |
*| |RP-WRITE-ALTER-PERNO|019 |      SHIFT PERID.                      |
*| |RP-WRITE-ALTER-PERNO|020 |      LENGTH = LENGTH + 1.              |
*| |RP-WRITE-ALTER-PERNO|021 |    ENDWHILE.                           |
*| |RP-WRITE-ALTER-PERNO|022 |  ENDIF                                 |
*| |RP-WRITE-ALTER-PERNO|023 |ENDIF                                   |
*| |RP-WRITE-ALTER-PERNR|001 |****************************************|
*| |RP-WRITE-ALTER-PERNR|002 |*RP-WRITE-ALTER-PERNR P0001 P0003 WRITE*|
*| |RP-WRITE-ALTER-PERNR|003 |****************************************|
*| |RP-WRITE-ALTER-PERNR|004 |DATA SFELD LIKE P0003-SFELD             |
*| |RP-WRITE-ALTER-PERNR|005 |DATA LENGTH(2) TYPE N                   |
*| |RP-WRITE-ALTER-PERNR|006 |CALL FUNCTION                          *|
*| |RP-WRITE-ALTER-PERNR|007 |     'RP_FETCH_ALTERNATE_PERNR'        *|
*| |RP-WRITE-ALTER-PERNR|008 |     EXPORTING PP0001       = &1       *|
*| |RP-WRITE-ALTER-PERNR|009 |               PP0003_SFELD = &2-SFELD *|
*| |RP-WRITE-ALTER-PERNR|010 |     IMPORTING SFELD       =  SFELD    *|
*| |RP-WRITE-ALTER-PERNR|011 |               LENGTH      =  LENGTH    |
*| |RP-WRITE-ALTER-PERNR|012 |IF SFELD NE SPACE AND &3 NE SPACE       |
*| |RP-WRITE-ALTER-PERNR|013 |  WRITE: / SFELD                        |
*| |RP-WRITE-ALTER-PERNR|014 |ENDIF                                   |
*| |RP-ZEITRAUM         |001 |****************************************|
*| |RP-ZEITRAUM         |002 |* RP-ZEITRAUM                          *|
*| |RP-ZEITRAUM         |003 |* AUSWERTUNGSZEITRAUM IN DIE 2TE ZEILE *|
*| |RP-ZEITRAUM         |004 |****************************************|
*| |RP-ZEITRAUM         |005 |DATA $ZLINE(60)                         |
*| |RP-ZEITRAUM         |006 |DATA $ZDATE(13) VALUE 'TT.MM,JJJJ $3'   |
*| |RP-ZEITRAUM         |007 |DATA NEXT-LINE-ZE LIKE SY-LINNO         |
*| |RP-ZEITRAUM         |008 |DATA LINZ(2) TYPE P                     |
*| |RP-ZEITRAUM         |009 |LINZ = STRLEN( TEXT-ZRM )               |
*| |RP-ZEITRAUM         |010 |IF LINZ GE 24                           |
*| |RP-ZEITRAUM         |011 |  LINZ = SY-LINSZ - LINZ - 17           |
*| |RP-ZEITRAUM         |012 |ELSE                                    |
*| |RP-ZEITRAUM         |013 |  IF LINZ EQ 0                          |
*| |RP-ZEITRAUM         |014 |    LINZ = SY-LINSZ - 29 - 17           |
*| |RP-ZEITRAUM         |015 |  ELSE                                  |
*| |RP-ZEITRAUM         |016 |    LINZ = SY-LINSZ - 24 - 17           |
*| |RP-ZEITRAUM         |017 |  ENDIF                                 |
*| |RP-ZEITRAUM         |018 |ENDIF                                   |
*| |RP-ZEITRAUM         |019 |LINZ = LINZ / 2                         |
*| |RP-ZEITRAUM         |020 |NEXT-LINE-ZE = SY-LINNO                 |
*| |RP-ZEITRAUM         |021 |SKIP TO LINE 2                          |
*| |RP-ZEITRAUM         |022 |POSITION LINZ                           |
*| |RP-ZEITRAUM         |023 |$ZLINE+1 =                             *|
*| |RP-ZEITRAUM         |024 |  'AUSWERTUNGSZEITRAUM $1 BIS $2'(ZRM)  |
*| |RP-ZEITRAUM         |025 |WRITE PN-BEGDA DD/MM/YYYY TO $ZDATE(10) |
*| |RP-ZEITRAUM         |026 |REPLACE '$1' WITH $ZDATE(10) INTO $ZLINE|
*| |RP-ZEITRAUM         |027 |WRITE PN-ENDDA DD/MM/YYYY TO $ZDATE(10) |
*| |RP-ZEITRAUM         |028 |REPLACE '$2' WITH $ZDATE INTO $ZLINE    |
*| |RP-ZEITRAUM         |029 |REPLACE '$3' WITH SY-ULINE INTO $ZLINE  |
*| |RP-ZEITRAUM         |030 |WRITE $ZLINE                            |
*| |RP-ZEITRAUM         |031 |SKIP TO LINE NEXT-LINE-ZE               |
*| |RPD-GET-SVATTR-GP   |010 |****************************************|
*| |RPD-GET-SVATTR-GP   |020 |* AKTIONEN ZU SV-ATTRIBUTE, MUSS NACH  *|
*| |RPD-GET-SVATTR-GP   |030 |* IMPORT SV STEHEN VGL.RPD-GET-SVATTR-IM|
*| |RPD-GET-SVATTR-GP   |040 |* FUER FUNKTIONBAUSTEIN RPD_GET_SVATTR *|
*| |RPD-GET-SVATTR-GP   |050 |* ES WERDEN 40 ATTRIBUTE UNTERSTUETZT  *|
*| |RPD-GET-SVATTR-GP   |060 |****************************************|
*| |RPD-GET-SVATTR-GP   |070 |DATA SVATTR(2) VALUE &1                 |
*| |RPD-GET-SVATTR-GP   |080 |CLEAR SVATTR-ALL                        |
*| |RPD-GET-SVATTR-GP   |090 |CLEAR SVATTR-SINGLE                     |
*| |RPD-GET-SVATTR-GP   |100 |MOVE-CORRESPONDING P0013 TO PSVA        |
*| |RPD-GET-SVATTR-GP   |110 |MOVE PSVA TO RPSVA                      |
*| |RPD-GET-SVATTR-IM   |010 |****************************************|
*| |RPD-GET-SVATTR-IM   |020 |* AKTIONEN ZU SV-ATTRIBUTE, MUSS NACH  *|
*| |RPD-GET-SVATTR-IM   |030 |* IMPORT SV STEHEN VGL.RPD-GET-SVATTR-GP|
*| |RPD-GET-SVATTR-IM   |040 |* FUER FUNKTIONBAUSTEIN RPD_GET_SVATTR *|
*| |RPD-GET-SVATTR-IM   |050 |* ES WERDEN 40 ATTRIBUTE UNTERSTUETZT  *|
*| |RPD-GET-SVATTR-IM   |060 |****************************************|
*| |RPD-GET-SVATTR-IM   |070 |CLEAR SVATTR-ALL                        |
*| |RPD-GET-SVATTR-IM   |080 |CLEAR SVATTR-SINGLE                     |
*| |RPD-GET-SVATTR-IM   |090 |MOVE-CORRESPONDING SV      TO PSVA      |
*| |RPD-GET-SVATTR-IM   |100 |MOVE PSVA TO RPSVA                      |
*| |RPD-GET-SVATTRD     |010 |****************************************|
*| |RPD-GET-SVATTRD     |020 |* RPD-GET-SVATTRD                      *|
*| |RPD-GET-SVATTRD     |030 |* DATENBESCHREIBUNG SV-ATTRIBUTE FUER  *|
*| |RPD-GET-SVATTRD     |040 |* DEN FUNKTIONBAUSTEIN RPD_GET_SVATTR  *|
*| |RPD-GET-SVATTRD     |050 |* ES WERDEN 40 ATTRIBUTE UNTERSTUETZT  *|
*| |RPD-GET-SVATTRD     |055 |****************************************|
*| |RPD-GET-SVATTRD     |060 |DATA  BEGIN OF SVATTR-ALL               |
*| |RPD-GET-SVATTRD     |070 |DATA    A01(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |080 |DATA    A02(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |090 |DATA    A03(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |100 |DATA    A04(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |110 |DATA    A05(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |120 |DATA    A06(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |130 |DATA    A07(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |140 |DATA    A08(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |150 |DATA    A09(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |160 |DATA    A10(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |170 |DATA    A11(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |180 |DATA    A12(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |190 |DATA    A13(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |200 |DATA    A14(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |210 |DATA    A15(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |220 |DATA    A16(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |230 |DATA    A17(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |240 |DATA    A18(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |250 |DATA    A19(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |260 |DATA    A20(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |270 |DATA    A21(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |280 |DATA    A22(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |290 |DATA    A23(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |300 |DATA    A24(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |310 |DATA    A25(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |320 |DATA    A26(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |330 |DATA    A27(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |340 |DATA    A28(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |350 |DATA    A29(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |360 |DATA    A30(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |370 |DATA    A31(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |380 |DATA    A32(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |390 |DATA    A33(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |400 |DATA    A34(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |410 |DATA    A35(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |420 |DATA    A36(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |430 |DATA    A37(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |440 |DATA    A38(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |450 |DATA    A39(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |460 |DATA    A40(1) TYPE C                   |
*| |RPD-GET-SVATTRD     |470 |DATA  END OF SVATTR-ALL                 |
*| |RPD-GET-SVATTRD     |510 |DATA SVATTR-SINGLE(1) TYPE C VALUE '  ' |
*| |RPD-GET-SVATTRD     |600 |DATA BEGIN OF PSVA                      |
*| |RPD-GET-SVATTRD     |610 |DATA SVA-001 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |620 |DATA SVA-002 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |630 |DATA SVA-003 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |640 |DATA SVA-004 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |650 |DATA SVA-005 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |660 |DATA SVA-006 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |670 |DATA SVA-007 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |680 |DATA SVA-008 LIKE P0013-SVA01           |
*| |RPD-GET-SVATTRD     |690 |DATA END OF PSVA                        |
*| |RPD-GET-SVATTRD     |700 |TABLES: RPSVA                           |
*----------------------------------------------------------------------