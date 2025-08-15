#conda activate r-ResDisMapper.1.1 
# library(ResDisMapper)

gen <- 'Example_datasets/Pigeon.gen'
coordinates <- 'Example_datasets/Pigeon.coordinates'
outdir <- 'example_result'
# 自动创建输出文件夹（如不存在）
if (!dir.exists(outdir)) {
  dir.create(outdir, recursive = TRUE)
}

source("R/rdm_IBD_v8_TF.R")
pdf(paste(outdir, "IBD.pdf", sep = "/"))
IBD.res <- rdm_IBD(Gen_raw = gen, Geo_raw = coordinates,
    Dist_method = 4, IBD_method = 1)
dev.off()


source("R/rdm_residual_v11_TF_TQ.R") #修改，保存3D图
Res_SLDF <- rdm_residual(IBD.res = IBD.res, Geo_raw = coordinates,
    min.dist = 1, max.dist = 10000, n_resolution = 50, proj = sp::CRS("+init=epsg:4326"),
    outputfile = paste(outdir, "residuals_3d.html", sep = "/"))



source("R/rdm_resistance_v11_TF_TQ.R")
F.df <- rdm_resistance(IBD.res = IBD.res, Res_SLDF = Res_SLDF, nrows = 25, ncols = 50,
    conf_intervals = 0.95, random_rep = 1000, outputfile = paste(outdir, "resistance_map.csv", sep = "/"))



source("R/rdm_mapper_v9_TF_TQ.R") #修改，返回ggplot对象
p <- rdm_mapper(F.df = F.df, Geo_raw = coordinates, p_signf = 0.05, p_size = 2,
    p_col = "black", disp_all_cells = 0, disp_contours = 1)
ggplot2::ggsave(filename = paste(outdir, "resistance_map.pdf", sep = "/"), plot = p, width = 16, height = 8)


