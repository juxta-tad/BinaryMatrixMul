package main

import "core:fmt"
import "core:math"

SIZE :: 8


print_matrix :: proc(matx: [SIZE][SIZE]int) {
	for row in matx {
		for elem in row {
			fmt.printf("%d ", elem)
		}
		fmt.println()
	}
	fmt.println()
}

multiply_matrices :: proc(mat1, mat2, result: ^[SIZE][SIZE]int) {
	for i in 0 ..< SIZE {
		for j in 0 ..< SIZE {
			result[i][j] = 0
			for k in 0 ..< SIZE {
				result[i][j] |= mat1[i][k] & mat2[k][j]
			}
		}
	}
}

flattenMatrix :: proc(matx: [SIZE][SIZE]int) -> u64 {
	flat: u64
	for i in 0 ..< SIZE {
		for j in 0 ..< SIZE {
			i := u32(i)
			j := u32(j)
			// Set the bit at position (i * 8 + j) to the value of matrix[i][j]
			if matx[i][j] == 1 {
				flat |= (1 << ((7 - i) * 8 + (7 - j)))
			}
		}
	}
	return flat
}

unflattenMatrix :: proc(flat: u64) -> [SIZE][SIZE]int {
	matx: [SIZE][SIZE]int

	for i in 0 ..< SIZE {
		for j in 0 ..< SIZE {
			i := u32(i)
			j := u32(j)
			// Extract the bit at position (i * 8 + j)
			bitPos := ((7 - i) * 8 + (7 - j))
			if (flat & (1 << bitPos)) != 0 {
				matx[i][j] = 1
			} else {
				matx[i][j] = 0
			}
		}
	}

	return matx
}


printBinaryGrid :: proc(n: u64) {

	binaryStr := fmt.tprintf("%064b", n)
	for i in 0 ..< SIZE {
		for j in 0 ..< SIZE {

			fmt.printf("%c ", binaryStr[i * 8 + j])
		}
		fmt.println()
	}
	fmt.println()
}

reverseBits :: proc(n: u64) -> u64 {
	n := n
	newN: u64 = 0
	for i in 0 ..< size_of(u64) * 8 {
		i := u64(i)
		newN = newN << 1
		if ((n & 1) > 0) {
			newN = newN ~ 1
		}
		n = n >> 1
	}
	return newN
}


bit_matrix_multiply :: proc(a, b: u64) -> u64 {
    ROWMASK :: u64(0xFF) 
    COLMASK :: u64(0x0101010101010101)

    row0: u8 = u8(b & ROWMASK)
    row1: u8 = u8((b >> 8) & ROWMASK)
    row2: u8 = u8((b >> 16) & ROWMASK)
    row3: u8 = u8((b >> 24) & ROWMASK)
    row4: u8 = u8((b >> 32) & ROWMASK)
    row5: u8 = u8((b >> 40) & ROWMASK)
    row6: u8 = u8((b >> 48) & ROWMASK)
    row7: u8 = u8((b >> 56) & ROWMASK)

    return u64(
        ((a & COLMASK) * u64(row0)) ~
        (((a >> 1) & COLMASK) * u64(row1)) ~
        (((a >> 2) & COLMASK) * u64(row2)) ~
        (((a >> 3) & COLMASK) * u64(row3)) ~
        (((a >> 4) & COLMASK) * u64(row4)) ~
        (((a >> 5) & COLMASK) * u64(row5)) ~
        (((a >> 6) & COLMASK) * u64(row6)) ~
        (((a >> 7) & COLMASK) * u64(row7))
    )
}

main :: proc() {

	fmt.println("Matrix 1:")
	mat1 := [SIZE][SIZE]int {
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 0, 1, 0, 0, 0},
		{1, 1, 0, 1, 0, 0, 0, 1},
	}
	print_matrix(mat1)


	flat1 := flattenMatrix(mat1)
	print_matrix(unflattenMatrix(flat1))

	fmt.println(flat1)

	fmt.println("Matrix 2:")
	mat2 := [SIZE][SIZE]int {
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 1, 0},
		{0, 1, 0, 0, 1, 1, 1, 1},
	}
	print_matrix(mat2)

	flat2 := flattenMatrix(mat2)
	fmt.println(flat2)


	result: [SIZE][SIZE]int
	multiply_matrices(&mat1, &mat2, &result)

	fmt.println("Result of Matrix Multiplication:")
	print_matrix(result)

	r := flattenMatrix(result)
	fmt.println(r)
	fmt.println(8 &~ (flat1 & flat2))


	for i in 255 ..< 255 + 10 {
		for j in 255 ..< 255 + 10 {
			i := u64(i)
			j := u64(j)

			x := unflattenMatrix(i)
			y := unflattenMatrix(j)

			resulte: [SIZE][SIZE]int
			multiply_matrices(&x, &y, &resulte)
			fmt.println(i, j, "=", flattenMatrix(resulte))
			fmt.println(bit_matrix_multiply(i, j))
			//fmt.println(reverseBits(bit_matrix_multiply(i, j)))
		}
	}
	//fmt.println(flattenMatrix(mat1)  flattenMatrix(mat2))
}
