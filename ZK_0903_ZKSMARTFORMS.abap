*&---------------------------------------------------------------------*
*& Report  ZKSMARTFORMS                                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZKSMARTFORMS                            .
DATA:  GDF_ID TYPE ZEID,
       GT_ZTSTU TYPE TABLE OF ZTSTU.

SELECT-OPTIONS: S_ID FOR GDF_ID.

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
form GET_DATA .

   SELECT *
    INTO TABLE GT_ZTSTU
    FROM ZTSTU
   WHERE ID  IN S_ID.

endform.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  OUT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form OUT_DATA .
    DATA: FM_NAME TYPE RS38L_FNAM,
        CONTROL_PARAMETERS TYPE SSFCTRLOP,
        OUTPUT_OPTIONS TYPE SSFCOMPOP.

    "スマートフォームIDにより、汎用モジュールIDを取得する
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname                 = 'ZFORM_STU' "自分で登録したスマートフォームID
        IMPORTING
         FM_NAME                   = FM_NAME  "取得した汎用モジュールID
        EXCEPTIONS
          NO_FORM                  = 1
          NO_FUNCTION_MODULE       = 2
          OTHERS                   = 3
                .
      IF sy-subrc <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    CONTROL_PARAMETERS-NO_DIALOG = 'X'. "不显示控制框
    CONTROL_PARAMETERS-PREVIEW = 'X'.   "选中打印预览
    OUTPUT_OPTIONS-TDDEST = 'A000'.     "选中出力デバイスコード

    CALL FUNCTION FM_NAME
        EXPORTING
            CONTROL_PARAMETERS = CONTROL_PARAMETERS
            OUTPUT_OPTIONS = OUTPUT_OPTIONS
        TABLES
            GT_STU = GT_ZTSTU.

endform.                    " OUT_DATA




