void main() {
    int A = 8;
    int B = 3;
    int C = 3;
    int D = 5;
    int* dPtr = &D;
    unsigned int E = 0x5A5A;
    unsigned int F = 0x6767;
    unsigned int G = 0x3C;
    unsigned int H = 0xFF;

    if ((A-B) > 3) {
        C = C + 4;
        D = C - 3;
        G = E | F;
    } else {
        C = C << 3;
        *dPtr = 7;
        G = E & F;
    }

    A = A + B;
    G = (E ^ F) & H;
}
