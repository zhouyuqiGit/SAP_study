复习
    text表一般是外结合

    concatenate(字符串连接) 必须全是String类型

    DATA LDF_SCORE_C TYPE CHAR10.

    LDF_SCORE_C = GDW_STU-SCORE.

提示
    ctrl+y 可以自由选中

文件的上传（两种方式）
    FUNCTION 'GUI_UPLOWD'.

    OPEN DATASET P_FNAME        "打开文件
        FOR INPUT.
    
        DO.
            READ DATASET P_FNAME INTO GW_STR.
            IF SY-SUBRC<>0.             "判断还有没有能读取的数据
                EXIT.
            ENDIF.
            APPEND GW_STR TO GT_STR.    "对内表
        ENDDO.

字符串拆分
    SPLIT GF_STR '001,趙,99.5,7'
        AT ','
        INTO    GW_STU-ID        .   "一定要准备好接受变量的数量和类型
                GW_STU-NAME
                GW_STU_SCORE.
        "或↓
        INTO TABLE GT_STR.          "直接插入一个内表里循环出来
            LOOP AT GT_STR INTO GW_STR.
                <FS> = GW_STR.      "把构造放在指针里
                ASSIGN COMPONENT NAME OF STRUCTURE REC TO <FS>.
            ENDLOOP.

    拆分日期        "也可以拆分字符串
    GY_YY = GC_DATE(4).      "2018
    GY_YY = GC_DATE+0(4).    "2018
    GF_MM = GC_DATE+4(2).    "12
    
CG3Y    从服务器下载文件
CG3Z    从本地上传文件
AL11    查看服务器的路径内容
FILE    绝对路径变成相对路径

バッチインプット    標準テーブルデータ登録、変更
    SHDB    录屏

    データ移行
    CALL TRANSACTION 'AS01' 
        USING GT_BDC            "入力        
        MODE 'N'
        MESSAGES INTO GT_MSG.   "出力
    
    1. マスタ移行
    2. トランザクション移行 （業務データ）

    練習　FI01 銀行登録
         AS01 資産登録

SHDB 录屏
做过什么样的batchinput 就是问T-cd 

作业：班级学生表不用结合的方式取数据
READ TABLE 从内表里取一条数据
