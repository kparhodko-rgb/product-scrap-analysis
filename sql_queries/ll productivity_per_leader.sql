select team_leader,
    strftime('%Y-%m', date) as month,
    sum(OK_qty) as total_ok,
    round(sum(OK_qty) * 1.0 / sum(sum(OK_qty)) over (partition by strftime('%Y-%m', date)) * 100, 2) as ok_pct,
    sum(total_scrap) as total_scrap,
    round(sum(total_scrap) * 1.0 / sum(OK_qty) * 100, 2) as scrap_to_ok_pct
from main_table
group by team_leader, month
order by month, team_leader