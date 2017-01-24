#!/usr/bin/Rscript

#
# # Dénes Türei EMBL-EBI 2017
#

require(ggplot2)
require(reshape2)
require(ggdendro)

inFile <- 'fctop_none.csv'
fctop <- read.table(inFile, header = TRUE, sep = '\t')

fctop <- fctop[, names(fctop) != 'resnum']

fctop.m <- melt(fctop)

fctop.m$label <- factor(fctop$label, levels = unique(as.character(fctop$label)))

fctop.m['logfc'] <- sign(fctop.m$value) * log2(abs(fctop.m$value)) / max(log2(abs(fctop.m$value)))

p <- ggplot(fctop.m, aes(variable, label)) +
    geom_tile(aes(fill = logfc)) +
    scale_fill_gradient2(low = 'orangered3', mid = 'white', high = 'steelblue') +
    xlab('Treatment') +
    ylab('Phosphorylation sites') +
    theme(
        axis.text.y = element_text(size = 4),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_blank()
    )

ggsave('gg_fcdiff_top_heatmap.pdf', device = cairo_pdf, width = 4, height = 48)

# Only top 50:

fctop50 <- head(fctop, 111)
rnames <- fctop50$psite
rownames(fctop50) <- rnames
mfctop50 <- as.matrix(fctop50[,6:8])
rownames(mfctop50) <- rnames
psites_dendro <- as.dendrogram(hclust(dist(mfctop50)))
ordr <- order.dendrogram(psites_dendro)
ofctop50 <- fctop50[ordr,]
onames <- attr(ofctop50, 'dimnames')

fctop.m <- melt(fctop50)

fctop.m$psite <- factor(fctop50$psite, levels = unique(as.character(fctop50$psite)))

fctop.m['logfc'] <- sign(fctop.m$value) * log2(abs(fctop.m$value)) / max(log2(abs(fctop.m$value)))


p <- ggplot(fctop.m, aes(variable, psite)) +
geom_tile(aes(fill = logfc)) +
scale_fill_gradient2(low = 'orangered3', mid = 'white', high = 'steelblue') +
xlab('Treatment') +
ylab('Phosphorylation sites') +
theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.background = element_blank()
    )

ggsave('gg_fcdiff_top50_heatmap.pdf', device = cairo_pdf, width = 6, height = 14)

### top heatmap with dendrogram

headfctop <- head(fctop, 100)
rnames <- headfctop$label
rownames(headfctop) <- rnames
mheadfctop <- as.matrix(headfctop[,8:10])
rownames(mheadfctop) <- rnames
psites_dendro <- as.dendrogram(hclust(dist(mheadfctop / apply(abs(mheadfctop), 1, max))))
ordr <- order.dendrogram(psites_dendro)
oheadfctop <- mheadfctop[ordr,]
onames <- attr(oheadfctop, 'dimnames')
dfheadfctop <- as.data.frame(oheadfctop)
colnames(dfheadfctop) <- onames[[2]]
dfheadfctop$psite <- onames[[1]]
dfheadfctop$psite <- with(dfheadfctop, factor(psite, levels = psite, ordered = TRUE))
mltdfheadfctop <- melt(dfheadfctop, id.vars = 'psite')
dendrodatapsite <- dendro_data(psites_dendro)

# Set up a blank theme
theme_none <- theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.title.x = element_text(colour = NA),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = unit(c(0, 0, 0, 0), 'cm')
)

# Heatmap
p1 <- ggplot(mltdfheadfctop, aes(x = variable, y = psite)) +
    geom_tile(aes(fill = value)) +
    scale_fill_gradient2(high = '#990000', mid = 'white', low = '#333333', name = 'Fold change (log2)') +
    theme(legend.position = 'left') +
    xlab('Treatment') +
    ylab('Phosphorylation site') +
    #guides(fill = guide_legend(title = 'Fold change (log2)')) +
    theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_blank()
        )

p3 <- ggplot(segment(dendrodatapsite)) +
    geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) +
    #scale_y_continuous(limits = c(0, 100)) +
    scale_x_continuous(limits = c(0, 100)) +
    coord_flip(xlim = c(0, 100)) +
    theme_none

cairo_pdf(filename = 'gg_heatmap_dendro.pdf', width = 8, height = 14)
    grid.newpage()
    print(p1, vp=viewport(0.8, 1.0, x=.4, y=.5))
    print(p3, vp=viewport(0.2, 1.076, x=0.88, y=0.498))
dev.off()
