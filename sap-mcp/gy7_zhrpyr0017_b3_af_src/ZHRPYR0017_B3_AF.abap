*&---------------------------------------------------------------------*
*& Report  ZHRPYR0017
*&
*&---------------------------------------------------------------------*
*& 레포트명     : ZHRPYR0017
*& 작성인       : 이황준
*& 소속부서     :
*& 작성일자     : 2024-10-21
*& 변경인       :
*& 최종변경일자 :
*& 변경내역     :
*& 용도         : [급여] 급여명세서 출력
*&---------------------------------------------------------------------*
REPORT ZHRPYR0017_B3_AF   MESSAGE-ID ZHR01.

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
      CALL TRANSACTION 'ZHRPYR0040'.   " AND SKIP FIRST SCREEN.
  ENDCASE.

***********************************************************************
START-OF-SELECTION.
***********************************************************************
  CLEAR: GV_PDF_DATA, PDF_FSIZE.

*ADOBE FORM 출력용 펑션
  CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3AF'
    EXPORTING
      IV_ZSTYPE   = P_ZSTYPE
      IV_YEAR     = '2025'
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