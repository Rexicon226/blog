p = 101
F = GF(p)

G = F(2)

# Let H = G^a where a is known (bad practice in real commitments)
a = 13
H = G^a

# Commit to x = 42, r = 7
x = 42
r = 7
C = G^x * H^r

print("G: ", G^x)
print("Original commitment C:", C)

# C can also be written as G^(x + a*r)
z = x + a * r
print("C = G^z where z =", z)

# Try forging a new opening (x', r') such that x' + a * r' = z
x_prime = 30
a_inv = inverse_mod(a, p - 1)
r_prime = (z - x_prime) * a_inv % (p - 1)

C_prime = G^x_prime * H^r_prime

print("Forged opening: x' =", x_prime, ", r' =", r_prime)
print("C' from forged opening:", C_prime)
print("Does the forged commitment match the original?", C_prime == C)