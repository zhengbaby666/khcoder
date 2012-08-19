package plotR::som;

use strict;

use kh_r_plot;

sub new{
	my $class = shift;
	my %args = @_;

	my $self = \%args;
	bless $self, $class;

	kh_r_plot->clear_env;

	my $r_command = $args{r_command};
	$args{font_bold} += 1;

	# �ѥ�᡼����������ʬ
	$r_command .= "cex <- $args{font_size}\n";
	$r_command .= "text_font <- $args{font_bold}\n";
	$r_command .= "n_nodes <- $args{n_nodes}\n";
	$r_command .= "if_cls <- $args{if_cls}\n";
	$r_command .= "n_cls <- $args{n_cls}\n";
	$r_command .= "rlen1 <- $args{rlen1}\n";
	$r_command .= "rlen2 <- $args{rlen2}\n";
	
	if ($args{p_topo} eq 'hx'){
		$r_command .= "if_plothex <- 1\n";
	} else {
		$r_command .= "if_plothex <- 0\n";
	}

	my $p1 = $self->r_cmd_p1_hx;
	my $p2 = $self->r_cmd_p2_hx;

	# �ץ��åȺ���
	my @plots = ();
	my $flg_error = 0;

	$plots[0] = kh_r_plot->new(
		name      => $args{plotwin_name}.'_1',
		command_f =>
			 $r_command
			.$p1
			."plot_mode <- \"color\"\n"
			.$p2,
		width     => $args{plot_size},
		height    => $args{plot_size},
	) or $flg_error = 1;

	if ( $args{if_cls} == 1 ){
		$plots[1] = kh_r_plot->new(
			name      => $args{plotwin_name}.'_2',
			command_f =>
				 $r_command
				.$p1
				."plot_mode <- \"gray\"\n"
				.$p2,
			command_a =>
				 "plot_mode <- \"gray\"\n"
				.$p2,
			width     => $args{plot_size},
			height    => $args{plot_size},
		) or $flg_error = 1;
	}

	$plots[2] = kh_r_plot->new(
		name      => $args{plotwin_name}.'_3',
		command_f =>
			 $r_command
			.$p1
			."plot_mode <- \"freq\"\n"
			.$p2,
		command_a =>
			 "plot_mode <- \"freq\"\n"
			.$p2,
		width     => $args{plot_size},
		height    => $args{plot_size},
	) or $flg_error = 1;

	$plots[3] = kh_r_plot->new(
		name      => $args{plotwin_name}.'_4',
		command_f =>
			 $r_command
			.$p1
			."plot_mode <- \"umat\"\n"
			.$p2,
		command_a =>
			 "plot_mode <- \"umat\"\n"
			.$p2,
		width     => $args{plot_size},
		height    => $args{plot_size},
	) or $flg_error = 1;

	$::config_obj->R->send("print( summary(somm) )");
	my $t = $::config_obj->R->read;
	$t =~ s/\x0D\x0A|\x0D|\x0A/\n/g;
	print "-------------------------[Begin]-------------------------[R]\n";
	print "$t\n";
	print "---------------------------------------------------------[R]\n";

	kh_r_plot->clear_env;
	undef $self;
	undef %args;
	$self->{result_plots} = \@plots;
	#$self->{result_info} = $info;
	#$self->{result_info_long} = $info_long;
	
	return 0 if $flg_error;
	return $self;
}

