import pygame
import random

# Initialize Pygame
pygame.init()

# Game settings
width, height = 640, 480
cell_size = 20
grid_width = width // cell_size
grid_height = height // cell_size
fps = 10

# Colors
black = (0, 0, 0)
white = (255, 255, 255)
red = (255, 0, 0)

# Direction
up = (0, -1)
down = (0, 1)
left = (-1, 0)
right = (1, 0)

# Snake class
class Snake:
    def __init__(self):
        self.body = [(grid_width // 2, grid_height // 2)]
        self.direction = random.choice([up, down, left, right])
        self.grow = False

    def update(self):
        current_head = self.body[0]
        x = (current_head[0] + self.direction[0]) % grid_width
        y = (current_head[1] + self.direction[1]) % grid_height
        new_head = (x, y)

        if new_head in self.body[1:]:
            game_over()

        self.body.insert(0, new_head)
        if not self.grow:
            self.body.pop()
        else:
            self.grow = False

    def change_direction(self, new_direction):
        if (new_direction[0] * -1, new_direction[1] * -1) != self.direction:
            self.direction = new_direction

    def grow_snake(self):
        self.grow = True

    def draw(self):
        for body_part in self.body:
            x = body_part[0] * cell_size
            y = body_part[1] * cell_size
            pygame.draw.rect(screen, white, (x, y, cell_size, cell_size))

# Food class
class Food:
    def __init__(self):
        self.position = self.generate_position()

    def generate_position(self):
        while True:
            x = random.randint(0, grid_width - 1)
            y = random.randint(0, grid_height - 1)
            position = (x, y)
            if position not in snake.body:
                return position

    def draw(self):
        x = self.position[0] * cell_size
        y = self.position[1] * cell_size
        pygame.draw.rect(screen, red, (x, y, cell_size, cell_size))

    def check_collision(self):
        if snake.body[0] == self.position:
            self.position = self.generate_position()
            snake.grow_snake()

# Game over function
def game_over():
    pygame.quit()
    quit()

# Initialize the game window
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Gluttonous Snake")
clock = pygame.time.Clock()

# Initialize the snake and food
snake = Snake()
food = Food()

# Game loop
while True:
    # Event handling
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            game_over()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                snake.change_direction(up)
            elif event.key == pygame.K_DOWN:
                snake.change_direction(down)
            elif event.key == pygame.K_LEFT:
                snake.change_direction(left)
            elif event.key == pygame.K_RIGHT:
                snake.change_direction(right)

    # Update snake and food
    snake.update()
    food.check_collision()

    # Drawing
    screen.fill(black)
    snake.draw()
    food.draw()
    pygame.display.flip()

    # Delay to control the game's speed
    clock.tick(fps)
