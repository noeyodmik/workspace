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
  DATA: LT_P0100    TYPE TABLE OF ZHRT0100 WITH HEADER LINE,
        LT_P0100_2  TYPE TABLE OF ZHRT0100 WITH HEADER LINE,
        LT_ZHRT0300 TYPE TABLE OF ZHRT0300 WITH HEADER LINE,
        LT_P9001    TYPE TABLE OF P9001    WITH HEADER LINE,
        LT_RGDIR    TYPE TABLE OF HRPY_RGDIR WITH HEADER LINE,
        LT_WPBP     TYPE TABLE OF PC205    WITH HEADER LINE,
        V_BEGDA     TYPE SY-DATUM,
        WAS         TYPE ZHRS0023, "Header
        WA1         TYPE ZHRS0021, "지급내역
        WA1_1       TYPE ZHRS0021,
        WA2         TYPE ZHRS0022, "공제항목
        WA2_2       TYPE ZHRS0022,
        V_YNCA      TYPE SY-DATUM, "조회일자
        V_YNCA_H    TYPE SY-DATUM.

  DATA: LS_T7KRMR LIKE T7KRMR,                           "건강보험요율
        LS_T7KRIR LIKE T7KRIR,                           "장기요양보험요율
        LT_T7KRSR LIKE TABLE OF T7KRSR WITH HEADER LINE. "국민연금, 고용보험요율

************************************************************************
* Logic
************************************************************************
  CLEAR P_CNT.

*-----------------------------------------------------------------------
*--  1. 급여 결과 디렉토리(RGDIR) 조회 (202505 이전 FPPER 보정 포함)
*-----------------------------------------------------------------------
  PERFORM GET_PAYRESULT TABLES LT_RGDIR
                               IR_PERNR
                               IR_PAYDT
                      CHANGING V_BEGDA.

*----------------------------------------------------------------------
*--  2. 급여명세서 대상 실적(ZHRT0100) 및 공지(ZHRT0300) 조회
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
*--  3. 사원별 급여명세서 데이터 구성
*----------------------------------------------------------------------
  LOOP AT LT_P0100.
    CLEAR: WAS, WA1, WA2, WA1_1, WA2_2, ET_PAYSLIP_B3, LT_WPBP, LT_WPBP[].

    " [개선 1-1] 현재 사원(LT_P0100-PERNR)의 WPBP만 개별 추출하여 타 사원 혼선 방지
    PERFORM GET_EMP_WPBP TABLES LT_RGDIR
                                LT_WPBP
                          USING LT_P0100-PERNR.

    " 3-1. 급여명세서 - HEADER
    PERFORM SET_HEADER TABLES LT_ZHRT0300
                              LT_P9001
                              LT_P0100
                              ET_PAYSLIP_B3
                        USING PV_ZSTYPE
                     CHANGING WAS.

    " 3-2. 급여명세서 - 항목명 및 금액 매핑
    PERFORM SET_ITEM USING LT_P0100
                  CHANGING WA1
                           WA2.

    " 3-3. 급여명세서 - 지급/공제항목 압축 (금액이 있는 항목만 순차 배치)
    PERFORM SET_BETRG CHANGING WA1
                               WA2
                               WA1_1
                               WA2_2
                               ET_PAYSLIP_B3
                               P_CNT.

    " 3-4. 급여명세서 - 근무일수 및 근무시간 계산
    PERFORM CALC_WKDAY TABLES ET_PAYSLIP_B3
                              IR_PERNR
                              IR_ORGEH
                              IR_PAYDT
                              LT_WPBP
                        USING LT_P0100
                              PV_ZSTYPE.

    " 3-5. 급여명세서 - 산출식 수당 및 보상일수 계산
    PERFORM CALC_BETRG TABLES ET_PAYSLIP_B3
                              LT_P0100
                              LT_P0100_2
                              LT_WPBP
                              IR_ORGEH
                        USING WA1
                              IV_YEAR
                              PV_ZSTYPE
                              V_YNCA
                              V_YNCA_H.

    " 3-6. 급여명세서 - 요율(국민연금, 고용보험, 건강보험) 계산
    PERFORM CALC_RATE TABLES LT_T7KRSR
                             ET_PAYSLIP_B3
                             LT_P0100
                       USING LS_T7KRMR
                             LS_T7KRIR.

    APPEND ET_PAYSLIP_B3.
    CLEAR ET_PAYSLIP_B3.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PAYRESULT
*&---------------------------------------------------------------------*
FORM GET_PAYRESULT TABLES   LT_RGDIR STRUCTURE HRPY_RGDIR
                            IR_PERNR STRUCTURE SEL_PERNR
                            IR_PAYDT STRUCTURE SEL_DATE
                   CHANGING V_BEGDA.

  DATA: LV_DATE TYPE DATS.

  CLEAR: LT_RGDIR, LT_RGDIR[].
  REFRESH: LT_RGDIR.

  IF IR_PAYDT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_RGDIR
      FROM HRPY_RGDIR
     WHERE PERNR IN IR_PERNR
       AND SRTZA = 'A'.
  ELSE.
    " Webdynpro 등에서 단일 지급일 조회 시 HIGH가 비어있으면 월말일로 보정
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

  " [유지 1-2] 202505 이전 FPPER 1개월 차감 로직 유지
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

      LT_RGDIR-FPPER = LV_DATE(6).
      MODIFY LT_RGDIR INDEX SY-TABIX.
    ENDIF.
  ENDLOOP.

  SORT LT_RGDIR BY PERNR FPPER PAYDT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_EMP_WPBP