sub r_cmd_p1_hx{
	return '

d <- t(d)
d <- subset(d, rowSums(d) > 0)
#d <- scale(d)
d <- t(d)

# SOM�μ¹�
library(som)
d <- normalize(d)
ti <- system.time(
	somm <- som(
		d,
		n_nodes,
		n_nodes,
		topol="hexa",
		rlen=c(rlen1,rlen2)
	)
)
#print(ti)
#print(somm$rlen)
#print(summary(somm))

# �ʻҤκ�ɸ�����
row2coods <- NULL
eve <- 0
for (i in 0:(n_nodes - 1)){
	for (h in 0:(n_nodes - 1)){
		row2coods <- c(row2coods, h + eve, i)
	}
	if (eve == 0){
		eve <- 0.5
	} else {
		eve <- 0
	}
}
row2coods <- matrix( row2coods, byrow=T, ncol=2  )

# �ʻҤΥ��饹������
if ( if_cls == 1 ){
	library(amap)
	library( RColorBrewer )
	hcl <- hcluster(somm$code, method="euclidean", link="ward")

	colors <- NULL
	if (n_cls <= 9){
		pastel <- brewer.pal(9, "Pastel1")
		pastel[6] = brewer.pal(9, "Pastel1")[9]
		pastel[9] = brewer.pal(9, "Pastel1")[6]
		colors <- pastel[cutree(hcl,k=n_cls)]
	} else {
		colors <- brewer.pal(12, "Set3")[cutree(hcl,k=n_cls)]
	}
} else {
	colors <- rep("gray90", n_nodes^2)
}
labcd <- NULL




';
}

sub r_cmd_p2_hx{

return 
'
# �ץ��åȤμ¹�
par(mai=c(0,0,0,0), mar=c(0,0,0,0), omi=c(0,0,0,0), oma =c(0,0,0,0) )

plot(                                             # �����
	NULL,NULL,
	xlim=c(0,n_nodes-0.5),
	ylim=c(0,n_nodes-1),
	axes=F,
	frame.plot=F
)

if (if_plothex == 1){                             # �ʻҤο�
	a <- 0.333333333333
} else {
	a <- 0.5
}
b <- 1-a

if ( plot_mode == "gray"){                        # �ƥ��顼�⡼�ɤؤ��б�
	color_act  <- rep("gray90",n_nodes^2)
	color_line <- "white"
	if_points  <- 1
}
if ( plot_mode == "color" ) {
	color_act <- colors
	color_line <- "white"
	if_points  <- 1
}
if ( plot_mode == "freq" ){
	color_act <- somm$code.sum$nobs;
	if (max(color_act) == 1){
		color_act <- color_act * 3 + 1;
	} else {
		color_act <- color_act - min(color_act)
		color_act <- round( color_act / max(color_act) * 6 ) + 1
		#color_act[color_act==7] <- 6
	}
	color_seed <- brewer.pal(6,"GnBu")
	#color_seed <- brewer.pal(6,"YlOrRd")
	color_seed <- c("white", color_seed)
	color_act <- color_seed[color_act]
	
	color_line <- "gray80"
	if_points  <- 0
}
if ( plot_mode == "umat" ){
	
	# ��Υ�׻�
	dist_u <- NULL
	
	dist_m <- as.matrix( dist(somm$code, method="euclid") )
	
	for (i in 0:(n_nodes - 1)){
		for (h in 0:(n_nodes - 1)){
			cu <- NULL
			n  <- 0
			
			if (h != n_nodes -1){       # ��
				cu <- c(
					cu, 
					dist_m[
						h     + i * n_nodes + 1,
						h + 1 + i * n_nodes + 1
					]
				)
			}
			
			if (h != 0){                # ��
				cu <- c(
					cu,
					dist_m[
						h     + i * n_nodes + 1,
						h - 1 + i * n_nodes + 1
					]
				)
			}
			
			if (i != n_nodes - 1){
				if (h %% 2 == 0){       # ����ʶ�����
					cu <- c(
						cu,
						dist_m[
							h +   i       * n_nodes + 1,
							h + ( i + 1 ) * n_nodes + 1
						]
					)
				} else {                # ����ʴ����
					if (h != n_nodes -1){
						cu <- c(
							cu,
							dist_m[
								h     +   i       * n_nodes + 1,
								h + 1 + ( i + 1 ) * n_nodes + 1
							]
						)
					}
				}
			}
			
			if (i != 0){
				if (h %% 2 == 0){       # �����ʶ�����
					cu <- c(
						cu,
						dist_m[
							h +   i       * n_nodes + 1,
							h + ( i - 1 ) * n_nodes + 1
						]
					)
				} else {                # �����ʴ����
					if (h != n_nodes -1){
						cu <- c(
							cu,
							dist_m[
								h     +   i       * n_nodes + 1,
								h + 1 + ( i - 1 ) * n_nodes + 1
							]
						)
					}
				}
			}
			
			if (i != n_nodes - 1){
				if (h %% 2 == 0){       # ����ʶ�����
					if (h != 0){
						cu <- c(
							cu,
							dist_m[
								h      +   i       * n_nodes + 1,
								h - 1  + ( i + 1 ) * n_nodes + 1
							]
						)
					}
				} else {                # ����ʴ����
					cu <- c(
						cu,
						dist_m[
							h +   i       * n_nodes + 1,
							h + ( i + 1 ) * n_nodes + 1
						]
					)
				}
			}
			
			if (i != 0){
				if (h %% 2 == 0){       # �����ʶ�����
					if (h != 0){
						cu <- c(
							cu,
							dist_m[
								h      +   i       * n_nodes + 1,
								h - 1  + ( i - 1 ) * n_nodes + 1
							]
						)
					}
				} else {                # �����ʴ����
					cu <- c(
						cu,
						dist_m[
							h +   i       * n_nodes + 1,
							h + ( i - 1 ) * n_nodes + 1
						]
					)
				}
			}
			dist_u <- c(dist_u, median(cu) )
		}
	}
	
	print( summary(dist_u) )
	
	dist_u <- dist_u - min(dist_u)
	dist_u <- round( dist_u / max(dist_u) * 100 ) + 1
	color_act <- cm.colors(101)[dist_u]
	
	color_line <- "gray80"
	if_points  <- 1
}


for (i in 1:n_nodes^2){                           # �Ρ��ɤο�
	x <- row2coods[i,1]
	y <- row2coods[i,2]

	polygon(
		x=c( x + 0.5, x + 0.5, x,     x - 0.5, x - 0.5, x ),
		y=c( y + a,   y - a,   y - b, y - a,   y + a,   y + b ),
		col=color_act[i],
		border="white",
		lty=0,
	)
}


for (i in 0:(n_nodes - 1)){                       # ��������
	for (h in 0:(n_nodes - 2)){
		if ( colors[h + i * n_nodes + 1] == colors[h + i * n_nodes + 2] ){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x + 0.5, y + a,
				x + 0.5, y - a,
				col=color_line,
				lwd=1,
			)
		}
	}
}

