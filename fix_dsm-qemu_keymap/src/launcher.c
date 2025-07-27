#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>


int main(int argc, char *argv[]) {

	// Créer le processus enfant

		int total_args = argc + 3;  // "-k", "fr", NULL

        char **child_argv = malloc(sizeof(char *) * total_args);
        if (!child_argv) {
            perror("malloc");
            exit(EXIT_FAILURE);
        }

        child_argv[0] = "/var/packages/Virtualization/target/bin/qemu-system-x86_64.bin";  // nom du programme exécuté
		//child_argv[0] = "/bin/echo";
        child_argv[1] = "-k";
        child_argv[2] = "fr";

        // Copier les arguments passés à launcher
        for (int i = 1; i < argc; i++) {
            child_argv[i + 2] = argv[i];
        }

        child_argv[total_args - 1] = NULL;  // terminaison NULL

		execv(child_argv[0], child_argv);

		// Si exec échoue
		perror("execl a échoué");
		exit(EXIT_FAILURE);
}
