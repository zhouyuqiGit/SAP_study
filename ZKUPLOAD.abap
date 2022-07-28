*&---------------------------------------------------------------------*
*& Report  ZKUPLOAD                                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZKUPLOAD.
DATA: GDT_FILE TYPE TABLE OF STRING,              "接收上传文件的table
       GDW_FILE type STRING,                      "接受上传文件的构造
       GDW_ZTSTU TYPE ZTSTU,                      "内表的构造
       GDT_ZTSTU TYPE TABLE OF ZTSTU.             "内表
constants: con_tab type x value '09'.             "定义tab的两种方式
constants: c_tab type c value cl_abap_char_utilities=>HORIZONTAL_TAB.

PARAMETERS: P_TBLID TYPE CHAR10 DEFAULT 'ZTSTU',
            P_FNAME TYPE CHAR30 DEFAULT 'C:\STU.txt'.

START-OF-SELECTION.
  PERFORM UPLOAD_DATA .         "学生情報取得
  PERFORM EDIT_DATA.            "学生情报编辑
  PERFORM INS_DATA.             "学生情報登録

END-OF-SELECTION.

*&--------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM UPLOAD_DATA.
  DATA: LDF_FNAME TYPE STRING.
  LDF_FNAME = P_FNAME.              "参数一般是char类型，要换成String类型才能用
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                      = LDF_FNAME "文件路径和名
    TABLES
      DATA_TAB                      = GDT_FILE  "文件内容保存对象表(String类型)
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
  LOOP AT GDT_FILE INTO GDW_FILE.   "循环String类型的表到构造
    SPLIT GDW_FILE                  "拆分该构造
       AT c_tab                     "根据tab来拆分
     INTO lf_char_id
          GDW_ZTSTU-name            "把拆分后的内容放进内表的项目
          GDW_ZTSTU-sex
          GDW_ZTSTU-birthday
          GDW_ZTSTU-phone
          GDW_ZTSTU-adress
          lf_char_score
          GDW_ZTSTU-class.

    GDW_ZTSTU-id    = lf_char_id.   "因为id和score在内表里是数字类型 
    GDW_ZTSTU-score = lf_char_score. "直接传String会报错 需要先转成char
    SELECT SINGLE ID
      INTO lf_char_id
      FROM ZTSTU
      WHERE ID = GDW_ZTSTU-id.    "检索DB表是否有该条数据
    IF SY-SUBRC = 0.              "如果有存在的数据 就把id添加到LDF_ID 最后输出
      CONCATENATE LDF_ID
                  GDW_ZTSTU-id 
       SEPARATED  BY ','.
           LDF_ID .
        CONTINUE.
     ELSE.                        "如果不存在 则把构造添加进内表
       APPEND GDW_ZTSTU TO GDT_ZTSTU.
      ENDIF.
  ENDLOOP.
  WRITE:/ LDF_ID.
ENDFORM.                    "EDIT_DATA

FORM INS_DATA.
   INSERT (P_TBLID) FROM TABLE GDT_ZTSTU  "把内表插入DB表
     ACCEPTING DUPLICATE KEYS .           "如果插入失败也不中断处理

   IF SY-SUBRC = 0.
      COMMIT WORK.
      MESSAGE S001(00) WITH 'OK'.
   ELSE.
      ROLLBACK WORK.
      MESSAGE S001(00) WITH 'ERROR'.
   ENDIF.
ENDFORM.                    "INS_DATA