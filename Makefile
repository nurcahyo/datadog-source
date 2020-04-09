srcdir = /usr/local/opt/datadog-php
builddir = /usr/local/opt/datadog-php
top_srcdir = /usr/local/opt/datadog-php
top_builddir = /usr/local/opt/datadog-php
EGREP = /usr/bin/grep -E
SED = /usr/bin/sed
CONFIGURE_COMMAND = './configure'
CONFIGURE_OPTIONS =
SHLIB_SUFFIX_NAME = dylib
SHLIB_DL_SUFFIX_NAME = so
ZEND_EXT_TYPE = zend_extension
RE2C = exit 0;
AWK = awk
shared_objects_ddtrace = src/ext/ddtrace.lo src/dogstatsd/client.lo src/ext/arrays.lo src/ext/circuit_breaker.lo src/ext/comms_php.lo src/ext/compat_string.lo src/ext/coms.lo src/ext/configuration.lo src/ext/configuration_php_iface.lo src/ext/dispatch.lo src/ext/dispatch_setup.lo src/ext/dogstatsd_client.lo src/ext/engine_hooks.lo src/ext/env_config.lo src/ext/logging.lo src/ext/memory_limit.lo src/ext/mpack/mpack.lo src/ext/random.lo src/ext/request_hooks.lo src/ext/serializer.lo src/ext/signals.lo src/ext/span.lo src/ext/third-party/mt19937-64.lo src/ext/php7/dispatch.lo src/ext/php7/engine_hooks.lo
PHP_PECL_EXTENSION = ddtrace
EXTRA_LDFLAGS = -lcurl
PHP_MODULES = $(phplibdir)/ddtrace.la
PHP_ZEND_EX =
all_targets = $(PHP_MODULES) $(PHP_ZEND_EX)
install_targets = install-modules install-headers
prefix = /usr/local/Cellar/php@7.2/7.2.27
exec_prefix = $(prefix)
libdir = ${exec_prefix}/lib
prefix = /usr/local/Cellar/php@7.2/7.2.27
phplibdir = /usr/local/opt/datadog-php/modules
phpincludedir = /usr/local/Cellar/php@7.2/7.2.27/include/php
CC = cc
CFLAGS = -g -O2
CFLAGS_CLEAN = $(CFLAGS)
CPP = cc -E
CPPFLAGS = -DHAVE_CONFIG_H
CXX =
CXXFLAGS =
CXXFLAGS_CLEAN = $(CXXFLAGS)
EXTENSION_DIR = /usr/local/Cellar/php@7.2/7.2.27/pecl/20170718
PHP_EXECUTABLE = /usr/local/Cellar/php@7.2/7.2.27/bin/php
EXTRA_LDFLAGS = -lcurl
EXTRA_LIBS =
INCLUDES = -I/usr/local/Cellar/php@7.2/7.2.27/include/php -I/usr/local/Cellar/php@7.2/7.2.27/include/php/main -I/usr/local/Cellar/php@7.2/7.2.27/include/php/TSRM -I/usr/local/Cellar/php@7.2/7.2.27/include/php/Zend -I/usr/local/Cellar/php@7.2/7.2.27/include/php/ext -I/usr/local/Cellar/php@7.2/7.2.27/include/php/ext/date/lib -I/usr/local/opt/datadog-php -I/usr/local/opt/datadog-php/src/ext -I/usr/local/opt/datadog-php/src/ext/mpack -I/usr/local/opt/datadog-php/src/dogstatsd
LFLAGS =
LDFLAGS =
SHARED_LIBTOOL =
LIBTOOL = $(SHELL) $(top_builddir)/libtool
SHELL = /bin/sh
INSTALL_HEADERS =
mkinstalldirs = $(top_srcdir)/build/shtool mkdir -p
INSTALL = $(top_srcdir)/build/shtool install -c
INSTALL_DATA = $(INSTALL) -m 644

DEFS = -DPHP_ATOM_INC -I$(top_builddir)/include -I$(top_builddir)/main -I$(top_srcdir)
COMMON_FLAGS = $(DEFS) $(INCLUDES) $(EXTRA_INCLUDES) $(CPPFLAGS) $(PHP_FRAMEWORKPATH)

all: $(all_targets)
	@echo
	@echo "Build complete."
	@echo "Don't forget to run 'make test'."
	@echo

build-modules: $(PHP_MODULES) $(PHP_ZEND_EX)

build-binaries: $(PHP_BINARIES)

