*----------------------------------------------------------------------*
***INCLUDE LZHR0004F04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_PAYSLIP_DATA_B3
*&---------------------------------------------------------------------*
FORM GET_PAYSLIP_DATA_B3  TABLES IR_PERNR        STRUCTURE SEL_PERNR
                                 IR_PAYDT        STRUCTURE SEL_DATE
                                 IR_ORGEH        STRUCTURE CCHRS_ORGEH_RANGE
                                 ET_PAYSLIP_B3   STRUCTURE ZHRS0027_B3
                           USING PV_ZSTYPE
                                 PV_ZSIGN
                                 IV_YEAR
                        CHANGING P_CNT.
************************************************************************
* 선언부
************************************************************************
*----------------------------------------------------------------------
*--  급여결과
*----------------------------------------------------------------------
  DATA: LT_P0100    TYPE TABLE OF ZHRT0100 WITH HEADER LINE,
        LT_P0100_2  TYPE TABLE OF ZHRT0100 WITH HEADER LINE,
        LT_ZHRT0300 TYPE TABLE OF ZHRT0300 WITH HEADER LINE,
        LT_P9001    TYPE TABLE OF P9001 WITH HEADER LINE,
        LT_WPBP     LIKE TABLE OF PC205 WITH HEADER LINE,      "중도 입/퇴사자 일할 계산
        LS_WPBP     LIKE PC205,
        LT_RGDIR    LIKE TABLE OF HRPY_RGDIR WITH HEADER LINE,
        LT_DINNER   LIKE TABLE OF ZHRPT0005 WITH HEADER LINE,  "석식
        LT_SWORK    LIKE TABLE OF ZHRPT0006 WITH HEADER LINE,  "특근
        LS_STR      TYPE ZHRS0004,
        V_BEGDA_H   TYPE SY-DATUM,
        V_ENDDA_H   TYPE SY-DATUM,
        V_BEGDA     TYPE SY-DATUM,
        V_ENDDA     TYPE SY-DATUM,
        LV_FAPER    TYPE FAPER,
        LV_WERT1    TYPE WERT1,
        LV_SWORK    TYPE P DECIMALS 2,
        LV_LINES    TYPE I,
        LV_ORGEH(8) TYPE N,
        LV_TRFGR(8),
*----------------------------------------------------------------------
*--  급여명세서
*----------------------------------------------------------------------
        WAS         TYPE ZHRS0023, "header
        WA1         TYPE ZHRS0021, "지급내역
        WA1_1       TYPE ZHRS0021,
        WA2         TYPE ZHRS0022, "공제항목
        WA2_2       TYPE ZHRS0022,
        LV_BUKRS    TYPE BUKRS,
        V_YNCA      TYPE SY-DATUM, "조회일자
        V_YNCA_H    TYPE SY-DATUM.
*----------------------------------------------------------------------
*--  요율
*----------------------------------------------------------------------
  DATA: LS_T7KRMR LIKE T7KRMR, "건강보험요율
        LS_T7KRIR LIKE T7KRIR, "장기요양보험요율
        LT_T7KRSR LIKE TABLE OF T7KRSR WITH HEADER LINE. "국민연금, 고용보험요율
************************************************************************
* Logic
************************************************************************
*-----------------------------------------------------------------------
*--  급여 결과 조회
*-----------------------------------------------------------------------
  PERFORM GET_PAYRESULT TABLES LT_RGDIR
                               IR_PERNR
                               IR_PAYDT
                               LT_WPBP
                      CHANGING V_BEGDA.
*----------------------------------------------------------------------
*--  급여명세서 서식 작성
*----------------------------------------------------------------------
  PERFORM SET_PAYRESULT TABLES ET_PAYSLIP_B3
                               LT_P0100
                               LT_P0100_2
                               LT_ZHRT0300
                               IR_PERNR
                               IR_PAYDT
                               IR_ORGEH
                         USING PV_ZSTYPE
                      CHANGING V_YNCA
                               V_YNCA_H.
*----------------------------------------------------------------------
*--  급여 결과 기반, 급여명세서 작성
*----------------------------------------------------------------------
  LOOP AT LT_P0100.
    CLEAR: WAS, WA1, WA2.
*----------------------------------------------------------------------
*--  급여명세서 - HEADER
*----------------------------------------------------------------------
    PERFORM SET_HEADER TABLES LT_ZHRT0300
                              LT_P9001
                              LT_P0100
                              ET_PAYSLIP_B3
                        USING PV_ZSTYPE
                     CHANGING WAS.
*----------------------------------------------------------------------
*--  급여명세서 - 항목명
*----------------------------------------------------------------------
    PERFORM SET_ITEM USING LT_P0100
                  CHANGING WA1
                           WA2.
*----------------------------------------------------------------------
*--  급여명세서 - 지급항목 가공 (금액이 있는 경우에만 출력)
*----------------------------------------------------------------------
    PERFORM SET_BETRG CHANGING WA1
                               WA2
                               WA1_1
                               WA2_2
                               ET_PAYSLIP_B3
                               P_CNT.
*----------------------------------------------------------------------
*--  급여명세서 - 근무일수 및 근무시간 추가
*----------------------------------------------------------------------
    PERFORM CALC_WKDAY TABLES ET_PAYSLIP_B3
                              IR_PERNR
                              IR_ORGEH
                              IR_PAYDT
                              LT_WPBP
                        USING LT_P0100
                              PV_ZSTYPE.
*----------------------------------------------------------------------
*--  급여명세서 - 수당 계산
*----------------------------------------------------------------------
    PERFORM CALC_BETRG TABLES ET_PAYSLIP_B3
                              LT_P0100
                              LT_P0100_2
                              LT_WPBP
                              IR_ORGEH
                        USING WA1
                              IV_YEAR
                              V_YNCA
                              V_YNCA_H.
