*----------------------------------------------------------------------*
***INCLUDE LZHR0004F03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_BASIC_PAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LGART  text
*      -->P_PERNR  text
*      -->P_LV_DATE  text
*      -->P_LV_BASIC_PAY  text
*----------------------------------------------------------------------*
FORM GET_BASIC_PAY  TABLES S_LGART STRUCTURE PJPSK_RANGE_LGART
                    USING    P_PERNR
                             P_DATE
                             P_BASIC_PAY.

  DATA: PP0001 TYPE TABLE OF P0001,
        PP0007 TYPE TABLE OF P0007,
        PP0008 TYPE TABLE OF P0008,
        PP0014 TYPE TABLE OF P0014,
        PPBWLA TYPE TABLE OF PBWLA WITH HEADER LINE.
*        LT_PPBWLA TYPE TABLE OF PBWLA,
*        LS_PPBWLA TYPE PBWLA.
  DATA : LV_INFTY(4).

  SELECT * INTO CORRESPONDING FIELDS OF TABLE PP0001
    FROM PA0001
   WHERE PERNR = P_PERNR
     AND BEGDA <= P_DATE
     AND ENDDA >= P_DATE.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE PP0007
    FROM PA0007
   WHERE PERNR = P_PERNR
     AND BEGDA <= P_DATE
     AND ENDDA >= P_DATE.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE PP0008
    FROM PA0008
   WHERE PERNR = P_PERNR
     AND BEGDA <= P_DATE
     AND ENDDA >= P_DATE.

*----------------------------------------------------------------------*
*   "기준금액 가져오기
*----------------------------------------------------------------------*
  DO 2 TIMES.
    IF SY-INDEX = 1.
      LV_INFTY = '0008'.
    ELSE.
      LV_INFTY = '0014'.
    ENDIF.

    CLEAR: PP0001, PP0007, PP0008, PPBWLA[].
    CALL FUNCTION 'RP_FILL_WAGE_TYPE_TABLE_EXT'
      EXPORTING
        APPLI                        = 'E'
        BEGDA                        = P_DATE
        ENDDA                        = P_DATE
        INFTY                        = LV_INFTY
        OBJPS                        = ' '
        TCLAS                        = 'A'
        PERNR                        = P_PERNR
*       SEQNR                        = ' '
*       SUBTY                        = ' '
*       DLSPL                        = 'X'
*       MSGFLG                       = ' '
*       NORDCT                       = ' '
*       CONV_CURR                    = 'X'
      TABLES
        PP0001                       = PP0001
        PP0007                       = PP0007
        PP0008                       = PP0008
        PPBWLA                       = PPBWLA
      EXCEPTIONS
        ERROR_AT_INDIRECT_EVALUATION = 1.



    LOOP AT PPBWLA WHERE LGART IN S_LGART.
      P_BASIC_PAY = P_BASIC_PAY + PPBWLA-BETRG.
    ENDLOOP.

  ENDDO.


ENDFORM.                    " GET_BASIC_PAY
*&---------------------------------------------------------------------*
*&      Form  GET_PAYROLL_RESULTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERNR  text
*      -->P_RGDIR  text
*----------------------------------------------------------------------*
FORM GET_PAYROLL_RESULTS  USING P_PERNR
                                P_RGDIR STRUCTURE PC261.

  RX-KEY-PERNR = P_PERNR.
  RX-KEY-SEQNO = P_RGDIR-SEQNR.
  RP-IMP-C2-KR.
*  RC                      =        RP-IMP-KR-SUBRC.

ENDFORM.                    " GET_PAYROLL_RESULTS
*&---------------------------------------------------------------------*
*&      Form  GET_SPECIFIC_DAYS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_TAB  text
*      -->P_LT_TAB1  text
*      -->P_PERNR  text
*      -->P_EX_STR_LSPDT  text
*      -->P_SEPDT  text
*----------------------------------------------------------------------*
FORM GET_SPECIFIC_DAYS  TABLES   P_TAB  STRUCTURE ZHRS0025
                                 P_TAB2 STRUCTURE ZHRS0026
                        USING    P_PERNR
                                 P_LSPDT
                                 P_SEPDT.

  CALL FUNCTION 'ZHR0004_GET_SPECIFIC_PERIOD'
    EXPORTING
      PERNR  = P_PERNR
      BEGDA  = P_LSPDT
      ENDDA  = P_SEPDT
      SIGN   = 'I'
*     OPT    =
*   IMPORTING
*     E_RETURN       =
    TABLES
      S_TAB  = P_TAB
      EX_TAB = P_TAB2.


ENDFORM.                    " GET_SPECIFIC_DAYS
*&---------------------------------------------------------------------*
*&      Form  GET_PAYSLIP_DATA
*&---------------------------------------------------------------------*
FORM GET_PAYSLIP_DATA  TABLES   IR_PERNR        STRUCTURE SEL_PERNR
                                IR_PAYDT        STRUCTURE SEL_DATE
                                IR_ORGEH        STRUCTURE CCHRS_ORGEH_RANGE
                                ET_PAYSLIP_DATA STRUCTURE ZHRS0027
                                ET_PAYSLIP_B3   STRUCTURE ZHRS0027_B3
                        USING   PV_ZSTYPE
                                PV_ZSIGN
                                IV_YEAR.

  DATA: LT_P0100   TYPE TABLE OF ZHRT0100 WITH HEADER LINE,
*-> 급상여결과 조회 조건 수정 2025-04-03
        LT_P0100_2 TYPE TABLE OF ZHRT0100 WITH HEADER LINE.
*<- 급상여결과 조회 조건 수정 2025-04-03
  DATA: LT_ZHRT0300 TYPE TABLE OF ZHRT0300 WITH HEADER LINE.
  DATA: LT_P9001 TYPE TABLE OF P9001 WITH HEADER LINE.

  DATA: LS_T7KRMR LIKE T7KRMR, "건강보험요율
        LS_T7KRIR LIKE T7KRIR, "장기요양보험요율
        LT_T7KRSR LIKE TABLE OF T7KRSR WITH HEADER LINE. "국민연금, 고용보험요율

  DATA: LV_BEGDA TYPE D.

  " ************************************  급여 명세서 수정 ************************************

  DATA : LT_WPBP       LIKE TABLE OF PC205 WITH HEADER LINE, "중도 입/퇴사자 일할 계산
         LS_WPBP       LIKE PC205,
         LT_RGDIR      LIKE TABLE OF HRPY_RGDIR WITH HEADER LINE,
         LT_DINNER     LIKE TABLE OF ZHRPT0005 WITH HEADER LINE,  "석식
         LT_SWORK      LIKE TABLE OF ZHRPT0006 WITH HEADER LINE,  "특근
         LS_STR        TYPE ZHRS0004,
         V_BEGDA_H     TYPE SY-DATUM,
         V_ENDDA_H     TYPE SY-DATUM,
         V_BEGDA       TYPE SY-DATUM,
         V_ENDDA       TYPE SY-DATUM,
         LV_FAPER      TYPE FAPER,
         LV_DATE       TYPE DATS,
         LV_DINNER(2),
         LV_WERT1      TYPE WERT1,
         LV_DINWER(10),
         LV_SWORK      TYPE P DECIMALS 2,
         LV_LINES      TYPE I.

  DATA : LV_DATUM TYPE SY-DATUM.

  " ************************************  급여 명세서 수정 ************************************

  DATA: LV_NUM_1 LIKE ZHRT0100-D09.
  DATA : LV_TEXT(30),
         LV_ORGEH(8) TYPE N,
         LV_TRFGR(8).
  DATA: LV_NUM(2)   TYPE N,
        LV_NUM_2(2) TYPE N.

  DATA:  WAS   TYPE ZHRS0023.           "header
  DATA : WA1   TYPE ZHRS0021,
         WA1_1 TYPE ZHRS0021.

  DATA : WA2   TYPE ZHRS0022,
         WA2_2 TYPE ZHRS0022.

  DATA : LV_BUKRS TYPE BUKRS.

*  DATA : lv_zzclass TYPE zhre_zzclass.
*  CLEAR lv_zzclass.
*  "급지(현장직 판단)
*  SELECT SINGLE zzclass
*    FROM pa0001 INTO lv_zzclass
*      WHERE pernr IN ir_pernr
*        AND orgeh IN ir_orgeh.

*<- added by SEPPIN 07.07.2025 10:47:10
  " 하단 급식비 등 셀렉트 조건을 위한 날짜 설정
*>- added by SEPPIN 07.07.2025 10:47:10

  " 입력한 지급일의 일자를 01로 설정한 후 시작일에 할당
*  CONCATENATE ir_paydt-low+0(6) '01' INTO v_begda.
*
*  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
*    EXPORTING
*      day_in            = v_begda
*    IMPORTING
*      last_day_of_month = v_endda
*    EXCEPTIONS
*      day_in_no_date    = 1
*      OTHERS            = 2.

  "고용상태용 -1달
*  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*    EXPORTING
*      date      = v_begda
*      days      = '00'
*      months    = '01'
*      signum    = '-'
*      years     = '00'
*    IMPORTING
*      calc_date = v_begda_h.

*  REPLACE ALL OCCURRENCES OF `.` IN ir_paydt-low WITH space.

  IF IR_PAYDT IS INITIAL.
    READ TABLE IR_PAYDT INDEX 1.
  ENDIF.

*<- added by SEPPIN 03.07.2025 13:49:43
  " 기존 로직은 입력한 기간이 있을 때만 조회가 가능했으나
  " 입력한 기간이 없으면 모든 값을 조회할 수 있도록 추가
*>- added by SEPPIN 03.07.2025 13:49:43
  IF IR_PAYDT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_RGDIR
      FROM HRPY_RGDIR
      WHERE PERNR IN IR_PERNR
      AND SRTZA = 'A'.
  ELSE.

*<- added by SEPPIN 03.07.2025 13:49:34
    " Webdyn으로 조회할 경우 급여 지급일이 low에 할당되어 high가 비어있음
    " 급여 대상 월로 조회하기 때문에 당월의 마지막 일 구해서 셀렉트
*>- added by SEPPIN 03.07.2025 13:49:34
    IF IR_PAYDT-HIGH IS INITIAL.
      CONCATENATE IR_PAYDT-LOW+0(6) '01' INTO V_BEGDA.
      CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
        EXPORTING
          DAY_IN            = IR_PAYDT-LOW
        IMPORTING
          LAST_DAY_OF_MONTH = IR_PAYDT-HIGH
        EXCEPTIONS
          DAY_IN_NO_DATE    = 1
          OTHERS            = 2.

    ENDIF.

    SELECT * FROM HRPY_RGDIR
      INTO CORRESPONDING FIELDS OF TABLE LT_RGDIR
        WHERE PERNR IN IR_PERNR
          AND FPPER BETWEEN IR_PAYDT-LOW(6) AND IR_PAYDT-HIGH(6)
          AND SRTZA = 'A'.

  ENDIF.

*<- added by SEPPIN 03.07.2025 13:49:19
  " 기존에는 입력한 지급월에 -1을 하여 함수를 실행했지만
  " 지급일을 입력하지 않을 경우 오류가 발생해 가져온 급여 결과를 돌며 지급일을 가져오는 것으로 수정
  " 또한 202505 이후 당월 지급으로 변경되어 이전 결과는 해당 월에 -1
*>- added by SEPPIN 03.07.2025 13:49:19

