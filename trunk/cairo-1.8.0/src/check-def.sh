#!/bin/sh

LANG=C

if which nm 2>/dev/null >/dev/null; then
	:
else
	echo "'nm' not found; skipping test"
	exit 0
fi

test -z "$srcdir" && srcdir=.
test -z "$MAKE" && MAKE=make
stat=0

$MAKE check-has-hidden-symbols.i > /dev/null || exit 1
if tail -1 check-has-hidden-symbols.i | grep CAIRO_HAS_HIDDEN_SYMBOLS >/dev/null; then
	echo "Compiler doesn't support symbol visibility; skipping test"
	exit 0
fi

get_cairo_syms='nm "$so" | grep " [BCDGINRSTVW] " | cut -d" " -f3'
if [ "`uname -s`" = "Linux" ]; then
       get_cairo_syms='( objdump -t "$so" | grep "^[^ ]* [^l.*]*[.]"; objdump -t "$so" | grep "[.]hidden.*\\<cairo"; ) | sed "s/.* //"'
fi

defs="cairo.def"
$MAKE $defs > /dev/null
for def in $defs; do
	lib=`echo "$def" | sed 's/[.]def$//'`
	lib=`echo "$lib" | sed 's@.*/@@'`
	so=.libs/lib${lib}.so

	test -f "$so" || continue

	echo Checking that $so has the same symbol list as $def

	{
		echo EXPORTS
		eval $get_cairo_syms | grep -v '^_cairo_test_\|^_fini\|^_init\|^_save[fg]pr\|^_rest[fg]pr' | sort -u
		# cheat: copy the last line from the def file!
		tail -n1 "$def"
	} | diff "$def" - || stat=1
done

exit $stat