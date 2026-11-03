*&---------------------------------------------------------------------*
*&  Include           ZHRPYR0017_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_init .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = 'ICON_OPERATOR'
      text                  = '명세서 결과 수정'
      info                  = 'info'
      add_stdinf            = ' '
    IMPORTING
      result                = sscrfields-functxt_01
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.

ENDFORM.                    " SET_INIT
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA.

  DATA: LT_P0100 TYPE TABLE OF ZHRT0100 WITH HEADER LINE.
  DATA: LV_NUM_1 LIKE ZHRT0100-D09.

  CLEAR: WA1, WAS, WA2, WA1_1, WA2_2, STAB, STAB[].


  CLEAR:  LT_P0100[].
  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_P0100
    FROM  ZHRT0100
    WHERE PERNR IN S_PERNR
      AND PAYDT IN S_PER
      AND ORGEH IN P_ORGEH
      AND ZSTYPE = P_ZSTYPE.

  SORT LT_P0100 ASCENDING BY PERNR PAYDT.

  LOOP AT LT_P0100.

    CLEAR: WA1,WA2,WAS.

    SELECT SINGLE ENAME INTO WAS-ENAME
      FROM PA0001
     WHERE PERNR  = LT_P0100-PERNR
       AND BEGDA <= LT_P0100-PAYDT
       AND ENDDA >= LT_P0100-PAYDT.

    PERFORM PROGRESS_INDICATOR USING LT_P0100-PERNR WAS-ENAME.

    "사원번호
    WRITE LT_P0100-PERNR TO WAS-PERNR NO-ZERO.

    "부서명
    CALL FUNCTION 'ZHR0002_GET_ORGTX'
      EXPORTING
        IM_ORGEH = LT_P0100-ORGEH
        IM_DATE  = LT_P0100-PAYDT
        LANGU    = '3'
      IMPORTING
        EX_ORGTX = WAS-STEXT.
***********직급 또는 직책 필요에 따라 주석
*    MOVE LT_P0100-ZZPSGRPTX TO WAS-ZJ2T.       "직책명
    MOVE LT_P0100-ZZCALTLTX TO WAS-ZJ2T.       "직급명
***********
    "타이틀
    IF LT_P0100-OCRSN IS INITIAL.
      CONCATENATE LT_P0100-PABRJ '년'
                  LT_P0100-PABRP '월 급여 명세서'
             INTO WAS-TITLE SEPARATED BY SPACE.
    ELSEIF LT_P0100-OCRSN = '0002' OR
           LT_P0100-OCRSN = '0003'.
      CONCATENATE LT_P0100-PABRJ '년'
                  LT_P0100-PABRP '월 상여 명세서'
             INTO WAS-TITLE SEPARATED BY SPACE.
    ELSEIF LT_P0100-OCRSN = '0004'.
      CONCATENATE LT_P0100-PABRJ '년'
                  LT_P0100-PABRP '월 연차비 명세서'
             INTO WAS-TITLE SEPARATED BY SPACE.
    ENDIF.

