# 5.16 is not at all required;
# defaulting to what my system comes with

use 5.016;
use ExtUtils::MakeMaker;
WriteMakefile(
  NAME         => 'gotest',
  VERSION_FROM => 'gotest.pm',
);

sub MY::postamble {
    my $lib_ext = ($^O =~ /MSWin32/) ? '.dll' : '.so';

    return <<"MAKE_FRAG";

# This isn't covered by H_FILES, because H_FILES is a list
# of present .h files at perl Makefile.PL time, and this
# won't be there yet
\$(C_FILES): libadd.h

libadd.h: add.go \$(INST_ARCHAUTODIR)/libadd$lib_ext
	touch libadd.h

\$(INST_ARCHAUTODIR)/libadd$lib_ext: add.go
# This has to be built locally because it does generate libadd.h
	go build -buildmode=c-shared -o libadd$lib_ext add.go
	mv libadd$lib_ext \$(INST_ARCHAUTODIR)/libadd$lib_ext

\$(C_FILES): libsub.h

libsub.h: sub.go \$(INST_ARCHAUTODIR)/libsub$lib_ext
	touch libsub.h

\$(INST_ARCHAUTODIR)/libsub$lib_ext: sub.go
# This has to be built locally because it does generate libsub.h
	go build -buildmode=c-shared -o libsub$lib_ext sub.go
	mv libsub$lib_ext \$(INST_ARCHAUTODIR)/libsub$lib_ext

MAKE_FRAG
}
