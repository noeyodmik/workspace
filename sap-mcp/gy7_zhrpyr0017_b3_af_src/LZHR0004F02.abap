*----------------------------------------------------------------------*
***INCLUDE LZHR0004F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0062   text
*      -->P_0063   text
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.
ENDFORM.                    "BDC_FIELD
*&---------------------------------------------------------------------*
*&      Form  BDC_INSERT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BDCDATA  text
*      -->P_PROC_TYP  text
*      -->P_GEN_MODE  text
*----------------------------------------------------------------------*
FORM BDC_INSERT TABLES P_BDCDATA
                USING  CTU_PARAMS LIKE CTU_PARAMS
                       P_RETURN STRUCTURE BAPIRETURN1.
*  CASE P_PROC_TYP.
*    WHEN 1.
*      CALL FUNCTION 'BDC_INSERT'
*        EXPORTING
*          TCODE     = 'PA30'
*        TABLES
*          DYNPROTAB = P_BDCDATA.
*
*    WHEN 2.

      CALL TRANSACTION 'PA30' USING P_BDCDATA
                              OPTIONS FROM CTU_PARAMS
                              MESSAGES INTO MESSTAB.

      LOOP AT MESSTAB.
        IF MESSTAB-MSGTYP = 'E'.
          SELECT SINGLE * FROM T100 WHERE   SPRSL = MESSTAB-MSGSPRA
                                      AND   ARBGB = MESSTAB-MSGID
                                      AND   MSGNR = MESSTAB-MSGNR.
          L_MSTRING = T100-TEXT.
          IF L_MSTRING CS '&1'.
            REPLACE '&1' WITH MESSTAB-MSGV1 INTO L_MSTRING.
            REPLACE '&2' WITH MESSTAB-MSGV2 INTO L_MSTRING.
            REPLACE '&3' WITH MESSTAB-MSGV3 INTO L_MSTRING.
            REPLACE '&4' WITH MESSTAB-MSGV4 INTO L_MSTRING.
          ELSE.
            REPLACE '&' WITH MESSTAB-MSGV1 INTO L_MSTRING.
            REPLACE '&' WITH MESSTAB-MSGV2 INTO L_MSTRING.
            REPLACE '&' WITH MESSTAB-MSGV3 INTO L_MSTRING.
            REPLACE '&' WITH MESSTAB-MSGV4 INTO L_MSTRING.
          ENDIF.
          CONDENSE L_MSTRING.
          EXIT.
        ELSEIF MESSTAB-MSGTYP = 'S'.
          IF MESSTAB-MSGID = 'PG' AND MESSTAB-MSGNR = '001'.
            MESSTAB-MSGTYP = 'E'.
            P_RETURN-TYPE = MESSTAB-MSGTYP.
            P_RETURN-MESSAGE = '사원번호를 아직 지정하지 않았습니다.'.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.  "   LOOP AT MESSTAB 의 끝


      IF MESSTAB-MSGTYP   = 'E'.
         P_RETURN-TYPE    = 'E'.
         P_RETURN-MESSAGE = L_MSTRING.
      ELSE.
         P_RETURN-TYPE    = 'S'.
         P_RETURN-MESSAGE = '처리성공'.
      ENDIF.

      CLEAR MESSTAB. REFRESH MESSTAB.

*    WHEN OTHERS.
*  ENDCASE.
ENDFORM.                    "BDC_INSERT