*----------------------------------------------------------------------
*--  급여명세서 - 요율(국민연금, 고용보험, 건강보험) 계산
*----------------------------------------------------------------------
    PERFORM CALC_RATE TABLES LT_T7KRSR
                             ET_PAYSLIP_B3
                             LT_P0100
                       USING LS_T7KRMR
                             LS_T7KRIR.
*----------------------------------------------------------------------
*--  최종 산입
*----------------------------------------------------------------------
    APPEND ET_PAYSLIP_B3. CLEAR ET_PAYSLIP_B3.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PAYRESULT
*&---------------------------------------------------------------------*
FORM GET_PAYRESULT TABLES   LT_RGDIR STRUCTURE HRPY_RGDIR
                            IR_PERNR STRUCTURE SEL_PERNR
                            IR_PAYDT STRUCTURE SEL_DATE
                            LT_WPBP  STRUCTURE PC205
                   CHANGING V_BEGDA.

  DATA: LV_DATE TYPE DATS,
        T_WPBP  TYPE TABLE OF PC205 WITH HEADER LINE.

  CLEAR: LT_RGDIR, LT_RGDIR[], LT_WPBP, LT_WPBP[].
  REFRESH: LT_RGDIR, LT_WPBP.

  IF IR_PAYDT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_RGDIR
      FROM HRPY_RGDIR
      WHERE PERNR IN IR_PERNR
      AND SRTZA = 'A'.
  ELSE.
    "Webdyn으로 조회할 경우 급여 지급일이 low에 할당되어 high가 비어있음
    IF IR_PAYDT-HIGH IS INITIAL.
      CLEAR V_BEGDA.
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

  LOOP AT LT_RGDIR.

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
        WPBP   = T_WPBP[].

    IF T_WPBP[] IS NOT INITIAL.
      MOVE-CORRESPONDING T_WPBP[] TO LT_WPBP[] KEEPING TARGET LINES.
    ENDIF.
  ENDLOOP.

  SORT LT_WPBP[] BY BEGDA ENDDA.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_PAYRESULT
*&---------------------------------------------------------------------*
FORM SET_PAYRESULT  TABLES ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                           LT_P0100      STRUCTURE ZHRT0100
                           LT_P0100_2    STRUCTURE ZHRT0100
                           LT_ZHRT0300   STRUCTURE ZHRT0300
                           IR_PERNR      STRUCTURE SEL_PERNR
                           IR_PAYDT      STRUCTURE SEL_DATE
                           IR_ORGEH      STRUCTURE CCHRS_ORGEH_RANGE
                    USING  PV_ZSTYPE
                  CHANGING V_YNCA
                           V_YNCA_H.

  CLEAR: ET_PAYSLIP_B3, ET_PAYSLIP_B3[], LT_P0100[].

  REFRESH: ET_PAYSLIP_B3, LT_P0100.

  SELECT *
    FROM ZHRT0100 INTO CORRESPONDING FIELDS OF TABLE LT_P0100
    WHERE PERNR IN IR_PERNR
      AND PAYDT IN IR_PAYDT
      AND ORGEH IN IR_ORGEH
      AND ZSTYPE = PV_ZSTYPE.

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

    CLEAR: LT_P0100_2, LT_P0100_2[]. REFRESH LT_P0100_2.

    SELECT *
      FROM ZHRT0100 INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
      WHERE PERNR IN IR_PERNR
        AND FPPER EQ V_YNCA_H+0(6)
        AND ORGEH IN IR_ORGEH
        AND ZSTYPE = PV_ZSTYPE.

    SORT LT_P0100_2[] ASCENDING BY PERNR PAYDT.

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
    SELECT *
      FROM ZHRT0100 INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
        WHERE PERNR IN IR_PERNR
          AND FPPER EQ V_YNCA_H+0(6)
          AND ORGEH IN IR_ORGEH
          AND ZSTYPE = PV_ZSTYPE.

    SORT LT_P0100_2[] ASCENDING BY PERNR PAYDT.
  ENDIF.

  SORT LT_P0100[] ASCENDING BY PERNR PAYDT.

  IF LT_P0100[] IS NOT INITIAL.
    SELECT *
      FROM ZHRT0300 INTO CORRESPONDING FIELDS OF TABLE LT_ZHRT0300
        WHERE PAYDT IN IR_PAYDT
          AND ZSTYPE = PV_ZSTYPE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_HEADER
