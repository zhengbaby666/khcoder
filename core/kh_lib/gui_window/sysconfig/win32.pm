package gui_window::sysconfig::win32;
use base qw(gui_window::sysconfig);
use strict;
use Tk;

use gui_jchar;
use Gui_DragDrop;
#use gui_window::sysconfig::win32::chasen;
#use gui_window::sysconfig::win32::mecab;

#------------------#
#   Window�򳫤�   #
#------------------#

sub __new{
	my $self = shift;
	my $mw   = $::main_gui->mw;
	my $inis = $self->{win_obj};

	$self->{c_or_j}      = $::config_obj->c_or_j;

	# $inis->focus;
	# $inis->grab;
	$inis->title($self->gui_jt('KH Coder������'));

	my $lfra = $inis->LabFrame(
		-label => $self->gui_jchar('[�����Ф�����ˡ]'),
		-labelside => 'acrosstop',
		-borderwidth => 2,)
		->pack(-expand=>'yes',-fill=>'both');
	#my $fra0 = $lfra->Frame() ->pack(-anchor=>'c',-fill=>'x',-expand=>'yes');
	my $fra0_5 = $lfra->Frame() ->pack(-anchor=>'c',-fill=>'x',-expand=>'yes');
	my $fra0_7 = $lfra->Frame() ->pack(-anchor=>'c',-fill=>'x',-expand=>'yes');

	$lfra->Radiobutton(
		-text     => $self->gui_jchar('��䥡����ܸ��'),
		-font     => 'TKFN',
		-variable => \$self->{c_or_j},
		-value    => 'chasen',
		-command  => sub{ $self = $self->refine_cj },
	)->pack(-anchor => 'w');

	my $fra1 = $lfra->Frame() ->pack(-anchor=>'c',-fill=>'x',-expand=>'yes');

	$self->{lb1} = $fra1->Label(
		-text => $self->gui_jchar('chasen.exe�Υѥ���'),
		-font => 'TKFN'
	)->pack(-side => 'left');

	my $entry1 = $fra1->Entry(-font => 'TKFN')->pack(-side => 'right');
	$self->{entry1} = $entry1;

	$entry1->DropSite(
		-dropcommand => [\&Gui_DragDrop::get_filename_droped, $entry1,],
		-droptypes   => ($^O eq 'MSWin32' ? 'Win32' : ['KDE', 'XDND', 'Sun'])
	);

	$self->{btn1} = $fra1->Button(
		-text => $self->gui_jchar('����'),
		-font => 'TKFN',
		-command => sub { $self->browse_chasen(); }
	)->pack(-padx => '2',-side => 'right');

	
	my $msg = 'MeCab�����ܸ��';
	if ($::config_obj->all_in_one_pack && ! -e $::config_obj->mecab_path){
		$msg .= '�����ӥ��󥹥ȡ��뤬ɬ��';
	}

	$lfra->Radiobutton(
		-text     => $self->gui_jchar($msg),
		-font     => 'TKFN',
		-variable => \$self->{c_or_j},
		-value    => 'mecab',
		-command  => sub{ $self = $self->refine_cj },
	)->pack(-anchor => 'w');

	my $fra2 = $lfra->Frame() ->pack(-anchor=>'c',-fill=>'x',-expand=>'yes');

	$self->{lb2} = $fra2->Label(
		-text => $self->gui_jchar('mecab.exe�Υѥ���'),
		-font => 'TKFN'
	)->pack(-side => 'left');

	my $entry2 = $fra2->Entry(-font => 'TKFN')->pack(-side => 'right');
	$self->{entry2} = $entry2;

	$entry2->DropSite(
		-dropcommand => [\&Gui_DragDrop::get_filename_droped, $entry2,],
		-droptypes   => ($^O eq 'MSWin32' ? 'Win32' : ['KDE', 'XDND', 'Sun'])
	);

	$self->{btn2} = $fra2->Button(
		-text => $self->gui_jchar('����'),
		-font => 'TKFN',
		-command => sub { $self->browse_mecab(); }
	)->pack(-padx => '2',-side => 'right');
	
	$entry1->insert(0,$self->gui_jchar($::config_obj->chasen_path));
	$entry2->insert(0,$self->gui_jchar($::config_obj->mecab_path));
	
	$lfra->Radiobutton(
		-text     => $self->gui_jchar('Snowball Stemmer'),
		-font     => 'TKFN',
		-variable => \$self->{c_or_j},
		-value    => 'stemming',
		-command  => sub{ $self = $self->refine_cj },
	)->pack(-anchor => 'w');

	my $fra_stem = $lfra->Frame()->pack(-anchor => 'w');
	
	$self->{label_stem1} = $fra_stem->Label(
		-text => 'Language:'
	)->pack(-side => 'left',-anchor => 'w');

	$self->{opt_stem} = gui_widget::optmenu->open(
		parent  => $fra_stem,
		pack    => {-anchor=>'w', -side => 'left'},
		options =>
			[
				['English'      => 'en'],
				['Dutch *'      => 'nl'],
				['French *'     => 'fr'],
				['German *'     => 'de'],
				['Italian *'    => 'it'],
				['Portuguese *' => 'pt'],
				['Spanish *'    => 'es'],
			],
		variable => \$self->{opt_stem_val},
	);
	$self->{opt_stem}->set_value($::config_obj->stemming_lang);

	$self->{label_stem2} = $fra_stem->Label(
		-text => '  Stop words:'
	)->pack(-side => 'left',-anchor => 'w');

	$self->{btn_stem} = $fra_stem->Button(
		-text => 'config',
		-borderwidth => 1,
		-command => sub {
			my $class = "gui_window::stop_words::stemming_";
			$class   .= "$self->{opt_stem_val}";
			$class->open();
		}
	)->pack(-side => 'left');


	$self = $self->refine_cj;

	$self->{mail_obj} = gui_widget::mail_config->open(
		parent => $inis,
	);


	$inis->Button(
		-text => $self->gui_jchar('����󥻥�'),
		-font => 'TKFN',
		-width => 8,
		-command => sub{$self->close;}
	)->pack(-anchor=>'e',-side => 'right',-padx => 2, -pady => 2);

	$inis->Button(
		-text  => 'OK',
		-font  => 'TKFN',
		-width => 8,
		-command => sub {$self->ok;}
	)->pack(-anchor => 'e',-side => 'right',  -pady => 2);

	# ʸ�����������ѥХ����
	$inis->bind('Tk::Entry', '<Key-Delete>', \&gui_jchar::check_key_e_d);
	$entry1->bind("<Key>",[\&gui_jchar::check_key_e,Ev('K'),\$entry1]);
	
	
	#$self->gui_switch;

	return $self;
}

