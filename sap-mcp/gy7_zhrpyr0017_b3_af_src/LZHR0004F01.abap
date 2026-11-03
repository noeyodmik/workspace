*----------------------------------------------------------------------*
***INCLUDE LZHR0004F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_RESULT_FROM_RETO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RGDIR  text
*      -->P_RT  text
*      -->P_CRT  text
*      -->P_BT  text
*      -->P_WPBP  text
*      -->P_KRSI  text
*      -->P_AB  text
*      -->P_PRINT_START  text
*      -->P_PRINT_END  text
*      -->P_FLAG  text
*      <--P_RETROYM  text
*----------------------------------------------------------------------*
FORM GET_RESULT_FROM_RETO    TABLES   P_RGDIR   STRUCTURE   PC261
                                      P_RT      STRUCTURE   PC207
                                      P_CRT     STRUCTURE   PC208
                                      P_BT      STRUCTURE   PC209
                                      P_WPBP    STRUCTURE   PC205
                                      P_KRSI    STRUCTURE   PC2H3
                                      P_AB      STRUCTURE   PC20I
                                USING    VALUE(PRINT_START)
                                         VALUE(PRINT_END)
                                         P_FLAG
                                CHANGING P_RETROYM.


  DATA : F_CONTINUE TYPE     C,
         F_EXIT     TYPE     C,
         L_BEGDA    TYPE     D,
         L_ENDDA    TYPE     D.

  DATA   :     XDATA    LIKE     STANDARD   TABLE   OF   PC261
                        WITH     HEADER     LINE.

  RANGES       P_PAYID           FOR      PC261-PAYID.   "급여계산 식별자
  RANGES       P_PAYTY           FOR      PC261-PAYTY.   "급여유형

* Pay type = space Means Regular payroll
  P_PAYTY-LOW       =          ' '.
  P_PAYTY-SIGN      =          'I'.
  P_PAYTY-OPTION    =          'EQ'.
  APPEND P_PAYTY.

  LOOP   AT   P_RGDIR  WHERE    INPER    =     PN_PER.
    CHECK     P_RGDIR-FPPER     =        P_RGDIR-INPER.
    CHECK NOT P_RGDIR-FPPER IS INITIAL.

*급여계산일자 및 기간 산정
    PERFORM   RE549Q            USING    P_RGDIR-IPERM
                                         P_RGDIR-PAYDT(4)
                                         P_RGDIR-PAYDT+4(2).
*                                         P_RGDIR-INPER(4)
*                                         P_RGDIR-INPER+4(2).

    PERFORM   FIND_RGDIR_TRIGGERS        TABLES    P_RGDIR
                                XDATA    P_PAYTY   P_PAYID
                                USING    P_RGDIR-PAYDT P_RGDIR-PAYDT.
*                               USING    T549Q-BEGDA   P_RGDIR-PAYDT.
*                               USING    T549Q-BEGDA   T549Q-ENDDA.
** 소급시작연월 구하기
    CLEAR: P_RETROYM.
    READ TABLE XDATA INDEX 1.
    IF SY-SUBRC  = 0.
      P_RETROYM = XDATA-FPPER.
    ENDIF.

    LOOP      AT         XDATA
      WHERE   INPER             =       '000000'.
      IF      XDATA-INOCC       =       '08'
        AND   XDATA-IPEND       >=       T549Q-BEGDA
        AND   XDATA-IPEND       <=       T549Q-ENDDA.
        DELETE     XDATA.
      ELSEIF  XDATA-PAYTY       NE      SPACE.
        DELETE     XDATA.
      ENDIF.
    ENDLOOP.

    CASE   W_RETRO.
      WHEN    'SUM'.   " 소급분 포함
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '2'.
        PERFORM   MOVE_WTS_TO_RT.
      WHEN    'NOW'.   " 소급분 별도 표기
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB.
      WHEN    'RET'.   " 소급분만 표기
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB1.
    ENDCASE.

    P_RT[]     =   RT[].
    P_CRT[]    =   CRT[].
    P_BT[]     =   BT[].
    P_WPBP[]   =   WPBP[].
    P_KRSI[]   =   KRSI[].
    P_AB[]     =   AB[].
    EXIT.
  ENDLOOP.

** 전월퇴직정산결과 조회
*
*  IF P_FLAG IS NOT INITIAL.
*
*    L_ENDDA           =           TMP_DATE1.
*    L_BEGDA           =           L_ENDDA.
*    L_BEGDA+6(2)      =          '01'.
*
*    P_PAYTY-LOW       =          'B'.
*    P_PAYTY-SIGN      =          'I'.
*    P_PAYTY-OPTION    =          'EQ'.
*
*    APPEND            P_PAYTY.
*
*    LOOP      AT      P_RGDIR
*      WHERE           OCCAT       =       '08'
*        AND           FPBEG      >=        L_BEGDA
*        AND           FPBEG      <=        L_ENDDA.
*
*      CHECK   P_RGDIR-FPPER       =        P_RGDIR-INPER.
*      PERFORM FIND_RGDIR_TRIGGERS TABLES   P_RGDIR  XDATA  P_PAYTY P_PAYID
*                                  USING    L_ENDDA L_ENDDA.
*      LOOP    AT      XDATA
*        WHERE         INPER       =       '000000'.
*        IF            XDATA-INOCC =       '05'
*              OR      XDATA-INOCC =       '09'
*              OR      XDATA-INOCC =       '10'
*              OR      XDATA-INOCC =       '11'.
*          DELETE      XDATA.
*        ENDIF.
*      ENDLOOP.
*
*      CASE   W_RETRO.
*        WHEN    'SUM'.                                "소급분 포함
*          PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '2'.
*          PERFORM   MOVE_WTS_TO_RT.
*        WHEN    'NOW'.                                "소급분 제외
*          PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
*          PERFORM   MOVE_WTS_TO_RT_SOGUB.
*        WHEN    'RET'.                                "소급분만
*          PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
*          PERFORM   MOVE_WTS_TO_RT_SOGUB1.
*      ENDCASE.
*      P_RT[]    =   RT[].
*      EXIT.
*    ENDLOOP.
*
*  ENDIF.

ENDFORM.                    " GET_RESULT_FROM_RETO
FORM GET_RESULT_FROM_RETO_9001    TABLES   P_RGDIR   STRUCTURE   PC261
                                           P_RT      STRUCTURE   PC207
                                           P_CRT     STRUCTURE   PC208
                                           P_BT      STRUCTURE   PC209
                                           P_WPBP    STRUCTURE   PC205
                                           P_KRSI    STRUCTURE   PC2H3
                                           P_AB      STRUCTURE   PC20I
                                  USING    VALUE(PRINT_START)
                                           VALUE(PRINT_END)
                                           P_FLAG
                                           PAYDT
                                  CHANGING P_RETROYM.


  DATA : F_CONTINUE TYPE     C,
         F_EXIT     TYPE     C,
         L_BEGDA    TYPE     D,
         L_ENDDA    TYPE     D.

  DATA   :     XDATA    LIKE     STANDARD   TABLE   OF   PC261
                        WITH     HEADER     LINE.

  RANGES       P_PAYID           FOR      PC261-PAYID.   "급여계산 식별자
  RANGES       P_PAYTY           FOR      PC261-PAYTY.   "급여유형

* Pay type = space Means Regular payroll
  P_PAYTY-LOW       =          ' '.
  P_PAYTY-SIGN      =          'I'.
  P_PAYTY-OPTION    =          'EQ'.
  APPEND P_PAYTY.

  LOOP AT P_RGDIR  WHERE fpper = pn_per
                     AND paydt = paydt.
    CHECK NOT P_RGDIR-FPPER IS INITIAL.

*급여계산일자 및 기간 산정
    PERFORM   RE549Q            USING    P_RGDIR-IPERM
                                         P_RGDIR-PAYDT(4)
                                         P_RGDIR-PAYDT+4(2).
*                                         P_RGDIR-INPER(4)
*                                         P_RGDIR-INPER+4(2).

    PERFORM   FIND_RGDIR_TRIGGERS        TABLES    P_RGDIR
                                XDATA    P_PAYTY   P_PAYID
                                USING    P_RGDIR-PAYDT P_RGDIR-PAYDT.
