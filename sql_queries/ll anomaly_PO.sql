with raw as (select PO_number, 
			strftime('%Y-%m', date) as month,
			sum(total_scrap) total_scrap, 
			SUM(OK_qty) + SUM(total_scrap) as qty_po,
			ROUND(SUM(total_scrap) * 1.0 / (SUM(total_scrap) + SUM(OK_qty)) * 100, 2) AS scrap_percent
		from main_table mt 
		group by month, PO_number
		having qty_po>1000),
	rank_month as (select *, 
			rank () over (PARTITION by month order by scrap_percent desc) as rank_scrap
		from raw),
	rank_top as (select *
		from rank_month rm
		left join write_off wo on wo.PO_number=rm.PO_number
		where rank_scrap<=3),
	shift_scan as (select distinct rt.PO_number, 
			rt.month, 
			scrap_percent, 
			rank_scrap, 
			rt.part_number, 
			rt.pallet_label, 
			rt.shift as production_shift,
			thr.scan_leader,
			thr.scan_shift,
			thr.box_label
		from rank_top rt
		left join thrm_material thr on thr.pallet_label=rt.pallet_label),
	scrap_per_month as (select 
			month ,
			scan_leader, 
			count(distinct box_label) as boxes_scanned
		from shift_scan
		group by month, scan_leader
		order by month)
select *
from scrap_per_month





