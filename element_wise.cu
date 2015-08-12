#include <iostream>
#include <stdio.h>
#include <cuda.h>

#define NB_THREADS 50

#define checkCudaErrors(val) check( (val), #val, __FILE__, __LINE__)

enum ft_op {ADD = 0, SUB, MUL, DIV, MOD};



template<typename T>
void check(T err, const char* const func, const char* const file, const int line) {
  if (err != cudaSuccess) {
    std::cerr << "CUDA error at: " << file << ":" << line << std::endl;
    std::cerr << cudaGetErrorString(err) << " " << func << std::endl;
    exit(1);
  }
}


__global__ void	k_addition_element_wise(int *values, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		values[id] += n;
}

__global__ void	k_substraction_element_wise(int *values, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		values[id] -= n;
}

__global__ void	k_multiplication_element_wise(int *values, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		values[id] *= n;
}

__global__ void	k_division_element_wise(int *values, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		values[id] /= n;
}

__global__ void	k_modulo_element_wise(int *values, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		values[id] = values[id] % n;
}

void			element_wise(int *v, int len, int n, ft_op op) {

	int		*d_values;
	int		**d_values_ = &d_values;

	int		blocks = (len % NB_THREADS == 0) ? (len / NB_THREADS):(len / NB_THREADS) + 1;

	checkCudaErrors(cudaMalloc(d_values_, sizeof(int) * len));
	checkCudaErrors(cudaMemcpy(d_values, v, sizeof(int) * len, cudaMemcpyHostToDevice));

	if (op == ADD)
		k_addition_element_wise<<<blocks, NB_THREADS>>>(d_values, len, n);
	else if (op == SUB)
		k_substraction_element_wise<<<blocks, NB_THREADS>>>(d_values, len, n);
	else if (op == MUL)
		k_multiplication_element_wise<<<blocks, NB_THREADS>>>(d_values, len, n);
	else if (op == DIV)
		k_division_element_wise<<<blocks, NB_THREADS>>>(d_values, len, n);
	else if (op == MOD)
		k_modulo_element_wise<<<blocks, NB_THREADS>>>(d_values, len, n);

	cudaDeviceSynchronize();// checkCudaErrors(cudaGetLastError());
	checkCudaErrors(cudaMemcpy(v, d_values, sizeof(int) * len, cudaMemcpyDeviceToHost));
	cudaFree(d_values_);
}