*&---------------------------------------------------------------------*
*       [개선 1-1] 특정 사원(PV_PERNR)의 WPBP만 추출
*----------------------------------------------------------------------*
FORM GET_EMP_WPBP TABLES LT_RGDIR STRUCTURE HRPY_RGDIR
                         LT_WPBP  STRUCTURE PC205
                   USING PV_PERNR TYPE PERSNO.

  DATA: LT_TMP_WPBP TYPE TABLE OF PC205 WITH HEADER LINE.

  CLEAR: LT_WPBP, LT_WPBP[].

  LOOP AT LT_RGDIR WHERE PERNR = PV_PERNR.
    CLEAR: LT_TMP_WPBP, LT_TMP_WPBP[].

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
        WPBP   = LT_TMP_WPBP[].

    IF LT_TMP_WPBP[] IS NOT INITIAL.
      MOVE-CORRESPONDING LT_TMP_WPBP[] TO LT_WPBP[] KEEPING TARGET LINES.
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

  CLEAR: ET_PAYSLIP_B3, ET_PAYSLIP_B3[], LT_P0100, LT_P0100[],
         LT_P0100_2, LT_P0100_2[], LT_ZHRT0300, LT_ZHRT0300[].

  SELECT *
    FROM ZHRT0100
    INTO CORRESPONDING FIELDS OF TABLE LT_P0100
   WHERE PERNR IN IR_PERNR
     AND PAYDT IN IR_PAYDT
     AND ORGEH IN IR_ORGEH
     AND ZSTYPE = PV_ZSTYPE.

  SORT LT_P0100[] ASCENDING BY PERNR PAYDT.

  IF LT_P0100[] IS NOT INITIAL.
    SELECT *
      FROM ZHRT0300
      INTO CORRESPONDING FIELDS OF TABLE LT_ZHRT0300
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
              CHANGING WAS           TYPE ZHRS0023.

  DATA: LV_TEXT(30) TYPE C,
        LV_DIVGVXT  TYPE STRING.

  SELECT SINGLE ENAME FROM PA0001 INTO WAS-ENAME
   WHERE PERNR  = LT_P0100-PERNR
     AND BEGDA <= LT_P0100-PAYDT
     AND ENDDA >= LT_P0100-PAYDT.

  " 사원번호
  WRITE LT_P0100-PERNR TO WAS-PERNR NO-ZERO.

  " 부서명 / 직급명
  WAS-STEXT = LT_P0100-ORGEH_TEXT.
  WAS-ZJ2T  = LT_P0100-ZZCALTLTX.

  " 타이틀
  IF LT_P0100-LIST_TXT IS NOT INITIAL.
    WAS-TITLE = LT_P0100-LIST_TXT.
  ELSE.
    CLEAR LV_TEXT.
    SELECT SINGLE DDTEXT FROM DD07T INTO LV_TEXT
     WHERE DOMNAME    = 'ZSTYPE'
       AND DDLANGUAGE = SY-LANGU
       AND DOMVALUE_L = LT_P0100-ZSTYPE.

    CASE LT_P0100-ZSTYPE.
      WHEN '800'.
        WAS-TITLE = |{ LT_P0100-PABRJ+2(2) }년 { LV_TEXT } 명세서|.
      WHEN OTHERS.
        WAS-TITLE = |{ LT_P0100-PABRJ }년 { LT_P0100-PABRP }월 { LV_TEXT }명세서|.
    ENDCASE.
  ENDIF.

  " 급여명세서 메시지 (미사용 - 차후 개선 예정으로 현행 유지)
  CLEAR: LT_ZHRT0300.
  READ TABLE LT_ZHRT0300 WITH KEY PAYDT = LT_P0100-PAYDT.
  IF SY-SUBRC EQ 0.
    ET_PAYSLIP_B3-ZMESSAGE1 = |* { LT_ZHRT0300-ZMESSAGE }|.
  ENDIF.

  PERFORM HR_READ_INFOTYPE TABLES LT_P9001
                            USING '9001'
                                  LT_P0100-PERNR
                                  LT_P0100-PAYDT.
  READ TABLE LT_P9001 WITH KEY ZSTYPE = PV_ZSTYPE.
  IF SY-SUBRC EQ 0.
    IF ET_PAYSLIP_B3-ZMESSAGE1 IS NOT INITIAL.
      ET_PAYSLIP_B3-ZMESSAGE2 = |* { LT_P9001-ZMESSAGE }|.
    ENDIF.
  ELSE.
    ET_PAYSLIP_B3-ZMESSAGE1 = |* { LT_P9001-ZMESSAGE }|.
  ENDIF.

  " 저장된 총액 및 시급 포맷팅
  PERFORM: FORMAT_TOTAL USING LT_P0100-P_TOTAL CHANGING WAS-P999,
           FORMAT_TOTAL USING LT_P0100-D_TOTAL CHANGING WAS-D99,
           FORMAT_TOTAL USING LT_P0100-TOTAL   CHANGING WAS-TOTAL,
           FORMAT_TOTAL USING LT_P0100-BET01   CHANGING WAS-BET01,
           FORMAT_TOTAL USING LT_P0100-BET02   CHANGING WAS-BET02.

  " 급여 대상 기간 내 소정근로시간 (체육선수: 104.3시간, 그 외: 209시간)
  IF LT_P0100-ZZPSGRPTX = '체육'.
    LV_DIVGVXT = '104.3'.
  ELSE.
    LV_DIVGVXT = '209'.
  ENDIF.
  ET_PAYSLIP_B3-DIVGV = LV_DIVGVXT.

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

  " [유지 3-3] 특별성과급(비과세) P27이 있는 경우 특별성과급(P25)으로 덮어쓰기 유지
  IF LT_P0100-P27 > 0.
    LT_P0100-P25 = LT_P0100-P27.
  ENDIF.

  CLEAR: LV_YYYYMM, LV_P07, LV_P19.

  " 급여년월 판단 (2026.01 이전: 급지수당을 현장휴일근로에 합산 / 이후: 별도 출력)
  IF LT_P0100-FPPER IS NOT INITIAL.
    LV_YYYYMM = LT_P0100-FPPER.
  ELSE.
    CONCATENATE LT_P0100-PABRJ LT_P0100-PABRP INTO LV_YYYYMM.
  ENDIF.

  LV_P07 = LT_P0100-P07. "급지수당
  LV_P19 = LT_P0100-P19. "현장휴일근로

  IF LV_YYYYMM < '202601'.
    LV_P19 = LV_P19 + LV_P07.
    CLEAR LV_P07.
  ENDIF.

  " === 지급내역 매핑 ===
  WRITE LT_P0100-P01 TO WA1-P01 CURRENCY 'KRW'.
  WA1-LGTXT01 = '기  본  급'.
  CONDENSE WA1-P01.

  WRITE LT_P0100-P02 TO WA1-P02 CURRENCY 'KRW'.
  WA1-LGTXT02 = '기본연장급'.
  CONDENSE WA1-P02.

  WRITE LT_P0100-P03 TO WA1-P03 CURRENCY 'KRW'.
  WA1-LGTXT03 = '능  력  급'.
  CONDENSE WA1-P03.

  " 포상금 (P29 -> P04 슬롯 사용)
  WRITE LT_P0100-P29 TO WA1-P04 CURRENCY 'KRW'.
  WA1-LGTXT04 = '포 상 금'.
  CONDENSE WA1-P04.

  WRITE LT_P0100-P05 TO WA1-P05 CURRENCY 'KRW'.
  WA1-LGTXT05 = '식 대 수 당'.
  CONDENSE WA1-P05.

  WRITE LT_P0100-P06 TO WA1-P06 CURRENCY 'KRW'.
  WA1-LGTXT06 = '현 장 직 무'.
  CONDENSE WA1-P06.

  WRITE LV_P07 TO WA1-P07 CURRENCY 'KRW'.
  WA1-LGTXT07 = '급지수당'.
  CONDENSE WA1-P07.

  WRITE LT_P0100-P08 TO WA1-P08 CURRENCY 'KRW'.
  WA1-LGTXT08 = '자격증수당'.
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
  WA1-T17     = LT_P0100-T02.
  CONDENSE WA1-P17.

  WRITE LT_P0100-P18 TO WA1-P18 CURRENCY 'KRW'.
  WA1-LGTXT18 = '야간근무수당'.
  WA1-T18     = LT_P0100-T03.
  CONDENSE WA1-P18.

  WRITE LV_P19 TO WA1-P19 CURRENCY 'KRW'.
  WA1-LGTXT19 = '현장휴일근로'.
  WA1-T19     = LT_P0100-T04.
  CONDENSE WA1-P19.

  WRITE LT_P0100-P20 TO WA1-P20 CURRENCY 'KRW'.
  WA1-LGTXT20 = '휴일연장수당'.
  WA1-T20     = LT_P0100-T05.
  CONDENSE WA1-P20.

  " [수정 3-2] 석식대수당 시간/일수 필드 오타 수정 (WA1-T23 -> WA1-T21)
  WRITE LT_P0100-P21 TO WA1-P21 CURRENCY 'KRW'.
  WA1-LGTXT21 = '석식대수당'.
  WA1-T21     = LT_P0100-T06.
  CONDENSE WA1-P21.

  WRITE LT_P0100-P22 TO WA1-P22 CURRENCY 'KRW'.
  WA1-LGTXT22 = '연 차 수 당'.
  WA1-T22     = LT_P0100-T07.
  CONDENSE WA1-P22.

  WRITE LT_P0100-P23 TO WA1-P23 CURRENCY 'KRW'.
  WA1-LGTXT23 = '정 기 상 여'.
  WA1-T23     = LT_P0100-T08.
  CONDENSE WA1-P23.

  " [추가 3-1] 신설 '연차보상' (P24 매핑)
  WRITE LT_P0100-P24 TO WA1-P24 CURRENCY 'KRW'.
  WA1-LGTXT24 = '연 차 보 상'.
  WA1-T24     = LT_P0100-T08.
  CONDENSE WA1-P24.

  WRITE LT_P0100-P25 TO WA1-P25 CURRENCY 'KRW'.
  WA1-LGTXT25 = '특별성과급'.
  WA1-T25     = LT_P0100-T08.
  CONDENSE WA1-P25.

  WRITE LT_P0100-P26 TO WA1-P26 CURRENCY 'KRW'.
  WA1-LGTXT26 = '휴  가  비'.
  CONDENSE WA1-P26.

  WRITE LT_P0100-P28 TO WA1-P28 CURRENCY 'KRW'.
  WA1-LGTXT28 = '기 타 지 급'.
  CONDENSE WA1-P28.

  WRITE LT_P0100-P30 TO WA1-P30 CURRENCY 'KRW'.
  WA1-LGTXT30 = '기 지 급 금'.
  CONDENSE WA1-P30.

  WRITE LT_P0100-R_TOTAL TO WA1-P31 CURRENCY 'KRW'.
  WA1-LGTXT31 = '소  급  분'.
  CONDENSE WA1-P31.

  WRITE LT_P0100-P32 TO WA1-P32 CURRENCY 'KRW'.
  WA1-LGTXT32 = 'AI 활용지원'.
  CONDENSE WA1-P32.

  " === 공제내역 매핑 ===
  WRITE LT_P0100-D01   TO WA2-D01 CURRENCY 'KRW'.
  WA2-LGTXT_01 = '소  득  세'.
  CONDENSE WA2-D01.

  WRITE LT_P0100-D02   TO WA2-D02 CURRENCY 'KRW'.
  WA2-LGTXT_02 = '주  민  세'.
  CONDENSE WA2-D02.

  WRITE LT_P0100-D01_1 TO WA2-D03 CURRENCY 'KRW'.
  WA2-LGTXT_03 = '정산소득세'.
  CONDENSE WA2-D03.

  WRITE LT_P0100-D02_1 TO WA2-D04 CURRENCY 'KRW'.
  WA2-LGTXT_04 = '정산주민세'.
  CONDENSE WA2-D04.

  WRITE LT_P0100-D03   TO WA2-D05 CURRENCY 'KRW'.
  WA2-LGTXT_05 = '국 민 연 금'.
  CONDENSE WA2-D05.

  WRITE LT_P0100-D04   TO WA2-D06 CURRENCY 'KRW'.
  WA2-LGTXT_06 = '건 강 보 험'.
  CONDENSE WA2-D06.

  WRITE LT_P0100-D04_1 TO WA2-D07 CURRENCY 'KRW'.
  WA2-LGTXT_07 = '건강보험정산'.
  CONDENSE WA2-D07.

  WRITE LT_P0100-D05   TO WA2-D08 CURRENCY 'KRW'.
  WA2-LGTXT_08 = '장 기 요 양'.
  CONDENSE WA2-D08.

  WRITE LT_P0100-D05_1 TO WA2-D09 CURRENCY 'KRW'.
  WA2-LGTXT_09 = '장기요양정산'.
  CONDENSE WA2-D09.

  WRITE LT_P0100-D06_2 TO WA2-D10 CURRENCY 'KRW'.
  WA2-LGTXT_10 = '고 용 보 험'.
  CONDENSE WA2-D10.

  WRITE LT_P0100-D07   TO WA2-D11 CURRENCY 'KRW'.
  WA2-LGTXT_11 = ' '.
  CONDENSE WA2-D11.

  WRITE LT_P0100-D08   TO WA2-D12 CURRENCY 'KRW'.
  WA2-LGTXT_12 = '주  차  비'.
  CONDENSE WA2-D12.

  WRITE LT_P0100-D09   TO WA2-D13 CURRENCY 'KRW'.
  WA2-LGTXT_13 = '구 내 식 당'.
  CONDENSE WA2-D13.

  WRITE LT_P0100-D10   TO WA2-D14 CURRENCY 'KRW'.
  WA2-LGTXT_14 = '린 라 운 지'.
  CONDENSE WA2-D14.

  WRITE LT_P0100-D11   TO WA2-D15 CURRENCY 'KRW'.
  WA2-LGTXT_15 = '통 근 버 스'.
  CONDENSE WA2-D15.

  WRITE LT_P0100-D12   TO WA2-D16 CURRENCY 'KRW'.
  WA2-LGTXT_16 = '복지월상환금'.
  CONDENSE WA2-D16.

  WRITE LT_P0100-D13   TO WA2-D17 CURRENCY 'KRW'.
  WA2-LGTXT_17 = '복 지 이 자'.
  CONDENSE WA2-D17.

  WRITE LT_P0100-D14   TO WA2-D18 CURRENCY 'KRW'.
  WA2-LGTXT_18 = '경  조  비'.
  CONDENSE WA2-D18.

  WRITE LT_P0100-D15   TO WA2-D19 CURRENCY 'KRW'.
  WA2-LGTXT_19 = '기 타 공 제'.
  CONDENSE WA2-D19.

  WRITE LT_P0100-D16   TO WA2-D20 CURRENCY 'KRW'.
  WA2-LGTXT_20 = '학자금대출'.
  CONDENSE WA2-D20.

  WRITE LT_P0100-D17   TO WA2-D21 CURRENCY 'KRW'.
  WA2-LGTXT_21 = '통신비공제'.
  CONDENSE WA2-D21.

  WRITE LT_P0100-D01_9 TO WA2-D22 CURRENCY 'KRW'.
  WA2-LGTXT_22 = '연말정산소득세'.
  CONDENSE WA2-D22.

  WRITE LT_P0100-D02_9 TO WA2-D23 CURRENCY 'KRW'.
  WA2-LGTXT_23 = '연말정산주민세'.
  CONDENSE WA2-D23.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_BETRG