#--------------------#
#   �ե��󥯥����   #
#--------------------#

# OK�ܥ���
sub ok{
	my $self = shift;
	
	my $oldfont = $::config_obj->font_main;
	
	$::config_obj->chasen_path(  $self->gui_jg( $self->entry1->get() ) );
	$::config_obj->mecab_path(   $self->gui_jg( $self->entry2->get() ) );
	$::config_obj->c_or_j(       $self->gui_jg( $self->{c_or_j}      ) );
	$::config_obj->stemming_lang($self->gui_jg( $self->{opt_stem_val}) );
	
	$::config_obj->use_heap(    $self->{mail_obj}->if_heap );
	$::config_obj->mail_if(     $self->{mail_obj}->if      );
	$::config_obj->mail_smtp(   $self->{mail_obj}->smtp    );
	$::config_obj->mail_from(   $self->{mail_obj}->from    );
	$::config_obj->mail_to(     $self->{mail_obj}->to      );
	$::config_obj->font_main(   Jcode->new($self->{mail_obj}->font)->euc );
	
	if ($::config_obj->save){
		$self->close;
	}
	
	unless ($oldfont eq $::config_obj->font_main){
		$::main_gui->close_all;
		$::main_gui->remove_font;
		$::main_gui->make_font;
		$::config_obj->ClearGeometries;
		gui_errormsg->open(
			type => 'msg',
			msg  => "�ե���Ȥ��ѹ�����ޤ�����\n�ѹ���ͭ���ˤ��뤿��ˡ�KH Coder��Ƶ�ư���Ƥ���������",
		);
		
	}

}

