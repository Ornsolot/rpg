#include "ocml.h"

void fct1(void *a)
{
    printf("nb : %d\n", *((int *)a));
}

int main()
{
    int a = 5;
    sfThread *thread1= sfThread_create(fct1, &a);
    sfThread_launch(thread1);
    for (int i = 0; i < 40; i++) {
        printf("Main : Hello\n");
    }
    sfThread_wait(thread1);
    return 0;
}

