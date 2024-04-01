REPORT ZEMPLOYEE_PERFORMANCE_REPORT.


DATA: gt_employee_production TYPE TABLE OF zemployee_info,
      gt_employee_marketing TYPE TABLE OF zemployee_info,
      gt_employee_trade TYPE TABLE OF zemployee_info,
      gt_employee_finance TYPE TABLE OF zemployee_info,
      gt_employee_design TYPE TABLE OF zemployee_info,
      gt_performance_production TYPE TABLE OF zemployee_performance,
      gt_performance_marketing TYPE TABLE OF zemployee_performance,
      gt_performance_trade TYPE TABLE OF zemployee_performance,
      gt_performance_finance TYPE TABLE OF zemployee_performance,
      gt_performance_design TYPE TABLE OF zemployee_performance,
      gt_combined TYPE TABLE OF zcombined_data,
      gv_total_employees TYPE i.

TYPES: BEGIN OF ty_combined_data,
         pernr TYPE p LENGTH 8,
         ad TYPE string,
         soyad TYPE string,
         yas TYPE i,
         departman TYPE string,
         maas TYPE p LENGTH 8 DECIMALS 2,
         performans TYPE i,
       END OF ty_combined_data.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE text-001.
PARAMETERS: p_department TYPE zdepartment_info-department.
SELECTION-SCREEN END OF BLOCK block1.

* Start of selection
START-OF-SELECTION.
  PERFORM get_employee_data_production.
  PERFORM get_employee_data_marketing.
  PERFORM get_employee_data_inttrade.
  PERFORM get_employee_data_finance.
  PERFORM get_employee_data_design.
  PERFORM get_performance_data_production.
  PERFORM get_performance_data_marketing.
  PERFORM get_performance_data_trade.
  PERFORM get_performance_data_finance.
  PERFORM get_performance_data_design.
  PERFORM combine_data.
  PERFORM display_data.

FORM get_employee_data_production.
  SELECT * FROM zemployee_info INTO TABLE @gt_employee_production
    WHERE department = 'Production'.
ENDFORM.


FORM get_employee_data_marketing.
  SELECT * FROM zemployee_info INTO TABLE @gt_employee_marketing
    WHERE department = 'Marketing'.
ENDFORM.


FORM get_employee_data_trade.
  SELECT * FROM zemployee_info INTO TABLE @gt_employee_trade
    WHERE department = 'Trade'.
ENDFORM.


FORM get_employee_data_finance.
  SELECT * FROM zemployee_info INTO TABLE @gt_employee_finance
    WHERE department = 'Finance'.
ENDFORM.

FORM get_employee_data_design.
  SELECT * FROM zemployee_info INTO TABLE @gt_employee_design
    WHERE department = 'Design'.
ENDFORM.

FORM get_performance_data_production.
  SELECT * FROM zemployee_performance INTO TABLE @gt_performance_production
    WHERE pernr IN gt_employee_production-pernr.
ENDFORM.

FORM get_performance_data_marketing.
  SELECT * FROM zemployee_performance INTO TABLE @gt_performance_marketing
    WHERE pernr IN gt_employee_marketing-pernr.
ENDFORM.

FORM get_performance_data_trade.
  SELECT * FROM zemployee_performance INTO TABLE @gt_performance_trade
    WHERE pernr IN gt_employee_trade-pernr.
ENDFORM.

FORM get_performance_data_finance.
  SELECT * FROM zemployee_performance INTO TABLE @gt_performance_finance
    WHERE pernr IN gt_employee_finance-pernr.
ENDFORM.

FORM get_performance_data_design.
  SELECT * FROM zemployee_performance INTO TABLE @gt_performance_design
    WHERE pernr IN gt_employee_design-pernr.
ENDFORM.

FORM combine_data.
  CLEAR gt_combined.
  LOOP AT gt_employee_production INTO DATA(ls_employee).
    LOOP AT gt_performance_production INTO DATA(ls_performance)
      WHERE pernr = ls_employee-pernr.
      APPEND INITIAL LINE TO gt_combined ASSIGNING FIELD-SYMBOL(<fs_combined>).
      <fs_combined>-pernr = ls_employee-pernr.
      <fs_combined>-ad = ls_employee-ad.
      <fs_combined>-soyad = ls_employee-soyad.
      <fs_combined>-yas = ls_employee-yas.
      <fs_combined>-departman = ls_employee-departman.
      <fs_combined>-maas = ls_employee-maas.
      <fs_combined>-performans = ls_performance-performans.
    ENDLOOP.
  ENDLOOP.
ENDFORM.


FORM display_data.
  CLEAR gv_total_employees.
  LOOP AT gt_combined INTO DATA(ls_combined).
    WRITE: / 'Personel Numarası:', ls_combined-pernr,
           / 'Ad:', ls_combined-ad,
           / 'Soyad:', ls_combined-soyad,
           / 'Yaş:', ls_combined-yas,
           / 'Departman:', ls_combined-departman,
           / 'Maaş:', ls_combined-maas,
           / 'Performans:', ls_combined-performans.
    ADD 1 TO gv_total_employees.
  ENDLOOP.
  WRITE: / 'Toplam Çalışan Sayısı:', gv_total_employees.
ENDFORM.