*&---------------------------------------------------------------------*
*&  저장된 임금항목별 금액을 출력을 위한 구조로 전송
*&---------------------------------------------------------------------*
    "지급총액
    IF LT_P0100-P_TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-P_TOTAL TO WAS-P999 CURRENCY 'KRW'.
    ENDIF.

    "공제총액
    IF LT_P0100-D_TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-D_TOTAL TO WAS-D99 CURRENCY 'KRW'.
    ENDIF.

    "실지급액
    IF LT_P0100-TOTAL IS  NOT INITIAL.
      WRITE LT_P0100-TOTAL TO WAS-TOTAL CURRENCY 'KRW'.
    ENDIF.

    "기본시급
    IF  LT_P0100-BET02 IS NOT INITIAL.
      WRITE LT_P0100-BET02 TO WAS-BET01 CURRENCY 'KRW'.
    ENDIF.

    "통상시급
    IF  LT_P0100-BET01 IS NOT INITIAL.
      WRITE LT_P0100-BET01 TO WAS-BET02 CURRENCY 'KRW'.
    ENDIF.

    MOVE-CORRESPONDING WAS TO STAB.


    WRITE LT_P0100-P01 TO WA1-P01 CURRENCY 'KRW'.
    WA1-LGTXT01 = '기본급'.
    CONDENSE WA1-P01.

    WRITE LT_P0100-P02 TO WA1-P02 CURRENCY 'KRW'.
    WA1-LGTXT02 = '고정연장수당'.
    CONDENSE WA1-P02.


    WRITE LT_P0100-P03 TO WA1-P03 CURRENCY 'KRW'.
    WA1-LGTXT03 = '직책수당'.
    CONDENSE WA1-P03.


    WRITE LT_P0100-P04 TO WA1-P04 CURRENCY 'KRW'.
    WA1-LGTXT04 = '연구개발비'.
    CONDENSE WA1-P04.


    WRITE LT_P0100-P05 TO WA1-P05 CURRENCY 'KRW'.
    WA1-LGTXT05 = '차량유지비'.
    CONDENSE WA1-P05.


    WRITE LT_P0100-P06 TO WA1-P06 CURRENCY 'KRW'.
    WA1-LGTXT06 = '식대수당(연봉포함)'.
    CONDENSE WA1-P06.


    WRITE LT_P0100-P07 TO WA1-P07 CURRENCY 'KRW'.
    WA1-LGTXT07 = '조정수당'.
    CONDENSE WA1-P07.


    WRITE LT_P0100-P08 TO WA1-P08 CURRENCY 'KRW'.
    WA1-LGTXT08 = '보육수당'.
*    WA1-T08 = LT_P0100-T08.
    CONDENSE WA1-P08.


    WRITE LT_P0100-P09 TO WA1-P09 CURRENCY 'KRW'.
    WA1-LGTXT09 = '인센티브'.
    CONDENSE WA1-P09.


    WRITE LT_P0100-P10 TO WA1-P10 CURRENCY 'KRW'.
    WA1-LGTXT10 = '야놀자포인트'.
    CONDENSE WA1-P10.


    WRITE LT_P0100-P11 TO WA1-P11 CURRENCY 'KRW'.
    WA1-LGTXT11 = '기타수당'.
    CONDENSE WA1-P11.


    WRITE LT_P0100-P12 TO WA1-P12 CURRENCY 'KRW'.
    WA1-LGTXT12 = '전월미지급분'.
    CONDENSE WA1-P12.


    WRITE LT_P0100-P13 TO WA1-P13 CURRENCY 'KRW'.
    WA1-LGTXT13 = '기지급금'.
    CONDENSE WA1-P13.


    WRITE LT_P0100-P14 TO WA1-P14 CURRENCY 'KRW'.
    WA1-LGTXT14 = '통신비'.
    CONDENSE WA1-P14.


    WRITE LT_P0100-P15 TO WA1-P15 CURRENCY 'KRW'.
    WA1-LGTXT15 = '식대수당'.
    CONDENSE WA1-P15.


    WRITE LT_P0100-P16 TO WA1-P16 CURRENCY 'KRW'.
    WA1-LGTXT16 = '연장수당'.
    CONDENSE WA1-P16.


    WRITE LT_P0100-P17 TO WA1-P17 CURRENCY 'KRW'.
    WA1-LGTXT17 = '생일축하금'.
    CONDENSE WA1-P17.


    WRITE LT_P0100-P18 TO WA1-P18 CURRENCY 'KRW'.
    WA1-LGTXT18 = '야간근무수당'.
*    WA1-T18 = LT_P0100-T02.
    CONDENSE WA1-P18.


    WRITE LT_P0100-P19 TO WA1-P19 CURRENCY 'KRW'.
    WA1-LGTXT19 = '휴일근무수당'.
*    WA1-T19 = LT_P0100-T03.
    CONDENSE WA1-P19.


    WRITE LT_P0100-P20 TO WA1-P20 CURRENCY 'KRW'.
    WA1-LGTXT20 = '휴일연장수당'.
*    WA1-T20 = LT_P0100-T05.
    CONDENSE WA1-P20.


    WRITE LT_P0100-P21 TO WA1-P21 CURRENCY 'KRW'.
    WA1-LGTXT21 = '연차수당'.
    CONDENSE WA1-P21.


    WRITE LT_P0100-P22 TO WA1-P22 CURRENCY 'KRW'.
    WA1-LGTXT22 = '상여금'.
