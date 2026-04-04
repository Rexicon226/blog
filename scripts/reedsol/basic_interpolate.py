import numpy as np
import matplotlib.pyplot as plt

# 4 data points, giving us a degree < 4 polynomial
x_data = np.array([0, 1, 2, 3])
y_data = np.array([1, 3, 2, 5])

# interpolate polynomial
coeffs = np.polyfit(x_data, y_data, deg=3)

x = np.linspace(0, 6, 200)
y = np.polyval(coeffs, x)

plt.scatter(x_data, y_data, label="Original data")
plt.plot(x, y, label="Interpolated polynomial")
plt.scatter([4, 5], np.polyval(coeffs, [4, 5]), label="Parity points")
plt.legend()
plt.title("Data -> Polynomial -> More Points (Parity)")
plt.savefig('graph.png')