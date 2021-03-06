AC_INIT([gtkaml],[0.5.94])

AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)
AM_CONFIG_HEADER(config.h)
AM_MAINTAINER_MODE

AC_PROG_CC
AC_DISABLE_STATIC
# If you add the macro AC_PROG_LIBTOOL here, you must run "libtoolize" before "automake", 
# or you will get an error:
# required file `./ltmain.sh' not found
AC_PROG_LIBTOOL

PKG_CHECK_MODULES(VALA, libvala-0.30, [VALA_VERSION="0.30"],
	[PKG_CHECK_MODULES(VALA, libvala-0.28, [VALA_VERSION="0.28"],
		[PKG_CHECK_MODULES(VALA, libvala-0.26, [VALA_VERSION="0.26"],
			[PKG_CHECK_MODULES(VALA, libvala-0.18, [VALA_VERSION="0.18"],
				[PKG_CHECK_MODULES(VALA, libvala-0.16, [VALA_VERSION="0.16"])
			])
		])
	])
])

AC_SUBST(VALA_CFLAGS)
AC_SUBST(VALA_LIBS)

AC_SUBST(VALA_VERSION)
AH_TEMPLATE([VALA_VERSION], [Vala version])
AC_DEFINE_UNQUOTED([VALA_VERSION], [$VALA_VERSION])

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(CFLAGS)
AC_SUBST(LDFLAGS)

#similar to CFLAGS, use VALAFLAGS from environment
AC_SUBST(VALAFLAGS)

AC_HEADER_STDC

PKG_CHECK_MODULES([GLIB], glib-2.0 >= 2.12.0)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

PKG_CHECK_MODULES([GIO], gio-2.0 >= 2.12.0)
AC_SUBST(GIO_CFLAGS)
AC_SUBST(GIO_LIBS)

PKG_CHECK_MODULES([GTK], gtk+-3.0)
AC_SUBST(GTK_CFLAGS)
AC_SUBST(GTK_LIBS)

PKG_CHECK_MODULES([LIBXML2], libxml-2.0)
AC_SUBST(LIBXML2_CFLAGS)
AC_SUBST(LIBXML2_LIBS)

AC_ARG_ENABLE(tests, AS_HELP_STRING([--enable-tests], [Enable building of tests]), enable_tests=$enableval, enable_tests=no)
AM_CONDITIONAL([ENABLE_TESTS], [test x$enable_tests = xyes])

AC_ARG_ENABLE([docs], AS_HELP_STRING([--enable-docs],[use this to generate valadoc]),
              [enable_docs=$enableval], [enable_docs=no])
AM_CONDITIONAL([ENABLE_DOCS], [test x$enable_docs = xyes])

AS_IF([test "x$enable_docs" != xno],
      [AC_PATH_PROG([VALADOC], [valadoc], :)
       AC_SUBST(VALADOC)
       AS_IF([test "$VALADOC" = :],
             [AC_MSG_ERROR([valadoc not found])])])


m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])


AC_CONFIG_FILES([
Makefile
gtkaml-1.0.pc
src/Makefile
libgtkaml/Makefile
libgtkaml/gtkaml-1.0.deps
markuphints/Makefile
tests/gtk2/Makefile
tests/gtk3/Makefile
])

AC_OUTPUT
