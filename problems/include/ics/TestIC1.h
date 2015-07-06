#ifndef TESTIC1_H
#define TESTIC1_H

#include "InitialCondition.h"
#include <stdio.h>
#include <iostream>

class TestIC1;
template<>
InputParameters validParams<TestIC1>();

class TestIC1 : public InitialCondition 

{
    public:
    TestIC1(const std::string & name,
              InputParameters parameters);

    virtual Real value(const Point & p);
    
    private: 
        Real _coefficient;
};

#endif 
