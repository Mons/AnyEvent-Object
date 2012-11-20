use 5.008008;
use ExtUtils::MakeMaker;

our $AUTHOR = -e '.git';
if ($AUTHOR) {
	#system( 'pod2text ... > README' ) and die "$!";
}

WriteMakefile(
	NAME              => 'AnyEvent::Object',
	VERSION_FROM      => 'lib/AnyEvent/Object.pm',
	ABSTRACT_FROM     => 'lib/AnyEvent/Object.pm',
	PREREQ_PM         => { AnyEvent => 5 },
	AUTHOR            => 'Mons Anderson <mons@cpan.org>',
	META_ADD          => { license => 'perl' },
);

__END__
use inc::Module::Install;

my $MI  = $Module::Install::MAIN;
name           'AnyEvent-Object';
all_from       'lib/AnyEvent/Object.pm';
author         'Mons Anderson <mons@cpan.org>';
license        'perl';

build_requires 'Test::More';

auto_provides;
auto_install;

WriteAll;

print STDERR "Generated makefile for ".$MI->load('name')->name."-".$MI->load('version')->version."\n";
