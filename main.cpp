#include <iostream>
#include <vector>

#include <cudaLinearAlgebra.hpp>

int					main() {

	int myints[] = {16,2,77,29};
	std::vector<int> vec(myints, myints + sizeof(myints) / sizeof(int));

	int myints2[] = {1,2,3,4,5,6};
	std::vector<int> vec2(myints2, myints2 + sizeof(myints2) / sizeof(int));

	int myints3[] = {5,2,10,1,6,12,8,3,9,4,11,6};
	std::vector<int> vec3(myints3, myints3 + sizeof(myints3) / sizeof(int));



	// for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';

	// element_wise(&vec[0], vec.size(), 1, ADD);

	// for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';


	// element_wise(&vec[0], vec.size(), 10, SUB);

	// for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';


	// element_wise(&vec[0], vec.size(), 3, MUL);

	// for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';


	// element_wise(&vec[0], vec.size(), 2, DIV);

	// for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';

	///////////////////////////////////////
	// int			*a = element_wise(&vec[0], &vec2[0], vec.size(), ADD);
	// std::vector<int> vec3(a, a + 4);


	// for (std::vector<int>::iterator it = vec3.begin(); it != vec3.end(); ++it)
	// 	std::cout << ' ' << *it;
	// std::cout << '\n';
	////////////////////////////////////////



	// 1  2  3		5  2  10 1			a  c  e  g
	// 4  5  6		6  12 8  3			b  d  f  h
	// 				9  4  11 6

	// [5][12][27] [2][24][12] [10][16][33] ...
	// [44]		   [38]		   [59]		 	...


	int			*a = dot_product(&vec2[0], &vec3[0], 2, 3, 3, 4);
	std::vector<int> vec4(a, a + (2 * 4));


	for (std::vector<int>::iterator it = vec2.begin(); it != vec2.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';

	for (std::vector<int>::iterator it = vec3.begin(); it != vec3.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';

	for (std::vector<int>::iterator it = vec4.begin(); it != vec4.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';




	return (0);
}
