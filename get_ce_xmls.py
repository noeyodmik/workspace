import io, sys
sys.path.insert(0, r"c:\Users\sapin\Desktop\Workspace\sap-mcp")
from config import Settings
from pyrfc import Connection

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
c = Connection(**Settings("EA3").rfc_params())

CODE = """  IF iv_ext_id(4) = 'XML_'.
    DATA: lo_ce TYPE REF TO cl_hrsfec_compound_employee,
          lv_xml TYPE string,
          lv_empid TYPE hrsfec_employee_id_external,
          ls_stat TYPE hrsfec_d_repstat.

    lv_empid = iv_ext_id+4.
    lo_ce = cl_hrsfec_compound_employee=>get_instance( ).

    SELECT SINGLE * FROM hrsfec_d_repstat INTO ls_stat
      WHERE employee_id_ext = lv_empid.

    IF sy-subrc = 0 AND ls_stat-cur_repl_srt_msgid IS NOT INITIAL.
      TRY.
          CALL METHOD lo_ce->get_ce_xml_str
            EXPORTING
              iv_employee_id_ext        = ls_stat-employee_id_ext
              iv_inbound_message        = lo_ce->get_xml_bndl_msg( ls_stat-cur_repl_srt_msgid )
            IMPORTING
              ev_ce_xml_string_readable = lv_xml.
          ev_ok = 'X'.
          ev_message = lv_xml.
        CATCH cx_root INTO DATA(lx).
          ev_ok = ' '.
          ev_message = lx->get_text( ).
      ENDTRY.
    ELSE.
      ev_ok = ' '.
      ev_message = |No REPSTAT found for { lv_empid }|.
    ENDIF.
    RETURN.
  ENDIF.
"""

res = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
orig_lines = [l['LINE'] for l in res.get('SOURCE_EXTENDED', [])]
mod_lines = [{'LINE': l} for l in (orig_lines[:31] + CODE.splitlines() + orig_lines[31:])]

c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
       SAVE_INACTIVE=' ', SOURCE_EXTENDED=mod_lines)
try:
    for emp in ['70000017', '70000019']:
        r = c.call('Z_MCP_GET_REPLICATION_LOG', IV_EXT_ID=f'XML_{emp}')
        msg = r.get('EV_MESSAGE', '')
        print(f"=== EMP {emp} XML length: {len(msg)} ===")
        with open(f"ce_{emp}.xml", "w", encoding="utf-8") as f:
            f.write(msg)
        print(f"Saved to ce_{emp}.xml: {msg[:200]}...")
finally:
    c.call('RPY_INCLUDE_UPDATE', INCLUDE_NAME='LZMCPU11', TRANSPORT_NUMBER='EA3K900019',
           SAVE_INACTIVE=' ', SOURCE_EXTENDED=[{'LINE': l} for l in orig_lines])
    chk = c.call('RPY_PROGRAM_READ', PROGRAM_NAME='LZMCPU11')
    back = [l['LINE'] for l in chk.get('SOURCE_EXTENDED', [])]
    print("Restored identical:", back == orig_lines)
