LoadFunctionLibrary ("GrabBag");
LoadFunctionLibrary ("terms.bf");

function parameters.applyNameSpace (id, namespace) {
	if (Type (namespace) == "String") {
		if (Abs (namespace) > 0) {
			return namespace + "." + id;
		}
	}
	return id;
}

function parameters.declareGlobal (id, cache) {
    if (Type (id) == "String") {
        if (Abs (id)) {
            if (Type (cache) == "AssociativeList") {
                if (Abs (cache[id]) == 0) {
                    return;
                }
            }
            ExecuteCommands ("global `id` = 1;");
        }
    } else {
        if (Type (id) == "AssociativeList") {
            parameters.declareGlobal.var_count = Abs (id);
            for (parameters.declareGlobal.k = 0; parameters.declareGlobal.k <  parameters.declareGlobal.var_count; parameters.declareGlobal.k += 1) {
                parameters.declareGlobal (id[parameters.declareGlobal.k], cache);
            }            
        }
    }
}


function parameters.quote (arg) {
	return "\"" + arg + "\"";
}

function parameters.addMultiplicativeTerm (matrix, term) {
	
	if (Abs (term) > 0) {
		__N = Rows (matrix);
	
		for (__r = 0; __r < __N; __r+=1) {
			for (__c = 0; __c < __N; __c+=1) {
				if (__r != __c) {
					if (Abs (matrix[__r][__c])) {
						matrix[__r][__c] += "*" + term;
					} else {
						matrix[__r][__c] =  term;
					}
				}
			}
		}
	}
	
	return matrix;
}

function parameters.stringMatrixToFormulas (id, matrix) {
	__N = Rows (matrix);
	
	ExecuteCommands ("`id` = {__N,__N}");
	
	for (__r = 0; __r < __N; __r+=1) {
		for (__c = 0; __c < __N; __c+=1) {
		
			if (__r != __c && Abs (matrix[__r][__c])) {
				ExecuteCommands ("`id`[__r][__c] := " + matrix[__r][__c]);
			}
		}
	}
	
}

function parameters.generate_attributed_names (prefix, attributes, delimiter) {
    if (delimiter == None) {
        delimiter = "_";
    }
    parameters.generate_names.holder = {};
    for (parameters.generate_names.k = 0; parameters.generate_names.k < Columns (attributes); parameters.generate_names.k += 1) {
        parameters.generate_names.holder + (prefix + delimiter + attributes[parameters.generate_names.k]);
    }   
    return parameters.generate_names.holder;
}

function parameters.generate_sequential_names (prefix, count, delimiter) {
    if (delimiter == None) {
        delimiter = "_";
    }
    parameters.generate_names.holder = {};
    for (parameters.generate_names.k = 0; parameters.generate_names.k < count; parameters.generate_names.k += 1) {
        parameters.generate_names.holder + (prefix + delimiter + parameters.generate_names.k);
    }   
    return parameters.generate_names.holder;
}

function parameters.setRange (id, ranges) {
    if (Type (id) == "String") {
        if (Abs (id)) {
            if (Type (ranges) == "AssociativeList") {
                if (Abs (ranges[terms.lower_bound])) {
                    ExecuteCommands ("`id` :> " + ranges[terms.lower_bound]);
                } 
                if (Abs (ranges[terms.upper_bound])) {
                    ExecuteCommands ("`id` :< " + ranges[terms.upper_bound]);
                } 
            }
        }
    } else {
        if (Type (id) == "AssociativeList") {
            parameters.setRange.var_count = Abs (id);
            for (parameters.setRange.k = 0; parameters.setRange.k <  parameters.setRange.var_count; parameters.setRange.k += 1) {
                parameters.setRange (id[parameters.setRange.k], ranges);
            }
        }
    }
}

function parameters.setConstraint (id, value, global_tag) {
    if (Type (id) == "String") {
        if (Abs (id)) {
            ExecuteCommands ("`global_tag` `id` := " + value);
        }
    } else {
        if (Type (id) == "AssociativeList" && Type (value) == "AssociativeList") {                

            parameters.setConstraint.var_count = Abs (id);
            for (parameters.setConstraint.k = 0; parameters.setConstraint.k <  parameters.setConstraint.var_count; parameters.setConstraint.k += 1) {
                parameters.setConstraint (id[parameters.setConstraint.k], 
                                          value[parameters.setConstraint.k], 
                                          global_tag);
            }            
        }
    }
}


lfunction parameters.helper.stick_breaking (parameters, initial_values) {
    left_over   = ""; 
    weights     = {};
    accumulator = 1;
    
    
    for (k = 0; k < Abs (parameters); k += 1) {
        if (None != initial_values) {
            vid = parameters[k];
            ^(vid) = initial_values[k] / accumulator;
            accumulator = accumulator * (1-^(vid));
        }
        weights [k] = left_over + parameters[k];
        left_over += "(1-" + parameters[k] + ")*";
     }
    
    weights[k] = left_over[0][Abs (left_over)-2];
    return weights;
}
