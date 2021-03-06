view: monthly_active_users_explore_extender {}#dummy base view
explore: monthly_active_users_explore_extender {
  extension: required
  join: monthly_active_users_config {
    type: cross
    relationship: one_to_many
  }
  query: monthly_active_users_by_day {
    description: "Load or Turtle with dimensions selected.  Do not use with other measures"
    dimensions: [monthly_active_users_config.monthly_active_users_measurement_date]
    measures: [monthly_active_users_config.monthly_active_users]
  }
}

view: monthly_active_users_config {
  view_label: "Monthly Active Users"
  derived_table: {
    sql:
    select 0 as days_to_add union all
    select 1 as days_to_add union all
    select 2 as days_to_add union all
    select 3 as days_to_add union all
    select 4 as days_to_add union all
    select 5 as days_to_add union all
    select 6 as days_to_add union all
    select 7 as days_to_add union all
    select 8 as days_to_add union all
    select 9 as days_to_add union all
    select 10 as days_to_add union all
    select 11 as days_to_add union all
    select 12 as days_to_add union all
    select 13 as days_to_add union all
    select 14 as days_to_add union all
    select 15 as days_to_add union all
    select 16 as days_to_add union all
    select 17 as days_to_add union all
    select 18 as days_to_add union all
    select 19 as days_to_add union all
    select 20 as days_to_add union all
    select 21 as days_to_add union all
    select 22 as days_to_add union all
    select 23 as days_to_add union all
    select 24 as days_to_add union all
    select 25 as days_to_add union all
    select 26 as days_to_add union all
    select 27 as days_to_add union all
    select 28 as days_to_add union all
    select 29 as days_to_add
        ;;
  }
  #to be overridden
  dimension: user_id__input_field {sql:;;label:"User ID" hidden:yes type:number}
  dimension: activation_event__input_date_field {type:date  sql:;;label:"Activation Event Date" hidden:yes datatype:date}
  #optional
  dimension: activation_event__criteria {sql:1=1;;label:"Activation Criteria Met" hidden:yes type:yesno}

  #the magic fields from this view
  dimension: days_to_add {hidden:yes type:number label:"Activity Days Prior To Period End Date"}
  dimension: monthly_active_users_measurement_date {
    hidden: yes
    convert_tz: no
    type: date
    datatype: date
    sql: date_add(${activation_event__input_date_field}, INTERVAL ${days_to_add} DAY) ;;
  }

  # dimension: appeared_on_monthly_active_users_measurement_date {
  #   hidden: yes
  #   group_label: "Period Membership Flags"
  #   type: yesno
  #   sql: ${days_to_add}=0 ;;
  # }
  # dimension: appeared_within_week_of_end_date {
  #   hidden: yes
  #   group_label: "Period Membership Flags"
  #   type: yesno
  #   sql: ${days_to_add}<7 ;;
  # }
  dimension: appeared_within_thirty_days_leading_up_to_measurement_date {
    hidden: yes
    type: yesno
    sql: ${days_to_add}<30 ;;
  }
  measure: monthly_active_users {
    hidden: yes
    type: count_distinct
    sql: ${user_id__input_field} ;;
    # filters: [appeared_within_thirty_days_leading_up_to_measurement_date: "Yes"]
    filters: [activation_event__criteria: "Yes"]
    # drill_fields: [monthly_active_users_config.user_id__input_field,activation_event__input_date_field,one_day_added_for_timeline_end]
    link: {
      label: "Daily Timeline By User"
      url: "{{monthly_active_users_drill_fields._link}}{{drill_config_string._sql}}"
    }
  }

  #########
  ##primarily for drill to viz suppport
  dimension: one_day_added_for_timeline_end {
    hidden: yes
    convert_tz: no
    type: date
    datatype: date
    sql: date_add(${activation_event__input_date_field}, INTERVAL 1 DAY) ;;
  }
  # dimension: one_hour_added_for_timeline_end {
  #   hidden: yes
  #   type: date_hour
  #   sql: timestamp_add(${activation_event__input_date_field}, INTERVAL 1 HOUR) ;;
  # }
  measure: monthly_active_users_drill_fields {
    hidden: yes
    type: count_distinct
    sql: ${user_id__input_field} ;;
    filters: [activation_event__criteria: "Yes"]
    drill_fields: [monthly_active_users_config.user_id__input_field,activation_event__input_date_field,one_day_added_for_timeline_end]
  }
  dimension: drill_config_string {
    hidden: yes
    sql:
        &sorts=dau_wau_mau_support.user_id__input_field+desc
        &limit=5000
        &vis=%7B%22groupBars%22%3Atrue%2C%22labelSize%22%3A%2210pt%22%2C%22showLegend%22%3Atrue%2C%22color_application%22%3A%7B%22collection_id%22%3A%221297ec12-86a5-4ae0-9dfc-82de70b3806a%22%2C%22custom%22%3A%7B%22id%22%3A%224c333a3f-d655-ef67-55f6-619f4d9f879c%22%2C%22label%22%3A%22Custom%22%2C%22type%22%3A%22continuous%22%2C%22stops%22%3A%5B%7B%22color%22%3A%22%2398c1ff%22%2C%22offset%22%3A0%7D%2C%7B%22color%22%3A%22%23f75ad8%22%2C%22offset%22%3A50%7D%2C%7B%22color%22%3A%22%23fa4147%22%2C%22offset%22%3A100%7D%5D%7D%2C%22options%22%3A%7B%22steps%22%3A5%2C%22reverse%22%3Atrue%7D%7D%2C%22type%22%3A%22looker_timeline%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C%22show_null_points%22%3Atrue%2C%22interpolation%22%3A%22linear%22%2C%22defaults_version%22%3A1%2C%22series_types%22%3A%7B%7D%2C%22hidden_fields%22%3A%5B%5D%7D
        &toggle=vis,vse;;
  }
  # measure: count_distinct_activity_times {
  #   hidden: yes
  #   type: count_distinct
  #   sql:${activation_event__input_date_field} ;;
  # }
  # ##### End drill helpers

}
