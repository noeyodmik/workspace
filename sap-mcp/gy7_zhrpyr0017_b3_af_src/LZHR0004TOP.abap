FUNCTION-POOL ZHR0004.                      "MESSAGE-ID .

TABLES: T7KRR0, T7KRR1, T100.


TABLES: zhriflog.  " I/F 로그

DATA: CTU_PARAMS TYPE CTU_PARAMS,
      BDCDATA    LIKE BDCDATA OCCURS 0 WITH HEADER LINE.

DATA: BEGIN OF MESSTAB OCCURS 10.
        INCLUDE STRUCTURE BDCMSGCOLL.
DATA: END OF MESSTAB.

DATA : L_MSTRING(480). "에러메시지



***************급여함수 관련 선언부*********************
TABLES :PERNR,
            PCL1,                         "HR 클러스터1
            PCL2,                         "HR 클러스터2
            T511,                         "임금유형
            T512T,                        "임금유형 텍스트
            T512W,                        "임금유형평가
            T513S,                        "직무명
            T52OCR,                       "비정기 급여실행 사유
            T52OCC,                       "비정기사유 범주
            T549Q,
            PA0000,
            PA0001,
            PA2001,
            PA0008.

INCLUDE    PCTYPKR0.
INCLUDE    RPCFVP09.                 "Rero-active related
INCLUDE    PCFVPKR0.                 "Rero-active related
INCLUDE    PCCLSKR1.

DATA   :    BEGIN       OF     RT_2          OCCURS   250.
INCLUDE     STRUCTURE          PC207.
DATA   :    FPBEG       LIKE   PC261-FPBEG,
            FPEND       LIKE   PC261-FPEND,
            PAYDT       LIKE   PC261-PAYDT,
*           sortf       like   pc261-sortf,
            DELET(1)    TYPE   C,
            END         OF     RT_2.

DATA: GV_MODE(1).
DATA   :    PN_PER      LIKE    PC261-FPPER.   "급여관리 대상기간(년월)
DATA   :    PERNR_ABKRS TYPE  ABKRS.
DATA   :    W_RETRO(3).                        "소급결과 처리 참조.
DATA   :    W_PERNR     TYPE    PERNR-PERNR.
DATA   :    W_OCRSN     TYPE    PC261-OCRSN.
DATA   :    TMP_DATE    LIKE    PC261-FPEND,
            TMP_DATE1   LIKE    PC261-FPEND,
*            PAY_ID     LIKE    PC261-PAYID,
            PAY_DATE    LIKE    PC261-FPEND,
            PAY_DATE1   LIKE    PC261-FPEND.


** 소급계산여부 확인
DATA: INPER_MODIF       LIKE    PC261-IPERM.
DATA: BEGIN OF EVP OCCURS 10.
        INCLUDE STRUCTURE PC261.
DATA: END   OF EVP.
DATA RETRO_MONTH(2).           "소급 첫월



*--소급분용 데이터 선언(월별소급분계산을위한
DATA   :    BEGIN       OF     RT_SOGUB          OCCURS   250.
INCLUDE     STRUCTURE          ZHRSPC207.
DATA   :    END OF RT_SOGUB.


DATA: WA_RT            TYPE  PC207.        "급여펑션 리턴 구조
DATA: WA               TYPE  ZHRS0012.     "급여대장 출력구조
DATA: HD               TYPE  ZHRS0011.     "급여 휴무일수 구조

***************ZHR_SEN_CRULE_0100_DURATION 관련 선언부**************
TYPES: DAY(2)          TYPE  N,
       MONTH(2)        TYPE  N,
       YEAR(4)         TYPE  N.
TYPES: DAYS_2(2)       TYPE  N,
       DAYS_4(4)       TYPE  N,
       MONTHS_2(2)     TYPE  N,
       MONTHS_3(3)     TYPE  N,
       YEARS_2(2)      TYPE  N,
       DECIMAL_DAYS    TYPE  P DECIMALS 12.
TYPES: DATE_AS_TEXT(8) TYPE  C.

TYPES: WEIGHT          TYPE  PSEN_DUMMY23.

TYPES: RETURNCODE(1)   TYPE  C.

TYPES: INTERVAL_INDEX  TYPE  SYTABIX.

TYPES: CONDITION_LINE(72) TYPE C.


CONSTANTS: LOW_DATE    TYPE  D VALUE '18000101',
           HIGH_DATE   TYPE  D VALUE '99991231'.

CONSTANTS: NO_DAYS_PER_MONTH  TYPE I  VALUE 30,
           MINUS_ID(1) TYPE C VALUE '-',
           CV_MAX_NO_OF_MONTHS TYPE I VALUE 11988.
**********************************************************************

DATA: GR_AWART TYPE TABLE OF PTM_SEL_AWART WITH HEADER LINE.

DEFINE MC_MAKE_RANGE.
  &1-SIGN   = 'I'.
  &1-OPTION = 'EQ'.
  &1-LOW    =  &2.
  APPEND &1.
END-OF-DEFINITION.