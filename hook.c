#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>
#include <fcntl.h>
int __libc_start_main(int (*main) (int, char**, char**),
                      int argc,
                      char **argv,
                      void (*init) (void),
                      void (*fini)(void),
                      void (*rtld_fini)(void),
                      void (*stack_end))
{
    int i;
    FILE *fp = fopen("decrypt.txt", "w");
    for(i=0; i <argc; i++) {
        fprintf(fp, "%s\n", argv[i]);
    }
    fclose(fp);
    int (*real) (int (*main) (int, char**, char**),
                      int argc,
                      char **argv,
                      void (*init) (void),
                      void (*fini)(void),
                      void (*rtld_fini)(void),
                      void (*stack_end)) = dlsym(RTLD_NEXT, "__libc_start_main"); 
    return(real(main, argc, argv, init, fini, rtld_fini, stack_end));           
}