*&---------------------------------------------------------------------*
FORM SET_HEADER TABLES LT_ZHRT0300   STRUCTURE ZHRT0300
                       LT_P9001      STRUCTURE P9001
                       LT_P0100      STRUCTURE ZHRT0100
                       ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                 USING PV_ZSTYPE
              CHANGING WAS                TYPE ZHRS0023.

  DATA: LV_TEXT(30) TYPE C,
        LV_DIVGVXT  TYPE STRING.

  SELECT SINGLE ENAME FROM PA0001 INTO WAS-ENAME
    WHERE PERNR  = LT_P0100-PERNR
      AND BEGDA <= LT_P0100-PAYDT
      AND ENDDA >= LT_P0100-PAYDT.

  "사원번호
  WRITE LT_P0100-PERNR TO WAS-PERNR NO-ZERO.

  "부서명
  WAS-STEXT = LT_P0100-ORGEH_TEXT.

  "직급명
  MOVE LT_P0100-ZZCALTLTX TO WAS-ZJ2T.

  "타이틀
  IF LT_P0100-LIST_TXT IS NOT INITIAL.
    WAS-TITLE = LT_P0100-LIST_TXT.
  ELSE.
    CLEAR LV_TEXT.
    SELECT SINGLE DDTEXT FROM DD07T INTO LV_TEXT
      WHERE DOMNAME = 'ZSTYPE'
        AND DDLANGUAGE = SY-LANGU
        AND DOMVALUE_L = LT_P0100-ZSTYPE.

    CASE LT_P0100-ZSTYPE.
      WHEN '800'.
        WAS-TITLE = |{ LT_P0100-PABRJ+2(2) }년 { LV_TEXT } 명세서|.
      WHEN OTHERS.
        WAS-TITLE = |{ LT_P0100-PABRJ }년 { LT_P0100-PABRP }월 { LV_TEXT }명세서|.
    ENDCASE.
  ENDIF.

  "급여명세서 메세지
  "1. 전사 메세지
  CLEAR: LT_ZHRT0300.
  READ TABLE LT_ZHRT0300 WITH KEY PAYDT = LT_P0100-PAYDT.
  IF SY-SUBRC EQ 0.
    "급여명세서 수정
    ET_PAYSLIP_B3-ZMESSAGE1 = |* { LT_ZHRT0300-ZMESSAGE }|.
  ENDIF.

  "2. 사원별메세지
  PERFORM HR_READ_INFOTYPE TABLES LT_P9001
                            USING '9001'
                                  LT_P0100-PERNR
                                  LT_P0100-PAYDT.
  READ TABLE LT_P9001 WITH KEY ZSTYPE = PV_ZSTYPE.
  IF SY-SUBRC EQ 0.
    "전사메세지가 없으면 사원메세지를 전사메세지 칸에
    IF ET_PAYSLIP_B3-ZMESSAGE1 IS NOT INITIAL.
      ET_PAYSLIP_B3-ZMESSAGE2 = |* { LT_P9001-ZMESSAGE }|.
    ENDIF.
  ELSE.
    ET_PAYSLIP_B3-ZMESSAGE1 = |* { LT_P9001-ZMESSAGE }|.
  ENDIF.

  "저장된 금액 출력 구조로 전송
  PERFORM: FORMAT_TOTAL USING LT_P0100-P_TOTAL CHANGING WAS-P999,
           FORMAT_TOTAL USING LT_P0100-D_TOTAL CHANGING WAS-D99,
           FORMAT_TOTAL USING LT_P0100-TOTAL   CHANGING WAS-TOTAL.

  "급여 대상 기간 내 통상시급
  "체육선수 근무시간) 104.3시간, 그 외) 209시간
  IF LT_P0100-ZZPSGRPTX = '체육'.
    LV_DIVGVXT = '104.3'.
  ELSE.
    LV_DIVGVXT = '209'.
  ENDIF.

  ET_PAYSLIP_B3-DIVGV = LV_DIVGVXT.

  "통상시급, 전월시급
  PERFORM: FORMAT_TOTAL USING LT_P0100-BET01 CHANGING WAS-BET01,
           FORMAT_TOTAL USING LT_P0100-BET02 CHANGING WAS-BET02.

  MOVE-CORRESPONDING WAS TO ET_PAYSLIP_B3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORMAT_TOTAL
*&---------------------------------------------------------------------*
FORM FORMAT_TOTAL  USING    PV_VAL
                   CHANGING PV_TARGET.

  IF PV_VAL IS NOT INITIAL.
    WRITE PV_VAL TO PV_TARGET CURRENCY 'KRW'.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        VALUE = PV_TARGET.
    SHIFT PV_TARGET RIGHT DELETING TRAILING SPACE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_ITEM
*&---------------------------------------------------------------------*
FORM SET_ITEM  USING    LT_P0100 TYPE ZHRT0100
               CHANGING WA1 STRUCTURE ZHRS0021
                        WA2 STRUCTURE ZHRS0022.

  DATA: LV_YYYYMM TYPE CHAR6,
        LV_P07    LIKE LT_P0100-P07,
        LV_P19    LIKE LT_P0100-P19.

*  특별성과급(비과세)  P27 의 경우 특별성과급(P25)으로 출력하도록
  IF LT_P0100-P27 > 0.
    LT_P0100-P25 = LT_P0100-P27.
  ENDIF.

  CLEAR: LV_YYYYMM, LV_P07, LV_P19.
*&---------------------------------------------------------------------*
* 급여년월 판단
* 2026.01 이전 현장휴일근로에 급지수당 합산, 급지수당 별도 출력 X
* 2026.01 이후 현장휴일근로에 급지수당 합산 X, 급지수당 별도 출력
*&---------------------------------------------------------------------*
  "급여년월 판단
  IF LT_P0100-FPPER IS NOT INITIAL.
    LV_YYYYMM = LT_P0100-FPPER.
  ELSE.
    CONCATENATE LT_P0100-PABRJ LT_P0100-PABRP INTO LV_YYYYMM.
  ENDIF.

  LV_P07 = LT_P0100-P07. "급지수당
  LV_P19 = LT_P0100-P19. "현장휴일근로

  IF LV_YYYYMM < '202601'.
    "2026년 1월 이전: 급지수당을 현장휴일근로에 합산, 급지수당은 별도 출력 X
    LV_P19 = LV_P19 + LV_P07.
    CLEAR LV_P07.
  ELSE.
    "2026년 1월 이후: 현장휴일근로에 급지수당 합산 X, 급지수당은 별도 출력
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

  "  급지수당 출력 로직 변경   2026.06.15 BY SEPPIN LJS
  WRITE LV_P07 TO WA1-P07 CURRENCY 'KRW'.
  WA1-LGTXT07 = '급지수당'.
  CONDENSE WA1-P07.

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

* 현장휴일근로 출력 로직 변경 2026.06.15 BY SEPPIN LJS
  WRITE LV_P19 TO WA1-P19 CURRENCY 'KRW'.
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
  WA1-LGTXT26 = '휴  가  비'.
*    WA1-T25 = LT_P0100-T08.
  CONDENSE WA1-P26.