for (i in 0:(n_nodes - 1)){                       # ������ξü
	for (h in c(-1, n_nodes-1) ){
		x <- h
		y <- i
		if ( y %% 2 == 1 ){
			x <- x + 0.5
		}
		segments(                       # ����
			x + 0.5, y + a,
			x + 0.5, y - a,
			col=color_line,
			lwd=1,
		)
	}
	if ( y %% 2 == 0 ){
		segments(                       # ��ü1
			-0.5, y + a,
			0   , y + 1 - a,
			col=color_line,
			lwd=1,
		)
		if ( y != 0){
			segments(                   # ��ü2
				-0.5, y - a,
				 0  , y - 1 + a,
				col=color_line,
				lwd=1,
			)
		}
	} else {
		if ( y != n_nodes - 1){
			segments(                   # ��ü1
				n_nodes - 0.5, y + 1 - a,
				n_nodes      , y + a,
				col=color_line,
				lwd=1,
			)
		}
		segments(                       # ��ü2
			n_nodes - 0.5, y - 1 + a,
			n_nodes      , y - a,
			col=color_line,
			lwd=1,
		)
	}
}

for (i in 0:(n_nodes - 2)){                       # ����������
	for (h in 0:(n_nodes - 1)){
		if (i %% 2 == 1){
			chk <- 1
		} else {
			chk <- 0
		}
	
		if (
			   is.na(colors[h +        i    * n_nodes + 1]) == 1
			|| is.na(colors[h + chk + (i+1) * n_nodes + 1]) == 1
			|| h + chk == n_nodes
		){
			next
		}
	
		if ( 
			    colors[h +        i    * n_nodes + 1]
			==  colors[h + chk + (i+1) * n_nodes + 1] 
		){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x,       y + b,
				x + 0.5, y + a,
				col=color_line,
				lwd=1,
			)
		}
	}
}

