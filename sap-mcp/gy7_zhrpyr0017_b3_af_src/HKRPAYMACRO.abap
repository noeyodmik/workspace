********************************************************************
* HKRPAYMACRO Macro definitions for payroll cluster KR South Korea
********************************************************************
* THIS INCLUDE WAS GENERATED
* BY REPORT:___H99UMACROGENERATOR
* USER:________MOOCKW
* ON:__________29.03.2021
* DO NOT CHANGE MANUALLY!!!!!!!!!!!!!!!!!!
********************************************************************
 "**********************************************************************
 " import definition for cluster KR South Korea
 "**********************************************************************
 define RP-IMP-C2-KR.
   if cl_hrpclx_buffer=>is_switched_on( ) = abap_true.
     PERFORM pclx_macro_execute USING 'RP-IMP-C2-KR'
                                      rx-key
                                      abap_true
                                      space
                             CHANGING rp-imp-KR-subrc
                                      KR-VERSION-number.
   else.
   clear:
     OKR-VERSION,                                                    "OBJECTS_FOR_CLEAR
     VERSC,
     WPBP, WPBP[],
     ABC, ABC[],
     RT, RT[],
     CRT, CRT[],
     BT, BT[],
     C0, C0[],
     VCP, VCP[],
     ALP, ALP[],
     DFT, DFT[],
     GRT, GRT[],
     LS, LS[],
     STATUS,
     ARRRS, ARRRS[],
     DDNTK, DDNTK[],
     ACCR, ACCR[],
     AB, AB[],
     FUND, FUND[],
     AVERAGE, AVERAGE[],
     MODIF, MODIF[],
     LIFL, LIFL[],
     LIDI, LIDI[],
     C1, C1[],
     V0, V0[],
     BENTAB, BENTAB[],
     CODIST, CODIST[],
     KRSI, KRSI[],
     KRTAX, KRTAX[],
     KRSP1, KRSP1[],
     KRSP2, KRSP2[],
     BEN_BPS, BEN_BPS[],
     KRRP, KRRP[].
   import
     KR-VERSION TO OKR-VERSION                                       "OBJECTS_FOR_IMPORT
     VERSC
     WPBP
     ABC
     RT
     CRT
     BT
     C0
     VCP
     ALP
     DFT
     GRT
     LS
     STATUS
     ARRRS
     DDNTK
     ACCR
     AB
     FUND
     AVERAGE
     MODIF
     LIFL
     LIDI
     C1
     V0
     BENTAB
     CODIST
     KRSI
     KRTAX
     KRSP1
     KRSP2
     BEN_BPS
     KRRP
   from database PCL2(KR) id rx-key using pcl2_exp_imp
   IGNORING STRUCTURE BOUNDARIES.
   rp-imp-KR-subrc = sy-subrc.
   KR-VERSION-number = '01'.
   if sy-subrc eq 0 and
      OKR-VERSION-number ne KR-VERSION-number.
      rp-imp-KR-subrc = 8.
   endif.
   endif.

 "* Conversion on-the-fly for domain change of KLBEW note 3024949
 "* after structure change of PC20I:
 "*      field KLBEW with type CHAR2 is added at the end
 "*        note: if the renaming is not done together with the domain
 "*              change, the import will dump
   cl_hrpay99_ab_after_imp=>convert( CHANGING ct_ab = ab[] ).


 end-of-definition.

 "**********************************************************************
 " export definition for cluster KR South Korea
 "**********************************************************************
 define RP-EXP-C2-KR.

   if cl_hrpclx_buffer=>is_switched_on( ) = abap_true.



     PERFORM pclx_macro_execute USING 'RP-EXP-C2-KR'
                                      rx-key
                                      abap_false
                                      space
                             CHANGING rp-imp-KR-subrc
                                      KR-VERSION-number.
      pcl2-versn = KR-VERSION-number.
   else.
   KR-VERSION-number = '01'.
   pcl2-versn = '01'.


   export
     KR-VERSION                                                      "OBJECTS_FOR_EXPORT
     VERSC
     WPBP
     ABC
     RT
     CRT
     BT
     C0
     VCP
     ALP
     DFT
     GRT
     LS
     STATUS
     ARRRS
     DDNTK
     ACCR
     AB
     FUND
     AVERAGE
     MODIF
     LIFL
     LIDI
     C1
     V0
     BENTAB
     CODIST
     KRSI
     KRTAX
     KRSP1
     KRSP2
     BEN_BPS
     KRRP
   to database PCL2(KR) id rx-key using pcl2_exp_imp.
   rp-imp-KR-subrc = sy-subrc.
   endif.
 end-of-definition.

 "**********************************************************************
 " import definition -'O' tables- for cluster KR South Korea
 "**********************************************************************
 define RP-IMP-C2-KR-O.
   if cl_hrpclx_buffer=>is_switched_on( ) = abap_true.

     PERFORM pclx_macro_execute USING 'RP-IMP-C2-KR-O'
                                      orx-key
                                      abap_true
                                      space
                             CHANGING rp-imp-KR-subrc
                                      KR-VERSION-number.
   else.
   clear:
     OKR-VERSION,                                                    "OBJECTS_FOR_CLEAR_O
     OVERSC,
     OWPBP, OWPBP[],
     OABC, OABC[],
     ORT, ORT[],
     OCRT, OCRT[],
     OBT, OBT[],
     OC0, OC0[],
     OVCP, OVCP[],
     OALP, OALP[],
     ODFT, ODFT[],
     OGRT, OGRT[],
     OLS, OLS[],
     OSTATUS,
     OARRRS, OARRRS[],
     ODDNTK, ODDNTK[],
     OACCR, OACCR[],
     OAB, OAB[],
     OFUND, OFUND[],
     OAVERAGE, OAVERAGE[],
     OMODIF, OMODIF[],
     OLIFL, OLIFL[],
     OLIDI, OLIDI[],
     OC1, OC1[],
     OV0, OV0[],
     OBENTAB, OBENTAB[],
     OCODIST, OCODIST[],
     OKRSI, OKRSI[],
     OKRTAX, OKRTAX[],
     OKRSP1, OKRSP1[],
     OKRSP2, OKRSP2[],
     OBEN_BPS, OBEN_BPS[],
     OKRRP, OKRRP[].
   import
     KR-VERSION TO OKR-VERSION                                       "OBJECTS_FOR_IMPORT_O
     VERSC TO OVERSC
     WPBP TO OWPBP
     ABC TO OABC
     RT TO ORT
     CRT TO OCRT
     BT TO OBT
     C0 TO OC0
     VCP TO OVCP
     ALP TO OALP
     DFT TO ODFT
     GRT TO OGRT
     LS TO OLS
     STATUS TO OSTATUS
     ARRRS TO OARRRS
     DDNTK TO ODDNTK
     ACCR TO OACCR
     AB TO OAB
     FUND TO OFUND
     AVERAGE TO OAVERAGE
     MODIF TO OMODIF
     LIFL TO OLIFL
     LIDI TO OLIDI
     C1 TO OC1
     V0 TO OV0
     BENTAB TO OBENTAB
     CODIST TO OCODIST
     KRSI TO OKRSI
     KRTAX TO OKRTAX
     KRSP1 TO OKRSP1
     KRSP2 TO OKRSP2
     BEN_BPS TO OBEN_BPS
     KRRP TO OKRRP
   from database PCL2(KR) id orx-key using pcl2_exp_imp
   IGNORING STRUCTURE BOUNDARIES.
   rp-imp-KR-subrc = sy-subrc.
   KR-VERSION-number = '01'.
   if sy-subrc eq 0 and
      OKR-VERSION-number ne KR-VERSION-number.
      rp-imp-KR-subrc = 8.
   endif.
   endif.

 "* Conversion on-the-fly for domain change of KLBEW note 3024949
 "* after structure change of PC20I:
 "*      KLBEW is renamed to KLBEW_NUM2 (NUM2) and additional
 "*      field KLBEW with type CHAR2 is added at the end
 "*        note: if the renaming is not done together with the domain
 "*              change, the import will dump
   cl_hrpay99_ab_after_imp=>convert( CHANGING ct_ab = oab[] ).


 end-of-definition.

 "**********************************************************************
 " refresh definition for cluster KR South Korea
 "**********************************************************************
 define RP-REF-C2-KR.
   if cl_hrpclx_buffer=>is_switched_on( ) = abap_true.
     CLEAR rx-key.
     PERFORM pclx_macro_execute USING 'RP-REF-C2-KR'
                                      rx-key
                                      abap_false
                                      space
                             CHANGING rp-imp-KR-subrc
                                      KR-VERSION-number.
   else.
   clear:
     RX-KEY,
     OKR-VERSION,                                                    "OBJECTS_FOR_CLEAR
     VERSC,
     WPBP, WPBP[],
     ABC, ABC[],
     RT, RT[],
     CRT, CRT[],
     BT, BT[],
     C0, C0[],
     VCP, VCP[],
     ALP, ALP[],
     DFT, DFT[],
     GRT, GRT[],
     LS, LS[],
     STATUS,
     ARRRS, ARRRS[],
     DDNTK, DDNTK[],
     ACCR, ACCR[],
     AB, AB[],
     FUND, FUND[],
     AVERAGE, AVERAGE[],
     MODIF, MODIF[],
     LIFL, LIFL[],
     LIDI, LIDI[],
     C1, C1[],
     V0, V0[],
     BENTAB, BENTAB[],
     CODIST, CODIST[],
     KRSI, KRSI[],
     KRTAX, KRTAX[],
     KRSP1, KRSP1[],
     KRSP2, KRSP2[],
     BEN_BPS, BEN_BPS[],
     KRRP, KRRP[].
   endif.
 end-of-definition.

 "**********************************************************************
 " refresh definition-'O' tables-for cluster KR South Korea
 "**********************************************************************
 define RP-REF-C2-KR-O.
   if cl_hrpclx_buffer=>is_switched_on( ) = abap_true.
     CLEAR orx-key.
     PERFORM pclx_macro_execute USING 'RP-REF-C2-KR-O'
                                      orx-key
                                      abap_false
                                      space
                             CHANGING rp-imp-KR-subrc
                                      OKR-VERSION-number.
   else.
   clear:
     ORX-KEY,
     OKR-VERSION,                                                    "OBJECTS_FOR_CLEAR_O
     OVERSC,
     OWPBP, OWPBP[],
     OABC, OABC[],
     ORT, ORT[],
     OCRT, OCRT[],
     OBT, OBT[],
     OC0, OC0[],
     OVCP, OVCP[],
     OALP, OALP[],
     ODFT, ODFT[],
     OGRT, OGRT[],
     OLS, OLS[],
     OSTATUS,
     OARRRS, OARRRS[],
     ODDNTK, ODDNTK[],
     OACCR, OACCR[],
     OAB, OAB[],
     OFUND, OFUND[],
     OAVERAGE, OAVERAGE[],
     OMODIF, OMODIF[],
     OLIFL, OLIFL[],
     OLIDI, OLIDI[],
     OC1, OC1[],
     OV0, OV0[],
     OBENTAB, OBENTAB[],
     OCODIST, OCODIST[],
     OKRSI, OKRSI[],
     OKRTAX, OKRTAX[],
     OKRSP1, OKRSP1[],
     OKRSP2, OKRSP2[],
     OBEN_BPS, OBEN_BPS[],
     OKRRP, OKRRP[].
   endif.
 end-of-definition.