*    IF ir_paydt-low+4(2) = '01'.
*      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*        EXPORTING
*          date      = ir_paydt-low
*          days      = '00'
*          months    = '01'
*          signum    = '-'
*          years     = '00'
*        IMPORTING
*          calc_date = lv_datum.
*      lv_faper = lv_datum+0(6).
*    ELSE.
*      lv_faper = ir_paydt-low+0(6) - 1.
*    ENDIF.

  LOOP AT LT_RGDIR.
    IF LT_RGDIR-FPPER < '202505'.
      CLEAR LV_DATE.
      CONCATENATE LT_RGDIR-FPPER '01' INTO LV_DATE.
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          DATE      = LV_DATE
          DAYS      = '00'
          MONTHS    = '01'
          SIGNUM    = '-'
          YEARS     = '00'
        IMPORTING
          CALC_DATE = LV_DATE.

      LT_RGDIR-FPPER =  LV_DATE(6).
      MODIFY LT_RGDIR INDEX SY-TABIX.
    ENDIF.
  ENDLOOP.

*<- added by SEPPIN 03.07.2025 13:50:01
  " 202505월 이후로는 당월 지급, 이전은 익월 지급
  " 현재는 해당 사원의 마지막 월의 급여 결과만 받아오고 있음
  " 단순히 중도 입/퇴사자 구분 용도로만 쓰는 듯함
*>- added by SEPPIN 03.07.2025 13:50:01

  LOOP AT LT_RGDIR.

    CLEAR: LT_WPBP[].
    CALL FUNCTION 'ZHR0004_GET_PAYRESULT_V2'
      EXPORTING
        PERNR  = LT_RGDIR-PERNR
        ABKRS  = LT_RGDIR-IABKRS
        YYYYMM = LT_RGDIR-FPPER
        OCRSN  = LT_RGDIR-OCRSN
        PAYID  = LT_RGDIR-PAYID
        PAYDT  = LT_RGDIR-PAYDT
        MODE   = 'A'
      TABLES
        WPBP   = LT_WPBP.

  ENDLOOP.

*<- added by SEPPIN 07.07.2025 09:31:46
  " 각 금액 조회 조건이 입력한 월에 1월부터 말일까지로 조회했으나,
  " 급여 결과의 각 월로 조회 수정해야함
*>- added by SEPPIN 07.07.2025 09:31:46

  "석식 계산
  "횟수
*  SELECT COUNT(*)
*    FROM zhrpt0005 INTO lv_dinner
*      WHERE pernr IN ir_pernr
*        AND begda BETWEEN v_begda AND v_endda
*        AND apply NE 'Y'
*        AND pernr NOT LIKE '____9___'.

  SELECT COUNT(*)
    FROM ZHRPT0005 INTO LV_DINNER
      WHERE PERNR IN IR_PERNR
        AND BEGDA BETWEEN IR_PAYDT-LOW AND IR_PAYDT-HIGH
        AND APPLY NE 'Y'
        AND PERNR NOT LIKE '____9___'.

  "금액
  SELECT SINGLE WERT1 FROM
    T510J INTO LV_WERT1
      WHERE MOLGA = '41'
        AND LGART = '3500'
        AND BEGDA >= '20230101'
        AND ENDDA <= '99991231'.

  WRITE LV_WERT1 TO LV_DINWER CURRENCY 'KRW' LEFT-JUSTIFIED.

  "특근 시간수
