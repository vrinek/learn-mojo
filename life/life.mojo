import time

from gridv1 import Grid
from python import Python

def run_display(
    var grid: Grid,
    window_height: Int = 1000,
    window_width: Int = 1000,
    background_color: String = "black",
    cell_color: String = "green",
    pause: Float64 = 0.1,
) -> None:
    # Import the pygame Python package
    pygame = Python.import_module("pygame")

    # Initialize pygame modules
    pygame.init()

    # Create a window and set its title
    window = pygame.display.set_mode(Python.tuple(window_width, window_height))
    pygame.display.set_caption("Conway's Game of Life")

    cell_height = window_height / grid.rows
    cell_width = window_width / grid.cols
    border_size = 1
    cell_fill_color = pygame.Color(cell_color)
    background_fill_color = pygame.Color(background_color)

    running = True
    while running:
        # Poll for events
        event = pygame.event.poll()
        if event.type == pygame.QUIT:
            # Quit if the window is closed
            print("Quiting...")
            running = False

        # Clear the window by painting with the background color
        window.fill(background_fill_color)

        # Draw each live cell in the grid
        for row in range(grid.rows):
            for col in range(grid.cols):
                if grid[row, col]:
                    x = col * cell_width + border_size
                    y = row * cell_width + border_size
                    width = cell_width - border_size
                    height = cell_height - border_size

                    pygame.draw.rect(
                        window,
                        cell_fill_color,
                        Python.tuple(x, y, width, height)
                    )

        # Update the display
        pygame.display.flip()

        # Pause to let the user appreciate the scene
        time.sleep(pause)

        # Next generation
        grid = grid.evolve()

    # Shut down pygame cleanly
    pygame.quit()

def main():
    start = Grid.random(128, 128)
    run_display(start^)
