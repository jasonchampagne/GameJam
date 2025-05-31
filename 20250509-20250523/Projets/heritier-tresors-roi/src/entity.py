import pygame
from animate import AnimateSprite


class Entity(AnimateSprite):
    def __init__(self, name, x, y):
        super().__init__(name)
        
        self.image = self.get_image(0,0)
        self.image.set_colorkey([0,0,0]) # gérer la transparence
        self.rect = self.image.get_rect()
        self.position = [x,y]
        self.feet = pygame.Rect(0,0, self.rect.width*0.5, 10)
        self.old_position = self.position.copy()
        

    def save_location(self):
        self.old_position = self.position.copy()

    
    def move(self, input):
        if input == 'right':
            self.position[0] += self.speed
        elif input == 'left':
            self.position[0] -= self.speed
        elif input == 'up':
            self.position[1] -= self.speed
        elif input == 'down':
            self.position[1] += self.speed
        else:
            pass

    def move_back(self):
        self.position = self.old_position
        self.update()

    def update(self):
        self.rect.topleft = self.position
        self.feet.midbottom = self.rect.midbottom


 
class Player(Entity):
    def __init__(self, x, y):
        super().__init__('player', x, y)