*  SELECT anzhl
*    FROM zhrpt0006 INTO CORRESPONDING FIELDS OF TABLE lt_swork
*      WHERE pernr IN ir_pernr
*        AND begda BETWEEN v_begda AND v_endda
*        AND apply NE 'Y'
*        AND pernr NOT LIKE '____9___'.

  SELECT ANZHL
    FROM ZHRPT0006 INTO CORRESPONDING FIELDS OF TABLE LT_SWORK
      WHERE PERNR IN IR_PERNR
        AND BEGDA BETWEEN LT_RGDIR-FPBEG AND LT_RGDIR-FPEND
        AND APPLY NE 'Y'
        AND PERNR NOT LIKE '____9___'.

  CLEAR LV_SWORK.

  LOOP AT LT_SWORK.
    LV_SWORK = LV_SWORK + LT_SWORK-ANZHL.
  ENDLOOP.

  CLEAR: WA1, WAS, WA2, WA1_1, WA2_2, ET_PAYSLIP_DATA, ET_PAYSLIP_DATA[], ET_PAYSLIP_B3, ET_PAYSLIP_B3[].

  CLEAR:  LT_P0100[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100
    FROM   ZHRT0100
    WHERE  PERNR IN IR_PERNR
      AND  PAYDT IN IR_PAYDT
      AND  ORGEH IN IR_ORGEH
      AND  ZSTYPE = PV_ZSTYPE.

*-> 급상여결과 조회 조건 수정 2025-04-03
  DATA: V_YNCA   TYPE SY-DATUM,
        V_YNCA_H TYPE SY-DATUM.
  IF IR_PAYDT-LOW+4(2) EQ '03'.
    CLEAR: V_YNCA.
    CONCATENATE IR_PAYDT-LOW+0(6) '01' INTO V_YNCA.
    "연차수당 계산용 -1달
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        DATE      = V_YNCA
        DAYS      = '00'
        MONTHS    = '01'
        SIGNUM    = '-'
        YEARS     = '00'
      IMPORTING
        CALC_DATE = V_YNCA_H.

    CLEAR:  LT_P0100_2[].
    SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
      FROM   ZHRT0100
      WHERE  PERNR IN IR_PERNR
        AND  FPPER  EQ V_YNCA_H+0(6)
        AND  ORGEH IN IR_ORGEH
        AND  ZSTYPE = PV_ZSTYPE.

    SORT LT_P0100_2 ASCENDING BY PERNR PAYDT.

  ELSEIF IR_PAYDT-HIGH+4(2) EQ '03'.
    CLEAR: V_YNCA.
    CONCATENATE IR_PAYDT-HIGH+0(6) '01' INTO V_YNCA.
    "연차수당 계산용 -1달
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        DATE      = V_YNCA
        DAYS      = '00'
        MONTHS    = '01'
        SIGNUM    = '-'
        YEARS     = '00'
      IMPORTING
        CALC_DATE = V_YNCA_H.

    CLEAR:  LT_P0100_2[].
    SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
      FROM   ZHRT0100
      WHERE  PERNR IN IR_PERNR
        AND  FPPER  EQ V_YNCA_H+0(6)
        AND  ORGEH IN IR_ORGEH
        AND  ZSTYPE = PV_ZSTYPE.

    SORT LT_P0100_2 ASCENDING BY PERNR PAYDT.

  ENDIF.
*<- 급상여결과 조회 조건 수정 2025-04-03

  SORT LT_P0100 ASCENDING BY PERNR PAYDT.

  IF LT_P0100[] IS NOT INITIAL.
    SELECT * FROM ZHRT0300
      INTO   TABLE LT_ZHRT0300
     WHERE   PAYDT IN IR_PAYDT
       AND   ZSTYPE = PV_ZSTYPE.
  ENDIF.

  LOOP AT LT_P0100.

    CLEAR: WA1,WA2,WAS.

    SELECT SINGLE ENAME INTO WAS-ENAME
      FROM PA0001
     WHERE PERNR  = LT_P0100-PERNR
       AND BEGDA <= LT_P0100-PAYDT
       AND ENDDA >= LT_P0100-PAYDT.

    "사원번호
    WRITE LT_P0100-PERNR TO WAS-PERNR NO-ZERO.

*    "부서명
    WAS-STEXT = LT_P0100-ORGEH_TEXT.

****직급 또는 직책 필요시 주석
*    MOVE LT_P0100-ZZPSGRPTX TO WAS-ZJ2T.       "직책명
    MOVE LT_P0100-ZZCALTLTX TO WAS-ZJ2T.       "직급명
***************
    "타이틀
*  DATA LV_TEXT TYPE DD07T-DDTEXT.
    IF LT_P0100-LIST_TXT IS NOT INITIAL.
      WAS-TITLE = LT_P0100-LIST_TXT.
    ELSE.
      SELECT SINGLE DDTEXT
        FROM DD07T
        INTO LV_TEXT
        WHERE DOMNAME = 'ZSTYPE'
            AND DDLANGUAGE = SY-LANGU
            AND DOMVALUE_L = LT_P0100-ZSTYPE.

      CONCATENATE LT_P0100-PABRJ '년'
                  LT_P0100-PABRP '월'
                  LV_TEXT
                  '명세서'
             INTO WAS-TITLE SEPARATED BY SPACE.
    ENDIF.

    "급여명세서 메세지
    "1. 전사 메세지
    CLEAR LT_ZHRT0300.
    READ TABLE LT_ZHRT0300 WITH KEY PAYDT = LT_P0100-PAYDT.
    IF SY-SUBRC EQ 0.
      ET_PAYSLIP_DATA-ZMESSAGE1 = LT_ZHRT0300-ZMESSAGE.
      "급여명세서 수정
      ET_PAYSLIP_B3-ZMESSAGE1 = LT_ZHRT0300-ZMESSAGE.
      CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE1 INTO ET_PAYSLIP_DATA-ZMESSAGE1
                                                  SEPARATED BY SPACE.
      CONCATENATE ' * ' ET_PAYSLIP_B3-ZMESSAGE1 INTO ET_PAYSLIP_B3-ZMESSAGE1
                                                  SEPARATED BY SPACE.
    ENDIF.
    "2. 사원별메세지
    PERFORM HR_READ_INFOTYPE TABLES LT_P9001
                              USING '9001'
                                    LT_P0100-PERNR
                                    LT_P0100-PAYDT.

    READ TABLE LT_P9001 WITH KEY ZSTYPE = PV_ZSTYPE.
    IF SY-SUBRC EQ 0.
      "전사메세지가 없으면 사원메세지를 전사메세지 칸에 넣는다.
      "급여명세서 수정
      IF ET_PAYSLIP_DATA-ZMESSAGE1 IS NOT INITIAL OR ET_PAYSLIP_B3-ZMESSAGE1 IS NOT INITIAL.
        ET_PAYSLIP_DATA-ZMESSAGE2 = LT_P9001-ZMESSAGE.
        ET_PAYSLIP_B3-ZMESSAGE2 = LT_P9001-ZMESSAGE.
        CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE2 INTO ET_PAYSLIP_DATA-ZMESSAGE2
                                                    SEPARATED BY SPACE.
        CONCATENATE ' * ' ET_PAYSLIP_B3-ZMESSAGE2 INTO ET_PAYSLIP_B3-ZMESSAGE2
                                                    SEPARATED BY SPACE.
      ELSE.
        ET_PAYSLIP_DATA-ZMESSAGE1 = LT_P9001-ZMESSAGE.
        ET_PAYSLIP_B3-ZMESSAGE1 = LT_P9001-ZMESSAGE.
        CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE1 INTO ET_PAYSLIP_DATA-ZMESSAGE1
                                                    SEPARATED BY SPACE.
        CONCATENATE ' * ' ET_PAYSLIP_B3-ZMESSAGE1 INTO ET_PAYSLIP_B3-ZMESSAGE1
                                                    SEPARATED BY SPACE.
      ENDIF.

    ENDIF.

*&---------------------------------------------------------------------*
*&  저장된 임금항목별 금액을 출력을 위한 구조로 전송
*&---------------------------------------------------------------------*
    "지급총액
    IF LT_P0100-P_TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-P_TOTAL TO WAS-P999 CURRENCY 'KRW'.
    ENDIF.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WAS-P999.
    SHIFT WAS-P999 RIGHT DELETING TRAILING SPACE.
    "공제총액
    IF LT_P0100-D_TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-D_TOTAL TO WAS-D99 CURRENCY 'KRW'.
    ENDIF.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WAS-D99.
    SHIFT WAS-D99 RIGHT DELETING TRAILING SPACE.
    "실지급액
    IF LT_P0100-TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-TOTAL TO WAS-TOTAL CURRENCY 'KRW'.
    ENDIF.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WAS-TOTAL.
    SHIFT WAS-TOTAL RIGHT DELETING TRAILING SPACE.

    " 통상시급 급여계산대상기간
*--------------------------------------------------------------------*
* 20250820 체육선수 근무 시간 변경에 따른 명세서 날짜 수정
* 사원 하위 그룹이 체육선수 이면서 직책이 체육이면 104.30
* 그외는 209시간으로 출력인데...
* 급여 대상 근무 기간 받아오는걸로 수정...
*--------------------------------------------------------------------*
    DATA LV_DIVGVXT TYPE STRING.
    IF LT_P0100-ZZPSGRPTX = '체육'.
      LV_DIVGVXT = '104.3'.
    ELSE.
      LV_DIVGVXT = '209'.
    ENDIF.
    ET_PAYSLIP_B3-DIVGV = LV_DIVGVXT.

    "통상시급
    IF  LT_P0100-BET01 IS NOT INITIAL.
      WRITE LT_P0100-BET01 TO WAS-BET01 CURRENCY 'KRW'.
    ENDIF.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WAS-BET01.
    "전월시급
    IF  LT_P0100-BET02 IS NOT INITIAL.
      WRITE LT_P0100-BET02 TO WAS-BET02 CURRENCY 'KRW'.
    ENDIF.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = WAS-BET02.
    MOVE-CORRESPONDING WAS TO ET_PAYSLIP_DATA.
    "급여명세서 수정
    MOVE-CORRESPONDING WAS TO ET_PAYSLIP_B3.

*  특별성과급(비과세)  P27 의 경우 특별성과급(P25)으로 출력하도록
    IF LT_P0100-P27 > 0.
      LT_P0100-P25 = LT_P0100-P27.
    ENDIF.

    " 급여명세서 라인 맞추기
    WRITE LT_P0100-P01 TO WA1-P01 CURRENCY 'KRW'.
    WA1-LGTXT01 = '기  본  급'.
    CONDENSE WA1-P01.

    WRITE LT_P0100-P02 TO WA1-P02 CURRENCY 'KRW'.
    WA1-LGTXT02 = '기본연장급'.
    CONDENSE WA1-P02.

    WRITE LT_P0100-P03 TO WA1-P03 CURRENCY 'KRW'.
    WA1-LGTXT03 = '능  력  급'.
    CONDENSE WA1-P03.

    WRITE LT_P0100-P04 TO WA1-P04 CURRENCY 'KRW'.
    WA1-LGTXT04 = ' '.
    CONDENSE WA1-P04.

    WRITE LT_P0100-P05 TO WA1-P05 CURRENCY 'KRW'.
    WA1-LGTXT05 = '식 대 수 당'.
    CONDENSE WA1-P05.

    WRITE LT_P0100-P06 TO WA1-P06 CURRENCY 'KRW'.
    WA1-LGTXT06 = '현 장 직 무'.
    CONDENSE WA1-P06.

    "    WRITE LT_P0100-P07 TO WA1-P07 CURRENCY 'KRW'.  " 현장휴일근로 수당 병합
    "    WA1-LGTXT07 = '급지수당'.
    "    CONDENSE WA1-P07.

    WRITE LT_P0100-P08 TO WA1-P08 CURRENCY 'KRW'.
    WA1-LGTXT08 = '자격증수당'.
*    WA1-T08 = LT_P0100-T08.
    CONDENSE WA1-P08.

    WRITE LT_P0100-P09 TO WA1-P09 CURRENCY 'KRW'.
    WA1-LGTXT09 = '직책선임수당'.
    CONDENSE WA1-P09.

    WRITE LT_P0100-P10 TO WA1-P10 CURRENCY 'KRW'.
    WA1-LGTXT10 = '해 외 수 당'.
    CONDENSE WA1-P10.

    WRITE LT_P0100-P11 TO WA1-P11 CURRENCY 'KRW'.
    WA1-LGTXT11 = ' '.
    CONDENSE WA1-P11.

    WRITE LT_P0100-P12 TO WA1-P12 CURRENCY 'KRW'.
    WA1-LGTXT12 = '기 타 수 당'.
    CONDENSE WA1-P12.

    WRITE LT_P0100-P13 TO WA1-P13 CURRENCY 'KRW'.
    WA1-LGTXT13 = '당 직 수 당'.
    CONDENSE WA1-P13.

    WRITE LT_P0100-P14 TO WA1-P14 CURRENCY 'KRW'.
    WA1-LGTXT14 = ' '.
    CONDENSE WA1-P14.

    WRITE LT_P0100-P15 TO WA1-P15 CURRENCY 'KRW'.
    WA1-LGTXT15 = '특 근 수 당'.
    CONDENSE WA1-P15.

    WRITE LT_P0100-P16 TO WA1-P16 CURRENCY 'KRW'.
    WA1-LGTXT16 = '조  정  급'.
    CONDENSE WA1-P16.

    WRITE LT_P0100-P17 TO WA1-P17 CURRENCY 'KRW'.
    WA1-LGTXT17 = '연장근무수당'.
    WA1-T17 = LT_P0100-T02.
    CONDENSE WA1-P17.

    WRITE LT_P0100-P18 TO WA1-P18 CURRENCY 'KRW'.
    WA1-LGTXT18 = '야간근무수당'.
    WA1-T18 = LT_P0100-T03.
    CONDENSE WA1-P18.

* 현장휴일근로 =  현장휴일근로 + 급지수당 (명세서만)
    LT_P0100-P19  =   LT_P0100-P19 + LT_P0100-P07.
    WRITE LT_P0100-P19 TO WA1-P19 CURRENCY 'KRW'.
    WA1-LGTXT19 = '현장휴일근로'.
    WA1-T19 = LT_P0100-T04.
    CONDENSE WA1-P19.

    WRITE LT_P0100-P20 TO WA1-P20 CURRENCY 'KRW'.
    WA1-LGTXT20 = '휴일연장수당'.
    WA1-T20 = LT_P0100-T05.
    CONDENSE WA1-P20.

    WRITE LT_P0100-P21 TO WA1-P21 CURRENCY 'KRW'.
    WA1-LGTXT21 = '석식대수당'.
    WA1-T23 = LT_P0100-T06.
    CONDENSE WA1-P21.

    WRITE LT_P0100-P22 TO WA1-P22 CURRENCY 'KRW'.
    WA1-LGTXT22 = '연 차 수 당'.
    WA1-T22 = LT_P0100-T07.
    CONDENSE WA1-P22.

    WRITE LT_P0100-P23 TO WA1-P23 CURRENCY 'KRW'.
    WA1-LGTXT23 = '정 기 상 여'.
    WA1-T23 = LT_P0100-T08.
    CONDENSE WA1-P23.

    WRITE LT_P0100-P24 TO WA1-P24 CURRENCY 'KRW'.
    WA1-LGTXT24 = '특 별 상 여'.
    WA1-T24 = LT_P0100-T08.
    CONDENSE WA1-P24.

    WRITE LT_P0100-P25 TO WA1-P25 CURRENCY 'KRW'.
    WA1-LGTXT25 = '특별성과급'.
    WA1-T25 = LT_P0100-T08.
    CONDENSE WA1-P25.

*   #5951 휴가비 추가
    WRITE LT_P0100-P26 TO WA1-P26 CURRENCY 'KRW'.
    WA1-LGTXT26 = '휴가비'.
*    WA1-T25 = LT_P0100-T08.
    CONDENSE WA1-P26.

*   20250515 기타수당(과세X) 추가
    WRITE LT_P0100-P28 TO WA1-P28 CURRENCY 'KRW'.
    WA1-LGTXT28 = '기 타 지 급'.
    CONDENSE WA1-P28.


    WRITE LT_P0100-P30 TO WA1-P30 CURRENCY 'KRW'.
    WA1-LGTXT30 = '기 지 급 금'.
    CONDENSE WA1-P30.

    WRITE LT_P0100-R_TOTAL  TO WA1-P31 CURRENCY 'KRW'.
    WA1-LGTXT31 = '소  급  분'.
    CONDENSE WA1-P31.

**  20260320 AI수당 추가
    WRITE LT_P0100-P32  TO WA1-P32 CURRENCY 'KRW'.
    WA1-LGTXT32 = 'AI 활용지원'.
    CONDENSE WA1-P32.

***공제액명세  부분

    WRITE LT_P0100-D01   TO WA2-D01 CURRENCY 'KRW'.
    WA2-LGTXT_01         = '소  득  세'.
    CONDENSE WA2-D01.

    WRITE LT_P0100-D02   TO WA2-D02 CURRENCY 'KRW'.
    WA2-LGTXT_02         = '주  민  세'.
    CONDENSE WA2-D02.

    WRITE LT_P0100-D01_1 TO WA2-D03 CURRENCY 'KRW'.
    WA2-LGTXT_03         = '정산소득세'.
    CONDENSE WA2-D03.

    WRITE LT_P0100-D02_1 TO WA2-D04 CURRENCY 'KRW'.
    WA2-LGTXT_04         = '정산주민세'.
    CONDENSE WA2-D04.

    WRITE LT_P0100-D03   TO WA2-D05 CURRENCY 'KRW'.
    WA2-LGTXT_05         = '국 민 연 금'.
    CONDENSE WA2-D05.

    WRITE LT_P0100-D04   TO WA2-D06 CURRENCY 'KRW'.
    WA2-LGTXT_06         = '건 강 보 험'.
    CONDENSE WA2-D06.

    WRITE LT_P0100-D04_1 TO WA2-D07 CURRENCY 'KRW'.
    WA2-LGTXT_07         = '건강보험정산'.
    CONDENSE WA2-D07.

    WRITE LT_P0100-D05   TO WA2-D08 CURRENCY 'KRW'.
    WA2-LGTXT_08         = '장 기 요 양'.
    CONDENSE WA2-D08.

    WRITE LT_P0100-D05_1 TO WA2-D09 CURRENCY 'KRW'.
    WA2-LGTXT_09         = '장기요양정산'.
    CONDENSE WA2-D09.


    WRITE LT_P0100-D06_2 TO WA2-D10 CURRENCY 'KRW'.
    WA2-LGTXT_10         = '고 용 보 험'.
    CONDENSE WA2-D10.

    WRITE LT_P0100-D07   TO WA2-D11 CURRENCY 'KRW'.
    WA2-LGTXT_11 = ' '.
    CONDENSE WA2-D11.

    WRITE LT_P0100-D08   TO WA2-D12 CURRENCY 'KRW'.
    WA2-LGTXT_12         = '주  차  비'.
    CONDENSE WA2-D12.

    WRITE LT_P0100-D09   TO WA2-D13 CURRENCY 'KRW'.
    WA2-LGTXT_13         = '구 내 식 당'.
    CONDENSE WA2-D13.

    WRITE LT_P0100-D10   TO WA2-D14 CURRENCY 'KRW'.
    WA2-LGTXT_14         = '린 라 운 지'.
    CONDENSE WA2-D14.

    WRITE LT_P0100-D11   TO WA2-D15 CURRENCY 'KRW'.
    WA2-LGTXT_15         = '통 근 버 스'.
    CONDENSE WA2-D15.

    WRITE LT_P0100-D12   TO WA2-D16 CURRENCY 'KRW'.
    WA2-LGTXT_16         = '복지월상환금'.
    CONDENSE WA2-D16.

    WRITE LT_P0100-D13   TO WA2-D17 CURRENCY 'KRW'.
    WA2-LGTXT_17         = '복 지 이 자'.
    CONDENSE WA2-D17.

    WRITE LT_P0100-D14   TO WA2-D18 CURRENCY 'KRW'.
    WA2-LGTXT_18         = '경  조  비'.
    CONDENSE WA2-D18.

    WRITE LT_P0100-D15   TO WA2-D19 CURRENCY 'KRW'.
    WA2-LGTXT_19         = '기 타 공 제'.
    CONDENSE WA2-D19.

    WRITE LT_P0100-D16   TO WA2-D20 CURRENCY 'KRW'.
    WA2-LGTXT_20         = '학자금대출'.
    CONDENSE WA2-D20.

    WRITE LT_P0100-D17   TO WA2-D21 CURRENCY 'KRW'.
    WA2-LGTXT_21         = '통신비공제'.
    CONDENSE WA2-D21.

    WRITE LT_P0100-D01_9    TO WA2-D22 CURRENCY 'KRW'.
    WA2-LGTXT_22         = '연말정산소득세'.
    CONDENSE WA2-D22.

    WRITE LT_P0100-D02_9   TO WA2-D23 CURRENCY 'KRW'.
    WA2-LGTXT_23         = '연말정산주민세'.
    CONDENSE WA2-D23.

    FIELD-SYMBOLS: <FS_LGTXX>   TYPE ANY,
                   <FS_BETXX>   TYPE ANY,
                   <FS_ANZXX>   TYPE ANY,
                   <FS_LGTXX_2> TYPE ANY,
                   <FS_BETXX_2> TYPE ANY,
                   <FS_ANZXX_2> TYPE ANY.
*&---------------------------------------------------------------------*
*&  지급항목 가공 (금액이 있는 경우에만 출력)
*&---------------------------------------------------------------------*
    CLEAR: LV_NUM, LV_NUM_2, WA1_1.
    DO 32 TIMES.
      LV_NUM = LV_NUM + 1.

      UNASSIGN: <FS_LGTXX>, <FS_BETXX>, <FS_ANZXX>.

      "임금유형 텍스트
      CLEAR LV_TEXT.
      CONCATENATE 'WA1-LGTXT' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_LGTXX>.

      "금액
      CLEAR LV_TEXT.
      CONCATENATE 'WA1-P' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_BETXX>.

      "수
      CLEAR LV_TEXT.
      CONCATENATE 'WA1-T' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_ANZXX>.

      IF <FS_LGTXX> IS NOT INITIAL AND <FS_BETXX> NE '0' .
        LV_NUM_2 = LV_NUM_2 + 1.

        "임금유형 텍스트
        CLEAR LV_TEXT.
        CONCATENATE 'WA1_1-LGTXT' LV_NUM_2 INTO LV_TEXT.
        ASSIGN (LV_TEXT) TO <FS_LGTXX_2>.

        "금액
        CLEAR LV_TEXT.
        CONCATENATE 'WA1_1-P' LV_NUM_2 INTO LV_TEXT.
        ASSIGN (LV_TEXT) TO <FS_BETXX_2>.

        "수
        CLEAR LV_TEXT.
        CONCATENATE 'WA1_1-T' LV_NUM_2 INTO LV_TEXT.
        ASSIGN (LV_TEXT) TO <FS_ANZXX_2>.


        MOVE <FS_LGTXX> TO <FS_LGTXX_2>.
        MOVE <FS_BETXX> TO <FS_BETXX_2>.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = <FS_BETXX_2>.
        SHIFT <FS_BETXX_2> RIGHT DELETING TRAILING SPACE.
        MOVE <FS_ANZXX> TO <FS_ANZXX_2>.

        ADD 1 TO LV_NUM_2.
        IF LV_NUM_2 > 9.
          LV_NUM_2 = 1.
        ENDIF.
      ENDIF.

      UNASSIGN : <FS_LGTXX>, <FS_BETXX>, <FS_ANZXX>.

    ENDDO.

    MOVE-CORRESPONDING WA1_1 TO ET_PAYSLIP_DATA.
    "급여명세서 수정
    MOVE-CORRESPONDING WA1_1 TO ET_PAYSLIP_B3.
*&---------------------------------------------------------------------*
*&  공제항목 가공 (금액이 있는 경우에만 출력)
*&---------------------------------------------------------------------*
    CLEAR: LV_NUM, LV_NUM_2, WA2_2.
    DO 27 TIMES.

      LV_NUM = LV_NUM + 1.

      UNASSIGN: <FS_LGTXX>, <FS_BETXX>.

      "임금유형 텍스트
      CLEAR LV_TEXT.
      CONCATENATE 'WA2-LGTXT_' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_LGTXX>.

      "금액
      CLEAR LV_TEXT.
      CONCATENATE 'WA2-D' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_BETXX>.

      IF <FS_LGTXX> IS NOT INITIAL AND <FS_BETXX> NE '0'.
        LV_NUM_2 = LV_NUM_2 + 1.

        "임금유형 텍스트
        CLEAR LV_TEXT.
        CONCATENATE 'WA2_2-LGTXT_' LV_NUM_2 INTO LV_TEXT.
        ASSIGN (LV_TEXT) TO <FS_LGTXX_2>.

        "금액
        CLEAR LV_TEXT.
        CONCATENATE 'WA2_2-D' LV_NUM_2 INTO LV_TEXT.
        ASSIGN (LV_TEXT) TO <FS_BETXX_2>.


        MOVE <FS_LGTXX> TO <FS_LGTXX_2>.
        MOVE <FS_BETXX> TO <FS_BETXX_2>.
        CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
          CHANGING
            VALUE = <FS_BETXX_2>.
        SHIFT <FS_BETXX_2> RIGHT DELETING TRAILING SPACE.

        ADD 1 TO LV_NUM_2.
        IF LV_NUM_2 > 13.
          LV_NUM_2 = 1.
        ENDIF.
      ENDIF.

    ENDDO.

    MOVE-CORRESPONDING: WA2_2 TO ET_PAYSLIP_DATA,
                        WA2_2 TO ET_PAYSLIP_B3. "급여명세서 수정
*&---------------------------------------------------------------------*
*&  근무일수 및 근무시간추가
*&---------------------------------------------------------------------*
    WRITE : LT_P0100-PAYDT  TO ET_PAYSLIP_DATA-PAYDT  MM/DD/YYYY,
            LT_P0100-ZPAYDT TO ET_PAYSLIP_DATA-ZPAYDT MM/DD/YYYY.

    DATA : L_TIME(6)    TYPE P DECIMALS 2,
           L_TIME_ND(6) TYPE P DECIMALS 2,
           L_DAY(3)     TYPE P DECIMALS 0.
    "근로일수
    ET_PAYSLIP_DATA-TIM01 = L_DAY  = LT_P0100-H00.
    "총 근무시간수
    ET_PAYSLIP_DATA-TIM02 = L_TIME = LT_P0100-H99.
    "연장근로시간
    ET_PAYSLIP_DATA-TIM03 = L_TIME = LT_P0100-T02.
    "야간근로시간
    ET_PAYSLIP_DATA-TIM04 = L_TIME = LT_P0100-T03 .
    "휴일근무근로시간
    ET_PAYSLIP_DATA-TIM05 = L_TIME = LT_P0100-T04.
    "휴일연장근무근로시간
    ET_PAYSLIP_DATA-TIM06 = L_TIME = LT_P0100-T05.
    "휴일야간근무근로시간
    ET_PAYSLIP_DATA-TIM07 = L_TIME = LT_P0100-T06.
    "***********휴일근무에 휴일연장 휴일야간 합산한 로직(분리표시시 해당 주석 함..)
    "    ET_PAYSLIP_DATA-TIM05 = L_TIME = LT_P0100-T04 + LT_P0100-T05 + LT_P0100-T06.
    "**********
    "직인출력 옵션추가
    " ************************************  급여 명세서 수정 ************************************
    "근무일수 및 근무시간 추가
    WRITE : LT_P0100-PAYDT  TO ET_PAYSLIP_B3-PAYDT  MM/DD/YYYY,
            LT_P0100-ZPAYDT TO ET_PAYSLIP_B3-ZPAYDT MM/DD/YYYY.
    "중도입,퇴사자는 소수점 첫번째 자리까지만 표기
    DATA: L_TIME_M(6) TYPE P DECIMALS 1,
          LV_WDAYS    TYPE I.

    " 총 연장 근무 시간
    DATA LV_TOTAL02 TYPE ZHRT0100-T02.

    "기본 연장 근무 시간 계산식 변경
    DATA : LV_BEGDA_TIME TYPE BEGDA.
    DATA : LV_ENDDA_TIME TYPE ENDDA.

*--------------------------------------------------------------------*
* 우미 로직 수정 03.03.2026 13:40:48 by SEPPIN
* IT2010 조회용 날짜 별도 운용
*--------------------------------------------------------------------*
    DATA: LV_BEGDA_2010    TYPE BEGDA,
          LV_ENDDA_2010    TYPE ENDDA,
          LV_PABRP_2010(2) TYPE N.

    CLEAR LV_PABRP_2010.
    LV_PABRP_2010 = LT_P0100-PABRP - 1.

    LV_BEGDA_2010 = |{ LT_P0100-PABRJ }{ LV_PABRP_2010 }21|.
    LV_ENDDA_2010 = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }20|.
