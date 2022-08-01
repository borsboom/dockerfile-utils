void myfunc(char *const src, int len) {
    int i;
    for (i = 0; i < len; ++i) {
        src[i] = 42;
    }
}

int main(void) {
    char arr[] = {'a', 'b', 'c', 'd'};
    int len = sizeof(arr);
    myfunc(arr, len + 1);
    return 0;
}
