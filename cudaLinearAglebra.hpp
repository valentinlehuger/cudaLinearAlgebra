#ifndef CUDALINEARALGEBRA_HPP
#define CUDALINEARALGEBRA_HPP

#define NB_THREADS 50


enum ft_op {ADD = 0, SUB, MUL, DIV, MOD};

/*
**	Element wise function for vector int operation
**	Returns a int array containing the operation result
*/
int 			*element_wise(int *v, int len, int n, ft_op op);

/*
**	Element wise function for vector vector operation
**	Returns a int array containing the operation result
*/
int			  *element_wise(int *v1, int *v2, int len, ft_op op);

#endif