*                               USING    T549Q-BEGDA   P_RGDIR-PAYDT.
*                               USING    T549Q-BEGDA   T549Q-ENDDA.
** 소급시작연월 구하기
    CLEAR: P_RETROYM.
    READ TABLE XDATA INDEX 1.
    IF SY-SUBRC  = 0.
      P_RETROYM = XDATA-FPPER.
    ENDIF.

    LOOP      AT         XDATA
      WHERE   INPER             =       '000000'.
      IF      XDATA-INOCC       =       '90'
        AND   XDATA-IPEND       >=       T549Q-BEGDA
        AND   XDATA-IPEND       <=       T549Q-ENDDA.
        DELETE     XDATA.
      ELSEIF  XDATA-PAYTY       NE      SPACE.
        DELETE     XDATA.
      ENDIF.
    ENDLOOP.

    CASE   W_RETRO.
      WHEN    'SUM'.   " 소급분 포함
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '2'.
        PERFORM   MOVE_WTS_TO_RT.
      WHEN    'NOW'.   " 소급분 별도 표기
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB.
      WHEN    'RET'.   " 소급분만 표기
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB1.
    ENDCASE.

    P_RT[]     =   RT[].
    P_CRT[]    =   CRT[].
    P_BT[]     =   BT[].
    P_WPBP[]   =   WPBP[].
    P_KRSI[]   =   KRSI[].
    P_AB[]     =   AB[].
    EXIT.
  ENDLOOP.
ENDFORM.
FORM GET_RESULT_FROM_0008    TABLES   P_RGDIR   STRUCTURE   PC261
                                      P_RT      STRUCTURE   PC207
                                      P_CRT     STRUCTURE   PC208
                                      P_BT      STRUCTURE   PC209
                                      P_WPBP    STRUCTURE   PC205
                                      P_KRSI    STRUCTURE   PC2H3
                                      P_AB      STRUCTURE   PC20I
                                USING    VALUE(PRINT_START)
                                         VALUE(PRINT_END)
                                         P_FLAG
                                CHANGING P_RETROYM.


*  DATA :
**F_CONTINUE TYPE     C,
**         F_EXIT     TYPE     C,
*         L_BEGDA    TYPE     D,
*         L_ENDDA    TYPE     D.
*
  DATA   :     XDATA    LIKE     STANDARD   TABLE   OF   PC261
                        WITH     HEADER     LINE.
*
  RANGES       P_PAYID           FOR      PC261-PAYID.   "급여계산 식별자
  RANGES       P_PAYTY           FOR      PC261-PAYTY.   "급여유형
*
** Pay type = space Means Regular payroll
*  P_PAYTY-LOW       =          ' '.
*  P_PAYTY-SIGN      =          'I'.
*  P_PAYTY-OPTION    =          'EQ'.
*  APPEND P_PAYTY.



* 전월퇴직정산결과 조회

  IF P_FLAG IS NOT INITIAL.

*    L_ENDDA           =           TMP_DATE1.
*    L_BEGDA           =           L_ENDDA.
*    L_BEGDA+6(2)      =          '01'.

    P_PAYTY-LOW       =          'B'.
    P_PAYTY-SIGN      =          'I'.
    P_PAYTY-OPTION    =          'EQ'.

    APPEND            P_PAYTY.

*    LOOP      AT      P_RGDIR
*      WHERE           OCCAT       =       '08'
*        AND           FPBEG      >=        L_BEGDA
*        AND           FPBEG      <=        L_ENDDA.

    CHECK   P_RGDIR-FPPER       =        P_RGDIR-INPER.
    PERFORM FIND_RGDIR_TRIGGERS TABLES   P_RGDIR  XDATA  P_PAYTY P_PAYID
                                USING    P_RGDIR-PAYDT P_RGDIR-PAYDT.
    LOOP    AT      XDATA
      WHERE         INPER       =       '000000'.
      IF            XDATA-INOCC =       '05'
            OR      XDATA-INOCC =       '09'
            OR      XDATA-INOCC =       '10'
            OR      XDATA-INOCC =       '11'.
        DELETE      XDATA.
      ENDIF.
    ENDLOOP.

    CASE   W_RETRO.
      WHEN    'SUM'.                                "소급분 포함
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '2'.
        PERFORM   MOVE_WTS_TO_RT.
      WHEN    'NOW'.                                "소급분 제외
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB.
      WHEN    'RET'.                                "소급분만
        PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
        PERFORM   MOVE_WTS_TO_RT_SOGUB1.
    ENDCASE.
    P_RT[]    =   RT[].
    EXIT.
*    ENDLOOP.

  ENDIF.

ENDFORM.                    " GET_RESULT_FROM_RETO
*&amp;---------------------------------------------------------------------*
*&amp;      Form  RE549Q
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_RGDIR_IPERM  text
*      -->P_P_RGDIR_PAYDT(4)  text
*      -->P_P_RGDIR_PAYDT+4(2)  text
*----------------------------------------------------------------------*
FORM RE549Q    USING   P_PERMO   P_YEAR   P_PERIOD.

  CHECK       T549Q-PERMO       <>       P_PERMO
        OR    T549Q-PABRJ       <>       P_YEAR
        OR    T549Q-PABRP       <>       P_PERIOD.

  SELECT      SINGLE     *      FROM     T549Q
     WHERE    PABRJ             EQ       P_YEAR
       AND    PABRP             EQ       P_PERIOD
       AND    PERMO             EQ       P_PERMO.

  IF          SY-SUBRC          <>       0.           "no entry found?
    CLEAR             T549Q.
  ENDIF.
ENDFORM.                    " RE549Q
*&amp;---------------------------------------------------------------------*
*&amp;      Form  FIND_RGDIR_TRIGGERS
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_RGDIR  text
*      -->P_XDATA  text
*      -->P_P_PAYTY  text
*      -->P_P_PAYID  text
*      -->P_T549Q_BEGDA  text
*      -->P_T549Q_ENDDA  text
*----------------------------------------------------------------------*
FORM FIND_RGDIR_TRIGGERS
              TABLES     $RGDIR    STRUCTURE    PC261
                         $XDATA    STRUCTURE    PC261
                         P_PAYTY   STRUCTURE    PAYTY_CD
                         P_PAYID   STRUCTURE    PAYTY_CD
              USING      P_BEGDA   P_ENDDA.

  DATA : SEL_EVP LIKE     PC261,
         XEVP    LIKE     STANDARD  TABLE  OF  PC261,
         TMP_EVP LIKE     STANDARD  TABLE  OF  PC261,
         RETRO   TYPE     C,
         INDEX   LIKE     SY-INDEX.
  REFRESH     $XDATA.

  XEVP        =                 $RGDIR[].

  CALL FUNCTION 'CD_SELECT_PAYTY_RANGE'
    TABLES
      IN_RGDIR  = XEVP
      OUT_RGDIR = TMP_EVP
      PAYTY_TAB = P_PAYTY.

  CALL FUNCTION 'CD_SELECT_PAYID_RANGE'
    TABLES
      IN_RGDIR  = TMP_EVP
      OUT_RGDIR = XEVP
      PAYID_TAB = P_PAYID.
* 급여일자가 급여기간안에 없을경우 삭제
  DELETE      XEVP
    WHERE  NOT  PAYDT  BETWEEN   P_BEGDA  AND  P_ENDDA.
*      OR   ABKRS    NE  PERNR_ABKRS.
*      AND  NOT  ABKRS  =        PERNR-ABKRS .

*** get original records
  LOOP   AT   XEVP    INTO      SEL_EVP.
    CALL FUNCTION 'CD_RETROCALC_PERIOD'
      EXPORTING
        ENTRY = SEL_EVP
      IMPORTING
        CALCD = RETRO.
    IF   RETRO        NE        SPACE.
      DELETE       XEVP.
    ENDIF.
  ENDLOOP.

  SORT        XEVP    BY        INPER  IPERM  INPID  INPTY  BONDT.

  DELETE      ADJACENT          DUPLICATES    FROM   XEVP
              COMPARING   INPER IPERM INPID INPTY BONDT.

  SORT        XEVP    BY        SEQNR.

  LOOP   AT   XEVP    INTO      SEL_EVP.
    INDEX   =         SY-TABIX.
    CLEAR             TMP_EVP.
    PERFORM   FILL_EVP  TABLES  $RGDIR  TMP_EVP  USING  SEL_EVP.
    LOOP AT   TMP_EVP INTO      $XDATA.
*             $xdata-sortn      =       index.
      APPEND            $XDATA.
    ENDLOOP.
  ENDLOOP.
*  SORT $xdata BY inper iperm inpid inpty bondt.
*  DELETE ADJACENT DUPLICATES FROM $xdata
*         COMPARING inper iperm inpid inpty bondt.
ENDFORM.                    " FIND_RGDIR_TRIGGERS
*&amp;---------------------------------------------------------------------*
*&amp;      Form  FILL_EVP
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_$RGDIR  text
*      -->P_TMP_EVP  text
*      -->P_SEL_EVP  text
*----------------------------------------------------------------------*
FORM FILL_EVP
              TABLES     IN_TAB    STRUCTURE    PC261
                         OUT_TAB   STRUCTURE    PC261
              USING      VALUE($SELDT)  LIKE    PC261.

  REFRESH     OUT_TAB.
