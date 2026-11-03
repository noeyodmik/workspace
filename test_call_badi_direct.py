import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id = 'TEST_CALL_BADI_IT0008'.
    DATA: lo_badi_call TYPE REF TO if_hrsfec_badi_call,
          lt_comp_info TYPE pad_sfec_ce_compensation_tab,
          ls_comp_info TYPE pad_sfec_ce_compensation_info,
          ls_recurr    TYPE pad_sfec_ce_paycomp_recurring,
          lt_p0008     TYPE p0008_tab,
          ls_p0008     TYPE p0008,
          lt_prelp_sec TYPE prelp_tab,
          lv_prelp_sec TYPE infty,
          lt_map_msg   TYPE if_hrsfec_mapping_message=>gty_t_mapping_message.

    " Mock compensation info payload with 5,000,000 KRW
    ls_recurr-paycompvalue = '5000000'.
    ls_recurr-currency_code = 'KRW'.
    APPEND ls_recurr TO ls_comp_info-paycompensation_recurring.
    APPEND ls_comp_info TO lt_comp_info.

    TRY.
        lo_badi_call = cl_hrsfec_badi_call=>get_instance( ).

        lo_badi_call->hrsfec_b_ce_change_it0008(
          EXPORTING
            iv_country_grouping            = '41'
            iv_personnel_number            = '70000017'
            it_compensation_information    = lt_comp_info
            iv_full_transmission_start_dat = '20260101'
            it_map_messages                = lt_map_msg
          CHANGING
            ct_infty_0008                  = lt_p0008
            ct_prelp_secondary             = lt_prelp_sec
            cv_infty_prelp_secondary       = lv_prelp_sec
        ).

        READ TABLE lt_p0008 INTO ls_p0008 INDEX 1.
        ev_ok = 'X'.
        ev_message = |BAdI OK: LGA01={ ls_p0008-lga01 } BET01={ ls_p0008-bet01 } WAERS={ ls_p0008-waers } TRFAR={ ls_p0008-trfar } TRFGB={ ls_p0008-trfgb } TRFGR={ ls_p0008-trfgr }|.
      CATCH cx_root INTO DATA(lx_badi).
        ev_ok = ' '.
        ev_message = |BAdI FAILED: { lx_badi->get_text( ) }|.
    ENDTRY.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]

mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]
c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)

try:
    r_test = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID='TEST_CALL_BADI_IT0008')
    print("Result:", r_test.get('EV_OK'), r_test.get('EV_MESSAGE'))
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)

c.close()

