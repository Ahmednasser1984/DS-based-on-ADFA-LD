function res=cleval(cp)
    accuracy=cp.CorrectRate*100;
    sensitivity=cp.Sensitivity*100;
    specificity=cp.Specificity*100;
    PPV=cp.PositivePredictiveValue*100;
    NPV=cp.NegativePredictiveValue*100;
    %# columns:actual, rows:predicted, last-row: unclassified instances
    cp.CountingMatrix;
    recallP = sensitivity;
    recallN = specificity;
    precisionP = PPV;
    precisionN = NPV;
    f1P = 2*((precisionP*recallP)/(precisionP + recallP));
    f1N = 2*((precisionN*recallN)/(precisionN + recallN));
    fscore = ((f1P+f1N)/2);
    res=[accuracy;sensitivity;specificity;fscore];