*&---------------------------------------------------------------------*
*& Report  ZKUPLOAD                                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZKUPLOAD.
DATA: GDT_FILE TYPE TABLE OF STRING,
       GDW_FILE type string,
       GDW_ZTSTU TYPE ZTSTU,
       GDT_ZTSTU TYPE TABLE OF ZTSTU.
constants: con_tab type x value '09'.
constants: c_tab type c value cl_abap_char_utilities=>HORIZONTAL_TAB.

PARAMETERS: P_TBLID TYPE CHAR10 DEFAULT 'ZTSTU',
            P_FNAME TYPE CHAR30 DEFAULT 'C:\STU.txt'.

START-OF-SELECTION.
  PERFORM UPLOAD_DATA .        "学生情報取得
  PERFORM EDIT_DATA.
  PERFORM INS_DATA.         "学生情報登録

END-OF-SELECTION.

*&--------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM UPLOAD_DATA.
  DATA: LDF_FNAME TYPE STRING.
  LDF_FNAME = P_FNAME.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                      = LDF_FNAME
    TABLES
      DATA_TAB                      = GDT_FILE
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
  IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    "GET_DATA

*&--------------------------------------------------------------------*
*&      Form  OUT_DATA
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM EDIT_DATA.

DATA: lf_char_id  TYPE char3,
       LDF_ID TYPE CHAR100,
        lf_char_score TYPE char6.
  LOOP AT GDT_FILE INTO GDW_FILE.
    SPLIT GDW_FILE
       AT c_tab
     INTO lf_char_id
          GDW_ZTSTU-name
          GDW_ZTSTU-sex
          GDW_ZTSTU-birthday
          GDW_ZTSTU-phone
          GDW_ZTSTU-adress
          lf_char_score
          GDW_ZTSTU-class.

    GDW_ZTSTU-id    = lf_char_id.
    GDW_ZTSTU-score = lf_char_score.
    SELECT SINGLE ID
      INTO lf_char_id
      FROM ZTSTU
      WHERE NAME = GDW_ZTSTU-id.
    IF SY-SUBRC = 0.
      CONCATENATE LDF_ID 
                  GDW_ZTSTU-id 
       SEPARATED  BY ','.
           LDF_ID .
        CONTINUE.
     ELSE.
       APPEND GDW_ZTSTU TO GDT_ZTSTU.
      ENDIF.
  ENDLOOP.
  WRITE:/ LDF_ID.
ENDFORM.                    "EDIT_DATA

FORM INS_DATA.
   INSERT (P_TBLID) FROM TABLE GDT_ZTSTU
     ACCEPTING DUPLICATE KEYS .

   IF SY-SUBRC = 0.
      COMMIT WORK.
      MESSAGE S001(00) WITH 'OK'.
   ELSE.
      ROLLBACK WORK.
      MESSAGE S001(00) WITH 'ERROR'.
   ENDIF.
ENDFORM.                    "INS_DATA