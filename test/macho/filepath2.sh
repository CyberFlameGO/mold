#!/bin/bash
set -e
cd $(dirname $0)
mold=`pwd`/../../ld64.mold
echo -n "Testing $(basename -s .sh $0) ... "
t=$(pwd)/../../out/test/macho/$(basename -s .sh $0)
mkdir -p $t

cat <<EOF | cc -o $t/a.o -c -xc -
#include <stdio.h>
void hello() { printf("Hello world\n"); }
EOF

cat <<EOF | cc -o $t/b.o -c -xc -
void hello();
int main() { hello(); }
EOF

cat <<EOF > $t/filelist
a.o
b.o
EOF

clang -fuse-ld=$mold -o $t/exe -Xlinker -filelist -Xlinker $t/filelist,$t
$t/exe | grep -q 'Hello world'

echo OK