*    WA1-T22 = LT_P0100-T04.
    CONDENSE WA1-P22.


    WRITE LT_P0100-P23 TO WA1-P23 CURRENCY 'KRW'.
    WA1-LGTXT23 = '사이닝보너스'.
*    WA1-T23 = LT_P0100-T06.
    CONDENSE WA1-P23.


    WRITE LT_P0100-P24 TO WA1-P24 CURRENCY 'KRW'.
    WA1-LGTXT24 = '스톡옵션'.
    CONDENSE WA1-P24.


    WRITE LT_P0100-P25 TO WA1-P25 CURRENCY 'KRW'.
    WA1-LGTXT25 = '인정상여'.
    CONDENSE WA1-P25.

    WRITE LT_P0100-P26 TO WA1-P26 CURRENCY 'KRW'.
    WA1-LGTXT26 = '사내추천'.
    CONDENSE WA1-P26.


    WRITE LT_P0100-P27 TO WA1-P27 CURRENCY 'KRW'.
    WA1-LGTXT27 = '실비보험'.
    CONDENSE WA1-P27.

    WRITE LT_P0100-P28 TO WA1-P28 CURRENCY 'KRW'.
    WA1-LGTXT28 = '해외수당'.
    CONDENSE WA1-P28.


****공제액명세  부분


    WRITE LT_P0100-D01 TO WA2-D01 CURRENCY 'KRW'.
    WA2-LGTXT_01 = '소득세'.
    CONDENSE WA2-D01.

    WRITE LT_P0100-D02 TO WA2-D02 CURRENCY 'KRW'.
    WA2-LGTXT_02 = '주민세'.
    CONDENSE WA2-D02.


    WRITE LT_P0100-D03 TO WA2-D03 CURRENCY 'KRW'.
    WA2-LGTXT_03 = '국민연금'.
    CONDENSE WA2-D03.

    WRITE LT_P0100-D04 TO WA2-D04 CURRENCY 'KRW'.
    WA2-LGTXT_04 = '건강보험'.
    CONDENSE WA2-D04.

    WRITE LT_P0100-D05 TO WA2-D05 CURRENCY 'KRW'.
    WA2-LGTXT_05 = '장기요양'.
    CONDENSE WA2-D05.

    WRITE LT_P0100-D06 TO WA2-D06 CURRENCY 'KRW'.
    WA2-LGTXT_06 = '고용보험'.
    CONDENSE WA2-D06.

    WRITE LT_P0100-D04_1 TO WA2-D07 CURRENCY 'KRW'.
    WA2-LGTXT_07 = '건강보험정산'.
    CONDENSE WA2-D07.

    WRITE LT_P0100-D05_1 TO WA2-D08 CURRENCY 'KRW'.
    WA2-LGTXT_08 = '장기요양정산'.
    CONDENSE WA2-D08.

    WRITE LT_P0100-D07 TO WA2-D09 CURRENCY 'KRW'.
    WA2-LGTXT_09 = '기타공제'.
    CONDENSE WA2-D09.

    WRITE LT_P0100-D08 TO WA2-D10 CURRENCY 'KRW'.
    WA2-LGTXT_10 = '기부금'.
    CONDENSE WA2-D10.


    WRITE LT_P0100-D09 TO WA2-D11 CURRENCY 'KRW'.
    WA2-LGTXT_11 = '학자금대출상환'.
    CONDENSE WA2-D11.

    WRITE LT_P0100-D10 TO WA2-D12 CURRENCY 'KRW'.
    WA2-LGTXT_12 = '동호회비'.
    CONDENSE WA2-D12.

    WRITE LT_P0100-D11 TO WA2-D13 CURRENCY 'KRW'.
    WA2-LGTXT_13 = '식대공제'.
    CONDENSE WA2-D13.

    WRITE LT_P0100-D12 TO WA2-D14 CURRENCY 'KRW'.
    WA2-LGTXT_14 = '건강환급이자'.
    CONDENSE WA2-D14.


    WRITE LT_P0100-D01_1 TO WA2-D15 CURRENCY 'KRW'.
    WA2-LGTXT_15 = '정산소득세'.
    CONDENSE WA2-D15.

    WRITE LT_P0100-D02_1 TO WA2-D16 CURRENCY 'KRW'.
    WA2-LGTXT_16 = '정산주민세'.
    CONDENSE WA2-D16.

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

      IF <FS_BETXX> <> '0'.
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
        MOVE <FS_ANZXX> TO <FS_ANZXX_2>.

      ENDIF.

    ENDDO.


    MOVE-CORRESPONDING WA1_1 TO STAB.


