*&---------------------------------------------------------------------*
*& Report  ZKHOMEWORE073001                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zkhomewore073001                        .
TYPES: BEGIN OF TY_DA,
        BLDAT TYPE STRING,
        BLART TYPE STRING,
        BUKRS TYPE STRING,
        NEWBS TYPE STRING,
        NEWKO TYPE STRING,
        WRBTR TYPE STRING,
        NEWBS2 TYPE STRING,
        NEWKO2 TYPE STRING,
        WRBTR2 TYPE STRING,
      END OF TY_DA.

DATA: GDT_ASSET TYPE TABLE OF TY_DA,
      GDW_ASSET TYPE TY_DA,
      GDT_FILE  TYPE TABLE OF STRING,
      GDW_FILE  TYPE STRING,
      GDT_BDC   TYPE TABLE OF BDCDATA,
      GDW_BDC   TYPE BDCDATA,
      GDF_MOD   TYPE C VALUE 'n',
      GDT_MSG   TYPE TABLE OF BDCMSGCOLL,
      GDW_MSG   TYPE BDCMSGCOLL,
      GDF_MSG   TYPE CHAR50.

CONSTANTS:  C_TAB TYPE C VALUE cl_abap_char_utilities=>horizontal_tab.

PARAMETERS: P_FNAME TYPE CHAR30 DEFAULT 'D:FB01.txt'.

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM edit_data.
  PERFORM create_data.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA: LDF_FNAME TYPE STRING.
  LDF_FNAME = P_FNAME.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                      = LDF_FNAME
    tables
      data_tab                      = GDT_FILE "这个内表必须是STRING类型否则报错
    EXCEPTIONS
      FILE_OPEN_ERROR               = 1
      FILE_READ_ERROR               = 2
      NO_BATCH                      = 3
      GUI_REFUSE_FILETRANSFER       = 4
      INVALID_TYPE                  = 5
      NO_AUTHORITY                  = 6
      UNKNOWN_ERROR                 = 7
      BAD_DATA_FORMAT               = 8
      HEADER_NOT_ALLOWED            = 9
      SEPARATOR_NOT_ALLOWED         = 10
      HEADER_TOO_LONG               = 11
      UNKNOWN_DP_ERROR              = 12
      ACCESS_DENIED                 = 13
      DP_OUT_OF_MEMORY              = 14
      DISK_FULL                     = 15
      DP_TIMEOUT                    = 16
      OTHERS                        = 17
            .
  IF sy-subrc <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  EDIT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM edit_data .

  LOOP AT GDT_FILE INTO GDW_FILE.
    SPLIT GDW_FILE
      AT  C_TAB
    INTO  GDW_ASSET-BLDAT 
          GDW_ASSET-BLART 
          GDW_ASSET-BUKRS 
          GDW_ASSET-NEWBS 
          GDW_ASSET-NEWKO 
          GDW_ASSET-WRBTR
          GDW_ASSET-NEWBS2
          GDW_ASSET-NEWKO2
          GDW_ASSET-WRBTR2.

    APPEND GDW_ASSET TO GDT_ASSET.

    CLEAR:  GDW_ASSET.
  ENDLOOP.

ENDFORM.                    " EDIT_DATA

*&---------------------------------------------------------------------*
*&      Form  CREATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_data .
  LOOP AT GDT_ASSET INTO GDW_ASSET.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = 'T'.
    GDW_BDC-FNAM = 'FB01'.
    GDW_BDC-FVAL = SPACE.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = 'SAPMF05A'.
    GDW_BDC-DYNPRO = '0100'.
    GDW_BDC-DYNBEGIN = 'X'.
    GDW_BDC-FNAM = SPACE.
    GDW_BDC-FVAL = SPACE.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BDC_OKCODE'.
    GDW_BDC-FVAL = '/00'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BKPF-BLDAT'.
    GDW_BDC-FVAL = GDW_ASSET-BLDAT.   "'2022/07/30'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BKPF-BLART'.
    GDW_BDC-FVAL = GDW_ASSET-BLART.   "'DA'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BKPF-BUKRS'.
    GDW_BDC-FVAL = GDW_ASSET-BUKRS.   "'1000'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'RF05A-NEWBS'.
    GDW_BDC-FVAL = GDW_ASSET-NEWBS.   "'01'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'RF05A-NEWKO'.
    GDW_BDC-FVAL = GDW_ASSET-NEWKO.   "'1175'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = 'SAPMF05A'.
    GDW_BDC-DYNPRO = '0301'.
    GDW_BDC-DYNBEGIN = 'X'.
    GDW_BDC-FNAM = SPACE.
    GDW_BDC-FVAL = SPACE.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BDC_OKCODE'.
    GDW_BDC-FVAL = '/00'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BSEG-WRBTR'.
    GDW_BDC-FVAL = GDW_ASSET-WRBTR.   "'100'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'RF05A-NEWBS'.
    GDW_BDC-FVAL = GDW_ASSET-NEWBS2.   "'50'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'RF05A-NEWKO'.
    GDW_BDC-FVAL = GDW_ASSET-NEWKO2.   "'159100'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = 'SAPMF05A'.
    GDW_BDC-DYNPRO = '0300'.
    GDW_BDC-DYNBEGIN = 'X'.
    GDW_BDC-FNAM = SPACE.
    GDW_BDC-FVAL = SPACE.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BDC_OKCODE'.
    GDW_BDC-FVAL = '=BU'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BSEG-WRBTR'.
    GDW_BDC-FVAL = GDW_ASSET-WRBTR2.   "'100'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = 'SAPLKACB'.
    GDW_BDC-DYNPRO = '0002'.
    GDW_BDC-DYNBEGIN = 'X'.
    GDW_BDC-FNAM = SPACE.
    GDW_BDC-FVAL = SPACE.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    GDW_BDC-PROGRAM = SPACE.
    GDW_BDC-DYNPRO = SPACE.
    GDW_BDC-DYNBEGIN = SPACE.
    GDW_BDC-FNAM = 'BDC_OKCODE'.
    GDW_BDC-FVAL = '=ENTE'.
    APPEND GDW_BDC TO GDT_BDC.
    CLEAR: GDW_BDC.

    CALL TRANSACTION 'FB01'
    USING GDT_BDC
      MODE GDF_MOD
      MESSAGES INTO GDT_MSG.

    LOOP AT GDT_MSG INTO GDW_MSG.
      MESSAGE ID GDW_MSG-MSGID
        TYPE 'E'
        NUMBER GDW_MSG-MSGNR
        WITH   GDW_MSG-MSGV1
               GDW_MSG-MSGV2
               GDW_MSG-MSGV3
               GDW_MSG-MSGV4
        INTO   GDF_MSG.

      WRITE:/  GDF_MSG.
    ENDLOOP.

    CLEAR:  GDT_BDC,  GDT_MSG.
  ENDLOOP.

ENDFORM.                    " CREATE_DATA
