# 5.16 is not at all required;
# defaulting to what my system comes with

use 5.016;
use ExtUtils::MakeMaker;

my $lib_ext  = ($^O =~ /MSWin32/) ? '.dll' : '.so';
my $path_sep = ($^O =~ /MSWin32/) ? '\\' : '/';

WriteMakefile(
  NAME         => 'gotest',
  VERSION_FROM => 'gotest.pm',
  MYEXTLIB     => "\$(INST_ARCHAUTODIR)${path_sep}libadd$lib_ext \$(INST_ARCHAUTODIR)${path_sep}libsub$lib_ext"
);

sub MY::postamble {
    return <<"MAKE_FRAG";

# This isn't covered by H_FILES, because H_FILES is a list
# of present .h files at perl Makefile.PL time, and this
# won't be there yet
libadd$lib_ext: libadd.h

libadd.h: add.go \$(INST_ARCHAUTODIR)${path_sep}libadd$lib_ext
	\$(TOUCH) libadd.h

\$(INST_ARCHAUTODIR)${path_sep}libadd$lib_ext: add.go
# This has to be built locally because it does generate libadd.h
# -x -ldflags=-v
	go build -buildmode="c-shared" -o libadd$lib_ext add.go
	\$(MV) libadd$lib_ext \$(INST_ARCHAUTODIR)${path_sep}libadd$lib_ext

libsub$lib_ext: libsub.h

libsub.h: sub.go \$(INST_ARCHAUTODIR)${path_sep}libsub$lib_ext
	\$(TOUCH) libsub.h

\$(INST_ARCHAUTODIR)${path_sep}libsub$lib_ext: sub.go
# This has to be built locally because it does generate libsub.h
# -x -ldflags=-v
	go build -buildmode="c-shared" -o libsub$lib_ext sub.go
	\$(MV) libsub$lib_ext \$(INST_ARCHAUTODIR)${path_sep}libsub$lib_ext

MAKE_FRAG
}
