Building GraphViz 2.32
======================

I applied the following quick hacks to emscripten:

diff --git a/system/include/libc/sys/unistd.h b/system/include/libc/sys/unistd.h
index a4219d4..460a0dc 100644
--- a/system/include/libc/sys/unistd.h
+++ b/system/include/libc/sys/unistd.h
@@ -104,7 +104,7 @@ uid_t   _EXFUN(getuid, (void ));
 char * _EXFUN(getusershell, (void));
 int    _EXFUN(iruserok, (unsigned long raddr, int superuser, const char *ruser, const char *luser));
 #endif
-int     _EXFUN(isatty, (int __fildes ));
+// int     _EXFUN(isatty, (int __fildes ));
 #if !defined(__INSIDE_CYGWIN__)
 int     _EXFUN(lchown, (const char *__path, uid_t __owner, gid_t __group ));
 #endif

diff --git a/system/include/libc/regex.h b/system/include/libc/regex.h
index 2ac78f4..feb8911 100644
--- a/system/include/libc/regex.h
+++ b/system/include/libc/regex.h
@@ -38,6 +38,7 @@
 #define        _REGEX_H_
 
 #include <sys/cdefs.h>
+#include <sys/types.h>
 
 /* types */
 typedef off_t regoff_t;