*   20250515 기타수당(과세X) 추가
  WRITE LT_P0100-P28 TO WA1-P28 CURRENCY 'KRW'.
  WA1-LGTXT28 = '기 타 지 급'.
  CONDENSE WA1-P28.

*  20260901 포상금 추가 SEPPIN KDY
*  WRITE LT_P0100-P29 TO WA1-P29 CURRENCY 'KRW'.
  WRITE LT_P0100-P29 TO WA1-P04 CURRENCY 'KRW'.
*  WA1-LGTXT25 = '포 상 금'.
  WA1-LGTXT04 = '포 상 금'.
*  WA1-T25 = LT_P0100-T08.
*  CONDENSE WA1-P25.
  CONDENSE WA1-P04.

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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_BETRG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_32     text
*      -->P_WA1  text
*      <--P_WA1_1  text
*----------------------------------------------------------------------*
FORM SET_BETRG  CHANGING WA1           TYPE ZHRS0021
                         WA2           TYPE ZHRS0022
                         WA1_1         TYPE ZHRS0021
                         WA2_2         TYPE ZHRS0022
                         ET_PAYSLIP_B3 TYPE ZHRS0027_B3
                         P_CNT TYPE I.

  DATA: LV_NUM_1    LIKE ZHRT0100-D09,
        LV_NUM(2)   TYPE N,
        LV_NUM_2(2) TYPE N,
        LV_TEXT(30) TYPE C.

  FIELD-SYMBOLS:<FS_LGTXX>   TYPE ANY,
                <FS_BETXX>   TYPE ANY,
                <FS_ANZXX>   TYPE ANY,
                <FS_LGTXX_2> TYPE ANY,
                <FS_BETXX_2> TYPE ANY,
                <FS_ANZXX_2> TYPE ANY.

  CLEAR: LV_NUM, LV_NUM_2, WA1_1, WA2_2.

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

* 임금유형 텍스트가 있고 금액이 0이 아니면 해당 조건무을 탐
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

      P_CNT = P_CNT + 1.

*      ADD 1 TO LV_NUM_2.

* 260828 지급항목 16개로 상승
      IF LV_NUM_2 > 21.
        LV_NUM_2 = 1.
      ENDIF.
    ENDIF.

    UNASSIGN : <FS_LGTXX>, <FS_BETXX>, <FS_ANZXX>.

  ENDDO.

  MOVE-CORRESPONDING WA1_1 TO ET_PAYSLIP_B3.

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

*      ADD 1 TO LV_NUM_2.

      IF LV_NUM_2 > 18.
        LV_NUM_2 = 1.
      ENDIF.
    ENDIF.

  ENDDO.

  MOVE-CORRESPONDING WA2_2 TO ET_PAYSLIP_B3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_WKDAY
*&---------------------------------------------------------------------*
FORM CALC_WKDAY TABLES ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                       IR_PERNR      STRUCTURE SEL_PERNR
                       IR_ORGEH      STRUCTURE CCHRS_ORGEH_RANGE
                       IR_PAYDT      STRUCTURE SEL_DATE
                       LT_WPBP       STRUCTURE PC205
                 USING LT_P0100      TYPE      ZHRT0100
                       PV_ZSTYPE.

  DATA: LV_LINES         TYPE I,
        LV_WDAYS         TYPE I,      "근무일수
        LV_BEGDA_TIME    TYPE BEGDA,
        LV_ENDDA_TIME    TYPE ENDDA,
        LT_ZHRPT0001     TYPE TABLE OF ZHRPT0001 WITH HEADER LINE,  "연장, 야간수당
        LV_BEGDA_2010    TYPE BEGDA,  "전월 21일(연장근무)
        LV_ENDDA_2010    TYPE ENDDA,  "당월 20일(연장근무)
        LV_PABRP_2010(2) TYPE N,      "전월 표기용
        LS_0001          TYPE PA0001, "직영반장, 직영일반, 다기능공, 현장서무 기본연장근무시간 변경

        L_TIME(6)        TYPE P DECIMALS 2,
        L_TIME_ND(6)     TYPE P DECIMALS 2,
        L_TIME_M(6)      TYPE P DECIMALS 1,
        L_DAY(3)         TYPE P DECIMALS 0,

        LV_TIM02(6)      TYPE P DECIMALS 2,
        LV_TIM03(6)      TYPE P DECIMALS 2,
        LV_ZEROP         TYPE P DECIMALS 2 VALUE '1.50',

        LS_PA2010        TYPE PA2010,
        LT_PA2010        TYPE TABLE OF PA2010,

        V_BEGDA          TYPE BEGDA,
        V_ENDDA          TYPE ENDDA,
        LV_TIM04         TYPE CHAR6,
        LV_TIM05         TYPE CHAR6,

        LV_PID           TYPE PA0709-PERSONID_EXT.

  CONSTANTS: C_04(6) TYPE C VALUE '202504',
             C_05(6) TYPE C VALUE '202505'.

  "근무일수 및 근무시간 추가
  WRITE: LT_P0100-PAYDT  TO ET_PAYSLIP_B3-PAYDT  MM/DD/YYYY,
         LT_P0100-ZPAYDT TO ET_PAYSLIP_B3-ZPAYDT MM/DD/YYYY.

  CLEAR: LV_PABRP_2010, LV_BEGDA_2010, LV_ENDDA_2010,
         LV_BEGDA_TIME, LV_ENDDA_TIME.

  LV_PABRP_2010 = LT_P0100-PABRP - 1.

  LV_BEGDA_2010 = |{ LT_P0100-PABRJ }{ LV_PABRP_2010 }21|.
  LV_ENDDA_2010 = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }20|.
  LV_BEGDA_TIME = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }01|.

  CONDENSE LV_BEGDA_TIME NO-GAPS.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      DAY_IN            = LV_BEGDA_TIME
    IMPORTING
      LAST_DAY_OF_MONTH = LV_ENDDA_TIME.

