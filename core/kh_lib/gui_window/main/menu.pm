package gui_window::main::menu;

use strict;
use Tk;

# ��˥塼�����ꡧ�ץ��������Ȥ����򤵤���Active
my @menu0 = (
	'm_b1_mark',
	'm_b2_morpho',
	't_sql_select',
	'm_b0_close',
	'm_b1_hukugo',
	'm_b2_datacheck',
	'm_b1_hukugo_te'
);

# ��˥塼�����ꡧ�����ǲ��Ϥ��Ԥ��Ƥ����Active
my @menu1 = (
	't_word_search',
	#'t_word_list',
	't_word_list_cf',
	't_word_freq',
	't_word_df_freq',
	't_word_ass',
	't_word_conc',
	'm_b3_check',
	't_cod_count',
	't_cod_tab',
	't_cod_jaccard',
	#'t_cod_multi',
	't_cod_out',
	't_cod_outtab',
	't_cod_out_spss',
	't_cod_out_csv',
	't_cod_out_tab',
	't_cod_out_var',
	't_txt_html2mod',
	'm_b3_crossout',
	'm_b3_crossout_csv',
	'm_b3_crossout_spss',
	'm_b3_crossout_tab',
	'm_b3_crossout_var',
	't_txt_pickup',
	't_doc_search',
	't_out_read',
	't_out_read_csv',
	't_out_read_tab',
	't_out_list',
	'm_b3_contxtout',
	'm_b3_contxtout_spss',
	'm_b3_contxtout_csv',
	'm_b3_contxtout_tab',
	'm_b0_export',
	't_cas_bayes',
	't_bayes_learn',
	't_bayes_predict',
	't_bayes_view',
	't_bayes_view_log',
);

#------------------#
#   ��˥塼����   #
#------------------#

