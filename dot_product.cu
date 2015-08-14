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
    res_row_idx = (id / ncol1) / ncol2;
    res_col_idx = (id / ncol1) % ncol2;
    idx_in_cell = (id) % ncol1;
    res[id] = m1[res_row_idx][idx_in_cell] * m2[idx_in_cell][res_col_idx];

    __syncthreads();
    // sum reduce
    for (int i = 2; i < ncol2; i * 2) {
      
    }
  }
}


int           *dot_product(int *m1, int *m2, int nrow1, int ncol1, int nrow2, int ncol2) {

  int         *h_res = (int *)malloc(sizeof(int) * (nrow1 * ncol2));
  int         *d_m1;
  int         **d_m1_ = &d_m1;
  int         *d_m2;
  int         **d_m2_ = &d_m2;
  int         *d_res;
  int         **d_res_ = &d_res;

  int		blocks = ((nrow1 * ncol2) % NB_THREADS == 0) ? ((nrow1 * ncol2 * ncol1) / NB_THREADS):((nrow1 * ncol2) / NB_THREADS) + 1;

  checkCudaErrors(cudaMalloc(d_m1_, sizeof(int) * len));
  checkCudaErrors(cudaMalloc(d_m2_, sizeof(int) * len));
  checkCudaErrors(cudaMalloc(d_res_, sizeof(int) * len));
  checkCudaErrors(cudaMemcpy(d_m1, v, sizeof(int) * (nrow1 * ncol1), cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_m2, v, sizeof(int) * (nrow2 * ncol2), cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemset(d_res, 0, sizeof(int) * (nrow1 * ncol2 * ncol1)));

  k_dot_product<<<blocks, NB_THREADS>>>(d_res, d_m1, d_m2, nrow1, ncol1, nrow2, ncol2);

  cudaDeviceSynchronize();// checkCudaErrors(cudaGetLastError());
  checkCudaErrors(cudaMemcpy(h_result, d_result, sizeof(int) * len, cudaMemcpyDeviceToHost));

  cudaFree(d_m1_);
  cudaFree(d_m2_);
  cudaFree(d_res_);

  return (h_res);
}