*--------------------------------------------------------------------*
    LV_BEGDA_TIME = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }01|.

    CONDENSE LV_BEGDA_TIME NO-GAPS.

    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN            = LV_BEGDA_TIME
      IMPORTING
        LAST_DAY_OF_MONTH = LV_ENDDA_TIME.

    " 250516 zhrt0001 에서 해당 월의 연장 및 야간 수당 합산해서 가져오기
    DATA LT_ZHRPT0001 TYPE TABLE OF ZHRPT0001 WITH HEADER LINE.

*    SELECT lgart,
*      SUM( anzhl )
*       FROM zhrpt0001
*      WHERE pernr IN @ir_pernr
*      AND begda BETWEEN @lv_begda_time AND @lv_endda_time
*      GROUP BY lgart
*      INTO TABLE @lt_zhrpt0001.

*<- added by SEPPIN 08.07.2025 14:02:12
    " 202506월부터 야간근무시간에 전월 시간 포함으로 해당 월만 가져오는 로직 수정
*>- added by SEPPIN 08.07.2025 14:02:12
    SELECT * FROM ZHRPT0001
      WHERE PERNR IN @IR_PERNR
*      AND begda BETWEEN @lv_begda_time AND @lv_endda_time
      INTO TABLE @LT_ZHRPT0001.

    "일할 계산
*    "일할 계산용 시간 변수
*    "34라 가정, 만근 20일 기준 일당 1.7
*    DATA: lv_time TYPE p DECIMALS 1.
*    lv_time = '1.7'.
    "wpbp가 두줄일 시 중도퇴사자로 간주
    DESCRIBE TABLE LT_WPBP LINES LV_LINES.
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
*--------------------------------------------------------------------*
    DATA : LS_0001 TYPE PA0001.
    CLEAR LS_0001.
    SELECT SINGLE PERSK PERSG FROM PA0001
      INTO CORRESPONDING FIELDS OF LS_0001
      WHERE PERNR = LT_P0100-PERNR
      AND ORGEH IN IR_ORGEH
      AND BEGDA <= LT_P0100-PAYDT
    AND ENDDA >= LT_P0100-PAYDT.


    "근로일수 = lt_p0100-h00
    "기본연장근무시간 및 초과연장근무시간(기본연장근무시간인 34시간을 초과한 값)
    "기본연장급이 없으나 중도입사/퇴사한 인원(일할계산)
    "일할계산 / 0
    "집계된 연장시간보다 일할계산된 시간이 초과될 경우 초과된 시간은 초과연장근무시간으로
    CLEAR LS_WPBP.
    IF LT_P0100-P02 IS INITIAL AND LT_WPBP[] IS NOT INITIAL.
      CASE LV_LINES.
        WHEN 1. "신규입사자
          LOOP AT LT_WPBP[] INTO LS_WPBP.
            IF ( LV_LINES = 1 AND LS_WPBP-BEGDA+6(2) NE '01' )."신규입사자
              "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
              IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
                LV_WDAYS = 1.
              ELSE.
                LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
              ENDIF.