*----------------------------------------------------------------------*
* fills internal table EVP for respective personnel number             *
*----------------------------------------------------------------------*
  CALL FUNCTION 'CD_EVALUATION_PERIODS'
    EXPORTING
      BONUS_DATE      = $SELDT-BONDT             "$bondt
      INPER           = $SELDT-INPER             "period
      INPER_MODIF     = $SELDT-IPERM             "pn-permo
      PAY_IDENT       = $SELDT-INPID             "$payid
      PAY_TYPE        = $SELDT-INPTY             "$payty
    TABLES
      EVPDIR          = OUT_TAB
      RGDIR           = IN_TAB
    EXCEPTIONS
      NO_RECORD_FOUND = 01.
ENDFORM.                    " FILL_EVP
*&amp;---------------------------------------------------------------------*
*&amp;      Form  PROCESS_EVP
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_XDATA  text
*      -->P_0125   text
*----------------------------------------------------------------------*
FORM   PROCESS_EVP    TABLES   $EVP     STRUCTURE  PC261  USING  OPTION.
  DATA   :     EVP               LIKE     PC261.
  DATA   :
    PRINT_RETRO TYPE     C,
    RETROCALC   TYPE     C,
    OKAY        TYPE     C.

  LOOP  AT   $EVP
    WHERE    SRTZA             EQ      'A'.
    EVP               =        $EVP.
    OKAY              =        SPACE.
    PERFORM      IMPORT_RESULTS
                 USING        $EVP     CHANGING  RETROCALC.

    PERFORM      EDIT_PERIOD
                 USING OPTION RETROCALC VERSC-FPBEG VERSC-FPEND.

  ENDLOOP.
ENDFORM.                    " PROCESS_EVP
*&amp;---------------------------------------------------------------------*
*&amp;      Form  IMPORT_RESULTS
*&amp;---------------------------------------------------------------------*
*      -->P_$EVP  text
*      <--P_RETROCALC  text
*----------------------------------------------------------------------*
FORM    IMPORT_RESULTS         USING    VALUE($EVP) LIKE PC261
            CHANGING  RECALC   TYPE     C.
  DATA   :    RC                 LIKE     SY-SUBRC.

  REFRESH: RT, ORT.

  PERFORM   IMPORT_ACTUAL      USING    $EVP    RC.
  IF        RC                 =        0.
    PERFORM     SET_RECALC     USING    $EVP    RECALC.

    IF      RECALC             NE       SPACE .         "Retro-acrtvie?
      PERFORM  IMPORT_PREVIOUS         USING   $EVP.
    ENDIF.
  ENDIF.

ENDFORM.                    " IMPORT_RESULTS

*&amp;---------------------------------------------------------------------*
*&amp;      Form  IMPORT_ACTUAL
*&amp;---------------------------------------------------------------------*
*      -->P_$EVP  text
*      -->P_RC  text
*----------------------------------------------------------------------*
FORM   IMPORT_ACTUAL           USING    VALUE($EVP) LIKE PC261
            RC                 LIKE     SY-SUBRC.

  RX-KEY-PERNR            =        W_PERNR.
  RX-KEY-SEQNO            =        $EVP-SEQNR.
  RP-IMP-C2-KR.
  RC                      =        RP-IMP-KR-SUBRC.


ENDFORM.                    " IMPORT_ACTUAL
*&amp;---------------------------------------------------------------------*
*&amp;      Form  SET_RECALC
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_$EVP  text
*      -->P_RECALC  text
*----------------------------------------------------------------------*
FORM   SET_RECALC    USING     VALUE($EVP)   STRUCTURE    PC261
                     $RECALC   TYPE     C.
  CALL FUNCTION 'CD_RETROCALC_PERIOD'
    EXPORTING
      ENTRY  = $EVP
    IMPORTING
      CALCD  = $RECALC
    EXCEPTIONS
      OTHERS = 1.
ENDFORM.                    " SET_RECALC
*&amp;---------------------------------------------------------------------*
*&amp;      Form  IMPORT_PREVIOUS
*&amp;---------------------------------------------------------------------*
*      -->P_$EVP  text
*----------------------------------------------------------------------*
FORM   IMPORT_PREVIOUS   USING    VALUE($EVP)   STRUCTURE   PC261.

  DATA  :     BEGIN       OF       OUT_RGDIR     OCCURS      50.
                INCLUDE     STRUCTURE    PC261.
              DATA  :     END         OF       OUT_RGDIR.
  DATA  :     WOK-PAYDT   LIKE     P0000-BEGDA.
  DATA  :     WOK-OCRSN(4).
  DATA  :     WOK-INPER(6).
  DATA  :     WOK-FPPER(6).
  DATA  :     WOK-PAYID(1).

  WOK-PAYDT             =        RGDIR-PAYDT.
  WOK-OCRSN             =        RGDIR-OCRSN.
  WOK-PAYID             =        RGDIR-PAYID.

  WOK-INPER             =        RGDIR-INPER.
  WOK-FPPER             =        RGDIR-FPPER.

  CALL FUNCTION 'CD_READ_PREVIOUS'
    EXPORTING
      IN_RECORD = $EVP
      EXACT     = 'X'
    TABLES
      RGDIR     = RGDIR
      OUT_RGDIR = OUT_RGDIR
    EXCEPTIONS
      OTHERS    = 1.

  IF   SY-SUBRC         EQ       0.
    PERFORM          IMPORT_OLD-NATIO    USING     OUT_RGDIR.
  ENDIF.

  RGDIR-PAYDT           =        WOK-PAYDT.
  RGDIR-OCRSN           =        WOK-OCRSN.
  RGDIR-PAYID           =        WOK-PAYID.

  RGDIR-INPER           =        WOK-INPER.
  RGDIR-FPPER           =        WOK-FPPER.

ENDFORM.                    " IMPORT_PREVIOUS
*&amp;---------------------------------------------------------------------*
*&amp;      Form  IMPORT_OLD-NATIO
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OUT_RGDIR  text
*----------------------------------------------------------------------*
FORM IMPORT_OLD-NATIO     USING    VALUE($EVP)   STRUCTURE  PC261.

  ORX-KEY-PERNR         =         W_PERNR.
  ORX-KEY-SEQNO         =         $EVP-SEQNR.

  RP-IMP-C2-KR-O.
  IF    RP-IMP-KR-SUBRC NE        0.
    PERFORM         REFRESH_OLD-NATIO.
  ENDIF.

ENDFORM.                    " IMPORT_OLD-NATIO
*&amp;---------------------------------------------------------------------*
*&amp;      Form  REFRESH_OLD-NATIO
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM REFRESH_OLD-NATIO .
  RP-REF-C2-KR-O.
ENDFORM.                    " REFRESH_OLD-NATIO
*&amp;---------------------------------------------------------------------*
*&amp;      Form  EDIT_PERIOD
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OPTION  text
*      -->P_RETROCALC  text
*      -->P_VERSC_FPBEG  text
*      -->P_VERSC_FPEND  text
*----------------------------------------------------------------------*
FORM EDIT_PERIOD      USING     VALUE(OPTION)    VALUE($RETROCALC)
                                VALUE($FPBEG)    VALUE($FPEND).
  DATA : E_FPBEG TYPE     D,
         E_FPEND TYPE     D.

  IF   $RETROCALC              =       'X'.            "RR?
    CASE  OPTION.
      WHEN '1'.
        MOVE  '19000101'  TO       E_FPBEG.
        MOVE  '99991231'  TO       E_FPEND.
      WHEN '2'.
        MOVE   $FPBEG     TO       E_FPBEG.
        MOVE   $FPEND     TO       E_FPEND.
    ENDCASE.

    PERFORM      COPY-RT-TO-RT_2     USING   E_FPBEG   E_FPEND.
    PERFORM      COPY-ORT-TO-RT_2    USING   E_FPBEG   E_FPEND.
  ELSE.
    PERFORM      COPY-RT-TO-RT_2     USING   $FPBEG    $FPEND.
    PERFORM      DELETE-FROM-RT_2.
  ENDIF.

ENDFORM.                    " EDIT_PERIOD
*&amp;---------------------------------------------------------------------*
*&amp;      Form  COPY-RT-TO-RT_2
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_FPBEG  text
*      -->P_E_FPEND  text
*----------------------------------------------------------------------*
FORM COPY-RT-TO-RT_2         USING    VALUE($FPBEG) VALUE($FPEND).
  DATA   :     $RT_2             LIKE     LINE  OF  RT_2.
  LOOP       AT     RT.
    $RT_2             =        RT.
    $RT_2-FPBEG       =        $FPBEG.
    $RT_2-FPEND       =        $FPEND.
    APPEND  $RT_2     TO       RT_2.
  ENDLOOP.
