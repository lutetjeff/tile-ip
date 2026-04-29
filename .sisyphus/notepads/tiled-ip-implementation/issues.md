
## NumPy 2.x int8 Overflow Fixes (2026-04-27)

### Problem
NumPy 2.x changed behavior where `np.int8(x)` with `x > 127` raises `OverflowError` (currently a `DeprecationWarning` in NumPy 1.26). Two test files were affected.

### Fixes Applied

#### tests/test_activation.py — `_unpack_bytes`
**Before:**
```python
[np.int8((value >> (i * 8)) & 0xFF) for i in range(T_width)]
```
**After:**
```python
np.array(
    [(value >> (i * 8)) & 0xFF for i in range(T_width)],
    dtype=np.uint8,
).astype(np.int8)
```
- First creates a `uint8` array (which accepts values 0-255 without overflow), then casts to `int8` (which correctly wraps, e.g., 128 -> -128).

#### tests/test_mem_router.py — `mem_map` creation
**Before:**
```python
mem_map = {i: int(data[i] & 0xFF) for i in range(rows * cols)}
```
**After:**
```python
mem_map = {i: int(np.uint8(data[i])) for i in range(rows * cols)}
```
- `np.uint8(data[i])` safely converts a negative `int8` scalar to its unsigned byte representation before passing to `int()`.

### Verification
- All 34 tests in both files pass.
- No `DeprecationWarning` emitted even when running with `-W error::DeprecationWarning`.