*              et_payslip_b3-tim01 = l_time_m = lv_time * lv_wdays.
              "기본연장근무시간 = 34(기본연장근무시간) / 근무일수
              "근무일수가 27일보다 적으면 신규입사자로 판단
              IF LV_WDAYS < 27.
                "계산식 변경
                "아래 조건문 ELSE로 이동
*                ET_PAYSLIP_B3-TIM01 = L_TIME_M = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
*                et_payslip_b3-tim01 = l_time_m = 34 / lv_wdays.
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 변경 및 조건문 추가
*--------------------------------------------------------------------*
                IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
                ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "**다기능공
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
                ELSE.
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
                ENDIF.

              ELSE.
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 변경 및 조건문 추가
*--------------------------------------------------------------------*
                IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
                ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "**다기능공
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
                ELSE.
                  ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
                ENDIF.
*                ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
              ENDIF.

              " 20250216 총 연장 근무 시간을 구한 후 일할 계산
*              lv_total02 = l_time = 0.
*              LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*                lv_total02 = l_time = lv_total02 + lt_zhrpt0001-anzhl.
*              ENDLOOP.
*              lv_total02 = l_time = lv_total02 / lv_wdays.
*
*              " 총 근무 시간이 기본 근무 시간보다 많은 경우 차감
*              IF lv_total02 > et_payslip_b3-tim01.
*                et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*                et_payslip_b3-tim02 = l_time = lv_total02 - et_payslip_b3-tim01.
*              ELSE.
*                et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*                et_payslip_b3-tim02 = l_time = 0.
*              ENDIF.



              "연장시간이 있고 기본연장근무시간이 연장시간보다 클 경우
              "초과연장근무시간 = 연장시간 - 기본연장근무시간
*              IF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 > lt_p0100-t02.
*                et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
**                et_payslip_b3-tim02 = l_time = et_payslip_b3-tim01 - lt_p0100-t02.
*                et_payslip_b3-tim02 = l_time = 0.
*                "연장시간이 있고 기본연장근무시간이 연장시간보다 작을 경우
*                "/ 기본연장근무시간 = 연장시간 / 근무일수
*              ELSEIF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 < lt_p0100-t02.
**                et_payslip_b3-tim01_o = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*                et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
**                et_payslip_b3-tim02 = l_time = 0.
*
*                "et_payslip_b3-tim02 = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*
*                "연장시간이 없을 경우
*                "/ 기본연장근무시간 및 초과연장근무시간 = 0
*              ELSEIF lt_p0100-t02 IS INITIAL.
*                et_payslip_b3-tim01_o = l_time = 0.
*                et_payslip_b3-tim02 = l_time = 0.
*              ENDIF.

            ENDIF.
          ENDLOOP.
        WHEN OTHERS. "중도퇴사자
          "해당월 1일 ~ 퇴사일 이전의 날짜까지 일할계산
          LOOP AT LT_WPBP[] INTO LS_WPBP WHERE BEGDA+6(2) EQ '01'.
*           IF ( lv_lines = 1 AND ls_wpbp-begda+6(2) NE '01' )."신규입사자
            "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
            IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
            ENDIF.
*            et_payslip_b3-tim01 = l_time_m = lv_time * lv_wdays.
            "기본연장근무시간 = 34(기본연장근무시간) / 근무일수
            "계산식 변경 = 34(기본연장근무시간) / 해당 월 수 * 근무일수
*--------------------------------------------------------------------*
*             우미 로직 수정 18.03.2026 14:11:10 by SEPPIN
*             아래 조건문에 넣기위해 비활성화함
*            ET_PAYSLIP_B3-TIM01 = L_TIME_M = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
*--------------------------------------------------------------------*
*            et_payslip_b3-tim01 = l_time_m = 34 / lv_wdays.

*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 변경 및 조건문 추가
*--------------------------------------------------------------------*
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "**다기능공
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ENDIF.

            " 20250216 총 연장 근무 시간을 구한 후 일할 계산
*            lv_total02 = l_time = 0.
*            LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*              lv_total02 = l_time = lv_total02  + lt_zhrpt0001-anzhl.
*            ENDLOOP.
*            lv_total02 = l_time = lv_total02 / lv_wdays.
*
*            " 총 근무 시간이 기본 근무 시간보다 많은 경우 차감
*            IF lv_total02 > et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*              et_payslip_b3-tim02 = l_time = lv_total02 - et_payslip_b3-tim01.
*            ELSE.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.

            "연장시간이 있고 기본연장근무시간이 연장시간보다 클 경우
            "초과연장근무시간 = 연장시간 - 기본연장근무시간
*            IF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 > lt_p0100-t02.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
**              et_payslip_b3-tim02 = l_time = et_payslip_b3-tim01 - lt_p0100-t02.
*              et_payslip_b3-tim02 = l_time = 0.
*              "연장시간이 있고 기본연장근무시간이 연장시간보다 작을 경우
*              "/ 기본연장근무시간 = 연장시간 / 근무일수
*            ELSEIF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 < lt_p0100-t02.
**              et_payslip_b3-tim01_o = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
**              et_payslip_b3-tim02 = l_time = 0.
*              "연장시간이 없을 경우
*              "/ 기본연장근무시간 및 초과연장근무시간 = 0
*            ELSEIF lt_p0100-t02 IS INITIAL.
*              et_payslip_b3-tim01_o = l_time = 0.
*              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.
*            ENDIF.

          ENDLOOP.
      ENDCASE.

      "기본연장급이 있고, 중도입사/퇴사 이력이 없는 인원 = 34시간 (일괄)
      "34시간 / 0
      "집계된 연장시간보다 기본연장근무시간이 초과될 경우 초과된 시간은 초과연장근무시간으로
    ELSEIF LT_P0100-P02 IS NOT INITIAL AND LT_WPBP[] IS INITIAL.

*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
*--------------------------------------------------------------------*
      IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
        ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
      ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
        ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
      ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
        ET_PAYSLIP_B3-TIM01 = L_TIME = 18.
      ELSE.
        ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
      ENDIF.


      " 20250216 총 연자 근무 시간을 구한 후 기본 연장 근무 시간 차감
*      lv_total02 = l_time = 0.
*      LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*        lv_total02 = l_time = lv_total02  + lt_zhrpt0001-anzhl.
*      ENDLOOP.

      " 총 근무 시간이 기본 근무 시간보다 많은 경우 차감
*      IF lv_total02 > et_payslip_b3-tim01.
*        et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*        et_payslip_b3-tim02 = l_time = lv_total02 - et_payslip_b3-tim01.
*      ELSE.
*        et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*        et_payslip_b3-tim02 = l_time = 0.
*      ENDIF.

      "연장시간이 기본연장근무시간보다 초과될 경우
      "/ 기본연장근무시간 = 기본연장근무시간
      "초과연장근무시간 = 연장시간 - 기본연장근무시간
*      IF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 > lt_p0100-t02.
*        et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
**        et_payslip_b3-tim02 = et_payslip_b3-tim01 - lt_p0100-t02.
*        et_payslip_b3-tim02 = l_time = 0.
*        "연장시간이 기본연장근무시간보다 적을 경우
*        "/ 기본연장근무시간 = 기본연장근무시간(34) - 연장근무시간
*        "초과연장근무시간 = 0
*      ELSEIF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 < lt_p0100-t02.
*        et_payslip_b3-tim01_o = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
**        et_payslip_b3-tim02 = l_time = 0.
*        et_payslip_b3-tim02 = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*        "연장근무시간이 없을 경우
*        "/ 기본연장근무시간 = 기본연장근무시간
*        "초과연장근무시간 = 0
*      ELSEIF lt_p0100-t02 IS INITIAL.
*        et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*        et_payslip_b3-tim02 = l_time = 0.
*      ENDIF.

      "기본연장급이 있고 중도입사/퇴사 이력이 있는 인원(일할계산)
      "일할계산 / 연장근무시간 - 일할계산
      "초과연장근무시간은 일할계산분이 연장근무시간 초과 시 나머지분으로
    ELSEIF LT_P0100-P02 IS NOT INITIAL AND LT_WPBP[] IS NOT INITIAL.
      CASE LV_LINES.
        WHEN 1.
          LOOP AT LT_WPBP[] INTO LS_WPBP.
            "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
            IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
            ENDIF.
            IF LV_WDAYS < 27. "신규입사자
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
*--------------------------------------------------------------------*
              IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
                ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
              ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
              ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 18 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
              ELSE.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
              ENDIF.
*--------------------------------------------------------------------*
*               우미 로직 수정 18.03.2026 14:51:57 by SEPPIN

              "기본연장근무시간 = 34(기본연장근무시간) / 근무일수
*              ET_PAYSLIP_B3-TIM01 = L_TIME_M = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
*--------------------------------------------------------------------*


*                et_payslip_b3-tim01 = l_time_m = 34 / lv_wdays.

*              " 20250216 총 연자 근무 시간을 구한 후 일할 계산
*              lv_total02 = l_time = 0.
*              LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*                lv_total02 = l_time = lv_total02  + lt_zhrpt0001-anzhl.
*              ENDLOOP.
*              lv_total02 = l_time = lv_total02 / lv_wdays.

            ELSE.
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
*--------------------------------------------------------------------*
              IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
                ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
              ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
              ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 18.
              ELSE.
                ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
              ENDIF.

              "신규, 중도가 아닐 경우 일괄 34
*              ET_PAYSLIP_B3-TIM01 = L_TIME = 34.

*              " 20250216 총 연자 근무 시간을 구한 후 일할 계산
*              lv_total02 = l_time = 0.
*              LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*                lv_total02 = l_time = lv_total02  + lt_zhrpt0001-anzhl.
*              ENDLOOP.
*              lv_total02 = l_time = lv_total02 .

            ENDIF.

            " 총 근무 시간이 기본 근무 시간보다 많은 경우 차감
*            IF lv_total02 > et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*              et_payslip_b3-tim02 = l_time = lv_total02 - et_payslip_b3-tim01.
*            ELSE.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
*              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.

            "연장시간이 있으나 기본연장근무시간보다 적을 경우
            "/ 기본연장근무시간 = 연장시간 / 근무 일수
            "초과연장근무시간 = 0
*            IF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 > lt_p0100-t02.
**              et_payslip_b3-tim01_o = et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
*              et_payslip_b3-tim02 = l_time = 0.
*
*              "연장시간이 있으며 기본연장근무시간보다 클 경우
*              "/ 기본연장근무시간 = 연장시간 / 근무 일수
*              "초과연장근무시간 = 연장시간 - 기본연장근무시간
*            ELSEIF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 < lt_p0100-t02.
*              et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
**              et_payslip_b3-tim02 = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*            ELSEIF lt_p0100-t02 IS INITIAL.
*              "연장시간이 없을 경우
*              "/ 기본연장근무시간 = 0
*              "초과연장근무시간 = 0
**              et_payslip_b3-tim01_o = et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time = 0.
*              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.

          ENDLOOP.

        WHEN OTHERS. "중도퇴사자
          LOOP AT LT_WPBP[] INTO LS_WPBP.
            "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
            IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
            ENDIF.
            "기본연장근무시간 = 34(기본연장근무시간) / 근무일수
