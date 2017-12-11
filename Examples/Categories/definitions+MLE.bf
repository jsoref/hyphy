/* This is an example HY-PHY Batch File.	In this file, we will illustrate how to integrate category 	variables into evolutionary models	   Sergei L. Kosakovsky Pond and Spencer V. Muse    June 2001. *//* 0. Read in the file that contains a function to display	  properties of a category variable */	  #include "displayfunction.bf";	  /* 1. Read and filter the data */DataSet 		spectrinData = ReadDataFile ("data/aspectrin.nuc");DataSetFilter	filteredData = CreateFilter (spectrinData,1);HarvestFrequencies (observedFreqs, filteredData, 1, 1, 1);/* 2. Define the category variable PRIOR to initializing the model matrix */category catVar = (2,EQUAL,MEAN, ,{{1}{5}}, 1,2);/* 3. Now define the HKY85 model with each rate matrix entry having the 	  additional multiplier of catVar. This instructs HyPhy to compute 	  E[likelihood] with respect to catVar. "t" is the branch length.s*/global   TR;/* shared transversion/transition ratio. */HKY85RateMatrix = 		{{*,			t*catVar*TR,		t*catVar,		t*catVar*TR}		 {t*catVar*TR,	*,					t*catVar*TR,	t*catVar}		 {t*catVar,		t*catVar*TR,		*,				t*catVar*TR}		 {t*TR*catVar,	t*catVar,			t*catVar*TR,	*}};Model HKY85	 = (HKY85RateMatrix, observedFreqs);/* 4. Define the tree and the likelihood function. Obtain MLE and report results. */Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Export (modelStr, USE_LAST_MODEL);fprintf (stdout, modelStr, "\n");Optimize (result, theLnLik);fprintf (stdout,"1). 2 fixed equiprobable rates\n\n",theLnLik);/* Get information about the catVar:	a two column matrix of rates and their probabilities,	and pass it to the echoCatVar function (defined in	the file included at step 0. for display */	GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);/* 5. Redefine the category variable and repeat optimization. 	  Note that the tree and the likelihood function must also be redefined	  to incorporate the updates to catVar.*/category catVar = (2,{{1/3}{2/3}} ,MEAN, ,{{1}{5}}, 1,2);Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"\n\n2). 2 fixed rates with different probabilities\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global R = 1;category catVar = (3,EQUAL,MEAN, ,{{R}{4*R}{9*R}}, 0, 1e25);Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"\n\n3). 3 proportional equiprobable rates\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global lambda = 1;rateMatrix = {8,1};for (k=0; k<8; k=k+1){	rateMatrix[k][0]:=k__;}probMatrix = {8,1}; probMatrix[0][0]:= Exp(-lambda);factorial = 1;for (k=1; k<8; k=k+1){	factorial = factorial*k;	probMatrix[k][0]:=lambda^(k__)/factorial__*Exp(-lambda);}category catVar = (8,probMatrix,MEAN, ,rateMatrix, 0, 1e25);Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"4). Truncated Poisson with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global P = .1;P:<1;rateMatrix = {10,1};for (k=0; k<10; k=k+1){	rateMatrix[k][0]:=k__;}probMatrix = {10,1}; probMatrix[0][0]:= (1-P);for (k=1; k<10; k=k+1){	probMatrix[k][0]:=(1-P)*P^(k__);}category catVar = (10,probMatrix,MEAN, ,rateMatrix, 0, 1e25);Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"5). Truncated geometric with 10 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global 	lambda = 1;category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"6.1). Discretized (by MEAN) exponential with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global 	lambda = 1;category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"6.2). Discretized (by MEDIAN) exponential with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global 	lambda = 1;category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					SCALED_MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"6.3). Discretized (by SCALED_MEDIAN) exponential with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global alpha = .5;alpha:>0.01;alpha:<100;category catVar =  (10,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					GammaDist(_x_,alpha,alpha), /* density */					CGammaDist(_x_,alpha,alpha), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					CGammaDist(_x_,alpha+1,alpha)						/* "antiderivative" of x f(x) */				   );Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"7). Discretized gamma with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global betaP = 1;global betaQ = 1;betaP:>0.05;betaP:<100;betaQ:>0.05;betaQ:<100;category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					_x_^(betaP-1)*(1-_x_)^(betaQ-1)/Beta(betaP,betaQ), /* density */					IBeta(_x_,betaP,betaQ), /*CDF*/					0, 				   /*left bound*/					1, 			   /*right bound*/					IBeta(_x_,betaP+1,betaQ)*betaP/(betaP+betaQ)						/* "antiderivative" of x f(x) */				   );Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"8). Discretized beta with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);global mu = 3;global sigma  = .5;sigma:>0.0001;sqrt2pi = Sqrt(8*Arctan(1));category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					Exp((_x_-mu)(mu-_x_)/(2*sigma*sigma))/(sqrt2pi__*sigma)/ZCDF(mu/sigma), /* density */					(1-ZCDF((mu-_x_)/sigma))/ZCDF(mu/sigma), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					(mu*(1-ZCDF(-mu/sigma)-ZCDF((mu-_x_)/sigma))+				    sigma*(Exp(-mu*mu/(2*sigma*sigma))-				    Exp((_x_-mu)(mu-_x_)/(2*sigma*sigma)))/sqrt2pi__)/ZCDF(mu/sigma)						/* "antiderivative" of x f(x) */				   );Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"9). Discretized normal>0 with 8 rate classes.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);/* 6. An example of Hidden Markov Chain correlation */lambda:<1;lambda=.125;hiddenMarkovM = {8,8};hiddenMarkovF = {8,1};for (k=0; k<8; k=k+1){	hiddenMarkovM [k][k] := lambda+(1-lambda)/8;	hiddenMarkovF [k][1] := 1/8;		for (l=k+1;l<8;l=l+1)	{		hiddenMarkovM [k][l] := (1-lambda)/8;		hiddenMarkovM [l][k] := (1-lambda)/8;	}}Model HMM = (hiddenMarkovM,hiddenMarkovF,false);global alpha = .5;alpha:>0.01;alpha:<100;category catVar =  (8,		/* number of rates */					hiddenMarkovF,  /* probs. of rates */					MEAN,	/* sampling method */					GammaDist(_x_,alpha,alpha), /* density */					CGammaDist(_x_,alpha,alpha), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					CGammaDist(_x_,alpha+1,alpha),						/* "antiderivative" of x f(x) */					HMM /* Hidden Markov transition model */				   );UseModel (HKY85); /* otherwise HMM would be applied to the tree */Tree	givenTree = DATAFILE_TREE;LikelihoodFunction  theLnLik = (filteredData, givenTree);Optimize (result, theLnLik);fprintf (stdout,"10). Discretized gamma with 8 rate classes and \n\tspatial rate correlation via a HMM.\n\n",theLnLik);GetInformation (catInfo,catVar);catInfo = echoCatVar (catInfo);