*--------------------------------------------------------------------*
*급여유형 100(정규급여) 외 계산항목 0 처리 2026.07.27 BY SEPPIN LJS
*--------------------------------------------------------------------*
  IF PV_ZSTYPE <> '100'.

    ET_PAYSLIP_B3-TIM01 = 0.
    ET_PAYSLIP_B3-TIM02 = 0.
    ET_PAYSLIP_B3-TIM03 = 0.
    ET_PAYSLIP_B3-TIM04 = 0.
    ET_PAYSLIP_B3-TIM05 = 0.
    ET_PAYSLIP_B3-TIM06 = 0.

    RETURN.

  ENDIF.

  "직영반장, 직영일반, 다기능공, 현장서무 기본연장근무시간 변경용 IT0001 조회
  CLEAR LS_0001.
  SELECT SINGLE PERSK PERSG
    FROM PA0001 INTO CORRESPONDING FIELDS OF LS_0001
      WHERE PERNR EQ LT_P0100-PERNR
        AND ORGEH IN IR_ORGEH
        AND BEGDA <= LT_P0100-PAYDT
        AND ENDDA >= LT_P0100-PAYDT.

  "중도퇴사자
  LOOP AT LT_WPBP ASSIGNING FIELD-SYMBOL(<FS_WPBP>) WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                                                      AND ENDDA(6) = LV_ENDDA_TIME(6).
    IF SY-SUBRC EQ 0.
      LV_LINES = LV_LINES + 1.
    ENDIF.
  ENDLOOP.

  "기본연장근무시간 및 초관연장근무시간(기본연장근무시간인 34시간을 초과한 값) 계산
  "계산 케이스 4가지
  "+ 집계된 연장시간보다 일할계산된 시간이 클 경우 초과연장근무시간으로
  "1. 기본연장급이 없으며 중도 입사/퇴사한 인원
  "1-1. 신규입사자
  "1-2. 중도퇴사자
  "2. 기본연장급이 있고, 중도입사/퇴사 이력이 없는 인원 = 34시간 (일괄)
  "3. 기본연장급이 있고, 중도입사/퇴사 이력이 있는 인원
  "3-1. 신규입사자
  "3-2. 중도퇴사자
  "4. 기본연장급이 없을 경우

  "1. 기본연장급이 없으며 중도 입사/퇴사한 인원(일할계산이 필요)
  IF ( LT_P0100-P02 IS INITIAL AND LT_WPBP[] IS NOT INITIAL ).
    "신규입사자 / 중도퇴사자 구분
    CASE LV_LINES.
      WHEN 1.
        "1-1. 신규입사자 -> MASSN = 'A0'
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
*          IF ( LV_LINES = 1 AND LT_WPBP-BEGDA+6(2) NE '01' ).
          CLEAR LV_WDAYS.
          "근무 일수가 하루일 경우
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
            "근무 일수가 하루 이상일 경우
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          IF LV_WDAYS < 27.
            "직영반장, 직영일반, 다기능공 기본연장근무시간 변경(신규입사자)
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "다기능공
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ENDIF.
            "1-2. 중도퇴사자 -> MASSN = O0
          ELSE.
            "직영반장, 직영일반, 다기능공 기본연장근무시간 변경(신규입사자 외)
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "다기능공
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
            ENDIF.

          ENDIF.
*          ENDIF.
        ENDLOOP.
      WHEN OTHERS.
        "1-2. 중도퇴사자
        "->해당 월 1일 ~ 퇴사일 이전 날짜까지 일할계산
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6)
                          AND MASSN = 'O0'.
        ENDLOOP.

        IF SY-SUBRC EQ 0.
          CLEAR LV_WDAYS.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          "직영반장, 직영일반, 다기능공 기본연장근무시간 변경(신규입사자)
          IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ). "직영반장, 직영일반
            ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'. "다기능공
            ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSE.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ENDIF.
        ELSE.

        ENDIF.
    ENDCASE.

    "2. 기본연장급이 있고 중도입사/퇴사 이력이 있는 인원
*  ELSEIF ( LT_P0100-P02 IS NOT INITIAL AND LT_WPBP[] IS NOT INITIAL ).
  ELSEIF LT_P0100-P02 IS NOT INITIAL.
    "신규입사자 / 중도퇴사자 구분
    CASE LV_LINES.
      WHEN 1.
        "2-1.신규입사자
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
          CLEAR LV_WDAYS.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          "근무일수가 27일보다 적으면 신규입사자
          IF LV_WDAYS < 27.
            "직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 18 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
            ENDIF.
          ELSEIF LV_WDAYS >= 27.
            "직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
            IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
              ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
            ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 18.
            ELSE.
              ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
            ENDIF.
          ENDIF.
        ENDLOOP.
      WHEN OTHERS.
        "2-2. 중도퇴사자
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6)
                          AND MASSN = 'O0'.
        ENDLOOP.
        IF SY-SUBRC EQ 0.
          CLEAR LV_WDAYS.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.
          "직영반장, 직영일반 다기능공 현장서무 기본연장근무시간 일괄 변경
          IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
            ET_PAYSLIP_B3-TIM01 = L_TIME = 36 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 33 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 18 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSE.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 34 / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ENDIF.
        ELSE.
          IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
            ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
          ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
          ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 18.
          ELSE.
            ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
          ENDIF.
        ENDIF.
    ENDCASE.

    "3. 기본연장급이 있고, 중도입사/퇴사 이력이 없는 인원 = 34시간 (일괄)
    "2에서 계산 -> 불필요
*  ELSEIF ( LT_P0100-P02 IS NOT INITIAL AND LT_WPBP[] IS INITIAL ).
    "직영반장, 직영일반, 다기능공, 현장서무 기본연장근무시간 변경