*            ET_PAYSLIP_B3-TIM01 = L_TIME_M = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
*            et_payslip_b3-tim01 = l_time_m = 34 / lv_wdays.
*--------------------------------------------------------------------*
* 우미 로직 수정 18.03.2026 10:48:39 by SEPPIN
* 직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
*--------------------------------------------------------------------*
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 18 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ENDIF.


            " 20250216 총 연자 근무 시간을 구한 후 일할 계산
*            lv_total02 = l_time = 0.
*            LOOP AT lt_zhrpt0001 WHERE lgart EQ '3100'.
*              lv_total02 = l_time = lv_total02  + lt_zhrpt0001-anzhl.
*            ENDLOOP.
*            lv_total02 = l_time = lv_total02 / lv_wdays.

            " 총 근무 시간이 기본 근무 시간보다 많은 경우 차감
*            IF lv_total02 > et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
**              et_payslip_b3-tim02 = l_time = lv_total02 - et_payslip_b3-tim01.
*            ELSE.
*              et_payslip_b3-tim01_o = l_time = et_payslip_b3-tim01.
**              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.

            "연장시간이 있으나 기본연장근무시간보다 적을 경우
            "/ 기본연장근무시간 = 연장시간 / 근무 일수
            "초과연장근무시간 = 0
*            IF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 > lt_p0100-t02.
**              et_payslip_b3-tim01_o = et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
*              et_payslip_b3-tim02 = l_time = 0.
*              "연장시간이 있으며 기본연장근무시간보다 클 경우
*              "/ 기본연장근무시간 = 연장시간 / 근무 일수
*              "초과연장근무시간 = 연장시간 - 기본연장근무시간
*            ELSEIF lt_p0100-t02 IS NOT INITIAL AND et_payslip_b3-tim01 < lt_p0100-t02.
*              et_payslip_b3-tim01_o = l_time_m = lt_p0100-t02 / lv_wdays.
**              et_payslip_b3-tim02 = l_time = lt_p0100-t02 - et_payslip_b3-tim01.
*            ELSEIF lt_p0100-t02 IS INITIAL.
*              "연장시간이 없을 경우
*              "/ 기본연장근무시간 = 0
*              "초과연장근무시간 = 0
**              et_payslip_b3-tim01_o = et_payslip_b3-tim01.
*              et_payslip_b3-tim01_o = l_time = 0.
*              et_payslip_b3-tim02 = l_time = 0.
*            ENDIF.

          ENDLOOP.
      ENDCASE.
      "기본연장급이 없을 경우 = 0시간(일괄)
      "0 / 0
      "초과연장근무시간도 연장근무시간과 동일
    ELSEIF LT_P0100-P02 IS INITIAL.
      ET_PAYSLIP_B3-TIM01 = L_TIME = 0.
*      et_payslip_b3-tim01_o = l_time = lt_p0100-p02.
      "기본연장급이 없을 경우 기본연장근무시간의 모든 항목은 0
      ET_PAYSLIP_B3-TIM01_O = L_TIME = 0.
*      et_payslip_b3-tim02 = l_time = lt_p0100-p02.
      "기본연장급이 없을 경우 초과연장근무시간도 0
*      et_payslip_b3-tim02 = l_time = 0.
    ENDIF.

    "야간근무시간 250630까지는 고정 근무, 이후부터는 일할 계산
*    et_payslip_b3-tim03 = l_time = lt_p0100-t03.
    " 20250516 야간 근무 수당만 가져와서 합산하기

*--------------------------------------------------------------------*
* 우미 로직 수정 07.04.2026 11:23:02 by SEPPIN
* 초과연장근무시간 집계 방식 수정(IT2010->ZHRPT0001)
* 대상 기간 내 zhrpt0001의 lgart '3100' 시간 일괄 합산
* 기본연장근무시간이 34시간인 대상자에 한해 기본연장근무시간을 초과할 경우
* 초과분만 입력
*--------------------------------------------------------------------*
    DATA: LV_TIM02(6) TYPE P DECIMALS 2,
          LV_TIM03(6) TYPE P DECIMALS 2,
          LV_ZEROP    TYPE P DECIMALS 2 VALUE '1.50'.

    CLEAR: LT_ZHRPT0001, LV_TIM02.

    "초과근로 테이블 조회
    SELECT *
      FROM ZHRPT0001 INTO CORRESPONDING FIELDS OF TABLE LT_ZHRPT0001
        WHERE PERNR IN IR_PERNR
          AND BEGDA BETWEEN LV_BEGDA_2010 AND LV_ENDDA_2010.

    "기본연장근무시간이 34시간 이상인 경우, 아닌 경우로 분기
    IF ET_PAYSLIP_B3-TIM01 >= 34.
      LOOP AT LT_ZHRPT0001 ASSIGNING FIELD-SYMBOL(<FS_ZHRPT0001>) WHERE LGART = '3100'.
        LV_TIM02 = LV_TIM02 + <FS_ZHRPT0001>-ANZHL.
      ENDLOOP.

      ET_PAYSLIP_B3-TIM02 = L_TIME = LV_TIM02 / LV_ZEROP.
      "기존 계산
      IF IR_PAYDT-LOW(6) <= '202504'.
        LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                                            AND ZYYMM EQ IR_PAYDT-LOW(6).
          ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
        ENDLOOP.
      ELSEIF IR_PAYDT-LOW(6)  = '202505'.
        LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                                            AND BEGDA >= '20250501'
                                            AND BEGDA <= '20250520'.
          ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
        ENDLOOP.
      ELSE.
        UNASSIGN <FS_ZHRPT0001>.
        LOOP AT LT_ZHRPT0001 ASSIGNING <FS_ZHRPT0001> WHERE LGART = '3200'.
          LV_TIM03 = LV_TIM03 + <FS_ZHRPT0001>-ANZHL.
        ENDLOOP.

        ET_PAYSLIP_B3-TIM03 = L_TIME = LV_TIM03.
      ENDIF.
    ELSEIF ET_PAYSLIP_B3-TIM01 < 34.
      ET_PAYSLIP_B3-TIM02 = ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
    ENDIF.

    DATA :
      LT_PA2010 TYPE TABLE OF PA2010 WITH HEADER LINE,
      LS_PA2010 TYPE PA2010.

    SELECT * FROM PA2010
      INTO CORRESPONDING FIELDS OF TABLE  LT_PA2010
      WHERE PERNR IN IR_PERNR
      "AND BEGDA BETWEEN LV_BEGDA_TIME AND LV_ENDDA_TIME
      AND BEGDA BETWEEN LV_BEGDA_2010 AND LV_ENDDA_2010
    ORDER BY BEGDA DESCENDING.
*
*    READ TABLE LT_PA2010 WITH KEY LGART = '3100'.
*    ET_PAYSLIP_B3-TIM02 = L_TIME = LT_PA2010-ANZHL / LV_ZEROP.
*      et_payslip_b3-tim02 = lt_pa2010.

*<- added by SEPPIN 08.07.2025 11:42:11
    "  202504월까지는 당월
    " 202505부터 1 ~ 20일까지
    " 202506부터 전월 21부터 당월 20일까지로 변경되었기 때문에 로직 수정
*>- added by SEPPIN 08.07.2025 11:42:11

*    ET_PAYSLIP_B3-TIM03 = L_TIME = 0.

*    IF IR_PAYDT-LOW(6) <= '202504'.
*      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
*                                          AND ZYYMM EQ IR_PAYDT-LOW(6).
*        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
*      ENDLOOP.
*    ELSEIF IR_PAYDT-LOW(6)  = '202505'.
*      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
*                                          AND BEGDA >= '20250501'
*                                          AND BEGDA <= '20250520'.
*        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
*      ENDLOOP.
*    ELSE.
*
*      DATA:
*        LV_TIM03BEG TYPE BEGDA,
*        LV_TIM03END TYPE ENDDA.
*
*      CLEAR LV_DATE.
*      CONCATENATE IR_PAYDT-LOW(6) '01' INTO LV_TIM03BEG.
*      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*        EXPORTING
*          DATE      = LV_TIM03BEG
*          DAYS      = '00'
*          MONTHS    = '01'
*          SIGNUM    = '-'
*          YEARS     = '00'
*        IMPORTING
*          CALC_DATE = LV_TIM03BEG.
*
*      CONCATENATE LV_TIM03BEG(6)  '21' INTO LV_TIM03BEG.
*      CONCATENATE IR_PAYDT-LOW(6) '20' INTO LV_TIM03END.
*
*      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
*                                          AND BEGDA >= LV_TIM03BEG
*                                          AND BEGDA <= LV_TIM03END.
*        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
*      ENDLOOP.
*    ENDIF.

    DATA:
      LV_TIM04 TYPE CHAR6,
      LV_TIM05 TYPE CHAR6.

    " 현장휴일근로 25년7월부터는 2010 횟수 계산, 그 전에는 하위그룹에 따른 시간 고정
    IF V_BEGDA(6) >= '202507'.
*--------------------------------------------------------------------*
* 우미 로직 수정 03.03.2026 14:04:18 by SEPPIN
* 오타인듯 함(특근수당 임금유형 = 3600)
*      READ TABLE LT_PA2010 WITH KEY LGART = '1600'.
      READ TABLE LT_PA2010 WITH KEY LGART = '3600'.
      LV_TIM04 = ( LT_PA2010-ANZHL / 14 ) * 8.
      LV_TIM05 = ( LT_PA2010-ANZHL / 14 ).
*--------------------------------------------------------------------*
    ELSE.
      " 20250618 사원 그룹 및 하위 그룹 가져오기
      DATA:
        LT_PA0001 TYPE TABLE OF PA0001,
        LS_PA0001 TYPE PA0001.

      SELECT SINGLE * FROM PA0001
        INTO CORRESPONDING FIELDS OF LS_PA0001
        WHERE PERNR = ET_PAYSLIP_B3-PERNR
        AND ORGEH IN IR_ORGEH
        AND BEGDA <= LT_P0100-PAYDT
        AND ENDDA >= LT_P0100-PAYDT.

      " 직영반장이나 일반일 경우 32/4로 값 변경
      IF LS_PA0001-PERSG EQ '5'
        AND ( LS_PA0001-PERSK EQ 'E0' OR LS_PA0001-PERSK = 'E1' ).
        LV_TIM04 = '32'.
        LV_TIM05 = '4'.
      ELSE.
        LV_TIM04 = '16'.
        LV_TIM05 = '2'.
      ENDIF.

    ENDIF.

    "현장휴일근무
    "현장휴일근로수당이 있고 중도입사/퇴사 이력이 있는 경우
    "일할계산 / 일할계산
*    DATA: lv_p19(20).
*    WRITE lt_p0100-p19 TO lv_p19 CURRENCY 'KRW' LEFT-JUSTIFIED.
    IF LT_P0100-P19 <> 0 AND LT_WPBP[] IS NOT INITIAL.
      CASE LV_LINES.
        WHEN 1. "신규입사자
          LOOP AT LT_WPBP[] INTO LS_WPBP.
            IF ( LV_LINES = 1 AND LS_WPBP-BEGDA+6(2) NE '01' ).
              "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
              IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
                LV_WDAYS = 1.
              ELSE.
                LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
              ENDIF.
              ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04 / LV_WDAYS.
              ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05 / LV_WDAYS.
              "신규입사자가 아닌 경우
            ELSEIF ( LV_LINES = 1 AND LS_WPBP-BEGDA+6(2) EQ '01' ).
              ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04.
              ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05.
            ENDIF.

          ENDLOOP.
        WHEN OTHERS. "중도퇴사자
          LOOP AT LT_WPBP[] INTO LS_WPBP WHERE BEGDA+6(2) EQ '01'.
            "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
