#include <iostream>
#include <vector>

#include <cudaLinearAlgebra.hpp>

int					main() {

	int myints[] = {16,2,77,29};
	std::vector<int> vec(myints, myints + sizeof(myints) / sizeof(int));

	int myints2[] = {1,2,3,4};
	std::vector<int> vec2(myints2, myints2 + sizeof(myints2) / sizeof(int));



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


	int			*a = element_wise(&vec[0], &vec2[0], vec.size(), ADD);
	std::vector<int> vec3(a, a + 4);


	for (std::vector<int>::iterator it = vec3.begin(); it != vec3.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';


	return (0);
}
