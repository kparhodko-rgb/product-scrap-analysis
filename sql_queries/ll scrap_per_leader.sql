with raw as (
    select PO_number,
        strftime('%Y-%m', date) as month,
        sum(total_scrap) total_scrap,
        sum(OK_qty) + sum(total_scrap) as qty_po,
        round(sum(total_scrap) * 1.0 / (sum(total_scrap) + sum(OK_qty)) * 100, 2) as scrap_percent,
        sum(scrap_softness) as scrap_softness,
        sum(scrap_overlap) as scrap_overlap,
        sum(scrap_welding) as scrap_welding,
        sum(scrap_deformation) as scrap_deformation,
        sum(scrap_holes) as scrap_holes,
        sum(scrap_rubber) as scrap_rubber,
        sum(scrap_tube) as scrap_tube
    from main_table mt
    group by month, PO_number
),
rank_top as (
    select *
    from raw rm
    left join write_off wo on wo.PO_number = rm.PO_number
),
shift_scan as (
    select distinct rt.PO_number,
        rt.month,
        rt.scrap_percent,
        rt.scrap_softness,
        rt.scrap_overlap,
        rt.scrap_welding,
        rt.scrap_deformation,
        rt.scrap_holes,
        rt.scrap_rubber,
        rt.scrap_tube,
        rt.total_scrap,
        rt.part_number,
        rt.pallet_label,
        rt.shift as production_shift,
        thr.scan_leader,
        thr.scan_shift,
        thr.box_label
    from rank_top rt
    left join thrm_material thr on thr.pallet_label = rt.pallet_label
)
select scan_leader,
    round(sum(scrap_softness) * 1.0 / sum(total_scrap) * 100, 2) as scrap_softness_pct,
    round(sum(scrap_overlap) * 1.0 / sum(total_scrap) * 100, 2) as scrap_overlap_pct,
    round(sum(scrap_welding) * 1.0 / sum(total_scrap) * 100, 2) as scrap_welding_pct,
    round(sum(scrap_deformation) * 1.0 / sum(total_scrap) * 100, 2) as scrap_deformation_pct,
    round(sum(scrap_holes) * 1.0 / sum(total_scrap) * 100, 2) as scrap_holes_pct,
    round(sum(scrap_rubber) * 1.0 / sum(total_scrap) * 100, 2) as scrap_rubber_pct,
    round(sum(scrap_tube) * 1.0 / sum(total_scrap) * 100, 2) as scrap_tube_pct
from shift_scan
group by scan_leader