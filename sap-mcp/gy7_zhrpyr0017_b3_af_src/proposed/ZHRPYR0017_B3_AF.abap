*&---------------------------------------------------------------------*
*& Report  ZHRPYR0017_B3_AF
*&---------------------------------------------------------------------*
*& 레포트명     : ZHRPYR0017_B3_AF
*& 작성인       : 이황준
*& 작성일자     : 2024-10-21
*& 용도         : [급여] 급여명세서 출력 (Adobe Form)
*&---------------------------------------------------------------------*
REPORT ZHRPYR0017_B3_AF MESSAGE-ID ZHR01.

INCLUDE ZHRPYR0017_B3_AF_TOP.
INCLUDE ZHRPYR0017_B3_AF_SEL.
INCLUDE ZHRPYR0017_B3_AF_O01.
INCLUDE ZHRPYR0017_B3_AF_I01.
INCLUDE ZHRPYR0017_B3_AF_F01.

***********************************************************************
INITIALIZATION.
***********************************************************************
  PERFORM SET_INIT.
  P_ZSTYPE = '100'.

***********************************************************************
AT SELECTION-SCREEN.
***********************************************************************
  CASE SSCRFIELDS-UCOMM.
    WHEN 'FC01'.
      CALL TRANSACTION 'ZHRPYR0040'.
  ENDCASE.

***********************************************************************
START-OF-SELECTION.
***********************************************************************
  DATA: LV_YEAR TYPE CHAR04.

  CLEAR: GV_PDF_DATA, PDF_FSIZE, LV_YEAR.

  " [개선 4-3] 지급일(S_PER) 선택값 기준 연도 동적 전달 (미입력 시 당해연도)
  IF S_PER-LOW IS NOT INITIAL.
    LV_YEAR = S_PER-LOW+0(4).
  ELSE.
    LV_YEAR = SY-DATUM+0(4).
  ENDIF.

  " Adobe Form 출력용 펑션 호출
  CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3AF'
    EXPORTING
      IV_ZSTYPE   = P_ZSTYPE
      IV_YEAR     = LV_YEAR
    IMPORTING
      E_PDF_DATA  = GV_PDF_DATA
      E_PDF_FSIZE = PDF_FSIZE
    TABLES
      IR_PERNR    = S_PERNR
      IR_PAYDT    = S_PER
      IR_ORGEH    = P_ORGEH.

  IF GV_PDF_DATA IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE S031 DISPLAY LIKE 'E'.
  ENDIF.

