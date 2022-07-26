* 第六节课

DB结合
    SELECT  A~ID
            A~NAME
            A~CLASS
            B~CLASSNAME
    INTO TABLE GT_ZTSTU
    FROM ZTSTU AS A INNER JOIN ZTCLASS AS B     "LEFT OUTER等
        ON B~CLASS = A~CLASS
    WHERE A~ID IN S_ID.         "在S/4环境 要写成@S_ID

内表结合
    IF GT_STU[] is not initial.         "[]はテーブルヘッダの意味
        SELECT XXX
        FROM ZTCLASS
            FOR ALL ENTRIES IN GT_STU   "内部テーブル
        WHERE CLASS = GT_STU-CLASS.     "内部テーブルの項目
                CLASS IN GRT_STU.
    ENDIF.

    1.结合的内表绝对不能为空 所以要先判断
    2.SELECT后面必须是内表项目 S/4环境除外
    3.内表需要排序，删除重复项

    排序
    SORT GT_ZTSTU
        BY CLASS ASCENDING.     --昇順
           ID   DESCDING.      --降順

    去重
    DELETE ADJACENT DUPLICATES FROM itab
        COMPARING class.

注意
    循环select的话会频繁开关数据库浪费资源和时间 所以不推荐
    正确的方法是把数据放在内表里 对内表进行循环
    select
        where id in 1-5
    endselect.
    
登陆表
    项目
        組込型ボタン
            可以更方便填写表（可以略写データエレメント）
    検索ヘルプ
        表单里会出现检索提示用的小按钮
    チェックテーブル
        表单里输入的数据是チェックテーブル里不存在的情况不会被登陆
    通货/数量项目
        在项目里登表时必须选用通货/数量表里面的项目

调用构造方法传参
    REPORT ZKINNERJOIN.
    TYPES:  BEGIN OF TY_STU,        
                ID      TYPE ZEID,
                NAME    TYPE ZENAME,
                CLASS   TYPE ZECLASS,
                CLASSNANE   TYPE ZECLASSNAME,
            END OF TY_STU.
    DATA:   GDF_ID TYPE ZEID,
            GDT_STU TYPE TABLE OF TY_STU.
    SELECT-OPTIONS: S_ID FOR GDF_ID.

    START-OF-SELECTION.
        PERFORM GET_DATA    TABLES     GDT_STU     "可以不定义     
                            USING      GDF_ID      "指定入力参数
                            CHANGING   GDF_NAME .  "指定出力参数
        PERFORM OUT_DATA.
    END-OF-SELECTION.

    FORM GET_DATA
        TABLES      GDT_STU     TYPE ANY        
        USING       PU_ID       TYPE ZEID
        CHANGING    PC_NAME     TYPE ZENAME .   "定义参数 P代表parameter　C代表changing"

        SELET   A~ID
                A~NAME
                A~CLASS
                B~CLASSNAME
            INTO TABLE GDT_STU
            FROM ZTSTU AS A INNER JOIN ZTCLASS AS B
                ON B~CLASS = A~CLASS
        WHERE ID IN S_ID.
        IF SY-SUBRC = 0.
            MESSAGE S001(00) WITH '対象データ：' SY-DBCNT.
        ELSE.
            MESSAGE E001(00) WITH '対象データが存在しません' SY-DBCNT.
        ENDIF.

    ENDFORM.

    FORM OUT_DATA.
        LOOP AT CDT_STU INTO GDW_STU.
            WRITE:/ GDW_STU-ID,
                    GDW_STU-NAME,
                    GDW_STU-CLASS,
                    GDW_STU-CLASSNAME.
        ENDLOOP.

    ENDFORM.

文件下载
    两种下载方式

    文件出力到本地
        CALL FUNCTION 'GUI_DOWNLOAD'    "调用这个汎用モジュール
            EXPORTING
                FILENAME = 'C:¥999.TXT'
    文件出力到服务器
        OPEN DATASET P_FNAME        "打开文件
            FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
        P_FNAME:'C:¥FILE01.TXT'.    "ファイルのパース（ファイル名）
        TRANSFER GW_STR TO P_FNAME. "写入文件
            GW_STR:'要写入的内容'.
        P_FNAME:'C:¥FILE01.TXT'.
        CLOSE DATASET P_FNAME.      "关闭文件
        P_FNAME:'C:¥FILE01.TXT'.
                
字符串的连接
    CONCATENATE '111' 'AAA' INTO GF_STR
    SEPARATED BY ','                "区切りカンマ

    GF_STR = 'AA' && 'BB'.          "r3用不了

    
* つづりをチェックしてください  構文エラー
* ディクョナリでテーブル　射影ビューまたはデータベースビュー として定義されていません  テーブルが有効化されてないかも