** <- 우미 로직 수정 begin 29.07.2025 14:17:22
** 2일자 퇴사로 인해 시작일과 종료일이 같은 경우
** => 근무일수가 0이 되어 CX_SY_ZERODIVIDE 오류가 나서 근무일수 1로 조정
            IF LS_WPBP-BEGDA = LS_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LS_WPBP-ENDDA - LS_WPBP-BEGDA.
            ENDIF.
** -> 우미 로직 수정 end 29.07.2025 14:17:22
*            et_payslip_b3-tim04 = l_time_m = 16.
            ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04 / LV_WDAYS.
*            et_payslip_b3-tim05 = l_time_m = 2.
            ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05 / LV_WDAYS.
          ENDLOOP.
      ENDCASE.
      "현장휴일근로수당이 있고 중도입사/퇴사 이력이 없는 경우
      "16 / 0.
    ELSEIF LT_P0100-P19 <> 0 AND LT_WPBP[] IS INITIAL.
      ET_PAYSLIP_B3-TIM04 = L_TIME = LV_TIM04.
      ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
      ET_PAYSLIP_B3-TIM05 = L_TIME = LV_TIM05.
      ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
      "현장휴일근로수당이 없으면
      "0/0
    ELSEIF LT_P0100-P19 EQ 0.
      ET_PAYSLIP_B3-TIM04 = L_TIME = 0.
      ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
      ET_PAYSLIP_B3-TIM05 = L_TIME = LT_P0100-T05.
      ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
    ENDIF.

    "특근근무시간
*    et_payslip_b3-tim06 = l_time = l_time_nd = lv_swork.
    "기존 포맷 휴일 근무 시간과 동일하게 변경

*    " 특근시간 = 특근 시간 - 특근수당 / 통상 시급 * 1.5
*    DATA lv_test_value TYPE p DECIMALS 2 VALUE '1.5'.
*    lt_p0100-t04 = lt_p0100-t04 - lt_p0100-p15 / ( lt_p0100-bet01 * lv_test_value ).
    ET_PAYSLIP_B3-TIM06 = L_TIME = L_TIME_ND = LT_P0100-T04.

    "급여명세서 수정
    "통상시급
    TRY.
        "연차수당 wa1-p22
        DATA: LV_RESULT    TYPE ZCALC07,
              LV_P22(20),
*-> 기존 급여명세서에도 연차수당 보상 일수 항목 추가 2025-04-02
              LV_BET01(20),
              LV_P22_2(20).
*<- 기존 급여명세서에도 연차수당 보상 일수 항목 추가 2025-04-02
        CLEAR: LV_RESULT, LV_P22, LV_BET01, LV_P22_2.

        "20250613 연차 수당
        DATA LT_PA0015 TYPE TABLE OF PA0015 WITH HEADER LINE.
        DATA LV_BETRG TYPE CHAR15.

        CLEAR: LT_PA0015, LV_BETRG.


        IF IV_YEAR >= '2025'.
          DATA : LV_DATE_NEW(10) TYPE C.

          " 지급일이
          LV_DATE_NEW = ET_PAYSLIP_B3-PAYDT.
          REPLACE ALL OCCURRENCES OF '.' IN LV_DATE_NEW WITH SPACE.
          REPLACE ALL OCCURRENCES OF '/' IN LV_DATE_NEW WITH SPACE.

          IF LV_DATE_NEW+4(2) EQ '03'.
            IF LV_DATE_NEW+6(2) EQ '05'.
              WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
              SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.
              WRITE WA1-P22 TO LV_P22 CURRENCY 'KRW'.
              SHIFT LV_P22 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ',' IN LV_P22 WITH SPACE.
              "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
              LV_RESULT = CONV INT4( LV_P22 ) / ( CONV INT4( ET_PAYSLIP_B3-CALC00 ) * 8 ).
              WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07.
              SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.
            ELSE.

              CLEAR: V_YNCA.
              CONCATENATE LV_DATE_NEW+0(6) '01' INTO V_YNCA.
              "연차수당 계산용 -1달
              CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                EXPORTING
                  DATE      = V_YNCA
                  DAYS      = '00'
                  MONTHS    = '01'
                  SIGNUM    = '-'
                  YEARS     = '00'
                IMPORTING
                  CALC_DATE = V_YNCA_H.

              " 중도퇴직자의 경우, 당월 + 전달의 결과가 필요함
              " lv_date_new, v_ynca_h 둘다 필요

              CLEAR:  LT_P0100_2[].

              " 라인이 2개면 중도 퇴사자
              IF LV_LINES EQ 2.

                SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                                  FROM   ZHRT0100
                                  WHERE  PERNR = ET_PAYSLIP_B3-PERNR
                                    AND  FPPER  BETWEEN V_YNCA_H+0(6) AND LV_DATE_NEW+0(6)
                                    AND  ORGEH IN IR_ORGEH
                                    AND  ZSTYPE = PV_ZSTYPE.

                DATA LV_COUNT TYPE I.
                LV_COUNT = LINES( LT_P0100_2 ).

                " 연차수당 받아오기
                SELECT * FROM PA0015
                  WHERE PERNR = @ET_PAYSLIP_B3-PERNR
                  AND LGART = '3700'
                  ORDER BY BEGDA DESCENDING
                  INTO CORRESPONDING FIELDS OF TABLE @LT_PA0015
                  UP TO @LV_COUNT ROWS.

              ELSE.

                                                            " 20250618
                " 한 줄이고 일자가 1일이 아니면 중도 입사인데
                " 중도 퇴사가 아니면 지급일 기준으로 셀렉트

                " 일단은 무조건 저번달 급여로 계싼

                SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                  FROM   ZHRT0100
                  WHERE  PERNR = ET_PAYSLIP_B3-PERNR
                    AND  FPPER  EQ V_YNCA_H+0(6)
*                    AND  FPPER  EQ LV_DATE_NEW+0(6)
                    AND  ORGEH IN IR_ORGEH
                    AND  ZSTYPE = PV_ZSTYPE.

*--------------------------------------------------------------------*
*이전달 급여결과 없다면, 신규입사자이므로 이번달 계산결과로 사용
*--------------------------------------------------------------------*

                IF LT_P0100_2[] IS INITIAL.
                  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                                    FROM   ZHRT0100
                                    WHERE  PERNR = ET_PAYSLIP_B3-PERNR
                                      AND  FPPER  EQ V_YNCA+0(6)
*                    AND  FPPER  EQ LV_DATE_NEW+0(6)
                                      AND  ORGEH IN IR_ORGEH
                                      AND  ZSTYPE = PV_ZSTYPE.
                ENDIF.

              ENDIF.

              SORT LT_P0100_2 ASCENDING BY PERNR PAYDT.
              SORT LT_PA0015 ASCENDING BY BEGDA
              .
              LOOP AT LT_P0100_2.

                WRITE LT_P0100_2-BET01 TO LV_BET01 CURRENCY 'KRW'.
                SHIFT LV_BET01 LEFT DELETING LEADING SPACE.
                REPLACE ALL OCCURRENCES OF ',' IN LV_BET01 WITH SPACE.

                " 20250613 퇴사자의 경우에는 3월 연차수당도 지급이 되어야 하기 때문에 로직 추가
                " lv_lines이 두 줄 이상인 경우에는 중도퇴직자
                IF LV_LINES EQ 2.

                  READ TABLE LT_PA0015 INDEX SY-TABIX.
                  WRITE  LT_PA0015-BETRG TO LV_BETRG CURRENCY LT_PA0015-WAERS.
                  SHIFT LV_BETRG LEFT DELETING LEADING SPACE.
                  REPLACE ALL OCCURRENCES OF ',' IN LV_BETRG WITH SPACE.
                  LV_RESULT = LV_RESULT + ( CONV INT4( LV_BETRG ) / ( CONV INT4( LV_BET01 ) * 8 ) ).

                ELSE.

                  "3월 급여일때 2월 기준 통상시급으로 반영
*--------------------------------------------------------------------*
*20260327 계산은 2월로 하지만 해당월 통상시급으로 표기하기위해 수정
*--------------------------------------------------------------------*
*                  WRITE LT_P0100_2-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
                  WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.

                  SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
                  REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.
                  WRITE WA1-P22 TO LV_P22 CURRENCY 'KRW'.
                  SHIFT LV_P22 LEFT DELETING LEADING SPACE.
                  REPLACE ALL OCCURRENCES OF ',' IN LV_P22 WITH SPACE.
                  "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
                  LV_RESULT = CONV INT4( LV_P22 ) / ( CONV INT4( LV_BET01 ) * 8 ).

                ENDIF.

                WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07.
                SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.

              ENDLOOP.

            ENDIF.
          ELSE.
            WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
            SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.
            WRITE WA1-P22 TO LV_P22 CURRENCY 'KRW'.
            SHIFT LV_P22 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ',' IN LV_P22 WITH SPACE.
            "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
            LV_RESULT = CONV INT4( LV_P22 ) / ( CONV INT4( ET_PAYSLIP_B3-CALC00 ) * 8 ).
            WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07.
            SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.
          ENDIF.
        ELSE.
          LOOP AT LT_P0100_2.
            WRITE LT_P0100_2-BET01 TO LV_BET01 CURRENCY 'KRW'.
            SHIFT LV_BET01 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ',' IN LV_BET01 WITH SPACE.
            WRITE WA1-P22 TO LV_P22_2 CURRENCY 'KRW'.
            SHIFT LV_P22_2 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ',' IN LV_P22_2 WITH SPACE.
            "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
            LV_RESULT = CONV INT4( LV_P22_2 ) / ( CONV INT4( LV_BET01 ) * 8 ).
            WRITE LV_RESULT TO ET_PAYSLIP_DATA-CALC07.
            SHIFT ET_PAYSLIP_DATA-CALC07 LEFT DELETING LEADING SPACE.
          ENDLOOP.
        ENDIF.

