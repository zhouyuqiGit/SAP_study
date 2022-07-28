



建表         SE11    
建数据       SE16
            SE16N（比较方便）

アダン表的命名规则
    头文字都是 Z or Y 开头

汎用モジュール
    汎用グループ    SE38
    汎用モジュール  SE37

调用汎用モジュール
    大致的意思就是在SE38写输入用的表单  
    用パターン按钮自动生成调用代码
    调用function把表单的值传进去

    REPORT  zkrcallfunction                         .
    DATA: gdf_rst TYPE zescore.
    PARAMETERS: p_no1 TYPE zescore,
                p_sign TYPE c DEFAULT '+',
                p_no2 TYPE zescore.

    AT SELECTION-SCREEN.

    CALL FUNCTION 'ZF_CALCULATE'
        EXPORTING               "自动生成的原因 其实是入力项"
        i_no1      = p_no1      
        i_sign     = p_sign
        i_no2      = p_no2
        IMPORTING
        e_rst      = gdf_rst
        EXCEPTIONS              "自动生成的原因 其实是入力项"
        sign_error = 1
        zero_error = 2
        OTHERS     = 3.
    IF sy-subrc <> 0.           "判断是否调用成功而返回"
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
        MESSAGE s001(00) WITH '計算結果：' gdf_rst.
    ENDIF.

メッセージ      SE91
    MESSAGE E007(00) WITH '学生ID' '学生姓名' SPACE SPACE. 
        (00) メッセージクラス   "多个参数用空格隔开, 没有使用的参数用SPACE指定"
    
    MESSAGE ID      GCF_MSGID   "右边的内容可以用变量代替"
            TYPE    'E'
            NUMBER  '007'
            WITH    '学生ID'。

    A   强制终了
    E   エラー      赤メッセージ
    I   提示        ポップアップ
    S   正常        緑メッセージ
    W   警告        黄メッセージ
    X   退出

    1. RAISING  "后面指定异常名 有无都可"
            MESSAGE S007(00) WITH '学生ID' RAISING EXC_ZERO.
    2. INTO     "后面指定放入的变量"
            MESSAGE S007(00) WITH GDF_RST INTO GDF_OUT.
    3. DISPLAY LIKE 'E'     "让信息的颜色和形式变成指定的信息类型"
            MESSAGE S007(00) DISPLAY LIKE 'E' WITH '学生ID'.

错误的调查方法（截图）

从外部チェック代码的方法（截图）

作业 
    汎用モジュール作成練習
        入力パラメータ：学生ID
        出力パラメータ：学生名前、住所、点数
        例外：学生ID：入力した学生IDが存在しません
        