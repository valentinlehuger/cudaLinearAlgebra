#include <iostream>
#include <vector>

enum ft_op {ADD = 0, SUB, MUL, DIV, MOD};

void			element_wise(int *v, int len, int n, ft_op op);


int					main() {

	int myints[] = {16,2,77,29};
	std::vector<int> vec(myints, myints + sizeof(myints) / sizeof(int));

	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';

	element_wise(&vec[0], vec.size(), 1, ADD);

	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';


	element_wise(&vec[0], vec.size(), 10, SUB);

	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';


	element_wise(&vec[0], vec.size(), 3, MUL);

	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';


	element_wise(&vec[0], vec.size(), 2, DIV);

	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); ++it)
		std::cout << ' ' << *it;
	std::cout << '\n';



	return (0);
}