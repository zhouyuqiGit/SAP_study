*&---------------------------------------------------------------------
*& Report  ZKINNERJOIN                                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT ZKINNERJOIN                             .
TYPES:  BEGIN OF TY_STU,
            ID      TYPE ZEID,
            NAME    TYPE ZENAME,
            CLASS   TYPE ZECLASS,
            CLASSNAME   TYPE ZECLASSNAME,
        END OF TY_STU.
DATA:   GDF_ID TYPE ZEID,
        GDF_NAME TYPE ZENAME,
        GDT_STU TYPE TABLE OF TY_STU,
        GDW_STU TYPE TY_STU,
        GDT_ZTSTU TYPE TABLE OF ZTSTU,
        GDE_STU TYPE STRING.

SELECT-OPTIONS: S_ID FOR GDF_ID.
PARAMETERS: P_FNAME TYPE CHAR30 DEFAULT 'C:\FILE01.TXT'.

START-OF-SELECTION.
    PERFORM GET_DATA    USING      GDF_ID      "指定入力参数
                        CHANGING   GDF_NAME .  "指定出力参数
    PERFORM OUT_DATA.
END-OF-SELECTION.

FORM GET_DATA
    USING       PU_ID       TYPE ZEID
    CHANGING    PC_NAME     TYPE ZENAME .

    " SELECT  A~ID
    "         A~NAME
    "         A~CLASS
    "         B~CLASSNAME
    "     INTO TABLE GDT_STU
    "     FROM ZTSTU AS A INNER JOIN ZTCLASS AS B
    "         ON B~CLASS = A~CLASS
    " WHERE ID IN S_ID.
    " IF SY-SUBRC = 0.
    "     MESSAGE S001(00) WITH '対象データ：' SY-DBCNT.
    " ELSE.
    "     MESSAGE E001(00) WITH '対象データが存在しません' SY-DBCNT.
    " ENDIF.

    "内表结合
    SELECT *
      INTO TABLE GDT_ZTSTU
    FROM ZTSTU
    WHERE ID IN S_ID.

    IF GDT_ZTSTU is not initial.
        SELECT  
            GDT_ZTSTU-CLASS
            CLASSNAME
        INTO TABLE GDT_STU
        FROM ZTCLASS
            FOR ALL ENTRIES IN GDT_ZTSTU   "内部テーブル
        WHERE CLASS = GDT_ZTSTU-CLASS.     "内部テーブルの項目
                "CLASS IN GDT_STU.
    ENDIF.


ENDFORM.

FORM OUT_DATA.

    " OPEN DATASET 'C:\FILE02.TXT'
    "     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

    LOOP AT GDT_STU INTO GDW_STU.
        WRITE:/ GDW_STU-ID,
                GDW_STU-NAME,
                GDW_STU-CLASS,
                GDW_STU-CLASSNAME.

        " CONCATENATE GDW_STU-ID GDW_STU-NAME GDW_STU-CLASS
        "     GDW_STU-CLASSNAME INTO GDE_STU SEPARATED BY ','.

        " TRANSFER GDE_STU TO 'C:\FILE02.TXT'.
    ENDLOOP.

    " CLOSE DATASET 'C:\FILE02.TXT'.

*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
*        filename                      = 'C:\FILE01.TXT'
*      tables
*        data_tab                      = GDT_STU
*      EXCEPTIONS
*        FILE_WRITE_ERROR              = 1
*        NO_BATCH                      = 2
*        GUI_REFUSE_FILETRANSFER       = 3
*        INVALID_TYPE                  = 4
*        NO_AUTHORITY                  = 5
*        UNKNOWN_ERROR                 = 6
*        HEADER_NOT_ALLOWED            = 7
*        SEPARATOR_NOT_ALLOWED         = 8
*        FILESIZE_NOT_ALLOWED          = 9
*        HEADER_TOO_LONG               = 10
*        DP_ERROR_CREATE               = 11
*        DP_ERROR_SEND                 = 12
*        DP_ERROR_WRITE                = 13
*        UNKNOWN_DP_ERROR              = 14
*        ACCESS_DENIED                 = 15
*        DP_OUT_OF_MEMORY              = 16
*        DISK_FULL                     = 17
*        DP_TIMEOUT                    = 18
*        FILE_NOT_FOUND                = 19
*        DATAPROVIDER_EXCEPTION        = 20
*        CONTROL_FLUSH_ERROR           = 21
*        OTHERS                        = 22
*              .
*    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.

ENDFORM.