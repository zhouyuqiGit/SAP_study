各个模块的介绍          
	会计系
          FI 财务管理
          CO 管理会计
	ロジ系
          SD 贩卖管理
          MM 在库/购买管理
          PP 生产/计划管理

数据类型                        
     C 字符串                      
     D 日期                      
     I 正数                      
     P 小数                      
定义变量                        
     DATA:GDF_ID(3) TYPE C,                       
          GDF_NAME(10) TYPE C.     "."应该是一句话结束                
          GDF_ID = '123'                       
     WRITE:/ GDF_ID.               输出用                
判断语句                        
     IF GF_SCORE >= 60 and GF_class = 'A'.                       
          WRITE:/ '合格'.                       
     ELSE.                       
          WRITE:/ '不合格'.                       
     ENDIF.                       
                    
     CASE WEEK.                       
     WHEN '1'.                       
          work.                       
     WHEN '2'.                       
          work.                       
     WHEN others.                       
          error.                       
     ENDCASE.                       
                    
循环语句                        
     DO 3 TIMES.                       
          CNT = CNT + 1.           EXIT.  退出循环                
          WRITE:/ CNT.             CONTINIUTE.    结束当前循环              
     ENDDO.                       
                    
     LOOP AT GDT_STU INTO GS_STU.  把内表GDT_STU放到构造GS_STU里               
     WRITE:/ GS_STU-NAME.                       
     ENDLOOP.                       
                    
帐票  アダン开发用得最多的就是帐票                      
     WRITE命令输出的帐票      缺点是画面一换整个程序都要重新写                 
     I/F(インタフェース)      不同系统之间的数据交换                 
     BDC(BatchInput)          批量导入                 
     ALV                      出入力帐票                 
     SMART FROMS              PDF 源泉票 注文领受书                 
     DYNPRO→FIORI             画面程序        
                              头文字A～X的都是标准功能         
                              T-CODE 快捷码         

制作帐票万变不离其宗的7步骤                        
     命名 REPORT   ZKT7STEPS                     
     定义 
          該当帳票のタイプ定義                     
          TYPES:    BEGIN OF ty_stu,                    
                         ID TYPE CHAR3,           "データエレメント = データタイプ＋長さ＋名前"            
                         NAME TYPE CHAR30,                    
                         CLASS TYPE C,                    
                         BIR TYPE D,                    
                    END OF ty_stu.                    

          変数定義                     
          DATA: GDF_ID TYPE CHAR3,          "変数"          
               GDW_STU TYPE ty_stu,          "构造"          
               GDT_STU TYPE TABLE OF ty_stu.          "内表"          
                                             
          定数定義（数字、英字、符号）
          CONSTANTS:GCF_PI TYPE P DECIMALS 5 VALUE '3.14159'
                    GCF_W TYPE CHAR VLAUE 'WTO'
                    GDF_NUM = 5 * GCF_PI.
                    GDF_ID = 'WTO'.

          指针定義
          FIELD-SYMBOLS: <FS_STU> TYPE TY_STU.
          
     選択画面                                      "选择画面项目设定テキスト：ジャンプ–テキストエレメント−選択テキスト
          PARAMETERS:    P_ID TYPE CHAR3.         "头文字P代表画面
          SELECT-OPTIONS:S_ID FOR GDF_ID          "用FOR后面放一个变量     除了ラジオボタン、
                                                                        "チェックボックス外基本都可以

     初期处理
          在选择画面还没出来之前做的初期处理
          INITIALIZATION.
               変数初期化
                    CLEAR: GF_XX, GS_STU.
               初期値設定
                    P_ID = '001'.
          
     入力チェック
          AT SELECTION-SCREEN.
          必須入力チェック    IF P_ID IS INITAL. MESSAGE E001(00) WITH 'エラー'. ENDIF.
          存在チェック        一般是用sql检索
          組合チェック        

     主処理
          START-OF-SELECTION.
               PERFORM GET_DATA.        "执行GET_DATA这个子处理"
               PERFORM EDIT_DATA.       "编辑处理-循环，判断，编辑，计算"
               PERFORM OUT_DATA.        "数据出力-下载"
          END-OF-SELECTION.

     子処理（サブルーチン）
          取数据
               1. DB里的数据用SQL取
               2.本地文件用汎用モジュール
               3.服务器文件用汎用モジュール
               
          取DB的数据

               FORM GET_DATA.

               取DB的数据到内表里：
               data: GDT_ZTSTU type table of ZTSTU.         "GDT_ZTSTU是内表 参照的是ZTSTU"
               types:    begin of ty_stu,                   "检索结果只有两个项目 所以只定义id name"      
                              id   type zeid,               
                              name type zename,
                         end of ty_stu.
               SELECT id name                               "項目ID"
                    INTO TABLE GDT_ZTSTU                    "插入到内表"
                    FROM ZTSTU.                             "DB TABLE"

               取DB的数据到构造里：
               data: GDW_ZTSTU type table of ty_stu.
                    SELECT SINGLE id name                   "SINGLE代表只检索一条数据（指定Key）" 
                         INTO TABLE GDW_ZTSTU               "插入到构造（也可以取单个数据到变量里）"
                         FROM ZTSTU               
                         "UP 1 ROWS"                        "只取一条数据的情况"
                    WHERE ID = '001'.

               ENDFORM.

          数据编辑
               FORM EDIT_DATA.
                    LOOP AT GDT_ZTSTU INTO GW_ZTSTU.
                         READ TABLE GT_CLASS INTO GS_CLASS           "READ是表结合用？？？"
                              WITH KEY CLASS = GW_ZTSTU-CLASS.       "结合条件？？？"
                         GW_OUT-TEACHER = GW_CLASS-TEACHER.
                         GW_OUT-ID = GW_ZTSTU-ID.
                         GW_OUT-NAME = GW_ZTSTU-NAME. 
                         IF GW_ZTSTU-SCORE >= 60.
                              GW_OUT-SCORE = GW_ZTSTU-SCORE.
                              APPEND GW_OUT TO GT_OUT.
                         ENDIF.
                    ENDLOOP.
               ENDFORM.

          数据出力
               1. WRITE            report
               2. Download         file
               3. ALV              report
               4. SMARTFORM        pdf
               5. DYNPRO           売掛金／未収金
               6. Dbtable          登録　アドオンテーブル用INSERT UPDATE/標準テーブル用BDC，BAPI

               用WRITE画表格：
               FORM OUT_DATA.
                    WRITE:    /(10) SY-ULINE,     "第一行的横线"
                              / SY-VLINE,         "第二行的竖线"
                              '学生ID' COLOR 6 INVERSE ON ,      "第二行的文字和颜色"
                                                                 "没有INVERSE ON是背景色"
                              SY-VLINE,
                              /(10) SY-ULINE.
               ENDFORM.

               




