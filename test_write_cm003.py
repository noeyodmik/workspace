import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

METHOD_SRC = """  METHOD IF_HRSFEC_CE_CHANGE_IT0008~CHANGE_INFO_TYPE_DATA.
    DATA: lv_amount   TYPE p0008-bet01,
          lv_currency TYPE p0008-waers.

    IF it_compensation_information IS NOT INITIAL.
      LOOP AT it_compensation_information ASSIGNING FIELD-SYMBOL(<ls_comp_info>).
        LOOP AT <ls_comp_info>-paycompensation_recurring ASSIGNING FIELD-SYMBOL(<ls_paycomp>).
          IF <ls_paycomp>-paycompvalue-value IS NOT INITIAL.
            lv_amount = <ls_paycomp>-paycompvalue-value.
          ENDIF.
          IF <ls_paycomp>-currency_code IS NOT INITIAL.
            lv_currency = <ls_paycomp>-currency_code.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    IF lv_currency IS INITIAL.
      lv_currency = 'KRW'.
    ENDIF.

    LOOP AT ct_infty_0008 ASSIGNING FIELD-SYMBOL(<ls_p0008>).
      <ls_p0008>-trfar = '10'.
      <ls_p0008>-trfgb = '10'.
      <ls_p0008>-trfgr = 'SEPPIN'.
      <ls_p0008>-waers = lv_currency.
      <ls_p0008>-lga01 = '1010'.
      <ls_p0008>-bet01 = lv_amount.
    ENDLOOP.

    IF ct_infty_0008 IS INITIAL.
      DATA: ls_p0008 TYPE p0008.
      ls_p0008-pernr = iv_personnel_number.
      ls_p0008-infty = '0008'.
      ls_p0008-subty = '0'.
      ls_p0008-begda = iv_full_transmission_start_dat.
      ls_p0008-endda = '99991231'.
      ls_p0008-trfar = '10'.
      ls_p0008-trfgb = '10'.
      ls_p0008-trfgr = 'SEPPIN'.
      ls_p0008-waers = lv_currency.
      ls_p0008-lga01 = '1010'.
      ls_p0008-bet01 = lv_amount.
      APPEND ls_p0008 TO ct_infty_0008.
    ENDIF.
  ENDMETHOD."""

# Escape single quotes for ABAP literal: ' -> ''
def abap_esc(line):
    return line.replace("'", "''")

lines_abap = "\n".join([f"    APPEND '{abap_esc(l)}' TO lt_source." for l in METHOD_SRC.splitlines()])

CODE = """  " --- WRITE CM003 AND ACTIVATE CLASS ---
  IF iv_ext_id = 'WRITE_CM003'.
    DATA: lt_source TYPE TABLE OF string,
          lt_clskeys TYPE seoc_class_keys,
          ls_clskey  TYPE seoclskey.

""" + lines_abap + """

    INSERT REPORT 'ZHR_PY========================CM003' FROM lt_source.
    IF sy-subrc = 0.
      ls_clskey-clsname = 'ZHR_PY'.
      APPEND ls_clskey TO lt_clskeys.

      CALL FUNCTION 'SEO_CLASS_ACTIVATE'
        EXPORTING
          clskeys      = lt_clskeys
        EXCEPTIONS
          OTHERS       = 1.

      IF sy-subrc = 0.
        ev_ok = 'X'.
        ev_message = 'CM003 written and ZHR_PY activated successfully!'.
      ELSE.
        ev_ok = ' '.
        ev_message = |SEO_CLASS_ACTIVATE failed: { sy-subrc }|.
      ENDIF.
    ELSE.
      ev_ok = ' '.
      ev_message = |INSERT REPORT CM003 failed: { sy-subrc }|.
    ENDIF.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='WRITE_CM003')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900013',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

# Read CM003
r_cm3 = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='ZHR_PY========================CM003')
print('--- CM003 lines ---')
for l in r_cm3.get('SOURCE_EXTENDED', []):
    print(l['LINE'])

c.close()
