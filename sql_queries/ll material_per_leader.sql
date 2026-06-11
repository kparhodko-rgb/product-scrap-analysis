with raw as (select PO_number, 
			strftime('%Y-%m', date) as month,
			sum(total_scrap) total_scrap, 
			SUM(OK_qty) + SUM(total_scrap) as qty_po,
			ROUND(SUM(total_scrap) * 1.0 / (SUM(total_scrap) + SUM(OK_qty)) * 100, 2) AS scrap_percent
		from main_table mt 
		group by month, PO_number
		having qty_po>1000),
	rank_top as (select *
		from raw rm
		left join write_off wo on wo.PO_number=rm.PO_number),
	shift_scan as (select distinct rt.PO_number, 
			rt.month, 
			scrap_percent, 
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
select scan_leader, round(avg(pct_of_month),2) AS avg_pct_prd
from (select month , scan_leader, boxes_scanned,
Round (boxes_scanned*1.0/sum(boxes_scanned) over (Partition by month)*100,2) as pct_of_month
from scrap_per_month)
group by scan_leader

