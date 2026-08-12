# # Simple GF(256) with log/antilog tables

# PRIMITIVE = 0x11d

# exp = [0]*512
# log = [0]*256

# x = 1
# for i in range(255):
#     exp[i] = x
#     log[x] = i
#     x <<= 1
#     if x & 0x100:
#         x ^= PRIMITIVE

# for i in range(255, 512):
#     exp[i] = exp[i - 255]

# def gf_add(a, b):
#     return a ^ b

# def gf_mul(a, b):
#     if a == 0 or b == 0:
#         return 0
#     return exp[log[a] + log[b]]

# # visualize closure
# vals = [gf_add(i, j) for i in range(8) for j in range(8)]

# print("XOR table (partial):")
# for i in range(4):
#     print([gf_add(i, j) for j in range(4)])

# def poly_mul(a, b):
#     res = [0]*(len(a)+len(b)-1)
#     for i in range(len(a)):
#         for j in range(len(b)):
#             res[i+j] ^= gf_mul(a[i], b[j])
#     return res

# def poly_eval(poly, x):
#     res = 0
#     for coef in reversed(poly):
#         res = gf_mul(res, x) ^ coef
#     return res

# def subspace_poly(j):
#     poly = [1]  # constant 1
#     for x in range(2**j):
#         poly = poly_mul(poly, [x, 1])  # (x + root)
#     return poly

# for j in range(3):
#     s = subspace_poly(j)
#     vals = [poly_eval(s, x) for x in range(2**j)]
#     print(f"s_{j}(x) zeros:", vals)

def plot_butterfly(n):
    import matplotlib.pyplot as plt
    import numpy as np
    
    stages = int(np.log2(n))
    
    for stage in range(stages):
        stride = 2**stage
        for i in range(0, n, 2*stride):
            for j in range(stride):
                a = i + j
                b = a + stride
                plt.plot([stage, stage+1], [a, a], 'k-')
                plt.plot([stage, stage+1], [b, b], 'k-')
                plt.plot([stage, stage+1], [a, b], 'r--')
    
    plt.title("Butterfly Network")
    plt.xlabel("Stage")
    plt.ylabel("Index")
    plt.savefig('graph.png')

plot_butterfly(8)