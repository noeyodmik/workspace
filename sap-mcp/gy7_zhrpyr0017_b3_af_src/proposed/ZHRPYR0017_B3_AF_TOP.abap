*&---------------------------------------------------------------------*
*&  Include           ZHRPYR0017_B3_AF_TOP
*&---------------------------------------------------------------------*
TABLES: SSCRFIELDS,
        ICON,
        PA0001,
        ZHRT0100.                                "급여 결과 실적 테이블

DATA: MESSAGE(100)     TYPE C,                   "상태바 메시지 텍스트
      OK_CODE          TYPE SY-UCOMM,
      PDF_FSIZE        TYPE I,
      GV_PDF_DATA      TYPE XSTRING,
      GP_CONTAINER     TYPE SCRFNAME VALUE 'HTML_CONTAINER',
      G_HTML_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      G_HTML_CONTROL   TYPE REF TO CL_GUI_HTML_VIEWER,
      P_REPID          TYPE SY-REPID,
      P_DYNNR          TYPE SY-DYNNR,
      URL(255)         TYPE C.

