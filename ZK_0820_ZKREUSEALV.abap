*&---------------------------------------------------------------------*
*& Report  ZKREUSEALV                                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZKREUSEALV                                .
TYPE-POOLS: slis. "类型池
"双击REUSE_ALV_GRID_DISPLAY_LVC跳转到定义画面可以查看参数的类型
DATA:  GDF_ID TYPE ZEID,
       GDT_ZTSTU TYPE TABLE OF ZTSTU,
       GDS_LAYOUT TYPE LVC_S_LAYO,     "レイアウト構造
       GDW_FIELDCAT TYPE LVC_S_FCAT,   "項目カタログ構造
       GDT_FIELDCAT TYPE LVC_T_FCAT.   "項目カタログ

SELECT-OPTIONS: S_ID FOR GDF_ID.       "范围指定输入框 右边是代入的变量


START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM OUT_DATA.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .
  SELECT *
    INTO TABLE GDT_ZTSTU
    FROM ZTSTU
   WHERE ID  IN S_ID.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  OUT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM OUT_DATA .
  FIELD-SYMBOLS: <FS_FCAT> TYPE LVC_S_FCAT.
  GDS_LAYOUT-ZEBRA  = 'X'.        "レイアウト 斑马线
  GDS_LAYOUT-CWIDTH_OPT  = 'X'.   "レイアウト 列幅最適化

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'ID'.
  GDW_FIELDCAT-KEY       = 'X'.   "指定KEY
  GDW_FIELDCAT-coltext   = '学生ID'.
  GDW_FIELDCAT-OUTPUTLEN = '3'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'NAME'.
  GDW_FIELDCAT-coltext   = '学生名前'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'SEX'.
  GDW_FIELDCAT-coltext   = '性別'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'BIRTHDAY'.
  GDW_FIELDCAT-coltext   = '誕生日'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'PHONE'.
  GDW_FIELDCAT-coltext   = '電話番号'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'ADRESS'.
  GDW_FIELDCAT-coltext   = '住所'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'SCORE'.
  GDW_FIELDCAT-coltext   = '成績'.
  GDW_FIELDCAT-SCRTEXT_S  = 'コメント'. "コメント
  GDW_FIELDCAT-EMPHASIZE = 'X'.   "强调色
  GDW_FIELDCAT-EDIT      = 'X'.   "可编辑
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  GDW_FIELDCAT-DECIMALS = '1'.    "指定小数位数
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.

  CLEAR: GDW_FIELDCAT.
  GDW_FIELDCAT-FIELDNAME = 'CLASS'.
  GDW_FIELDCAT-coltext   = 'クラス'.
  GDW_FIELDCAT-OUTPUTLEN = '10'.
  APPEND GDW_FIELDCAT TO GDT_FIELDCAT.


*構造情報取得用汎用モジュール（单表查询的情况下 比较快）
  " CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  "   EXPORTING
  "     i_structure_name       = 'ztstu'
  "   CHANGING
  "     ct_fieldcat            = GDT_FIELDCAT
  "   EXCEPTIONS
  "     inconsistent_interface = 1
  "     program_error          = 2
  "     OTHERS                 = 3.

  " LOOP AT GDT_FIELDCAT ASSIGNING <fs_fcat> .  "使用指针的写法
  "   IF  <fs_fcat>-fieldname = 'ID'.
  "     <fs_fcat>-key = 'X'.
  "   ENDIF.
  "   IF  <fs_fcat>-fieldname = 'SCORE'.
  "     <fs_fcat>-coltext = '学生点数'.
  "     <fs_fcat>-edit = 'X'.
  "   ENDIF.
  " ENDLOOP.

  " LOOP AT GDT_FIELDCAT INTO GDW_FIELDCAT .  "使用构造的写法
  "   IF  GDW_FIELDCAT-fieldname = 'ID'.
  "     GDW_FIELDCAT-key = 'X'.
  "   ENDIF.
  "   IF  GDW_FIELDCAT-fieldname = 'SCORE'.
  "     GDW_FIELDCAT-coltext = '学生点数'.
  "     GDW_FIELDCAT-edit = 'X'.
  "   ENDIF.
  "   MODIFY GDT_FIELDCAT FROM GDW_FIELDCAT. "因为构造的变化无法直接反应到内表里,要用modify反向反应到内表
  " ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'            "ALV出力
   EXPORTING
   " I_PROGRAM_NAME                    = 'ztstu'        "单个表的时直接设置构造
     I_CALLBACK_PROGRAM                = sy-repid       "当前的程序名
     I_CALLBACK_PF_STATUS_SET          = 'F_SET_STA'    "ツールバー的设定
     I_CALLBACK_USER_COMMAND           = 'F_USER_COMMAND'  "传的是子处理
     I_CALLBACK_HTML_TOP_OF_PAGE       = 'HTML_TOP_OF_PAGE' "添加ALV的头
     I_CALLBACK_HTML_END_OF_LIST       = 'HTML_END_OF_LIST' "添加尾
     IS_LAYOUT_LVC                     = GDS_LAYOUT     "レイアウト構造设置
     IT_FIELDCAT_LVC                   = GDT_FIELDCAT   "項目カタログ设置
   TABLES
      T_OUTTAB                         = GDT_ZTSTU      "表示のデータ
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2.
  IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " OUT_DATA

" ALV画面操作
FORM F_USER_COMMAND
  USING
    al_ucomm LIKE sy-ucomm
  CHANGING
    ao_sfield TYPE slis_selfield. "返回的数据

  CASE al_ucomm.        "ALV画面操作后的动作 为什么用LIKE???
    WHEN '&DATA_SAVE'.  "保存ボタンの押下
      UPDATE ZTSTU FROM TABLE GDT_ZTSTU.
      IF SY-SUBRC = 0.
        COMMIT WORK.
        MESSAGE S018(00).
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    WHEN 'DOWNLOAD'.    "ダウンロードの押下
*      PERFORM F_DOWNLOAD.
    WHEN '&IC1'.                "鼠标双击
      CALL TRANSACTION 'AS03'.  "跳转画面到固定資産照会
  ENDCASE.

  ao_sfield-refresh = 'X'.      "同步内表数据

ENDFORM. "F_USER_COMMAND

FORM F_SET_STA
  USING
    AL_EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'STANDARD_FULLSCREEN'. "GUIステータス名 就是ツールバー 在WRITE出力之前描画
ENDFORM. "F_SET_STA

FORM HTML_TOP_OF_PAGE
  USING DOCUMENT TYPE REF TO CL_DD_DOCUMENT.

  DATA: TEXT TYPE SDYDO_TEXT_ELEMENT.
  TEXT = 'SAP_TOP_OF_PAGE_TEST'.
  CALL METHOD DOCUMENT->ADD_TEXT
    EXPORTING
      TEXT = TEXT
      SAP_STYLE = 'HEADING'.

ENDFORM. "HTML_TOP_OF_PAGE

FORM HTML_END_OF_LIST
  USING END TYPE REF TO CL_DD_DOCUMENT.
 
  DATA: LS_TEXT TYPE SDYDO_TEXT_ELEMENT.

  LS_TEXT = 'SAP_END_OF_LIST_TEST'.
  CALL METHOD END->ADD_TEXT
    EXPORTING
      TEXT         = LS_TEXT
      SAP_EMPHASIS = 'STRONG'.

ENDFORM. "HTML_END_OF_LIST