sub make{
	my $class = shift;
	my $gui   = shift;
	my $self;
	
	my $mw = ${$gui}->mw;
	my $menubar = $mw->Menu(-type => 'menubar');
	$mw->configure(-menu => $menubar);

	#------------------#
	#   �ץ���������   #

	my $msg = gui_window->gui_jm('�ץ���������(P)','euc');
	my $f = $menubar->cascade(
		-label => "$msg",
		-font => "TKFN",
		-underline => $::config_obj->underline_conv(13),
		-tearoff=>'no'
	);

		$msg = gui_window->gui_jchar('����','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command =>
				sub{gui_window::project_new->open;},
			-accelerator => 'Ctrl+N'
		);
		$msg = gui_window->gui_jchar('����','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command =>
				sub{gui_window::project_open->open;},
			-accelerator => 'Ctrl+O'
		);
		$self->{m_b0_close} = $f->command(
			-label => gui_window->gui_jchar('�Ĥ���'),
			-font => "TKFN",
			-state => 'disable',
			-command =>
				sub{
						$self->mc_close_project;
					},
			-accelerator => 'Ctrl+W'
		);
		
		$f->separator();

		$f->command(
			-label => gui_window->gui_jchar('����ݡ���'),
			-font => "TKFN",
			-command =>
				sub{
						$self->mc_import_project;
					},
		);

		$self->{m_b0_export} = $f->command(
			-label => gui_window->gui_jchar('�������ݡ���'),
			-font => "TKFN",
			-state => 'disable',
			-command =>
				sub{
						$self->mc_export_project;
					},
		);

		$f->separator();
		
		$msg = gui_window->gui_jchar('����','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command => 
				sub{gui_window::sysconfig->open;},
		);
		#$f->separator();
		
		$msg = gui_window->gui_jchar('��λ','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command => sub{
						$::main_gui->get('main_window')->close or exit;
					},
			-accelerator => 'Ctrl+Q'
		);

	#------------#
	#   ������   #

	$f = $menubar->cascade(
		-label => gui_window->gui_jm('������(B)'),
		-font => "TKFN",
		-underline => $::config_obj->underline_conv(7),
		-tearoff=>'no'
	);

		$self->{m_b2_datacheck} = $f->command(
				-label => gui_window->gui_jchar('ʬ���оݥե�����Υ����å�'),
				-font => "TKFN",
				-command => sub{
					my $ans = $mw->messageBox(
						-message => gui_window->gui_jchar
							(
							   "���ν����ˤϻ��֤��������礬����ޤ���\n".
							   "³�Ԥ��Ƥ�������Ǥ�����"
							),
						-icon    => 'question',
						-type    => 'OKCancel',
						-title   => 'KH Coder'
					);
					unless ($ans =~ /ok/i){ return 0; }
					$self->mc_datacheck;
				},
				-state => 'disable'
			);

		$self->{m_b2_morpho} = $f->command(
				-label => gui_window->gui_jchar('�������μ¹�'),
				-font => "TKFN",
				-command => sub{
					my $ans = $mw->messageBox(
						-message => gui_window->gui_jchar
							(
							   "���֤Τ����������¹Ԥ��褦�Ȥ��Ƥ��ޤ���\n".
							   "³�Ԥ��Ƥ�������Ǥ�����"
							),
						-icon    => 'question',
						-type    => 'OKCancel',
						-title   => 'KH Coder'
					);
					unless ($ans =~ /ok/i){ return 0; }
					$self->mc_morpho;
				},
				-state => 'disable'
			);
		$f->separator();
		$self->{m_b1_mark} = $f->command(
				-label => gui_window->gui_jchar('��μ������'),
				-font => "TKFN",
				-command => sub{
					gui_window::dictionary->open;
				},
				-state => 'disable'
			);

		my $f_hukugo = $f->cascade(
				-label => gui_window->gui_jchar('ʣ���θ���'),
				-font => "TKFN",
				-tearoff=>'no'
			);

		$self->{m_b1_hukugo_te} = $f_hukugo->command(
				-label => gui_window->gui_jchar('TermExtract������'),
				-font => "TKFN",
				-command => sub{
					my $found = 1;
					eval "require TermExtract::Calc_Imp"  or $found = 0;
					eval "require TermExtract::Chasen"    or $found = 0;
					eval "require TermExtract::Chasen_kh" or $found = 0;
					if ($found){
						gui_window::use_te->open;
					} else {
						$mw->messageBox(
							-message => gui_window->gui_jchar('TermExtract�����󥹥ȡ��뤵��Ƥ��ޤ���'),
							-title => 'KH Coder',
							-type => 'OK',
						);
						return 0;
					}
				},
				-state => 'disable'
			);

		$self->{m_b1_hukugo} = $f_hukugo->command(
				-label => gui_window->gui_jchar('��䥤ˤ��Ϣ��'),
				-font => "TKFN",
				-command => sub{
					$self->mc_hukugo;
				},
				-state => 'disable'
			);

		$f->separator();

		$self->{m_b3_check} = $f->command(
				-label => gui_window->gui_jchar('�����з�̤��ǧ'),
				-font => "TKFN",
				-command => sub{
					gui_window::morpho_check->open;
				},
				-state => 'disable'
			);

	#------------#
	#   �ġ���   #

	$f = $menubar->cascade(
		-label => gui_window->gui_jchar('Tools(T)','euc'),
		-font => "TKFN",
		-underline => 6,
		-tearoff=>'no'
	);

	my $f3 = $f->cascade(
			-label => gui_window->gui_jchar('��и�'),
			-font => "TKFN",
			-tearoff=>'no'
		);

		$self->{t_word_list_cf} = $f3->command(
				-label => gui_window->gui_jchar('��и�ꥹ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_list->open;
				},
				-state => 'disable'
			);

		my $f_wd_stats = $f3->cascade(
			-label => gui_window->gui_jchar('��������'),
			-font => "TKFN",
			-tearoff=>'no'
		);
		
		$self->{t_word_freq} = $f_wd_stats->command(
				-label => gui_window->gui_jchar('�и������ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_freq->open->count;
				},
				-state => 'disable'
			);

		$self->{t_word_df_freq} = $f_wd_stats->command(
				-label => gui_window->gui_jchar('ʸ�����ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_df_freq->open->count;
				},
				-state => 'disable'
			);

		$self->{t_word_tf_df} = $f_wd_stats->command(
				-label => gui_window->gui_jchar('�и������ʸ����Υץ��å�'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_tf_df->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_word_tf_df' if $::config_obj->R;

		$f3->separator;

		$self->{t_word_search} = $f3->command(
				-label => gui_window->gui_jchar('��и측��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_search->open;
				},
				-state => 'disable'
			);

		$self->{t_word_conc} = $f3->command(
				-label => gui_window->gui_jchar('KWIC���󥳡�����'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_conc->open;
				},
				-state => 'disable'
			);

		$self->{t_word_ass} = $f3->command(
				-label => gui_window->gui_jchar('��Ϣ��õ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_ass->open;
				},
				-state => 'disable'
			);

		$f3->separator;

		$self->{t_word_corresp} = $f3->command(
				-label => gui_window->gui_jchar('�б�ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_corresp->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_word_corresp' if $::config_obj->R;

		$self->{t_word_mds} = $f3->command(
				-label => gui_window->gui_jchar('¿�������ٹ���ˡ'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_mds->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_word_mds' if $::config_obj->R;

		$self->{t_word_cls} = $f3->command(
				-label => gui_window->gui_jchar('����Ū���饹����ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_cls->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_word_cls' if $::config_obj->R;

		$self->{t_word_netgraph} = $f3->command(
				-label => gui_window->gui_jchar('�����ͥåȥ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::word_netgraph->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_word_netgraph' if $::config_obj->R;

	my $f8 = $f->cascade(
			-label => gui_window->gui_jchar('ʸ��'),
			 -font => "TKFN",
			 -tearoff=>'no'
		);

		$self->{t_doc_search} = $f8->command(
				-label => gui_window->gui_jchar('ʸ�񸡺�'),
				-font => "TKFN",
				-command => sub{
					gui_window::doc_search->open;
				},
				-state => 'disable'
			);

		$self->{t_doc_cls} = $f8->command(
				-label => gui_window->gui_jchar('���饹����ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::doc_cls->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_doc_cls' if $::config_obj->R;

		$self->{t_cas_bayes} = $f8->cascade(
			-label => gui_window->gui_jchar('�٥����ؽ��ˤ��ʬ��'),
			 -font => "TKFN",
			 -tearoff=>'no'
		);

		$self->{t_bayes_learn} = $self->{t_cas_bayes}->command(
			-label => gui_window->gui_jchar('�����ѿ�����ؽ�'),
			-font => "TKFN",
			-command => sub{
				gui_window::bayes_learn->open;
			},
			-state => 'disable'
		);

		$self->{t_bayes_predict} = $self->{t_cas_bayes}->command(
			-label => gui_window->gui_jchar('�ؽ���̤��Ѥ�����ưʬ��'),
			-font => "TKFN",
			-command => sub{
				gui_window::bayes_predict->open;
			},
			-state => 'disable'
		);

		$self->{t_cas_bayes}->separator;

		$self->{t_bayes_view} = $self->{t_cas_bayes}->command(
			-label => gui_window->gui_jchar('�ؽ���̥ե���������Ƥ��ǧ'),
			-font => "TKFN",
			-command => sub{
				$self->mc_view_knb;
			},
			-state => 'disable'
		);

		$self->{t_bayes_view_log} = $self->{t_cas_bayes}->command(
			-label => gui_window->gui_jchar('ʬ������ե���������Ƥ��ǧ'),
			-font => "TKFN",
			-command => sub{
				$self->mc_view_nbl;
			},
			-state => 'disable'
		);

		$f8->separator;

		$self->{m_b3_crossout} = $f8->cascade(
				-label => gui_window->gui_jchar("��ʸ�����и��ɽ�ν���",'euc'),
				-font => "TKFN",
				-state => 'disable',
				-tearoff=>'no'
			);

			$self->{m_b3_crossout_csv} = $self->{m_b3_crossout}->command(
				-label => gui_window->gui_jchar("CSV�ե�����"),
				-font  => "TKFN",
				-command => sub{
					gui_window::morpho_crossout::csv->open;
				},
			);

			$self->{m_b3_crossout_spss} = $self->{m_b3_crossout}->command(
				-label => gui_window->gui_jchar("SPSS�ե�����"),
				-font  => "TKFN",
				-command => sub{
					gui_window::morpho_crossout::spss->open;
				},
			);

			$self->{m_b3_crossout_tab} = $self->{m_b3_crossout}->command(
				-label => gui_window->gui_jchar("���ֶ��ڤ�"),
				-font  => "TKFN",
				-command => sub{
					gui_window::morpho_crossout::tab->open;
				},
			);

			$self->{m_b3_crossout}->separator;

			$self->{m_b3_crossout_var} = $self->{m_b3_crossout}->command(
				-label => gui_window->gui_jchar("����ĹCSV ��WordMiner��"),
				-font  => "TKFN",
				-command => sub{
					gui_window::morpho_crossout::var->open;
				},
			);

		$self->{m_b3_contxtout} = $f8->cascade(
				-label => gui_window->gui_jchar("����и��ʸ̮�٥��ȥ��ɽ�ν���",'euc'),
				-font => "TKFN",
				-state => 'disable',
				-tearoff=>'no'
			);

			$self->{m_b3_contxtout_csv} = $self->{m_b3_contxtout}->command(
				-label => gui_window->gui_jchar("CSV�ե�����"),
				-font  => "TKFN",
				-command => sub{
					gui_window::contxt_out::csv->open;
				},
			);

			$self->{m_b3_contxtout_spss} = $self->{m_b3_contxtout}->command(
				-label => gui_window->gui_jchar("SPSS�ե�����"),
				-font  => "TKFN",
				-command => sub{
					gui_window::contxt_out::spss->open;
				},
			);

			$self->{m_b3_contxtout_tab} = $self->{m_b3_contxtout}->command(
				-label => gui_window->gui_jchar("���ֶ��ڤ�"),
				-font  => "TKFN",
				-command => sub{
					gui_window::contxt_out::tab->open;
				},
			);

	my $f5 = $f->cascade(
			-label => gui_window->gui_jchar('�����ǥ���'),
			 -font => "TKFN",
			 -tearoff=>'no'
		);

		$self->{t_cod_count} = $f5->command(
			-label => gui_window->gui_jchar('ñ�㽸��'),
			-font => "TKFN",
			-command => sub{
					gui_window::cod_count->open;
				},
			-state => 'disable'
		);

		$self->{t_cod_tab} = $f5->command(
			-label => gui_window->gui_jchar('�ϡ��ᡦ����Ȥν���'),
			-font => "TKFN",
			-command => sub{
					gui_window::cod_tab->open;
				},
			-state => 'disable'
		);

		$self->{t_cod_outtab} = $f5->command(
			-label => gui_window->gui_jchar('�����ѿ��ȤΥ���������'),
			-font => "TKFN",
			-command => sub{
					gui_window::cod_outtab->open;
				},
			-state => 'disable'
		);

		$self->{t_cod_jaccard} = $f5->command(
			-label => gui_window->gui_jchar('����ٹ���'),
			-font => "TKFN",
			-command => sub{
					gui_window::cod_jaccard->open;
				},
			-state => 'disable'
		);

		$f5->separator();

		$self->{t_cod_corresp} = $f5->command(
				-label => gui_window->gui_jchar('�б�ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::cod_corresp->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_cod_corresp' if $::config_obj->R;

		#$self->{t_cod_multi} = $f5->cascade(
		#	-label => gui_window->gui_jchar('�����ɴִ�Ϣ'),
		#	 -font => "TKFN",
		#	 -tearoff=>'no'
		#);

		$self->{t_cod_mds} = $f5->command(
				-label => gui_window->gui_jchar('¿�������ٹ���ˡ'),
				-font => "TKFN",
				-command => sub{
					gui_window::cod_mds->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_cod_mds' if $::config_obj->R;

		$self->{t_cod_cls} = $f5->command(
				-label => gui_window->gui_jchar('����Ū���饹����ʬ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::cod_cls->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_cod_cls' if $::config_obj->R;

		$self->{t_cod_netg} = $f5->command(
				-label => gui_window->gui_jchar('�����ͥåȥ��'),
				-font => "TKFN",
				-command => sub{
					gui_window::cod_netg->open;
				},
				-state => 'disable'
			);
		push @menu1, 't_cod_netg' if $::config_obj->R;

		$f5->separator();

		$self->{t_cod_out} = $f5->cascade(
			-label => gui_window->gui_jchar('�����ǥ��󥰷�̤ν���'),
			 -font => "TKFN",
			 -tearoff=>'no'
		);

			$self->{t_cod_out_csv} = $self->{t_cod_out}->command(
				-label => gui_window->gui_jchar('CSV�ե�����'),
				-font => "TKFN",
				-command => sub{
						gui_window::cod_out::csv->open;
					},
				-state => 'disable'
			);

			$self->{t_cod_out_spss} = $self->{t_cod_out}->command(
				-label => gui_window->gui_jchar('SPSS�ե�����'),
				-font => "TKFN",
				-command => sub{
						gui_window::cod_out::spss->open;
					},
				-state => 'disable'
			);

			$self->{t_cod_out_tab} = $self->{t_cod_out}->command(
				-label => gui_window->gui_jchar('���ֶ��ڤ�'),
				-font => "TKFN",
				-command => sub{
						gui_window::cod_out::tab->open;
					},
				-state => 'disable'
			);

			$self->{t_cod_out}->separator();

			$self->{t_cod_out_var} = $self->{t_cod_out}->command(
				-label => gui_window->gui_jchar('����ĹCSV ��WordMiner��'),
				-font => "TKFN",
				-command => sub{
						gui_window::cod_out::var->open;
					},
				-state => 'disable'
			);

	$f->separator();
	
	my $f_out_var = $f->cascade(
		-label => gui_window->gui_jchar('�����ѿ�'),
		 -font => "TKFN",
		 -tearoff=>'no'
	);

		$self->{t_out_read} = $f_out_var->cascade(
			-label => gui_window->gui_jchar('�ɤ߹���'),
			 -font => "TKFN",
			 -tearoff=>'no'
		);

			$self->{t_out_read_csv} = $self->{t_out_read}->command(
				-label => gui_window->gui_jchar('CSV�ե�����'),
				-font => "TKFN",
				-command => sub{
						gui_window::outvar_read::csv->open;
					},
				-state => 'disable'
			);

			$self->{t_out_read_tab} = $self->{t_out_read}->command(
				-label => gui_window->gui_jchar('���ֶ��ڤ�'),
				-font => "TKFN",
				-command => sub{
						gui_window::outvar_read::tab->open;
					},
				-state => 'disable'
			);

		$self->{t_out_list} = $f_out_var->command(
			-label => gui_window->gui_jchar('�ѿ��ꥹ�ȡ��ͥ�٥�'),
			-font => "TKFN",
			-command => sub{
					gui_window::outvar_list->open;
				},
			-state => 'disable'
		);

	my $f6 = $f->cascade(
		-label => gui_window->gui_jchar('�ƥ����ȥե�������ѷ�'),
		 -font => "TKFN",
		 -tearoff=>'no'
	);

		$self->{t_txt_pickup} = $f6->command(
			-label => gui_window->gui_jchar('��ʬ�ƥ����Ȥμ��Ф�'),
			-font => "TKFN",
			-command => sub{
					gui_window::txt_pickup->open;
				},
			-state => 'disable'
		);

		$self->{t_txt_html2mod} = $f6->command(
			-label => gui_window->gui_jchar('HTML����CSV���Ѵ�'),
			-font => "TKFN",
			-command => sub{
					gui_window::txt_html2csv->open;
				},
			-state => 'disable'
		);


	# �ץ饰������ɤ߹���
	$f->separator();
	my $f_p = $f->cascade(
			-label => gui_window->gui_jchar('�ץ饰����'),
			-font => "TKFN",
			-tearoff=>'no'
		);

	my $read_each = sub {
		return if(-d $File::Find::name);
		return unless $_ =~ /.+\.pm/;
		substr($_, length($_) - 3, length($_)) = '';
		unless (eval "use $_; 1"){
			my $err = $@;
			gui_errormsg->open(
				type => 'msg',
				msg  => "�ץ饰�����".$_.".pm�פ��ɤ߹��ߤ���ߤ��ޤ�����\n���顼��\n$err"
			);
			print "$err\n";
			return 0;
		}
		my $conf = $_->plugin_config;
		my $cu = $_;
		my $mother = $f_p;
		
		# ���롼�׻�����б�
		if ( length($conf->{menu_grp}) ){
			unless ( $self->{plugin_cascades}{$conf->{menu_grp}} ){
				$self->{plugin_cascades}{$conf->{menu_grp}} = $f_p->cascade(
					-label   => gui_window->gui_jchar($conf->{menu_grp}),
					-font    => "TKFN",
					-tearoff =>'no'
				);
			}
			$mother = $self->{plugin_cascades}{$conf->{menu_grp}};
		}
		
		# ��˥塼���ޥ�ɺ���
		my $tmp_menu = $mother->command(
				-label => gui_window->gui_jchar($conf->{name}),
				-font => "TKFN",
				-command => sub{
					$cu->exec;
				},
				-state => 'disable'
		);
		
		# ��˥塼����
		$conf->{menu_cnf} = 0 unless defined($conf->{menu_cnf});
		if ($conf->{menu_cnf} == 0){
			$tmp_menu->configure(-state, 'normal');
		}
		elsif ($conf->{menu_cnf} == 1){
			$self->{'t_plugin_'.$_} = $tmp_menu;
			push @menu0, 't_plugin_'.$_;
		}
		elsif ($conf->{menu_cnf} == 2){
			$self->{'t_plugin_'.$_} = $tmp_menu;
			push @menu1, 't_plugin_'.$_;
		}
	};

	use File::Find;
	find($read_each, $::config_obj->cwd.'/plugin');

	$self->{t_sql_select} = $f->command(
			-label => gui_window->gui_jchar('SQLʸ�μ¹�'),
			-font => "TKFN",
			-command => sub{
				gui_window::sql_select->open;
			},
			-state => 'disable'
		);

	$f->configure(
		-label     => gui_window->gui_jm('�ġ���(T)'),
		-underline => $::config_obj->underline_conv(7),
	);


	#------------#
	#   �إ��   #
	
	$msg = gui_window->gui_jm('�إ��(H)','euc');
	$f = $menubar->cascade(
		-label => "$msg",
		-font => "TKFN",
		-underline => $::config_obj->underline_conv(7),
		-tearoff=>'no'
	);
	
		$msg = gui_window->gui_jchar('�����������PDF��','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command => sub { gui_OtherWin->open('khcoder_manual.pdf'); },
		);
		
		$msg = gui_window->gui_jchar('�ǿ������Web��','euc');
		$f->command(
			-label => $msg,
			-font => "TKFN",
			-command => sub {
					 gui_OtherWin->open('http://khc.sourceforge.net');
					},
		);
		
		$msg = gui_window->gui_jchar('KH Coder�ˤĤ���','euc');
		$f->command(
			-label => $msg,
			-command => sub{gui_window::about->open;},
			-font => "TKFN",
		);

	#--------------------#
	#   �������Х����   #
	
	$mw->bind(
		'<Control-Key-o>',
		sub{gui_window::project_open->open;}
	);
	$mw->bind(
		'<Control-Key-n>',
		sub{gui_window::project_new->open;}
	);
	$mw->bind(
		'<Control-Key-v>',
		sub{gui_window::about->open;}
	);
	$mw->bind(
		'<Control-Key-w>',
		sub{$self->mc_close_project;}
	);

	bless $self, $class;
	return $self;
}

#------------------------------------#
#   ��Ԥ�ۤ����˥塼�����ޥ��   #
#------------------------------------#

sub mc_view_nbl{
	my @types = (
		[ "KH Coder: Naive Bayes Logs",[qw/.nbl/] ],
		["All files",'*']
	);
	my $path = $::main_gui->mw->getOpenFile(
		-defaultextension => '.knb',
		-filetypes        => \@types,
		-title            =>
			gui_window->gui_jt('��������ʬ������ե����������'),
		-initialdir       => gui_window->gui_jchar($::config_obj->cwd),
	);
	unless ($path){
		return 0;
	}
	$path = gui_window->gui_jg_filename_win98($path);
	$path = gui_window->gui_jg($path);
	$path = $::config_obj->os_path($path);
	
	my $win = $::main_gui->get('w_bayes_view_log');
	$win->close if Exists( $win->{win_obj} );
	
	gui_window::bayes_view_log->open($path);
}

sub mc_view_knb{
	my @types = (
		[ "KH Coder: Naive Bayes Moldels",[qw/.knb/] ],
		["All files",'*']
	);
	my $path = $::main_gui->mw->getOpenFile(
		-defaultextension => '.knb',
		-filetypes        => \@types,
		-title            =>
			gui_window->gui_jt('��������ؽ���̥ե����������'),
		-initialdir       => gui_window->gui_jchar($::config_obj->cwd),
	);
	unless ($path){
		return 0;
	}
	$path = gui_window->gui_jg_filename_win98($path);
	$path = gui_window->gui_jg($path);
	$path = $::config_obj->os_path($path);
	
	my $win = $::main_gui->get('w_bayes_view_knb');
	$win->close if Exists( $win->{win_obj} );
	
	gui_window::bayes_view_knb->open($path);
	
	# my $dist = $::project_obj->file_TempCSV;
	# kh_nbayes::Util->knb2csv(
	# 	path => $path,
	# 	csv  => $dist,
	# );
	# gui_OtherWin->open($dist);
}
sub mc_import_project{
	require kh_project_io;

	# KHC�ե�����Υѥ�
	my @types = (
		['KH Coder',[qw/.khc/] ],
		["All Files",'*']
	);
	my $path = $::main_gui->mw->getOpenFile(
		-defaultextension => '.khc',
		-filetypes        =>  \@types,
		-title            =>
			gui_window->gui_jt('KHC�����Υե����뤫��ץ��������Ȥ򥤥�ݡ���'),
		-initialdir       => gui_window->gui_jchar($::config_obj->cwd),
	);
	unless ($path){
		return 0;
	}
	$path = gui_window->gui_jg_filename_win98($path);
	$path = gui_window->gui_jg($path);
	$path = $::config_obj->os_path($path);
	
	# ʬ���оݥե��������¸���
	my $info = &kh_project_io::get_info($path);
	return undef unless length($info->{file_name});
	@types = (
		['Data Files',[qw/.txt .html .htm/] ],
		["All Files",'*']
	);
	my $path_s = $::main_gui->mw->getSaveFile(
		-defaultextension => '.khc',
		-filetypes        =>  \@types,
		-title            =>
			gui_window->gui_jt('ʬ���оݥե��������¸�����ꤷ�Ʋ�������Ʊ������coder_data�ե��������������ޤ���'),
		-initialdir       => gui_window->gui_jchar($::config_obj->cwd),
		-initialfile      => gui_window->gui_jchar($info->{file_name})
	);
	unless ($path_s){
		return 0;
	}
	$path_s = gui_window->gui_jg_filename_win98($path_s);
	$path_s = gui_window->gui_jg($path_s);
	$path_s = $::config_obj->os_path($path_s);
	
	# �¹�
	my $w = gui_wait->start;
	&kh_project_io::import($path,$path_s);
	$w->end;
	
	# �ץ��������ȥޥ͡����㡼��ɽ��
	gui_window::project_open->open;

}
sub mc_export_project{
	require kh_project_io;

	# �ե�����̾
	my @types = (
		['KH Coder',[qw/.khc/] ],
		["All Files",'*']
	);
	my $path = $::main_gui->mw->getSaveFile(
		-defaultextension => '.khc',
		-filetypes        =>  \@types,
		-title            =>
			gui_window->gui_jt('���ߤΥץ��������Ȥ�KHC�����Υե�����˥������ݡ���'),
		-initialdir       => gui_window->gui_jchar($::config_obj->cwd),
	);
	unless ($path){
		return 0;
	}
	$path = gui_window->gui_jg_filename_win98($path);
	$path = gui_window->gui_jg($path);
	$path = $::config_obj->os_path($path);
	
	# �¹�
	my $w = gui_wait->start;
	&kh_project_io::export($path);
	$w->end;
}
sub mc_close_project{
	$::main_gui->close_all;
	undef $::project_obj;
	$::main_gui->menu->refresh;
	$::main_gui->inner->refresh;
}
sub mc_datacheck{
	#my $w = gui_wait->start;
	use kh_datacheck;
	kh_datacheck->run;
	#$w->end;
}
sub mc_morpho{
	my $self = shift;
	my $w = gui_wait->start;
	$self->mc_morpho_exec;
	$w->end;
	$::main_gui->menu->refresh;
	$::main_gui->inner->refresh;
}
sub mc_morpho_exec{
	mysql_ready->first;
	$::project_obj->status_morpho(1);
}
sub mc_hukugo{
	my $self = shift;
	my $mw = $::main_gui->{win_obj};

	my $if_exec = 1;
	if (
		   ( -e $::project_obj->file_HukugoList )
		&& ( mysql_exec->table_exists('hukugo') )
	){
		my $t0 = (stat $::project_obj->file_target)[9];
		my $t1 = (stat $::project_obj->file_HukugoList)[9];
		if ($t0 < $t1){
			$if_exec = 0; # ���ξ��������Ϥ��ʤ�
		}
	}

	if ($if_exec){
		my $ans = $mw->messageBox(
			-message => gui_window->gui_jchar
				(
				   "���֤Τ����������¹Ԥ��褦�Ȥ��Ƥ��ޤ���"
				   ."������������û���֤ǽ�λ���ޤ���\n".
				   "³�Ԥ��Ƥ�������Ǥ�����"
				),
			-icon    => 'question',
			-type    => 'OKCancel',
			-title   => 'KH Coder'
		);
		unless ($ans =~ /ok/i){ return 0; }

		my $w = gui_wait->start;
		use mysql_hukugo;
		mysql_hukugo->run_from_morpho;
		$w->end;
	}

	gui_window::hukugo->open;
}


#------------------------#
#   ��˥塼�ξ����ѹ�   #
#------------------------#

sub refresh{
	my $self = shift;
	$self->disable_all;

	if ($::project_obj){
		$self->normalize(\@menu0);
		if ($::project_obj->status_morpho){
			$self->normalize(\@menu1);
		}
	}
}

sub normalize{
	my $self = shift;
	foreach my $i (@{$_[0]}){
		$self->{$i}->configure(-state,'normal');
	}
}

sub disable_all{
	my $self = shift;
	foreach my $i (keys %{$self}){
		if (substr($i,0,2) eq 'm_' || substr($i,0,2) eq 't_'){
			$self->{$i}->configure(-state, 'disable');
		}
	}
}

1;