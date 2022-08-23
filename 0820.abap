得意先ーーお客さん
面试需要 背模块的业务流程

ALVレポートはALV汎用モジュールを呼び出して、実現できます。
ALV実現方式
1.REUSE_ALV_LIST_DISPLAY    (FUNCTION)照会用
※ 2.REUSE_ALV_GRID_DISPLAY    (FUNCTION)照会用
※ 3.REUSE_ALV_GRID_DISPLAY_LVC    (FUNCTION)照会/更新用
4.CL_GUI_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY  (METHOD)照会用
5.CL_GUI_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY  (METHOD)照会用

LVC_FIELDCATALOG_MERGE 修改单个表的構造情報 单表的情况下比较方便

LOOP AT GDT_FIELDCAT ASSIGNING <fs_fcat> .  "使用指针的写法，指针是内表里其中一个地址
    <fs_fcat>-coltext = '学生点数'.          "改变指针也会直接改内表
ENDLOOP.

LOOP AT GDT_FIELDCAT INTO GDW_FIELDCAT .  "使用构造的写法，构造和内表是完全无关的两个变量
    MODIFY GDT_FIELDCAT FROM GDW_FIELDCAT. "构造的变化无法直接反应到内表里,要用modify反向反应到内表
ENDLOOP.