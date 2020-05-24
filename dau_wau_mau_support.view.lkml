view: dau_wau_mau_explore_to_be_extended {}#dummy base view
explore: dau_wau_mau_explore_to_be_extended {
  query: daily_active_users_by_day {
    description: "Load or Turtle with dimensions selected.  Do not use with other measures"
    dimensions: [dau_wau_mau_support.period_end_date]
    measures: [dau_wau_mau_support.dau]
  }
  query: weeky_active_users_by_day {
    description: "Load or Turtle with dimensions selected.  Do not use with other measures"
    dimensions: [dau_wau_mau_support.period_end_date]
    measures: [dau_wau_mau_support.wau]
  }
  query: monthly_active_users_by_day {
    description: "Load or Turtle with dimensions selected.  Do not use with other measures"
    dimensions: [dau_wau_mau_support.period_end_date]
    measures: [dau_wau_mau_support.mau]
  }

  query: daily_and_monthly_active_users_by_day {
    description: "Load or Turtle with dimensions selected.  Do not use with other measures"
    dimensions: [dau_wau_mau_support.period_end_date]
    measures: [dau_wau_mau_support.mau,dau_wau_mau_support.dau]
  }

  extension: required
  join: dau_wau_mau_support {
    type: cross
    relationship: one_to_many
    sql_where:${dau_wau_mau_support.date_to_use__input_field}<current_timestamp;; #assumes there's data up through yesterday only
  }
}

view: dau_wau_mau_support {
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
  dimension: user_id__input_field {sql:;;label:"User ID"hidden:yes type:number}
  dimension: date_to_use__input_field {sql:;;label:"Activity Date" hidden:yes}

  #the magic fields from this view
  dimension: days_to_add {hidden:yes}
  dimension: period_end_date {
    hidden: yes
    type: date
    sql: timestamp_add(${date_to_use__input_field}, INTERVAL ${days_to_add} DAY) ;;
  }

  dimension: appeared_on_period_end_date {
    hidden: yes
    group_label: "Period Membership Flags"
    type: yesno
    sql: ${days_to_add}=0 ;;
  }
  dimension: appeared_within_week_of_end_date {
    hidden: yes
    group_label: "Period Membership Flags"
    type: yesno
    sql: ${days_to_add}<7 ;;
  }
  dimension: appeared_within_30_days {
    hidden: yes
    group_label: "Period Membership Flags"
    type: yesno
    sql: ${days_to_add}<30 ;;
  }

  measure: dau {
    hidden: yes
    type: count_distinct
    sql: ${user_id__input_field} ;;
    filters: [appeared_on_period_end_date: "Yes"]
    drill_fields: [dau_wau_mau_support.user_id__input_field,count_distinct_activity_times,date_used_hour,one_hour_added_for_timeline_end]
    link: {
      label: "Hourly Timeline By User"
      url: "{{dau._link}}{{drill_config_string._sql}}"
    }
  }
  measure: wau {
    hidden: yes
    type: count_distinct
    sql: ${user_id__input_field} ;;
    filters: [appeared_within_week_of_end_date: "Yes"]
    drill_fields: [dau_wau_mau_support.user_id__input_field,count_distinct_activity_times,date_used_date,one_day_added_for_timeline_end]
    link: {
      label: "Daily Timeline By User"
      url: "{{wau._link}}{{drill_config_string._sql}}"
    }
  }
  measure: mau {
    hidden: yes
    type: count_distinct
    sql: ${user_id__input_field} ;;
    filters: [appeared_within_30_days: "Yes"]
    drill_fields: [dau_wau_mau_support.user_id__input_field,count_distinct_activity_times,date_used_date,one_day_added_for_timeline_end]
    link: {
      label: "Daily Timeline By User"
      url: "{{mau._link}}{{drill_config_string._sql}}"
    }
  }


#########
##primarily for drill to viz suppport
  dimension_group: date_used {
    hidden: yes
    type: time
    timeframes: [raw,hour,date]
    sql: ${date_to_use__input_field} ;;
  }
  dimension: one_day_added_for_timeline_end {
    hidden: yes
    type: date
    sql: timestamp_add(${date_to_use__input_field}, INTERVAL 1 DAY) ;;
  }
  dimension: one_hour_added_for_timeline_end {
    hidden: yes
    type: date_hour
    sql: timestamp_add(${date_to_use__input_field}, INTERVAL 1 HOUR) ;;
  }
  dimension: drill_config_string {
    hidden: yes
    sql:
      &sorts=dau_wau_mau_support.user_id__input_field+desc
      &limit=5000
      &vis=%7B%22groupBars%22%3Atrue%2C%22labelSize%22%3A%2210pt%22%2C%22showLegend%22%3Atrue%2C%22color_application%22%3A%7B%22collection_id%22%3A%221297ec12-86a5-4ae0-9dfc-82de70b3806a%22%2C%22custom%22%3A%7B%22id%22%3A%224c333a3f-d655-ef67-55f6-619f4d9f879c%22%2C%22label%22%3A%22Custom%22%2C%22type%22%3A%22continuous%22%2C%22stops%22%3A%5B%7B%22color%22%3A%22%2398c1ff%22%2C%22offset%22%3A0%7D%2C%7B%22color%22%3A%22%23f75ad8%22%2C%22offset%22%3A50%7D%2C%7B%22color%22%3A%22%23fa4147%22%2C%22offset%22%3A100%7D%5D%7D%2C%22options%22%3A%7B%22steps%22%3A5%2C%22reverse%22%3Atrue%7D%7D%2C%22type%22%3A%22looker_timeline%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C%22show_null_points%22%3Atrue%2C%22interpolation%22%3A%22linear%22%2C%22defaults_version%22%3A1%2C%22series_types%22%3A%7B%7D%2C%22hidden_fields%22%3A%5B%5D%7D
      &toggle=vis,vse;;
  }
  measure: count_distinct_activity_times {
    hidden: yes
    type: count_distinct
    sql:${date_to_use__input_field} ;;
  }
##### End drill helpers

}
