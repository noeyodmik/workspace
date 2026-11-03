FUNCTION ZHR0004_PRINT_PAYSLIP_PDF_B3AF.
*"--------------------------------------------------------------------
*"*"로컬인터페이스:
*"  IMPORTING
*"     VALUE(IV_ZSTYPE) TYPE  ZSTYPE
*"     VALUE(IV_ZSIGN) TYPE  XFELD OPTIONAL
*"     REFERENCE(IV_YEAR) TYPE  PABRJ
*"  EXPORTING
*"     VALUE(ET_DATA) TYPE  RCL_BAG_TLINE
*"     VALUE(E_PDF_DATA) TYPE  XSTRING
*"     VALUE(E_PDF_FSIZE) TYPE  I
*"  TABLES
*"      IR_PERNR STRUCTURE  SEL_PERNR
*"      IR_PAYDT STRUCTURE  SEL_DATE
*"      IR_ORGEH STRUCTURE  CCHRS_ORGEH_RANGE OPTIONAL
*"      ET_BIN_DATA STRUCTURE  ITCOO OPTIONAL
*"--------------------------------------------------------------------
************************************************************************
*                          Change History
*---------- ------------ ----------- -----------------------------------
* ChangeNo.  Changed on   Changed By  Description
*---------- ------------ ----------- -----------------------------------
* 0001       2026.09.04   SEPPIN      복사 후 신규 생성
************************************************************************
************************************************************************
* 선언부
************************************************************************
  DATA: LV_AF_FM_NAME   TYPE RS38L_FNAM,
        LS_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS,
        LS_DOCPARAMS    TYPE SFPDOCPARAMS,
        LS_FORMOUTPUT   TYPE FPFORMOUTPUT.

  DATA: LO_PDF_MERGER  TYPE REF TO CL_RSPO_PDF_MERGE,
        LV_MERGE_RC    TYPE I,
        LS_PAYSLIP     TYPE ZHRS0027_B3,
        LT_PAYSLIP_ONE TYPE TABLE OF ZHRS0027_B3.
*----------------------------------------------------------------------
*--  급여명세서
*----------------------------------------------------------------------
  DATA: LT_PAYSLIP_B3      TYPE TABLE OF ZHRS0027_B3 WITH HEADER LINE.
************************************************************************
************************************************************************
* Logic
************************************************************************
  CLEAR: ET_DATA[], ET_BIN_DATA[], E_PDF_DATA, E_PDF_FSIZE.
*----------------------------------------------------------------------
*--  급여 결과 조회
*----------------------------------------------------------------------

* 260828 지급항목 개수 조회
* 지급 항목이 10개 초과인 경우 test 양식으로 출력
  DATA: LV_PAYCNT TYPE I.
  CLEAR: LV_PAYCNT.
  PERFORM GET_PAYSLIP_DATA_B3 TABLES IR_PERNR
                                     IR_PAYDT
                                     IR_ORGEH
                                     LT_PAYSLIP_B3
                               USING IV_ZSTYPE
                                     IV_ZSIGN
                                     IV_YEAR
                            CHANGING LV_PAYCNT.

  CHECK LT_PAYSLIP_B3[] IS NOT INITIAL.
*----------------------------------------------------------------------*
*-- Adobe Form PDF 생성
*----------------------------------------------------------------------*
  CLEAR: LS_OUTPUTPARAMS,
         LS_DOCPARAMS,
         LS_FORMOUTPUT,
         LV_AF_FM_NAME.

  LS_OUTPUTPARAMS-NODIALOG = 'X'.
  LS_OUTPUTPARAMS-GETPDF   = 'X'.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = LS_OUTPUTPARAMS
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.

  IF SY-SUBRC <> 0.
    RETURN.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = 'ZHR_F_PAYSLIP'
    IMPORTING
      E_FUNCNAME = LV_AF_FM_NAME.

  LS_DOCPARAMS-LANGU = SY-LANGU.

*----------------------------------------------------------------------*
*-- 사원별 Adobe Form 생성 후 PDF 병합
*----------------------------------------------------------------------*

  CREATE OBJECT LO_PDF_MERGER.

  LOOP AT LT_PAYSLIP_B3 INTO LS_PAYSLIP.

    CLEAR: LS_FORMOUTPUT.
    CLEAR: LT_PAYSLIP_ONE[].

*   Adobe Form에는 사원 1명 데이터만 전달
    APPEND LS_PAYSLIP TO LT_PAYSLIP_ONE.

    CALL FUNCTION LV_AF_FM_NAME
      EXPORTING
        /1BCDWB/DOCPARAMS  = LS_DOCPARAMS
        STAB               = LT_PAYSLIP_ONE
      IMPORTING
        /1BCDWB/FORMOUTPUT = LS_FORMOUTPUT
      EXCEPTIONS
        USAGE_ERROR        = 1
        SYSTEM_ERROR       = 2
        INTERNAL_ERROR     = 3
        OTHERS             = 4.

    IF SY-SUBRC <> 0.
      CALL FUNCTION 'FP_JOB_CLOSE'.
      RETURN.
    ENDIF.

*   사원 1명분 PDF를 병합 대상에 추가
    IF LS_FORMOUTPUT-PDF IS NOT INITIAL.
      LO_PDF_MERGER->ADD_DOCUMENT( LS_FORMOUTPUT-PDF ).
    ENDIF.

  ENDLOOP.

* Adobe Form Job Close
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.

  IF SY-SUBRC <> 0.
    RETURN.
  ENDIF.

* 사원별 PDF를 하나의 PDF로 병합
  LO_PDF_MERGER->MERGE_DOCUMENTS(
    IMPORTING
      MERGED_DOCUMENT = E_PDF_DATA
      RC              = LV_MERGE_RC ).

  E_PDF_FSIZE = XSTRLEN( E_PDF_DATA ).

************************************************************************
ENDFUNCTION.