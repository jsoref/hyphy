/* This is an example HY-PHY Batch File.	In this file, we will illustrate how to define category	variables sampled from continuous distribution to model rate heterogeneity.	   Sergei L. Kosakovsky Pond and Spencer V. Muse    June 2001. *//* 1. We begin with a simple distribution:	it has 4 equiprobable rate classes		The first argument in defining a category variable is the number of rate classes.		The second argument defines the probability of each class. We set it to	EQUAL.		The third argument determines how the continuous distribution is sampled:		MEAN - weighted (conditional) mean over an interval		MEDIAN - median of the interval		SCALED_MEDIAN - medians of the intervals scaled so that the discretized		distribution has the same mean as the continous one.		The fourth argument is the density of the distribution that we are sampling;	Let us begin with the exponential random variable over [0,Inf].	Its density is 				f(_x_) = lambda Exp(-lambda _x_). 		It MUST be defined in terms of "_x_" (and  other parameters if applicable, e.g "lambda" here).	"_x_" is the variable of integration.		The fifth argument is the CDF of the distribution that we are sampling.	It can be left blank to suggest that HyPhy numerically integrate the density,	but should always be specified if known, because it will GREATLY improve the speed.	It must also be defined in terms of _x_ and specify P{X<=_x_}.	For the exponential random variable the CDF is:			F(_x_) = 1-Exp(-lamda _x_).		The sixth and seventh arguments are the bounds of the support of the distribution.	([0,1e25] in this case: 1e25 -or any other large number- is Inf). 	The seventh (optional) argument is only used if "MEAN" sampling is requested.	It is the formula which gives the intergal of x f(x) over the interval (-Inf, _x_].	It is used for computing conditional means. If this argument is not supplied, 	HyPhy will perform numerical integration (which is much slower than direct evaluation).		For the exponential random variable it is:		-_x_ Exp (-lambda _x_) + (1-Exp(-lambda _x_)/lambda*//* this will display the category info, along with sample mean and variance */#include "displayFunction.bf";global lambda = 2;category catVar =  (4,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );fprintf (stdout,"1). 4 equiprobable rates sampled from Exponential with lambda = 2\n");GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN:");catInfo = echoCatVar (catInfo);/* note that sample mean if 1/2 as expected, because it is the mean of exponential with lambda = 2,   sample variance if close to 1/4 which is what it is for the continuous case. If we increase the number   of classes, sample variance will approach 1/4 *//* now we try the sampling by median. Notice that the sample mean is no longer 1/2 */category catVar =  (4,		/* number of rates */					EQUAL,  /* probs. of rates */					MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEDIAN:");catInfo = echoCatVar (catInfo);/* now we try the sampling by scaled median. The sample mean is back to 1/2 */category catVar =  (4,		/* number of rates */					EQUAL,  /* probs. of rates */					SCALED_MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by SCALED_MEDIAN:");catInfo = echoCatVar (catInfo);/* Sample by MEAN again. Omit the last term to try numerical averaging.   Numerical averaging is VERY SLOW compared to direct evaluation, so  don't use unless you must! */category catVar =  (4,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (numerical averaging):");catInfo = echoCatVar (catInfo);/* Sample by MEAN again. Omit CDF AND the average to do both numerically.   This is by far the slowest method of sampling. Use it only if there   is absolutely no other choice! */category catVar =  (4,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					,                  /*skip CDF */					0, 				   /*left bound*/					1e25, 			   /*right bound*/				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (numerical CDF and averaging):");catInfo = echoCatVar (catInfo);/* 2. The only guaranteed way to "embed" models by increasing the numberof rate classes is to use MEDIAN sampling, and increase the numberof categories by a factor of 3. Note that in this exampleall rates sampled with 3 classes are also present in the 9 rate class sample */fprintf (stdout,"2). Equiprobable rates sampled from Exponential with lambda = 2\n");category catVar =  (3,		/* number of rates */					EQUAL,  /* probs. of rates */					MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEDIAN (3 rate classes):");catInfo = echoCatVar (catInfo);category catVar =  (9,		/* number of rates */					EQUAL,  /* probs. of rates */					MEDIAN,	/* sampling method */					lambda*Exp(-lambda*_x_), /* density */					1-Exp(-lambda*_x_), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					-_x_*Exp(-lambda*_x_) + (1-Exp(-lambda*_x_))/lambda 						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEDIAN (9 rate classes):");catInfo = echoCatVar (catInfo);/* 3. Sampling the Gamma distribution requires special functions.  */fprintf (stdout,"3). Equiprobable rates sampled from Gamma with mean 1, variance 1/10. \n");global alpha = 10;/* gamma distrubution develops very high derivatives for small or large alpha values, and they can't be sampled reliably - thus the bounds on alpha.*/alpha:>0.01;alpha:<100;category catVar =  (10,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					GammaDist(_x_,alpha,alpha), /* density */					CGammaDist(_x_,alpha,alpha), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					CGammaDist(_x_,alpha+1,alpha)						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (10 rate classes):");catInfo = echoCatVar (catInfo);/* 4. General Gamma distribution has mean alpha/beta, variance alpha/beta^2  */fprintf (stdout,"4). Equiprobable rates sampled from Gamma with mean 2, variance 1/25. \n");global alpha = 100;/* gamma distrubution develops very high derivatives for small or large alpha/beta values, and they can't be sampled reliably - thus the bounds on alpha.*/alpha:>0.01;alpha:<100;global beta =  50; beta:>0.01;beta:<100;category catVar =  (10,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					GammaDist(_x_,alpha,beta), /* density */					CGammaDist(_x_,alpha,beta), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					CGammaDist(_x_,alpha+1,beta)*alpha/beta						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (10 rate classes):");catInfo = echoCatVar (catInfo);/* 5. A sample from the beta distribution.	  Beta distributions has mean p/(p+q) and variance pq/[(p+q)^2(p+q+1)]  */fprintf (stdout,"5). Equiprobable rates sampled from Beta with mean 1/2 , variance 1/12. \n");/* beta distrubution develops very high derivatives for small or large P and Q values, and they can't be sampled reliably - thus the bounds on alpha.*/global betaP = 1;global betaQ = 1;betaP:>0.05;betaP:<100;betaQ:>0.05;betaQ:<100;category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					_x_^(betaP-1)*(1-_x_)^(betaQ-1)/Beta(betaP,betaQ), /* density */					IBeta(_x_,betaP,betaQ), /*CDF*/					0, 				   /*left bound*/					1, 			   /*right bound*/					IBeta(_x_,betaP+1,betaQ)*betaP/(betaP+betaQ)						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (8 rate classes):");catInfo = echoCatVar (catInfo);/* 6. A sample from the normal restricted to [0, Inf). ZCDF is the N(0,1) CDF.*/fprintf (stdout,"6). Equiprobable rates sampled from Normal(>0) with mean 3 , variance 1/4. \n");global mu = 3;global sigma  = .5;sigma:>0.0001;sqrt2pi = Sqrt(8*Arctan(1));category catVar =  (8,		/* number of rates */					EQUAL,  /* probs. of rates */					MEAN,	/* sampling method */					Exp((_x_-mu)(mu-_x_)/(2*sigma*sigma))/(sqrt2pi__*sigma)/ZCDF(mu/sigma), /* density */					(1-ZCDF((mu-_x_)/sigma))/ZCDF(mu/sigma), /*CDF*/					0, 				   /*left bound*/					1e25, 			   /*right bound*/					(mu*(1-ZCDF(-mu/sigma)-ZCDF((mu-_x_)/sigma))+				    sigma*(Exp(-mu*mu/(2*sigma*sigma))-				    Exp((_x_-mu)(mu-_x_)/(2*sigma*sigma)))/sqrt2pi__)/ZCDF(mu/sigma)						/* "antiderivative" of x f(x) */				   );				   GetInformation (catInfo,catVar);fprintf (stdout, "\nSample by MEAN (8 rate classes):");catInfo = echoCatVar (catInfo);