ENDFORM.                    " COPY-RT-TO-RT_2
*&amp;---------------------------------------------------------------------*
*&amp;      Form  COPY-ORT-TO-RT_2
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_FPBEG  text
*      -->P_E_FPEND  text
*----------------------------------------------------------------------*
FORM COPY-ORT-TO-RT_2        USING   VALUE($FPBEG)   VALUE($FPEND).

  LOOP       AT    ORT.
    RT_2              =       ORT.
    RT_2-FPBEG        =       $FPBEG.
    RT_2-FPEND        =       $FPEND.
    RT_2-ANZHL        =       - ORT-ANZHL.
    RT_2-BETRG        =       - ORT-BETRG.
    IF       RT_2-BETRG        EQ      0
       AND   RT_2-ANZHL        EQ      0.
      RT_2-BETPE        =       0.
    ELSE.
      RT_2-BETPE        =       - ORT-BETPE.
    ENDIF.
*     collect rt_2.
    APPEND   RT_2.                                 "VKIK131798b
  ENDLOOP.

ENDFORM.                    " COPY-ORT-TO-RT_2
*&amp;---------------------------------------------------------------------*
*&amp;      Form  DELETE-FROM-RT_2
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE-FROM-RT_2 .
  LOOP  AT    RT_2
    WHERE     ANZHL            EQ       0
      AND     BETPE            EQ       0
      AND     BETRG            EQ       0.
    RT_2-DELET       =       'X'.
    MODIFY           RT_2.
  ENDLOOP.
ENDFORM.                    " DELETE-FROM-RT_2
*&amp;---------------------------------------------------------------------*
*&amp;      Form  GET_RESULTS
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RGDIR  text
*----------------------------------------------------------------------*
FORM GET_RESULTS             TABLES   P_RT      STRUCTURE   PC207
                                      P_CRT     STRUCTURE   PC208
                                      P_BT      STRUCTURE   PC209
                                      P_WPBP    STRUCTURE   PC205
                              USING   $RGDIR    STRUCTURE   PC261.



  RX-KEY-PERNR               =        W_PERNR.
  UNPACK  $RGDIR-SEQNR       TO       RX-KEY-SEQNO.

  IMPORT  KR-VERSION         TO       OKR-VERSION
                                      RT
                                      CRT
                                      WPBP
                                      BT
          FROM    DATABASE   PCL2(KR) ID  RX-KEY.

  IF      RP-IMP-KR-SUBRC    NE       0.
    MESSAGE            E327(PN).
  ELSE.
    P_RT[]   =  RT[].
    P_CRT[]  =  CRT[].
    P_BT[]   =  BT[].
    P_WPBP[] =  WPBP[].
  ENDIF.


ENDFORM.                    " GET_RESULTS
*&amp;---------------------------------------------------------------------*
*&amp;      Form  MOVE_WTS_TO_RT
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MOVE_WTS_TO_RT .

  DATA : RETRO_AMT  LIKE RT-BETRG.
  DATA : BONUS      LIKE RT-BETRG.

  DATA : BEGIN      OF  WK_RT    OCCURS  0.
           INCLUDE    STRUCTURE    PC207 .
         DATA : END        OF  WK_RT .

  DATA : BEGIN      OF  WK_RT1   OCCURS  0.
           INCLUDE    STRUCTURE    PC207 .
         DATA : END        OF  WK_RT1 .

  DATA : BEGIN      OF  WK1_RT   OCCURS  0.
           INCLUDE    STRUCTURE    PC207 .
         DATA : END        OF  WK1_RT .

  DATA : BEGIN      OF  WK2_RT   OCCURS  0.
           INCLUDE    STRUCTURE    PC207 .
         DATA : END        OF  WK2_RT .

  CLEAR          RT.
  REFRESH        RT.

  LOOP    AT     RT_2.
    CASE    RT_2-LGART.
      WHEN '/001'.            "시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT.
      WHEN '/002'.            "통상시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT1.
      WHEN '/4MG'.            "기본임금
        MOVE-CORRESPONDING        RT_2      TO     WK1_RT.
      WHEN '/LLB'.            "대출 뱔런스
        MOVE-CORRESPONDING        RT_2      TO     WK2_RT.
      WHEN  OTHERS.
        MOVE-CORRESPONDING        RT_2      TO     RT.
        COLLECT      RT.
    ENDCASE.
  ENDLOOP.

  MOVE-CORRESPONDING        WK_RT     TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK_RT1    TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK1_RT    TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK2_RT    TO     RT.
  COLLECT      RT.

  CLEAR          RT_2.
  REFRESH        RT_2.
  CLEAR          ORT.
  REFRESH        ORT.

