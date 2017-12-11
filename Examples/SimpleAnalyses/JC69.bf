/* This is an example HY-PHY Batch File.   It reads in a '#' nucleotide dataset data/hiv.nuc and estimates   maximum ln-likelihood based on the tree contained in the data file,   using Jukes Cantor 69 model.      Output is printed out as a Newick Style tree with branch lengths   representing the number of expected substitutions per branch (which   is the default setting for nucleotide models w/o rate variation).         Sergei L. Kosakovsky Pond and Spencer V. Muse    December 1999. *//* 1. Read in the data and store the result in a DataSet variable.*/DataSet 		nucleotideSequences = ReadDataFile ("data/hiv.nuc");   /* 2. Filter the data, specifying that all of the data is to be used	  and that it is to be treated as nucleotides.*/	  DataSetFilter	filteredData = CreateFilter (nucleotideSequences,1);/* 3. Define the F81 substitution matrix. '*' is defined to be -(sum of off-diag row elements) */JC69RateMatrix = 		{{*,mu,mu,mu}		 {mu,*,mu,mu}		 {mu,mu,*,mu}		 {mu,mu,mu,*}};		 /*4.  Define the F81 models, by combining the substitution matrix with the vector of equal equilibrium	  frequencies. */equalFreqs = {{.25}{.25}{.25}{.25}};Model 	F81 = (JC69RateMatrix, equalFreqs);/*5.  Now we can define the tree variable, using the tree string read from the data file,	  and, by default, assigning the last defined model (JC69) to all tree branches. */	  Tree	givenTree = DATAFILE_TREE;/*6.  Since all the likelihood function ingredients (data, tree, equilibrium frequencies)	  have been defined we are ready to construct the likelihood function. */	  LikelihoodFunction  theLnLik = (filteredData, givenTree);/*7.  Maximize the likelihood function, storing parameter values in the matrix paramValues */Optimize (paramValues, theLnLik);/*8.  Print the tree with optimal branch lengths to the console. */fprintf  (stdout, theLnLik);		    