*        CASE sy-cprog.
*          WHEN 'ZHRPYR0017_B3'.
*            "*------20250424 연차수당 보상 일수 변경 Start
*            DATA : lv_date_new(10) TYPE c.
*
*            lv_date_new = et_payslip_b3-paydt.
*            REPLACE ALL OCCURRENCES OF '.' IN lv_date_new WITH space.
*
*            IF lv_date_new+4(2) EQ '03'.
*              IF lv_date_new+6(2) EQ '05'.
*                WRITE lt_p0100-bet01 TO et_payslip_b3-calc00 CURRENCY 'KRW'.
*                SHIFT et_payslip_b3-calc00 LEFT DELETING LEADING space.
*                REPLACE ALL OCCURRENCES OF ',' IN et_payslip_b3-calc00 WITH space.
*                WRITE wa1-p22 TO lv_p22 CURRENCY 'KRW'.
*                SHIFT lv_p22 LEFT DELETING LEADING space.
*                REPLACE ALL OCCURRENCES OF ',' IN lv_p22 WITH space.
*                "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
*                lv_result = CONV int4( lv_p22 ) / ( CONV int4( et_payslip_b3-calc00 ) * 8 ).
*                WRITE lv_result TO et_payslip_b3-calc07.
*                SHIFT et_payslip_b3-calc07 LEFT DELETING LEADING space.
*              ELSE.
*                CLEAR: v_ynca.
*                CONCATENATE lv_date_new+0(6) '01' INTO v_ynca.
*                "연차수당 계산용 -1달
*                CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*                  EXPORTING
*                    date      = v_ynca
*                    days      = '00'
*                    months    = '01'
*                    signum    = '-'
*                    years     = '00'
*                  IMPORTING
*                    calc_date = v_ynca_h.
*
*                CLEAR:  lt_p0100_2[].
*                SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_p0100_2
*                  FROM   zhrt0100
*                  WHERE  pernr = et_payslip_b3-pernr
*                    AND  fpper  EQ v_ynca_h+0(6)
*                    AND  orgeh IN ir_orgeh
*                    AND  zstype = pv_zstype.
*
*                SORT lt_p0100_2 ASCENDING BY pernr paydt.
*
*                LOOP AT lt_p0100_2.
*                  "3월 급여일때 2월 기준 통상시급으로 반영
*                  WRITE lt_p0100_2-bet01 TO lv_bet01 CURRENCY 'KRW'.
*                  SHIFT lv_bet01 LEFT DELETING LEADING space.
*                  REPLACE ALL OCCURRENCES OF ',' IN lv_bet01 WITH space.
*
*                  WRITE lt_p0100-bet01 TO et_payslip_b3-calc00 CURRENCY 'KRW'.
*                  SHIFT et_payslip_b3-calc00 LEFT DELETING LEADING space.
*                  REPLACE ALL OCCURRENCES OF ',' IN et_payslip_b3-calc00 WITH space.
*                  WRITE wa1-p22 TO lv_p22 CURRENCY 'KRW'.
*                  SHIFT lv_p22 LEFT DELETING LEADING space.
*                  REPLACE ALL OCCURRENCES OF ',' IN lv_p22 WITH space.
*                  "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
*                  lv_result = CONV int4( lv_p22 ) / ( CONV int4( lv_bet01 ) * 8 ).
*                  WRITE lv_result TO et_payslip_b3-calc07.
*                  SHIFT et_payslip_b3-calc07 LEFT DELETING LEADING space.
*
*                ENDLOOP.
*
*              ENDIF.
*            ELSE.
*              WRITE lt_p0100-bet01 TO et_payslip_b3-calc00 CURRENCY 'KRW'.
*              SHIFT et_payslip_b3-calc00 LEFT DELETING LEADING space.
*              REPLACE ALL OCCURRENCES OF ',' IN et_payslip_b3-calc00 WITH space.
*              WRITE wa1-p22 TO lv_p22 CURRENCY 'KRW'.
*              SHIFT lv_p22 LEFT DELETING LEADING space.
*              REPLACE ALL OCCURRENCES OF ',' IN lv_p22 WITH space.
*              "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
*              lv_result = CONV int4( lv_p22 ) / ( CONV int4( et_payslip_b3-calc00 ) * 8 ).
*              WRITE lv_result TO et_payslip_b3-calc07.
*              SHIFT et_payslip_b3-calc07 LEFT DELETING LEADING space.
*            ENDIF.
*
*
*            "*------20250424 연차수당 보상 일수 변경 End
**            WRITE lt_p0100-bet01 TO et_payslip_b3-calc00 CURRENCY 'KRW'.
**            SHIFT et_payslip_b3-calc00 LEFT DELETING LEADING space.
**            REPLACE ALL OCCURRENCES OF ',' IN et_payslip_b3-calc00 WITH space.
**            WRITE wa1-p22 TO lv_p22 CURRENCY 'KRW'.
**            SHIFT lv_p22 LEFT DELETING LEADING space.
**            REPLACE ALL OCCURRENCES OF ',' IN lv_p22 WITH space.
**            "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
**            lv_result = CONV int4( lv_p22 ) / ( CONV int4( et_payslip_b3-calc00 ) * 8 ).
**            WRITE lv_result TO et_payslip_b3-calc07.
**            SHIFT et_payslip_b3-calc07 LEFT DELETING LEADING space.
*
**<- 기존 급여명세서에도 연차수당 보상 일수 항목 추가 2025-04-02
*          WHEN 'ZHRPYR0017' OR 'SAPMHTTP'.
*            LOOP AT lt_p0100_2.
*              WRITE lt_p0100_2-bet01 TO lv_bet01 CURRENCY 'KRW'.
*              SHIFT lv_bet01 LEFT DELETING LEADING space.
*              REPLACE ALL OCCURRENCES OF ',' IN lv_bet01 WITH space.
*              WRITE wa1-p22 TO lv_p22_2 CURRENCY 'KRW'.
*              SHIFT lv_p22_2 LEFT DELETING LEADING space.
*              REPLACE ALL OCCURRENCES OF ',' IN lv_p22_2 WITH space.
*              "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
*              lv_result = CONV int4( lv_p22_2 ) / ( CONV int4( lv_bet01 ) * 8 ).
*              WRITE lv_result TO et_payslip_data-calc07.
*              SHIFT et_payslip_data-calc07 LEFT DELETING LEADING space.
*            ENDLOOP.
*        ENDCASE.
*<- 기존 급여명세서에도 연차수당 보상 일수 항목 추가 2025-04-02
      CATCH CX_SY_CONVERSION_NO_NUMBER.

    ENDTRY.

    "석식대수당
    IF WA1-P22 IS INITIAL.
      ET_PAYSLIP_B3-CALC08 = 0.
    ELSE.
*      et_payslip_b3-calc08 = lv_dinner. "lv_dinwer
      "20250515 석식대수당 횟수 계산 로직에서 날짜를 파악할 수 없어 수정
      ET_PAYSLIP_B3-CALC08 = LT_P0100-T06 / 1.
    ENDIF.

    "자격증수당
    IF WA1-P08 IS INITIAL.
      ET_PAYSLIP_B3-CALC09 = 0.
    ELSE.
      ET_PAYSLIP_B3-CALC09 = WA1-P08.
    ENDIF.

    "현장직무수당
    IF LT_P0100-ZZCLASS EQ '11' OR LT_P0100-ZZCLASS EQ '12'
    OR LT_P0100-ZZCLASS EQ '15' OR LT_P0100-ZZCLASS EQ '16'.
      ET_PAYSLIP_B3-CALC10 = WA1-P06.
      SHIFT ET_PAYSLIP_B3-CALC10 LEFT DELETING LEADING SPACE.
    ELSE.
      ET_PAYSLIP_B3-CALC10 = 0.
      SHIFT ET_PAYSLIP_B3-CALC10 LEFT DELETING LEADING SPACE.
    ENDIF.

    " ************************************  급여 명세서 수정 ************************************

    IF PV_ZSIGN IS NOT INITIAL.
      ET_PAYSLIP_DATA-ZSIGN = LV_BUKRS && '_SIGN'.
    ENDIF.

    CONCATENATE LT_P0100-PABRJ LT_P0100-PABRP '01' INTO LV_BEGDA.

    "요율 세팅 내역 테이블 조회 일자 조건
    DATA: LV_ENDDA TYPE ENDDA.
    CLEAR LV_ENDDA.

    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN            = LV_BEGDA
      IMPORTING
        LAST_DAY_OF_MONTH = LV_ENDDA
      EXCEPTIONS
        DAY_IN_NO_DATE    = 1
        OTHERS            = 2.

    IF LS_T7KRMR IS INITIAL.  "건강보험요율
      SELECT SINGLE * FROM T7KRMR
        INTO CORRESPONDING FIELDS OF LS_T7KRMR
       WHERE SIMOD = '01'
         AND ENDDA >= LV_BEGDA
         AND BEGDA <= LV_BEGDA.
    ENDIF.
*    ET_PAYSLIP_DATA-RATE_01 = LS_T7KRMR-EEPRT.
    WRITE LS_T7KRMR-EEPRT TO ET_PAYSLIP_DATA-RATE_01
                          STYLE 0 LEFT-JUSTIFIED.
    "급여명세서 수정
    WRITE LS_T7KRMR-EEPRT TO ET_PAYSLIP_B3-RATE_01
                          STYLE 0 LEFT-JUSTIFIED.

    IF LS_T7KRIR IS INITIAL.  "장기요양보험요율
      SELECT SINGLE * FROM T7KRIR
        INTO CORRESPONDING FIELDS OF LS_T7KRIR
       WHERE SIPID = '01'
         AND ENDDA >= LV_BEGDA
         AND BEGDA <= LV_BEGDA.
    ENDIF.
*    ET_PAYSLIP_DATA-RATE_02 = LS_T7KRIR-EEPRT.
    WRITE LS_T7KRIR-EEPRT TO ET_PAYSLIP_DATA-RATE_02
                          STYLE 0 LEFT-JUSTIFIED.
    "급여명세서 수정
    WRITE LS_T7KRIR-EEPRT TO ET_PAYSLIP_B3-RATE_02
                          STYLE 0 LEFT-JUSTIFIED.

    IF LT_T7KRSR[] IS INITIAL.
      SELECT * FROM T7KRSR
        INTO CORRESPONDING FIELDS OF TABLE LT_T7KRSR
       WHERE SUBTY IN ('2', '3')
         AND WCICD = SPACE
         AND ENDDA >= LV_BEGDA
         AND BEGDA <= LV_BEGDA.
    ENDIF.
    LOOP AT LT_T7KRSR.
      CASE LT_T7KRSR-SUBTY.
        WHEN '2'.
*          ET_PAYSLIP_DATA-RATE_03 = LT_T7KRSR-EEPRT.  "국민연금요율
          WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_DATA-RATE_03
                                STYLE 0 LEFT-JUSTIFIED.
          "급여명세서 수정
          WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_B3-RATE_03
                                STYLE 0 LEFT-JUSTIFIED.
        WHEN '3'.
*          ET_PAYSLIP_DATA-RATE_04 = LT_T7KRSR-EEPRT.  "고용보험요율
          WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_DATA-RATE_04
                                STYLE 0 LEFT-JUSTIFIED.
          "급여명세서 수정
          WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_B3-RATE_04
                                STYLE 0 LEFT-JUSTIFIED.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    CONCATENATE : ET_PAYSLIP_DATA-RATE_01 '%' INTO ET_PAYSLIP_DATA-RATE_01,
                  ET_PAYSLIP_DATA-RATE_02 '%' INTO ET_PAYSLIP_DATA-RATE_02,
                  ET_PAYSLIP_DATA-RATE_03 '%' INTO ET_PAYSLIP_DATA-RATE_03,
                  ET_PAYSLIP_DATA-RATE_04 '%' INTO ET_PAYSLIP_DATA-RATE_04.

    "급여명세서 수정
    CONCATENATE : ET_PAYSLIP_B3-RATE_01 '%' INTO ET_PAYSLIP_B3-RATE_01,
                  ET_PAYSLIP_B3-RATE_02 '%' INTO ET_PAYSLIP_B3-RATE_02,
                  ET_PAYSLIP_B3-RATE_03 '%' INTO ET_PAYSLIP_B3-RATE_03,
                  ET_PAYSLIP_B3-RATE_04 '%' INTO ET_PAYSLIP_B3-RATE_04.

    APPEND: ET_PAYSLIP_DATA, ET_PAYSLIP_B3.
    CLEAR: ET_PAYSLIP_DATA, ET_PAYSLIP_B3.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HR_READ_INFOTYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_P9001  text
*      -->P_0521   text
*      -->P_LT_P0100_PERNR  text
*      -->P_LT_P0100_PAYDT  text
*----------------------------------------------------------------------*
FORM HR_READ_INFOTYPE  TABLES   PT_P9001 STRUCTURE P9001
                       USING    PV_INFTY
                                PV_PERNR
                                PV_PAYDT.
  REFRESH PT_P9001.
  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      PERNR     = PV_PERNR
      INFTY     = PV_INFTY
      BEGDA     = PV_PAYDT
      ENDDA     = PV_PAYDT
    TABLES
      INFTY_TAB = PT_P9001.

ENDFORM.