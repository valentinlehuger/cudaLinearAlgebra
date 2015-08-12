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


__global__ void	k_addition_element_wise(int *vec, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		vec[id] += n;
}

__global__ void	k_addition_element_wise(int *result, int *vec1, int *vec2, int len) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		result[id] = vec1[id] + vec2[id];
}

__global__ void	k_substraction_element_wise(int *vec, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		vec[id] -= n;
}

__global__ void	k_multiplication_element_wise(int *vec, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		vec[id] *= n;
}

__global__ void	k_division_element_wise(int *vec, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		vec[id] /= n;
}

__global__ void	k_modulo_element_wise(int *vec, int len, int n) {

	int			id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < len)
		vec[id] = vec[id] % n;
}

void			element_wise(int *v, int len, int n, ft_op op) {

	int		*d_vec;
	int		**d_vec_ = &d_vec;

	int		blocks = (len % NB_THREADS == 0) ? (len / NB_THREADS):(len / NB_THREADS) + 1;

	checkCudaErrors(cudaMalloc(d_vec_, sizeof(int) * len));
	checkCudaErrors(cudaMemcpy(d_vec, v, sizeof(int) * len, cudaMemcpyHostToDevice));

	if (op == ADD)
		k_addition_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	else if (op == SUB)
		k_substraction_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	else if (op == MUL)
		k_multiplication_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	else if (op == DIV)
		k_division_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	else if (op == MOD)
		k_modulo_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);

	cudaDeviceSynchronize();// checkCudaErrors(cudaGetLastError());
	checkCudaErrors(cudaMemcpy(v, d_vec, sizeof(int) * len, cudaMemcpyDeviceToHost));
	cudaFree(d_vec_);
}

/*
**	Element wise function for vector vector operation
**	Returns a int array containing the operation result
*/

int			*element_wise(int *v1, int *v2, int len, ft_op op) {

	int		*d_vec1;
	int		*d_vec2;
	int		**d_vec1_ = &d_vec1;
	int		**d_vec2_ = &d_vec2;
	int		*h_result = (int *)malloc(sizeof(int) * len);
	int		*d_result;
	int		**d_result_ = &d_result;


	int		blocks = (len % NB_THREADS == 0) ? (len / NB_THREADS):(len / NB_THREADS) + 1;

	checkCudaErrors(cudaMalloc(d_vec1_, sizeof(int) * len));
	checkCudaErrors(cudaMalloc(d_vec2_, sizeof(int) * len));
	checkCudaErrors(cudaMalloc(d_result_, sizeof(int) * len));
	checkCudaErrors(cudaMemcpy(d_vec1, v1, sizeof(int) * len, cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemcpy(d_vec2, v2, sizeof(int) * len, cudaMemcpyHostToDevice));
	// checkCudaErrors(cudaMemcpy(d_result, h_result, sizeof(int) * len, cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemset(d_result, 0, sizeof(int) * len));

	if (op == ADD)
		k_addition_element_wise<<<blocks, NB_THREADS>>>(d_result, d_vec1, d_vec2, len);
	// else if (op == SUB)
	// 	k_substraction_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	// else if (op == MUL)
	// 	k_multiplication_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	// else if (op == DIV)
	// 	k_division_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);
	// else if (op == MOD)
	// 	k_modulo_element_wise<<<blocks, NB_THREADS>>>(d_vec, len, n);

	cudaDeviceSynchronize();// checkCudaErrors(cudaGetLastError());
	checkCudaErrors(cudaMemcpy(h_result, d_result, sizeof(int) * len, cudaMemcpyDeviceToHost));
	cudaFree(d_vec1_);
	cudaFree(d_vec2_);
	cudaFree(d_result_);
	return (h_result);
}