*&---------------------------------------------------------------------*
*&  공제항목 가공 (금액이 있는 경우에만 출력)
*&---------------------------------------------------------------------*
    CLEAR: LV_NUM, LV_NUM_2, WA2_2.
    DO 27 TIMES.

      LV_NUM = LV_NUM + 1.

      "임금유형 텍스트
      CLEAR LV_TEXT.
      CONCATENATE 'WA2-LGTXT_' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_LGTXX>.

      "금액
      CLEAR LV_TEXT.
      CONCATENATE 'WA2-D' LV_NUM INTO LV_TEXT.
      ASSIGN (LV_TEXT) TO <FS_BETXX>.


      IF <FS_BETXX> <> '0'.
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

      ENDIF.


    ENDDO.

    MOVE-CORRESPONDING WA2_2 TO STAB.
    APPEND STAB.
    CLEAR STAB.

  ENDLOOP.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_PDF_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM SET_PDF_OUTPUT .

  DATA: LT_PDF_BINARY TYPE SOLIX_TAB.

  CLEAR LT_PDF_BINARY[].

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      BUFFER     = GV_PDF_DATA
    TABLES
      BINARY_TAB = LT_PDF_BINARY.

* HTML Viewer 생성
  IF G_HTML_CONTAINER IS INITIAL.

    P_REPID = SY-REPID.
    P_DYNNR = SY-DYNNR.

    CREATE OBJECT G_HTML_CONTAINER
      EXPORTING
        CONTAINER_NAME = GP_CONTAINER.

    CREATE OBJECT G_HTML_CONTROL
      EXPORTING
        PARENT = G_HTML_CONTAINER.

  ENDIF.

* PDF 데이터 Viewer에 Load
  CALL METHOD G_HTML_CONTROL->LOAD_DATA
    EXPORTING
      SIZE         = PDF_FSIZE
      TYPE         = 'application'
      SUBTYPE      = 'pdf'
    IMPORTING
      ASSIGNED_URL = URL
    CHANGING
      DATA_TABLE   = LT_PDF_BINARY
    EXCEPTIONS
      OTHERS       = 1.

  IF SY-SUBRC <> 0.
    RETURN.
  ENDIF.

* Viewer 출력
  CALL METHOD CL_GUI_CFW=>FLUSH.

  CALL METHOD G_HTML_CONTROL->SHOW_DATA
    EXPORTING
      URL      = URL
      IN_PLACE = 'X'
    EXCEPTIONS
      OTHERS   = 0.

ENDFORM.                  "SET_PDF_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  PROGRESS_INDICATOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROGRESS_INDICATOR USING P_PERNR P_ENAME.
  CONCATENATE P_PERNR '(' P_ENAME ')' '진행중' INTO MESSAGE
               SEPARATED    BY       SPACE .

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      TEXT = MESSAGE.
ENDFORM.                    " PROGRESS_INDICATOR
*&---------------------------------------------------------------------*
*&      Form  GET_OBJID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_OBJID  text
*----------------------------------------------------------------------*
FORM GET_OBJID  USING    $P_OBJID LIKE ZHRT0100-ORGEH.

  DATA : L_OBJ LIKE OBJEC.

  CALL FUNCTION 'RH_OBJID_REQUEST'
    EXPORTING
      PLVAR       = '01'
      OTYPE       = 'O'
      SEARK       = '*'
      SEARK_BEGDA = SY-DATUM
      SEARK_ENDDA = SY-DATUM
      ORGBEG      = SY-DATUM
      ORGEND      = SY-DATUM
    IMPORTING
      SEL_OBJECT  = L_OBJ.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    $P_OBJID = L_OBJ-REALO.
  ENDIF.
ENDFORM.                    " GET_OBJID