
1. Introduction

    a. Modular Arithmetics

        i. Why zero is exluded from multiplicative groups
        ii. Importance of prime moduli for security

    b. Cyclic groups

        i. group exponentiation as a one way function
        ii. elliptic curve groups vs prime field multiplicative groups

    c. Discrete Log Problem

        i. why it's hard (no PLT alg)
        ii. what kind of groups make DLP hard vs easy (small subgroup attacks or weak curves)
        iii. explain ecc DLP?

2. Pedersen Commitments

    a. What is a commitment
        
        i. commitments should be binding and hiding
        ii. real world example? locking a value in a safe

    b. Run through the formulas

        i. explain why we need two generators and that the discrete log between them
            must not be known
        ii. show additive homomorphism

    c. Show that it is secure via DLP
    
        i. binding relies on difficulty of finding two openings for same commitment
        ii. hiding relies on randomness, information theoretic hiding

3. ElGamal Encryption

    a. run through encryption + decryption steps

    b. What is twisted elgamal 

        i. compare between regular elgamal and twisted
        ii. explain reason for twist (decouple encryption from message group elements)

    c. twisted elgamal supports homomorphic addition over encrypted messages

4. Why this matters
    
    a. zkp (bullet proofs use pedersen commitments)
    
    b. confidential transactions in blockchains (monero, zcash)

    c. voting, multi-party computation, identity protocols