for (i in 0:(n_nodes - 2)){                       # ����������
	for (h in 0:(n_nodes - 1)){
		if (i %% 2 == 0){
			chk <- 1
		} else {
			chk <- 0
		}
		if (
			   is.na(colors[h +        i    * n_nodes + 1]) == 1
			|| is.na(colors[h - chk + (i+1) * n_nodes + 1]) == 1
			|| h - chk < 0
		){
			next
		}
	
		if ( 
			    colors[h +        i    * n_nodes + 1]
			==  colors[h - chk + (i+1) * n_nodes + 1] 
		){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x,       y + b,
				x - 0.5, y + a,
				col=color_line,
				lwd=1,
			)
		}
	}
}



for (i in 0:(n_nodes - 1)){                       # ���졼����������
	for (h in 0:(n_nodes - 2)){
		if ( colors[h + i * n_nodes + 1] != colors[h + i * n_nodes + 2] ){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x + 0.5, y + a,
				x + 0.5, y - a,
				col="gray60",
				lwd=2,
			)
		}
	}
}

for (i in 0:(n_nodes - 2)){                       # ���졼������������
	for (h in 0:(n_nodes - 1)){
		if (i %% 2 == 1){
			chk <- 1
		} else {
			chk <- 0
		}
	
		if (
			   is.na(colors[h +        i    * n_nodes + 1]) == 1
			|| is.na(colors[h + chk + (i+1) * n_nodes + 1]) == 1
			|| h + chk == n_nodes
		){
			next
		}
	
		if ( 
			    colors[h +        i    * n_nodes + 1]
			!=  colors[h + chk + (i+1) * n_nodes + 1] 
		){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x,       y + b,
				x + 0.5, y + a,
				col="gray60",
				lwd=2,
			)
		}
	}
}

for (i in 0:(n_nodes - 2)){                       # ���졼������������
	for (h in 0:(n_nodes - 1)){
		if (i %% 2 == 0){
			chk <- 1
		} else {
			chk <- 0
		}
	
		if (
			   is.na(colors[h +        i    * n_nodes + 1]) == 1
			|| is.na(colors[h - chk + (i+1) * n_nodes + 1]) == 1
			|| h - chk < 0
		){
			next
		}
	
		if ( 
			    colors[h +        i    * n_nodes + 1]
			!=  colors[h - chk + (i+1) * n_nodes + 1] 
		){
			x <- h
			y <- i
			if ( y %% 2 == 1 ){
				x <- x + 0.5
			}
			
			segments(
				x,       y + b,
				x - 0.5, y + a,
				col="gray60",
				lwd=2,
			)
		}
	}
}

points <- NULL                                    # ��Υݥ����
sf <- 0.35
a  <- a   * sf;
b  <- b   * sf;
c  <- 0.5 * sf;
for (i in 1:nrow(somm$visual)){
	x <- somm$visual[i,1]
	y <- somm$visual[i,2]
	if ( y %% 2 == 1 ){
		x <- x + 0.5
	}
	points <- c(points, x, y)
}
points <- matrix( points, byrow=T, ncol=2  )

if( if_points == 1 ){
	if (F){
		for (i in 1:nrow(points)){
			x <- points[i,1]
			y <- points[i,2]
		
			polygon(
				x=c( x + c, x + c, x,     x - c, x - c, x ),
				y=c( y + a,   y - a,   y - b, y - a,   y + a,   y + b ),
				col="white",
				border="gray70",
				lty=1,
			)
		}
	} else {
		symbols(
			points[,1],
			points[,2],
			squares=rep(0.35,length(points[,1])),
			fg="gray70",
			bg="white",
			inches=F,
			add=T,
		)
	}
}

library(maptools)                                 # ��Υ�٥�
if (is.null(labcd) == 1){
	labcd <- pointLabel(
		x=points[,1],
		y=points[,2],
		labels=rownames(d),
		doPlot=F,
		cex=cex,
		offset=0
	)
}

text(
	labcd$x,
	labcd$y,
	labels=rownames(d),
	cex=cex,
	offset=0,
	font=text_font
)


';
}

1;