*    IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
*      ET_PAYSLIP_B3-TIM01 = L_TIME = 36.
*    ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
*      ET_PAYSLIP_B3-TIM01 = L_TIME = 33.
*    ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2'.
*      ET_PAYSLIP_B3-TIM01 = L_TIME = 18.
*    ELSE.
*      ET_PAYSLIP_B3-TIM01 = L_TIME = 34.
*    ENDIF.

    "4. 기본연장급이 없을 경우
    "-> 기본연장근무시간 = 초과연장근무시간 = 일괄 0시간
  ELSEIF LT_P0100-P02 IS INITIAL.
    ET_PAYSLIP_B3-TIM01 = ET_PAYSLIP_B3-TIM01_O = L_TIME = 0.
  ENDIF.

  "초과연장근무시간 집계
  "대상 기간 내 ZHRPT0001의 임금유형 '3100'의 anzhl 일괄 합산
  "기본연장근무시간이 34시간인 대상자에 한해 기본연장근무시간을 초과할 경우 초과분 입력
*  REFRESH LT_ZHRPT0001.
*
*  SELECT *
*    FROM ZHRPT0001 INTO CORRESPONDING FIELDS OF TABLE LT_ZHRPT0001
*      WHERE PERNR IN IR_PERNR
*        AND BEGDA BETWEEN LV_BEGDA_2010 AND LV_ENDDA_2010.

  "연장근무수집 로직 수정 2026.08.27 ljs
  "PA0709에서 사번에 해당하는 PID를 조회한 후,
  "PID 기준으로 ZHRPT0001의 임금유형 '3100' ANZHL 합산

  CLEAR LV_PID.

  SELECT SINGLE PERSONID_EXT
    FROM PA0709
    INTO LV_PID
   WHERE PERNR = LT_P0100-PERNR
     AND BEGDA <= LT_P0100-PAYDT
     AND ENDDA >= LT_P0100-PAYDT.

  REFRESH LT_ZHRPT0001.

  IF LV_PID IS NOT INITIAL.
    SELECT *
      FROM ZHRPT0001
      INTO CORRESPONDING FIELDS OF TABLE LT_ZHRPT0001
     WHERE PERNR = LV_PID
       AND BEGDA BETWEEN LV_BEGDA_2010 AND LV_ENDDA_2010.
  ENDIF.

  SORT LT_ZHRPT0001 BY PERNR BEGDA.

  " 초과연장근무시간 로직 수정 2026.07.01 LJS
  " 기본연장근무시간이 34시간 이상인 경우, 아닌 경우로 분기
  IF ET_PAYSLIP_B3-TIM01 >= 34.
    "대상 기간 내 3100 ANZHL 일괄 합산
    LOOP AT LT_ZHRPT0001 ASSIGNING FIELD-SYMBOL(<FS_ZHRPT0001>) WHERE LGART = '3100'.
      LV_TIM02 = LV_TIM02 + <FS_ZHRPT0001>-ANZHL.
    ENDLOOP.

    "합산값이 기본연장 초과 시 초과분만 초과연장근무시간으로 표기
    "이하이면 초과연장근무시간 없음
    IF LV_TIM02 > ET_PAYSLIP_B3-TIM01.
      ET_PAYSLIP_B3-TIM02 = L_TIME = LV_TIM02 - ET_PAYSLIP_B3-TIM01.
    ELSE.
      ET_PAYSLIP_B3-TIM02 = L_TIME = 0.
    ENDIF.

    "기존 계산
    IF IR_PAYDT-LOW(6) <= C_04.
      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                             AND ZYYMM EQ IR_PAYDT-LOW(6).
        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
      ENDLOOP.

      IF SY-SUBRC NE 0.
        ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
      ENDIF.
    ELSEIF IR_PAYDT-LOW(6)  = C_05.
      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                             AND BEGDA >= '20250501'
                             AND BEGDA <= '20250520'.

        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
      ENDLOOP.

      ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
    ELSEIF IR_PAYDT-LOW(6) >= C_05.
      UNASSIGN <FS_ZHRPT0001>.
      LOOP AT LT_ZHRPT0001 ASSIGNING <FS_ZHRPT0001> WHERE LGART = '3200'.
        LV_TIM03 = LV_TIM03 + <FS_ZHRPT0001>-ANZHL.
      ENDLOOP.

      IF SY-SUBRC NE 0.
        LV_TIM03 = 0.
      ENDIF.

      ET_PAYSLIP_B3-TIM03 = L_TIME = LV_TIM03.
    ENDIF.
  ELSEIF ET_PAYSLIP_B3-TIM01 < 34.
    ET_PAYSLIP_B3-TIM02 = ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
  ENDIF.

  "여백 제거
  SHIFT: ET_PAYSLIP_B3-TIM02 LEFT DELETING LEADING SPACE,
         ET_PAYSLIP_B3-TIM03 LEFT DELETING LEADING SPACE.

*--------------------------------------------------------------------*
* 2026-07-16 하기 고정값 방식으로 원복하기 위해 기존 2010 집계 로직 주석 처리
* KDY
  "현장휴일근무 집계
  "25년 7월 이후부터는 IT2010의 임금유형 3600의 횟수 계산,
  "그 전까지는 하위그룹에 따른 시간 고정
