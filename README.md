# gradient-domain-fusion

![](http://jmecom.github.io/images/gradient-domain-fusion/sf-npr-big.png)

#### [Full writeup here.](http://ahris.github.io/articles/gradient-domain-fusion/)

Developed by [Jordan Mecom](http://jmecom.github.io) and [Alice Wang](http://github.com/ahris).

This project explores image blending and non-photo realistic rendering using gradient domain fusion (adapted from the SIGGRAPH 2010 talk about [GradientShop](http://grail.cs.washington.edu/projects/gradientshop/)). Given an input image, gradient domain image processing first finds the gradient of the given image, and then solves for a new image using a system of equations. The equations act as constraints, defining what problem is solved. In this project, we explore a simple toy problem, Poisson blending, and non-photo realistic rendering. 
