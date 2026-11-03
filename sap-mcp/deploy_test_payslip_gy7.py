import os
import sys

sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from backends.rfc_backend import RfcBackend


def run_abap(conn, lines):
    for i, ln in enumerate(lines):
        if len(ln) > 72:
            raise ValueError(f"Line {i+1} > 72 chars ({len(ln)}): {ln}")
    res = conn.call(
        "RFC_ABAP_INSTALL_AND_RUN",
        PROGRAM=[{"LINE": ln} for ln in lines],
    )
    err = res.get("ERRMESSAGE", "").strip()
    if err:
        print("  [ABAP ERR]:", err)
    return [w["ZEILE"] for w in res.get("WRITES", [])]


def main():
    s = Settings("GY7")
    b = RfcBackend(s)
    conn = b._conn()

    src_dir = r"c:\Users\sapin\Desktop\Workspace\sap-mcp\gy7_zhrpyr0017_b3_af_src"
    prop_dir = os.path.join(src_dir, "proposed")

    # 1. ZHR0004_T 함수 그룹 생성(TLIBG/TLIBT/TADIR) + Include 초기 엔트리 생성
    print("=== Step 1: Create FUGR ZHR0004_T & Init Includes ===")
    step1_abap = [
        "REPORT Z_TMP_SETUP_TEST.",
        "DATA: lt_src   TYPE TABLE OF string,",
        "      ls_tlibg TYPE tlibg,",
        "      ls_tlibt TYPE tlibt.",
        "",
        "* 1) Register ZHR0004_T in TLIBG, TLIBT, TADIR ($TMP)",
        "ls_tlibg-area  = 'ZHR0004_T'.",
        "ls_tlibg-uname = 'SEPPIN'.",
        "MODIFY tlibg FROM ls_tlibg.",
        "",
        "ls_tlibt-spras = sy-langu.",
        "ls_tlibt-area  = 'ZHR0004_T'.",
        "ls_tlibt-areat = 'Payslip PDF B3 Test Group'.",
        "MODIFY tlibt FROM ls_tlibt.",
        "",
        "CALL FUNCTION 'TR_TADIR_INTERFACE'",
        "  EXPORTING",
        "    wi_test_modus       = ' '",
        "    wi_tadir_pgmid      = 'R3TR'",
        "    wi_tadir_object     = 'FUGR'",
        "    wi_tadir_obj_name   = 'ZHR0004_T'",
        "    wi_tadir_devclass   = '$TMP'",
        "    wi_tadir_author     = 'SEPPIN'",
        "    wi_tadir_masterlang = sy-langu",
        "  EXCEPTIONS",
        "    OTHERS              = 1.",
        "WRITE: / 'TADIR FUGR RC:', sy-subrc.",
        "",
        "* 2) Create initial Function Group programs",
        "CLEAR lt_src.",
        "APPEND 'FUNCTION-POOL ZHR0004_T.' TO lt_src.",
        "INSERT REPORT 'LZHR0004_TTOP' FROM lt_src PROGRAM TYPE 'I'.",
        "WRITE: / 'LZHR0004_TTOP RC:', sy-subrc.",
        "",
        "CLEAR lt_src.",
        "APPEND 'INCLUDE LZHR0004_TU01.' TO lt_src.",
        "APPEND '                    \"ZHR0004_PRINT_PAYSLIP_PDF_B3T' TO lt_src.",
        "INSERT REPORT 'LZHR0004_TUXX' FROM lt_src PROGRAM TYPE 'I'.",
        "WRITE: / 'LZHR0004_TUXX RC:', sy-subrc.",
        "",
        "CLEAR lt_src.",
        "APPEND '* F04' TO lt_src.",
        "INSERT REPORT 'LZHR0004_TF04' FROM lt_src PROGRAM TYPE 'I'.",
        "WRITE: / 'LZHR0004_TF04 RC:', sy-subrc.",
        "",
        "CLEAR lt_src.",
        "APPEND 'INCLUDE LZHR0004_TTOP.' TO lt_src.",
        "APPEND 'INCLUDE LZHR0004_TUXX.' TO lt_src.",
        "APPEND 'INCLUDE LZHR0004_TF04.' TO lt_src.",
        "INSERT REPORT 'SAPLZHR0004_T' FROM lt_src PROGRAM TYPE 'F'.",
        "WRITE: / 'SAPLZHR0004_T RC:', sy-subrc.",
        "COMMIT WORK.",
    ]
    for ln in run_abap(conn, step1_abap):
        print(" ", ln)

    # 2. LZHR0004_TTOP, LZHR0004_TF04 업로드
    print("=== Step 2: Upload Function Group ZHR0004_T includes ===")
    lzhr0004_ttop = "\n".join([
        "FUNCTION-POOL ZHR0004_T.",
        "",
        "TABLES: T7KRR0, T7KRR1, T100,",
        "        PERNR, PCL1, PCL2, T511, T512T, T512W, T513S,",
        "        T52OCR, T52OCC, T549Q, PA0000, PA0001, PA2001, PA0008.",
    ])

    with open(os.path.join(prop_dir, "LZHR0004F04.abap"), "r", encoding="utf-8") as f:
        f04_src = f.read()

    # HR_READ_INFOTYPE 서브루틴 추가 (기존 LZHR0004F03에 있던 헬퍼)
    hr_read_form = "\n".join([
        "",
        "*&---------------------------------------------------------------------*",
        "*&      Form  HR_READ_INFOTYPE",
        "*&---------------------------------------------------------------------*",
        "FORM HR_READ_INFOTYPE  TABLES   PT_P9001 STRUCTURE P9001",
        "                       USING    PV_INFTY",
        "                                PV_PERNR",
        "                                PV_PAYDT.",
        "  REFRESH PT_P9001.",
        "  CALL FUNCTION 'HR_READ_INFOTYPE'",
        "    EXPORTING",
        "      PERNR     = PV_PERNR",
        "      INFTY     = PV_INFTY",
        "      BEGDA     = PV_PAYDT",
        "      ENDDA     = PV_PAYDT",
        "    TABLES",
        "      INFTY_TAB = PT_P9001.",
        "ENDFORM.",
    ])
    lzhr0004_tf04 = f04_src.replace("***INCLUDE LZHR0004F04.", "***INCLUDE LZHR0004_TF04.") + hr_read_form

    for prog_name, subc, src in [
        ("LZHR0004_TTOP", "I", lzhr0004_ttop),
        ("LZHR0004_TF04", "I", lzhr0004_tf04),
    ]:
        r = b.update_source("PROG", prog_name, src, "")
        print(f"  Upload {prog_name}: ok={r.ok}, msg={r.message}")

    # 3. 함수 모듈 ZHR0004_PRINT_PAYSLIP_PDF_B3T 생성 (RS_FUNCTIONMODULE_INSERT)
    print("=== Step 3: Create Function Module ZHR0004_PRINT_PAYSLIP_PDF_B3T ===")
    with open(os.path.join(prop_dir, "ZHR0004_PRINT_PAYSLIP_PDF_B3AF.abap"), "r", encoding="utf-8") as f:
        fm_raw = f.read().splitlines()

    # NEW_SOURCE에는 FUNCTION / ENDFUNCTION 제외 본문만 전달
    body_lines = []
    in_body = False
    for ln in fm_raw:
        u = ln.strip().upper()
        if u.startswith("FUNCTION "):
            in_body = True
            continue
        if u.startswith("ENDFUNCTION"):
            break
        if ln.startswith('*"'):
            continue
        if in_body:
            body_lines.append({"LINE": ln})

    step3_abap = [
        "REPORT Z_TMP_CREATE_FM_B3T.",
        "DATA: lt_import TYPE TABLE OF rsimp,",
        "      ls_import TYPE rsimp,",
        "      lt_export TYPE TABLE OF rsexp,",
        "      ls_export TYPE rsexp,",
        "      lt_tables TYPE TABLE OF rstbl,",
        "      ls_tables TYPE rstbl,",
        "      lv_incl   TYPE rs38l-include.",
        "",
        "CLEAR ls_import.",
        "ls_import-parameter = 'IV_ZSTYPE'.",
        "ls_import-typ       = 'ZSTYPE'.",
        "ls_import-optional  = ' '.",
        "ls_import-reference = ' '.",
        "APPEND ls_import TO lt_import.",
        "",
        "CLEAR ls_import.",
        "ls_import-parameter = 'IV_ZSIGN'.",
        "ls_import-typ       = 'CHAR01'.",
        "ls_import-optional  = 'X'.",
        "ls_import-reference = ' '.",
        "APPEND ls_import TO lt_import.",
        "",
        "CLEAR ls_import.",
        "ls_import-parameter = 'IV_YEAR'.",
        "ls_import-typ       = 'CHAR04'.",
        "ls_import-optional  = 'X'.",
        "ls_import-reference = ' '.",
        "APPEND ls_import TO lt_import.",
        "",
        "CLEAR ls_export.",
        "ls_export-parameter = 'E_PDF_DATA'.",
        "ls_export-typ       = 'XSTRING'.",
        "ls_export-reference = ' '.",
        "APPEND ls_export TO lt_export.",
        "",
        "CLEAR ls_export.",
        "ls_export-parameter = 'E_PDF_FSIZE'.",
        "ls_export-typ       = 'I'.",
        "ls_export-reference = ' '.",
        "APPEND ls_export TO lt_export.",
        "",
        "CLEAR ls_export.",
        "ls_export-parameter = 'EV_PDF'.",
        "ls_export-typ       = 'XSTRING'.",
        "ls_export-reference = ' '.",
        "APPEND ls_export TO lt_export.",
        "",
        "CLEAR ls_tables.",
        "ls_tables-parameter = 'IR_PERNR'.",
        "ls_tables-dbstruct  = 'SEL_PERNR'.",
        "ls_tables-optional  = 'X'.",
        "APPEND ls_tables TO lt_tables.",
        "",
        "CLEAR ls_tables.",
        "ls_tables-parameter = 'IR_PAYDT'.",
        "ls_tables-dbstruct  = 'SEL_DATE'.",
        "ls_tables-optional  = 'X'.",
        "APPEND ls_tables TO lt_tables.",
        "",
        "CLEAR ls_tables.",
        "ls_tables-parameter = 'IR_ORGEH'.",
        "ls_tables-dbstruct  = 'CCHRS_ORGEH_RANGE'.",
        "ls_tables-optional  = 'X'.",
        "APPEND ls_tables TO lt_tables.",
        "",
        "CALL FUNCTION 'FUNCTION_EXISTS'",
        "  EXPORTING",
        "    funcname = 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'",
        "  EXCEPTIONS",
        "    OTHERS   = 1.",
        "IF sy-subrc <> 0.",
        "  CALL FUNCTION 'RS_FUNCTIONMODULE_INSERT'",
        "    EXPORTING",
        "      funcname                = 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'",
        "      function_pool           = 'ZHR0004_T'",
        "      interface_global        = ' '",
        "      remote_call             = ' '",
        "      short_text              = 'Payslip PDF B3 Test (Refactored)'",
        "      suppress_corr_check     = 'X'",
        "      suppress_language_check = 'X'",
        "      authority_check         = ' '",
        "      save_active             = 'X'",
        "    IMPORTING",
        "      function_include        = lv_incl",
        "    TABLES",
        "      import_parameter        = lt_import",
        "      export_parameter        = lt_export",
        "      tables_parameter        = lt_tables",
        "    EXCEPTIONS",
        "      OTHERS                  = 1.",
        "  WRITE: / 'FM INSERT RC:', sy-subrc, 'INCL:', lv_incl.",
        "ELSE.",
        "  WRITE: / 'FM ALREADY EXISTS: ZHR0004_PRINT_PAYSLIP_PDF_B3T'.",
        "ENDIF.",
    ]
    for ln in run_abap(conn, step3_abap):
        print(" ", ln)

    # ZHR0004_PRINT_PAYSLIP_PDF_B3T 소스 업데이트 및 활성화
    fm_full_src = "\n".join(fm_raw).replace(
        "FUNCTION ZHR0004_PRINT_PAYSLIP_PDF_B3AF.",
        "FUNCTION ZHR0004_PRINT_PAYSLIP_PDF_B3T.",
    )
    r_fm = b.update_source("FUNC", "ZHR0004_PRINT_PAYSLIP_PDF_B3T", fm_full_src, "")
    print("  Update FUNC ZHR0004_PRINT_PAYSLIP_PDF_B3T:", r_fm.ok, r_fm.message)

    # SAPLZHR0004_T 및 하위 Include 일괄 활성화 & GENERATE REPORT
    step3b_abap = [
        "REPORT Z_TMP_ACTIVATE_FUGR_T.",
        "DATA: lt_dwin TYPE TABLE OF dwinactiv,",
        "      ls_dwin TYPE dwinactiv,",
        "      lt_work TYPE TABLE OF dwinactiv,",
        "      lv_msg  TYPE c LENGTH 255,",
        "      lv_line TYPE i,",
        "      lv_word TYPE c LENGTH 30,",
        "      lt_src  TYPE TABLE OF string.",
        "",
        "SELECT * FROM dwinactiv INTO TABLE lt_dwin",
        "  WHERE obj_name LIKE 'LZHR0004_T%'",
        "     OR obj_name = 'SAPLZHR0004_T'",
        "     OR obj_name = 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'.",
        "LOOP AT lt_dwin INTO ls_dwin.",
        "  CALL FUNCTION 'RS_INSERT_INTO_WORKING_AREA'",
        "    EXPORTING",
        "      object   = ls_dwin-object",
        "      obj_name = ls_dwin-obj_name",
        "    EXCEPTIONS",
        "      OTHERS   = 1.",
        "ENDLOOP.",
        "",
        "* Activate all in working area or replace state 'I' with 'A'",
        "LOOP AT lt_dwin INTO ls_dwin WHERE object = 'REPS'.",
        "  READ REPORT ls_dwin-obj_name INTO lt_src STATE 'I'.",
        "  IF sy-subrc = 0 AND lt_src IS NOT INITIAL.",
        "    INSERT REPORT ls_dwin-obj_name FROM lt_src STATE 'A'",
        "      PROGRAM TYPE 'I'.",
        "  ENDIF.",
        "ENDLOOP.",
        "DELETE FROM dwinactiv",
        "  WHERE obj_name LIKE 'LZHR0004_T%'",
        "     OR obj_name = 'SAPLZHR0004_T'",
        "     OR obj_name = 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'.",
        "COMMIT WORK.",
        "",
        "GENERATE REPORT 'SAPLZHR0004_T'",
        "  MESSAGE lv_msg LINE lv_line WORD lv_word.",
        "WRITE: / 'GENERATE SAPLZHR0004_T RC:', sy-subrc.",
        "IF sy-subrc <> 0.",
        "  WRITE: / 'ERR:', lv_msg, 'LINE:', lv_line, 'WORD:', lv_word.",
        "ENDIF.",
    ]
    for ln in run_abap(conn, step3b_abap):
        print(" ", ln)

    for obj_t, obj_n in [
        ("PROG", "LZHR0004_TTOP"),
        ("PROG", "LZHR0004_TF04"),
        ("FUNC", "ZHR0004_PRINT_PAYSLIP_PDF_B3T"),
    ]:
        act = b.activate_object(obj_t, obj_n)
        print(f"  Activate {obj_t} {obj_n}: ok={act.ok}, msg={act.message}")

    # 4. ZHRPYR0017_B3_AF_T 및 하위 Include 5개 생성 및 활성화
    print("=== Step 4: Upload & Activate ZHRPYR0017_B3_AF_T and Includes ===")
    with open(os.path.join(prop_dir, "ZHRPYR0017_B3_AF_TOP.abap"), "r", encoding="utf-8") as f:
        top_src = f.read()
    with open(os.path.join(src_dir, "ZHRPYR0017_B3_AF_SEL.abap"), "r", encoding="utf-8") as f:
        sel_src = f.read()
    with open(os.path.join(src_dir, "ZHRPYR0017_B3_AF_O01.abap"), "r", encoding="utf-8") as f:
        o01_src = f.read()
    with open(os.path.join(src_dir, "ZHRPYR0017_B3_AF_I01.abap"), "r", encoding="utf-8") as f:
        i01_src = f.read()
    with open(os.path.join(prop_dir, "ZHRPYR0017_B3_AF_F01.abap"), "r", encoding="utf-8") as f:
        f01_src = f.read()
    with open(os.path.join(prop_dir, "ZHRPYR0017_B3_AF.abap"), "r", encoding="utf-8") as f:
        main_src = f.read()

    main_t_src = (
        main_src.replace("REPORT ZHRPYR0017_B3_AF", "REPORT ZHRPYR0017_B3_AF_T")
        .replace("INCLUDE ZHRPYR0017_B3_AF_TOP.", "INCLUDE ZHRPYR0017_B3_AF_T_TOP.")
        .replace("INCLUDE ZHRPYR0017_B3_AF_SEL.", "INCLUDE ZHRPYR0017_B3_AF_T_SEL.")
        .replace("INCLUDE ZHRPYR0017_B3_AF_O01.", "INCLUDE ZHRPYR0017_B3_AF_T_O01.")
        .replace("INCLUDE ZHRPYR0017_B3_AF_I01.", "INCLUDE ZHRPYR0017_B3_AF_T_I01.")
        .replace("INCLUDE ZHRPYR0017_B3_AF_F01.", "INCLUDE ZHRPYR0017_B3_AF_T_F01.")
        .replace("CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3AF'", "CALL FUNCTION 'ZHR0004_PRINT_PAYSLIP_PDF_B3T'")
    )

    for inc_name, inc_src in [
        ("ZHRPYR0017_B3_AF_T_TOP", top_src),
        ("ZHRPYR0017_B3_AF_T_SEL", sel_src),
        ("ZHRPYR0017_B3_AF_T_O01", o01_src),
        ("ZHRPYR0017_B3_AF_T_I01", i01_src),
        ("ZHRPYR0017_B3_AF_T_F01", f01_src),
    ]:
        c_inc = b.create_object("INCL", inc_name, "$TMP", inc_name, "")
        r_inc = b.update_source("INCL", inc_name, inc_src, "")
        act_inc = b.activate_object("INCL", inc_name)
        print(f"  Include {inc_name}: create={c_inc.ok}, update={r_inc.ok} ({r_inc.message}), activate={act_inc.ok} ({act_inc.message})")

    r_main = b.update_source("PROG", "ZHRPYR0017_B3_AF_T", main_t_src, "")
    chk_main = b.syntax_check("PROG", "ZHRPYR0017_B3_AF_T", main_t_src)
    act_main = b.activate_object("PROG", "ZHRPYR0017_B3_AF_T")
    print(f"  Main ZHRPYR0017_B3_AF_T: update={r_main.ok}, syntax={chk_main.ok} ({chk_main.message}), activate={act_main.ok} ({act_main.message})")

    # 5. Textpool 복사 확인 및 보정 (READ TEXTPOOL ZHRPYR0017_B3_AF -> INSERT TEXTPOOL ZHRPYR0017_B3_AF_T)
    step5_abap = [
        "REPORT Z_TMP_COPY_TEXTPOOL.",
        "DATA: lt_text TYPE TABLE OF textpool.",
        "READ TEXTPOOL 'ZHRPYR0017_B3_AF' INTO lt_text LANGUAGE sy-langu.",
        "IF lt_text IS NOT INITIAL.",
        "  INSERT TEXTPOOL 'ZHRPYR0017_B3_AF_T' FROM lt_text LANGUAGE sy-langu.",
        "  WRITE: / 'TEXTPOOL copied, lines:', lines( lt_text ).",
        "ENDIF.",
        "READ TEXTPOOL 'ZHRPYR0017_B3_AF' INTO lt_text LANGUAGE '3'.",
        "IF lt_text IS NOT INITIAL.",
        "  INSERT TEXTPOOL 'ZHRPYR0017_B3_AF_T' FROM lt_text LANGUAGE '3'.",
        "  WRITE: / 'TEXTPOOL(KO) copied, lines:', lines( lt_text ).",
        "ENDIF.",
    ]
    for ln in run_abap(conn, step5_abap):
        print(" ", ln)


if __name__ == "__main__":
    main()