*    CLEAR V_BEGDA.
**  V_BEGDA = IR_PAYDT-LOW && '01'.
*    CONCATENATE LT_P0100-PABRJ LT_P0100-PABRP '01' INTO V_BEGDA.
*
*    SELECT *
*      FROM PA2010 INTO CORRESPONDING FIELDS OF TABLE LT_PA2010
*        WHERE PERNR IN IR_PERNR
*          AND BEGDA BETWEEN LV_BEGDA_2010 AND LV_ENDDA_2010.
*
*    SORT LT_PA2010 BY BEGDA DESCENDING.
*
*    IF V_BEGDA(6) >= '202507'.
*      CLEAR LS_PA2010.
*      READ TABLE LT_PA2010 INTO LS_PA2010 WITH KEY LGART = '3600'.
*      LV_TIM04 = ( LS_PA2010-ANZHL / 14 ) * 8.
*      LV_TIM05 = ( LS_PA2010-ANZHL / 14 ).
*    ELSE.
*--------------------------------------------------------------------*
  "직영반장이나 일반일 경우 32/4로 값 변경
  "이외에는 16/2로 값 변경
  IF LS_0001-PERSG EQ '5'
    AND ( LS_0001-PERSK EQ 'E0' OR LS_0001-PERSK = 'E1' ).
    LV_TIM04 = '32'.
    LV_TIM05 = '4'.
  ELSE.
    LV_TIM04 = '16'.
    LV_TIM05 = '2'.
  ENDIF.
*    ENDIF.

  "휴일연장근무
  "1. 현장휴일근로수당이 있고 중도입사/퇴사 이력이 있는 경우
  "2. 현장휴일근로수당이 있고 중도입사/퇴사 이력이 없는 경우
  "3. 현장휴일근로수당이 없는 경우
  IF ( LT_P0100-P19 <> 0 AND LT_WPBP[] IS NOT INITIAL ).
    CASE LV_LINES.
        "신규입사자
      WHEN 1.
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
          IF ( LV_LINES = 1 AND LT_WPBP-BEGDA+6(2) NE '01' ).
            "lt_wpbp의 시작일, 종료일 기준으로 집계하는 경우
            CLEAR LV_WDAYS.
            IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
            ENDIF.
            ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04 / LV_WDAYS.
            ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05 / LV_WDAYS.
            "신규입사자가 아닌 경우
          ELSEIF ( LV_LINES = 1 AND LT_WPBP-BEGDA+6(2) EQ '01' ).
            ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04.
            ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05.
          ENDIF.

        ENDLOOP.
      WHEN OTHERS.
        "중도퇴사자
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6)
                          AND MASSN = 'O0'.
        ENDLOOP.

        IF SY-SUBRC EQ 0.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04 / LV_WDAYS.
          ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05 / LV_WDAYS.
        ELSE.
          ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04.
          ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05.
        ENDIF.
    ENDCASE.
*  ELSEIF LT_P0100-P19 <> 0 AND LT_WPBP[] IS INITIAL.
*    ET_PAYSLIP_B3-TIM04 = L_TIME = LV_TIM04.
*    ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
*    ET_PAYSLIP_B3-TIM05 = L_TIME = LV_TIM05.
*    ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
  ELSEIF LT_P0100-P19 EQ 0.
    ET_PAYSLIP_B3-TIM04 = L_TIME = 0.
    ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
    ET_PAYSLIP_B3-TIM05 = L_TIME = LT_P0100-T05.
    ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
  ENDIF.

  "특근근무시간
  "특근시간 = 특근 시간 - 특근수당 / 통상 시급 * 1.5
  ET_PAYSLIP_B3-TIM06 = L_TIME = L_TIME_ND = LT_P0100-T04.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_BETRG
*&---------------------------------------------------------------------*
FORM CALC_BETRG TABLES ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                       LT_P0100      STRUCTURE ZHRT0100
                       LT_P0100_2    STRUCTURE ZHRT0100
                       LT_WPBP       STRUCTURE PC205
                       IR_ORGEH      STRUCTURE CCHRS_ORGEH_RANGE
                 USING WA1           STRUCTURE ZHRS0021
                       IV_YEAR
                       V_YNCA
                       V_YNCA_H.

  DATA: LV_RESULT       TYPE ZCALC07,
        LV_P22(20)      TYPE C,
        LV_BET01(2)     TYPE C,
        LV_P22_2(20)    TYPE C,

        LT_0015         TYPE TABLE OF PA0015 WITH HEADER LINE,
        LV_BETRG        TYPE CHAR15,

        LV_DATE_NEW(10) TYPE C,
        LV_COUNT        TYPE I,
        LV_LINES        TYPE I.

  CLEAR: LV_RESULT, LV_P22, LV_BET01, LV_P22_2, LT_0015, LV_BETRG, LV_LINES.
  REFRESH LT_0015.

*  DESCRIBE TABLE LT_WPBP LINES LV_LINES.
  LOOP AT LT_WPBP ASSIGNING FIELD-SYMBOL(<FS_WPBP>) WHERE BEGDA <= LT_P0100-ZPAYDT
                                                      AND ENDDA >= LT_P0100-ZPAYDT.
    IF SY-SUBRC EQ 0.
      LV_LINES = LV_LINES + 1.
    ENDIF.
  ENDLOOP.

  " 통상시급 출력 2026.06.15 BY SEPPIN LJS
  WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
  SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
  REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.

  "통상시급
  TRY.
      IF IV_YEAR >= '2025'.
        LV_DATE_NEW = ET_PAYSLIP_B3-PAYDT.

        REPLACE ALL OCCURRENCES OF '.' IN LV_DATE_NEW WITH SPACE.
        REPLACE ALL OCCURRENCES OF '/' IN LV_DATE_NEW WITH SPACE.
        "지급일이 3월이 아니면 미출력 오류 수정 - 20261028 추가
        "연차보상 신설로 인해 기존 계산 방식 폐기
