*&---------------------------------------------------------------------*
*& Report  ZKHOMEWORE0723                                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Joinではなくread tableで複数テーブルを結合する練習                        *
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  zkhomewore0723                          .

TYPES: BEGIN OF ty_out,
          id      TYPE zeid,
          name    TYPE zename,
          class   TYPE zeclass,
          classname TYPE zeclassname,
       END OF ty_out,
       BEGIN OF ty_stu,
          id        TYPE zeid,
          name      TYPE zename,
          class      TYPE zeclass,
       END OF ty_stu,
       BEGIN OF ty_class,
          class      TYPE zeclass,
          classname  TYPE zeclassname,
       END OF ty_class.
DATA:   gdt_stu TYPE TABLE OF ty_stu,       "可以直接定义为DB表的type,但没用到的项目会浪费内存,最好用TYPES
        gdw_stu TYPE ty_stu,
        gdt_class TYPE TABLE OF ty_class,
        gdw_class TYPE ty_class,
        gdt_out TYPE TABLE OF ty_out,
        gdw_out TYPE ty_out.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM edit_data.
  PERFORM out_data.

END-OF-SELECTION.

*&--------------------------------------------------------------------*
*&      Form  get_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM get_data.
  DATA: ldt_stu TYPE TABLE OF ty_stu.

  SELECT 
        id
        name
        class
      INTO TABLE gdt_stu                "把ztstu的内容放到内表
      FROM ztstu.
                                        "排序和去重是一个组合，这里去重的意义在于
                                        "gdt_stu和gdt_class结合的时候 条件是class
                                        "如果gdt_stu不去重的话会产生无数个class会浪费内存
                                        "所以做表结合的时候必须去重
  IF SY-SUBRC = 0.
    ldt_stu = gdt_stu.
    SORT ldt_stu
      BY class.
    DELETE ADJACENT DUPLICATES FROM ldt_stu
      COMPARING class.
  ENDIF.
                                        "把ztclass的内容放到内表gdt_class里
  IF ldt_stu IS NOT INITIAL.            "判断该内表不为空
    SELECT
        class
        classname
    INTO TABLE gdt_class
    FROM ztclass
        FOR ALL ENTRIES IN ldt_stu      "该select可以使用指定内表里项目的值做条件
  WHERE
      class = ldt_stu-class.            "条件为与内表gdt_stu.class相同的class，顺序不能换会报错
  ENDIF.
ENDFORM.                    "get_data

*&--------------------------------------------------------------------*
*&      Form  edit_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM edit_data.                         "结合两个内表的内容放到第三个内表gdt_out
  LOOP AT gdt_stu INTO gdw_stu.
    gdw_out-id = gdw_stu-id.
    gdw_out-name = gdw_stu-name.
    gdw_out-class = gdw_stu-class.
    CLEAR:gdw_class.                    "在loop里 使用的临时变量，构造变量，都要在赋值前清空
    READ TABLE gdt_class INTO gdw_class       "只能从内表取出一条数据
        WITH KEY class = gdw_stu-class.                       "read table的条件
    gdw_out-classname = gdw_class-classname.
    APPEND gdw_out TO gdt_out.
  ENDLOOP.
ENDFORM.                    "edit_data

*&--------------------------------------------------------------------*
*&      Form  out_data
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM out_data.
  LOOP AT gdt_out INTO gdw_out.
    WRITE:/ gdw_out-id,
            gdw_out-name,
            gdw_out-class,
            gdw_out-classname.
  ENDLOOP.
ENDFORM.                    "out_data