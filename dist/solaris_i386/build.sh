#!/bin/bash

# Have to explicitly include the Input* modules as the names of these are dynamically
# constructed in the code so Par::Packer can't auto-detect them.
# Same with some of the output modules.

PAR_VERBATIM=1 /opt/gnu/perl5/5.24/bin/pp \
  --unicode \
  --module=deprecate \
  --module=Biber::Input::file::bibtex \
  --module=Biber::Input::file::biblatexml \
  --module=Biber::Output::dot \
  --module=Biber::Output::bbl \
  --module=Biber::Output::bblxml \
  --module=Biber::Output::bibtex \
  --module=Biber::Output::biblatexml \
  --module=Pod::Simple::TranscodeSmart \
  --module=Pod::Simple::TranscodeDumb \
  --module=List::MoreUtils::XS \
  --module=List::SomeUtils::XS \
  --module=List::MoreUtils::PP \
  --module=HTTP::Status \
  --module=HTTP::Date \
  --module=Encode:: \
  --module=File::Find::Rule \
  --module=IO::Socket::SSL \
  --module=IO::String \
  --module=PerlIO::utf8_strict \
  --module=Text::CSV_XS \
  --module=DateTime \
  --link=/opt/gnu/perl5/5.24/lib/libbtparse.so \
  --link=/usr/lib/libxml2.so.2 \
  --link=/usr/lib/libz.so.1 \
  --link=/usr/lib/libxslt.so.1 \
  --link=/usr/lib/libexslt.so.0 \
  --link=/usr/lib/libssl.so.0.9.8 \
  --link=/usr/lib/libcrypto.so.0.9.8 \
  --addlist=biber.files \
  --cachedeps=scancache \
  --output=biber-solaris_x86_32 \
  /opt/gnu/perl5/5.24/bin/biber
