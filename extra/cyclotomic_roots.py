import numpy as np
import matplotlib.pyplot as plt

r = 12  # 12th roots of unity
angles = np.linspace(0, 2 * np.pi, r, endpoint=False)

fig, ax = plt.subplots(subplot_kw={'projection': 'polar'}, figsize=(6, 6))
ax.set_yticklabels([])
ax.set_xticks([])

ax.scatter(angles, np.ones(r), color='blue', s=80)

for i, angle in enumerate(angles):
    ax.text(angle, 1.1, f"$\\zeta^{{{i}}}$", ha='center', va='center', fontsize=10)

ax.set_title("12th Roots of Unity", fontsize=16)
plt.savefig("cyclotomic_roots.png")