# Mecab.exe�λ���
sub browse_mecab{
	my $self  = shift;

	my @types =
		(["exe files",           [qw/.exe/]],
		["All files",		'*']
	);
	
	my $path = $self->win_obj->getOpenFile(
		-filetypes  => \@types,
		-title      => $self->gui_jt('Mecab.exe�򳫤��Ƥ�������'),
		-initialdir => $self->gui_jchar($::config_obj->cwd),
	);
	
	if ($path){
		$path = $self->gui_jg_filename_win98($path);
		$path = $self->gui_jg($path);
		$path = $::config_obj->os_path($path);
		$self->entry2->delete('0','end');
		$self->entry2->insert(0,$self->gui_jchar($path));
	}
}

# Chasen.exe�λ���
sub browse_chasen{
	my $self  = shift;

	my @types =
		(["exe files",           [qw/.exe/]],
		["All files",		'*']
	);
	
	my $path = $self->win_obj->getOpenFile(
		-filetypes  => \@types,
		-title      => $self->gui_jt('Chasen.exe�򳫤��Ƥ�������'),
		-initialdir => $self->gui_jchar($::config_obj->cwd),
	);
	
	if ($path){
		$path = $self->gui_jg_filename_win98($path);
		$path = $self->gui_jg($path);
		$path = $::config_obj->os_path($path);
		$self->entry1->delete('0','end');
		$self->entry1->insert(0,$self->gui_jchar($path));
	}
}

# chasen��juman���ڤ��ؤ�
sub refine_cj{
	my $self = shift;

	if ($self->{c_or_j} eq 'chasen'){
		$self->entry1->configure(-state => 'normal');
		$self->btn1->configure(-state => 'normal');
		$self->lb1->configure(-state => 'normal');
		
		$self->entry2->configure(-state => 'disable');
		$self->btn2->configure(-state => 'disable');
		$self->lb2->configure(-state => 'disable');
		
		$self->{label_stem1}->configure(-state => 'disable');
		$self->{label_stem2}->configure(-state => 'disable');
		$self->{opt_stem}->configure(-state => 'disable');
		$self->{btn_stem}->configure(-state => 'disable');
		
	}
	elsif ($self->{c_or_j} eq 'mecab') {
		$self->entry1->configure(-state => 'disable');
		$self->btn1->configure(-state => 'disable');
		$self->lb1->configure(-state => 'disable');
		
		$self->entry2->configure(-state => 'normal');
		$self->btn2->configure(-state => 'normal');
		$self->lb2->configure(-state => 'normal');

		$self->{label_stem1}->configure(-state => 'disable');
		$self->{label_stem2}->configure(-state => 'disable');
		$self->{opt_stem}->configure(-state => 'disable');
		$self->{btn_stem}->configure(-state => 'disable');
	}
	
	elsif ($self->{c_or_j} eq 'stemming') {
		$self->entry1->configure(-state => 'disable');
		$self->btn1->configure(-state => 'disable');
		$self->lb1->configure(-state => 'disable');
		
		$self->entry2->configure(-state => 'disable');
		$self->btn2->configure(-state => 'disable');
		$self->lb2->configure(-state => 'disable');

		$self->{label_stem1}->configure(-state => 'normal');
		$self->{label_stem2}->configure(-state => 'normal');
		$self->{opt_stem}->configure(-state => 'normal');
		$self->{btn_stem}->configure(-state => 'normal');
	}

	return $self;
}

#--------------#
#   ��������   #
#--------------#

sub entry1{
	my $self = shift; return $self->{entry1};
}
sub entry2{
	my $self = shift; return $self->{entry2};
}
sub btn1{
	my $self = shift; return $self->{btn1};
}
sub btn2{
	my $self = shift; return $self->{btn2};
}
sub chk{
	my $self = shift; return $self->{chk};
}
sub chk2{
	my $self = shift; return $self->{chk2};
}
sub lb1{
	my $self = shift; return $self->{lb1};
}
sub lb2{
	my $self = shift; return $self->{lb2};
}
1;