select strftime('%Y-%m', date) as month_1, 
		round(sum(scrap_softness)* 1.0 / sum(total_scrap) * 100, 2) as scrap_softness_pct, 
		round(sum(scrap_overlap)* 1.0 / sum(total_scrap) * 100, 2) as scrap_overlap_pct, 
		round(sum(scrap_welding)* 1.0 / sum(total_scrap) * 100, 2) as scrap_welding_pct, 
		round(sum(scrap_deformation)* 1.0 / sum(total_scrap) * 100, 2) as scrap_deformation_pct, 
		round(sum(scrap_holes)* 1.0 / sum(total_scrap) * 100, 2) as scrap_holes_pct, 
		round(sum(scrap_rubber)* 1.0 / sum(total_scrap) * 100, 2) as scrap_rubber_pct, 
		round(sum(scrap_tube)* 1.0 / sum(total_scrap) * 100, 2) as scrap_tube_pct
from main_table 
group by month_1

