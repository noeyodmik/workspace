*&---------------------------------------------------------------------*
*&  Include           ZHRPYR0017_TOP
*&---------------------------------------------------------------------*
TABLES:  sscrfields,
         icon,
         PA0001,
         ZHRT0100.                                "급여 결과 실적 테이블

DATA  :  MESSAGE(100)     TYPE    C.              "상태바 메시지 텍스트

*** 스마트 폼용 DATA
DATA:  OK_CODE TYPE SY-UCOMM.
*DATA:  SMART_FORMNAME     TYPE TDSFNAME VALUE 'ZHR_PAY001_B2'.
DATA:  SMART_FORMNAME     TYPE TDSFNAME VALUE 'ZHR_PAY001_B3'.
DATA:  FUNC_MOD_NAME      TYPE RS38L_FNAM.
DATA:  CONTROL_PARAMETERS TYPE SSFCTRLOP,
       ARCHIVE_PARAMETERS TYPE ARC_PARAMS,
       JOB_OUTPUT_INFO    TYPE SSFCRESCL,
       OUTPUT_OPTIONS     TYPE SSFCOMPOP.

DATA   :   OTF_TAB        LIKE     ITCOO   OCCURS   0
                          WITH    HEADER   LINE.

DATA   :   PDF_FSIZE      TYPE     I.
DATA   :   PDF_TABLE      TYPE     RCL_BAG_TLINE.
DATA   :   GV_PDF_DATA    TYPE XSTRING.

DATA   :   BEGIN  OF   PDF_LINE_TAB    OCCURS    0,
           LINE(134)      TYPE     C,
           END    OF   PDF_LINE_TAB.

DATA: GP_CONTAINER        TYPE SCRFNAME VALUE 'HTML_CONTAINER',
      G_HTML_CONTAINER    TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      G_HTML_CONTROL      TYPE REF TO CL_GUI_HTML_VIEWER.
DATA:  P_REPID            TYPE SY-REPID,
       P_DYNNR            TYPE SY-DYNNR,
       URL(255),
       EXTNSION           TYPE I.

DATA: L_CLINE(134)        TYPE C.
FIELD-SYMBOLS: <L_XLINE>  TYPE X.

*--도메인텍스트 변수
DATA:  P_VALUE            LIKE DD07V-DOMVALUE_L,
       P_DOMAIN           LIKE DD07V-DOMNAME,
       P_TEXT             LIKE DD07V-DDTEXT.
DATA:  WAS                TYPE ZHRS0023.           "해더
DATA:  ITAB3              TYPE TABLE OF ZHRS0023.

DATA : ITAB1              TYPE TABLE OF ZHRS0021,
       WA1                TYPE ZHRS0021,
       WA1_1              TYPE ZHRS0021.

DATA : ITAB2              TYPE TABLE OF ZHRS0022,
       WA2                TYPE ZHRS0022,
       WA2_2              TYPE ZHRS0022.

DATA: BEGIN OF STAB OCCURS 0.
         INCLUDE STRUCTURE ZHRS0023.
         INCLUDE STRUCTURE ZHRS0021.
         INCLUDE STRUCTURE ZHRS0022.
DATA: END OF STAB.

DATA : LV_TEXT(30),
       LV_ORGEH(8)        TYPE N,
       LV_TRFGR(8).
DATA:  LV_NUM(2)          TYPE N,
       LV_NUM_2(2)        TYPE N.


DATA: S_MESSAGE           TYPE STRING.
DATA: LV_PAR1             TYPE CHAR40.
DATA: LV_PAR2             TYPE CHAR40.
DATA: LV_PERNR            TYPE PA0001-PERNR.