libphp$(PHP_MAJOR_VERSION).la: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(LIBTOOL) --mode=link $(CC) $(CFLAGS) $(EXTRA_CFLAGS) -rpath $(phptempdir) $(EXTRA_LDFLAGS) $(LDFLAGS) $(PHP_RPATHS) $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@
	-@$(LIBTOOL) --silent --mode=install cp $@ $(phptempdir)/$@ >/dev/null 2>&1

libs/libphp$(PHP_MAJOR_VERSION).bundle: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(CC) $(MH_BUNDLE_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS) $(EXTRA_LDFLAGS) $(PHP_GLOBAL_OBJS:.lo=.o) $(PHP_SAPI_OBJS:.lo=.o) $(PHP_FRAMEWORKS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@ && cp $@ libs/libphp$(PHP_MAJOR_VERSION).so

install: $(all_targets) $(install_targets)

install-sapi: $(OVERALL_TARGET)
	@echo "Installing PHP SAPI module:       $(PHP_SAPI)"
	-@$(mkinstalldirs) $(INSTALL_ROOT)$(bindir)
	-@if test ! -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); then \
		for i in 0.0.0 0.0 0; do \
			if test -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i; then \
				$(LN_S) $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); \
				break; \
			fi; \
		done; \
	fi
	@$(INSTALL_IT)

install-binaries: build-binaries $(install_binary_targets)

