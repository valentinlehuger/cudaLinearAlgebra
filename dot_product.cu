#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <cudaLinearAlgebra.hpp>

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)

template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    std::cerr << "CUDA error at: " << file << ":" << line << std::endl;
    std::cerr << cudaGetErrorString(err) << " " << func << std::endl;
    exit(1);
  }
}


__global__ void k_dot_product(int *res, int *m1, int *m2, int nrow1, int ncol1, int nrow2, int ncol2) {

  int			id = blockDim.x * blockIdx.x + threadIdx.x;

  if (id < (nrow1 * ncol2 * ncol1)) {
    // product
    int res_row_idx = (id / ncol1) / ncol2;
    int res_col_idx = (id / ncol1) % ncol2;
    int idx_in_cell = (id) % ncol1;

    res[id] = m1[res_row_idx * ncol1 + idx_in_cell] * m2[idx_in_cell * ncol2 + res_col_idx];

    __syncthreads();

    // sum reduce
    int s = ncol1;
    for (int i = ncol1 / 2; i > 0; i >>= 1) {
      if (idx_in_cell < i) {
        // printf("idx_in_cell : %d -- res[%d] += res[%d + %d] -> %d += %d\n", idx_in_cell, id, id, i, res[id], res[id + i]);
        res[id] += res[id + i];
        if (s % 2 == 1 && idx_in_cell == (i - 1))
          res[id] += res[id + i + 1];
      }
      else
        break ;
      s = i;
      __syncthreads();
    }
  }
}

  // 1  2  3    5  2  10 1      a  c  e  g
  // 4  5  6    6  12 8  3      b  d  f  h
  //            9  4  11 6

  // [5][12][27] [2][24][12] [10][16][33] ...
  // [44]        [38]        [59]         ...


int           *dot_product(int *m1, int *m2, int nrow1, int ncol1, int nrow2, int ncol2) {

  int         *h_res = (int *)malloc(sizeof(int) * (nrow1 * ncol2) * ncol1);
  int         *res = (int *)malloc(sizeof(int) * (nrow1 * ncol2));
  int         *d_m1;
  int         **d_m1_ = &d_m1;
  int         *d_m2;
  int         **d_m2_ = &d_m2;
  int         *d_res;
  int         **d_res_ = &d_res;

  int		blocks = ((nrow1 * ncol2) % NB_THREADS == 0) ? ((nrow1 * ncol2 * ncol1) / NB_THREADS):((nrow1 * ncol2) / NB_THREADS) + 1;

  checkCudaErrors(cudaMalloc(d_m1_, sizeof(int) * (nrow1 * ncol1)));
  checkCudaErrors(cudaMalloc(d_m2_, sizeof(int) * (nrow2 * ncol2)));
  checkCudaErrors(cudaMalloc(d_res_, sizeof(int) * (nrow1 * ncol2 * ncol1)));
  checkCudaErrors(cudaMemcpy(d_m1, m1, sizeof(int) * (nrow1 * ncol1), cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_m2, m2, sizeof(int) * (nrow2 * ncol2), cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemset(d_res, 0, sizeof(int) * (nrow1 * ncol2 * ncol1)));

  k_dot_product<<<blocks, NB_THREADS>>>(d_res, d_m1, d_m2, nrow1, ncol1, nrow2, ncol2);

  cudaDeviceSynchronize();// checkCudaErrors(cudaGetLastError());
  checkCudaErrors(cudaMemcpy(h_res, d_res, sizeof(int) * (nrow1 * ncol2 * ncol1), cudaMemcpyDeviceToHost));

  cudaFree(d_m1_);
  cudaFree(d_m2_);
  cudaFree(d_res_);

  for (int i = 0; i < nrow1 * ncol2; i++) {
    res[i] = h_res[i * ncol1];
  }
  return (res);
}