ENDFORM.                    " MOVE_WTS_TO_RT
*&amp;---------------------------------------------------------------------*
*&amp;      Form  MOVE_WTS_TO_RT_SOGUB
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MOVE_WTS_TO_RT_SOGUB .

  DATA : LT_T511 TYPE TABLE OF T511 WITH HEADER LINE. " 2018.04.10 추가

  DATA : RETRO_AMT  LIKE   RT-BETRG.
  DATA : BONUS      LIKE   RT-BETRG.

  DATA : BEGIN  OF  WK_RT  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK_RT .

  DATA : BEGIN  OF  WK_RT1  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK_RT1 .

  DATA : BEGIN  OF  WK1_RT  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK1_RT .
  DATA : BEGIN  OF  WK2_RT  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK2_RT .

  CLEAR          RT.
  REFRESH        RT.

  "지급 임금유형 가져오기
  CLEAR: LT_T511, LT_T511[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_T511
    FROM T511
   WHERE MOLGA = '41'
     AND ENDDA = '99991231'
     AND LGART BETWEEN '1000' AND '8999'
     AND OPKEN <> 'A'.

  LOOP    AT     RT_2.

    CASE RT_2-LGART.
      WHEN '/001'.            "시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT.
      WHEN '/002'.            "통상시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT1.
      WHEN '/4MG'.            "건강보험등급
        MOVE-CORRESPONDING        RT_2      TO     WK1_RT.
      WHEN '/LLB'.            "대출 밸런스
        MOVE-CORRESPONDING        RT_2      TO     WK2_RT.
      WHEN '2900' OR '4900'.   "기지급금, 인정상여   소급분에서 제외
        MOVE-CORRESPONDING        RT_2      TO     RT.
        COLLECT      RT.
      WHEN OTHERS.

        CLEAR LT_T511.
        READ TABLE LT_T511 WITH KEY LGART = RT_2-LGART.

        IF SY-SUBRC = 0.
*    WHEN '1000' OR '1100' OR '1200' OR '1300' OR '1400' OR
*         '1500' OR '1900' OR
*         '2000' OR '2100' OR '2200' OR '2300' OR '2500' OR
*         '2600' OR '2900' OR
*         '3000' OR '3100' OR '3200' OR '3210' OR '3300' OR
*         '3310' OR '3400' OR '3410' OR '3500' OR '3510' OR
*         '3700' OR '3710' OR '3720' OR
*         '4000' OR '4100' OR '4200' OR '4300' OR
*         '5000' OR '5100' OR '5200' OR '5300' OR '5500' .

          IF   RT_2-FPBEG   =  '19000101'.
            RETRO_AMT    =   RETRO_AMT + RT_2-BETRG.
          ELSE.
            MOVE-CORRESPONDING        RT_2      TO     RT.
            COLLECT      RT.
          ENDIF.

        ELSE.
          MOVE-CORRESPONDING        RT_2      TO     RT.
          COLLECT      RT.
        ENDIF.

    ENDCASE.


  ENDLOOP.


  MOVE-CORRESPONDING        WK_RT     TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK_RT1    TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK1_RT    TO     RT.
  COLLECT      RT.

  IF RETRO_AMT NE 0.
    RT-BETRG  =  RETRO_AMT.
    RT-LGART  = 'RTRO'.
    COLLECT      RT.
  ENDIF.

  CLEAR          RT_2.
  REFRESH        RT_2.
  CLEAR          ORT.
  REFRESH        ORT.

ENDFORM.                    " MOVE_WTS_TO_RT_SOGUB
*&amp;---------------------------------------------------------------------*
*&amp;      Form  MOVE_WTS_TO_RT_SOGUB1
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MOVE_WTS_TO_RT_SOGUB1 .
  DATA : LT_T511 TYPE TABLE OF T511 WITH HEADER LINE. " 2018.07.23 추가

  DATA : RETRO_AMT LIKE RT-BETRG.
  DATA : BONUS LIKE RT-BETRG.

  CLEAR          RT.
  REFRESH        RT.


  "지급 임금유형 가져오기
  CLEAR: LT_T511, LT_T511[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_T511
    FROM T511
   WHERE MOLGA = '41'
     AND ENDDA = '99991231'
     AND LGART BETWEEN '1000' AND '8999'
     AND OPKEN <> 'A'.


  LOOP    AT     RT_2.

    CLEAR LT_T511.
    READ TABLE LT_T511 WITH KEY LGART = RT_2-LGART.

    IF SY-SUBRC = 0.

*    CASE RT_2-LGART.
*
*    WHEN '1000' OR '1100' OR '1200' OR '1300' OR '1400' OR
*         '1500' OR '1900' OR
*         '2000' OR '2100' OR '2200' OR '2300' OR '2500' OR
*         '2600' OR '2900' OR
*         '3000' OR '3100' OR '3200' OR '3210' OR '3300' OR
*         '3310' OR '3400' OR '3410' OR '3500' OR '3510' OR
*         '3700' OR '3710' OR '3720' OR
*         '4000' OR '4100' OR '4200' OR '4300' OR
*         '5000' OR '5100' OR '5200' OR '5300' OR '5500' .
*           '/301' OR '/302' OR '/4UE'.

      IF  RT_2-FPBEG = '19000101'.
        MOVE-CORRESPONDING        RT_2      TO     RT.
        COLLECT      RT.
      ENDIF.

    ENDIF.
*    ENDCASE.
  ENDLOOP.

  CLEAR          RT_2.
  REFRESH        RT_2.
  CLEAR          ORT.
  REFRESH        ORT.

ENDFORM.                    "MOVE_WTS_TO_RT_SOGUB1
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR_DATA .
  CLEAR: RT, CRT, WPBP.
  REFRESH: RT, CRT, WPBP.

ENDFORM.                    " CLEAR_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_PAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_REGULAR USING RT TYPE PC207.


  CASE RT-LGART.
*----------------------------------------------------------------------*
*   지급급액관련
*----------------------------------------------------------------------*
    WHEN '/559'.
      ADD RT-BETRG TO WA-P50.   "은행이체 금액

    WHEN '/001'.
      WA-BET01 = RT-BETPE.      "통상시급

    WHEN '/002'.
      WA-BET02 = RT-BETPE.      "전월시급

    WHEN '/4WD'.
      ADD RT-ANZHL TO WA-H00.   "근무일수

    WHEN '/3T1'.
      ADD RT-BETRG TO WA-P99.   "과세소득총액

    WHEN '1000'.
      ADD RT-BETRG TO WA-P01.   "기본급
      ADD RT-ANZHL TO WA-T01.   "기본시간

    WHEN '1100'.
      ADD RT-BETRG TO WA-P02.   "기본연장급

    WHEN '1200'.
      ADD RT-BETRG TO WA-P03.   "능력급

      "    WHEN ''.
      "      ADD RT-BETRG TO WA-P04.   "

    WHEN '1300'.
      ADD RT-BETRG TO WA-P05.   "식대수당

    WHEN '1400'.
      ADD RT-BETRG TO WA-P06.   "현장직무수당

    WHEN '1900'.
      ADD RT-BETRG TO WA-P07.   "급지수당

**  20260320 AI 수당 추가
    WHEN '1920'.
      ADD RT-BETRG TO WA-P32.

    WHEN '1500'.
      ADD RT-BETRG TO WA-P08.   "자격증수당

    WHEN '2000' OR '2010'.
      ADD RT-BETRG TO WA-P09.   "직책선임수당

    WHEN '2300'.
      ADD RT-BETRG TO WA-P10.   "해외근무수당

    WHEN '2700'.
      ADD RT-BETRG TO WA-P12.   "기타수당

    WHEN '2100'.
      ADD RT-BETRG TO WA-P13.   "당직수당

    WHEN '3600'.
      ADD RT-BETRG TO WA-P15.   "특근수당(휴일근무)
      ADD RT-ANZHL TO WA-T04.   "휴일근무시간

    WHEN '3610'.
      ADD RT-BETRG TO WA-P15.   "특근초과수당(휴일근무)
      ADD RT-ANZHL TO WA-T05.   "휴일연장근무


    WHEN '2800'.
      ADD RT-BETRG TO WA-P16.   "조정급(전월미지급분)

    WHEN '3100'.
      ADD RT-BETRG TO WA-P17.   "연장수당
      ADD RT-ANZHL TO WA-T02.   "연장시간

    WHEN '3200'.
      ADD RT-BETRG TO WA-P18.   "야간근무수당
      ADD RT-ANZHL TO WA-T03.   "야간근무시간

    WHEN '3300' OR '1600'.
      ADD RT-BETRG TO WA-P19.   "현장휴일근로수당


    WHEN '3400'.
      ADD RT-BETRG TO WA-P20.   "휴일연장수당
      ADD RT-ANZHL TO WA-T05.   "휴일연장시간

    WHEN '3500'.
      ADD RT-BETRG TO WA-P21.   "석식대수당
      ADD RT-ANZHL TO WA-T06.   "석식대일수

    WHEN '3700' OR '3710'.
      ADD RT-BETRG TO WA-P22.   "연차수당
      ADD RT-ANZHL TO WA-T07.   "연차일수


    WHEN '4000'.
      ADD RT-BETRG TO WA-P23.   "정기상여
      ADD RT-ANZHL TO WA-T07.   "지급율

    WHEN '4100' OR '4200'.
      ADD RT-BETRG TO WA-P25.   "특별 성과급
      ADD RT-ANZHL TO WA-T07.   "지급율

    WHEN '4300'.                                            " #5369 추가
      ADD RT-BETRG TO WA-P27.   "특별 성과급   #6508 수정
      ADD RT-ANZHL TO WA-T07.   "지급율
      ADD RT-BETRG TO WA-B10.   "비과세합계   #5390 추가

    WHEN '4400'.                                            " #5951 추가
      ADD RT-BETRG TO WA-P26.   "휴가비

      "    WHEN ''.
      "      ADD RT-BETRG TO WA-P25.   "
      "      ADD RT-ANZHL TO WA-T07.   "지급율


    WHEN '2900'.
      ADD RT-BETRG TO WA-P30.   "기지급금 과세처리

    WHEN '4900'.
      ADD RT-BETRG TO WA-P31.   "인정상여 과세처리


    WHEN '/RPA' OR '/RPR'.         " 사용자 RP 부담금
      ADD RT-BETRG TO WA-P98.      " 퇴직연금 고용주 부담금
    WHEN '/RPD'.                   " 사용자 손익이연 RP 부담금 공제
      WA-P98  =  WA-P98 - RT-BETRG.

*----------------------------------------------------------------------*
*   비과세소득
*----------------------------------------------------------------------*
    WHEN '/3N2'.
      ADD RT-BETRG TO WA-B01.   "식대비과세

    WHEN '/3N8'.
      ADD RT-BETRG TO WA-B02.   "차량유지비

    WHEN '/3N7'.
      ADD RT-BETRG TO WA-B03.   "연구비비과세

    WHEN '/3N3'.
      ADD RT-BETRG TO WA-B04.   "초과근로비과세

    WHEN '/3NA'.
      ADD RT-BETRG TO WA-B05.   "자녀양육비비과세

    WHEN '/3NR'.
      ADD RT-BETRG TO WA-B06.   "직무발명보상금비과세

    WHEN '/3N9'.
      ADD RT-BETRG TO WA-B10.   "비과세합계


*----------------------------------------------------------------------*
*   공제관련 (개인부담금)
*----------------------------------------------------------------------*
    WHEN '/301'.
      ADD RT-BETRG TO WA-D01.      "소득세 (/301)
      ADD RT-BETRG TO WA-D01_2.    "소득세 합계 (/301, /3QI, /3RI)

    WHEN '/302'.
      ADD RT-BETRG TO WA-D02.      "주민세 (/302)
      ADD RT-BETRG TO WA-D02_2.    "주민세 합계 (/302, /3QR, /3RR)

    WHEN '/3QI'.
      IF WA-D01_1 IS INITIAL.
        ADD RT-BETRG TO WA-D01_1.    "퇴직소득세 정산 (/3QI, /3RI)
        ADD RT-BETRG TO WA-D01_2.    "소득세 합계 (/301, /3QI, /3RI)
      ENDIF.
    WHEN '/3QR'.
      IF WA-D02_1 IS INITIAL.
        ADD RT-BETRG TO WA-D02_1.    "퇴직주민세 정산 (/3QR, /3RR) 9002
        ADD RT-BETRG TO WA-D02_2.    "주민세 합계 (/302, /3QR, /3RR)

      ENDIF.
*    WHEN '/YAI'.
*      IF wa-d01_1 IS INITIAL.
*        ADD rt-betrg TO wa-d01_1.    "소득세 정산
*        ADD rt-betrg TO wa-d01_2.    "소득세 합계
*      ENDIF.
*    WHEN '/YAR'.
*      IF wa-d02_1 IS INITIAL.
*        ADD rt-betrg TO wa-d02_1.    "주민세 정산
*        ADD rt-betrg TO wa-d02_2.    "주민세 합계
*      ENDIF.
    WHEN '/3RI'.
      ADD RT-BETRG TO WA-D01_9.    "연말정산 소득세 (/3QI, /3RI)
      ADD RT-BETRG TO WA-D01_2.    "소득세 합계 (/301, /3QI, /3RI)

    WHEN '/3RR'.
      ADD RT-BETRG TO WA-D02_9.    "연말정산 주민세 (/3QR, /3RR) 9002
      ADD RT-BETRG TO WA-D02_2.    "주민세 합계 (/302, /3QR, /3RR)

    WHEN '/4PE'.
      ADD RT-BETRG TO WA-D03.      "국민연금 (/4PE)

    WHEN '/4ME'.
      ADD RT-BETRG TO WA-D04.      "건강보험 (/4ME)
      ADD RT-BETRG TO WA-D04_2.    "건강보험 합계 (/4ME, /4N5, HD03)

    WHEN '/4N5' OR 'HD03'.
      ADD RT-BETRG TO WA-D04_1.    "건강보험 정산 (/4N5, HD03)
      ADD RT-BETRG TO WA-D04_2.    "건강보험 합계 (/4ME, /4N5, HD03)

    WHEN '/4TE'.
      ADD RT-BETRG TO WA-D05.      "장기요양 (/4TE)
      ADD RT-BETRG TO WA-D05_2.    "장기요양 합계 (/4TE, /4T5, LE03)

    WHEN '/4T5' OR 'LE03'.
      ADD RT-BETRG TO WA-D05_1.    "장기요양 정산 (/4T5, LE03)
      ADD RT-BETRG TO WA-D05_2.    "장기요양 합계 (/4TE, /4T5, LE03)

    WHEN '/4UE'.
      ADD RT-BETRG TO WA-D06.      "고용보험 (/4UE)
      ADD RT-BETRG TO WA-D06_2.    "고용보험 합계 (/4UE, /4FE),/4U5

    WHEN '2810'.   " 사원고용보험조정
      SUBTRACT RT-BETRG FROM WA-D06.      "고용보험 (/4UE)
      SUBTRACT RT-BETRG FROM WA-D06_2.    "고용보험 합계 (/4UE, /4FE),/4U5

    WHEN '/4FE' OR '/4U3' OR '/4U5'.
      ADD RT-BETRG TO WA-D06_1.    "고용보험 정산 (/4FE)/4U5
      ADD RT-BETRG TO WA-D06_2.    "고용보험 합계 (/4UE, /4FE)/4U5


      "    WHEN ''.
      "      WA-D07 = WA-D07 - RT-BETRG.  "

    WHEN '5200'.
      WA-D08 = WA-D08 - RT-BETRG.  "주차비공제

    WHEN '5300'.
      WA-D09 = WA-D09 - RT-BETRG.  "구내식당

    WHEN '5500'.
      WA-D10 = WA-D10 - RT-BETRG.  "린라운지 공제

    WHEN '5600'.
      WA-D11 = WA-D11 - RT-BETRG.  "통근버스 공제

    WHEN '5700' OR '5800'.
      WA-D12 = WA-D12 - RT-BETRG.  "복지월상환금

    WHEN '5710' OR '5810'.
      WA-D13 = WA-D13 - RT-BETRG.  "복지대출이자

    WHEN '5400' OR '5410'.
      WA-D14 = WA-D14 - RT-BETRG.  "경조비 공제

    WHEN '5000'.
      WA-D15 = WA-D15 - RT-BETRG.  "기타공제

    WHEN '5100'.
      WA-D16 = WA-D16 - RT-BETRG.  "학자금대출 상환

    WHEN '6000'.
      WA-D17 = WA-D17 - RT-BETRG.  "임원통신비 공제


    WHEN '/LLB' OR  '/LEX'.
      ADD RT-BETRG  TO  WA-D999.    "대출 밸랜스(잔액)


    WHEN 'RTRO'.
      ADD RT-BETRG TO WA-R_TOTAL.  "소급분

    WHEN '/4PR'.
      ADD RT-BETRG TO WA-C01.   "고용주 국민 보험료
    WHEN '/4MR' OR '/4N6' OR 'HD04'.
      ADD RT-BETRG TO WA-C02.   "건강 보험료 고용주 분담금
    WHEN '/4TR' OR '/4T6' OR 'LE04'.
      ADD RT-BETRG TO WA-C04.   "장기요양 고용주 분담금
    WHEN '/4UR' OR '/4FR' OR '/4U4' OR '/4U6'.
      ADD RT-BETRG TO WA-C03.   "고용주 고용 보험료
    WHEN '/4WR' OR '/4FW' OR '/4W4' OR '/4W6'.
      ADD RT-BETRG TO WA-C05.   "고용주 산재 보험료

  ENDCASE.


ENDFORM.                    " GET_PAY
*&---------------------------------------------------------------------*
*&      Form  GET_BONUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_BONUS USING RT TYPE PC207.

  CASE RT-LGART.
*----------------------------------------------------------------------*
*   지급급액관련
*----------------------------------------------------------------------*
    WHEN '/559'.
      ADD RT-BETRG TO WA-P50.   "은행이체 금액

    WHEN '/001'.
      WA-BET01 = RT-BETPE.      "통상시급

    WHEN '/002'.
      WA-BET02 = RT-BETPE.      "기본시급


    WHEN '/3T1'. "
      ADD RT-BETRG TO WA-P99.   "과세소득총액


    WHEN '3700' OR '3710'.
      ADD RT-BETRG TO WA-P22.   "연차수당
      ADD RT-ANZHL TO WA-T08.   "연차일수

    WHEN '4000'.
      ADD RT-BETRG TO WA-P23.   "정기상여
      ADD RT-ANZHL TO WA-T08.   "지급율
      WA-BET01 = RT-ANZHL / 100.    "통상시급에 지급율 표시

    WHEN '4100'.
      ADD RT-BETRG TO WA-P25.   "특별성과급
      ADD RT-ANZHL TO WA-T08.   "지급율
      WA-BET01 = RT-ANZHL / 100.    "통상시급에 지급율 표시

* 20251027 SEPPIN
*4200 특별성과급(소장활동비) 과세소득총액에 합산
    WHEN '4200'.
      ADD RT-BETRG TO WA-P99.   "과세소득총액

      ADD RT-BETRG TO WA-P25.   "특별성과급
      ADD RT-ANZHL TO WA-T08.   "지급율
      WA-BET01 = RT-ANZHL / 100.    "통상시급에 지급율 표시

    WHEN '4300'.                " #6508 4300 분리
      ADD RT-BETRG TO WA-P27.   "특별성과급(비과세)
      ADD RT-ANZHL TO WA-T08.   "지급율
      WA-BET01 = RT-ANZHL / 100.    "통상시급에 지급율 표시

    WHEN '4400'.                                            " #5951 추가
      ADD RT-BETRG TO WA-P26.   "휴가비

      "    WHEN ''.
      "      ADD RT-BETRG TO WA-P25.   "
      "      ADD RT-ANZHL TO WA-T08.   "지급율
    "20260901 신규 임금유형 '포상금' 추가 SEPPIN-KDY
    WHEN '4500'.  "포상금
      ADD: RT-BETRG TO WA-P99,  "과세소득총액
           RT-BETRG TO WA-P29,  "포상금
           RT-ANZHL TO WA-T08.  "지급율

      WA-BET01 = RT-ANZHL / 100.  "통상시급에 지급율 표시
    WHEN '2900'.
      ADD RT-BETRG TO WA-P30.   "기지급금 과세처리

    WHEN '4900'.
      ADD RT-BETRG TO WA-P31.   "인정상여 과세처리

    WHEN '2710'. "20250515 추가
      ADD RT-BETRG TO WA-P28.   "기타수당(과세X)


*----------------------------------------------------------------------*
*   비과세관련
*----------------------------------------------------------------------*
    WHEN '/3N2'.
      ADD RT-BETRG TO WA-B01.   "식대비과세

    WHEN '/3N8'.
      ADD RT-BETRG TO WA-B02.   "차량유지비

    WHEN '/3N7'.
      ADD RT-BETRG TO WA-B03.   "연구비비과세

    WHEN '/3N3'.
      ADD RT-BETRG TO WA-B04.   "초과근로비과세

    WHEN '/3N9'.
      ADD RT-BETRG TO WA-B10.   "비과세합계

*----------------------------------------------------------------------*
*   공제금액관련
*----------------------------------------------------------------------*
    WHEN '/301'.
      ADD RT-BETRG TO WA-D01.      "소득세 (/301)
      ADD RT-BETRG TO WA-D01_2.    "소득세 합계 (/301, /3QI, /3RI)

    WHEN '/302'.
      ADD RT-BETRG TO WA-D02.      "주민세 (/302)
      ADD RT-BETRG TO WA-D02_2.    "주민세 합계 (/302, /3QR, /3RR)

    WHEN '/3QI' OR '/3RI'.
      ADD RT-BETRG TO WA-D01_1.    "소득세 정산 (/3QI, /3RI)
      ADD RT-BETRG TO WA-D01_2.    "소득세 합계 (/301, /3QI, /3RI)

    WHEN '/3QR' OR '/3RR'.
      ADD RT-BETRG TO WA-D02_1.    "주민세 정산 (/3QR, /3RR) 9002
      ADD RT-BETRG TO WA-D02_2.    "주민세 합계 (/302, /3QR, /3RR)

    WHEN '/4PE'.
      ADD RT-BETRG TO WA-D03.      "국민연금 (/4PE)

    WHEN '/4ME'.
      ADD RT-BETRG TO WA-D04.      "건강보험 (/4ME)
      ADD RT-BETRG TO WA-D04_2.    "건강보험 합계 (/4ME, /4N5, HD03)

    WHEN '/4N5' OR 'HD03'.
      ADD RT-BETRG TO WA-D04_1.    "건강보험 정산 (/4N5, HD03)
      ADD RT-BETRG TO WA-D04_2.    "건강보험 합계 (/4ME, /4N5, HD03)

    WHEN '/4TE'.
      ADD RT-BETRG TO WA-D05.      "장기요양 (/4TE)
      ADD RT-BETRG TO WA-D05_2.    "장기요양 합계 (/4TE, /4T5, LE03)

    WHEN '/4T5' OR 'LE03'.
      ADD RT-BETRG TO WA-D05_1.    "장기요양 정산 (/4T5, LE03)
      ADD RT-BETRG TO WA-D05_2.    "장기요양 합계 (/4TE, /4T5, LE03)

    WHEN '/4UE'.
      ADD RT-BETRG TO WA-D06.      "고용보험 (/4UE)
      ADD RT-BETRG TO WA-D06_2.    "고용보험 합계 (/4UE, /4FE),/4U5

    WHEN '/4FE' OR '/4U3' OR '/4U5'.
      ADD RT-BETRG TO WA-D06_1.    "고용보험 정산 (/4FE)/4U5
      ADD RT-BETRG TO WA-D06_2.    "고용보험 합계 (/4UE, /4FE)/4U5

    WHEN '5000'.
      WA-D15 = WA-D15 - RT-BETRG.  "기타공제

    WHEN 'RTRO'.
      ADD RT-BETRG TO WA-R_TOTAL.  "소급분

  ENDCASE.

ENDFORM.                    " GET_BONUS
*&amp;---------------------------------------------------------------------*
*&amp;      Form  GET_RESULT_FROM_RETO
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RGDIR  text
*      -->P_PRINT_START  text
*      -->P_PRINT_END  text
*----------------------------------------------------------------------*
FORM GET_RESULT_FROM_RETO_2  TABLES   P_RGDIR   STRUCTURE   PC261
                                      P_RT      STRUCTURE   ZHRS0013
                                      P_CRT     STRUCTURE   PC208
                                      P_BT      STRUCTURE   PC209
                                      P_WPBP    STRUCTURE   PC205
                                      P_KRSI    STRUCTURE   PC2H3
                                USING    VALUE(PRINT_START)
                                         VALUE(PRINT_END)
                                         P_FLAG
                                CHANGING P_RETROYM.


  DATA: F_CONTINUE TYPE C,
        F_EXIT     TYPE C,
        L_BEGDA    TYPE D,
        L_ENDDA    TYPE D.

  DATA: XDATA LIKE STANDARD TABLE OF PC261 WITH HEADER LINE.

  RANGES P_PAYID FOR PC261-PAYID.   "급여계산 식별자
  RANGES P_PAYTY FOR PC261-PAYTY.   "급여유형

  CLEAR: RT_2, RT_2[].
* Pay type = space Means Regular payroll
  P_PAYTY-LOW       =          ' '.
  P_PAYTY-SIGN      =          'I'.
  P_PAYTY-OPTION    =          'EQ'.
  APPEND P_PAYTY.

  LOOP AT P_RGDIR  WHERE INPER = PN_PER.
    CHECK P_RGDIR-FPPER = P_RGDIR-INPER.
    CHECK P_RGDIR-FPPER IS NOT INITIAL.

*급여계산일자 및 기간 산정
    PERFORM RE549Q USING P_RGDIR-IPERM
                         P_RGDIR-PAYDT(4)
                         P_RGDIR-PAYDT+4(2).
*                                         P_RGDIR-INPER(4)
*                                         P_RGDIR-INPER+4(2).

    PERFORM FIND_RGDIR_TRIGGERS TABLES P_RGDIR
                                XDATA    P_PAYTY   P_PAYID
*                               USING    P_RGDIR-PAYDT P_RGDIR-PAYDT.
*                               USING    T549Q-BEGDA   P_RGDIR-PAYDT.
                                USING    T549Q-BEGDA   T549Q-ENDDA.
** 소급시작연월 구하기
    CLEAR: P_RETROYM.
    READ TABLE XDATA INDEX 1.
    IF SY-SUBRC  = 0.
      P_RETROYM = XDATA-FPPER.
    ENDIF.

    LOOP AT XDATA
      WHERE INPER  = '000000'.
      IF  XDATA-INOCC = '08'
        AND XDATA-IPEND >= T549Q-BEGDA
        AND XDATA-IPEND <= T549Q-ENDDA.
        DELETE XDATA.
      ELSEIF XDATA-PAYTY NE SPACE.
        DELETE XDATA.
      ENDIF.
    ENDLOOP.


    IF GV_MODE = 'G'. "월 급여 + 소급분별도(RTRO 임금유형)
      PERFORM PROCESS_EVP TABLES XDATA USING  '1'.
      PERFORM RETRO.
    ELSE.
      PERFORM PROCESS_EVP TABLES XDATA USING  '2'.
    ENDIF.

    LOOP AT RT_2.
      MOVE-CORRESPONDING RT_2 TO P_RT.
      P_RT-FPPER = RT_2-FPBEG(6).  "대상기간
      P_RT-INPER = PN_PER.         "실행기간
      P_RT-PAYDT = P_RGDIR-PAYDT.  "지급일
      P_RT-OCRSN = P_RGDIR-OCRSN.  "급여사유
      P_RT-PAYID = P_RGDIR-PAYID.  "식별자
      APPEND P_RT.
      CLEAR P_RT.
    ENDLOOP.

    P_CRT[]   =   CRT[].
    P_BT[]    =   BT[].
    P_WPBP[]  =   WPBP[].
    P_KRSI[]  =   KRSI[].
    EXIT.
  ENDLOOP.



* 전월퇴직정산결과 조회
  IF P_FLAG IS NOT INITIAL.

    L_ENDDA      = TMP_DATE1.
    L_BEGDA      = L_ENDDA.
    L_BEGDA+6(2) = '01'.

    P_PAYTY-LOW    = 'B'.
    P_PAYTY-SIGN   = 'I'.
    P_PAYTY-OPTION = 'EQ'.
    APPEND P_PAYTY.

    LOOP AT  P_RGDIR WHERE OCCAT  = '08'
                       AND FPBEG >= L_BEGDA
                       AND FPBEG <= L_ENDDA.

      CHECK P_RGDIR-FPPER =  P_RGDIR-INPER.
      PERFORM FIND_RGDIR_TRIGGERS TABLES P_RGDIR  XDATA  P_PAYTY P_PAYID
                                  USING  L_ENDDA L_ENDDA.
      LOOP AT XDATA WHERE INPER = '000000'.
        IF  XDATA-INOCC = '05' OR
            XDATA-INOCC = '09' OR
            XDATA-INOCC = '10' OR
            XDATA-INOCC = '11'.
          DELETE      XDATA.
        ENDIF.
      ENDLOOP.

*      CASE   W_RETRO.
*        WHEN    'SUM'.   " 소급분 포함
      PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '2'.
*          PERFORM   MOVE_WTS_TO_RT.
*        WHEN    'NOW'.   " 제외
*          PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
*          PERFORM   MOVE_WTS_TO_RT_SOGUB.
*        WHEN    'RET'.                                 " 소급분만
*          PERFORM   PROCESS_EVP      TABLES   XDATA   USING  '1'.
*          PERFORM   MOVE_WTS_TO_RT_SOGUB1.
*      ENDCASE.

      LOOP AT RT_2.
        MOVE-CORRESPONDING RT_2 TO P_RT.
        P_RT-FPPER = RT_2-FPBEG(6).  "대상기간
        P_RT-INPER = PN_PER.         "실행기간
        P_RT-PAYDT = P_RGDIR-PAYDT.  "지급일
        P_RT-OCRSN = P_RGDIR-OCRSN.  "급여사유
        P_RT-PAYID = P_RGDIR-PAYID.  "식별자
        APPEND P_RT.
        CLEAR P_RT.
      ENDLOOP.

*    P_RT[]    =   RT[].

      EXIT.
    ENDLOOP.

  ENDIF.

ENDFORM.                    " GET_RESULT_FROM_RETO
*&amp;---------------------------------------------------------------------*
*&amp;      Form  GET_RESULTS
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RGDIR  text
*----------------------------------------------------------------------*
FORM GET_RESULTS_2           TABLES   P_RT      STRUCTURE   ZHRS0013
                                      P_CRT     STRUCTURE   PC208
                                      P_BT      STRUCTURE   PC209
                                      P_WPBP    STRUCTURE   PC205
                              USING   $RGDIR    STRUCTURE   PC261.



  RX-KEY-PERNR               =        W_PERNR.
  UNPACK  $RGDIR-SEQNR       TO       RX-KEY-SEQNO.

  IMPORT  KR-VERSION         TO       OKR-VERSION
                                      RT
                                      CRT
                                      WPBP
                                      BT
          FROM    DATABASE   PCL2(KR) ID  RX-KEY.

  IF      RP-IMP-KR-SUBRC    NE       0.
    MESSAGE            E327(PN).
  ELSE.
    LOOP AT RT.
      MOVE-CORRESPONDING RT TO P_RT.
      MOVE-CORRESPONDING $RGDIR TO P_RT.
      APPEND P_RT.
      CLEAR P_RT.
    ENDLOOP.
*    P_RT[]  =  RT[].
    P_CRT[] =  CRT[].
    P_BT[]  =  BT[].
    P_WPBP[] = WPBP[].
  ENDIF.


ENDFORM.                    " GET_RESULTS
*&amp;---------------------------------------------------------------------*
*&amp;      Form  MOVE_WTS_TO_RT_SOGUB
*&amp;---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RETRO.

  DATA: LT_T511 TYPE TABLE OF T511 WITH HEADER LINE. " 2018.04.10 추가

  DATA : RETRO_AMT LIKE RT-BETRG.
*  DATA : BONUS LIKE RT-BETRG.

** 050808 시급관련 소급분 처리를 위해 추가
  DATA : BEGIN  OF  WK_RT  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK_RT .

  DATA : BEGIN  OF  WK_RT1  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK_RT1 .

  DATA : BEGIN  OF  WK1_RT  OCCURS  0.
           INCLUDE    STRUCTURE  PC207 .
         DATA : END    OF  WK1_RT .
** 050808 시급관련 소급분 처리를 위해 추가

  CLEAR          RT.
  REFRESH        RT.

  "지급 임금유형 가져오기
  CLEAR: LT_T511, LT_T511[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_T511
    FROM T511
   WHERE MOLGA = '41'
     AND ENDDA = '99991231'
     AND LGART BETWEEN '1000' AND '9999'
     AND OPKEN <> 'A'.

  LOOP    AT     RT_2.

    CASE RT_2-LGART.
** 050808 시급관련 소급분 처리를 위해 추가
      WHEN '/001'.            "시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT.
      WHEN '/002'.            "통상시급
        MOVE-CORRESPONDING        RT_2      TO     WK_RT1.
      WHEN '/4MG'.            "건강보험등급
        MOVE-CORRESPONDING        RT_2      TO     WK1_RT.
** 050808 시급관련 소급분 처리를 위해 추가
      WHEN OTHERS.

        CLEAR LT_T511.
        READ TABLE LT_T511 WITH KEY LGART = RT_2-LGART.

        IF SY-SUBRC = 0.
*    WHEN '1000' OR '1001' OR '1100' OR '1200' OR '1400' OR
*         '1500' OR '1600' OR '2100' OR '2200' OR '2300' OR
*         '2400' OR '2500' OR '2600' OR '2700' OR '2800' OR
*         '2900' OR '3000' OR '3100' OR '3200' OR '3800' OR
*         '3900' OR '4000' OR '4010' OR '4020' OR '4100' OR
*         '5000' OR '5100' OR '5102' OR '5200' OR '5202' OR
*         '5300' OR '5302' OR '5400' OR '5402' OR '5500' OR
*         '5502' OR '5510' OR '5512' OR '5600' OR '5900' OR
*         '5902' OR '6000' OR '6100' OR '6200'.

          IF RT_2-FPBEG = '19000101'.
            RETRO_AMT = RETRO_AMT + RT_2-BETRG.
          ELSE.
            MOVE-CORRESPONDING        RT_2      TO     RT.
            COLLECT      RT.
          ENDIF.

        ELSE.
          MOVE-CORRESPONDING        RT_2      TO     RT.
          COLLECT      RT.
        ENDIF.

    ENDCASE.


  ENDLOOP.



** 050808 시급관련 소급분 처리를 위해 추가
  MOVE-CORRESPONDING        WK_RT     TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK_RT1    TO     RT.
  COLLECT      RT.
  MOVE-CORRESPONDING        WK1_RT    TO     RT.
  COLLECT      RT.
** 시급관련 소급분 처리를 위해 추가
  IF RETRO_AMT NE 0.
    RT-BETRG  =  RETRO_AMT.
    RT-LGART  = 'RTRO'.
    COLLECT RT.
  ENDIF.


  CLEAR          RT_2.
  REFRESH        RT_2.
  CLEAR          ORT.
  REFRESH        ORT.

  LOOP AT RT.
    MOVE-CORRESPONDING RT TO RT_2.
    APPEND RT_2.
    CLEAR RT_2.
  ENDLOOP.


ENDFORM.                    " MOVE_WTS_TO_RT_SOGUB
*&---------------------------------------------------------------------*
*&      Form  GET_HOLIDAYS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_AB  text
*----------------------------------------------------------------------*
FORM GET_HOLIDAYS  USING    AB  TYPE PC20I.


  CASE AB-AWART.
*----------------------------------------------------------------------*
*   휴무유형별 집계
*----------------------------------------------------------------------*
    WHEN  '1000' OR '1010'.
      ADD  AB-ABRTG TO HD-H01.  "연차
    WHEN  '1100'.
      ADD  AB-ABRTG TO HD-H02.  "대체휴가
    WHEN  '1200'.
      ADD  AB-ABRTG TO HD-H03.  "보건
    WHEN  '1300' OR '1310'.
      ADD  AB-ABRTG TO HD-H04.   "공가
    WHEN  '1400' OR
                '3300' OR '3310' OR  '3320' OR  '3330' OR '3340' .
      ADD  AB-ABRTG TO HD-H05.   "출산전후휴가(유급)
    WHEN  '1410' OR
                '3350'.
      ADD  AB-ABRTG TO HD-H06.   "출산전후휴가(무급)
      HD-H00 = HD-H00 - AB-ABRTG.
    WHEN  '1500'.
      ADD  AB-ABRTG TO HD-H07.   "병가(유급)
    WHEN  '1510'.
      ADD  AB-ABRTG TO HD-H08.   "병가(무급)
      HD-H00 = HD-H00 - AB-ABRTG.
    WHEN  '2100' OR '2110' OR
                '2200' OR '2210' OR '2220' OR '2230' OR '2240' OR
                '2250' OR '2260' .
      ADD  AB-ABRTG TO HD-H09.  "경조휴가
    WHEN  '3100' OR '3200'.
      ADD  AB-ABRTG TO HD-H10.   "출산 난임 (유급)
    WHEN  '3210'.
      ADD  AB-ABRTG TO HD-H11.   "출산 난임 (무급)
      HD-H00 = HD-H00 - AB-ABRTG.
    WHEN  '3500'.
      ADD  AB-ABRTG TO HD-H12.   "가족돌봄(무급))
      HD-H00 = HD-H00 - AB-ABRTG.
    WHEN  '4100' OR '4110'..
      ADD  AB-ABRTG TO HD-H13.   "결근(무급)
      HD-H00 = HD-H00 - AB-ABRTG.
    WHEN   OTHERS.
      ADD  AB-ABRTG TO HD-H04.   "그외 공가 처리

  ENDCASE.

ENDFORM.                    " GET_HOLIDAYS
*&---------------------------------------------------------------------*
*&      Form  MAKE_LOGKEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MAKE_LOGKEY .
  DATA: LV_DATE    LIKE SY-DATUM,
        LV_TIME    LIKE SY-UZEIT,
        LV_TSM(23),
        TSL        TYPE TIMESTAMPL.

  CALL FUNCTION 'ISU_DATE_TIME_CONVERT_TIMEZONE'
    EXPORTING
      X_DATE_UTC = SY-DATUM
      X_TIME_UTC = SY-UZEIT
      X_TIMEZONE = SY-ZONLO
    IMPORTING
      Y_DATE_LCL = LV_DATE
      Y_TIME_LCL = LV_TIME.

  CLEAR ZHRIFLOG.

  GET TIME STAMP FIELD TSL.
  LV_TSM = TSL.

  ZHRIFLOG-IDATE = LV_DATE.
  ZHRIFLOG-ITIME = LV_TIME.
  ZHRIFLOG-TSTMP = LV_TSM+15(6).
  ZHRIFLOG-UNAME = SY-UNAME.
ENDFORM.