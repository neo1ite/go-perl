package gotest;
our $VERSION = '0.01';

# Preload the libadd so file
# We need to do this manually, since otherwise it'll
# follow ld's default behavior and look in either LD_LIBRARY_PATH
# (which won't have our arch/auto/gotest directory)
# or in paths hard-coded into the library
# (which is even less obvious than doing a relative search from this PM)
{
  use File::Basename;
  use DynaLoader;
  my (undef, $dir) = fileparse(__FILE__);
  my $lib_ext  = ($^O =~ /MSWin32/) ? '.dll' : '.so';
  my @reldirs = qw(../arch/auto auto);
  my @libs = qw(libadd libsub);
  for my $libname (@libs) {
    my $lib;
    for my $reldir (@reldirs) {
      my $libpath = "$dir/" . $reldir . "/" . __PACKAGE__ . "/$libname$lib_ext";
      # The '1' is necessary to make the symbols visible to the upcoming load
      $lib = DynaLoader::dl_load_file($libpath, 1);
      last if $lib;
    }
    die "Couldn't load generated Go library $libname$lib_ext" unless defined $lib;
  }
}

use XSLoader;
XSLoader::load('gotest', $VERSION);

1;