*&---------------------------------------------------------------------*
FORM SET_BETRG  CHANGING WA1           TYPE ZHRS0021
                         WA2           TYPE ZHRS0022
                         WA1_1         TYPE ZHRS0021
                         WA2_2         TYPE ZHRS0022
                         ET_PAYSLIP_B3 TYPE ZHRS0027_B3
                         P_CNT         TYPE I.

  DATA: LV_NUM(2)   TYPE N,
        LV_NUM_2(2) TYPE N,
        LV_TEXT(30) TYPE C.

  FIELD-SYMBOLS: <FS_LGTXX>   TYPE ANY,
                 <FS_BETXX>   TYPE ANY,
                 <FS_ANZXX>   TYPE ANY,
                 <FS_LGTXX_2> TYPE ANY,
                 <FS_BETXX_2> TYPE ANY,
                 <FS_ANZXX_2> TYPE ANY.

  CLEAR: LV_NUM, LV_NUM_2, WA1_1, WA2_2, P_CNT.

  " 지급항목 압축 (금액이 0이 아닌 항목만 순차 배치)
  DO 32 TIMES.
    LV_NUM = LV_NUM + 1.
    UNASSIGN: <FS_LGTXX>, <FS_BETXX>, <FS_ANZXX>.

    LV_TEXT = |WA1-LGTXT{ LV_NUM }|.
    ASSIGN (LV_TEXT) TO <FS_LGTXX>.

    LV_TEXT = |WA1-P{ LV_NUM }|.
    ASSIGN (LV_TEXT) TO <FS_BETXX>.

    LV_TEXT = |WA1-T{ LV_NUM }|.
    ASSIGN (LV_TEXT) TO <FS_ANZXX>.

    IF <FS_LGTXX> IS NOT INITIAL AND <FS_BETXX> NE '0'.
      LV_NUM_2 = LV_NUM_2 + 1.

      LV_TEXT = |WA1_1-LGTXT{ LV_NUM_2 }|.
      ASSIGN (LV_TEXT) TO <FS_LGTXX_2>.

      LV_TEXT = |WA1_1-P{ LV_NUM_2 }|.
      ASSIGN (LV_TEXT) TO <FS_BETXX_2>.

      LV_TEXT = |WA1_1-T{ LV_NUM_2 }|.
      ASSIGN (LV_TEXT) TO <FS_ANZXX_2>.

      MOVE <FS_LGTXX> TO <FS_LGTXX_2>.
      MOVE <FS_BETXX> TO <FS_BETXX_2>.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_BETXX_2>.
      SHIFT <FS_BETXX_2> RIGHT DELETING TRAILING SPACE.
      MOVE <FS_ANZXX> TO <FS_ANZXX_2>.

      P_CNT = P_CNT + 1.

      IF LV_NUM_2 > 21.
        LV_NUM_2 = 1.
      ENDIF.
    ENDIF.
  ENDDO.

  MOVE-CORRESPONDING WA1_1 TO ET_PAYSLIP_B3.

  " 공제항목 압축 (금액이 0이 아닌 항목만 순차 배치)
  CLEAR: LV_NUM, LV_NUM_2, WA2_2.
  DO 27 TIMES.
    LV_NUM = LV_NUM + 1.
    UNASSIGN: <FS_LGTXX>, <FS_BETXX>.

    LV_TEXT = |WA2-LGTXT_{ LV_NUM }|.
    ASSIGN (LV_TEXT) TO <FS_LGTXX>.

    LV_TEXT = |WA2-D{ LV_NUM }|.
    ASSIGN (LV_TEXT) TO <FS_BETXX>.

    IF <FS_LGTXX> IS NOT INITIAL AND <FS_BETXX> NE '0'.
      LV_NUM_2 = LV_NUM_2 + 1.

      LV_TEXT = |WA2_2-LGTXT_{ LV_NUM_2 }|.
      ASSIGN (LV_TEXT) TO <FS_LGTXX_2>.

      LV_TEXT = |WA2_2-D{ LV_NUM_2 }|.
      ASSIGN (LV_TEXT) TO <FS_BETXX_2>.

      MOVE <FS_LGTXX> TO <FS_LGTXX_2>.
      MOVE <FS_BETXX> TO <FS_BETXX_2>.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_BETXX_2>.
      SHIFT <FS_BETXX_2> RIGHT DELETING TRAILING SPACE.

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

  DATA: LV_LINES      TYPE I,
        LV_WDAYS      TYPE I,      "근무일수
        LV_BEGDA_TIME TYPE BEGDA,
        LV_ENDDA_TIME TYPE ENDDA,
        LT_ZHRPT0001  TYPE TABLE OF ZHRPT0001 WITH HEADER LINE,
        LV_BEGDA_2010 TYPE BEGDA,  "전월 21일(연장근무)
        LV_ENDDA_2010 TYPE ENDDA,  "당월 20일(연장근무)
        LV_PREV_DATE  TYPE DATS,   "전월 계산용
        LS_0001       TYPE PA0001,
        LV_BASE_OT    TYPE P DECIMALS 2,

        L_TIME(6)     TYPE P DECIMALS 2,
        L_TIME_ND(6)  TYPE P DECIMALS 2,
        L_TIME_M(6)   TYPE P DECIMALS 1,

        LV_TIM02(6)   TYPE P DECIMALS 2,
        LV_TIM03(6)   TYPE P DECIMALS 2,

        LV_TIM04      TYPE CHAR6,
        LV_TIM05      TYPE CHAR6,
        LV_PID        TYPE PA0709-PERSONID_EXT.

  CONSTANTS: C_04(6) TYPE C VALUE '202504',
             C_05(6) TYPE C VALUE '202505'.

  " 지급일 포맷팅
  WRITE: LT_P0100-PAYDT  TO ET_PAYSLIP_B3-PAYDT  MM/DD/YYYY,
         LT_P0100-ZPAYDT TO ET_PAYSLIP_B3-ZPAYDT MM/DD/YYYY.

  CLEAR: LV_BEGDA_2010, LV_ENDDA_2010, LV_BEGDA_TIME, LV_ENDDA_TIME, LV_PREV_DATE.

  " 당월 1일 및 말일 계산
  LV_BEGDA_TIME = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }01|.
  CONDENSE LV_BEGDA_TIME NO-GAPS.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      DAY_IN            = LV_BEGDA_TIME
    IMPORTING
      LAST_DAY_OF_MONTH = LV_ENDDA_TIME.

  " [수정 2-3] 1월 급여 조회 시 전월('00'월) 오타 방지: RP_CALC_DATE_IN_INTERVAL로 전월 산출
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      DATE      = LV_BEGDA_TIME
      DAYS      = '00'
      MONTHS    = '01'
      SIGNUM    = '-'
      YEARS     = '00'
    IMPORTING
      CALC_DATE = LV_PREV_DATE.

  LV_BEGDA_2010 = |{ LV_PREV_DATE(6) }21|.
  LV_ENDDA_2010 = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }20|.

  " 급여유형 100(정규급여) 외 계산항목 0 처리
  IF PV_ZSTYPE <> '100'.
    ET_PAYSLIP_B3-TIM01 = 0.
    ET_PAYSLIP_B3-TIM02 = 0.
    ET_PAYSLIP_B3-TIM03 = 0.
    ET_PAYSLIP_B3-TIM04 = 0.
    ET_PAYSLIP_B3-TIM05 = 0.
    ET_PAYSLIP_B3-TIM06 = 0.
    RETURN.
  ENDIF.

  " 사원그룹/하위그룹(IT0001) 조회
  CLEAR LS_0001.
  SELECT SINGLE PERSK PERSG
    FROM PA0001
    INTO CORRESPONDING FIELDS OF LS_0001
   WHERE PERNR EQ LT_P0100-PERNR
     AND ORGEH IN IR_ORGEH
     AND BEGDA <= LT_P0100-PAYDT
     AND ENDDA >= LT_P0100-PAYDT.

  " 당월 WPBP 라인 수 집계 (사원별로 분리된 LT_WPBP 대상)
  CLEAR LV_LINES.
  LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                    AND ENDDA(6) = LV_ENDDA_TIME(6).
    LV_LINES = LV_LINES + 1.
  ENDLOOP.

  " 직군별 월 기준 기본연장근무시간 산출
  " - 직영반장/직영일반(E0, E1): 36시간
  " - 다기능공(E3): 33시간
  " - 현장서무(E2): 18시간 (기본연장급이 있는 경우)
  " - 그 외: 34시간
  IF LS_0001-PERSG = '5' AND ( LS_0001-PERSK = 'E0' OR LS_0001-PERSK = 'E1' ).
    LV_BASE_OT = 36.
  ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E3'.
    LV_BASE_OT = 33.
  ELSEIF LS_0001-PERSG = '5' AND LS_0001-PERSK = 'E2' AND LT_P0100-P02 IS NOT INITIAL.
    LV_BASE_OT = 18.
  ELSE.
    LV_BASE_OT = 34.
  ENDIF.

  " === 1. 기본연장근무시간(TIM01) 계산 ===
  IF LT_P0100-P02 IS INITIAL AND LT_WPBP[] IS NOT INITIAL.
    CASE LV_LINES.
      WHEN 1.
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
          CLEAR LV_WDAYS.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          IF LV_WDAYS < 27.
            ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSE.
            ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT.
          ENDIF.
        ENDLOOP.
      WHEN OTHERS.
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
          ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT / LV_ENDDA_TIME+6(2) * LV_WDAYS.
        ELSE.
          ET_PAYSLIP_B3-TIM01 = ET_PAYSLIP_B3-TIM01_O = L_TIME = 0.
        ENDIF.
    ENDCASE.

  ELSEIF LT_P0100-P02 IS NOT INITIAL.
    CASE LV_LINES.
      WHEN 1.
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
          CLEAR LV_WDAYS.
          IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
            LV_WDAYS = 1.
          ELSE.
            LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
          ENDIF.

          IF LV_WDAYS < 27.
            ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT / LV_ENDDA_TIME+6(2) * LV_WDAYS.
          ELSE.
            ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT.
          ENDIF.
        ENDLOOP.
      WHEN OTHERS.
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
          ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT / LV_ENDDA_TIME+6(2) * LV_WDAYS.
        ELSE.
          ET_PAYSLIP_B3-TIM01 = L_TIME = LV_BASE_OT.
        ENDIF.
    ENDCASE.

  ELSEIF LT_P0100-P02 IS INITIAL.
    ET_PAYSLIP_B3-TIM01 = ET_PAYSLIP_B3-TIM01_O = L_TIME = 0.
  ENDIF.

  " === 2. 초과연장근무시간(TIM02) 및 야간근무시간(TIM03) 집계 ===
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

  IF ET_PAYSLIP_B3-TIM01 >= 34.
    " 대상 기간 내 3100(연장) ANZHL 일괄 합산
    LOOP AT LT_ZHRPT0001 ASSIGNING FIELD-SYMBOL(<FS_ZHRPT0001>) WHERE LGART = '3100'.
      LV_TIM02 = LV_TIM02 + <FS_ZHRPT0001>-ANZHL.
    ENDLOOP.

    IF LV_TIM02 > ET_PAYSLIP_B3-TIM01.
      ET_PAYSLIP_B3-TIM02 = L_TIME = LV_TIM02 - ET_PAYSLIP_B3-TIM01.
    ELSE.
      ET_PAYSLIP_B3-TIM02 = L_TIME = 0.
    ENDIF.

    " 3200(야간) 시간 집계
    IF IR_PAYDT-LOW(6) <= C_04.
      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                             AND ZYYMM EQ IR_PAYDT-LOW(6).
        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
      ENDLOOP.
      IF SY-SUBRC NE 0.
        ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
      ENDIF.
    ELSEIF IR_PAYDT-LOW(6) = C_05.
      LOOP AT LT_ZHRPT0001 WHERE LGART EQ '3200'
                             AND BEGDA >= '20250501'
                             AND BEGDA <= '20250520'.
        ET_PAYSLIP_B3-TIM03 = L_TIME = ET_PAYSLIP_B3-TIM03 + LT_ZHRPT0001-ANZHL.
      ENDLOOP.
      IF SY-SUBRC NE 0.
        ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
      ENDIF.
    ELSEIF IR_PAYDT-LOW(6) > C_05.
      UNASSIGN <FS_ZHRPT0001>.
      LOOP AT LT_ZHRPT0001 ASSIGNING <FS_ZHRPT0001> WHERE LGART = '3200'.
        LV_TIM03 = LV_TIM03 + <FS_ZHRPT0001>-ANZHL.
      ENDLOOP.
      IF SY-SUBRC NE 0.
        LV_TIM03 = 0.
      ENDIF.
      ET_PAYSLIP_B3-TIM03 = L_TIME = LV_TIM03.
    ENDIF.
  ELSE.
    ET_PAYSLIP_B3-TIM02 = ET_PAYSLIP_B3-TIM03 = L_TIME = 0.
  ENDIF.

  SHIFT: ET_PAYSLIP_B3-TIM02 LEFT DELETING LEADING SPACE,
         ET_PAYSLIP_B3-TIM03 LEFT DELETING LEADING SPACE.

  " === 3. 현장휴일근무(TIM04) 및 휴일연장근무(TIM05) ===
  IF LS_0001-PERSG EQ '5'
    AND ( LS_0001-PERSK EQ 'E0' OR LS_0001-PERSK = 'E1' ).
    LV_TIM04 = '32'.
    LV_TIM05 = '4'.
  ELSE.
    LV_TIM04 = '16'.
    LV_TIM05 = '2'.
  ENDIF.

  IF LT_P0100-P19 <> 0 AND LT_WPBP[] IS NOT INITIAL.
    CASE LV_LINES.
      WHEN 1.
        LOOP AT LT_WPBP WHERE BEGDA(6) = LV_BEGDA_TIME(6)
                          AND ENDDA(6) = LV_ENDDA_TIME(6).
          IF LT_WPBP-BEGDA+6(2) NE '01'.
            CLEAR LV_WDAYS.
            IF LT_WPBP-BEGDA = LT_WPBP-ENDDA.
              LV_WDAYS = 1.
            ELSE.
              LV_WDAYS = LT_WPBP-ENDDA - LT_WPBP-BEGDA.
            ENDIF.
            " [유지 2-2] TIM04, TIM05는 근무일수(LV_WDAYS)로 나누어 일할계산
            ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04 / LV_WDAYS.
            ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05 / LV_WDAYS.
          ELSE.
            ET_PAYSLIP_B3-TIM04 = L_TIME_M = LV_TIM04.
            ET_PAYSLIP_B3-TIM05 = L_TIME_M = LV_TIM05.
          ENDIF.
        ENDLOOP.
      WHEN OTHERS.
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
  ELSEIF LT_P0100-P19 <> 0 AND LT_WPBP[] IS INITIAL.
    ET_PAYSLIP_B3-TIM04   = L_TIME = LV_TIM04.
    ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
    ET_PAYSLIP_B3-TIM05   = L_TIME = LV_TIM05.
    ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
  ELSEIF LT_P0100-P19 EQ 0.
    ET_PAYSLIP_B3-TIM04   = L_TIME = 0.
    ET_PAYSLIP_B3-TIM04_O = L_TIME = 0.
    ET_PAYSLIP_B3-TIM05   = L_TIME = LT_P0100-T05.
    ET_PAYSLIP_B3-TIM05_O = L_TIME = 0.
  ENDIF.

  " === 4. 특근근무시간(TIM06) ===
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
                       PV_ZSTYPE
                       V_YNCA
                       V_YNCA_H.

  " [수정 3-1] LV_BET01 길이 오타(2 -> 20) 수정 (CX_SY_CONVERSION_NO_NUMBER 방지)
  DATA: LV_RESULT       TYPE ZCALC07,
        LV_P22(20)      TYPE C,
        LV_BET01(20)    TYPE C,
        LV_P22_2(20)    TYPE C,
        LV_BET_PREV(20) TYPE C,
        LV_COMP_AMT(20) TYPE C,

        LT_0015         TYPE TABLE OF PA0015 WITH HEADER LINE,
        LV_BETRG        TYPE CHAR15,
        LV_LGART        TYPE LGART,

        LV_DATE_NEW(8)  TYPE C,
        LV_COUNT        TYPE I,
        LV_LINES        TYPE I.

  CLEAR: LV_RESULT, LV_P22, LV_BET01, LV_P22_2, LV_BET_PREV, LV_COMP_AMT,
         LT_0015, LV_BETRG, LV_LGART, LV_LINES.
  REFRESH LT_0015.

  " 사원별 LT_WPBP 기준 당월 라인 수 확인
  LOOP AT LT_WPBP WHERE BEGDA <= LT_P0100-ZPAYDT
                    AND ENDDA >= LT_P0100-ZPAYDT.
    LV_LINES = LV_LINES + 1.
  ENDLOOP.

  " 통상시급(CALC00) 기본 출력
  WRITE LT_P0100-BET01 TO ET_PAYSLIP_B3-CALC00 CURRENCY 'KRW'.
  SHIFT ET_PAYSLIP_B3-CALC00 LEFT DELETING LEADING SPACE.
  REPLACE ALL OCCURRENCES OF ',' IN ET_PAYSLIP_B3-CALC00 WITH SPACE.

  " === 1. 연차수당 보상일수(CALC07) 및 신설 연차보상(CALC10_1) 계산 ===
  TRY.
      IF IV_YEAR >= '2025'.
        " 포맷팅된 문자열 대신 원본 DATS(YYYYMMDD) 사용
        LV_DATE_NEW = LT_P0100-PAYDT.

        " (A) 연차수당 보상일수(CALC07): 당월 연차수당(P22) / (전월 통상시급(BET01) * 8)
        CLEAR: V_YNCA, V_YNCA_H, LT_P0100_2, LT_P0100_2[].
        CONCATENATE LV_DATE_NEW+0(6) '01' INTO V_YNCA.

        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            DATE      = V_YNCA
            DAYS      = '00'
            MONTHS    = '01'
            SIGNUM    = '-'
            YEARS     = '00'
          IMPORTING
            CALC_DATE = V_YNCA_H.

        IF LV_LINES EQ 2.
          " 중도퇴사자: 전월 ~ 당월 급여결과 조회
          SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
            FROM ZHRT0100
           WHERE PERNR  = LT_P0100-PERNR
             AND FPPER BETWEEN V_YNCA_H+0(6) AND LV_DATE_NEW+0(6)
             AND ORGEH IN IR_ORGEH
             AND ZSTYPE = PV_ZSTYPE.

          LV_COUNT = LINES( LT_P0100_2 ).

          " 퇴직금 산정(OCRSN = '0007')인 경우 연차보상(3800), 일반의 경우 연차수당(3700)
          IF LT_P0100-OCRSN = '0007'.
            LV_LGART = '3800'.
          ELSE.
            LV_LGART = '3700'.
          ENDIF.

          SELECT * FROM PA0015
           WHERE PERNR = @LT_P0100-PERNR
             AND LGART = @LV_LGART
           ORDER BY BEGDA DESCENDING
            INTO CORRESPONDING FIELDS OF TABLE @LT_0015
            UP TO @LV_COUNT ROWS.
        ELSE.
          " 일반/중도입사자: 우선 전월 급여결과로 조회
          SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
            FROM ZHRT0100
           WHERE PERNR  = LT_P0100-PERNR
             AND FPPER  = V_YNCA_H+0(6)
             AND ORGEH IN IR_ORGEH
             AND ZSTYPE = PV_ZSTYPE.

          " 전월 급여결과가 없으면(신규입사자 등) 당월 급여결과 사용
          IF LT_P0100_2[] IS INITIAL.
            SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100_2
              FROM ZHRT0100
             WHERE PERNR  = LT_P0100-PERNR
               AND FPPER  = V_YNCA+0(6)
               AND ORGEH IN IR_ORGEH
               AND ZSTYPE = PV_ZSTYPE.
          ENDIF.
        ENDIF.

        SORT LT_P0100_2 ASCENDING BY PERNR PAYDT.
        SORT LT_0015    ASCENDING BY BEGDA.

        LOOP AT LT_P0100_2.
          WRITE LT_P0100_2-BET01 TO LV_BET01 CURRENCY 'KRW'.
          SHIFT LV_BET01 LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ',' IN LV_BET01 WITH SPACE.

          WRITE WA1-P22 TO LV_P22_2 CURRENCY 'KRW'.
          SHIFT LV_P22_2 LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ',' IN LV_P22_2 WITH SPACE.

          TRY.
              LV_RESULT = CONV INT4( LV_P22_2 ) / ( CONV INT4( LV_BET01 ) * 8 ).
            CATCH CX_SY_ZERODIVIDE.
              CLEAR LV_RESULT.
          ENDTRY.

          WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC07 DECIMALS 0.
          SHIFT ET_PAYSLIP_B3-CALC07 LEFT DELETING LEADING SPACE.
        ENDLOOP.
        IF ET_PAYSLIP_B3-CALC07 IS INITIAL.
          ET_PAYSLIP_B3-CALC07 = '0'.
        ENDIF.

        " (B) [추가 3-1] 신설 '연차보상'(CALC10_1, WA1-P24 매핑):
        "     * 연차보상금(P24) / (통상시급 * 8)
        "     * 3월 5일 지급분의 경우 해당 레코드의 통상시급(전년 기준 단가) 적용
        "     * 퇴직정산(OCRSN 0007) 등 기타 지급 시에도 P24 존재 시 정상 계산
        IF WA1-P24 IS NOT INITIAL AND WA1-P24 NE '0'.
          WRITE LT_P0100-BET01 TO LV_BET_PREV CURRENCY 'KRW'.
          SHIFT LV_BET_PREV LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ',' IN LV_BET_PREV WITH SPACE.

          WRITE WA1-P24 TO LV_COMP_AMT CURRENCY 'KRW'.
          SHIFT LV_COMP_AMT LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ',' IN LV_COMP_AMT WITH SPACE.

          TRY.
              CLEAR LV_RESULT.
              LV_RESULT = CONV INT4( LV_COMP_AMT ) / ( CONV INT4( LV_BET_PREV ) * 8 ).
            CATCH CX_SY_ZERODIVIDE.
              CLEAR LV_RESULT.
          ENDTRY.

          WRITE LV_RESULT TO ET_PAYSLIP_B3-CALC10_1 DECIMALS 0.
          SHIFT ET_PAYSLIP_B3-CALC10_1 LEFT DELETING LEADING SPACE.
        ELSE.
          ET_PAYSLIP_B3-CALC10_1 = '0'.
        ENDIF.
      ENDIF.
    CATCH CX_SY_CONVERSION_NO_NUMBER.
  ENDTRY.

  " === 2. 기타 수당 산출식 항목 ===
  " [수정 3-2] 석식대수당(CALC08): WA1-P22(연차수당) -> WA1-P21(석식대수당) 오타 수정
  IF WA1-P21 IS INITIAL OR WA1-P21 = '0'.
    ET_PAYSLIP_B3-CALC08 = 0.
  ELSE.
    ET_PAYSLIP_B3-CALC08 = LT_P0100-T06 / 1.
  ENDIF.

  " 자격증수당(CALC09)
  IF WA1-P08 IS INITIAL.
    ET_PAYSLIP_B3-CALC09 = 0.
  ELSE.
    ET_PAYSLIP_B3-CALC09 = WA1-P08.
  ENDIF.

  " 현장직무수당(CALC10)
  IF LT_P0100-ZZCLASS EQ '11' OR LT_P0100-ZZCLASS EQ '12'
  OR LT_P0100-ZZCLASS EQ '15' OR LT_P0100-ZZCLASS EQ '16'.
    ET_PAYSLIP_B3-CALC10 = WA1-P06.
  ELSE.
    ET_PAYSLIP_B3-CALC10 = 0.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10 LEFT DELETING LEADING SPACE.

  " 직책선임수당(CALC10_2)
  IF WA1-P09 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_2 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_2 = WA1-P09.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_2 LEFT DELETING LEADING SPACE.

  " AI 활용지원(CALC10_3)
  IF WA1-P32 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_3 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_3 = WA1-P32.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_3 LEFT DELETING LEADING SPACE.

  " 급지수당(CALC10_4)
  IF WA1-P07 IS INITIAL.
    ET_PAYSLIP_B3-CALC10_4 = '0'.
  ELSE.
    ET_PAYSLIP_B3-CALC10_4 = WA1-P07.
  ENDIF.
  SHIFT ET_PAYSLIP_B3-CALC10_4 LEFT DELETING LEADING SPACE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_RATE
*&---------------------------------------------------------------------*
FORM CALC_RATE TABLES LT_T7KRSR     STRUCTURE T7KRSR
                      ET_PAYSLIP_B3 STRUCTURE ZHRS0027_B3
                      LT_P0100      STRUCTURE ZHRT0100
                USING LS_T7KRMR     TYPE T7KRMR
                      LS_T7KRIR     TYPE T7KRIR.

  DATA: LV_BEGDA TYPE BEGDA.

  CLEAR LV_BEGDA.
  LV_BEGDA = |{ LT_P0100-PABRJ }{ LT_P0100-PABRP }01|.

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

