#include <errno.h>
#include <limits.h>
#include <mach-o/dyld.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static const char site_lisp[] = "@siteLisp@";
static const char native_lisp[] = "@nativeLisp@";

static void executable_directory(char directory[PATH_MAX]) {
  /*
   * Home Manager copies the application out of the Nix store. Resolve the
   * sibling executable at runtime so exec(2) stays inside the launched bundle
   * and LaunchServices keeps the application associated with the correct PID.
   */
  char executable[PATH_MAX];
  uint32_t size = sizeof(executable);
  char *separator;

  if (_NSGetExecutablePath(executable, &size) != 0) {
    fprintf(stderr, "Emacs launcher path exceeds PATH_MAX\n");
    exit(EXIT_FAILURE);
  }
  if (realpath(executable, directory) == NULL) {
    perror("realpath");
    exit(EXIT_FAILURE);
  }
  separator = strrchr(directory, '/');
  if (separator == NULL) {
    fprintf(stderr, "Emacs launcher has no parent directory: %s\n", directory);
    exit(EXIT_FAILURE);
  }
  *separator = '\0';
}

/*
 * Match nixpkgs' emacsWithPackages wrapper: when the variable is unset, add
 * the package path followed by an empty element; otherwise insert the package
 * path immediately before its first empty element. A non-empty value without
 * an empty element is an explicit override and remains unchanged.
 */
static char *add_before_first_empty(const char *value, const char *addition) {
  size_t value_length;
  size_t addition_length = strlen(addition);
  size_t insertion = (size_t)-1;
  char *result;

  if (value == NULL || value[0] == '\0') {
    result = malloc(addition_length + 2);
    if (result == NULL) {
      return NULL;
    }
    memcpy(result, addition, addition_length);
    result[addition_length] = ':';
    result[addition_length + 1] = '\0';
    return result;
  }

  value_length = strlen(value);
  if (value[0] == ':') {
    insertion = 0;
  } else {
    for (size_t i = 1; i < value_length; ++i) {
      if (value[i - 1] == ':' && value[i] == ':') {
        insertion = i;
        break;
      }
    }
    if (insertion == (size_t)-1 && value[value_length - 1] == ':') {
      insertion = value_length;
    }
  }

  if (insertion == (size_t)-1) {
    return strdup(value);
  }

  result = malloc(value_length + addition_length + 2);
  if (result == NULL) {
    return NULL;
  }
  memcpy(result, value, insertion);
  memcpy(result + insertion, addition, addition_length);
  result[insertion + addition_length] = ':';
  memcpy(result + insertion + addition_length + 1, value + insertion,
         value_length - insertion + 1);
  return result;
}

static void set_load_path(const char *name, const char *addition) {
  char *value = add_before_first_empty(getenv(name), addition);
  if (value == NULL || setenv(name, value, 1) != 0) {
    perror(name);
    free(value);
    exit(EXIT_FAILURE);
  }
  free(value);
}

static void set_value(const char *name, const char *value) {
  if (setenv(name, value, 1) != 0) {
    perror(name);
    exit(EXIT_FAILURE);
  }
}

int main(int argc, char **argv) {
  char directory[PATH_MAX];
  char invocation_directory[PATH_MAX];
  char real_emacs[PATH_MAX];

  (void)argc;
  executable_directory(directory);
  if (snprintf(real_emacs, sizeof(real_emacs), "%s/.Emacs-wrapped", directory) >=
          (int)sizeof(real_emacs) ||
      snprintf(invocation_directory, sizeof(invocation_directory), "%s/",
               directory) >= (int)sizeof(invocation_directory)) {
    fprintf(stderr, "Emacs bundle path exceeds PATH_MAX\n");
    return EXIT_FAILURE;
  }

  set_load_path("EMACSLOADPATH", site_lisp);
  set_load_path("EMACSNATIVELOADPATH", native_lisp);
  set_value("emacsWithPackages_siteLisp", site_lisp);
  set_value("emacsWithPackages_siteLispNative", native_lisp);
  set_value("emacsWithPackages_invocationDirectory", invocation_directory);
  set_value("emacsWithPackages_invocationName", "Emacs");

  argv[0] = (char *)real_emacs;
  execv(real_emacs, argv);
  fprintf(stderr, "failed to execute %s: %s\n", real_emacs, strerror(errno));
  return EXIT_FAILURE;
}
