import random

@fieldwise_init
struct Grid(Copyable, Stringable):
    var rows: Int
    var cols: Int
    var data: List[List[Int]]

    fn __str__(self) -> String:
        # Create an empty String
        str = String()

        # Iterate through rows 0 to rows-1
        for row in range(self.rows):
            # Iterate through columns 0 to cols-1
            for col in range(self.cols):
                if self[row, col] == 1:
                    str += "*"  # If cell is populated, append an asterisk
                else:
                    str += " "  # If cell is not populated, append a space
            if row != self.rows - 1:
                str += "\n"  # Add a newline between rows, but not at the end
        return str

    fn __getitem__(self, row: Int, col: Int) -> Int:
        return self.data[row][col]

    fn __setitem__(mut self, row: Int, col: Int, value: Int) -> None:
        self.data[row][col] = value

    @staticmethod
    fn random(rows: Int, cols: Int) -> Self:
        # Seed the random number generator using the current time.
        random.seed()

        var data: List[List[Int]] = []

        for _ in range(rows):
            var row_data: List[Int] = []
            for _ in range(cols):
                # Generate a random 0 or 1 and append it to the row.
                row_data.append(Int(random.random_si64(0, 1)))
            data.append(row_data^)

        return Self(rows, cols, data^)
