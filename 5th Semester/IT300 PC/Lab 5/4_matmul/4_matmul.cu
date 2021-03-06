#include<stdio.h>
#define N 64
#define BLOCK_DIM 16

__global__ void matrixmul (int *a, int *b, int *c,int width);
void printArray(int a[N][N], int b[N][N], int c[N][N]);

int main() {
    int a[N][N], b[N][N], c[N][N];
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            a[i][j] = i+j;
            b[i][j] = i-j;
            c[i][j] = 0;
        }
    }
    int *dev_a, *dev_b, *dev_c;
    int size = N * N * sizeof(int);
    clock_t t;
	double time_taken;

    FILE *fp;
    fp = fopen ("output.txt","a");

    t = clock();

    // initialize a and b with real values (NOT SHOWN)
    cudaMalloc((void**) &dev_a, size);
    cudaMalloc((void**) &dev_b, size);
    cudaMalloc((void**) &dev_c, size);

    cudaMemcpy (dev_a, a, size, cudaMemcpyHostToDevice) ;
    cudaMemcpy (dev_b, b, size, cudaMemcpyHostToDevice) ;
    dim3 dimGrid(1,1);
    dim3 dimBlock(BLOCK_DIM, BLOCK_DIM) ;

    matrixmul<<<dimGrid, dimBlock>>> (dev_a,dev_b,dev_c,N);
    
    cudaMemcpy(c, dev_c, size, cudaMemcpyDeviceToHost) ;
    cudaFree(dev_a); 
    cudaFree(dev_b); 
    cudaFree(dev_c);

    t = clock() - t;
	time_taken = ((double)t)/CLOCKS_PER_SEC;
	printf("Matrix multiplication for 2-D array of size %dx%d and block size 16x16 took %lf seconds to execute \n", N, N, time_taken); 

	fprintf (fp, "%d %lf\n", N, time_taken);

    fclose(fp);

    // printArray(a,b,c);

    exit (0);
}

__global__ void matrixmul (int *a, int *b, int *e,int width) {
    int sum=0;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    if (col < width && row < width) {
        for(int k=0;k<width;k++)
            sum+=a[row*width+k]*b[k*width+col];
        e[row*width+col] = sum;
    }
}

void printArray(int a[N][N], int b[N][N], int c[N][N]) {

    printf("Array a:\n");
	for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            printf("%d ", a[i][j]);
        }
        printf("\n");
    }
    printf("\n\nArray b:\n");
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            printf("%d ", b[i][j]);
        }
        printf("\n");
    }
    printf("\n\nArray c:\n");
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            printf("%d ", c[i][j]);
        }
        printf("\n");
    }
    printf("\n");

}