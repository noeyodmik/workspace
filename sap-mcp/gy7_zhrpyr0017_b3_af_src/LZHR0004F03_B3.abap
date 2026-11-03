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
*       text
*----------------------------------------------------------------------*
*      -->P_IR_PERNR  text
*      -->P_IR_PAYDT  text
*      -->P_IR_ORGEH  text
*      -->P_IV_ZSTYPE  text
*----------------------------------------------------------------------*
FORM GET_PAYSLIP_DATA  TABLES   IR_PERNR STRUCTURE SEL_PERNR
                                IR_PAYDT STRUCTURE SEL_DATE
                                IR_ORGEH STRUCTURE CCHRS_ORGEH_RANGE
                                ET_PAYSLIP_DATA STRUCTURE ZHRS0027
                       USING    PV_ZSTYPE
                                PV_ZSIGN.

  DATA: LT_P0100 TYPE TABLE OF ZHRT0100 WITH HEADER LINE.
  DATA: LT_ZHRT0300 TYPE TABLE OF ZHRT0300 WITH HEADER LINE.
  DATA: LT_P9001 TYPE TABLE OF P9001 WITH HEADER LINE.

  DATA : LS_T7KRMR LIKE T7KRMR, "건강보험요율
         LS_T7KRIR LIKE T7KRIR, "장기요양보험요율
         LT_T7KRSR LIKE TABLE OF T7KRSR WITH HEADER LINE. "국민연금, 고용보험요율
  DATA : LV_BEGDA TYPE D.


  DATA: LV_NUM_1 LIKE ZHRT0100-D09.
  DATA : LV_TEXT(30),
         LV_ORGEH(8) TYPE N,
         LV_TRFGR(8).
  DATA: LV_NUM(2)   TYPE N,
        LV_NUM_2(2) TYPE N.

  DATA:  WAS                TYPE ZHRS0023.           "해더
  DATA : WA1   TYPE ZHRS0021,
         WA1_1 TYPE ZHRS0021.

  DATA : WA2   TYPE ZHRS0022,
         WA2_2 TYPE ZHRS0022.

  DATA : LV_BUKRS TYPE BUKRS.

  CLEAR: WA1, WAS, WA2, WA1_1, WA2_2, ET_PAYSLIP_DATA, ET_PAYSLIP_DATA[].


  CLEAR:  LT_P0100[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100
    FROM   ZHRT0100
    WHERE  PERNR IN IR_PERNR
      AND  PAYDT IN IR_PAYDT
      AND  ORGEH IN IR_ORGEH
      AND  ZSTYPE = PV_ZSTYPE.


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
      CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE1 INTO ET_PAYSLIP_DATA-ZMESSAGE1
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
      IF ET_PAYSLIP_DATA-ZMESSAGE1 IS NOT INITIAL.
        ET_PAYSLIP_DATA-ZMESSAGE2 = LT_P9001-ZMESSAGE.
        CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE2 INTO ET_PAYSLIP_DATA-ZMESSAGE2
                                                    SEPARATED BY SPACE.
      ELSE.
        ET_PAYSLIP_DATA-ZMESSAGE1 = LT_P9001-ZMESSAGE.
        CONCATENATE ' * ' ET_PAYSLIP_DATA-ZMESSAGE1 INTO ET_PAYSLIP_DATA-ZMESSAGE1
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


    WRITE LT_P0100-P30 TO WA1-P30 CURRENCY 'KRW'.
    WA1-LGTXT30 = '기 지 급 금'.
    CONDENSE WA1-P30.

    WRITE LT_P0100-R_TOTAL  TO WA1-P31 CURRENCY 'KRW'.
    WA1-LGTXT31 = '소  급  분'.
    CONDENSE WA1-P31.

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

    MOVE-CORRESPONDING WA2_2 TO ET_PAYSLIP_DATA.

*&---------------------------------------------------------------------*
*&  근무일수 및 근무시간추가
*&---------------------------------------------------------------------*
    WRITE : LT_P0100-PAYDT  TO ET_PAYSLIP_DATA-PAYDT  MM/DD/YYYY,
            LT_P0100-ZPAYDT TO ET_PAYSLIP_DATA-ZPAYDT MM/DD/YYYY.

    DATA : L_TIME(6) TYPE P DECIMALS 2,
           L_DAY(3)  TYPE P DECIMALS 0.
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
    IF PV_ZSIGN IS NOT INITIAL.
      ET_PAYSLIP_DATA-ZSIGN = LV_BUKRS && '_SIGN'.
    ENDIF.

    CONCATENATE LT_P0100-PABRJ LT_P0100-PABRP '01' INTO LV_BEGDA.

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
        WHEN '3'.
*          ET_PAYSLIP_DATA-RATE_04 = LT_T7KRSR-EEPRT.  "고용보험요율
          WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_DATA-RATE_04
                                STYLE 0 LEFT-JUSTIFIED.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    CONCATENATE : ET_PAYSLIP_DATA-RATE_01 '%' INTO ET_PAYSLIP_DATA-RATE_01,
                  ET_PAYSLIP_DATA-RATE_02 '%' INTO ET_PAYSLIP_DATA-RATE_02,
                  ET_PAYSLIP_DATA-RATE_03 '%' INTO ET_PAYSLIP_DATA-RATE_03,
                  ET_PAYSLIP_DATA-RATE_04 '%' INTO ET_PAYSLIP_DATA-RATE_04.

    APPEND ET_PAYSLIP_DATA.
    CLEAR ET_PAYSLIP_DATA.

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