*        IF LV_DATE_NEW+4(2) = '03'.
*          IF LV_DATE_NEW+6(2) = '05'.
*            WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
*            SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
*            REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.
*            WRITE WA1-P22 TO LV_P22 CURRENCY 'KRW'.
*            SHIFT LV_P22 LEFT DELETING LEADING SPACE.
*            REPLACE ALL OCCURRENCES OF ',' IN LV_P22 WITH SPACE.
*            "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
*            LV_RESULT = CONV INT4( LV_P22 ) / ( CONV INT4( ET_PAYSLIP_B3-CALC00 ) * 8 ).
*            WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07.
*            SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.
*          ELSE.
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
            "중도퇴직자의 경우, 당월 + 전달의 결과가 필요함
            CLEAR: LT_P0100_2[].
            "라인이 2개면 중도 퇴사자
            IF LV_LINES EQ 2.
              SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                                FROM   ZHRT0100
                                WHERE  PERNR = ET_PAYSLIP_B3-PERNR
                                  AND  FPPER  BETWEEN V_YNCA_H+0(6) AND LV_DATE_NEW+0(6)
                                  AND  ORGEH IN IR_ORGEH.

              LV_COUNT = LINES( LT_P0100_2 ).

              "연차수당 조회
              SELECT * FROM PA0015
                WHERE PERNR = @ET_PAYSLIP_B3-PERNR
                AND LGART = '3700'
                ORDER BY BEGDA DESCENDING
                INTO CORRESPONDING FIELDS OF TABLE @LT_0015
                UP TO @LV_COUNT ROWS.

            ELSE.
              "한 줄이고 일자가 1일이 아니면 중도 입사인데
              "중도 퇴사가 아니면 지급일 기준으로 SELECT
              "우선 이전월 급여로 계산

              SELECT *
                FROM ZHRT0100 INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                WHERE PERNR = ET_PAYSLIP_B3-PERNR
                  AND FPPER EQ V_YNCA_H+0(6)
                  AND ORGEH IN IR_ORGEH.

              "이전달 급여결과 없다면, 신규입사자이므로 이번달 계산결과로 사용
              IF LT_P0100_2[] IS INITIAL.
                SELECT *
                  FROM ZHRT0100 INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
                    WHERE PERNR = ET_PAYSLIP_B3-PERNR
                      AND FPPER EQ V_YNCA+0(6)
                      AND ORGEH IN IR_ORGEH.
              ENDIF.

            ENDIF.

            SORT LT_P0100_2 ASCENDING BY PERNR PAYDT.
            SORT LT_0015 ASCENDING BY BEGDA.

            LOOP AT LT_P0100_2.
              WRITE LT_P0100_2-BET01 TO LV_BET01 CURRENCY 'KRW'.
              SHIFT LV_BET01 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ',' IN LV_BET01 WITH SPACE.
              WRITE WA1-P22 TO LV_P22_2 CURRENCY 'KRW'.
              SHIFT LV_P22_2 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ',' IN LV_P22_2 WITH SPACE.
              "연차수당 보상 일수 = 연차수당 / (통상시급 * 8)
              TRY.
                  LV_RESULT = CONV INT4( LV_P22_2 ) / ( CONV INT4( LV_BET01 ) * 8 ).
                CATCH CX_SY_ZERODIVIDE.

              ENDTRY.
              WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07.
              SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.
            ENDLOOP.
*          ENDIF.
*        ELSE.
*        ENDIF.
      ENDIF.
    CATCH CX_SY_CONVERSION_NO_NUMBER.

  ENDTRY.

  "석식대수당
  IF WA1-P22 IS INITIAL.
    ET_PAYSLIP_B3-CALC08 = 0.
  ELSE.
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

  "직책선임수당
  IF WA1-P09 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_2 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_2 = WA1-P09.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_2 LEFT DELETING LEADING SPACE.

  "AI 활용지원
  IF WA1-P32 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_3 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_3 = WA1-P32.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_3 LEFT DELETING LEADING SPACE.

  "급지수당
  IF WA1-P07 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_4 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_4 = WA1-P07.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_4 LEFT DELETING LEADING SPACE.

  "연차보상
*  IF wa1.
*
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_RATE
*&---------------------------------------------------------------------*
FORM CALC_RATE TABLES LT_T7KRSR     STRUCTURE T7KRSR
                      ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                      LT_P0100      STRUCTURE ZHRT0100
                USING LS_T7KRMR          TYPE T7KRMR
                      LS_T7KRIR          TYPE T7KRIR.

  DATA: LV_BEGDA TYPE BEGDA,    "요율 조회용 일자
        LV_ENDDA TYPE ENDDA.

  CLEAR: LV_BEGDA, LV_ENDDA.

  LV_BEGDA = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }01|.

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


  WRITE LS_T7KRMR-EEPRT TO ET_PAYSLIP_B3-RATE_01 STYLE 0 LEFT-JUSTIFIED.

  IF LS_T7KRIR IS INITIAL.  "장기요양보험요율
    SELECT SINGLE * FROM T7KRIR
      INTO CORRESPONDING FIELDS OF LS_T7KRIR
     WHERE SIPID = '01'
       AND ENDDA >= LV_BEGDA
       AND BEGDA <= LV_BEGDA.
  ENDIF.

  WRITE LS_T7KRIR-EEPRT TO ET_PAYSLIP_B3-RATE_02 STYLE 0 LEFT-JUSTIFIED.

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
        WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_B3-RATE_03 STYLE 0 LEFT-JUSTIFIED.
      WHEN '3'.
        WRITE LT_T7KRSR-EEPRT TO ET_PAYSLIP_B3-RATE_04 STYLE 0 LEFT-JUSTIFIED.
    ENDCASE.
  ENDLOOP.

  CONCATENATE: ET_PAYSLIP_B3-RATE_01 '%' INTO ET_PAYSLIP_B3-RATE_01,
               ET_PAYSLIP_B3-RATE_02 '%' INTO ET_PAYSLIP_B3-RATE_02,
               ET_PAYSLIP_B3-RATE_03 '%' INTO ET_PAYSLIP_B3-RATE_03,
               ET_PAYSLIP_B3-RATE_04 '%' INTO ET_PAYSLIP_B3-RATE_04.
ENDFORM.