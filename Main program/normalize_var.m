function normalized = normalize_var(A)

     normA = A - min(A(:))
normalized = normA ./ max(normA(:));