install-modules: build-modules
	@test -d modules && \
	$(mkinstalldirs) $(INSTALL_ROOT)$(EXTENSION_DIR)
	@echo "Installing shared extensions:     $(INSTALL_ROOT)$(EXTENSION_DIR)/"
	@rm -f modules/*.la >/dev/null 2>&1
	@$(INSTALL) modules/* $(INSTALL_ROOT)$(EXTENSION_DIR)

install-headers:
	-@if test "$(INSTALL_HEADERS)"; then \
		for i in `echo $(INSTALL_HEADERS)`; do \
			i=`$(top_srcdir)/build/shtool path -d $$i`; \
			paths="$$paths $(INSTALL_ROOT)$(phpincludedir)/$$i"; \
		done; \
		$(mkinstalldirs) $$paths && \
		echo "Installing header files:          $(INSTALL_ROOT)$(phpincludedir)/" && \
		for i in `echo $(INSTALL_HEADERS)`; do \
			if test "$(PHP_PECL_EXTENSION)"; then \
				src=`echo $$i | $(SED) -e "s#ext/$(PHP_PECL_EXTENSION)/##g"`; \
			else \
				src=$$i; \
			fi; \
			if test -f "$(top_srcdir)/$$src"; then \
				$(INSTALL_DATA) $(top_srcdir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			elif test -f "$(top_builddir)/$$src"; then \
				$(INSTALL_DATA) $(top_builddir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			else \
				(cd $(top_srcdir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i; \
				cd $(top_builddir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i) 2>/dev/null || true; \
			fi \
		done; \
	fi

PHP_TEST_SETTINGS = -d 'open_basedir=' -d 'output_buffering=0' -d 'memory_limit=-1'
PHP_TEST_SHARED_EXTENSIONS =  ` \
	if test "x$(PHP_MODULES)" != "x"; then \
		for i in $(PHP_MODULES)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d extension=$$dlname"; \
		done; \
	fi; \
	if test "x$(PHP_ZEND_EX)" != "x"; then \
		for i in $(PHP_ZEND_EX)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d $(ZEND_EXT_TYPE)=$(top_builddir)/modules/$$dlname"; \
		done; \
	fi`
PHP_DEPRECATED_DIRECTIVES_REGEX = '^(magic_quotes_(gpc|runtime|sybase)?|(zend_)?extension(_debug)?(_ts)?)[\t\ ]*='

test: all
	@if test ! -z "$(PHP_EXECUTABLE)" && test -x "$(PHP_EXECUTABLE)"; then \
		INI_FILE=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r 'echo php_ini_loaded_file();' 2> /dev/null`; \
		if test "$$INI_FILE"; then \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_FILE" > $(top_builddir)/tmp-php.ini; \
		else \
			echo > $(top_builddir)/tmp-php.ini; \
		fi; \
		INI_SCANNED_PATH=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r '$$a = explode(",\n", trim(php_ini_scanned_files())); echo $$a[0];' 2> /dev/null`; \
		if test "$$INI_SCANNED_PATH"; then \
			INI_SCANNED_PATH=`$(top_srcdir)/build/shtool path -d $$INI_SCANNED_PATH`; \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_SCANNED_PATH"/*.ini >> $(top_builddir)/tmp-php.ini; \
		fi; \
		TEST_PHP_EXECUTABLE=$(PHP_EXECUTABLE) \
		TEST_PHP_SRCDIR=$(top_srcdir) \
		CC="$(CC)" \
			$(PHP_EXECUTABLE) -n -c $(top_builddir)/tmp-php.ini $(PHP_TEST_SETTINGS) $(top_srcdir)/run-tests.php -n -c $(top_builddir)/tmp-php.ini -d extension_dir=$(top_builddir)/modules/ $(PHP_TEST_SHARED_EXTENSIONS) $(TESTS); \
		TEST_RESULT_EXIT_CODE=$$?; \
		rm $(top_builddir)/tmp-php.ini; \
		exit $$TEST_RESULT_EXIT_CODE; \
	else \
		echo "ERROR: Cannot run tests without CLI sapi."; \
	fi

clean:
	find . -name \*.gcno -o -name \*.gcda | xargs rm -f
	find . -name \*.lo -o -name \*.o | xargs rm -f
	find . -name \*.la -o -name \*.a | xargs rm -f
	find . -name \*.so | xargs rm -f
	find . -name .libs -a -type d|xargs rm -rf
	rm -f libphp$(PHP_MAJOR_VERSION).la $(SAPI_CLI_PATH) $(SAPI_CGI_PATH) $(SAPI_MILTER_PATH) $(SAPI_LITESPEED_PATH) $(SAPI_FPM_PATH) $(OVERALL_TARGET) modules/* libs/*

distclean: clean
	rm -f Makefile config.cache config.log config.status Makefile.objects Makefile.fragments libtool main/php_config.h main/internal_functions_cli.c main/internal_functions.c stamp-h buildmk.stamp Zend/zend_dtrace_gen.h Zend/zend_dtrace_gen.h.bak Zend/zend_config.h TSRM/tsrm_config.h
	rm -f php7.spec main/build-defs.h scripts/phpize
	rm -f ext/date/lib/timelib_config.h ext/mbstring/oniguruma/config.h ext/mbstring/libmbfl/config.h ext/oci8/oci8_dtrace_gen.h ext/oci8/oci8_dtrace_gen.h.bak
	rm -f scripts/man1/phpize.1 scripts/php-config scripts/man1/php-config.1 sapi/cli/php.1 sapi/cgi/php-cgi.1 sapi/phpdbg/phpdbg.1 ext/phar/phar.1 ext/phar/phar.phar.1
	rm -f sapi/fpm/php-fpm.conf sapi/fpm/init.d.php-fpm sapi/fpm/php-fpm.service sapi/fpm/php-fpm.8 sapi/fpm/status.html
	rm -f ext/iconv/php_have_bsd_iconv.h ext/iconv/php_have_glibc_iconv.h ext/iconv/php_have_ibm_iconv.h ext/iconv/php_have_iconv.h ext/iconv/php_have_libiconv.h ext/iconv/php_iconv_aliased_libiconv.h ext/iconv/php_iconv_supports_errno.h ext/iconv/php_php_iconv_h_path.h ext/iconv/php_php_iconv_impl.h
	rm -f ext/phar/phar.phar ext/phar/phar.php
	if test "$(srcdir)" != "$(builddir)"; then \
	  rm -f ext/phar/phar/phar.inc; \
	fi
	$(EGREP) define'.*include/php' $(top_srcdir)/configure | $(SED) 's/.*>//'|xargs rm -f

prof-gen:
	CCACHE_DISABLE=1 $(MAKE) PROF_FLAGS=-fprofile-generate all

prof-clean:
	find . -name \*.lo -o -name \*.o | xargs rm -f
	find . -name \*.la -o -name \*.a | xargs rm -f
	find . -name \*.so | xargs rm -f
	rm -f libphp$(PHP_MAJOR_VERSION).la $(SAPI_CLI_PATH) $(SAPI_CGI_PATH) $(SAPI_MILTER_PATH) $(SAPI_LITESPEED_PATH) $(SAPI_FPM_PATH) $(OVERALL_TARGET) modules/* libs/*

prof-use:
	CCACHE_DISABLE=1 $(MAKE) PROF_FLAGS=-fprofile-use all


.PHONY: all clean install distclean test prof-gen prof-clean prof-use
.NOEXPORT:
src/ext/ddtrace.lo: /usr/local/opt/datadog-php/src/ext/ddtrace.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/ddtrace.c -o src/ext/ddtrace.lo 
src/dogstatsd/client.lo: /usr/local/opt/datadog-php/src/dogstatsd/client.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/dogstatsd/client.c -o src/dogstatsd/client.lo 
src/ext/arrays.lo: /usr/local/opt/datadog-php/src/ext/arrays.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/arrays.c -o src/ext/arrays.lo 
src/ext/circuit_breaker.lo: /usr/local/opt/datadog-php/src/ext/circuit_breaker.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/circuit_breaker.c -o src/ext/circuit_breaker.lo 
src/ext/comms_php.lo: /usr/local/opt/datadog-php/src/ext/comms_php.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/comms_php.c -o src/ext/comms_php.lo 
src/ext/compat_string.lo: /usr/local/opt/datadog-php/src/ext/compat_string.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/compat_string.c -o src/ext/compat_string.lo 
src/ext/coms.lo: /usr/local/opt/datadog-php/src/ext/coms.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/coms.c -o src/ext/coms.lo 
src/ext/configuration.lo: /usr/local/opt/datadog-php/src/ext/configuration.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/configuration.c -o src/ext/configuration.lo 
src/ext/configuration_php_iface.lo: /usr/local/opt/datadog-php/src/ext/configuration_php_iface.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/configuration_php_iface.c -o src/ext/configuration_php_iface.lo 
src/ext/dispatch.lo: /usr/local/opt/datadog-php/src/ext/dispatch.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/dispatch.c -o src/ext/dispatch.lo 
src/ext/dispatch_setup.lo: /usr/local/opt/datadog-php/src/ext/dispatch_setup.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/dispatch_setup.c -o src/ext/dispatch_setup.lo 
src/ext/dogstatsd_client.lo: /usr/local/opt/datadog-php/src/ext/dogstatsd_client.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/dogstatsd_client.c -o src/ext/dogstatsd_client.lo 
src/ext/engine_hooks.lo: /usr/local/opt/datadog-php/src/ext/engine_hooks.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/engine_hooks.c -o src/ext/engine_hooks.lo 
src/ext/env_config.lo: /usr/local/opt/datadog-php/src/ext/env_config.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/env_config.c -o src/ext/env_config.lo 
src/ext/logging.lo: /usr/local/opt/datadog-php/src/ext/logging.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/logging.c -o src/ext/logging.lo 
src/ext/memory_limit.lo: /usr/local/opt/datadog-php/src/ext/memory_limit.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/memory_limit.c -o src/ext/memory_limit.lo 
src/ext/mpack/mpack.lo: /usr/local/opt/datadog-php/src/ext/mpack/mpack.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/mpack/mpack.c -o src/ext/mpack/mpack.lo 
src/ext/random.lo: /usr/local/opt/datadog-php/src/ext/random.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/random.c -o src/ext/random.lo 
src/ext/request_hooks.lo: /usr/local/opt/datadog-php/src/ext/request_hooks.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/request_hooks.c -o src/ext/request_hooks.lo 
src/ext/serializer.lo: /usr/local/opt/datadog-php/src/ext/serializer.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/serializer.c -o src/ext/serializer.lo 
src/ext/signals.lo: /usr/local/opt/datadog-php/src/ext/signals.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/signals.c -o src/ext/signals.lo 
src/ext/span.lo: /usr/local/opt/datadog-php/src/ext/span.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/span.c -o src/ext/span.lo 
src/ext/third-party/mt19937-64.lo: /usr/local/opt/datadog-php/src/ext/third-party/mt19937-64.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/third-party/mt19937-64.c -o src/ext/third-party/mt19937-64.lo 
src/ext/php7/dispatch.lo: /usr/local/opt/datadog-php/src/ext/php7/dispatch.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/php7/dispatch.c -o src/ext/php7/dispatch.lo 
src/ext/php7/engine_hooks.lo: /usr/local/opt/datadog-php/src/ext/php7/engine_hooks.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -Wall -std=gnu11 -I. -I/usr/local/opt/datadog-php $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /usr/local/opt/datadog-php/src/ext/php7/engine_hooks.c -o src/ext/php7/engine_hooks.lo 
$(phplibdir)/ddtrace.la: ./ddtrace.la
	$(LIBTOOL) --mode=install cp ./ddtrace.la $(phplibdir)

./ddtrace.la: $(shared_objects_ddtrace) $(DDTRACE_SHARED_DEPENDENCIES)
	$(LIBTOOL) --mode=link $(CC) $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS)  -o $@ -export-dynamic -avoid-version -prefer-pic -module -rpath $(phplibdir) $(EXTRA_LDFLAGS) $(shared_objects_ddtrace) $(DDTRACE_SHARED_LIBADD)

