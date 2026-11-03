*&---------------------------------------------------------------------*
*&  Include           ZHRPYR0017_B3_AF_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
FORM SET_INIT .

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME                  = 'ICON_OPERATOR'
      TEXT                  = '명세서 결과 수정'
      INFO                  = 'info'
      ADD_STDINF            = ' '
    IMPORTING
      RESULT                = SSCRFIELDS-FUNCTXT_01
    EXCEPTIONS
      ICON_NOT_FOUND        = 1
      OUTPUTFIELD_TOO_SHORT = 2
      OTHERS                = 3.

ENDFORM.                    " SET_INIT
*&---------------------------------------------------------------------*
*&      Form  SET_PDF_OUTPUT
*&---------------------------------------------------------------------*
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
FORM PROGRESS_INDICATOR USING P_PERNR P_ENAME.
  CONCATENATE P_PERNR '(' P_ENAME ')' '진행중' INTO MESSAGE
               SEPARATED BY SPACE.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      TEXT = MESSAGE.
ENDFORM.                    " PROGRESS_INDICATOR
*&---------------------------------------------------------------------*
*&      Form  GET_OBJID
*&---------------------------------------------------------------------*
FORM GET_OBJID USING $P_OBJID LIKE ZHRT0100-ORGEH.

  DATA: L_OBJ LIKE OBJEC.

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

