*&---------------------------------------------------------------------*
*& Report  ZKBDC_0730                                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zkbdc_0730                              .
TYPES: BEGIN OF ty_asset,
          anlkl TYPE anla-anlkl,  "这里的类型是从录屏一览(SHDB)里来的
          bukrs TYPE anla-bukrs,
          txt50 TYPE anla-txt50,
          menge TYPE anla-menge,
          meins TYPE anla-meins,
          gsber TYPE anlz-gsber,
          kostl TYPE anlz-kostl,
        END OF ty_asset.

DATA: gdt_asset TYPE TABLE OF ty_asset, "固定資産データ == D:bdc.txt
      gdw_asset TYPE ty_asset,
      gdt_bdc TYPE bdcdata,
      gdw_bdc TYPE bdcdata,
      gdt_msg TYPE TABLE OF bdcmsgcoll,   "BDC信息收集表 可以在SE11查到
      gdw_msg TYPE bdcmsgcoll,
      gdf_mod TYPE c VALUE 'n',
      gdf_msg TYPE char50,
      gdt_file TYPE TABLE OF string,
      gdw_file TYPE string.

CONSTANTS: c_tab TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.

PARAMETERS: p_fname  TYPE char30 DEFAULT 'D:bdc.txt'. "定义选择画面的项目

INITIALIZATION.         "选择画面初期处理 没有内容 先写个框架

AT SELECTION-SCREEN.    "入力チェック 没有内容 先写个框架

START-OF-SELECTION.     "选择画面主处理
  PERFORM get_data.
  PERFORM edit_data.
  PERFORM create_data.

END-OF-SELECTION.

*&--------------------------------------------------------------------*
*&      Form  get_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM get_data.
  DATA: ldf_fname TYPE string.
  
  ldf_fname = p_fname.
  
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = ldf_fname
    TABLES
      data_tab                = gdt_file "这里必须把结果出力到一个STRING类型的表里
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "get_data

*&--------------------------------------------------------------------*
*&      Form  edit_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM edit_data.
  DATA: lf_c_menge  TYPE c.

  LOOP AT gdt_file INTO gdw_file.
    SPLIT gdw_file
      AT  c_tab
    INTO  gdw_asset-anlkl
          gdw_asset-bukrs
          gdw_asset-txt50
          lf_c_menge
          gdw_asset-meins
          gdw_asset-gsber
          gdw_asset-kostl.

    gdw_asset-menge = lf_c_menge.

    APPEND gdw_asset TO gdt_asset.

    CLEAR: gdw_asset.

  ENDLOOP.

ENDFORM.                    "edit_data

*&--------------------------------------------------------------------*
*&      Form  create_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM create_data.
  LOOP AT gdt_asset INTO gdw_asset.
    DATA: lf_p_menge  TYPE p,
          lf_c_menge TYPE c.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = 'T'.
    gdw_bdc-fnam = 'AS01'.
    gdw_bdc-fval = space.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = 'SAPLAIST'.
    gdw_bdc-dynpro = '0105'.
    gdw_bdc-dynbegin = 'X'.
    gdw_bdc-fnam = space.
    gdw_bdc-fval = space.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'BDC_OKCODE'.
    gdw_bdc-fval = '/00'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLA-ANLKL'.
    gdw_bdc-fval = gdw_asset-anlkl.                         "'1000'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLA-BUKRS'.
    gdw_bdc-fval = gdw_asset-bukrs.                         "'1000'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = 'SAPLAIST'.
    gdw_bdc-dynpro = '1000'.
    gdw_bdc-dynbegin = 'X'.
    gdw_bdc-fnam = space.
    gdw_bdc-fval = space.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'BDC_OKCODE'.
    gdw_bdc-fval = '=TAB02'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLA-TXT50'.
    gdw_bdc-fval = gdw_asset-txt50. "'newマンション1'.
    APPEND gdw_bdc TO gdt_bdc.

    "※　文件里直接取到的数据是String型　放到内表gdt_asset里需要做一次数据转换
    "(String to type_C to ANLA-MENGE(QUAN))
    "dbc表里只接受char　内表的数据放到bdc表gdt_bdc又要做一次数据转换
    "(ANLA-MENGE(QUAN) to type_P to type_C)
    CLEAR: gdw_bdc, lf_p_menge, lf_c_menge.
    lf_p_menge = gdw_asset-menge.
    lf_c_menge = lf_p_menge.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLA-MENGE'.
    gdw_bdc-fval = lf_c_menge.      "'1'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLA-MEINS'.
    gdw_bdc-fval = gdw_asset-meins. "'ST'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = 'SAPLAIST'.
    gdw_bdc-dynpro = '1000'.
    gdw_bdc-dynbegin = 'X'.
    gdw_bdc-fnam = space.
    gdw_bdc-fval = space.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'BDC_OKCODE'.
    gdw_bdc-fval = '=BUCH'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLZ-GSBER'.
    gdw_bdc-fval = gdw_asset-gsber.  "'9900'.
    APPEND gdw_bdc TO gdt_bdc.

    CLEAR: gdw_bdc.
    gdw_bdc-program = space.
    gdw_bdc-dynpro = space.
    gdw_bdc-dynbegin = space.
    gdw_bdc-fnam = 'ANLZ-KOSTL'.
    gdw_bdc-fval = gdw_asset-kostl.  "'2100'.
    APPEND gdw_bdc TO gdt_bdc.

    CALL TRANSACTION 'AS01'   "进行固定资产登陆的处理
    USING gdt_bdc             "设定该表的内容
      MODE gdf_mod            "N:全模式 A:测试模式 可以进入画面模式
      MESSAGES INTO gdt_msg.  "返回结果放到这个MSG表

    LOOP AT gdt_msg INTO gdw_msg. "把处理结果的MSG给循环出来
      MESSAGE ID gdw_msg-msgid    "バッチインプットメッセージ ID
          TYPE 'E'
          NUMBER gdw_msg-msgnr    "バッチインプットメッセージ番号
          WITH  gdw_msg-msgv1     "メッセージの変数部分
                gdw_msg-msgv2     "メッセージの変数部分
                gdw_msg-msgv3     "メッセージの変数部分
                gdw_msg-msgv4     "メッセージの変数部分　※这些信息都是为了制作出一条メッセージ
          INTO  gdf_msg.          "把完成的メッセージ设定到该变量

      WRITE:/ gdf_msg.

    ENDLOOP.

    CLEAR: gdt_bdc, gdt_msg.
  ENDLOOP.

ENDFORM.                    "create_data